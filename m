From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE]: lio-core-2.6.git updated to v2.6.29-rc8
Date: Fri, 13 Mar 2009 19:13:40 -0700
Message-ID: <1236996820.11120.1049.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:25381 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753570AbZCNCNq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Mar 2009 22:13:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Joel Becker <joel.becker@oracle.com>

Greetings all,

Just a quick note to the users of LIO v3.0 code in lio-core-2.6.git, I
pulled from linux-2.6.git this afternoon to v2.6.29-rc8 + kdb and
rebuilt everything in my x86 HVM test bed and so far everything looks
good.  I am also happy to report that the checkpatch cleanups for
drivers/lio-core/target_core_*.[c,h] are now complete, and things are
looking good for the first submission + feedback for v2.6.30.
checkpatch cleanups of drivers/lio-core/iscsi_target*[c,h] code are
ongoing as the plan is to submit the LIO-Target/ConfigFS fabric module
seperate from the generic target engine with Target_Core_Mod/ConfigFS.

Here is what things are looking like with Target_Core_Mod/ConfigFS and
LIO-Target/ConfigFS up and running on v2.6.29-rc8 with storage objects
of type IBLOCK LVM, Vmware SCSI passthrough, FILEIO and RAMDISK export
via LIO-Target v3.0 fabric.  The IBLOCK, FILEIO, and RAMDISK objects are
reporting SPC-3 version bits and support SPC-3 Persistent Reservations,
implict Asymmetric Logical Unit Assignement (ALUA) and 4k sectors
emulation support.  These recent SCSI cluster and multipath features has
been implemented generically in target_core_mod code, and are available
to all target mode fabric modules running on top of target_core_mod
infrastructure.

If you are a user that has been creating their own ConfigFS
configuration and/or scripts for controlling lio-core-2.6.git, I
encourage you to post your runnings setups to the LIO-devel list so that
we can help other interested folks get up.

Also, for those interested in the code, the lio-core-2.6.git tree can be
found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

For more information on configfs enabled LIO v3.0 code, please have a
look at:

http://linux-iscsi.org/index.php/LIO-Target/ConfigFS
http://linux-iscsi.org/index.php/Target_Core_Mod/ConfigFS

For more information about LIO-Target, please have a look at:

http://linux-iscsi.org/index.php/LIO-Target

A lastly, a huge thanks to the handful of folks who have been testing
v3.0 code against Linux cilent side ALUA, the VirtualBox iSCSI
initiator, OpenSolaris MPxIO+ZFS+iSCSI clients and MSFT Windows 2008
cluster setups.  Thank you for your feedback and contribution!

--nab

*) An example startup script

#!/bin/bash
	modprobe target_core_mod

	export CONFIGFS=/sys/kernel/config/
	export TARGET=/sys/kernel/config/target/core/
	export FABRIC=/sys/kernel/config/target/iscsi/

	mkdir -p $TARGET/iblock_0/lvm_test0
	echo eEaqKo-gYF8-vnDA-jJhf-Xqzy-pjGF-G6Y50v > $TARGET/iblock_0/lvm_test0/wwn/evpd_unit_serial
#	echo iblock_major=254,iblock_minor=2 > $TARGET/iblock_0/lvm_test0/control
#	echo 1 > $TARGET/iblock_0/lvm_test0/enable
	exec 3<>/dev/lio-test/test0
	echo 3 > $TARGET/iblock_0/lvm_test0/fd
	exec 3>&-
	echo 4096 > $TARGET/iblock_0/lvm_test0/attrib/block_size

	mkdir -p $TARGET/pscsi_0/sdd
	echo 66e418b4-e9ab-11dd-8f51-000c2943d57b > $TARGET/pscsi_0/sdd/wwn/evpd_unit_serial
#	echo scsi_channel_id=0,scsi_target_id=3,scsi_lun_id=0 > $TARGET/pscsi_0/sdd/control
#	echo 1 > $TARGET/pscsi_0/sdd/enable
	exec 3<>/dev/sdd
	echo 3 > $TARGET/pscsi_0/sdd/fd
	exec 3>&-

#	mkdir -p $TARGET/pscsi_1/sr0
#	echo scsi_channel_id=0,scsi_target_id=0,scsi_lun_id=0 > $TARGET/pscsi_0/sr0/control
#	echo 1 > $TARGET/pscsi_0/sdd/enable
	# Medium must be in the optical drive for 'exec 3</dev/sr0' to work
#	exec 3</dev/sr0
#	echo 3 > $TARGET/pscsi_1/sr0/fd
#	exec 3>&-

	mkdir -p $TARGET/rd_mcp_0/ramdisk
	echo rd_pages=32768 > $TARGET/rd_mcp_0/ramdisk/control
	echo 1 > $TARGET/rd_mcp_0/ramdisk/enable
	echo 4096 > $TARGET/rd_mcp_0/ramdisk/attrib/block_size

	mkdir -p $TARGET/fileio_0/fileio
	echo "fd_dev_name=/tmp/tmpfileio0,fd_dev_size=134217728" > $TARGET/fileio_0/fileio/control
	echo 1 > $TARGET/fileio_0/fileio/enable
	echo 4096 > $TARGET/fileio_0/fileio/attrib/block_size

	DEF_IQN="iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0"

	PORTAL="172.16.201.128:3260"

	# The first mkdir(2) to $FABRIC will load iscsi_target_mod
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/np/$PORTAL"
	echo 1 > "$FABRIC/$DEF_IQN/tpgt_1/np/$PORTAL/sctp"
#	echo 1 > "$FABRIC/$DEF_IQN/tpgt_1/attrib/prod_mode_write_protect"
	echo 8 > "$FABRIC/$DEF_IQN/tpgt_1/param/MaxConnections"

	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0"
	ln -s $TARGET/iblock_0/lvm_test0 "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0/lio_west_port"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1"
	ln -s $TARGET/pscsi_0/sdd "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1/lio_east_port"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_2"
