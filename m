From: scameron@beardog.cca.cpqcorp.net
Subject: [patch 4/8] cciss: factor out fix target status processing code from sendcmd functions
Date: Mon, 8 Jun 2009 16:04:35 -0500
Message-ID: <20090608210435.GJ23523@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:4312 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZFHVEM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 17:04:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, akpm@linux-foundation.org
Cc: scameron@beardog.cca.cpqcorp.net, mikem@beardog.cca.cpqcorp.net



Factor out code to process target status of completed commands in sendcmd()
and sendcmd_withirq_core(), and fix problem that bad target status was ignored in
sendcmd_withirq_core.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

---

---


diff -puN drivers/block/cciss.c~cciss_sendcmd_withirq_targstatus_fix drivers/block/cciss.c
--- linux-next/drivers/block/cciss.c~cciss_sendcmd_withirq_targstatus_fix	2009-06-08 12:58:53.000000000 -0500
+++ linux-next-scameron/drivers/block/cciss.c	2009-06-08 12:58:53.000000000 -0500
@@ -2267,6 +2267,31 @@ static int fill_cmd(CommandList_struct *
 	return status;
 }
 
+static int check_target_status(ctlr_info_t *h, CommandList_struct *c)
+{
+	switch (c->err_info->ScsiStatus) {
+	case SAM_STAT_GOOD:
+		return IO_OK;
+	case SAM_STAT_CHECK_CONDITION:
+		switch (0xf & c->err_info->SenseInfo[2]) {
+		case 0: return IO_OK; /* no sense */
+		case 1: return IO_OK; /* recovered error */
+		default:
+			printk(KERN_WARNING "cciss%d: cmd 0x%02x "
+				"check condition, sense key = 0x%02x\n",
+				h->ctlr, c->Request.CDB[0],
+				c->err_info->SenseInfo[2]);
+		}
+		break;
+	default:
+		printk(KERN_WARNING "cciss%d: cmd 0x%02x"
+			"scsi status = 0x%02x\n", h->ctlr,
+			c->Request.CDB[0], c->err_info->ScsiStatus);
+		break;
+	}
+	return IO_ERROR;
+}
+
 static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
@@ -2290,16 +2315,7 @@ resend_cmd2:
 
 	switch (c->err_info->CommandStatus) {
 	case CMD_TARGET_STATUS:
-		printk(KERN_WARNING "cciss: cmd 0x%02x "
-		"has completed with errors\n", c->Request.CDB[0]);
-		if (c->err_info->ScsiStatus) {
-			printk(KERN_WARNING "cciss: cmd 0x%02x "
-			       "has SCSI Status = %x\n",
-			       c->Request.CDB[0], c->err_info->ScsiStatus);
-			if (c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION)
-				printk(KERN_WARNING "sense key = 0x%02x\n",
-					0xf & c->err_info->SenseInfo[2]);
-		}
+		return_status = check_target_status(h, c);
 		break;
 	case CMD_DATA_UNDERRUN:
 	case CMD_DATA_OVERRUN:
@@ -2710,33 +2726,29 @@ resend_cmd1:
 			printk(KERN_WARNING "cciss%d: retried %p too many "
 				"times\n", h->ctlr, c);
 			status = IO_ERROR;
-			goto cleanup1;
+			break;
 		}
 
 		if (c->err_info->CommandStatus == CMD_UNABORTABLE) {
 			printk(KERN_WARNING "cciss%d: command could not be "
 				"aborted.\n", h->ctlr);
 			status = IO_ERROR;
-			goto cleanup1;
+			break;
 		}
 
-		printk(KERN_WARNING "cciss%d: sendcmd error\n", h->ctlr);
-		printk(KERN_WARNING "cmd = 0x%02x, CommandStatus = 0x%02x\n",
-			c->Request.CDB[0], c->err_info->CommandStatus);
 		if (c->err_info->CommandStatus == CMD_TARGET_STATUS) {
-			printk(KERN_WARNING "Target status = 0x%02x\n",
-			c->err_info->ScsiStatus);
-			if (c->err_info->ScsiStatus == 2) /* chk cond */
-				printk(KERN_WARNING "Sense key = 0x%02x\n",
-					0xf & c->err_info->SenseInfo[2]);
+			status = check_target_status(h, c);
+			break;
 		}
 
+		printk(KERN_WARNING "cciss%d: sendcmd error\n", h->ctlr);
+		printk(KERN_WARNING "cmd = 0x%02x, CommandStatus = 0x%02x\n",
+			c->Request.CDB[0], c->err_info->CommandStatus);
 		status = IO_ERROR;
-		goto cleanup1;
+		break;
 
 	} while (1);
 
-cleanup1:
 	/* unlock the data buffer from DMA */
 	buff_dma_handle.val32.lower = c->SG[0].Addr.lower;
 	buff_dma_handle.val32.upper = c->SG[0].Addr.upper;
_
