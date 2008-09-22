From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 12/13] scsi: update scsi_log_completion disposition decoding
Date: Mon, 22 Sep 2008 09:33:41 -0700
Message-ID: <1222101222-15079-13-git-send-email-andmike@linux.vnet.ibm.com>
References: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:35014 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYIVQeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2008 12:34:09 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8MGY9sc006088
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 12:34:09 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8MGY89I191646
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 10:34:08 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8MMY8XS005493
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:08 -0600
Received: from localhost.localdomain (desktop-andmike.beaverton.ibm.com [9.47.22.92])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m8MMXlYU003971
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2008 16:34:07 -0600
In-Reply-To: <1222101222-15079-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update scsi_log_completion to decode new disposition codes.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi.c |   41 ++++++++++++++++++++++-------------------
 include/scsi/scsi.h |    1 +
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 5c116d9..c0023e3 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -577,37 +577,40 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
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
index 09751e4..2d8f00e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -449,6 +449,7 @@ enum {
 };
 
 #define scsi_disposition_finish(dis) (dis & SCSI_MLQUEUE_DIS_FINISH)
+#define scsi_disposition_fail(dis) (dis & SCSI_MLQUEUE_DIS_FAIL)
 #define scsi_disposition_retry(dis)			\
 	((dis & SCSI_MLQUEUE_DIS_RETRY)		||	\
 	 (dis & SCSI_MLQUEUE_DIS_XPT_RETRY)	||	\
-- 
1.5.5.1