#	ln -s $TARGET/pscsi_1/sr0 "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_2/lio_cdrom_port"
	ln -s $TARGET/rd_mcp_0/ramdisk "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_2/ramdisk_port"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_3"
	ln -s $TARGET/fileio_0/fileio "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_3/fileio_port"

	INITIATOR_DEBIAN="iqn.1993-08.org.debian:01:2dadf92d0ef"

	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_0"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_0/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_1"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_1/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_2"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_2" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_2/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_3"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_3" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_3/"

	INITIATOR_SUSE="iqn.1996-04.de.suse:01:1661f9ee7b5"

	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_0"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_0/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_1"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_1/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_2"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_2" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_2/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_3"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_3" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_3/"

	INITIATOR_OM="iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0"

	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_OM/lun_0"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_OM/lun_0/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_OM/lun_1"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_OM/lun_1/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_OM/lun_2"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_2" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_OM/lun_2/"

	INITIATOR_MSFT="iqn.1991-05.com.microsoft:virt-cf1d76b8c7"

	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_MSFT/lun_0"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_MSFT/lun_0/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_MSFT/lun_1"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_MSFT/lun_1/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_MSFT/lun_2"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_2" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_MSFT/lun_2/"

	INITIATOR_VBOX="iqn.2008-04.com.sun.virtualbox.initiator"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_VBOX/lun_0"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_VBOX/lun_0/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_VBOX/lun_1"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_VBOX/lun_1/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_VBOX/lun_2"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_2" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_VBOX/lun_2/"
	mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_VBOX/lun_3"
	ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_3" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_VBOX/lun_3/"
	echo 0 > "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_VBOX/attrib/nopin_timeout"

	INITIATOR_WIN7="iqn.1991-05.com.microsoft:nab-pc"
        mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_WIN7/lun_0"
        ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_WIN7/lun_0/"
        mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_WIN7/lun_1"
        ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_WIN7/lun_1/"
        mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_WIN7/lun_2"
        ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_2" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_WIN7/lun_2/"
        mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_WIN7/lun_3"
        ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_3" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_WIN7/lun_3/"

	# Disable Authentication
	echo 0 > $FABRIC/$DEF_IQN/tpgt_1/attrib/authentication
#	echo 1 > $FABRIC/$DEF_IQN/tpgt_1/attrib/generate_node_acls
#	echo 0 > $FABRIC/$DEF_IQN/tpgt_1/attrib/demo_mode_write_protect
	# Enable the TPG Endpoint so initiators can login
	echo 1 > $FABRIC/$DEF_IQN/tpgt_1/enable

	DEF_IQN_2="iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd"

        mkdir -p "$FABRIC/$DEF_IQN_2/tpgt_1/np/$PORTAL"
        echo 1 > "$FABRIC/$DEF_IQN_2/tpgt_1/np/$PORTAL/sctp"
#       echo 1 > "$FABRIC/$DEF_IQN_2/tpgt_1/attrib/prod_mode_write_protect"
        echo 8 > "$FABRIC/$DEF_IQN_2/tpgt_1/param/MaxConnections"

        mkdir -p "$FABRIC/$DEF_IQN_2/tpgt_1/lun/lun_0"
        ln -s $TARGET/iblock_0/lvm_test0 "$FABRIC/$DEF_IQN_2/tpgt_1/lun/lun_0/lio_west_port"

        INITIATOR_DEBIAN="iqn.1993-08.org.debian:01:2dadf92d0ef"

        mkdir -p "$FABRIC/$DEF_IQN_2/tpgt_1/acls/$INITIATOR_DEBIAN/lun_0"
        ln -s "$FABRIC/$DEF_IQN_2/tpgt_1/lun/lun_0" "$FABRIC/$DEF_IQN_2/tpgt_1/acls/$INITIATOR_DEBIAN/lun_0/"
        mkdir -p "$FABRIC/$DEF_IQN_2/tpgt_1/acls/$INITIATOR_DEBIAN/lun_1"
        ln -s "$FABRIC/$DEF_IQN_2/tpgt_1/lun/lun_1" "$FABRIC/$DEF_IQN_2/tpgt_1/acls/$INITIATOR_DEBIAN/lun_1/"
        mkdir -p "$FABRIC/$DEF_IQN_2/tpgt_1/acls/$INITIATOR_DEBIAN/lun_2"
        ln -s "$FABRIC/$DEF_IQN_2/tpgt_1/lun/lun_2" "$FABRIC/$DEF_IQN_2/tpgt_1/acls/$INITIATOR_DEBIAN/lun_2/"

        # Disable Authentication
        echo 0 > $FABRIC/$DEF_IQN_2/tpgt_1/attrib/authentication
#       echo 1 > $FABRIC/$DEF_IQN_2/tpgt_1/attrib/generate_node_acls
#       echo 1 > $FABRIC/$DEF_IQN_2/tpgt_1/attrib/demo_mode_write_protect
        # Enable the TPG Endpoint so initiators can login
        echo 1 > $FABRIC/$DEF_IQN_2/tpgt_1/enable


*) tree /sys/kernel/config/target

