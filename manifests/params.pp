################################################################################
# Time-stamp: <Thu 2017-10-05 13:02 svarrette>
#
# File::      <tt>params.pp</tt>
# Author::    Tom De Vylder, Sebastien Varrette
# Copyright:: Copyright (c) 2015-2017 arioch,Falkor
# License::   Apache-2.0
#
# ------------------------------------------------------------------------------
# == Class: ulimit::params
#
# In this class are defined as default variables values that are used in all
# other ulimit classes and definitions.
# This class should be included, where necessary, and eventually be enhanced
# with support for more Operating Systems.
#
#
class ulimit::params {
  #### MODULE INTERNAL VARIABLES  #########
  # (Modify to adapt to unsupported OSes)
  #########################################

  $config_dir   = '/etc/security/limits.d'
  $config_group = 'root'
  $config_user  = 'root'
  $priority     = 80
  $purge        = true

  # apply default ulimits for OS if found
  $use_default_ulimits = true

  # ulimit defaults
  case $facts['os']['name'] {
    'RedHat','CentOS','Scientific','Rocky','AlmaLinux': {
      if $facts['os']['release']['major'] == '7' {
        # pam package on EL7 creates 20-nproc.conf
        $default_ulimits = {
          'nproc_user_defaults' => {
            'priority'          => 20,
            'ulimit_domain'     => '*',
            'ulimit_item'       => 'nproc',
            'ulimit_type'       => 'soft',
            'ulimit_value'      => '4096',
          },
          'nproc_root_defaults' => {
            'priority'          => 20,
            'ulimit_domain'     => 'root',
            'ulimit_item'       => 'nproc',
            'ulimit_type'       => 'soft',
            'ulimit_value'      => 'unlimited',
          },
        }
      } elsif $facts['os']['release']['major'] == '8' {
        $default_ulimits = {
          'nproc_user_defaults' => {
            'priority'          => 20,
            'ulimit_domain'     => '*',
            'ulimit_item'       => 'nproc',
            'ulimit_type'       => 'soft',
            'ulimit_value'      => '31547',
          },
          'nproc_root_defaults' => {
            'priority'        => 20,
            'ulimit_domain'   => 'root',
            'ulimit_item'     => 'nproc',
            'ulimit_type'     => 'soft',
            'ulimit_value'    => 'unlimited',
          },
        }
      } elsif $facts['os']['release']['major'] == '9' {
        $default_ulimits = {
          'nproc_user_defaults' => {
            'priority'          => 20,
            'ulimit_domain'     => '*',
            'ulimit_item'       => 'nproc',
            'ulimit_type'       => 'soft',
            'ulimit_value'      => '31547',
          },
          'nproc_root_defaults' => {
            'priority'        => 20,
            'ulimit_domain'   => 'root',
            'ulimit_item'     => 'nproc',
            'ulimit_type'     => 'soft',
            'ulimit_value'    => 'unlimited',
          },
        }
      } else {
        # if some other release then don't risk destroying default config
        fail("Unsupported operating system major release: ${facts['os']['release']['major']}")
      }
    } default: {
      $default_ulimits = {}
    }
  }
}
