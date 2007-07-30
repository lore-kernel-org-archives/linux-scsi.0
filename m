From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 3/23] advansys: Improve interrupt handler
Date: Mon, 30 Jul 2007 10:56:48 -0600
Message-ID: <11858146282602-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:59932 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbXG3Q5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:10 -0400
In-Reply-To: <1185814628978-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Pass the Scsi_Host to the interrupt handler, rather than polling all
hosts for each interrupt.
Return IRQ_NONE if we didn't handle this interrupt
Don't set the IRQF_DISABLED flag; this is not a fast-executing interrupt
handler.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |  172 ++++++++++++++++++++---------------------------
 1 files changed, 72 insertions(+), 100 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 6d11076..a407ff3 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3951,7 +3951,6 @@ static PortAddr _asc_def_iop_base[];
  * advansys.h contains function prototypes for functions global to Linux.
  */
 
-static irqreturn_t advansys_interrupt(int, void *);
 static int advansys_slave_configure(struct scsi_device *);
 static void asc_scsi_done_list(struct scsi_cmnd *);
 static int asc_execute_scsi_cmnd(struct scsi_cmnd *);
@@ -4684,89 +4683,76 @@ static struct scsi_host_template driver_template = {
  */
 static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 {
-	ulong flags;
-	int i;
-	asc_board_t *boardp;
+	unsigned long flags;
 	struct scsi_cmnd *done_scp = NULL, *last_scp = NULL;
 	struct scsi_cmnd *new_last_scp;
-	struct Scsi_Host *shost;
+	struct Scsi_Host *shost = dev_id;
+	asc_board_t *boardp = ASC_BOARDP(shost);
+	irqreturn_t result = IRQ_NONE;
 
-	ASC_DBG(1, "advansys_interrupt: begin\n");
+	ASC_DBG1(2, "advansys_interrupt: boardp 0x%p\n", boardp);
+	spin_lock_irqsave(&boardp->lock, flags);
+	if (ASC_NARROW_BOARD(boardp)) {
+		/*
+		 * Narrow Board
+		 */
+		if (AscIsIntPending(shost->io_port)) {
+			result = IRQ_HANDLED;
+			ASC_STATS(shost, interrupt);
+			ASC_DBG(1, "advansys_interrupt: before AscISR()\n");
+			AscISR(&boardp->dvc_var.asc_dvc_var);
+		}
+	} else {
+		/*
+		 * Wide Board
+		 */
+		ASC_DBG(1, "advansys_interrupt: before AdvISR()\n");
+		if (AdvISR(&boardp->dvc_var.adv_dvc_var)) {
+			result = IRQ_HANDLED;
+			ASC_STATS(shost, interrupt);
+		}
+	}
 
 	/*
-	 * Check for interrupts on all boards.
-	 * AscISR() will call asc_isr_callback().
-	 */
-	for (i = 0; i < asc_board_count; i++) {
-		shost = asc_host[i];
-		boardp = ASC_BOARDP(shost);
-		ASC_DBG2(2, "advansys_interrupt: i %d, boardp 0x%lx\n",
-			 i, (ulong)boardp);
-		spin_lock_irqsave(&boardp->lock, flags);
-		if (ASC_NARROW_BOARD(boardp)) {
-			/*
-			 * Narrow Board
-			 */
-			if (AscIsIntPending(shost->io_port)) {
-				ASC_STATS(shost, interrupt);
-				ASC_DBG(1,
-					"advansys_interrupt: before AscISR()\n");
-				AscISR(&boardp->dvc_var.asc_dvc_var);
-			}
-		} else {
-			/*
-			 * Wide Board
-			 */
-			ASC_DBG(1, "advansys_interrupt: before AdvISR()\n");
-			if (AdvISR(&boardp->dvc_var.adv_dvc_var)) {
-				ASC_STATS(shost, interrupt);
-			}
+	 * Start waiting requests and create a list of completed requests.
+	 *
+	 * If a reset request is being performed for the board, the reset
+	 * handler will complete pending requests after it has completed.
+	 */
+	if ((boardp->flags & ASC_HOST_IN_RESET) == 0) {
+		ASC_DBG2(1, "advansys_interrupt: done_scp 0x%p, "
+			 "last_scp 0x%p\n", done_scp, last_scp);
+
+		/* Start any waiting commands for the board. */
+		if (!ASC_QUEUE_EMPTY(&boardp->waiting)) {
+			ASC_DBG(1, "advansys_interrupt: before "
+				"asc_execute_queue()\n");
+			asc_execute_queue(&boardp->waiting);
 		}
 
 		/*
-		 * Start waiting requests and create a list of completed requests.
+		 * Add to the list of requests that must be completed.
 		 *
-		 * If a reset request is being performed for the board, the reset
-		 * handler will complete pending requests after it has completed.
+		 * 'done_scp' will always be NULL on the first iteration of
+		 * this loop. 'last_scp' is set at the same time as 'done_scp'.
 		 */
-		if ((boardp->flags & ASC_HOST_IN_RESET) == 0) {
-			ASC_DBG2(1,
-				 "advansys_interrupt: done_scp 0x%lx, last_scp 0x%lx\n",
-				 (ulong)done_scp, (ulong)last_scp);
-
-			/* Start any waiting commands for the board. */
-			if (!ASC_QUEUE_EMPTY(&boardp->waiting)) {
-				ASC_DBG(1,
-					"advansys_interrupt: before asc_execute_queue()\n");
-				asc_execute_queue(&boardp->waiting);
-			}
-
-			/*
-			 * Add to the list of requests that must be completed.
-			 *
-			 * 'done_scp' will always be NULL on the first iteration
-			 * of this loop. 'last_scp' is set at the same time as
-			 * 'done_scp'.
-			 */
-			if (done_scp == NULL) {
-				done_scp =
-				    asc_dequeue_list(&boardp->done, &last_scp,
-						     ASC_TID_ALL);
-			} else {
-				ASC_ASSERT(last_scp != NULL);
-				last_scp->host_scribble =
-				    (unsigned char *)asc_dequeue_list(&boardp->
-								      done,
-								      &new_last_scp,
-								      ASC_TID_ALL);
-				if (new_last_scp != NULL) {
-					ASC_ASSERT(REQPNEXT(last_scp) != NULL);
-					last_scp = new_last_scp;
-				}
+		if (done_scp == NULL) {
+			done_scp = asc_dequeue_list(&boardp->done,
+						&last_scp, ASC_TID_ALL);
+		} else {
+			ASC_ASSERT(last_scp != NULL);
+			last_scp->host_scribble =
+			    (unsigned char *)asc_dequeue_list(&boardp->
+							      done,
+							      &new_last_scp,
+							      ASC_TID_ALL);
+			if (new_last_scp != NULL) {
+				ASC_ASSERT(REQPNEXT(last_scp) != NULL);
+				last_scp = new_last_scp;
 			}
 		}
-		spin_unlock_irqrestore(&boardp->lock, flags);
 	}
+	spin_unlock_irqrestore(&boardp->lock, flags);
 
 	/*
 	 * If interrupts were enabled on entry, then they
@@ -4778,7 +4764,7 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 	asc_scsi_done_list(done_scp);
 
 	ASC_DBG(1, "advansys_interrupt: end\n");
-	return IRQ_HANDLED;
+	return result;
 }
 
 /*
@@ -17764,7 +17750,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	ASC_DVC_VAR *asc_dvc_varp = NULL;
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
 	adv_sgblk_t *sgp = NULL;
-	int share_irq = FALSE;
+	int share_irq;
 	int iolen = 0;
 	ADV_PADDR pci_memory_address;
 	int warn_code, err_code;
@@ -17918,15 +17904,15 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 #ifdef CONFIG_ISA
 		case ASC_IS_ISA:
 			shost->unchecked_isa_dma = TRUE;
-			share_irq = FALSE;
+			share_irq = 0;
 			break;
 		case ASC_IS_VL:
 			shost->unchecked_isa_dma = FALSE;
-			share_irq = FALSE;
+			share_irq = 0;
 			break;
 		case ASC_IS_EISA:
 			shost->unchecked_isa_dma = FALSE;
-			share_irq = TRUE;
+			share_irq = IRQF_SHARED;
 			break;
 #endif /* CONFIG_ISA */
 #ifdef CONFIG_PCI
@@ -17937,7 +17923,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 					 PCI_SLOT(pdev->devfn),
 					 PCI_FUNC(pdev->devfn));
 			shost->unchecked_isa_dma = FALSE;
-			share_irq = TRUE;
+			share_irq = IRQF_SHARED;
 			break;
 #endif /* CONFIG_PCI */
 		default:
@@ -17945,7 +17931,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 			    ("advansys_board_found: board %d: unknown adapter type: %d\n",
 			     boardp->id, asc_dvc_varp->bus_type);
 			shost->unchecked_isa_dma = TRUE;
-			share_irq = FALSE;
+			share_irq = 0;
 			break;
 		}
 	} else {
@@ -17961,7 +17947,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 				 PCI_SLOT(pdev->devfn),
 				 PCI_FUNC(pdev->devfn));
 		shost->unchecked_isa_dma = FALSE;
-		share_irq = TRUE;
+		share_irq = IRQF_SHARED;
 #endif /* CONFIG_PCI */
 	}
 
@@ -18425,25 +18411,11 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 
 	/* Register IRQ Number. */
 	ASC_DBG1(2, "advansys_board_found: request_irq() %d\n", shost->irq);
-	/*
-	 * If request_irq() fails with the IRQF_DISABLED flag set,
-	 * then try again without the IRQF_DISABLED flag set. This
-	 * allows IRQ sharing to work even with other drivers that
-	 * do not set the IRQF_DISABLED flag.
-	 *
-	 * If IRQF_DISABLED is not set, then interrupts are enabled
-	 * before the driver interrupt function is called.
-	 */
-	if (((ret = request_irq(shost->irq, advansys_interrupt,
-				IRQF_DISABLED | (share_irq ==
-						 TRUE ?
-						 IRQF_SHARED :
-						 0), "advansys", boardp)) != 0)
-	    &&
-	    ((ret =
-	      request_irq(shost->irq, advansys_interrupt,
-			  (share_irq == TRUE ? IRQF_SHARED : 0),
-			  "advansys", boardp)) != 0)) {
+
+	ret = request_irq(shost->irq, advansys_interrupt, share_irq,
+			  "advansys", shost);
+
+	if (ret) {
 		if (ret == -EBUSY) {
 			ASC_PRINT2
 			    ("advansys_board_found: board %d: request_irq(): IRQ 0x%x already in use.\n",
@@ -18644,7 +18616,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 #ifdef CONFIG_PROC_FS
 		kfree(boardp->prtbuf);
 #endif /* CONFIG_PROC_FS */
-		free_irq(shost->irq, boardp);
+		free_irq(shost->irq, shost);
 		scsi_unregister(shost);
 		asc_board_count--;
 		return NULL;
@@ -18960,7 +18932,7 @@ static int advansys_release(struct Scsi_Host *shost)
 
 	ASC_DBG(1, "advansys_release: begin\n");
 	boardp = ASC_BOARDP(shost);
-	free_irq(shost->irq, boardp);
+	free_irq(shost->irq, shost);
 	if (shost->dma_channel != NO_ISA_DMA) {
 		ASC_DBG(1, "advansys_release: free_dma()\n");
 		free_dma(shost->dma_channel);
-- 
1.4.4.4

