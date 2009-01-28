From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] [Target_Core_Mod] Add running SPC-3 Persistent
	Reservation logic
Date: Tue, 27 Jan 2009 23:40:01 -0800
Message-ID: <1233128401.6442.148.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:29308 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752273AbZA1HlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2009 02:41:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Joel Becker <joel.becker@oracle.com>, Hannes Reinecke <hare@suse.de>, Ming Zhang <blackmagic02881@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Rafiu Fakunle <rafiu@openfiler.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Greetings all,

This patch series adds the first running SPC-3 compliant Persistent Reservation
emulation support for PROUT REGISTER -> PROUT RESERVE -> PRIN READ_RESERVATIONS ->
PROUT RELEASE -> PROUT UNREGISTER, tested and running with Doug Gilbert's
very excellent sg_persist command.  This was tested against Open/iSCSI Initiators
running LIO-Target iSCSI/TCP, and Core-iSCSI Initiators running LIO-Target iSCSI/SCTP.

I will be adding information about TCM/LIO-Target v3.0 and LIO-Target v2.9 usage wrt
Persistent Reservations on to the http://Linux-iSCSI.org wiki at some point as well,
so folks can get their own SPC-3 compliant PR enabled Linux/iSCSI Targets up and running!

This patch is made against lio-core-2.6.git/master and tested on v2.6.29-rc2 x86
32-bit HVM.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Subject: [PATCH 1/2] [Target_Core_Mod/PERSISTENT_RESERVATION]: Add Service Action RESERVE/RELEASE w/ all_tg_pt=[0,1]
Subject: [PATCH 2/2] [Target_Core_Mod/ConfigFS]: Updates for PERSISTENT_RESERVE

Unpacking objects: 100% (12/12), done.
>From /pub/scm/linux/kernel/git/nab/lio-core-2.6
 * branch            master     -> FETCH_HEAD
Updating a4bcd2c..ab56467
Fast forward
 drivers/lio-core/target_core_base.h     |    3 +-
 drivers/lio-core/target_core_configfs.c |  116 +++++++++--
 drivers/lio-core/target_core_pr.c       |  354 ++++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_pr.h       |    1 +
 4 files changed, 446 insertions(+), 28 deletions(-)

Here is what it looks like in action, starting from the start, with no
PR registrations or reservations, lets have a look via Target_Core_Mod/ConfigFS
for a Linux LVM block device:

*) The setup...

Here is waht things now look like in Target_Core_Mod/ConfigFS for each
$HBA/$STORAGE_OBJECT, in this example, a Linux LVM struct block_device named
'lvm_test0' is used for the ConfigFS $STORAGE_OBJECT:

`-- target
    |-- core
    |   |-- iblock_0
    |   |   |-- hba_info
    |   |   `-- lvm_test0
	<SNIP>
    |   |       |-- pr
    |   |       |   |-- res_holder
    |   |       |   |-- res_pr_all_tgt_pts
    |   |       |   |-- res_pr_generation
    |   |       |   |-- res_pr_registered_i_pts
    |   |       |   |-- res_pr_type
    |   |       |   `-- res_type
    |   |       `-- wwn
    |   |           |-- evpd_assoc_logical_unit
    |   |           |-- evpd_assoc_scsi_target_device
    |   |           |-- evpd_assoc_target_port
    |   |           |-- evpd_protocol_identifier
    |   |           `-- evpd_unit_serial
	<SNIP>

initiator# # sg_persist --in --report-capabilities -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  v3.0
  Peripheral device type: disk
    Persistent Reservation In cmd: 5e 02 00 00 00 00 00 20 00 00 
Report capabilities response:
  Compatible Reservation Handling(CRH): 0
  Specify Initiator Ports Capable(SIP_C): 0
  All Target Ports Capable(ATP_C): 1
  Persist Through Power Loss Capable(PTPL_C): 0
  Type Mask Valid(TMV): 1
  Allow commands: 1
  Persist Through Power Loss Active(PTPL_A): 0
    Support indicated in Type mask:
      Write Exclusive, all registrants: 0
      Exclusive Access, registrants only: 0
      Write Exclusive, registrants only: 0
      Exclusive Access: 1
      Write Exclusive: 1
      Exclusive Access, all registrants: 0

target# cat /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/*
No SPC-3 Reservation holder
No SPC-3 Reservation holder
0x00000000
SPC-3 PR Registrations:
None
No SPC-3 Reservation holder
SPC3_PERSISTENT_RESERVATIONS

*) PROUT REGISTER:

initiator# sg_persist --out --register --param-sark=0x5678efff --param-alltgpt -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  v3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 00 00 00 00 00 00 00 18 00 
PR out: command (Register) successful

target# cat /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/*
No SPC-3 Reservation holder
No SPC-3 Reservation holder
0x00000001
SPC-3 PR Registrations:
iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000005678efff PRgen: 0x00000000
No SPC-3 Reservation holder
SPC3_PERSISTENT_RESERVATIONS

*) PROUT RESERVE: With a prout_type=1 for PR Type: WRITE_EXCLUSIVE (0x01)

initiator# sg_persist --out --reserve --param-rk=0x5678efff --prout-type=1 -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  v3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 01 01 00 00 00 00 00 18 00 
PR out: command (Reserve) successful

target# cat /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/*
SPC-3 Reservation FABRIC[iSCSI]: Initiator: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 Reservation holder: All Target Ports reserved
0x00000001
SPC-3 PR Registrations:
iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000005678efff PRgen: 0x00000000
SPC-3 Reservation Type: Write Exclusive Access
SPC3_PERSISTENT_RESERVATIONS

*) PRIN READ_RESERVATIONS:

initiator# sg_persist --in --read-reservation -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  v3.0
  Peripheral device type: disk
    Persistent Reservation In cmd: 5e 01 00 00 00 00 00 20 00 00 
  PR generation=0x1, Reservation follows:
    Key=0x5678efff
    scope: LU_SCOPE,  type: Write Exclusive

*) PROUT RELEASE:

initiator# sg_persist --out --release --param-rk=0x5678efff --prout-type=1 -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  v3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 02 01 00 00 00 00 00 18 00 
PR out: command (Release) successful

target# cat /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/*
No SPC-3 Reservation holder
No SPC-3 Reservation holder
0x00000001
SPC-3 PR Registrations:
iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000005678efff PRgen: 0x00000000
No SPC-3 Reservation holder
SPC3_PERSISTENT_RESERVATIONS

*) PRIN UNREGISTER:

initiator# sg_persist --out --register --param-rk=0x5678efff --param-sark=0 -v /dev/sde
    inquiry cdb: 12 00 00 00 24 00 
  LIO-ORG  IBLOCK  v3.0
  Peripheral device type: disk
    Persistent Reservation Out cmd: 5f 00 00 00 00 00 00 00 18 00 
PR out: command (Register) successful

target#cat /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/*
No SPC-3 Reservation holder
No SPC-3 Reservation holder
0x00000001
SPC-3 PR Registrations:
None
No SPC-3 Reservation holder
SPC3_PERSISTENT_RESERVATIONS

Comments..?

--nab

