From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 23/24] advansys: Improve interrupt handler
Date: Fri, 27 Jul 2007 07:42:32 -0600
Message-ID: <11855437542538-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:50070 "EHLO
	smtp-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933450AbXG0Nmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:37 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
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
 drivers/scsi/advansys.c |  155 ++++++++++++++++++++--------------------------
 1 files changed, 67 insertions(+), 88 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e5fb694..548ffcd 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -61,6 +61,10 @@
  *    the interrupt handler. In the timeout function if the interrupt
  *    has not occurred then print a message and run in polled mode.
  * 4. Need to add support for target mode commands, cf. CAM XPT.
+ * 5. check DMA mapping functions for failure
+ * 6. Remove internal queueing
+ * 7. Use scsi_transport_spi
+ * 8. advansys_info is not safe against multiple simultaneous callers
  */
 #warning this driver is still not properly converted to the DMA API
 
@@ -2940,7 +2944,6 @@ static PortAddr _asc_def_iop_base[];
  * --- Driver Function Prototypes
  */
 
-static irqreturn_t advansys_interrupt(int, void *);
 static int advansys_slave_configure(struct scsi_device *);
 static void asc_scsi_done_list(struct scsi_cmnd *);
 static int asc_execute_scsi_cmnd(struct scsi_cmnd *);
@@ -3645,89 +3648,76 @@ static struct scsi_host_template advansys_template = {
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
-		if (!shost)
-			continue;
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
-			ASC_DBG2(1, "advansys_interrupt: done_scp 0x%p, "
-				 "last_scp 0x%p\n", done_scp, last_scp);
-
-			/* Start any waiting commands for the board. */
-			if (!ASC_QUEUE_EMPTY(&boardp->waiting)) {
-				ASC_DBG(1, "advansys_interrupt: before "
-					"asc_execute_queue()\n");
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
-				done_scp = asc_dequeue_list(&boardp->done,
-							&last_scp, ASC_TID_ALL);
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
@@ -3739,7 +3729,7 @@ static irqreturn_t advansys_interrupt(int irq, void *dev_id)
 	asc_scsi_done_list(done_scp);
 
 	ASC_DBG(1, "advansys_interrupt: end\n");
-	return IRQ_HANDLED;
+	return result;
 }
 
 static void
@@ -16934,20 +16924,9 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 
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
-	ret = request_irq(shost->irq, advansys_interrupt,
-			  share_irq | IRQF_DISABLED, "advansys", boardp);
-	if (ret)
-		ret = request_irq(shost->irq, advansys_interrupt,
-				  share_irq, "advansys", boardp);
+
+	ret = request_irq(shost->irq, advansys_interrupt, share_irq,
+			  "advansys", shost);
 
 	if (ret) {
 		if (ret == -EBUSY) {
@@ -17003,7 +16982,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 		boardp->adv_sgblkp = sgp->next_sgblkp;
 		kfree(sgp);
 	}
-	free_irq(shost->irq, boardp);
+	free_irq(shost->irq, shost);
  err_free_dma:
 	if (shost->dma_channel != NO_ISA_DMA)
 		free_dma(shost->dma_channel);
@@ -17201,7 +17180,7 @@ static int advansys_release(struct Scsi_Host *shost)
 
 	ASC_DBG(1, "advansys_release: begin\n");
 	boardp = ASC_BOARDP(shost);
-	free_irq(shost->irq, boardp);
+	free_irq(shost->irq, shost);
 	if (shost->dma_channel != NO_ISA_DMA) {
 		ASC_DBG(1, "advansys_release: free_dma()\n");
 		free_dma(shost->dma_channel);
-- 
1.4.4.4

