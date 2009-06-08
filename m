From: scameron@beardog.cca.cpqcorp.net
Subject: [patch 7/8] cciss: Remove no longer needed sendcmd reject processing code
Date: Mon, 8 Jun 2009 16:09:32 -0500
Message-ID: <20090608210932.GM23523@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756005AbZFHVJX@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, akpm@linux-foundation.org
Cc: scameron@beardog.cca.cpqcorp.net, mikem@beardog.cca.cpqcorp.net
List-Id: linux-scsi@vger.kernel.org



Now that the cciss SCSI error handling routines operate with interrupts
enabled, we no longer need to maintain the list of command completions that
sendcmd() might inadvertantly scoop up, since now it only runs at driver init
time, and there won't be any other commands for it to scoop up.  So we
can remove that list and the code that adds to it and processes it.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
---

---


diff -puN drivers/block/cciss.c~cciss_remove_sendcmd_reject_processing drivers/block/cciss.c
--- linux-next/drivers/block/cciss.c~cciss_remove_sendcmd_reject_processing	2009-06-08 12:59:10.000000000 -0500
+++ linux-next-scameron/drivers/block/cciss.c	2009-06-08 12:59:10.000000000 -0500
@@ -2612,51 +2612,6 @@ static unsigned long pollcomplete(int ct
 	return 1;
 }
 
-static int add_sendcmd_reject(__u8 cmd, int ctlr, unsigned long complete)
-{
-	/* We get in here if sendcmd() is polling for completions
-	   and gets some command back that it wasn't expecting --
-	   something other than that which it just sent down.
-	   Ordinarily, that shouldn't happen, but it can happen when
-	   the scsi tape stuff gets into error handling mode, and
-	   starts using sendcmd() to try to abort commands and
-	   reset tape drives.  In that case, sendcmd may pick up
-	   completions of commands that were sent to logical drives
-	   through the block i/o system, or cciss ioctls completing, etc.
-	   In that case, we need to save those completions for later
-	   processing by the interrupt handler.
-	 */
-
-#ifdef CONFIG_CISS_SCSI_TAPE
-	struct sendcmd_reject_list *srl = &hba[ctlr]->scsi_rejects;
-
-	/* If it's not the scsi tape stuff doing error handling, (abort */
-	/* or reset) then we don't expect anything weird. */
-	if (cmd != CCISS_RESET_MSG && cmd != CCISS_ABORT_MSG) {
-#endif
-		printk(KERN_WARNING "cciss cciss%d: SendCmd "
-		       "Invalid command list address returned! (%lx)\n",
-		       ctlr, complete);
-		/* not much we can do. */
-#ifdef CONFIG_CISS_SCSI_TAPE
-		return 1;
-	}
-
-	/* We've sent down an abort or reset, but something else
-	   has completed */
-	if (srl->ncompletions >= (hba[ctlr]->nr_cmds + 2)) {
-		/* Uh oh.  No room to save it for later... */
-		printk(KERN_WARNING "cciss%d: Sendcmd: Invalid command addr, "
-		       "reject list overflow, command lost!\n", ctlr);
-		return 1;
-	}
-	/* Save it for later */
-	srl->complete[srl->ncompletions] = complete;
-	srl->ncompletions++;
-#endif
-	return 0;
-}
-
 /* Send command c to controller h and poll for it to complete.
  * Turns interrupts off on the board.  Used at driver init time
  * and during SCSI error recovery.
@@ -2701,11 +2656,10 @@ resend_cmd1:
 			break;
 		}
 
-		/* If it's not the cmd we're looking for, save it for later */
+		/* Make sure it's the command we're expecting. */
 		if ((complete & ~CISS_ERROR_BIT) != c->busaddr) {
-			if (add_sendcmd_reject(c->Request.CDB[0],
-				h->ctlr, complete) != 0)
-				BUG(); /* we are hosed if we get here. */
+			printk(KERN_WARNING "cciss%d: Unexpected command "
+				"completion.\n", h->ctlr);
 			continue;
 		}
 
@@ -2770,11 +2724,6 @@ resend_cmd1:
 	buff_dma_handle.val32.upper = c->SG[0].Addr.upper;
 	pci_unmap_single(h->pdev, (dma_addr_t) buff_dma_handle.val,
 			 c->SG[0].Len, PCI_DMA_BIDIRECTIONAL);
-#ifdef CONFIG_CISS_SCSI_TAPE
-	/* if we saved some commands for later, process them now. */
-	if (h->scsi_rejects.ncompletions > 0)
-		do_cciss_intr(0, h);
-#endif
 	return status;
 }
 
