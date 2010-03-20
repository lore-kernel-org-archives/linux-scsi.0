From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [ANNOUNCE] TCM/ConfigFS v3.4.0-rc1
Date: Fri, 19 Mar 2010 19:41:25 -0700
Message-ID: <1269052885.23779.95.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, openfcoe-devel <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.c>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Florian Haas <florian.haas-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Greetings all,

It is my great honor to announce the Target_Core_Mod/ConfigFS infrastructure project
has reached v3.4.0-rc1 and is again tracking linux-2.6.git HEAD at v2.6.34-rc1.  The
kernel code can be found here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

With this release marks the merge of the Open-FCoE.org based target module (tcm_fc) for
TCM/ConfigFS 3.x contributed by Joe Eykholt as the third fabric module available in
lio-core-2.6.git/master. This has included in a seperate release announcement, and
information for the TCM Open-FCoE.org target module can be found here:

http://www.linux-iscsi.org/index.php/Openfcoe

This release also reaches the milestone of TCM/ConfigFS becoming the first and only Linux
target mode project to run in multi-fabric mode across all known feature bits for SPC-4
defined persistent reservations (PR) using iSCSI, FCoE and Virtual SAS ports.  This patch series
and test case to make that happen for PR features SPEC_I_PT=1 and REGISTER_AND_MOVE was originally
posted here:

http://permalink.gmane.org/gmane.linux.scsi/57831

For more information about TCM/ConfigFS and fabric module usage with PR+ALUA, please have a look at:

http://www.linux-iscsi.org/index.php/Target_Core_Mod/ConfigFS
http://www.linux-iscsi.org/index.php/Persistent_Reservations
http://www.linux-iscsi.org/index.php/ALUA

Finally as no announcement would be complete without an multi-fabric demonstration, here is how
explict/implict ALUA multipath using upstream scsi_dh_alua is looking with Open-iSCSI + Open-FCoE
Initiators between TCM LIO-Target iSCSI and Open-FCoE.org target ports.  This is done by seperate
the iSCSi and FCoE Target ports into two different ALUA Target Port Groups (1gb_iscsi and 1gb_fcoe
respectively) for the same TCM/FILEIO LUN backstore.

Any constructive comments or questions are welcome!

--nab

*) Example /etc/multipath.conf

defaults {
        udev_dir                /dev
        polling_interval        2
        default_getuid_callout  "/lib/udev/scsi_id -g -u -s /block/%n"
        user_friendly_names     yes
}

devices {
	device {
		vendor "LIO-ORG"
		product "FILEIO"
		path_grouping_policy group_by_prio
		path_checker tur
		prio_callout "/sbin/mpath_prio_alua /dev/%n"
		hardware_handler "1 alua"
	}
}

*) Create fcoe association for eth0 on initiator side:

echo eth0 > /sys/module/fcoe/parameters/create

[  853.184640] scsi0 : FCoE Driver
[  853.186064] host0: libfc: Link up on port (     0)
[  856.754764] host0: Assigned Port ID  10101
[  856.758376] scsi 0:0:0:0: Direct-Access     LIO-ORG  FILEIO           3.1  PQ: 0 ANSI: 5
[  856.818511] sd 0:0:0:0: [sda] READ CAPACITY(16) failed
[  856.819201] sd 0:0:0:0: [sda] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
[  856.820127] sd 0:0:0:0: [sda] Sense not available.
[  856.820964] sd 0:0:0:0: [sda] 97656251 512-byte logical blocks: (50.0 GB/46.5 GiB)
[  856.822580] sd 0:0:0:0: [sda] Write Protect is off
[  856.823230] sd 0:0:0:0: [sda] Mode Sense: 2f 00 00 00
[  856.823640] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  856.825018] sd 0:0:0:0: [sda] READ CAPACITY(16) failed
[  856.825688] sd 0:0:0:0: [sda] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
[  856.826620] sd 0:0:0:0: [sda] Sense not available.
[  856.828304]  sda: unknown partition table
[  856.830403] sd 0:0:0:0: [sda] READ CAPACITY(16) failed
[  856.831109] sd 0:0:0:0: [sda] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
[  856.832039] sd 0:0:0:0: [sda] Sense not available.
[  856.833689] sd 0:0:0:0: [sda] Attached SCSI disk
<SNIP>
[  857.265004] alua: device handler registered
[  857.290275] device-mapper: multipath round-robin: version 1.0.0 loaded
[  857.291599] sd 0:0:0:0: alua: supports implicit and explicit TPGS
[  857.292794] sd 0:0:0:0: alua: port group 00 rel port 02
[  857.293645] sd 0:0:0:0: alua: port group 00 state A supports TOUSNA
[  857.300249] sd 0:0:0:0: alua: port group 00 state A supports TOUSNA

*) Create iSCSI session using Open-iSCSI:

iscsiadm -m node -T iqn.2003-01.org.linux-iscsi.lenny64guest1.x8664:sn.3074797efee0 --portal 192.168.0.250 --login

