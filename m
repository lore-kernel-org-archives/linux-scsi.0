From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/10] scsi: Avoid linebreaks in syslog output
Date: Fri, 12 Oct 2012 10:33:43 +0200
Message-ID: <1350030830-25614-4-git-send-email-hare@suse.de>
References: <1350030830-25614-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933529Ab2JLIdz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 04:33:55 -0400
In-Reply-To: <1350030830-25614-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kay Sievers <kay@vrfy.org>

sdev_printk() is adding a linebreak automatically, causing the
syslog output to be garbled:
[  542.494393] sr 2:0:0:0: Send:
[  542.494394] 0xffff8804291e5dc0
which will make debuggging painful.
So reshuffle sdev_printk invokation to have it printed on
the same line.

Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c |   38 ++++++++++++++++++++++----------------
 1 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2936b44..28b294b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -551,14 +551,15 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 		level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
-			scmd_printk(KERN_INFO, cmd, "Send: ");
 			if (level > 2)
-				printk("0x%p ", cmd);
-			printk("\n");
+				scmd_printk(KERN_INFO, cmd, "Send: 0x%p", cmd);
+			else
+				scmd_printk(KERN_INFO, cmd, "Send:");
 			scsi_print_command(cmd);
 			if (level > 3) {
-				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
-				       " queuecommand 0x%p\n",
+				scmd_printk(KERN_INFO, cmd,
+				       "buffer = 0x%p, bufflen = %d,"
+				       " queuecommand 0x%p",
 					scsi_sglist(cmd), scsi_bufflen(cmd),
 					cmd->device->host->hostt->queuecommand);
 
@@ -588,42 +589,47 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 				       SCSI_LOG_MLCOMPLETE_BITS);
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
-			scmd_printk(KERN_INFO, cmd, "Done: ");
-			if (level > 2)
-				printk("0x%p ", cmd);
+			const char *disp_str;
+
 			/*
 			 * Dump truncated values, so we usually fit within
 			 * 80 chars.
 			 */
 			switch (disposition) {
 			case SUCCESS:
-				printk("SUCCESS\n");
+				disp_str = "SUCCESS";
 				break;
 			case NEEDS_RETRY:
-				printk("RETRY\n");
+				disp_str = "RETRY";
 				break;
 			case ADD_TO_MLQUEUE:
-				printk("MLQUEUE\n");
+				disp_str = "MLQUEUE";
 				break;
 			case FAILED:
-				printk("FAILED\n");
+				disp_str = "FAILED";
 				break;
 			case TIMEOUT_ERROR:
-				/* 
+				/*
 				 * If called via scsi_times_out.
 				 */
-				printk("TIMEOUT\n");
+				disp_str = "TIMEOUT";
 				break;
 			default:
-				printk("UNKNOWN\n");
+				disp_str = "UNKNOWN";
 			}
+			if (level > 2)
+				scmd_printk(KERN_INFO, cmd, "Done: 0x%p %s",
+					    cmd, disp_str);
+			else
+				scmd_printk(KERN_INFO, cmd, "Done: %s",
+					    disp_str);
 			scsi_print_result(cmd);
 			scsi_print_command(cmd);
 			if (status_byte(cmd->result) & CHECK_CONDITION)
 				scsi_print_sense("", cmd);
 			if (level > 3)
 				scmd_printk(KERN_INFO, cmd,
-					    "scsi host busy %d failed %d\n",
+					    "scsi host busy %d failed %d",
 					    cmd->device->host->host_busy,
 					    cmd->device->host->host_failed);
 		}
-- 
1.7.4.2

