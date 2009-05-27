From: scameron@beardog.cca.cpqcorp.net
Subject: [PATCH 1/2] cciss: Factor out core of sendcmd() for a more sane interface
Date: Wed, 27 May 2009 15:26:07 -0500
Message-ID: <20090527202607.GA29327@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:21794 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbZE0UZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 16:25:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jens.axboe@kernel.dk, akpm@linux-foundation.org
Cc: mikem@beardog.cca.cpqcorp.net, scameron@beardog.cca.cpqcorp.net


Factor out the core of sendcmd() to provide a simpler interface
which exposes all the error information to the caller and make the
original sendcmd use this new function.  Rationale: The SCSI error
handling routines need to send commands with interrupts turned off,
but they also need access to the full error information.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
---

diff -puN drivers/block/cciss.c~cciss_sendcmd_cleanup drivers/block/cciss.c
--- lx2630-6/drivers/block/cciss.c~cciss_sendcmd_cleanup	2009-05-27 12:47:16.000000000 -0500
+++ lx2630-6-scameron/drivers/block/cciss.c	2009-05-27 13:33:13.000000000 -0500
@@ -2378,41 +2378,21 @@ static int add_sendcmd_reject(__u8 cmd,
 	return 0;
 }
 
-/*
- * Send a command to the controller, and wait for it to complete.
- * Only used at init time.
+/* Send command c to controller h and poll for it to complete.
+ * Turns interrupts off on the board.  Used at driver init time
+ * and during SCSI error recovery.
  */