[  893.969954] scsi1 : iSCSI Initiator over TCP/IP
[  894.286774] scsi 1:0:0:0: Direct-Access     LIO-ORG  FILEIO           3.1  PQ: 0 ANSI: 5
[  894.289767] sd 1:0:0:0: [sdb] 97656251 512-byte logical blocks: (50.0 GB/46.5 GiB)
[  894.292437] sd 1:0:0:0: [sdb] Write Protect is off
[  894.293254] sd 1:0:0:0: [sdb] Mode Sense: 2f 00 00 00
[  894.293951] sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  894.297422]  sdb: unknown partition table
[  894.304374] sd 1:0:0:0: [sdb] Attached SCSI disk
[  894.976821] sd 1:0:0:0: alua: supports implicit and explicit TPGS
[  894.978378] sd 1:0:0:0: alua: port group 00 rel port 01
[  894.979626] sd 1:0:0:0: alua: port group 00 state A supports TOUSNA
[  894.989850] sd 1:0:0:0: alua: port group 00 state A supports TOUSNA
[  894.990726] sd 0:0:0:0: alua: port group 00 state A supports TOUSNA

*) lsscsi and multipath output:

lenny64guest0:~# lsscsi
[0:0:0:0]    disk    LIO-ORG  FILEIO           3.1   /dev/sda
[1:0:0:0]    disk    LIO-ORG  FILEIO           3.1   /dev/sdb
lenny64guest0:~# lsscsi --transport
[0:0:0:0]    disk    fc:0x200000e081c090b3,0x010102  /dev/sda
[1:0:0:0]    disk    iqn.2003-01.org.linux-iscsi.lenny64guest1.x8664:sn.3074797efee0,t,0x1  /dev/sdb

lenny64guest0:~# multipath -ll
mpath2 (36001405f776de20dc416d4382d8b16d0) dm-0 LIO-ORG ,FILEIO        
[size=47G][features=0][hwhandler=1 alua]
\_ round-robin 0 [prio=100][active]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
 \_ 0:0:0:0 sda 8:0   [active][ready]

*) Target side ALUA Target Port Group output

lenny64guest1:/sys/kernel/config/target# tcm_node --listaluatpgs fileio_0/myfile
\------> 1g_fcoe  Target Port Group ID: 2
         Active ALUA Access Type(s): Implict and Explict
         Primary Access State: Active/NonOptimized
         Primary Access Status: Altered by Explict STPG
         Preferred Bit: 0
         Active/NonOptimized Delay in milliseconds: 100
         Transition Delay in milliseconds: 0
         \------> TG Port Group Members
             fc/20:00:00:e0:81:c0:90:b3/tpgt_1/lun_0
\------> 1g_iscsi  Target Port Group ID: 1
         Active ALUA Access Type(s): Implict and Explict
         Primary Access State: Active/Optimized
         Primary Access Status: Altered by Explict STPG
         Preferred Bit: 0
         Active/NonOptimized Delay in milliseconds: 100
         Transition Delay in milliseconds: 0
         \------> TG Port Group Members
             iSCSI/iqn.2003-01.org.linux-iscsi.lenny64guest1.x8664:sn.3074797efee0/tpgt_1/lun_0
\------> default_tg_pt_gp  Target Port Group ID: 0
         Active ALUA Access Type(s): Implict and Explict
         Primary Access State: Active/NonOptimized
         Primary Access Status: Altered by Explict STPG
         Preferred Bit: 0
         Active/NonOptimized Delay in milliseconds: 100
         Transition Delay in milliseconds: 0
         \------> TG Port Group Members
             No Target Port Group Members

*) TCM, LIO-Target and TCM_FC configfs layout

