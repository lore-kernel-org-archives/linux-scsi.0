From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/22] scsi: use local buffer for scsi_log_(send|completion)
Date: Thu, 28 Aug 2014 19:33:33 +0200
Message-ID: <1409247216-76074-20-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaH1Rdo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:44 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

scsi_logging is somewhat special, and so instead of tweaking
scsi_print_command() we should be using __scsi_print_command()
with a local buffer, which then can be formatted according
to the logging level.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d267e61..58e2d7f 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -529,17 +529,23 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 		level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
 				       SCSI_LOG_MLQUEUE_BITS);
 		if (level > 1) {
-			scmd_printk(KERN_INFO, cmd, "Send: ");
+			char buf[80];
+
+			__scsi_print_command(cmd->cmnd, buf, 80);
 			if (level > 2)
-				printk("0x%p ", cmd);
-			printk("\n");
-			scsi_print_command(cmd);
+				scmd_printk(KERN_INFO, cmd, "Send: 0x%p %s\n",
+					    cmd, buf);
+			else
+				scmd_printk(KERN_INFO, cmd, "Send: %s\n", buf);
 			if (level > 3) {
-				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
-				       " queuecommand 0x%p\n",
-					scsi_sglist(cmd), scsi_bufflen(cmd),
-					cmd->device->host->hostt->queuecommand);
-
+				struct Scsi_Host *shost = cmd->device->host;
+				scmd_printk(KERN_INFO, cmd,
+					    "Send: 0x%p buffer = 0x%p,"
+					    " bufflen = %d,"
+					    " queuecommand 0x%p\n",
+					    cmd, scsi_sglist(cmd),
+					    scsi_bufflen(cmd),
+					    shost->hostt->queuecommand);
 			}
 		}
 	}
@@ -566,15 +572,17 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 				       SCSI_LOG_MLCOMPLETE_BITS);
 		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
 		    (level > 1)) {
-			scmd_printk(KERN_INFO, cmd, "Done: ");
+			char buf[80];
+
+			__scsi_print_command(cmd->cmnd, buf, 80);
 			if (level > 2)
-				printk("0x%p ", cmd);
+				scmd_printk(KERN_INFO, cmd,
+					    "Done: 0x%p %s\n", cmd, buf);
+			else
+				scmd_printk(KERN_INFO, cmd, "Done: %s\n", buf);
 			scsi_print_result(cmd, disposition);
-			scsi_print_command(cmd);
-			if (status_byte(cmd->result) & CHECK_CONDITION) {
-				if (scsi_print_sense(cmd))
-					scsi_dump_sense(cmd);
-			}
+			if (status_byte(cmd->result) & CHECK_CONDITION)
+				scsi_print_sense(cmd);
 			if (level > 3)
 				scmd_printk(KERN_INFO, cmd,
 					    "scsi host busy %d failed %d\n",
-- 
1.8.5.2

