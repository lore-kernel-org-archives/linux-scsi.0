From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/6] [Target_Core_Mod/ALUA]: Add Logical Unit and Target
	Port Group infrastructure
Date: Thu, 05 Feb 2009 23:55:22 -0800
Message-ID: <1233906922.12375.353.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:31568 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752622AbZBFH43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2009 02:56:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, Rafiu Fakunle <rafiu@openfiler.com>

Greetings all,

The princible functionality for SPC-3 compliant ALUA Logical Unit and Target Port
groups is now up and running with Target_Core_Mod/ConfigFS and LIO-Target/ConfigFS.
So far, you can create, change, associate ConfigFS objects and release ALUA Logical
Unit and Target Port group abstractions through /sys/kernel/config/target/core/alua.

Changing of alua_access_state via ConfigFS is not supported just yet, but the transition
between Active/Optimized and Active/Non-Optimized should be easy enough.

This patch is made against lio-core-2.6.git/master
and tested on v2.6.29-rc2 x86 32-bit HVM.  The lio-core-2.6.git tree can be
found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Here is what it looks like in action so far:

*) Target ConfigFS side:

# Create a ALUA Logical Unit Group
target:/sys/kernel/config/target/core# mkdir -p alua/lu_gps/lio_lun_group
# Create two ALUA Target Port Groups
target:/sys/kernel/config/target/core# mkdir -p alua/tg_pt_gps/lio_west_group
target:/sys/kernel/config/target/core# mkdir -p alua/tg_pt_gps/lio_east_group
target:/sys/kernel/config/target/core# tree alua/
alua/
|-- lu_gps
|   |-- default_lu_gp
|   |   |-- alua_access_state
|   |   |-- lu_gp_id
|   |   `-- members
|   `-- lio_lun_group
|       |-- alua_access_state
|       |-- lu_gp_id
|       `-- members
`-- tg_pt_gps
    |-- default_tg_pt_gp
    |   |-- alua_access_state
    |   |-- members
    |   `-- tg_pt_gp_id
    |-- lio_east_group
    |   |-- alua_access_state
    |   |-- members
    |   `-- tg_pt_gp_id
    `-- lio_west_group
        |-- alua_access_state
        |-- members
        `-- tg_pt_gp_id

7 directories, 15 files

# Create an ALUA Logical Unit Group assocation for iblock_0/lvm_test0 to lio_lun_group
target:/sys/kernel/config/target/core# echo lio_lun_group > iblock_0/lvm_test0/alua_lu_gp 

# Create an Target Port Group assocation for lio_west_group
target:/sys/kernel/config/target/iscsi/$TARGETNAME/$TPGT/lun/lun_0# echo lio_west_group > alua_tg_pt_gp 

# Create an Target Port Group assocation for lio_east_group
target:/sys/kernel/config/target/iscsi/$ANOTHER_TARGETNAME/$TPGT/lun/lun_0# echo lio_east_group > alua_tg_pt_gp 

*) From target side dmesg:

Target_Core_ConfigFS: Allocated ALUA Logical Unit Group: core/alua/lu_gps/lio_lun_group, ID: 1
Target_Core_ConfigFS: Allocated ALUA Target Port Group: core/alua/tg_pt_gps/lio_west_group, ID: 1
Target_Core_ConfigFS: Allocated ALUA Target Port Group: core/alua/tg_pt_gps/lio_east_group, ID: 2
Target_Core_ConfigFS: Moving iblock_0/lvm_test0 to ALUA LU Group: core/alua/lu_gps/lio_lun_group, ID: 1
Target_Core_ConfigFS: Moving iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd/tpgt_1/lun_0 to ALUA Target Port Group: core/alua/tg_pt_gps/lio_east_group, ID: 2
Target_Core_ConfigFS: Moving iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun_0 to ALUA Target Port Group: core/alua/tg_pt_gps/lio_west_group, ID: 1

*) From the iSCSI Initiator side connected to LIO-Target v3.0 iSCSI Target Ports using sg3_utils:

