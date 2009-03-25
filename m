From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/5] [Target_Core_Mod]: Add REQUEST_SENSE usage subsystem
	plugins
Date: Tue, 24 Mar 2009 22:53:06 -0700
Message-ID: <1237960386.4138.396.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:40506 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753116AbZCYFxM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 01:53:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

>From bdb21365a760de67332536ff5d70f3bd3527bbf3 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 23 Mar 2009 22:24:54 -0700
Subject: [PATCH 2/5] [Target_Core_Mod]: Add REQUEST_SENSE usage subsystem plugins

This patch adds supports for the calling of transport_generic_emulate_request_sense()
in IBLOCK, FILEIO and RAMDISK_* subsystem plugins.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_file.c   |    6 ++++++
 drivers/lio-core/target_core_iblock.c |    6 ++++++
 drivers/lio-core/target_core_rd.c     |    6 ++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/target_core_file.c b/drivers/lio-core/target_core_file.c
index b641244..6d42d16 100644
--- a/drivers/lio-core/target_core_file.c
+++ b/drivers/lio-core/target_core_file.c
@@ -493,6 +493,12 @@ static int fd_emulate_scsi_cdb(se_task_t *task)
 		if (ret < 0)
 			return ret;
 		break;
+	case REQUEST_SENSE:
+		ret = transport_generic_emulate_request_sense(cmd,
+				T_TASK(cmd)->t_task_cdb);
+		if (ret < 0)
+			return ret;
+		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
 	case REZERO_UNIT:
diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index abd39bc..8b93dbc 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -510,6 +510,12 @@ static int iblock_emulate_scsi_cdb(se_task_t *task)
 		if (ret < 0)
 			return ret;
 		break;
+	case REQUEST_SENSE:
+		ret = transport_generic_emulate_request_sense(cmd,
+				T_TASK(cmd)->t_task_cdb);
+		if (ret < 0)
+			return ret;
+		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
 	case REZERO_UNIT:
diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index de61067..e65e723 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -501,6 +501,12 @@ static int rd_emulate_scsi_cdb(se_task_t *task)
 		if (ret < 0)
 			return ret;
 		break;
+	case REQUEST_SENSE:
+		ret = transport_generic_emulate_request_sense(cmd,
+				T_TASK(cmd)->t_task_cdb);
+		if (ret < 0)
+			return ret;
+		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
 	case REZERO_UNIT:
-- 
1.5.4.1



