From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/5] [TCM]: Add generic SAS, FC, and ISCSI CDB level emulation library handlers
Date: Wed, 12 May 2010 00:35:21 -0700
Message-ID: <1273649721-21699-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:45088 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751584Ab0ELFSf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2010 01:18:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.e>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greeting SCSI folks,

This patch series to lio-core-2.6.git/lio-4.0 adds a generic set of SAS, FC and iSCSI
ProtoID and PR TransportID I_T handlers in target_core_fabric.c following existing code
in TCM_Loop, TCM_FC and LIO-Target fabric code to allow a TCM fabric module to function
in both default single-protocol and the new optional multi-protocol fabric module.

Using this new common code, the TCM_Loop fabric module has been converted to allow for
run-time selectable CDB level fabric emulation of ProtoID and Transport I_T Nexus naming
information in a per configfs context at /sys/kernel/config/target/loopback/$WWN to individually
emulated I_T Nexuses under TCM_Loop module defined SCSI target endpoints.  This allows for
multi-fabric SCSI protocol naming information to be made available using the TCM_Loop LLD for
locally accessable Linux/SCSI struct scsi_devices and SG_IO.

So far this code has been tested on v2.6.37-rc7 with loopback Linux/SCSI struct scsi_devices
providing CDB emulation of different target port fabric naming with the above three SCSI protocols.

Using SG_IO backstores with a slightly modified version of STGT/iSCSI is also now
running with control path CDBs that allow TCM PR and ALUA emulation to function into STGT
userspace fabric ports..!  Here is a quick rundown of how the TCM_Loop + SG_IO + STGT/iSCSI
setup is looking with the series so far:

*) TCM_Loop fabric layout with single LVM IBLOCK backstore using emulated iSCSI I_T Nexus

root@target:~ tree /sys/kernel/config/target/loopback
	/sys/kernel/config/target/loopback
	|-- discovery_auth
	|-- iqn.foo.test123
	|   `-- tpgt_1
	|       |-- acls
	|       |-- attrib
	|       |-- lun
	|       |   |-- lun_0
	|       |   |   |-- alua_tg_pt_gp
	|       |   |   |-- alua_tg_pt_offline
	|       |   |   |-- alua_tg_pt_status
	|       |   |   |-- alua_tg_pt_write_md
	|       |   |   `-- virtual_scsi_port -> ../../../../../../target/core/iblock_0/lvm_test0
	|       |-- nexus
	|       |-- np
	|       `-- param
	`-- version

root@target:~ cat /sys/kernel/config/target/loopback/*/*/nexus
	iqn.1993-08.org.debian:01:2dadf92d0ef

*) STGT calls to export TCM_Loop LLD provided /dev/sg7 (see below) as a
   userspace iSCSI target port as LUN=1

tgtadm --lld iscsi --mode target --op new --tid 1 -T iqn.foo.test123
tgtadm --lld iscsi --mode logicalunit --op new --tid 1 --lun 1 -E sg --backing-store=/dev/sg7
tgtadm --lld iscsi --mode target --op bind --tid 1 -I ALL

tgtadm --lld iscsi --mode target --op show
Target 1: iqn.foo.test123
    System information:
        Driver: iscsi
        State: ready
    I_T nexus information:
        I_T nexus: 1
            Initiator: iqn.1993-08.org.debian:01:2dadf92d0ef
            Connection: 0
                IP Address: 172.16.201.129
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: IET     00010000
            SCSI SN: beaf10
            Size: 0 MB
            Online: Yes
            Removable media: No
            Backing store type: rdwr
            Backing store path: None
        LUN: 1
            Type: disk
            SCSI ID: IET     00010001
            SCSI SN: beaf11
            Size: 0 MB
            Online: Yes
            Removable media: No
            Backing store type: sg
            Backing store path: /dev/sg7
    Account information:
    ACL information:
        ALL

*) iSCSI Initiator side LUN output with IET controller LUN=0:

root@ubuntu:~# lsscsi
<SNIP>
[46:0:0:0]   storage IET      Controller       0001  -       
[46:0:0:1]   disk    LIO-ORG  IBLOCK           3.1   /dev/sdf
root@ubuntu:~# lsscsi --transport
<SNIP>
[46:0:0:0]   storage iqn.foo.test123,t,0x1           -       
[46:0:0:1]   disk    iqn.foo.test123,t,0x1           /dev/sdf

*) iSCSI Initiator side INQUIRY EVPD 0x83 output for STGT userspace prots reference
   the kernel level emulated TCM_Loop I_T Nexus information:

root@ubuntu:~# sg_inq -i /dev/sdf
<SNIP>
  Designation descriptor number 6, descriptor length: 32
    transport: Internet SCSI (iSCSI)
    id_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      iqn.foo.test123,t,0x0001

*) From the iSCSI Initiator, set the ALUA access state for the userspace STGT
   target port to Active/NonOptimized:

root@ubuntu:~# sg_stpg -v --state=1 --tp=0 /dev/sdf
    set target port groups cdb: a4 0a 00 00 00 00 00 00 00 08 00 00 

root@ubuntu:~# sg_rtpg --decode /dev/sdf
Report target port groups:
  target port group id : 0x0 , Pref=0
    target port group asymmetric access state : 0x01 (active/non optimized)
    T_SUP : 1, O_SUP : 1, U_SUP : 1, S_SUP : 1, AN_SUP : 1, AO_SUP : 1
    status code : 0x01 (target port asym. state changed by SET TARGET PORT GROUPS command)
    vendor unique status : 0x00
    target port count : 01
    Relative target port ids:
      0x01

