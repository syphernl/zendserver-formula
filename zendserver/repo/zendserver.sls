{%- from "zendserver/map.jinja" import zendserver with context %}
{%- set zend_version = salt['pillar.get']('zendserver:version:zend', '') %}
{%- set apache_version = salt['pillar.get']('zendserver:version:apache') %}
{%- set webserver = salt['pillar.get']('zendserver:webserver') %}

# Install ZendServer repository
zendserver_repo:
  pkgrepo.managed:
    - humanname: ZendServer PPA
    {% if (webserver == 'apache' and apache_version == '2.4') or zend_version|float() >= 9.0 %}
    - name: deb http://repos.zend.com/zend-server/{{zend_version}}/deb_apache2.4 server non-free
    {% else %}
    - name: deb http://repos.zend.com/zend-server/{{zend_version}}/deb_ssl1.0 server non-free
    {% endif %}
    - file: /etc/apt/sources.list.d/zendserver.list
    - key_url: http://repos.zend.com/zend.key
    - refresh: True
    - require_in:
      - pkg: zendserver
