From: James.Smart@Emulex.Com
Subject: [PATCH 0/3]  FC Transport updates (and dependencies)
Date: Tue, 11 Jan 2005 11:35:35 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F2E5@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:11245 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262835AbVAKQfi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 11:35:38 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j0BGZani009828
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jan 2005 08:35:36 -0800 (PST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Please apply the following patches:

Patch 1:
  This patch deprecates the use of device_for_each_child() with stargets.
  The reasoning behind this is due to issues regarding:
     Semaphores that device_for_each_child() takes
     Implicit assumptions that each child is an sdev device.

  The patch adds a new helper function, starget_for_each_device(), and
  replaces all previous uses of device_for_each_child().

  This patch has been previously posted, but has yet to be included:
    http://marc.theaimsgroup.com/?|=linux-scsi&m=110271680801710&w=2


Patch 2:
  This patch adds 5 more FC transport host attributes in support of HBAAPI. 

  This patch completes all the necessary sysfs attributes in support of
  HBAAPI for HBA Attributes, Statistics, and Port Attributes.
  

Patch 3:
  This patch adds support for FC Remote Ports (which may or may not
  be FCP targets) to the fc transport. The attributes for the ports are
  in support of HBAAPI. This patch also implements consistent scsi target
  id bindings for the remote ports.

  This patch completes all the necessary sysfs attributes in support of
  HBAAPI for Remote FC_Port attributes.

  This patch (minus some small changes) was previously posted as an RFC:
    http://marc.theaimsgroup.com/?|=linux-scsi&m=110187926413504&w=2


With these patches, the FC Transport is on the verge of supporting a
vendor-neutral HBAAPI version 1 library. The only functions missing are
2 host-level sysfs functions to perform CT Passthru and RNID management.
A proposal for these will be forthcoming.  The above patches are valid
for an HBAAPI version 2 library as well, with the missing functionality
being additional host-level service functions as well. However, version 2
includes many functions to manipulate Target and Persistent Bindings,
which will not be supported as it is contrary to the long-term design of
the SCSI subsystem.

-- James Smart



Below is an example of the resulting /sys/class layouts:


   <<< For the local FC Port / SCSI Host >>

[root@grumpy /]# cd /sys/class/fc_host

[root@grumpy fc_host]# ls -ld *
drwxr-xr-x  3 root root 0 Jan 10 15:55 host5
drwxr-xr-x  3 root root 0 Jan 10 15:55 host6
drwxr-xr-x  3 root root 0 Jan 10 16:07 host7

[root@grumpy fc_host cd /sys/class/fc_host

[root@grumpy host7]# ls -ld *
-r--r--r--  1 root root 4096 Jan 10 15:56 active_fc4s
lrwxrwxrwx  1 root root    0 Jan 10 15:56 device -> ../../../devices/pci0000:01/0000:01:04.1/host7
-r--r--r--  1 root root 4096 Jan 10 15:56 fabric_name
-r--r--r--  1 root root 4096 Jan 10 15:56 maxframe_size
-r--r--r--  1 root root 4096 Jan 10 15:56 node_name
-r--r--r--  1 root root 4096 Jan 10 15:56 port_id
-r--r--r--  1 root root 4096 Jan 10 15:56 port_name
-r--r--r--  1 root root 4096 Jan 10 15:56 port_state
-r--r--r--  1 root root 4096 Jan 10 15:56 port_type
lrwxrwxrwx  1 root root    0 Jan 10 16:07 rport-7:0-0 -> ../../../class/fc_remote_ports/rport-7:0-0
lrwxrwxrwx  1 root root    0 Jan 10 16:07 rport-7:0-1 -> ../../../class/fc_remote_ports/rport-7:0-1
lrwxrwxrwx  1 root root    0 Jan 10 16:07 rport-7:0-2 -> ../../../class/fc_remote_ports/rport-7:0-2
lrwxrwxrwx  1 root root    0 Jan 10 16:07 rport-7:0-3 -> ../../../class/fc_remote_ports/rport-7:0-3
lrwxrwxrwx  1 root root    0 Jan 10 16:07 rport-7:0-4 -> ../../../class/fc_remote_ports/rport-7:0-4
-r--r--r--  1 root root 4096 Jan 10 15:56 speed
drwxr-xr-x  2 root root    0 Jan 10 15:56 statistics
-r--r--r--  1 root root 4096 Jan 10 15:56 supported_classes
-r--r--r--  1 root root 4096 Jan 10 15:56 supported_fc4s
-r--r--r--  1 root root 4096 Jan 10 15:56 supported_speeds
-r--r--r--  1 root root 4096 Jan 10 15:56 symbolic_name
-rw-r--r--  1 root root 4096 Jan 10 15:56 tgtid_bind_type

[root@grumpy host7]# ls -ld statistics:
-r--r--r--  1 root root 4096 Jan 10 15:56 dumped_frames
-r--r--r--  1 root root 4096 Jan 10 15:56 error_frames
-r--r--r--  1 root root 4096 Jan 10 15:56 fcp_control_requests
-r--r--r--  1 root root 4096 Jan 10 15:56 fcp_input_megabytes
-r--r--r--  1 root root 4096 Jan 10 15:56 fcp_input_requests
-r--r--r--  1 root root 4096 Jan 10 15:56 fcp_output_megabytes
-r--r--r--  1 root root 4096 Jan 10 15:56 fcp_output_requests
-r--r--r--  1 root root 4096 Jan 10 15:56 invalid_crc_count
-r--r--r--  1 root root 4096 Jan 10 15:56 invalid_tx_word_count
-r--r--r--  1 root root 4096 Jan 10 15:56 link_failure_count
-r--r--r--  1 root root 4096 Jan 10 15:56 lip_count
-r--r--r--  1 root root 4096 Jan 10 15:56 loss_of_signal_count
-r--r--r--  1 root root 4096 Jan 10 15:56 loss_of_sync_count
-r--r--r--  1 root root 4096 Jan 10 15:56 nos_count
-r--r--r--  1 root root 4096 Jan 10 15:56 prim_seq_protocol_err_count
--w-------  1 root root 4096 Jan 10 15:56 reset_statistics
-r--r--r--  1 root root 4096 Jan 10 15:56 rx_frames
-r--r--r--  1 root root 4096 Jan 10 15:56 rx_words
-r--r--r--  1 root root 4096 Jan 10 15:56 seconds_since_last_reset
-r--r--r--  1 root root 4096 Jan 10 15:56 tx_frames
-r--r--r--  1 root root 4096 Jan 10 15:56 tx_words

[root@grumpy host7]# cat /tmp/showvars
#!/bin/sh
for file in $* ; do
  if [ -f $file ] ; then
    echo "$file:	"`cat $file`
  fi
done

[root@grumpy host7]# /tmp/showvars *
active_fc4s:	0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
fabric_name:	0x1000006069519369
maxframe_size:	2048 bytes
node_name:	0x20000000c9365ac7
port_id:	0x010400
port_name:	0x10000000c9365ac7
port_state:	Online
port_type:	NPort (fabric via point-to-point)
speed:	2 Gbit
supported_classes:	Class 3
supported_fc4s:	0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
supported_speeds:	1 Gbit, 2 Gbit
symbolic_name:	Emulex LP10000 FV1.90A4 DV8.0.20
tgtid_bind_type:	wwpn (World Wide Port Name)

[root@grumpy host7]# cd statistics

[root@grumpy statistics]# /tmp/showvars *
dumped_frames:	0xffffffffffffffff
error_frames:	0x0
fcp_control_requests:	0x0
fcp_input_megabytes:	0x0
fcp_input_requests:	0x0
fcp_output_megabytes:	0x0
fcp_output_requests:	0x0
invalid_crc_count:	0x0
invalid_tx_word_count:	0x1c
link_failure_count:	0x0
lip_count:	0xffffffffffffffff
loss_of_signal_count:	0x1
loss_of_sync_count:	0xe
nos_count:	0x0
prim_seq_protocol_err_count:	0x0
cat: reset_statistics: Permission denied
reset_statistics:	
rx_frames:	0x1d0
rx_words:	0x2b100
seconds_since_last_reset:	0x0
tx_frames:	0x51b
tx_words:	0x5100





   <<< For the SCSI Targets connected to the above FC Host >>

[root@grumpy /]# cd /sys/class/fc_transport

[root@grumpy fc_transport]# ls -ld *
drwxr-xr-x  2 root root 0 Jan 10 15:56 target7:0:0
drwxr-xr-x  2 root root 0 Jan 10 15:56 target7:0:1
drwxr-xr-x  2 root root 0 Jan 10 15:56 target7:0:2

[root@grumpy fc_transport]# cd target7:0:0

[root@grumpy target7:0:0]# ls -ld *
lrwxrwxrwx  1 root root    0 Jan 10 15:56 device -> ../../../devices/pci0000:01/0000:01:04.1/host7/target7:0:0
-rw-r--r--  1 root root 4096 Jan 10 15:56 dev_loss_tmo
-r--r--r--  1 root root 4096 Jan 10 15:56 node_name
-r--r--r--  1 root root 4096 Jan 10 15:56 port_id
-r--r--r--  1 root root 4096 Jan 10 15:56 port_name

[root@grumpy target7:0:0]# cd ..

[root@grumpy fc_transport]# /tmp/showvars */*
target7:0:0/dev_loss_tmo:	35
target7:0:0/node_name:	0x2000000c5005d6e4
target7:0:0/port_id:	0x010fe1
target7:0:0/port_name:	0x2200000c5005d6e4
target7:0:1/dev_loss_tmo:	35
target7:0:1/node_name:	0x2000000c5005df9d
target7:0:1/port_id:	0x010ed6
target7:0:1/port_name:	0x2200000c5005df9d
target7:0:2/dev_loss_tmo:	35
target7:0:2/node_name:	0x2000000c5005dfae
target7:0:2/port_id:	0x010ed9
target7:0:2/port_name:	0x2200000c5005dfae





   <<< For the remote FC Ports connected to the above FC Host >>

[root@grumpy /]# cd /sys/class/fc_remote_ports

[root@grumpy fc_remote_ports]# ls -ld *
drwxr-xr-x  2 root root 0 Jan 10 15:56 rport-7:0-0
drwxr-xr-x  2 root root 0 Jan 10 15:56 rport-7:0-1
drwxr-xr-x  2 root root 0 Jan 10 15:56 rport-7:0-2
drwxr-xr-x  2 root root 0 Jan 10 15:56 rport-7:0-3
drwxr-xr-x  2 root root 0 Jan 10 15:56 rport-7:0-4

[root@grumpy fc_remote_ports]# cd rport-7:0-0

[root@grumpy rport-7:0-0]# ls -ld *
lrwxrwxrwx  1 root root    0 Jan 10 15:56 device -> ../../../devices/pci0000:01/0000:01:04.1/host7/rport-7:0-0
-r--r--r--  1 root root 4096 Jan 10 15:56 errorcnt
-r--r--r--  1 root root 4096 Jan 10 15:56 iodonecnt
-r--r--r--  1 root root 4096 Jan 10 15:56 maxframe_size
-r--r--r--  1 root root 4096 Jan 10 15:56 node_name
-r--r--r--  1 root root 4096 Jan 10 15:56 port_id
-r--r--r--  1 root root 4096 Jan 10 15:56 port_name
-r--r--r--  1 root root 4096 Jan 10 15:56 port_state
-r--r--r--  1 root root 4096 Jan 10 15:56 qcmdcnt
-r--r--r--  1 root root 4096 Jan 10 15:56 roles
-r--r--r--  1 root root 4096 Jan 10 15:56 scsi_target_id
-r--r--r--  1 root root 4096 Jan 10 15:56 supported_classes

<< note: attributes errorcnt, iodonecnt, and qcmdcnt are driver-specific >>
<< parameters attached to the remote port object                         >>


[root@grumpy rport-7:0-0]# cd ..

[root@grumpy fc_remote_ports]# /tmp/showvars */*
rport-7:0-0/errorcnt:	0
rport-7:0-0/iodonecnt:	0
rport-7:0-0/maxframe_size:	2112 bytes
rport-7:0-0/node_name:	0x1000006069519369
rport-7:0-0/port_id:	0xfffffe
rport-7:0-0/port_name:	0x2004006069519369
rport-7:0-0/port_state:	Online
rport-7:0-0/qcmdcnt:	0
rport-7:0-0/roles:	Fabric Port
rport-7:0-0/scsi_target_id:	-1
rport-7:0-0/supported_classes:	Class 2, Class 3
rport-7:0-1/errorcnt:	0
rport-7:0-1/iodonecnt:	0
rport-7:0-1/maxframe_size:	2048 bytes
rport-7:0-1/node_name:	0x1000006069519369
rport-7:0-1/port_id:	0xfffffc
rport-7:0-1/port_name:	0x20fc006069519369
rport-7:0-1/port_state:	Online
rport-7:0-1/qcmdcnt:	0
rport-7:0-1/roles:	Directory Server
rport-7:0-1/scsi_target_id:	-1
rport-7:0-1/supported_classes:	Class 2, Class 3
rport-7:0-2/errorcnt:	4
rport-7:0-2/iodonecnt:	21
rport-7:0-2/maxframe_size:	2048 bytes
rport-7:0-2/node_name:	0x2000000c5005d6e4
rport-7:0-2/port_id:	0x010fe1
rport-7:0-2/port_name:	0x2200000c5005d6e4
rport-7:0-2/port_state:	Online
rport-7:0-2/qcmdcnt:	21
rport-7:0-2/roles:	FCP Target
rport-7:0-2/scsi_target_id:	0
rport-7:0-2/supported_classes:	Class 3
rport-7:0-3/errorcnt:	4
rport-7:0-3/iodonecnt:	21
rport-7:0-3/maxframe_size:	2048 bytes
rport-7:0-3/node_name:	0x2000000c5005df9d
rport-7:0-3/port_id:	0x010ed6
rport-7:0-3/port_name:	0x2200000c5005df9d
rport-7:0-3/port_state:	Online
rport-7:0-3/qcmdcnt:	21
rport-7:0-3/roles:	FCP Target
rport-7:0-3/scsi_target_id:	1
rport-7:0-3/supported_classes:	Class 3
rport-7:0-4/errorcnt:	4
rport-7:0-4/iodonecnt:	20
rport-7:0-4/maxframe_size:	2048 bytes
rport-7:0-4/node_name:	0x2000000c5005dfae
rport-7:0-4/port_id:	0x010ed9
rport-7:0-4/port_name:	0x2200000c5005dfae
rport-7:0-4/port_state:	Online
rport-7:0-4/qcmdcnt:	20
rport-7:0-4/roles:	FCP Target
rport-7:0-4/scsi_target_id:	2
rport-7:0-4/supported_classes:	Class 3