-static int sendcmd(__u8 cmd, int ctlr, void *buff, size_t size, unsigned int use_unit_num,	/* 0: address the controller,
-												   1: address logical volume log_unit,
-												   2: periph device address is scsi3addr */
-		   unsigned int log_unit,
-		   __u8 page_code, unsigned char *scsi3addr, int cmd_type)
+static int sendcmd_core(ctlr_info_t *h, CommandList_struct *c)
 {
-	CommandList_struct *c;
 	int i;
 	unsigned long complete;
-	ctlr_info_t *info_p = hba[ctlr];
+	int status = IO_ERROR;
 	u64bit buff_dma_handle;
-	int status, done = 0;
 
-	if ((c = cmd_alloc(info_p, 1)) == NULL) {
-		printk(KERN_WARNING "cciss: unable to get memory");
-		return IO_ERROR;
-	}
-	status = fill_cmd(c, cmd, ctlr, buff, size, use_unit_num,
-			  log_unit, page_code, scsi3addr, cmd_type);
-	if (status != IO_OK) {
-		cmd_free(info_p, c, 1);
-		return status;
-	}
-      resend_cmd1:
-	/*
-	 * Disable interrupt
-	 */
-#ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "cciss: turning intr off\n");
-#endif				/* CCISS_DEBUG */
-	info_p->access.set_intr_mask(info_p, CCISS_INTR_OFF);
+resend_cmd1:
+
+	/* Disable interrupt on the board. */
+	h->access.set_intr_mask(h, CCISS_INTR_OFF);
 
 	/* Make sure there is room in the command FIFO */
 	/* Actually it should be completely empty at this time */
@@ -2420,21 +2400,15 @@ static int sendcmd(__u8 cmd, int ctlr, v
 	/* tape side of the driver. */
 	for (i = 200000; i > 0; i--) {
 		/* if fifo isn't full go */
-		if (!(info_p->access.fifo_full(info_p))) {
-
+		if (!(h->access.fifo_full(h)))
 			break;
-		}
 		udelay(10);
 		printk(KERN_WARNING "cciss cciss%d: SendCmd FIFO full,"
-		       " waiting!\n", ctlr);
+		       " waiting!\n", h->ctlr);
 	}
-	/*
-	 * Send the cmd
-	 */
-	info_p->access.submit_command(info_p, c);
-	done = 0;
+	h->access.submit_command(h, c); /* Send the cmd */
 	do {
-		complete = pollcomplete(ctlr);
+		complete = pollcomplete(h->ctlr);
 
 #ifdef CCISS_DEBUG
 		printk(KERN_DEBUG "cciss: command completed\n");
@@ -2443,97 +2417,116 @@ static int sendcmd(__u8 cmd, int ctlr, v
 		if (complete == 1) {
 			printk(KERN_WARNING
 			       "cciss cciss%d: SendCmd Timeout out, "
-			       "No command list address returned!\n", ctlr);
+			       "No command list address returned!\n", h->ctlr);
 			status = IO_ERROR;
-			done = 1;
 			break;
 		}
 
-		/* This will need to change for direct lookup completions */
-		if ((complete & CISS_ERROR_BIT)
-		    && (complete & ~CISS_ERROR_BIT) == c->busaddr) {
-			/* if data overrun or underun on Report command
-			   ignore it
-			 */
-			if (((c->Request.CDB[0] == CISS_REPORT_LOG) ||
-			     (c->Request.CDB[0] == CISS_REPORT_PHYS) ||
-			     (c->Request.CDB[0] == CISS_INQUIRY)) &&
-			    ((c->err_info->CommandStatus ==
-			      CMD_DATA_OVERRUN) ||
-			     (c->err_info->CommandStatus == CMD_DATA_UNDERRUN)
-			    )) {
-				complete = c->busaddr;
-			} else {
-				if (c->err_info->CommandStatus ==
-				    CMD_UNSOLICITED_ABORT) {
-					printk(KERN_WARNING "cciss%d: "
-					       "unsolicited abort %p\n",
-					       ctlr, c);
-					if (c->retry_count < MAX_CMD_RETRIES) {
-						printk(KERN_WARNING
-						       "cciss%d: retrying %p\n",
-						       ctlr, c);
-						c->retry_count++;
-						/* erase the old error */
-						/* information */
-						memset(c->err_info, 0,
-						       sizeof
-						       (ErrorInfo_struct));
-						goto resend_cmd1;
-					} else {
-						printk(KERN_WARNING
-						       "cciss%d: retried %p too "
-						       "many times\n", ctlr, c);
-						status = IO_ERROR;
-						goto cleanup1;
-					}
-				} else if (c->err_info->CommandStatus ==
-					   CMD_UNABORTABLE) {
-					printk(KERN_WARNING
-					       "cciss%d: command could not be aborted.\n",
-					       ctlr);
-					status = IO_ERROR;
-					goto cleanup1;
-				}
-				printk(KERN_WARNING "ciss ciss%d: sendcmd"
-				       " Error %x \n", ctlr,
-				       c->err_info->CommandStatus);
-				printk(KERN_WARNING "ciss ciss%d: sendcmd"
-				       " offensive info\n"
-				       "  size %x\n   num %x   value %x\n",
-				       ctlr,
-				       c->err_info->MoreErrInfo.Invalid_Cmd.
-				       offense_size,
-				       c->err_info->MoreErrInfo.Invalid_Cmd.
-				       offense_num,
-				       c->err_info->MoreErrInfo.Invalid_Cmd.
-				       offense_value);
-				status = IO_ERROR;
-				goto cleanup1;
-			}
+		/* If it's not the cmd we're looking for, save it for later */
+		if ((complete & ~CISS_ERROR_BIT) != c->busaddr) {
+			if (add_sendcmd_reject(c->Request.CDB[0],
+				h->ctlr, complete) != 0)
+				BUG(); /* we are hosed if we get here. */
+			continue;
+		}
+
+		/* It is our command.  If no error, we're done. */
+		if (!(complete & CISS_ERROR_BIT)) {
+			status = IO_OK;
+			break;
+		}
+
+		/* There is an error... */
+
+		/* if data overrun or underun on Report command ignore it */
+		if (((c->Request.CDB[0] == CISS_REPORT_LOG) ||
+		     (c->Request.CDB[0] == CISS_REPORT_PHYS) ||
+		     (c->Request.CDB[0] == CISS_INQUIRY)) &&
+			((c->err_info->CommandStatus == CMD_DATA_OVERRUN) ||
+			 (c->err_info->CommandStatus == CMD_DATA_UNDERRUN))) {
+			complete = c->busaddr;
+			status = IO_OK;
+			break;
 		}
-		/* This will need changing for direct lookup completions */
-		if (complete != c->busaddr) {
-			if (add_sendcmd_reject(cmd, ctlr, complete) != 0) {
-				BUG();	/* we are pretty much hosed if we get here. */
+
+		if (c->err_info->CommandStatus == CMD_UNSOLICITED_ABORT) {
+			printk(KERN_WARNING "cciss%d: unsolicited abort %p\n",
+				h->ctlr, c);
+			if (c->retry_count < MAX_CMD_RETRIES) {
+				printk(KERN_WARNING "cciss%d: retrying %p\n",
+				   h->ctlr, c);
+				c->retry_count++;
+				/* erase the old error information */
+				memset(c->err_info, 0, sizeof(c->err_info));
+				goto resend_cmd1;
 			}
-			continue;
-		} else
-			done = 1;
-	} while (!done);
+			printk(KERN_WARNING "cciss%d: retried %p too many "
+				"times\n", h->ctlr, c);
+			status = IO_ERROR;
+			goto cleanup1;
+		}
+
+		if (c->err_info->CommandStatus == CMD_UNABORTABLE) {
+			printk(KERN_WARNING "cciss%d: command could not be "
+				"aborted.\n", h->ctlr);
+			status = IO_ERROR;
+			goto cleanup1;
+		}
 
-      cleanup1:
+		printk(KERN_WARNING "cciss%d: sendcmd error\n", h->ctlr);
+		printk(KERN_WARNING "cmd = 0x%02x, CommandStatus = 0x%02x\n",
+			c->Request.CDB[0], c->err_info->CommandStatus);
+		if (c->err_info->CommandStatus == CMD_TARGET_STATUS) {
+			printk(KERN_WARNING "Target status = 0x%02x\n",
+			c->err_info->ScsiStatus);
+			if (c->err_info->ScsiStatus == 2) /* chk cond */
+				printk(KERN_WARNING "Sense key = 0x%02x\n",
+					0xf & c->err_info->SenseInfo[2]);
+		}
+
+		status = IO_ERROR;
+		goto cleanup1;
+
+	} while (1);
+
+cleanup1:
 	/* unlock the data buffer from DMA */
 	buff_dma_handle.val32.lower = c->SG[0].Addr.lower;
 	buff_dma_handle.val32.upper = c->SG[0].Addr.upper;
-	pci_unmap_single(info_p->pdev, (dma_addr_t) buff_dma_handle.val,
+	pci_unmap_single(h->pdev, (dma_addr_t) buff_dma_handle.val,
 			 c->SG[0].Len, PCI_DMA_BIDIRECTIONAL);
 #ifdef CONFIG_CISS_SCSI_TAPE
 	/* if we saved some commands for later, process them now. */
-	if (info_p->scsi_rejects.ncompletions > 0)
-		do_cciss_intr(0, info_p);
+	if (h->scsi_rejects.ncompletions > 0)
+		do_cciss_intr(0, h);
 #endif
-	cmd_free(info_p, c, 1);
+	return status;
+}
+
+/*
+ * Send a command to the controller, and wait for it to complete.
+ * Used at init time, and during SCSI error recovery.
+ */
+static int sendcmd(__u8 cmd, int ctlr, void *buff, size_t size,
+	unsigned int use_unit_num,/* 0: address the controller,
+				     1: address logical volume log_unit,
+				     2: periph device address is scsi3addr */
+	unsigned int log_unit,
+	__u8 page_code, unsigned char *scsi3addr, int cmd_type)
+{
+	CommandList_struct *c;
+	int status;
+
+	c = cmd_alloc(hba[ctlr], 1);
+	if (!c) {
+		printk(KERN_WARNING "cciss: unable to get memory");
+		return IO_ERROR;
+	}
+	status = fill_cmd(c, cmd, ctlr, buff, size, use_unit_num,
+			  log_unit, page_code, scsi3addr, cmd_type);
+	if (status == IO_OK)
+		status = sendcmd_core(hba[ctlr], c);
+	cmd_free(hba[ctlr], c, 1);
 	return status;
 }
 
_