*) TCM side kernel ring buffer messages:

Target_Core_ConfigFS: REGISTER -> group: e0c42000 name: loopback
Initialized TCM Loop Core Bus
Setup generic discovery
Setup generic wwn
Setup generic tpg
Setup generic tpg_base
Setup generic tpg_port
Setup generic tpg_lun
Setup generic tpg_np
Setup generic tpg_np_base
Setup generic tpg_attrib
Setup generic tpg_param
Setup generic tpg_nacl
Setup generic tpg_nacl_base
Setup generic tpg_nacl_attrib
Setup generic tpg_nacl_auth
Setup generic tpg_nacl_param
Setup generic tpg_mappedlun
<<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
Initialized struct target_fabric_configfs: df9a8408 for loopback
<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
TCM_LOOP[0] - Set fabric -> tcm_loop_fabric_configfs
Target_Core_ConfigFS: REGISTER -> Located fabric: loopback
Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> df9a85b0
Target_Core_ConfigFS: REGISTER -> Allocated Fabric: loopback
Target_Core_ConfigFS: REGISTER -> Set tf->tf_fabric for loopback
scsi16 : TCM_Loopback
TCM_Loop_ConfigFS: Allocated emulated Target iSCSI Address: iqn.foo.test123 at Linux/SCSI Host ID: 16
TARGET_CORE[loopback]: Allocated Normal se_portal_group_t for endpoint: iqn.foo.test123, Portal Tag: 1
TCM_Loop_ConfigFS: Allocated Emulated iSCSI Target Port iqn.foo.test123,t,0x0001
loopback_TPG[1] - Added DYNAMIC ACL with TCQ Depth: 1 for loopback Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
TARGET_CORE[loopback]: Registered fabric_sess_ptr: deddd648
TCM_Loop_ConfigFS: Established I_T Nexus to emulated iSCSI Initiator Port: iqn.1993-08.org.debian:01:2dadf92d0ef
iblock/loopback: Adding to default ALUA Target Port Group: alua/default_tg_pt_gp
loopback_TPG[1]_LUN[0] - Activated loopback Logical Unit from CORE HBA: 4
TARGET_CORE[loopback]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
scsi 16:0:1:0: Direct-Access     LIO-ORG  IBLOCK           3.1  PQ: 0 ANSI: 5
sd 16:0:1:0: Attached scsi generic sg7 type 0
TCM_Loop_ConfigFS: Port Link Successful
sd 16:0:1:0: [sdg] 3072000 512-byte logical blocks: (1.57 GB/1.46 GiB)
sd 16:0:1:0: [sdg] Write Protect is off
sd 16:0:1:0: [sdg] Mode Sense: 2f 00 00 00
sd 16:0:1:0: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdg: unknown partition table
sd 16:0:1:0: [sdg] Attached SCSI disk
Successful explict ALUA transition TG PT Group: default_tg_pt_gp ID: 0 from primary access state Active/NonOptimized to Active/NonOptimized

*) TCM lsmod

Module                  Size  Used by
tcm_loop               11907  6 
target_core_mod       250789  28 tcm_loop
scsi_tgt                8650  1 target_core_mod
configfs               20508  2 target_core_mod
dm_mirror              11237  0 
dm_region_hash          7906  1 dm_mirror
dm_log                  7103  2 dm_mirror,dm_region_hash
dm_snapshot            25880  0 
pcnet32                27665  0 
mii                     3430  1 pcnet32
sg                     16603  3 

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org

Nicholas Bellinger (5):
  [TCM_Loop]: Add proper HBA defaults to struct Scsi_Host
  [TCM]: Add TPG parameter to struct
    target_core_fabric_ops->get_fabric_proto_ident()
  [TCM]: Add TPG parameter to struct
    target_core_fabric_ops->tpg_parse_pr_out_transport_id()
  [TCM]: Add generic ProtoID and TransportID fabric handlers for SAS,
    FC, and iSCSI
  [TCM_Loop]: Add support for multi-fabric CDB level emulation

 drivers/target/Kbuild                          |    1 +
 drivers/target/lio-target/iscsi_target.c       |    2 +-
 drivers/target/lio-target/iscsi_target.h       |    2 +-
 drivers/target/lio-target/iscsi_target_tpg.c   |    1 +
 drivers/target/lio-target/iscsi_target_tpg.h   |    3 +-
 drivers/target/target_core_fabric_lib.c        |  456 ++++++++++++++++++++++++
 drivers/target/target_core_pr.c                |   10 +-
 drivers/target/target_core_transport.c         |    6 +-
 drivers/target/tcm_fc/tfc_conf.c               |    5 +-
 drivers/target/tcm_loop/tcm_loop_configfs.c    |  140 ++++++--
 drivers/target/tcm_loop/tcm_loop_core.h        |   21 +-
 drivers/target/tcm_loop/tcm_loop_fabric.c      |  150 +++++---
 drivers/target/tcm_loop/tcm_loop_fabric.h      |    5 +-
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |    9 +-
 include/target/target_core_fabric_lib.h        |   28 ++
 include/target/target_core_fabric_ops.h        |    5 +-
 16 files changed, 727 insertions(+), 117 deletions(-)
 create mode 100644 drivers/target/target_core_fabric_lib.c
 create mode 100644 include/target/target_core_fabric_lib.h

