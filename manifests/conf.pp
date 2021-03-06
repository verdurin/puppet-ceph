# Creates the ceph configuration file
#
# == Parameters
# [*fsid*] The cluster's fsid.
#   Mandatory. Get one with `uuidgen -r`.
#
# [*auth_type*] Auth type.
#   Optional. undef or 'cephx'. Defaults to 'cephx'.
#
# == Dependencies
#
# none
#
# == Authors
#
#  François Charlier francois.charlier@enovance.com
#  Sébastien Han     sebastien.han@enovance.com
#
# == Copyright
#
# Copyright 2012 eNovance <licensing@enovance.com>
#
class ceph::conf (
  $fsid,
  $auth_type                 = 'cephx',
  $cluster_network           = undef,
  $public_network            = undef,
  $mon_data                  = '/var/lib/ceph/mon/mon.$id',
  $osd_data                  = '/var/lib/ceph/osd/osd.$id',
  $mds_data                  = '/var/lib/ceph/mds/mds.$id',
  $mon_osd_down_out_interval = undef,
  $osd_pool_default_size     = undef,
  $osd_crush_location        = undef,
) {

  include 'ceph::package'

  concat { '/etc/ceph/ceph.conf':
    owner   => 'root',
    group   => 0,
    mode    => '0664',
    require => Package['ceph'],
  }

  Concat::Fragment <<| tag == "${fsid}-ceph.conf" |>>

  concat::fragment { 'ceph.conf':
    tag     => "${fsid}-ceph.conf",
    target  => '/etc/ceph/ceph.conf',
    order   => '01',
    content => template('ceph/ceph.conf.erb'),
  }

}
