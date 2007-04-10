From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 1/3] cciss: reformat error handling
Date: Tue, 10 Apr 2007 15:58:27 -0500
Message-ID: <20070410205827.GA19579@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:39571 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030657AbXDJU63 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Apr 2007 16:58:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, steve.cameron@hp.com

PATCH 1/3
This patch reformats some error handling code to reduce line lengths a bit. It
accompanies the SG_IO patch which is 2/3 of this set.

Please consider this for inclusion.

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
Signed-off-by: Mike Miller <mike.miller@hp.com>

---

 linux-2.6.21-rc6/drivers/block/cciss.c |  176 ++++++++++++++++-----------------
 1 files changed, 90 insertions(+), 86 deletions(-)

diff -puN linux-2.6.21-rc6/drivers/block/cciss.c~reformat_error_handling linux-2.6.21-rc6/drivers/block/cciss.c
--- cciss_sg_io/linux-2.6.21-rc6/drivers/block/cciss.c~reformat_error_handling	2007-04-10 14:22:46.000000000 -0500
+++ cciss_sg_io-scameron/linux-2.6.21-rc6/drivers/block/cciss.c	2007-04-10 14:31:58.000000000 -0500
@@ -2349,95 +2349,99 @@ static inline void complete_command(ctlr
 	if (timeout)
 		status = 0;
 
-	if (cmd->err_info->CommandStatus != 0) {	/* an error has occurred */
-		switch (cmd->err_info->CommandStatus) {
-			unsigned char sense_key;
-		case CMD_TARGET_STATUS:
-			status = 0;
-
-			if (cmd->err_info->ScsiStatus == 0x02) {
-				printk(KERN_WARNING "cciss: cmd %p "
-				       "has CHECK CONDITION "
-				       " byte 2 = 0x%x\n", cmd,
-				       cmd->err_info->SenseInfo[2]
-				    );
-				/* check the sense key */
-				sense_key = 0xf & cmd->err_info->SenseInfo[2];
-				/* no status or recovered error */
-				if ((sense_key == 0x0) || (sense_key == 0x1)) {
-					status = 1;
-				}
-			} else {
-				printk(KERN_WARNING "cciss: cmd %p "
-				       "has SCSI Status 0x%x\n",
-				       cmd, cmd->err_info->ScsiStatus);
+	if (cmd->err_info->CommandStatus == 0)	/* no error has occurred */
+		goto after_error_processing;
+
+	switch (cmd->err_info->CommandStatus) {
+		unsigned char sense_key;
+	case CMD_TARGET_STATUS:
+		status = 0;
+
+		if (cmd->err_info->ScsiStatus == 0x02) {
+			printk(KERN_WARNING "cciss: cmd %p "
+			       "has CHECK CONDITION "
+			       " byte 2 = 0x%x\n", cmd,
+			       cmd->err_info->SenseInfo[2]
+			    );
+			/* check the sense key */
+			sense_key = 0xf & cmd->err_info->SenseInfo[2];
+			/* no status or recovered error */
+			if ((sense_key == 0x0) || (sense_key == 0x1)) {
+				status = 1;
 			}
-			break;
-		case CMD_DATA_UNDERRUN:
-			printk(KERN_WARNING "cciss: cmd %p has"
-			       " completed with data underrun "
-			       "reported\n", cmd);
-			break;
-		case CMD_DATA_OVERRUN:
-			printk(KERN_WARNING "cciss: cmd %p has"
-			       " completed with data overrun "
-			       "reported\n", cmd);
-			break;
-		case CMD_INVALID:
-			printk(KERN_WARNING "cciss: cmd %p is "
-			       "reported invalid\n", cmd);
-			status = 0;
-			break;
-		case CMD_PROTOCOL_ERR:
-			printk(KERN_WARNING "cciss: cmd %p has "
-			       "protocol error \n", cmd);
-			status = 0;
-			break;
-		case CMD_HARDWARE_ERR:
-			printk(KERN_WARNING "cciss: cmd %p had "
-			       " hardware error\n", cmd);
-			status = 0;
-			break;
-		case CMD_CONNECTION_LOST:
-			printk(KERN_WARNING "cciss: cmd %p had "
-			       "connection lost\n", cmd);
-			status = 0;
-			break;
-		case CMD_ABORTED:
-			printk(KERN_WARNING "cciss: cmd %p was "
-			       "aborted\n", cmd);
-			status = 0;
-			break;
-		case CMD_ABORT_FAILED:
-			printk(KERN_WARNING "cciss: cmd %p reports "
-			       "abort failed\n", cmd);
-			status = 0;
-			break;
-		case CMD_UNSOLICITED_ABORT:
-			printk(KERN_WARNING "cciss%d: unsolicited "
-			       "abort %p\n", h->ctlr, cmd);
-			if (cmd->retry_count < MAX_CMD_RETRIES) {
-				retry_cmd = 1;
-				printk(KERN_WARNING
-				       "cciss%d: retrying %p\n", h->ctlr, cmd);
-				cmd->retry_count++;
-			} else
-				printk(KERN_WARNING
-				       "cciss%d: %p retried too "
-				       "many times\n", h->ctlr, cmd);
-			status = 0;
-			break;
-		case CMD_TIMEOUT:
-			printk(KERN_WARNING "cciss: cmd %p timedout\n", cmd);
-			status = 0;
-			break;
-		default:
-			printk(KERN_WARNING "cciss: cmd %p returned "
-			       "unknown status %x\n", cmd,
-			       cmd->err_info->CommandStatus);
-			status = 0;
+		} else {
+			printk(KERN_WARNING "cciss: cmd %p "
+			       "has SCSI Status 0x%x\n",
+			       cmd, cmd->err_info->ScsiStatus);
 		}
+		break;
+	case CMD_DATA_UNDERRUN:
+		printk(KERN_WARNING "cciss: cmd %p has"
+		       " completed with data underrun "
+		       "reported\n", cmd);
+		break;
+	case CMD_DATA_OVERRUN:
+		printk(KERN_WARNING "cciss: cmd %p has"
+		       " completed with data overrun "
+		       "reported\n", cmd);
+		break;
+	case CMD_INVALID:
+		printk(KERN_WARNING "cciss: cmd %p is "
+		       "reported invalid\n", cmd);
+		status = 0;
+		break;
+	case CMD_PROTOCOL_ERR:
+		printk(KERN_WARNING "cciss: cmd %p has "
+		       "protocol error \n", cmd);
+		status = 0;
+		break;
+	case CMD_HARDWARE_ERR:
+		printk(KERN_WARNING "cciss: cmd %p had "
+		       " hardware error\n", cmd);
+		status = 0;
+		break;
+	case CMD_CONNECTION_LOST:
+		printk(KERN_WARNING "cciss: cmd %p had "
+		       "connection lost\n", cmd);
+		status = 0;
+		break;
+	case CMD_ABORTED:
+		printk(KERN_WARNING "cciss: cmd %p was "
+		       "aborted\n", cmd);
+		status = 0;
+		break;
+	case CMD_ABORT_FAILED:
+		printk(KERN_WARNING "cciss: cmd %p reports "
+		       "abort failed\n", cmd);
+		status = 0;
+		break;
+	case CMD_UNSOLICITED_ABORT:
+		printk(KERN_WARNING "cciss%d: unsolicited "
+		       "abort %p\n", h->ctlr, cmd);
+		if (cmd->retry_count < MAX_CMD_RETRIES) {
+			retry_cmd = 1;
+			printk(KERN_WARNING
+			       "cciss%d: retrying %p\n", h->ctlr, cmd);
+			cmd->retry_count++;
+		} else
+			printk(KERN_WARNING
+			       "cciss%d: %p retried too "
+			       "many times\n", h->ctlr, cmd);
+		status = 0;
+		break;
+	case CMD_TIMEOUT:
+		printk(KERN_WARNING "cciss: cmd %p timedout\n", cmd);
+		status = 0;
+		break;
+	default:
+		printk(KERN_WARNING "cciss: cmd %p returned "
+		       "unknown status %x\n", cmd,
+		       cmd->err_info->CommandStatus);
+		status = 0;
 	}
+
+after_error_processing:
+
 	/* We need to return this command */
 	if (retry_cmd) {
 		resend_cciss_cmd(h, cmd);
_