/sys/kernel/config/target/
|-- core
|   |-- alua
|   |   |-- lu_gps
|   |   |   `-- default_lu_gp
|   |   |       |-- alua_access_state
|   |   |       |-- lu_gp_id
|   |   |       `-- members
|   |   `-- tg_pt_gps
|   |       `-- default_tg_pt_gp
|   |           |-- alua_access_state
|   |           |-- members
|   |           `-- tg_pt_gp_id
|   |-- fileio_0
|   |   |-- fileio
|   |   |   |-- alua_lu_gp
|   |   |   |-- attrib
|   |   |   |   |-- block_size
|   |   |   |   |-- hw_block_size
|   |   |   |   |-- hw_max_sectors
|   |   |   |   |-- hw_queue_depth
|   |   |   |   |-- max_sectors
|   |   |   |   |-- queue_depth
|   |   |   |   |-- status_thread
|   |   |   |   |-- status_thread_tur
|   |   |   |   `-- task_timeout
|   |   |   |-- control
|   |   |   |-- enable
|   |   |   |-- fd
|   |   |   |-- info
|   |   |   |-- pr
|   |   |   |   |-- res_holder
|   |   |   |   |-- res_pr_all_tgt_pts
|   |   |   |   |-- res_pr_generation
|   |   |   |   |-- res_pr_holder_tg_port
|   |   |   |   |-- res_pr_registered_i_pts
|   |   |   |   |-- res_pr_type
|   |   |   |   `-- res_type
|   |   |   `-- wwn
|   |   |       |-- evpd_assoc_logical_unit
|   |   |       |-- evpd_assoc_scsi_target_device
|   |   |       |-- evpd_assoc_target_port
|   |   |       |-- evpd_protocol_identifier
|   |   |       `-- evpd_unit_serial
|   |   `-- hba_info
|   |-- iblock_0
|   |   |-- hba_info
|   |   `-- lvm_test0
|   |       |-- alua_lu_gp
|   |       |-- attrib
|   |       |   |-- block_size
|   |       |   |-- hw_block_size
|   |       |   |-- hw_max_sectors
|   |       |   |-- hw_queue_depth
|   |       |   |-- max_sectors
|   |       |   |-- queue_depth
|   |       |   |-- status_thread
|   |       |   |-- status_thread_tur
|   |       |   `-- task_timeout
|   |       |-- control
|   |       |-- enable
|   |       |-- fd
|   |       |-- info
|   |       |-- pr
|   |       |   |-- res_holder
|   |       |   |-- res_pr_all_tgt_pts
|   |       |   |-- res_pr_generation
|   |       |   |-- res_pr_holder_tg_port
|   |       |   |-- res_pr_registered_i_pts
|   |       |   |-- res_pr_type
|   |       |   `-- res_type
|   |       `-- wwn
|   |           |-- evpd_assoc_logical_unit
|   |           |-- evpd_assoc_scsi_target_device
|   |           |-- evpd_assoc_target_port
|   |           |-- evpd_protocol_identifier
|   |           `-- evpd_unit_serial
|   |-- pscsi_0
|   |   |-- hba_info
|   |   `-- sdd
|   |       |-- alua_lu_gp
|   |       |-- attrib
|   |       |   |-- block_size
|   |       |   |-- hw_block_size
|   |       |   |-- hw_max_sectors
|   |       |   |-- hw_queue_depth
|   |       |   |-- max_sectors
|   |       |   |-- queue_depth
|   |       |   |-- status_thread
|   |       |   |-- status_thread_tur
|   |       |   `-- task_timeout
|   |       |-- control
|   |       |-- enable
|   |       |-- fd
|   |       |-- info
|   |       |-- pr
|   |       |   |-- res_holder
|   |       |   |-- res_pr_all_tgt_pts
|   |       |   |-- res_pr_generation
|   |       |   |-- res_pr_holder_tg_port
|   |       |   |-- res_pr_registered_i_pts
|   |       |   |-- res_pr_type
|   |       |   `-- res_type
|   |       `-- wwn
|   |           |-- evpd_assoc_logical_unit
|   |           |-- evpd_assoc_scsi_target_device
|   |           |-- evpd_assoc_target_port
|   |           |-- evpd_protocol_identifier
|   |           `-- evpd_unit_serial
|   `-- rd_mcp_0
|       |-- hba_info
|       `-- ramdisk
|           |-- alua_lu_gp
|           |-- attrib
|           |   |-- block_size
|           |   |-- hw_block_size
|           |   |-- hw_max_sectors
|           |   |-- hw_queue_depth
|           |   |-- max_sectors
|           |   |-- queue_depth
|           |   |-- status_thread
|           |   |-- status_thread_tur
|           |   `-- task_timeout
|           |-- control
|           |-- enable
|           |-- fd
|           |-- info
|           |-- pr
|           |   |-- res_holder
|           |   |-- res_pr_all_tgt_pts
|           |   |-- res_pr_generation
|           |   |-- res_pr_holder_tg_port
|           |   |-- res_pr_registered_i_pts
|           |   |-- res_pr_type
|           |   `-- res_type
|           `-- wwn
|               |-- evpd_assoc_logical_unit
|               |-- evpd_assoc_scsi_target_device
|               |-- evpd_assoc_target_port
|               |-- evpd_protocol_identifier
|               `-- evpd_unit_serial
|-- iscsi
|   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd
|   |   `-- tpgt_1
|   |       |-- acls
|   |       |   `-- iqn.1993-08.org.debian:01:2dadf92d0ef
|   |       |       |-- attrib
|   |       |       |   |-- dataout_timeout
|   |       |       |   |-- dataout_timeout_retries
|   |       |       |   |-- default_erl
|   |       |       |   |-- nopin_response_timeout
|   |       |       |   |-- nopin_timeout
|   |       |       |   |-- random_datain_pdu_offsets
|   |       |       |   |-- random_datain_seq_offsets
|   |       |       |   `-- random_r2t_offsets
|   |       |       |-- cmdsn_depth
|   |       |       |-- info
|   |       |       |-- lun_0
|   |       |       |   |-- lun_0
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd/tpgt_1/lun/lun_0
|   |       |       |   `-- write_protect
|   |       |       `-- param
|   |       |           |-- DataPDUInOrder
|   |       |           |-- DataSequenceInOrder
|   |       |           |-- DefaultTime2Retain
|   |       |           |-- DefaultTime2Wait
|   |       |           |-- ErrorRecoveryLevel
|   |       |           |-- FirstBurstLength
|   |       |           |-- ImmediateData
|   |       |           |-- InitialR2T
|   |       |           |-- MaxBurstLength
|   |       |           |-- MaxConnections
|   |       |           `-- MaxOutstandingR2T
|   |       |-- attrib
|   |       |   |-- authentication
|   |       |   |-- cache_dynamic_acls
|   |       |   |-- default_cmdsn_depth
|   |       |   |-- demo_mode_write_protect
|   |       |   |-- generate_node_acls
|   |       |   |-- login_timeout
|   |       |   |-- netif_timeout
|   |       |   `-- prod_mode_write_protect
|   |       |-- control
|   |       |-- enable
|   |       |-- lun
|   |       |   `-- lun_0
|   |       |       |-- alua_tg_pt_gp
|   |       |       `-- lio_west_port
-> ../../../../../../target/core/iblock_0/lvm_test0
|   |       |-- np
|   |       |   `-- 172.16.201.128:3260
|   |       |       |-- info
|   |       |       `-- sctp
|   |       `-- param
|   |           |-- AuthMethod
|   |           |-- DataDigest
|   |           |-- DataPDUInOrder
|   |           |-- DataSequenceInOrder
|   |           |-- DefaultTime2Retain
|   |           |-- DefaultTime2Wait
|   |           |-- ErrorRecoveryLevel
|   |           |-- FirstBurstLength
|   |           |-- HeaderDigest
|   |           |-- IFMarkInt
|   |           |-- IFMarker
|   |           |-- ImmediateData
|   |           |-- InitialR2T
|   |           |-- MaxBurstLength
|   |           |-- MaxConnections
|   |           |-- MaxOutstandingR2T
|   |           |-- MaxRecvDataSegmentLength
|   |           |-- OFMarkInt
|   |           |-- OFMarker
|   |           `-- TargetAlias
|   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
|   |   `-- tpgt_1
|   |       |-- acls
|   |       |   |-- iqn.1991-05.com.microsoft:nab-pc
|   |       |   |   |-- attrib
|   |       |   |   |   |-- dataout_timeout
|   |       |   |   |   |-- dataout_timeout_retries
|   |       |   |   |   |-- default_erl
|   |       |   |   |   |-- nopin_response_timeout
|   |       |   |   |   |-- nopin_timeout
|   |       |   |   |   |-- random_datain_pdu_offsets
|   |       |   |   |   |-- random_datain_seq_offsets
|   |       |   |   |   `-- random_r2t_offsets
|   |       |   |   |-- cmdsn_depth
|   |       |   |   |-- info
|   |       |   |   |-- lun_0
|   |       |   |   |   |-- lun_0
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_0
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_1
|   |       |   |   |   |-- lun_1
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_1
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_2
|   |       |   |   |   |-- lun_2
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_2
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_3
|   |       |   |   |   |-- lun_3
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_3
|   |       |   |   |   `-- write_protect
|   |       |   |   `-- param
|   |       |   |       |-- DataPDUInOrder
|   |       |   |       |-- DataSequenceInOrder
|   |       |   |       |-- DefaultTime2Retain
|   |       |   |       |-- DefaultTime2Wait
|   |       |   |       |-- ErrorRecoveryLevel
|   |       |   |       |-- FirstBurstLength
|   |       |   |       |-- ImmediateData
|   |       |   |       |-- InitialR2T
|   |       |   |       |-- MaxBurstLength
|   |       |   |       |-- MaxConnections
|   |       |   |       `-- MaxOutstandingR2T
|   |       |   |-- iqn.1991-05.com.microsoft:virt-cf1d76b8c7
|   |       |   |   |-- attrib
|   |       |   |   |   |-- dataout_timeout
|   |       |   |   |   |-- dataout_timeout_retries
|   |       |   |   |   |-- default_erl
|   |       |   |   |   |-- nopin_response_timeout
|   |       |   |   |   |-- nopin_timeout
|   |       |   |   |   |-- random_datain_pdu_offsets
|   |       |   |   |   |-- random_datain_seq_offsets
|   |       |   |   |   `-- random_r2t_offsets
|   |       |   |   |-- cmdsn_depth
|   |       |   |   |-- info
|   |       |   |   |-- lun_0
|   |       |   |   |   |-- lun_0
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_0
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_1
|   |       |   |   |   |-- lun_1
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_1
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_2
|   |       |   |   |   |-- lun_2
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_2
|   |       |   |   |   `-- write_protect
|   |       |   |   `-- param
|   |       |   |       |-- DataPDUInOrder
|   |       |   |       |-- DataSequenceInOrder
|   |       |   |       |-- DefaultTime2Retain
|   |       |   |       |-- DefaultTime2Wait
|   |       |   |       |-- ErrorRecoveryLevel
|   |       |   |       |-- FirstBurstLength
|   |       |   |       |-- ImmediateData
|   |       |   |       |-- InitialR2T
|   |       |   |       |-- MaxBurstLength
|   |       |   |       |-- MaxConnections
|   |       |   |       `-- MaxOutstandingR2T
|   |       |   |-- iqn.1993-08.org.debian:01:2dadf92d0ef
|   |       |   |   |-- attrib
|   |       |   |   |   |-- dataout_timeout
|   |       |   |   |   |-- dataout_timeout_retries
|   |       |   |   |   |-- default_erl
|   |       |   |   |   |-- nopin_response_timeout
|   |       |   |   |   |-- nopin_timeout
|   |       |   |   |   |-- random_datain_pdu_offsets
|   |       |   |   |   |-- random_datain_seq_offsets
|   |       |   |   |   `-- random_r2t_offsets
|   |       |   |   |-- cmdsn_depth
|   |       |   |   |-- info
|   |       |   |   |-- lun_0
|   |       |   |   |   |-- lun_0
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_0
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_1
|   |       |   |   |   |-- lun_1
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_1
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_2
|   |       |   |   |   |-- lun_2
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_2
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_3
|   |       |   |   |   |-- lun_3
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_3
|   |       |   |   |   `-- write_protect
|   |       |   |   `-- param
|   |       |   |       |-- DataPDUInOrder
|   |       |   |       |-- DataSequenceInOrder
|   |       |   |       |-- DefaultTime2Retain
|   |       |   |       |-- DefaultTime2Wait
|   |       |   |       |-- ErrorRecoveryLevel
|   |       |   |       |-- FirstBurstLength
|   |       |   |       |-- ImmediateData
|   |       |   |       |-- InitialR2T
|   |       |   |       |-- MaxBurstLength
|   |       |   |       |-- MaxConnections
|   |       |   |       `-- MaxOutstandingR2T
|   |       |   |-- iqn.1996-04.de.suse:01:1661f9ee7b5
|   |       |   |   |-- attrib
|   |       |   |   |   |-- dataout_timeout
|   |       |   |   |   |-- dataout_timeout_retries
|   |       |   |   |   |-- default_erl
|   |       |   |   |   |-- nopin_response_timeout
|   |       |   |   |   |-- nopin_timeout
|   |       |   |   |   |-- random_datain_pdu_offsets
|   |       |   |   |   |-- random_datain_seq_offsets
|   |       |   |   |   `-- random_r2t_offsets
|   |       |   |   |-- cmdsn_depth
|   |       |   |   |-- info
|   |       |   |   |-- lun_0
|   |       |   |   |   |-- lun_0
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_0
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_1
|   |       |   |   |   |-- lun_1
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_1
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_2
|   |       |   |   |   |-- lun_2
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_2
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_3
|   |       |   |   |   |-- lun_3
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_3
|   |       |   |   |   `-- write_protect
|   |       |   |   `-- param
|   |       |   |       |-- DataPDUInOrder
|   |       |   |       |-- DataSequenceInOrder
|   |       |   |       |-- DefaultTime2Retain
|   |       |   |       |-- DefaultTime2Wait
|   |       |   |       |-- ErrorRecoveryLevel
|   |       |   |       |-- FirstBurstLength
|   |       |   |       |-- ImmediateData
|   |       |   |       |-- InitialR2T
|   |       |   |       |-- MaxBurstLength
|   |       |   |       |-- MaxConnections
|   |       |   |       `-- MaxOutstandingR2T
|   |       |   |--
iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0
|   |       |   |   |-- attrib
|   |       |   |   |   |-- dataout_timeout
|   |       |   |   |   |-- dataout_timeout_retries
|   |       |   |   |   |-- default_erl
|   |       |   |   |   |-- nopin_response_timeout
|   |       |   |   |   |-- nopin_timeout
|   |       |   |   |   |-- random_datain_pdu_offsets
|   |       |   |   |   |-- random_datain_seq_offsets
|   |       |   |   |   `-- random_r2t_offsets
|   |       |   |   |-- cmdsn_depth
|   |       |   |   |-- info
|   |       |   |   |-- lun_0
|   |       |   |   |   |-- lun_0
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_0
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_1
|   |       |   |   |   |-- lun_1
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_1
|   |       |   |   |   `-- write_protect
|   |       |   |   |-- lun_2
|   |       |   |   |   |-- lun_2
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_2
|   |       |   |   |   `-- write_protect
|   |       |   |   `-- param
|   |       |   |       |-- DataPDUInOrder
|   |       |   |       |-- DataSequenceInOrder
|   |       |   |       |-- DefaultTime2Retain
|   |       |   |       |-- DefaultTime2Wait
|   |       |   |       |-- ErrorRecoveryLevel
|   |       |   |       |-- FirstBurstLength
|   |       |   |       |-- ImmediateData
|   |       |   |       |-- InitialR2T
|   |       |   |       |-- MaxBurstLength
|   |       |   |       |-- MaxConnections
|   |       |   |       `-- MaxOutstandingR2T
|   |       |   `-- iqn.2008-04.com.sun.virtualbox.initiator
|   |       |       |-- attrib
|   |       |       |   |-- dataout_timeout
|   |       |       |   |-- dataout_timeout_retries
|   |       |       |   |-- default_erl
|   |       |       |   |-- nopin_response_timeout
|   |       |       |   |-- nopin_timeout
|   |       |       |   |-- random_datain_pdu_offsets
|   |       |       |   |-- random_datain_seq_offsets
|   |       |       |   `-- random_r2t_offsets
|   |       |       |-- cmdsn_depth
|   |       |       |-- info
|   |       |       |-- lun_0
|   |       |       |   |-- lun_0
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_0
|   |       |       |   `-- write_protect
|   |       |       |-- lun_1
|   |       |       |   |-- lun_1
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_1
|   |       |       |   `-- write_protect
|   |       |       |-- lun_2
|   |       |       |   |-- lun_2
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_2
|   |       |       |   `-- write_protect
|   |       |       |-- lun_3
|   |       |       |   |-- lun_3
-> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_3
|   |       |       |   `-- write_protect
|   |       |       `-- param
|   |       |           |-- DataPDUInOrder
|   |       |           |-- DataSequenceInOrder
|   |       |           |-- DefaultTime2Retain
|   |       |           |-- DefaultTime2Wait
|   |       |           |-- ErrorRecoveryLevel
|   |       |           |-- FirstBurstLength
|   |       |           |-- ImmediateData
|   |       |           |-- InitialR2T
|   |       |           |-- MaxBurstLength
|   |       |           |-- MaxConnections
|   |       |           `-- MaxOutstandingR2T
|   |       |-- attrib
|   |       |   |-- authentication
|   |       |   |-- cache_dynamic_acls
|   |       |   |-- default_cmdsn_depth
|   |       |   |-- demo_mode_write_protect
|   |       |   |-- generate_node_acls
|   |       |   |-- login_timeout
|   |       |   |-- netif_timeout
|   |       |   `-- prod_mode_write_protect
|   |       |-- control
|   |       |-- enable
|   |       |-- lun
|   |       |   |-- lun_0
|   |       |   |   |-- alua_tg_pt_gp
|   |       |   |   `-- lio_west_port
-> ../../../../../../target/core/iblock_0/lvm_test0
|   |       |   |-- lun_1
|   |       |   |   |-- alua_tg_pt_gp
|   |       |   |   `-- lio_east_port
-> ../../../../../../target/core/pscsi_0/sdd
|   |       |   |-- lun_2
|   |       |   |   |-- alua_tg_pt_gp
|   |       |   |   `-- ramdisk_port
-> ../../../../../../target/core/rd_mcp_0/ramdisk
|   |       |   `-- lun_3
|   |       |       |-- alua_tg_pt_gp
|   |       |       `-- fileio_port
-> ../../../../../../target/core/fileio_0/fileio
|   |       |-- np
|   |       |   `-- 172.16.201.128:3260
|   |       |       |-- info
|   |       |       `-- sctp
|   |       `-- param
|   |           |-- AuthMethod
|   |           |-- DataDigest
|   |           |-- DataPDUInOrder
|   |           |-- DataSequenceInOrder
|   |           |-- DefaultTime2Retain
|   |           |-- DefaultTime2Wait
|   |           |-- ErrorRecoveryLevel
|   |           |-- FirstBurstLength
|   |           |-- HeaderDigest
|   |           |-- IFMarkInt
|   |           |-- IFMarker
|   |           |-- ImmediateData
|   |           |-- InitialR2T
|   |           |-- MaxBurstLength
|   |           |-- MaxConnections
|   |           |-- MaxOutstandingR2T
|   |           |-- MaxRecvDataSegmentLength
|   |           |-- OFMarkInt
|   |           |-- OFMarker
|   |           `-- TargetAlias
|   `-- lio_version
`-- version

120 directories, 355 files

*) dmesg

TARGET_CORE[0]: Loading Generic Kernel Storage Engine: v3.0.0 on Linux/i686 on 2.6.29-rc8
TARGET_CORE[0]: Initialized ConfigFS Fabric Infrastructure: v1.0.0 on Linux/i686 on 2.6.29-rc8
SE_PC[0] - Registered Plugin Class: TRANSPORT
PLUGIN_TRANSPORT[1] - pscsi registered
PLUGIN_TRANSPORT[4] - iblock registered
PLUGIN_TRANSPORT[5] - rd_dr registered
PLUGIN_TRANSPORT[6] - rd_mcp registered
PLUGIN_TRANSPORT[7] - fileio registered
SE_PC[1] - Registered Plugin Class: OBJ
PLUGIN_OBJ[1] - dev registered
Target_Core_ConfigFS: Located se_plugin: caf25090 plugin_name: iblock hba_type: 4 plugin_dep_id: 0
CORE_HBA[0] - Linux-iSCSI.org iBlock HBA Driver v3.0 on Generic Target Core Stack v3.0
CORE_HBA[0] - Attached iBlock HBA: 0 to Generic Target Core TCQ Depth: 512
CORE_HBA[0] - Attached HBA to Generic Target Core
IBLOCK: Allocated ib_dev for lvm_test0
Target_Core_ConfigFS: Allocated se_subsystem_dev_t: caf26800 se_dev_su_ptr: ccf9f200
Target_Core_ConfigFS: Set emulated EVPD Unit Serial: eEaqKo-gYF8-vnDA-jJhf-Xqzy-pjGF-G6Y50v
IBLOCK: Claiming struct block_device: df663400
bio: create slab <bio-1> at 1
IBLOCK: Created bio_set() for major/minor: 254:2
iblock: Using SPC3_PERSISTENT_RESERVATIONS emulation
iblock: Enabling ALUA Emulation for SPC-3 device
iblock: Adding to default ALUA LU Group: core/alua/lu_gps/default_lu_gp
CORE_iBLOCK[0] - Activating Device with TCQ: 0 at Major: 254 Minor 2
  Vendor: LIO-ORG   Model: IBLOCK            Revision: v3. 
  Type:   Direct-Access                      ANSI SCSI revision: 05
T10 EVPD Unit Serial Number: eEaqKo-gYF8-vnDA-jJhf-Xqzy-pjGF-G6Y50v
T10 EVPD Page Length: 58
T10 EVPD Identifer Length: 54
T10 EVPD Identifier Association: addressed logical unit
T10 EVPD Identifier Type: T10 Vendor ID based
T10 EVPD ASCII Device Identifier: LIO-ORG
Target_Core_ConfigFS: Registered iblock se_dev->se_dev_ptr: cab76400 from fd
Target_Core_ConfigFS: Located se_plugin: caf25024 plugin_name: pscsi hba_type: 1 plugin_dep_id: 0
CORE_HBA[1] - Linux-iSCSI.org SCSI HBA Driver v3.0 on Generic Target Core Stack v3.0
CORE_HBA[1] - MPT SPI Host
CORE_HBA[1] - Attached SCSI HBA to Generic Target Core with TCQ Depth: 127 MaxSectors: 8192
CORE_HBA[1] - Attached HBA to Generic Target Core
PSCSI: Allocated pdv: dee890a0 for sdd
Target_Core_ConfigFS: Allocated se_subsystem_dev_t: caf26000 se_dev_su_ptr: dee890a0
Target_Core_ConfigFS: Set emulated EVPD Unit Serial: 66e418b4-e9ab-11dd-8f51-000c2943d57b
PSCSI: Claiming def32800 Major:Minor - 8:48
pscsi: Using SPC_PASSTHROUGH, no reservation emulation
pscsi: Using SPC_ALUA_PASSTHROUGH, no ALUA emulation
CORE_PSCSI[0] - Activating Device with TCQ: 32 at SCSI Location (Channel/Target/LUN) 0/3/0
  Vendor: VMware,   Model: VMware Virtual S  Revision: 1.0 
  Type:   Direct-Access                      ANSI SCSI revision: 02
PSCSI Status Byte exception at task: d6ade000 CDB: 0x12 Result: 0x08000002
CORE_PSCSI[0] - Added TYPE_DISK for 0:3:0
Target_Core_ConfigFS: Registered pscsi se_dev->se_dev_ptr: cab76c00 from fd
Target_Core_ConfigFS: Located se_plugin: caf250d8 plugin_name: rd_mcp hba_type: 6 plugin_dep_id: 0
CORE_HBA[2] - Linux-iSCSI.org Ramdisk HBA Driver v3.0 on Generic Target Core Stack v3.0
CORE_HBA[2] - Attached Ramdisk HBA: 0 to Generic Target Core TCQ Depth: 256 MaxSectors: 1024
CORE_HBA[2] - Attached HBA to Generic Target Core
Target_Core_ConfigFS: Allocated se_subsystem_dev_t: caf27000 se_dev_su_ptr: ccfe3100
RAMDISK: Referencing Page Count: 32768
CORE_RD[0] - Built Ramdisk Device ID: 0 space of 32768 pages in 11 tables
rd_mcp: Using SPC3_PERSISTENT_RESERVATIONS emulation
rd_mcp: Enabling ALUA Emulation for SPC-3 device
rd_mcp: Adding to default ALUA LU Group: core/alua/lu_gps/default_lu_gp
CORE_RD[0] - Activating Device with TCQ: 0 at Ramdisk Device ID: 0
  Vendor: LIO-ORG   Model: RAMDISK-MCP       Revision: v3. 
  Type:   Direct-Access                      ANSI SCSI revision: 05
T10 EVPD Unit Serial Number: 1234567890:2_0
T10 EVPD Page Length: 39
T10 EVPD Identifer Length: 35
T10 EVPD Identifier Association: addressed logical unit
T10 EVPD Identifier Type: T10 Vendor ID based
T10 EVPD ASCII Device Identifier: LIO-ORG
CORE_RD[0] - Added LIO MEMCPY Ramdisk Device ID: 0 of 32768 pages in 11 tables, 134217728 total bytes
Target_Core_ConfigFS: Registered se_dev->se_dev_ptr: cab76000
dev[cab76000]: SE Device block_size changed to 4096
Target_Core_ConfigFS: Located se_plugin: caf250fc plugin_name: fileio hba_type: 7 plugin_dep_id: 0
CORE_HBA[3] - Linux-iSCSI.org FILEIO HBA Driver v3.0 on Generic Target Core Stack v3.0
CORE_HBA[3] - Attached FILEIO HBA: 0 to Generic Target Core with TCQ Depth: 256 MaxSectors: 1024
CORE_HBA[3] - Attached HBA to Generic Target Core
FILEIO: Allocated fd_dev for ccf721e8
Target_Core_ConfigFS: Allocated se_subsystem_dev_t: caf24800 se_dev_su_ptr: df241e00
FILEIO: Referencing Path: /tmp/tmpfileio0
FILEIO: Referencing Size: 134217728
fileio: Using SPC3_PERSISTENT_RESERVATIONS emulation
fileio: Enabling ALUA Emulation for SPC-3 device
fileio: Adding to default ALUA LU Group: core/alua/lu_gps/default_lu_gp
CORE_FILE[0] - Activating Device with TCQ: 0 at FILEIO Device ID: 0
  Vendor: LIO-ORG   Model: FILEIO            Revision: v3. 
  Type:   Direct-Access                      ANSI SCSI revision: 05
T10 EVPD Unit Serial Number: 1234567890:3_0
T10 EVPD Page Length: 34
T10 EVPD Identifer Length: 30
T10 EVPD Identifier Association: addressed logical unit
T10 EVPD Identifier Type: T10 Vendor ID based
T10 EVPD ASCII Device Identifier: LIO-ORG
CORE_FILE[0] - Added LIO FILEIO Device ID: 0 at /tmp/tmpfileio0, 134217728 total bytes
Target_Core_ConfigFS: Registered se_dev->se_dev_ptr: df28cc00
dev[df28cc00]: SE Device block_size changed to 4096
Target_Core_ConfigFS: REGISTER -> group: e0c33980 name: iscsi
Linux-iSCSI.org iSCSI Target Core Stack v3.0.0 on Linux/i686 on 2.6.29-rc8
<<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
Initialized struct target_fabric_configfs: dc60eb00 for iscsi
<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
LIO_TARGET[0] - Set fabric -> lio_target_fabric_configfs
iscsi_allocate_thread_sets:195: ***OPS*** Spawned 4 thread set(s) (8 total threads).
TARGET_CORE[iSCSI]: Allocated Discovery se_portal_group_t for endpoint: None, Portal Tag: 0
CORE[0] - Allocated Discovery TPG
Loading Complete.
Target_Core_ConfigFS: REGISTER -> Located fabric: iscsi
Target_Core_ConfigFS: REGISTER -> e13c52c0
Target_Core_ConfigFS: REGISTER -> Allocated Fabric: iscsi
Target_Core_ConfigFS: REGISTER -> Set tf->tf_fabric for iscsi
lio_target_call_coreaddtiqn(): name: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
CORE[0] - Added iSCSI Target IQN: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
LIO_Target_ConfigFS: REGISTER -> Allocated Node: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
lio_target_tiqn_addtpg() called: name tpgt_1
lio_target_tiqn_addtpg() parent name: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
lio_target_tiqn_addtpg() Using TPGT: 1
TARGET_CORE[iSCSI]: Allocated Normal se_portal_group_t for endpoint: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0, Portal Tag: 1
CORE[iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0]_TPG[1] - Added iSCSI Target Portal Group
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
LIO_Target_ConfigFS: REGISTER -> Allocated TPG: tpgt_1
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0 TPGT: 1 PORTAL: 172.16.201.128:3260
CORE[0] - Added Network Portal: 172.16.201.128:3260 on TCP on network device: None
CORE[iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0] - Added Network Portal: 172.16.201.128:3260,1 on TCP on network device: None
CORE[iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0]_TPG[1] - Incremented np_exports to 1
LIO_Target_ConfigFS: addnptotpg done!
CORE[0] - Added Network Portal: 172.16.201.128:3260 on SCTP on network device: None
CORE[iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0] - Added Network Portal: 172.16.201.128:3260,1 on SCTP on network device: None
CORE[iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0]_TPG[1] - Incremented np_exports to 1
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0 TPGT: 1 LUN: 0
iblock/iSCSI: Adding to default ALUA Target Port Group: core/alua/tg_pt_gps/default_tg_pt_gp
iSCSI_TPG[1]_LUN[0] - Activated iSCSI Logical Unit from CORE HBA: 0
LIO_Target_ConfigFS: Created Port Symlink lvm_test0 -> lun_0
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0 TPGT: 1 LUN: 1
iSCSI_TPG[1]_LUN[1] - Activated iSCSI Logical Unit from CORE HBA: 1
LIO_Target_ConfigFS: Created Port Symlink sdd -> lun_1
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0 TPGT: 1 LUN: 2
rd_mcp/iSCSI: Adding to default ALUA Target Port Group: core/alua/tg_pt_gps/default_tg_pt_gp
iSCSI_TPG[1]_LUN[2] - Activated iSCSI Logical Unit from CORE HBA: 2
LIO_Target_ConfigFS: Created Port Symlink ramdisk -> lun_2
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0 TPGT: 1 LUN: 3
fileio/iSCSI: Adding to default ALUA Target Port Group: core/alua/tg_pt_gps/default_tg_pt_gp
iSCSI_TPG[1]_LUN[3] - Activated iSCSI Logical Unit from CORE HBA: 3
LIO_Target_ConfigFS: Created Port Symlink fileio -> lun_3
iSCSI_TPG[1] - Added ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0 TPGT: 1 Initiator: iqn.1993-08.org.debian:01:2dadf92d0ef CmdSN Depth: 16
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1993-08.org.debian:01:2dadf92d0ef Mapped LUN: lun_0
iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.1993-08.org.debian:01:2dadf92d0ef
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1993-08.org.debian:01:2dadf92d0ef TPG LUN: lun_0 Mapped LUN: lun_0 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1993-08.org.debian:01:2dadf92d0ef Mapped LUN: lun_1
iSCSI_TPG[1]_LUN[1->1] - Added RW ACL for  InitiatorNode: iqn.1993-08.org.debian:01:2dadf92d0ef
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1993-08.org.debian:01:2dadf92d0ef TPG LUN: lun_1 Mapped LUN: lun_1 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1993-08.org.debian:01:2dadf92d0ef Mapped LUN: lun_2
iSCSI_TPG[1]_LUN[2->2] - Added RW ACL for  InitiatorNode: iqn.1993-08.org.debian:01:2dadf92d0ef
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1993-08.org.debian:01:2dadf92d0ef TPG LUN: lun_2 Mapped LUN: lun_2 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1993-08.org.debian:01:2dadf92d0ef Mapped LUN: lun_3
iSCSI_TPG[1]_LUN[3->3] - Added RW ACL for  InitiatorNode: iqn.1993-08.org.debian:01:2dadf92d0ef
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1993-08.org.debian:01:2dadf92d0ef TPG LUN: lun_3 Mapped LUN: lun_3 Write Protect: OFF
iSCSI_TPG[1] - Added ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.1996-04.de.suse:01:1661f9ee7b5
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0 TPGT: 1 Initiator: iqn.1996-04.de.suse:01:1661f9ee7b5 CmdSN Depth: 16
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1996-04.de.suse:01:1661f9ee7b5 Mapped LUN: lun_0
iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.1996-04.de.suse:01:1661f9ee7b5
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1996-04.de.suse:01:1661f9ee7b5 TPG LUN: lun_0 Mapped LUN: lun_0 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1996-04.de.suse:01:1661f9ee7b5 Mapped LUN: lun_1
iSCSI_TPG[1]_LUN[1->1] - Added RW ACL for  InitiatorNode: iqn.1996-04.de.suse:01:1661f9ee7b5
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1996-04.de.suse:01:1661f9ee7b5 TPG LUN: lun_1 Mapped LUN: lun_1 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1996-04.de.suse:01:1661f9ee7b5 Mapped LUN: lun_2
iSCSI_TPG[1]_LUN[2->2] - Added RW ACL for  InitiatorNode: iqn.1996-04.de.suse:01:1661f9ee7b5
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1996-04.de.suse:01:1661f9ee7b5 TPG LUN: lun_2 Mapped LUN: lun_2 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1996-04.de.suse:01:1661f9ee7b5 Mapped LUN: lun_3
iSCSI_TPG[1]_LUN[3->3] - Added RW ACL for  InitiatorNode: iqn.1996-04.de.suse:01:1661f9ee7b5
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1996-04.de.suse:01:1661f9ee7b5 TPG LUN: lun_3 Mapped LUN: lun_3 Write Protect: OFF
iSCSI_TPG[1] - Added ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0 TPGT: 1 Initiator: iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0 CmdSN Depth: 16
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0 Mapped LUN: lun_0
iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0 TPG LUN: lun_0 Mapped LUN: lun_0 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0 Mapped LUN: lun_1
iSCSI_TPG[1]_LUN[1->1] - Added RW ACL for  InitiatorNode: iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0 TPG LUN: lun_1 Mapped LUN: lun_1 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0 Mapped LUN: lun_2
iSCSI_TPG[1]_LUN[2->2] - Added RW ACL for  InitiatorNode: iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.2003-01.org.linux-iscsi.om-gta02.armv4tl:sn.8f882218a9d0 TPG LUN: lun_2 Mapped LUN: lun_2 Write Protect: OFF
iSCSI_TPG[1] - Added ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.1991-05.com.microsoft:virt-cf1d76b8c7
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0 TPGT: 1 Initiator: iqn.1991-05.com.microsoft:virt-cf1d76b8c7 CmdSN Depth: 16
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1991-05.com.microsoft:virt-cf1d76b8c7 Mapped LUN: lun_0
iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.1991-05.com.microsoft:virt-cf1d76b8c7
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1991-05.com.microsoft:virt-cf1d76b8c7 TPG LUN: lun_0 Mapped LUN: lun_0 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1991-05.com.microsoft:virt-cf1d76b8c7 Mapped LUN: lun_1
iSCSI_TPG[1]_LUN[1->1] - Added RW ACL for  InitiatorNode: iqn.1991-05.com.microsoft:virt-cf1d76b8c7
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1991-05.com.microsoft:virt-cf1d76b8c7 TPG LUN: lun_1 Mapped LUN: lun_1 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1991-05.com.microsoft:virt-cf1d76b8c7 Mapped LUN: lun_2
iSCSI_TPG[1]_LUN[2->2] - Added RW ACL for  InitiatorNode: iqn.1991-05.com.microsoft:virt-cf1d76b8c7
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1991-05.com.microsoft:virt-cf1d76b8c7 TPG LUN: lun_2 Mapped LUN: lun_2 Write Protect: OFF
iSCSI_TPG[1] - Added ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.2008-04.com.sun.virtualbox.initiator
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0 TPGT: 1 Initiator: iqn.2008-04.com.sun.virtualbox.initiator CmdSN Depth: 16
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.2008-04.com.sun.virtualbox.initiator Mapped LUN: lun_0
iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.2008-04.com.sun.virtualbox.initiator
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.2008-04.com.sun.virtualbox.initiator TPG LUN: lun_0 Mapped LUN: lun_0 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.2008-04.com.sun.virtualbox.initiator Mapped LUN: lun_1
iSCSI_TPG[1]_LUN[1->1] - Added RW ACL for  InitiatorNode: iqn.2008-04.com.sun.virtualbox.initiator
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.2008-04.com.sun.virtualbox.initiator TPG LUN: lun_1 Mapped LUN: lun_1 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.2008-04.com.sun.virtualbox.initiator Mapped LUN: lun_2
iSCSI_TPG[1]_LUN[2->2] - Added RW ACL for  InitiatorNode: iqn.2008-04.com.sun.virtualbox.initiator
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.2008-04.com.sun.virtualbox.initiator TPG LUN: lun_2 Mapped LUN: lun_2 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.2008-04.com.sun.virtualbox.initiator Mapped LUN: lun_3
iSCSI_TPG[1]_LUN[3->3] - Added RW ACL for  InitiatorNode: iqn.2008-04.com.sun.virtualbox.initiator
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.2008-04.com.sun.virtualbox.initiator TPG LUN: lun_3 Mapped LUN: lun_3 Write Protect: OFF
iSCSI_TPG[1] - Added ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.1991-05.com.microsoft:nab-pc
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0 TPGT: 1 Initiator: iqn.1991-05.com.microsoft:nab-pc CmdSN Depth: 16
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1991-05.com.microsoft:nab-pc Mapped LUN: lun_0
iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.1991-05.com.microsoft:nab-pc
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1991-05.com.microsoft:nab-pc TPG LUN: lun_0 Mapped LUN: lun_0 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1991-05.com.microsoft:nab-pc Mapped LUN: lun_1
iSCSI_TPG[1]_LUN[1->1] - Added RW ACL for  InitiatorNode: iqn.1991-05.com.microsoft:nab-pc
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1991-05.com.microsoft:nab-pc TPG LUN: lun_1 Mapped LUN: lun_1 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1991-05.com.microsoft:nab-pc Mapped LUN: lun_2
iSCSI_TPG[1]_LUN[2->2] - Added RW ACL for  InitiatorNode: iqn.1991-05.com.microsoft:nab-pc
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1991-05.com.microsoft:nab-pc TPG LUN: lun_2 Mapped LUN: lun_2 Write Protect: OFF
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1991-05.com.microsoft:nab-pc Mapped LUN: lun_3
iSCSI_TPG[1]_LUN[3->3] - Added RW ACL for  InitiatorNode: iqn.1991-05.com.microsoft:nab-pc
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1991-05.com.microsoft:nab-pc TPG LUN: lun_3 Mapped LUN: lun_3 Write Protect: OFF
Disabling iSCSI Authentication Methods for TPG: 1.
iSCSI_TPG[1] - Enabled iSCSI Target Portal Group
lio_target_call_coreaddtiqn(): name: iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd
CORE[0] - Added iSCSI Target IQN: iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd
LIO_Target_ConfigFS: REGISTER -> Allocated Node: iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd
lio_target_tiqn_addtpg() called: name tpgt_1
lio_target_tiqn_addtpg() parent name: iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd
lio_target_tiqn_addtpg() Using TPGT: 1
TARGET_CORE[iSCSI]: Allocated Normal se_portal_group_t for endpoint: iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd, Portal Tag: 1
CORE[iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd]_TPG[1] - Added iSCSI Target Portal Group
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd
LIO_Target_ConfigFS: REGISTER -> Allocated TPG: tpgt_1
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd TPGT: 1 PORTAL: 172.16.201.128:3260
CORE[iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd] - Added Network Portal: 172.16.201.128:3260,1 on TCP on network device: None
CORE[iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd]_TPG[1] - Incremented np_exports to 2
LIO_Target_ConfigFS: addnptotpg done!
CORE[iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd] - Added Network Portal: 172.16.201.128:3260,1 on SCTP on network device: None
CORE[iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd]_TPG[1] - Incremented np_exports to 2
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd TPGT: 1 LUN: 0
iblock/iSCSI: Adding to default ALUA Target Port Group: core/alua/tg_pt_gps/default_tg_pt_gp
iSCSI_TPG[1]_LUN[0] - Activated iSCSI Logical Unit from CORE HBA: 0
LIO_Target_ConfigFS: Created Port Symlink lvm_test0 -> lun_0
iSCSI_TPG[1] - Added ACL with TCQ Depth: 16 for iSCSI Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd TPGT: 1 Initiator: iqn.1993-08.org.debian:01:2dadf92d0ef CmdSN Depth: 16
LIO_Target_ConfigFS: Initialized Initiator LUN ACL: iqn.1993-08.org.debian:01:2dadf92d0ef Mapped LUN: lun_0
iSCSI_TPG[1]_LUN[0->0] - Added RW ACL for  InitiatorNode: iqn.1993-08.org.debian:01:2dadf92d0ef
LIO_Target_ConfigFS: Created Initiator LUN ACL Symlink: iqn.1993-08.org.debian:01:2dadf92d0ef TPG LUN: lun_0 Mapped LUN: lun_0 Write Protect: OFF
Disabling iSCSI Authentication Methods for TPG: 1.
iSCSI_TPG[1] - Enabled iSCSI Target Portal Group



