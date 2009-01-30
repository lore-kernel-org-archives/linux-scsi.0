From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/PERSISTENT_RESERVATION]: Add PRIN SA
	READ_FULL_STATUS and LIO-Target iSCSI support
Date: Fri, 30 Jan 2009 01:30:34 -0800
Message-ID: <1233307834.6442.248.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:40017 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751562AbZA3Jbm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2009 04:31:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Rafiu Fakunle <rafiu@openfiler.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, Ming Zhang <blackmagic02881@gmail.com>

Greetings All,

This patch series adds support for PERSISTENT_RESERVE_IN Service Action
READ_FULL_STATUS for Target_Core_Mod/ConfigFS, and adds SPC-4 iSCSI TransportID
support to LIO-Target v3.0.

Here is what an active running SPC-3 compliant PERSISTENT RESERVATION setup looks
like using the PRIN SA READ_FULL_STATUS functionality with 2x active registrations
(debian w/ all_tg_pt=1 and opensuse w/ all_tg_pt=0 registrations) and an active
reservation held (debian IQN):

*) From Linux/iSCSI Initiators side using sg_persisnt from sg3_utils:

opensuse:~ # sg_persist -in --read-full-status -v /dev/sdb
    Persistent Reservation In cmd: 5e 03 00 00 00 00 00 20 00 00 
  PR generation=0x2
    Key=0x5678efff
      All target ports bit set
      << Reservation holder >>
      scope: LU_SCOPE,  type: Write Exclusive
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1993-08.org.debian:01:2dadf92d0ef
    Key=0x1234ffff
      All target ports bit clear
      Relative port address: 0x1
      not reservation holder
      Transport Id of initiator:
        iSCSI world wide unique port id: iqn.1996-04.de.suse:01:1661f9ee7b5

*) From Target_Core_Mod/ConfigFS for a Target_Core_Mod/IBLOCK struct block_device
   attached to LIO-Target v3.0 iSCSI Target ports:

target:~# cat /sys/kernel/config/target/core/iblock_0/lvm_test0/pr/*
SPC-3 Reservation: iSCSI Initiator: iqn.1993-08.org.debian:01:2dadf92d0ef
SPC-3 Reservation: All Target Ports registration
0x00000002
SPC-3 Reservation: iSCSI Target Node Endpoint: iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
SPC-3 Reservation: Portal Identifer Tag: 1 Logical Unit: 0
SPC-3 PR Registrations:
iSCSI Node: iqn.1993-08.org.debian:01:2dadf92d0ef Key: 0x000000005678efff PRgen: 0x00000000
iSCSI Node: iqn.1996-04.de.suse:01:1661f9ee7b5 Key: 0x000000001234ffff PRgen: 0x00000001
SPC-3 Reservation Type: Write Exclusive Access
SPC3_PERSISTENT_RESERVATIONS

Comments folks..?

--nab

[PATCH 1/4] [Target_Core_Mod/PERSISTENT_RESERVATION]: Change logic for all_tg_pt=[1,0]
[PATCH 2/4] [Target_Core_Mod/ConfigFS]: Add res_pr_holder_tg_port attribute
[PATCH 3/4] [Target_Core_Mod/PERSISTENT_RESERVATION]: Add support for PRIN SA READ_FULL_STATUS
[PATCH 4/4] [LIO-Target/PERSISTENT-RESERVATION]: Add support for iSCSI Transport IDs

remote: Counting objects: 35, done.
remote: Compressing objects: 100% (25/25), done.
remote: Total 25 (delta 21), reused 0 (delta 0)
Unpacking objects: 100% (25/25), done.
>From /pub/scm/linux/kernel/git/nab/lio-core-2.6
 * branch            master     -> FETCH_HEAD
Updating ab56467..df84268
Fast forward
 drivers/lio-core/iscsi_target_configfs.c  |    2 +
 drivers/lio-core/iscsi_target_tpg.c       |  142 ++++++++++++++++++++++++-
 drivers/lio-core/iscsi_target_tpg.h       |    4 +-
 drivers/lio-core/target_core_base.h       |    4 +-
 drivers/lio-core/target_core_configfs.c   |   76 +++++++++----
 drivers/lio-core/target_core_fabric_ops.h |    4 +-
 drivers/lio-core/target_core_pr.c         |  166 ++++++++++++++++++++++++----
 7 files changed, 346 insertions(+), 52 deletions(-)


