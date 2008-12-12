From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH Target_Core_Mod 0/12]: Make v3.0 storage engine code generic
Date: Fri, 12 Dec 2008 01:26:58 -0800
Message-ID: <1229074018.4153.630.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:20802 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756204AbYLLJ1B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 04:27:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@linux-foundation.org>

Greetings all,

This patch series adds generic se_portal_group_t and se_node_acl_t
functionality.  It also removes virtually all LIO-Target and iSCSI
target code from Target_Core_Mod/ConfigFS.  They are made against
against lio-core-2.6.git/master and tested on
v2.6.28-rc7.

To see the bleeding edge of generic target development using multiple
Linux storage subsystems using ConfigFS, please have a look at:

http://linux-iscsi.org/index.php/Target_Core_Mod/ConfigFS

Here are the patches:

[Target_Core_Mod 1/12] Add generic target portal group infrastructure
[Target_Core_Mod 2/12]: Add generic target se_device_t and LUN ACL infrastructure
[Target_Core_Mod 3/12]: Update struct target_core_fabric_ops API
[Target_Core_Mod 4/12]: Updates for target_core_base.h
[Target_Core_Mod 5/12]: Remove iSCSI includes from target_core_seobj.c
[Target_Core_Mod 6/12]: Updates for target_core_hba.c
[Target_Core_Mod 7/12]: Update generic REPORT_LUN code
[Target_Core_Mod 8/12]: Update SE Object code for target_core_base.h
[Target_Core_Mod 9/12]: Update PSCSI, IBLOCK, FILEIO and RAMDISK subsystem plugins
[Target_Core_Mod/MIB 10/12]: Update SCSI MIBs
[Target_Core_Mod 11/12]: Update target_core_transport.c for new generic code
[Target_Core_Mod/ConfigFS 12/12]: Remove do_configfs_mkdir() and do_configfs_rmdir()


Here is what it looks from dmesg:

TARGET_CORE[0]: Loading Generic Kernel Storage Engine: v3.0.0 on Linux/i686 on 2.6.28-rc7
TARGET_CORE[0]: Initialized ConfigFS Fabric Infrastructure: v1.0.0 on Linux/i686 on 2.6.28-rc7
SE_PC[1] - Registered Plugin Class: TRANSPORT
PLUGIN_TRANSPORT[1] - pscsi registered
PLUGIN_TRANSPORT[4] - iblock registered
PLUGIN_TRANSPORT[5] - rd_dr registered
PLUGIN_TRANSPORT[6] - rd_mcp registered
PLUGIN_TRANSPORT[7] - fileio registered
SE_PC[2] - Registered Plugin Class: OBJ
PLUGIN_OBJ[1] - dev registered
Target_Core_ConfigFS: Located se_plugin: ca3c1090 plugin_name: iblock hba_type: 4 plugin_dep_id: 0
CORE_HBA[0] - Linux-iSCSI.org iBlock HBA Driver v3.0 on Generic Target Core Stack v3.0.0
CORE_HBA[0] - Attached iBlock HBA: 0 to Generic Target Core TCQ Depth: 512
CORE_HBA[0] - Attached HBA to Generic Target Core
IBLOCK: Allocated ib_dev for lvm_test0
Target_Core_ConfigFS: Allocated se_subsystem_dev_t: cfab7400 se_dev_su_ptr: cf38f600
IBLOCK: Claiming struct block_device: cf636f00
IBLOCK: Created bio_set() for major/minor: 254:2
CORE_iBLOCK[0] - Activating Device with TCQ: 0 at Major: 254 Minor 2
  Vendor: LIO-ORG   Model: IBLOCK            Revision: v3.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
T10 EVPD Unit Serial Number: 1234567890:0_254_2
T10 EVPD Device Identifier: LIO-ORG IBLOCK:1234567890:0_254_2
Target_Core_ConfigFS: Registered iblock se_dev->se_dev_ptr: c8a4e000 from fd
Target_Core_ConfigFS: Located se_plugin: ca3c1024 plugin_name: pscsi hba_type: 1 plugin_dep_id: 0
CORE_HBA[1] - Linux-iSCSI.org Parallel SCSI HBA Driver v3.0 on Generic Target Core Stack v3.0.0
CORE_HBA[1] - MPT SPI Host
CORE_HBA[1] - Attached Parallel SCSI HBA to Generic Target Core with TCQ Depth: 127 MaxSectors: 8192
CORE_HBA[1] - Attached HBA to Generic Target Core
PSCSI: Allocated pdv: c7d63220 for sdd
Target_Core_ConfigFS: Allocated se_subsystem_dev_t: c8b7f200 se_dev_su_ptr: c7d63220
PSCSI: Claiming cf3f0000 Major:Minor - 8:48
CORE_PSCSI[0] - Activating Device with TCQ: 32 at Parallel SCSI Location (Channel/Target/LUN) 0/3/0
  Vendor: VMware,   Model: VMware Virtual S  Revision: 1.0 
  Type:   Direct-Access                      ANSI SCSI revision: 02
PSCSI Status Byte exception at task: cf9ee400 CDB: 0x12 Result: 0x08000002
CORE_PSCSI[0] - Added TYPE_DISK for 0:3:0
Target_Core_ConfigFS: Registered pscsi se_dev->se_dev_ptr: cedca400 from fd

Comments..?

--nab


