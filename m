From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix up NCR5380 private data
Date: Fri, 6 Feb 2004 17:00:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040206160046.GB4786@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:5829 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265535AbUBFQAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2004 11:00:50 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Use the private data passed to request_irq instead of looping over all
controllers.  The patch was ACKed by Alan a while ago.

Note that the patch only looks so huge because of the two leves of
indentation removed by the tiny chage.

--- 1.23/drivers/scsi/NCR5380.c	Sun Sep 28 02:38:22 2003
+++ edited/drivers/scsi/NCR5380.c	Wed Feb  4 04:58:00 2004
@@ -1326,81 +1326,71 @@
 static irqreturn_t NCR5380_intr(int irq, void *dev_id, struct pt_regs *regs) 
 {
 	NCR5380_local_declare();
-	struct Scsi_Host *instance;
+	struct Scsi_Host *instance = (struct Scsi_Host *)dev_id;
+	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	int done;
 	unsigned char basr;
-	struct NCR5380_hostdata *hostdata;
-	int handled = 0;
 
 	dprintk(NDEBUG_INTR, ("scsi : NCR5380 irq %d triggered\n", irq));
 
 	do {
 		done = 1;
-		/* The instance list is constant while the driver is
-		   loaded */
-		for (hostdata = first_host; hostdata != NULL; hostdata = hostdata->next)
-		{
-			instance = hostdata->host;
-			if (instance->irq == irq) {
-				handled = 1;
-				spin_lock_irq(instance->host_lock);
-				/* Look for pending interrupts */
-				NCR5380_setup(instance);
-				basr = NCR5380_read(BUS_AND_STATUS_REG);
-				/* XXX dispatch to appropriate routine if found and done=0 */
-				if (basr & BASR_IRQ) {
-					NCR5380_dprint(NDEBUG_INTR, instance);
-					if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
-						done = 0;
-						dprintk(NDEBUG_INTR, ("scsi%d : SEL interrupt\n", instance->host_no));
-						NCR5380_reselect(instance);
-						(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-					} else if (basr & BASR_PARITY_ERROR) {
-						dprintk(NDEBUG_INTR, ("scsi%d : PARITY interrupt\n", instance->host_no));
-						(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-					} else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
-						dprintk(NDEBUG_INTR, ("scsi%d : RESET interrupt\n", instance->host_no));
-						(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-					} else {
+		spin_lock_irq(instance->host_lock);
+		/* Look for pending interrupts */
+		NCR5380_setup(instance);
+		basr = NCR5380_read(BUS_AND_STATUS_REG);
+		/* XXX dispatch to appropriate routine if found and done=0 */
+		if (basr & BASR_IRQ) {
+			NCR5380_dprint(NDEBUG_INTR, instance);
+			if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
+				done = 0;
+				dprintk(NDEBUG_INTR, ("scsi%d : SEL interrupt\n", instance->host_no));
+				NCR5380_reselect(instance);
+				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+			} else if (basr & BASR_PARITY_ERROR) {
+				dprintk(NDEBUG_INTR, ("scsi%d : PARITY interrupt\n", instance->host_no));
+				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+			} else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
+				dprintk(NDEBUG_INTR, ("scsi%d : RESET interrupt\n", instance->host_no));
+				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+			} else {
 #if defined(REAL_DMA)
-						/*
-						 * We should only get PHASE MISMATCH and EOP interrupts
-						 * if we have DMA enabled, so do a sanity check based on
-						 * the current setting of the MODE register.
-						 */
-
-						if ((NCR5380_read(MODE_REG) & MR_DMA) && ((basr & BASR_END_DMA_TRANSFER) || !(basr & BASR_PHASE_MATCH))) {
-							int transfered;
-
-							if (!hostdata->connected)
-								panic("scsi%d : received end of DMA interrupt with no connected cmd\n", instance->hostno);
-
-							transfered = (hostdata->dmalen - NCR5380_dma_residual(instance));
-							hostdata->connected->SCp.this_residual -= transferred;
-							hostdata->connected->SCp.ptr += transferred;
-							hostdata->dmalen = 0;
+				/*
+				 * We should only get PHASE MISMATCH and EOP interrupts
+				 * if we have DMA enabled, so do a sanity check based on
+				 * the current setting of the MODE register.
+				 */
+
+				if ((NCR5380_read(MODE_REG) & MR_DMA) && ((basr & BASR_END_DMA_TRANSFER) || !(basr & BASR_PHASE_MATCH))) {
+					int transfered;
+
+					if (!hostdata->connected)
+						panic("scsi%d : received end of DMA interrupt with no connected cmd\n", instance->hostno);
+
+					transfered = (hostdata->dmalen - NCR5380_dma_residual(instance));
+					hostdata->connected->SCp.this_residual -= transferred;
+					hostdata->connected->SCp.ptr += transferred;
+					hostdata->dmalen = 0;
 
-							(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+					(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 							
-							/* FIXME: we need to poll briefly then defer a workqueue task ! */
-							NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG, BASR_ACK, 0, 2*HZ);
+					/* FIXME: we need to poll briefly then defer a workqueue task ! */
+					NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG, BASR_ACK, 0, 2*HZ);
 
-							NCR5380_write(MODE_REG, MR_BASE);
-							NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-						}
+					NCR5380_write(MODE_REG, MR_BASE);
+					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+				}
 #else
-						dprintk(NDEBUG_INTR, ("scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n", basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG)));
-						(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+				dprintk(NDEBUG_INTR, ("scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n", basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG)));
+				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 #endif
-					}
-				}	/* if BASR_IRQ */
-				spin_unlock_irq(instance->host_lock);
-				if(!done)
-					schedule_work(&hostdata->coroutine);
-			}	/* if (instance->irq == irq) */
-		}
+			}
+		}	/* if BASR_IRQ */
+		spin_unlock_irq(instance->host_lock);
+		if(!done)
+			schedule_work(&hostdata->coroutine);
 	} while (!done);
-	return IRQ_RETVAL(handled);
+	return IRQ_HANDLED;
 }
 
 #endif 
--- 1.25/drivers/scsi/g_NCR5380.c	Thu Jan 15 16:23:42 2004
+++ edited/drivers/scsi/g_NCR5380.c	Wed Feb  4 05:06:38 2004
@@ -450,7 +450,7 @@
 			instance->irq = NCR5380_probe_irq(instance, 0xffff);
 
 		if (instance->irq != SCSI_IRQ_NONE)
-			if (request_irq(instance->irq, generic_NCR5380_intr, SA_INTERRUPT, "NCR5380", NULL)) {
+			if (request_irq(instance->irq, generic_NCR5380_intr, SA_INTERRUPT, "NCR5380", instance)) {
 				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
 			}