# First LIO-Target iSCSI Target port:
initiator# sg_inq -v -l 16384 -p 0x83 /dev/sde
VPD INQUIRY: Device Identification page
    inquiry cdb: 12 01 83 00 fc 00 
  Designation descriptor number 1, descriptor length: 58
    id_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: LIO-ORG
      vendor specific: IBLOCK:eEaqKo-gYF8-vnDA-jJhf-Xqzy-pjGF-G6Y50v
  Designation descriptor number 2, descriptor length: 8
    transport: Internet SCSI (iSCSI)
    id_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x1
  Designation descriptor number 3, descriptor length: 8
    transport: Internet SCSI (iSCSI)
    id_type: Target port group,  code_set: Binary
    associated with the target port
      Target port group: 0x1
  Designation descriptor number 4, descriptor length: 8
    id_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
      Logical unit group: 0x1
  Designation descriptor number 5, descriptor length: 72
    transport: Internet SCSI (iSCSI)
    id_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0,t,0x0001

# Second LIO-Target iSCSI Target Port
initiator# sg_inq -v -l 16384 -p 0x83 /dev/sdf
VPD INQUIRY: Device Identification page
    inquiry cdb: 12 01 83 00 fc 00 
  Designation descriptor number 1, descriptor length: 58
    id_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: LIO-ORG
      vendor specific: IBLOCK:eEaqKo-gYF8-vnDA-jJhf-Xqzy-pjGF-G6Y50v
  Designation descriptor number 2, descriptor length: 8
    transport: Internet SCSI (iSCSI)
    id_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x2
  Designation descriptor number 3, descriptor length: 8
    transport: Internet SCSI (iSCSI)
    id_type: Target port group,  code_set: Binary
    associated with the target port
      Target port group: 0x2
  Designation descriptor number 4, descriptor length: 8
    id_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
      Logical unit group: 0x1
  Designation descriptor number 5, descriptor length: 72
    transport: Internet SCSI (iSCSI)
    id_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd,t,0x0001

# REPORT_TARGET_PORT_GROUPS response data:
initiator# sg_rtpg -v /dev/sde
    report target port groups cdb: a3 0a 00 00 00 00 00 00 04 00 00 00 
Report list length = 36
Report target port groups:
  target port group id : 0x0 , Pref=0
    target port group asymmetric access state : 0x00
    T_SUP : 0, O_SUP : 0, U_SUP : 0, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 00
  target port group id : 0x1 , Pref=0
    target port group asymmetric access state : 0x00
    T_SUP : 0, O_SUP : 0, U_SUP : 0, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 01
    Relative target port ids:
      0x01
  target port group id : 0x2 , Pref=0
    target port group asymmetric access state : 0x00
    T_SUP : 0, O_SUP : 0, U_SUP : 0, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x02
    vendor unique status : 0x00
    target port count : 01
    Relative target port ids:
      0x02

Comments folks..?

--nab

[PATCH 1/6] [Target_Core_Mod/ALUA]: Add support for SPC-3 Target Port and Logical Unit Groups
[PATCH 2/6] [Target_Core_Mod/ALUA]: Add setup for target_core_device.c code
[PATCH 3/6] [Target_Core_Mod]: Update FILEIO and RAMDISK subsystem plugins to SPC-3 revision identifer
[PATCH 4/6] [Target_Core_Mod/ALUA]: Add ALUA struct kmem_caches and update EVPD 0x83 information
[PATCH 5/6] [Target_Core_Mod/ConfigFS]: Add ALUA infrastructure
[PATCH 6/6] [LIO-Target/ConfigFS]: Add ALUA wrapper functions to Target_Core_Mod/ALUA code

>From /pub/scm/linux/kernel/git/nab/lio-core-2.6
 * branch            master     -> FETCH_HEAD
Updating 3466517..07c4589
Fast forward
 drivers/lio-core/iscsi_target_configfs.c |   42 +--
 drivers/lio-core/target_core_alua.c      |  496 +++++++++++++++++++++++----
 drivers/lio-core/target_core_alua.h      |   14 +
 drivers/lio-core/target_core_base.h      |   42 +++
 drivers/lio-core/target_core_configfs.c  |  564 +++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_device.c    |   16 +
 drivers/lio-core/target_core_file.c      |    2 +-
 drivers/lio-core/target_core_rd.c        |    2 +-
 drivers/lio-core/target_core_transport.c |   56 +++-
 9 files changed, 1113 insertions(+), 121 deletions(-)


