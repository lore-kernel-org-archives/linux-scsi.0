From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] [Target_Core_Mod]: Remove LOAD_UNLOAD_MEDIUM usage
	from IBLOCK/FILEIO/RAMDISK
Date: Tue, 27 Jan 2009 14:08:08 -0800
Message-ID: <1233094088.6442.105.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:20062 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752474AbZA0WJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 17:09:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

>From 26063b8d3f7a72a7529a0bef643ca2770023d487 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 27 Jan 2009 13:54:43 -0800
Subject: [PATCH 3/4] [Target_Core_Mod]: Remove LOAD_UNLOAD_MEDIUM usage from IBLOCK/FILEIO/RAMDISK

This patch removes the usage of LOAD_UNLOAD_MEDIUM (which has been droped in
favor of using include/linux/cdrom.h GP_* opcode defines) in the various virtual
(eg: above the SCSI layer) Target_Core_Mod subsystem plugin.  This opcode is only
defined for TYPE_ROM, and these subsystem plugins emulate TYPE_DISK.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_file.c   |    1 -
 drivers/lio-core/target_core_iblock.c |    1 -
 drivers/lio-core/target_core_rd.c     |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/lio-core/target_core_file.c b/drivers/lio-core/target_core_file.c
index 5cf95f2..156090a 100644
--- a/drivers/lio-core/target_core_file.c
+++ b/drivers/lio-core/target_core_file.c
@@ -490,7 +490,6 @@ static int fd_emulate_scsi_cdb (se_task_t *task)
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
-	case LOAD_UNLOAD_MEDIUM:
 	case REZERO_UNIT:
 	case SEEK_10:
 	case SPACE:
diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index 29dc87b..a94526c 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -420,7 +420,6 @@ static int iblock_emulate_scsi_cdb (se_task_t *task)
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
-	case LOAD_UNLOAD_MEDIUM:
 	case REZERO_UNIT:
 	case SEEK_10:
 	case SPACE:
diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index e991bb6..d6e4596 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -495,7 +495,6 @@ static int rd_emulate_scsi_cdb (se_task_t *task)
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
-	case LOAD_UNLOAD_MEDIUM:
 	case REZERO_UNIT:
 	case SEEK_10:
 	case SPACE:
-- 
1.5.4.1