|-- core
|   |-- alua
|   |   `-- lu_gps
|   |       `-- default_lu_gp
|   |           |-- lu_gp_id
|   |           `-- members
|   `-- fileio_0
|       |-- hba_info
|       |-- hba_mode
|       `-- myfile
|           |-- alias
|           |-- alua
|           |   |-- 1g_fcoe
|           |   |   |-- alua_access_state
|           |   |   |-- alua_access_status
|           |   |   |-- alua_access_type
|           |   |   |-- alua_write_metadata
|           |   |   |-- members
|           |   |   |-- nonop_delay_msecs
|           |   |   |-- preferred
|           |   |   |-- tg_pt_gp_id
|           |   |   `-- trans_delay_msecs
|           |   |-- 1g_iscsi
|           |   |   |-- alua_access_state
|           |   |   |-- alua_access_status
|           |   |   |-- alua_access_type
|           |   |   |-- alua_write_metadata
|           |   |   |-- members
|           |   |   |-- nonop_delay_msecs
|           |   |   |-- preferred
|           |   |   |-- tg_pt_gp_id
|           |   |   `-- trans_delay_msecs
|           |   `-- default_tg_pt_gp
|           |       |-- alua_access_state
|           |       |-- alua_access_status
|           |       |-- alua_access_type
|           |       |-- alua_write_metadata
|           |       |-- members
|           |       |-- nonop_delay_msecs
|           |       |-- preferred
|           |       |-- tg_pt_gp_id
|           |       `-- trans_delay_msecs
|           |-- alua_lu_gp
|           |-- attrib
|           |   |-- block_size
|           |   |-- emulate_tas
|           |   |-- emulate_ua_intlck_ctrl
|           |   |-- hw_block_size
|           |   |-- hw_max_sectors
|           |   |-- hw_queue_depth
|           |   |-- max_sectors
|           |   |-- queue_depth
|           |   `-- task_timeout
|           |-- control
|           |-- enable
|           |-- fd
|           |-- info
|           |-- pr
|           |   |-- res_aptpl_active
|           |   |-- res_aptpl_metadata
|           |   |-- res_holder
|           |   |-- res_pr_all_tgt_pts
|           |   |-- res_pr_generation
|           |   |-- res_pr_holder_tg_port
|           |   |-- res_pr_registered_i_pts
|           |   |-- res_pr_type
|           |   `-- res_type
|           |-- snap
|           |   |-- check_interval
|           |   |-- contact
|           |   |-- create_interval
|           |   |-- enabled
|           |   |-- lv_group
|           |   |-- lvc_size
|           |   |-- max_snapshots
|           |   |-- max_warn
|           |   |-- permissions
|           |   |-- pid
|           |   |-- usage
|           |   |-- usage_warn
|           |   `-- vgs_usage_warn
|           |-- udev_path
|           `-- wwn
|               |-- vpd_assoc_logical_unit
|               |-- vpd_assoc_scsi_target_device
|               |-- vpd_assoc_target_port
|               |-- vpd_protocol_identifier
|               `-- vpd_unit_serial
|-- fc
|   |-- 20:00:00:e0:81:c0:90:b3
|   |   `-- tpgt_1
|   |       |-- acl
|   |       |   `-- 20:00:00:e0:81:c0:90:b2
|   |       |       |-- auth
|   |       |       |   |-- node_name
|   |       |       |   `-- port_name
|   |       |       `-- lun_0
|   |       |           `-- lun_0 -> ../../../../../../../target/fc/20:00:00:e0:81:c0:90:b3/tpgt_1/lun/lun_0
|   |       `-- lun
|   |           `-- lun_0
|   |               |-- alua_tg_pt_gp
|   |               |-- alua_tg_pt_offline
|   |               |-- alua_tg_pt_status
|   |               |-- alua_tg_pt_write_md
|   |               `-- tcm_fc_port -> ../../../../../../target/core/fileio_0/myfile
|   `-- version
|-- iscsi
|   |-- discovery_auth
|   |   |-- authenticate_target
|   |   |-- enforce_discovery_auth
|   |   |-- password
|   |   |-- password_mutual
|   |   |-- userid
|   |   `-- userid_mutual
|   |-- iqn.2003-01.org.linux-iscsi.lenny64guest1.x8664:sn.3074797efee0
|   |   `-- tpgt_1
|   |       |-- acls
|   |       |   `-- iqn.1993-08.org.debian:01:5640fc164638
|   |       |       |-- attrib
|   |       |       |   |-- dataout_timeout
|   |       |       |   |-- dataout_timeout_retries
|   |       |       |   |-- default_erl
|   |       |       |   |-- nopin_response_timeout
|   |       |       |   |-- nopin_timeout
|   |       |       |   |-- random_datain_pdu_offsets
|   |       |       |   |-- random_datain_seq_offsets
|   |       |       |   `-- random_r2t_offsets
|   |       |       |-- auth
|   |       |       |   |-- authenticate_target
|   |       |       |   |-- password
|   |       |       |   |-- password_mutual
|   |       |       |   |-- userid
|   |       |       |   `-- userid_mutual
|   |       |       |-- cmdsn_depth
|   |       |       |-- info
|   |       |       |-- lun_0
|   |       |       |   |-- abe06ac681 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.lenny64guest1.x8664:sn.3074797efee0/tpgt_1/lun/lun_0
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
|   |       |       |-- 9b5222b0c6 -> ../../../../../../target/core/fileio_0/myfile
|   |       |       |-- alua_tg_pt_gp
|   |       |       |-- alua_tg_pt_offline
|   |       |       |-- alua_tg_pt_status
|   |       |       `-- alua_tg_pt_write_md
|   |       |-- np
|   |       |   `-- 192.168.0.250:3260
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

*) lsmod output on target side:

lenny64guest1:/sys/kernel/config/target# lsmod
Module                  Size  Used by
tcm_fc                 21970  6 
fcoe                   16843  1 
libfcoe                10914  1 fcoe
libfc                  72344  3 tcm_fc,fcoe,libfcoe
scsi_transport_fc      36413  2 fcoe,libfc
iscsi_target_mod      212124  7 
target_core_mod       243050  23 tcm_fc,iscsi_target_mod
scsi_tgt                8418  2 scsi_transport_fc,target_core_mod
configfs               19535  4 tcm_fc,iscsi_target_mod,target_core_mod
