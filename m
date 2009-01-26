From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/7 Target_Core_Mod]: Add running PRIO SA RESERVE and PRIN
	SA READ_KEYS and SA READ_RESERVATION support
Date: Mon, 26 Jan 2009 01:06:34 -0800
Message-ID: <1232960794.24642.120.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:37320 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750943AbZAZJG5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 04:06:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Rafiu Fakunle <rafiu@openfiler.com>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>

Grettings all,

This patch series adds the first running BITS of SPC-3 compatible
Persistent Reservation Service Action REGISTER, READ_KEYS and
READ_RESERVATION support to Target_Core_Mod/ConfigFS.  It has been
tested with sg3_utils with Open/iSCSI using x86 32-bit HVMs.

This patch is made against lio-core-2.6.git/master
and tested on v2.6.28 x86 32-bit HVM.  The lio-core-2.6.git tree can be
found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Subject: [PATCH 1/7] [Target_Core_Mod]: Add SPC-3 PERSISTENT_RESERVE_* Infrastrcture
Subject: [PATCH 2/7] [LIO-Target]: Convert iscsi_send_check_condition_and_sense -> transport_send_check_condition_and_sense()
Subject: [PATCH 3/7] [Target_Core_Mod/RAMDISK]: Convert to use Linux/SCSI SCSI_2 define
Subject: [PATCH 4/7] [Target_Core_Mod/FILEIO]: Convert to use Linux/SCSI SCSI_2 define
Subject: [PATCH 5/7] [Target_Core_Mod/IBLOCK]: Convert to use Linux/SCSI SCSI_3 define
Subject: [PATCH 6/7] [Target_Core_Mod/PERSISTENT_RESERVATION]: Add Service Action REGISTER logic
Subject: [PATCH 7/7] [Target_Core_Mod/ConfigFS]: Add res_pr_all_tgt_pts, res_pr_generation and res_pr_registered_i_pts

remote: Counting objects: 64, done.
remote: Compressing objects: 100% (47/47), done.
remote: Total 47 (delta 42), reused 0 (delta 0)
Unpacking objects: 100% (47/47), done.
>From /pub/scm/linux/kernel/git/nab/lio-core-2.6
 * branch            master     -> FETCH_HEAD
Updating a50c8a5..45345eb
Fast forward
 drivers/lio-core/iscsi_target.c          |    2 +-
 drivers/lio-core/iscsi_target_erl0.c     |    6 +-
 drivers/lio-core/iscsi_target_erl1.c     |    2 +-
 drivers/lio-core/iscsi_target_util.c     |    6 +-
 drivers/lio-core/target_core_base.h      |   89 ++++--
 drivers/lio-core/target_core_configfs.c  |  107 ++++++-
 drivers/lio-core/target_core_device.c    |    5 +-
 drivers/lio-core/target_core_file.c      |    4 +-
 drivers/lio-core/target_core_iblock.c    |    4 +-
 drivers/lio-core/target_core_pr.c        |  495 +++++++++++++++++++++++++++++-
 drivers/lio-core/target_core_pr.h        |   18 +
 drivers/lio-core/target_core_rd.c        |    4 +-
 drivers/lio-core/target_core_transport.c |   75 ++++-
 drivers/lio-core/target_core_transport.h |   14 +-
 14 files changed, 742 insertions(+), 89 deletions(-)

--nab

