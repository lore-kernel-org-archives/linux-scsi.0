From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 14/14] scsi: update scsi_log_completion disposition decoding
Date: Tue,  2 Sep 2008 09:05:43 -0700
Message-ID: <1220371543-15099-15-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33714 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYIBQFw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:52 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5pWY003401
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:51 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5pVD177064
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:51 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5pYM021439
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:51 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Update scsi_log_completion to decode new disposition codes.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi.c |   41 ++++++++++++++++++++++-------------------
 include/scsi/scsi.h |    1 +
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b87fbb2..a4f56af 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -578,37 +578,40 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 	if (unlikely(scsi_logging_level)) {
 		level = SCSI_LOG_LEVEL(SCSI_LOG_MLCOMPLETE_SHIFT,
 				       SCSI_LOG_MLCOMPLETE_BITS);
-		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
+		if (((level > 0) &&
+		    (cmd->result || !scsi_disposition_finish(disposition))) ||
 		    (level > 1)) {
 			scmd_printk(KERN_INFO, cmd, "Done: ");
 			if (level > 2)
 				printk("0x%p ", cmd);
+
 			/*
 			 * Dump truncated values, so we usually fit within
 			 * 80 chars.
 			 */
-			switch (disposition) {
-			case SUCCESS:
+			if (scsi_disposition_finish(disposition))
 				printk("SUCCESS\n");
-				break;
-			case NEEDS_RETRY:
+			else if (scsi_disposition_retry(disposition))
 				printk("RETRY\n");
-				break;
-			case ADD_TO_MLQUEUE:
-				printk("MLQUEUE\n");
-				break;
-			case FAILED:
+			else if (scsi_disposition_fail(disposition))
 				printk("FAILED\n");
-				break;
-			case TIMEOUT_ERROR:
-				/* 
-				 * If called via scsi_times_out.
-				 */
-				printk("TIMEOUT\n");
-				break;
-			default:
-				printk("UNKNOWN\n");
+			else {
+				switch (disposition) {
+				case SUCCESS:
+					printk("SUCCESS\n");
+					break;
+				case TIMEOUT_ERROR:
+					/*
+					 * If called via scsi_times_out.
+					 */
+					printk("TIMEOUT\n");
+					break;
+				default:
+					printk("UNKNOWN: 0x%x\n",
+					       disposition);
+				}
 			}
+
 			scsi_print_result(cmd);
 			scsi_print_command(cmd);
 			if (status_byte(cmd->result) & CHECK_CONDITION)
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index cacb12c..c7f317b 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -446,6 +446,7 @@ enum {
 };
 
 #define scsi_disposition_finish(dis) (dis & SCSI_MLQUEUE_DIS_FINISH)
+#define scsi_disposition_fail(dis) (dis & SCSI_MLQUEUE_DIS_FAIL)
 #define scsi_disposition_retry(dis)			\
 	((dis & SCSI_MLQUEUE_DIS_RETRY)		||	\
 	 (dis & SCSI_MLQUEUE_DIS_XPT_RETRY)	||	\
-- 
1.5.5.1

