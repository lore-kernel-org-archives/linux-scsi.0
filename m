From: scameron@beardog.cca.cpqcorp.net
Subject: [patch 2/8] cciss: factor out core of sendcmd_withirq() for use by SCSI error handling code
Date: Mon, 8 Jun 2009 16:01:11 -0500
Message-ID: <20090608210111.GH23523@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:15442 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZFHVAs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 17:00:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, akpm@linux-foundation.org
Cc: scameron@beardog.cca.cpqcorp.net, mikem@beardog.cca.cpqcorp.net



Factor the core of sendcmd_withirq out to provide a simpler interface
which provides access to full error information.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

---

---


diff -puN drivers/block/cciss.c~cciss_sendcmd_withirq_cleanup drivers/block/cciss.c
--- linux-next/drivers/block/cciss.c~cciss_sendcmd_withirq_cleanup	2009-06-08 12:58:44.000000000 -0500
+++ linux-next-scameron/drivers/block/cciss.c	2009-06-08 12:58:44.000000000 -0500
@@ -2278,114 +2278,123 @@ static int fill_cmd(CommandList_struct *
 	return status;
 }
 
-static int sendcmd_withirq(__u8 cmd,
-			   int ctlr,
-			   void *buff,
-			   size_t size,
-			   unsigned int use_unit_num,
-			   unsigned int log_unit, __u8 page_code, int cmd_type)
+static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c)
 {
-	ctlr_info_t *h = hba[ctlr];
-	CommandList_struct *c;
+	DECLARE_COMPLETION_ONSTACK(wait);
 	u64bit buff_dma_handle;
 	unsigned long flags;
-	int return_status;
-	DECLARE_COMPLETION_ONSTACK(wait);
+	int return_status = IO_OK;
 
-	if ((c = cmd_alloc(h, 0)) == NULL)
-		return -ENOMEM;
-	return_status = fill_cmd(c, cmd, ctlr, buff, size, use_unit_num,
-				 log_unit, page_code, NULL, cmd_type);
-	if (return_status != IO_OK) {
-		cmd_free(h, c, 0);
-		return return_status;
-	}
-      resend_cmd2:
+resend_cmd2:
 	c->waiting = &wait;
-
 	/* Put the request on the tail of the queue and send it */
-	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
 	addQ(&h->reqQ, c);
 	h->Qdepth++;
 	start_io(h);
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 
 	wait_for_completion(&wait);
 
-	if (c->err_info->CommandStatus != 0) {	/* an error has occurred */
-		switch (c->err_info->CommandStatus) {
-		case CMD_TARGET_STATUS:
-			printk(KERN_WARNING "cciss: cmd %p has "
-			       " completed with errors\n", c);
-			if (c->err_info->ScsiStatus) {
-				printk(KERN_WARNING "cciss: cmd %p "
-				       "has SCSI Status = %x\n",
-				       c, c->err_info->ScsiStatus);
-			}
-
-			break;
-		case CMD_DATA_UNDERRUN:
-		case CMD_DATA_OVERRUN:
-			/* expected for inquire and report lun commands */
-			break;
-		case CMD_INVALID:
-			printk(KERN_WARNING "cciss: Cmd %p is "
-			       "reported invalid\n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_PROTOCOL_ERR:
-			printk(KERN_WARNING "cciss: cmd %p has "
-			       "protocol error \n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_HARDWARE_ERR:
-			printk(KERN_WARNING "cciss: cmd %p had "
-			       " hardware error\n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_CONNECTION_LOST:
-			printk(KERN_WARNING "cciss: cmd %p had "
-			       "connection lost\n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_ABORTED:
-			printk(KERN_WARNING "cciss: cmd %p was "
-			       "aborted\n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_ABORT_FAILED:
-			printk(KERN_WARNING "cciss: cmd %p reports "
-			       "abort failed\n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_UNSOLICITED_ABORT:
+	if (c->err_info->CommandStatus == 0)
+		goto command_done;
+
+	switch (c->err_info->CommandStatus) {
+	case CMD_TARGET_STATUS:
+		printk(KERN_WARNING "cciss: cmd 0x%02x "
+		"has completed with errors\n", c->Request.CDB[0]);
+		if (c->err_info->ScsiStatus) {
+			printk(KERN_WARNING "cciss: cmd 0x%02x "
+			       "has SCSI Status = %x\n",
+			       c->Request.CDB[0], c->err_info->ScsiStatus);
+		}
+		break;
+	case CMD_DATA_UNDERRUN:
+	case CMD_DATA_OVERRUN:
+		/* expected for inquiry and report lun commands */
+		break;
+	case CMD_INVALID:
+		printk(KERN_WARNING "cciss: Cmd 0x%02x is "
+		       "reported invalid\n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_PROTOCOL_ERR:
+		printk(KERN_WARNING "cciss: cmd 0x%02x has "
+		       "protocol error \n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_HARDWARE_ERR:
+		printk(KERN_WARNING "cciss: cmd 0x%02x had "
+		       " hardware error\n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_CONNECTION_LOST:
+		printk(KERN_WARNING "cciss: cmd 0x%02x had "
+		       "connection lost\n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_ABORTED:
+		printk(KERN_WARNING "cciss: cmd 0x%02x was "
+		       "aborted\n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_ABORT_FAILED:
+		printk(KERN_WARNING "cciss: cmd 0x%02x reports "
+		       "abort failed\n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_UNSOLICITED_ABORT:
+		printk(KERN_WARNING
+		       "cciss%d: unsolicited abort 0x%02x\n", h->ctlr,
+			c->Request.CDB[0]);
+		if (c->retry_count < MAX_CMD_RETRIES) {
 			printk(KERN_WARNING
-			       "cciss%d: unsolicited abort %p\n", ctlr, c);
-			if (c->retry_count < MAX_CMD_RETRIES) {
-				printk(KERN_WARNING
-				       "cciss%d: retrying %p\n", ctlr, c);
-				c->retry_count++;
-				/* erase the old error information */
-				memset(c->err_info, 0,
-				       sizeof(ErrorInfo_struct));
-				return_status = IO_OK;
-				INIT_COMPLETION(wait);
-				goto resend_cmd2;
-			}
-			return_status = IO_ERROR;
-			break;
-		default:
-			printk(KERN_WARNING "cciss: cmd %p returned "
-			       "unknown status %x\n", c,
-			       c->err_info->CommandStatus);
-			return_status = IO_ERROR;
+			       "cciss%d: retrying 0x%02x\n", h->ctlr,
+				c->Request.CDB[0]);
+			c->retry_count++;
+			/* erase the old error information */
+			memset(c->err_info, 0,
+			       sizeof(ErrorInfo_struct));
+			return_status = IO_OK;
+			INIT_COMPLETION(wait);
+			goto resend_cmd2;
 		}
+		return_status = IO_ERROR;
+		break;
+	default:
+		printk(KERN_WARNING "cciss: cmd 0x%02x returned "
+		       "unknown status %x\n", c->Request.CDB[0],
+		       c->err_info->CommandStatus);
+		return_status = IO_ERROR;
 	}
+
+command_done:
 	/* unlock the buffers from DMA */
 	buff_dma_handle.val32.lower = c->SG[0].Addr.lower;
 	buff_dma_handle.val32.upper = c->SG[0].Addr.upper;
 	pci_unmap_single(h->pdev, (dma_addr_t) buff_dma_handle.val,
 			 c->SG[0].Len, PCI_DMA_BIDIRECTIONAL);
+	return return_status;
+}
+
+static int sendcmd_withirq(__u8 cmd,
+			   int ctlr,
+			   void *buff,
+			   size_t size,
+			   unsigned int use_unit_num,
+			   unsigned int log_unit, __u8 page_code, int cmd_type)
+{
+	ctlr_info_t *h = hba[ctlr];
+	CommandList_struct *c;
+	int return_status;
+
+	c = cmd_alloc(h, 0);
+	if (!c)
+		return -ENOMEM;
+	return_status = fill_cmd(c, cmd, ctlr, buff, size, use_unit_num,
+				 log_unit, page_code, NULL, cmd_type);
+	if (return_status == IO_OK)
+		return_status = sendcmd_withirq_core(h, c);
 	cmd_free(h, c, 0);
 	return return_status;
 }
_
