From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/4] SCSI: Make error printing more verbose
Date: Tue, 27 Feb 2007 22:40:27 -0500
Message-ID: <yq14pp76jbo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:16585 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbXB1Dk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Feb 2007 22:40:57 -0500
Received: from rgmgw3.us.oracle.com (rgmgw3.us.oracle.com [138.1.186.112])
	by agminet01.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l1S3etOm001368
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2007 21:40:56 -0600
Received: from rcsmt251.oracle.com (rcsmt251.oracle.com [148.87.90.196])
	by rgmgw3.us.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l1S2sIil028905
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2007 20:40:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch enhances SCSI error printing by:

 - Making use of scsi_print_result() in the completion functions.

 - Having scmd_printk() output the disk name (when applicable).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

--- 

 drivers/scsi/scsi.c        |   47 ++++++++++++++++-----------------------------
 drivers/scsi/scsi_lib.c    |    4 ---
 include/scsi/scsi_device.h |    8 +++++--
 3 files changed, 24 insertions(+), 35 deletions(-)


Index: scsi-misc-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_lib.c
+++ scsi-misc-2.6/drivers/scsi/scsi_lib.c
@@ -968,9 +968,7 @@ void scsi_io_completion(struct scsi_cmnd
 	}
 	if (result) {
 		if (!(req->cmd_flags & REQ_QUIET)) {
-			scmd_printk(KERN_INFO, cmd,
-				    "SCSI error: return code = 0x%08x\n",
-				    result);
+ 			scsi_print_result(cmd);
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
 		}
Index: scsi-misc-2.6/include/scsi/scsi_device.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_device.h
+++ scsi-misc-2.6/include/scsi/scsi_device.h
@@ -5,6 +5,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
+#include <linux/blkdev.h>
 #include <asm/atomic.h>
 
 struct request_queue;
@@ -153,8 +154,11 @@ struct scsi_device {
 #define sdev_printk(prefix, sdev, fmt, a...)	\
 	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
 
-#define scmd_printk(prefix, scmd, fmt, a...)	\
-	dev_printk(prefix, &(scmd)->device->sdev_gendev, fmt, ##a)
+#define scmd_printk(prefix, scmd, fmt, a...)				\
+        (scmd)->request->rq_disk ?					\
+	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
+		    (scmd)->request->rq_disk->disk_name, ##a) :		\
+	sdev_printk(prefix, (scmd)->device, fmt, ##a)
 
 enum scsi_target_state {
 	STARGET_RUNNING = 1,
Index: scsi-misc-2.6/drivers/scsi/scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi.c
+++ scsi-misc-2.6/drivers/scsi/scsi.c
@@ -344,7 +344,6 @@ void scsi_destroy_command_freelist(struc
 void scsi_log_send(struct scsi_cmnd *cmd)
 {
 	unsigned int level;
-	struct scsi_device *sdev;
 
 	/*
 	 * If ML QUEUE log level is greater than or equal to:
@@ -361,22 +360,17 @@ void scsi_log_send(struct scsi_cmnd *cmd
 		level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
-			sdev = cmd->device;
-			sdev_printk(KERN_INFO, sdev, "send ");
+			scmd_printk(KERN_INFO, cmd, "Send: ");
 			if (level > 2)
 				printk("0x%p ", cmd);
-			/*
-			 * spaces to match disposition and cmd->result
-			 * output in scsi_log_completion.
-			 */
-			printk("                 ");
+			printk("\n");
 			scsi_print_command(cmd);
 			if (level > 3) {
 				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
 				       " done = 0x%p, queuecommand 0x%p\n",
 					cmd->request_buffer, cmd->request_bufflen,
 					cmd->done,
-					sdev->host->hostt->queuecommand);
+					cmd->device->host->hostt->queuecommand);
 
 			}
 		}
@@ -386,7 +380,6 @@ void scsi_log_send(struct scsi_cmnd *cmd
 void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 {
 	unsigned int level;
-	struct scsi_device *sdev;
 
 	/*
 	 * If ML COMPLETE log level is greater than or equal to:
@@ -405,8 +398,7 @@ void scsi_log_completion(struct scsi_cmn
 				       SCSI_LOG_MLCOMPLETE_BITS);
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
-			sdev = cmd->device;
-			sdev_printk(KERN_INFO, sdev, "done ");
+			scmd_printk(KERN_INFO, cmd, "Done: ");
 			if (level > 2)
 				printk("0x%p ", cmd);
 			/*
@@ -415,40 +407,35 @@ void scsi_log_completion(struct scsi_cmn
 			 */
 			switch (disposition) {
 			case SUCCESS:
-				printk("SUCCESS");
+				printk("SUCCESS\n");
 				break;
 			case NEEDS_RETRY:
-				printk("RETRY  ");
+				printk("RETRY\n");
 				break;
 			case ADD_TO_MLQUEUE:
-				printk("MLQUEUE");
+				printk("MLQUEUE\n");
 				break;
 			case FAILED:
-				printk("FAILED ");
+				printk("FAILED\n");
 				break;
 			case TIMEOUT_ERROR:
 				/* 
 				 * If called via scsi_times_out.
 				 */
-				printk("TIMEOUT");
+				printk("TIMEOUT\n");
 				break;
 			default:
-				printk("UNKNOWN");
+				printk("UNKNOWN\n");
 			}
-			printk(" %8x ", cmd->result);
+			scsi_print_result(cmd);
 			scsi_print_command(cmd);
-			if (status_byte(cmd->result) & CHECK_CONDITION) {
-				/*
-				 * XXX The scsi_print_sense formatting/prefix
-				 * doesn't match this function.
-				 */
+			if (status_byte(cmd->result) & CHECK_CONDITION)
 				scsi_print_sense("", cmd);
-			}
-			if (level > 3) {
-				printk(KERN_INFO "scsi host busy %d failed %d\n",
-				       sdev->host->host_busy,
-				       sdev->host->host_failed);
-			}
+			if (level > 3)
+				scmd_printk(KERN_INFO, cmd,
+					    "scsi host busy %d failed %d\n",
+					    cmd->device->host->host_busy,
+					    cmd->device->host->host_failed);
 		}
 	}
 }