@@ -3195,44 +3144,18 @@ startio:
 
 static inline unsigned long get_next_completion(ctlr_info_t *h)
 {
-#ifdef CONFIG_CISS_SCSI_TAPE
-	/* Any rejects from sendcmd() lying around? Process them first */
-	if (h->scsi_rejects.ncompletions == 0)
-		return h->access.command_completed(h);
-	else {
-		struct sendcmd_reject_list *srl;
-		int n;
-		srl = &h->scsi_rejects;
-		n = --srl->ncompletions;
-		/* printk("cciss%d: processing saved reject\n", h->ctlr); */
-		printk("p");
-		return srl->complete[n];
-	}
-#else
 	return h->access.command_completed(h);
-#endif
 }
 
 static inline int interrupt_pending(ctlr_info_t *h)
 {
-#ifdef CONFIG_CISS_SCSI_TAPE
-	return (h->access.intr_pending(h)
-		|| (h->scsi_rejects.ncompletions > 0));
-#else
 	return h->access.intr_pending(h);
-#endif
 }
 
 static inline long interrupt_not_for_us(ctlr_info_t *h)
 {
-#ifdef CONFIG_CISS_SCSI_TAPE
-	return (((h->access.intr_pending(h) == 0) ||
-		 (h->interrupts_enabled == 0))
-		&& (h->scsi_rejects.ncompletions == 0));
-#else
 	return (((h->access.intr_pending(h) == 0) ||
 		 (h->interrupts_enabled == 0)));
-#endif
 }
 
 static irqreturn_t do_cciss_intr(int irq, void *dev_id)
@@ -4054,15 +3977,6 @@ static int __devinit cciss_init_one(stru
 		printk(KERN_ERR "cciss: out of memory");
 		goto clean4;
 	}
-#ifdef CONFIG_CISS_SCSI_TAPE
-	hba[i]->scsi_rejects.complete =
-	    kmalloc(sizeof(hba[i]->scsi_rejects.complete[0]) *
-		    (hba[i]->nr_cmds + 5), GFP_KERNEL);
-	if (hba[i]->scsi_rejects.complete == NULL) {
-		printk(KERN_ERR "cciss: out of memory");
-		goto clean4;
-	}
-#endif
 	spin_lock_init(&hba[i]->lock);
 
 	/* Initialize the pdev driver private data.
@@ -4122,9 +4036,6 @@ static int __devinit cciss_init_one(stru
 
 clean4:
 	kfree(inq_buff);
-#ifdef CONFIG_CISS_SCSI_TAPE
-	kfree(hba[i]->scsi_rejects.complete);
-#endif
 	kfree(hba[i]->cmd_pool_bits);
 	if (hba[i]->cmd_pool)
 		pci_free_consistent(hba[i]->pdev,
@@ -4242,9 +4153,6 @@ static void __devexit cciss_remove_one(s
 	pci_free_consistent(hba[i]->pdev, hba[i]->nr_cmds * sizeof(ErrorInfo_struct),
 			    hba[i]->errinfo_pool, hba[i]->errinfo_pool_dhandle);
 	kfree(hba[i]->cmd_pool_bits);
-#ifdef CONFIG_CISS_SCSI_TAPE
-	kfree(hba[i]->scsi_rejects.complete);
-#endif
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
diff -puN drivers/block/cciss.h~cciss_remove_sendcmd_reject_processing drivers/block/cciss.h
--- linux-next/drivers/block/cciss.h~cciss_remove_sendcmd_reject_processing	2009-06-08 12:59:10.000000000 -0500
+++ linux-next-scameron/drivers/block/cciss.h	2009-06-08 12:59:10.000000000 -0500
@@ -53,14 +53,6 @@ typedef struct _drive_info_struct
 	char rev[REV_LEN + 1];       /* SCSI revision string */
 } drive_info_struct;
 
-#ifdef CONFIG_CISS_SCSI_TAPE
-
-struct sendcmd_reject_list {
-	int ncompletions;
-	unsigned long *complete; /* array of NR_CMDS tags */
-};
-
-#endif
 struct ctlr_info 
 {
 	int	ctlr;
@@ -128,7 +120,6 @@ struct ctlr_info
 	void *scsi_ctlr; /* ptr to structure containing scsi related stuff */
 	/* list of block side commands the scsi error handling sucked up */
 	/* and saved for later processing */
-	struct sendcmd_reject_list scsi_rejects;
 #endif
 	unsigned char alive;
 	struct completion *rescan_wait;
_
