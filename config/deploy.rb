require 'bundler/capistrano'

set :application, "copycopter-server"
set :repository,  "git@github.com:usertesting/copycopter-server.git"
set :rake, "bundle exec rake --trace"
set :scm, :git
set :deploy_via, :remote_cache
set :use_sudo, false

ssh_options[:forward_agent] = true

set :bundle_bin, "/usr/bin/bundle"

role :web, "copycopter.int.usertesting.com"                          # Your HTTP server, Apache/etc
role :app, "copycopter.int.usertesting.com"                          # This may be the same as your `Web` server
role :db,  "copycopter.int.usertesting.com", :primary => true # This is where Rails migrations will run
set :rails_env, "production"
set :branch, "master" unless exists?(:branch)
# XXX: rename to www. once the blog is renamed
set :deploy_to, '/var/www/copycopter.int.usertesting.com'
set :user, 'deploy'

namespace :config do
  task :setup do
    %w(database.yml).each do |file|
      run "cp #{release_path}/config/#{file}.sample #{shared_path}/#{file}"
      run "cd #{release_path}/config; ln -nfs #{shared_path}/#{file}"
    end
  end
end

after 'deploy:update_code', 'config:setup'

