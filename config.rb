require 'extensions/views'
require 'rack/rewrite'

activate :blog do |blog|
  blog.name = :manuals
  blog.prefix = "metodicheskoe-posobie"
  blog.permalink = "{title}"
  blog.taglink = "tags/{tag}.html"
  blog.tag_template = "metodicheskoe-posobie/tags/tag.html"
  blog.layout = "posts"
  blog.summary_length = 200
end

activate :blog do |blog|
  blog.name = :softwares
  blog.prefix = "programmy"
  blog.permalink = "{title}"
  blog.taglink = "tags/{tag}.html"
  blog.tag_template = "programmy/tags/tag.html"
  blog.layout = "posts"
  blog.summary_length = 200
end

activate :views
activate :directory_indexes

set :relative_links, true
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :fonts_dir, 'assets/fonts'

configure :development do
 activate :livereload
end

use Rack::Rewrite do
  r301 %r{/softwares/}, '/programmy$1'
  r301 %r{/softwares(.*)\.html}, '/programmy'
  r301 %r{/manuals/}, '/metodicheskoe-posobie'
  r301 %r{/manuals(.*)\.html}, '/metodicheskoe-posobie$1'
end

configure :build do
  # Relative assets needed to deploy to Github Pages
  activate :relative_assets
end

activate :deploy do |deploy|
  deploy.branch = :master
  deploy.build_before = true
  deploy.method = :git
end

helpers do
  def nav_link(link_text, page_url, options = {})
    options[:class] ||= ""
    if current_page.url.length > 1
      current_url = current_page.url.chop
    else
      current_url = current_page.url
    end
    options[:class] << " active" if page_url == current_url
    link_to(link_text, page_url, options)
  end

  def content_type(link)
    link.split('/').last.split('.').last
  end
end
