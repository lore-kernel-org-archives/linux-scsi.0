From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 39/78] ncr5380: Standardize interrupt handling
Date: Sun, 03 Jan 2016 16:05:40 +1100
Message-ID: <20160103050511.361927211@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-standardize-interrupt-handling
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Because interrupt handling is crucial to the core driver(s), all wrapper
drivers need to agree on this code. This patch removes discrepancies.

NCR5380_intr() in NCR5380.c has the following pointless loop that differs
from the code in atari_NCR5380.c.

	done = 1;
	do {
		/* ... */
	} while (!done);

The 'done' flag gets cleared when a reconnected command is to be processed
from the work queue. But in NCR5380.c, the flag is also used to cause the
interrupt conditions to be re-examined. Perhaps this was because
NCR5380_reselect() was expected to cause another interrupt, or perhaps
the remaining present interrupt conditions need to be handled after the
NCR5380_reselect() call?

Actually, both possibilities are bogus, as is the loop itself. It seems
have been overlooked in the hit-and-miss removal of scsi host instance
list iteration many years ago; see history/history.git commit 491447e1fcff
("[PATCH] next NCR5380 updates") and commit 69e1a9482e57 ("[PATCH] fix up
NCR5380 private data"). See also my earlier patch, "Always retry
arbitration and selection".

The datasheet says, "IRQ can be reset simply by reading the Reset
Parity/Interrupt Register". So don't treat the chip IRQ like a
level-triggered interrupt. Of the conditions that set the IRQ flag,
some are level-triggered and some are edge-triggered, which means IRQ
itself must be edge-triggered.

Some interrupt conditions are latched and some are not. Before clearing
the chip IRQ flag, clear all state that may cause it to be raised. That
means clearing the DMA Mode and Busy Monitor bits in the Mode Register
and clearing the host ID in the Select Enable register.

Also clean up some printk's and some comments. Keep atari_NCR5380.c and
NCR5380.c in agreement.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |  187 +++++++++++++++++++++++--------------------
 drivers/scsi/atari_NCR5380.c |  156 +++++++++++++++++------------------
 drivers/scsi/dtc.c           |    8 -
 drivers/scsi/g_NCR5380.c     |    2 
 4 files changed, 180 insertions(+), 173 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:49.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:50.000000000 +1100
@@ -951,85 +951,114 @@ static void NCR5380_main(struct work_str
 #ifndef DONT_USE_INTR
 
 /**
- * 	NCR5380_intr	-	generic NCR5380 irq handler
- *	@irq: interrupt number
- *	@dev_id: device info
- *
- *	Handle interrupts, reestablishing I_T_L or I_T_L_Q nexuses
- *      from the disconnected queue, and restarting NCR5380_main() 
- *      as required.
- *
- *	Locks: takes the needed instance locks
+ * NCR5380_intr - generic NCR5380 irq handler
+ * @irq: interrupt number
+ * @dev_id: device info
+ *
+ * Handle interrupts, reestablishing I_T_L or I_T_L_Q nexuses
+ * from the disconnected queue, and restarting NCR5380_main()
+ * as required.
+ *
+ * The chip can assert IRQ in any of six different conditions. The IRQ flag
+ * is then cleared by reading the Reset Parity/Interrupt Register (RPIR).
+ * Three of these six conditions are latched in the Bus and Status Register:
+ * - End of DMA (cleared by ending DMA Mode)
+ * - Parity error (cleared by reading RPIR)
+ * - Loss of BSY (cleared by reading RPIR)
+ * Two conditions have flag bits that are not latched:
+ * - Bus phase mismatch (non-maskable in DMA Mode, cleared by ending DMA Mode)
+ * - Bus reset (non-maskable)
+ * The remaining condition has no flag bit at all:
+ * - Selection/reselection
+ *
+ * Hence, establishing the cause(s) of any interrupt is partly guesswork.
+ * In "The DP8490 and DP5380 Comparison Guide", National Semiconductor
+ * claimed that "the design of the [DP8490] interrupt logic ensures
+ * interrupts will not be lost (they can be on the DP5380)."
+ * The L5380/53C80 datasheet from LOGIC Devices has more details.
+ *
+ * Checking for bus reset by reading RST is futile because of interrupt
+ * latency, but a bus reset will reset chip logic. Checking for parity error
+ * is unnecessary because that interrupt is never enabled. A Loss of BSY
+ * condition will clear DMA Mode. We can tell when this occurs because the
+ * the Busy Monitor interrupt is enabled together with DMA Mode.
  */
 
-static irqreturn_t NCR5380_intr(int dummy, void *dev_id)
+static irqreturn_t NCR5380_intr(int irq, void *dev_id)
 {
 	struct Scsi_Host *instance = dev_id;
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
-	int done;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	int handled = 0;
 	unsigned char basr;
 	unsigned long flags;
 
-	dprintk(NDEBUG_INTR, "scsi : NCR5380 irq %d triggered\n",
-		instance->irq);
+	spin_lock_irqsave(instance->host_lock, flags);
+
+	basr = NCR5380_read(BUS_AND_STATUS_REG);
+	if (basr & BASR_IRQ) {
+		unsigned char mr = NCR5380_read(MODE_REG);
+		unsigned char sr = NCR5380_read(STATUS_REG);
+
+		dprintk(NDEBUG_INTR, "scsi%d: IRQ %d, BASR 0x%02x, SR 0x%02x, MR 0x%02x\n",
+		        instance->host_no, irq, basr, sr, mr);
 
-	do {
-		done = 1;
-		spin_lock_irqsave(instance->host_lock, flags);
-		/* Look for pending interrupts */
-		basr = NCR5380_read(BUS_AND_STATUS_REG);
-		/* XXX dispatch to appropriate routine if found and done=0 */
-		if (basr & BASR_IRQ) {
-			NCR5380_dprint(NDEBUG_INTR, instance);
-			if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
-				done = 0;
-				dprintk(NDEBUG_INTR, "scsi%d : SEL interrupt\n", instance->host_no);
-				NCR5380_reselect(instance);
-				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-			} else if (basr & BASR_PARITY_ERROR) {
-				dprintk(NDEBUG_INTR, "scsi%d : PARITY interrupt\n", instance->host_no);
-				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-			} else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
-				dprintk(NDEBUG_INTR, "scsi%d : RESET interrupt\n", instance->host_no);
-				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-			} else {
 #if defined(REAL_DMA)
-				/*
-				 * We should only get PHASE MISMATCH and EOP interrupts
-				 * if we have DMA enabled, so do a sanity check based on
-				 * the current setting of the MODE register.
-				 */
+		if ((mr & MR_DMA_MODE) || (mr & MR_MONITOR_BSY)) {
+			/* Probably End of DMA, Phase Mismatch or Loss of BSY.
+			 * We ack IRQ after clearing Mode Register. Workarounds
+			 * for End of DMA errata need to happen in DMA Mode.
+			 */
 
-				if ((NCR5380_read(MODE_REG) & MR_DMA) && ((basr & BASR_END_DMA_TRANSFER) || !(basr & BASR_PHASE_MATCH))) {
-					int transferred;
+			dprintk(NDEBUG_INTR, "scsi%d: interrupt in DMA mode\n", intance->host_no);
 
-					if (!hostdata->connected)
-						panic("scsi%d : received end of DMA interrupt with no connected cmd\n", instance->hostno);
+			int transferred;
 
-					transferred = (hostdata->dmalen - NCR5380_dma_residual(instance));
-					hostdata->connected->SCp.this_residual -= transferred;
-					hostdata->connected->SCp.ptr += transferred;
-					hostdata->dmalen = 0;
-
-					(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-							
-					/* FIXME: we need to poll briefly then defer a workqueue task ! */
-					NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG, BASR_ACK, 0, 2*HZ);
+			if (!hostdata->connected)
+				panic("scsi%d : DMA interrupt with no connected cmd\n",
+				      instance->hostno);
 
-					NCR5380_write(MODE_REG, MR_BASE);
-					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-				}
-#else
-				dprintk(NDEBUG_INTR, "scsi : unknown interrupt, BASR 0x%X, MR 0x%X, SR 0x%x\n", basr, NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG));
-				(void) NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-#endif
+			transferred = hostdata->dmalen - NCR5380_dma_residual(instance);
+			hostdata->connected->SCp.this_residual -= transferred;
+			hostdata->connected->SCp.ptr += transferred;
+			hostdata->dmalen = 0;
+
+			/* FIXME: we need to poll briefly then defer a workqueue task ! */
+			NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG, BASR_ACK, 0, 2 * HZ);
+
+			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+			NCR5380_write(MODE_REG, MR_BASE);
+			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+		} else
+#endif /* REAL_DMA */
+		if ((NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_mask) &&
+		    (sr & (SR_SEL | SR_IO | SR_BSY | SR_RST)) == (SR_SEL | SR_IO)) {
+			/* Probably reselected */
+			NCR5380_write(SELECT_ENABLE_REG, 0);
+			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+
+			dprintk(NDEBUG_INTR, "scsi%d: interrupt with SEL and IO\n",
+			        instance->host_no);
+
+			if (!hostdata->connected) {
+				NCR5380_reselect(instance);
+				queue_work(hostdata->work_q, &hostdata->main_task);
 			}
-		}	/* if BASR_IRQ */
-		spin_unlock_irqrestore(instance->host_lock, flags);
-		if(!done)
-			queue_work(hostdata->work_q, &hostdata->main_task);
-	} while (!done);
-	return IRQ_HANDLED;
+			if (!hostdata->connected)
+				NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+		} else {
+			/* Probably Bus Reset */
+			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+
+			dprintk(NDEBUG_INTR, "scsi%d: unknown interrupt\n", instance->host_no);
+		}
+		handled = 1;
+	} else {
+		shost_printk(KERN_NOTICE, instance, "interrupt without IRQ bit\n");
+	}
+
+	spin_unlock_irqrestore(instance->host_lock, flags);
+
+	return IRQ_RETVAL(handled);
 }
 
 #endif 
@@ -1218,8 +1247,9 @@ static int NCR5380_select(struct Scsi_Ho
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_reselect(instance);
+		if (!hostdata->connected)
+			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		printk("scsi%d : reselection after won arbitration?\n", instance->host_no);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return -1;
 	}
 
@@ -1563,9 +1593,10 @@ static int NCR5380_transfer_dma(struct S
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
 
 #ifdef REAL_DMA
-	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_ENABLE_EOP_INTR | MR_MONITOR_BSY);
+	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY |
+	                        MR_ENABLE_EOP_INTR);
 #elif defined(REAL_DMA_POLL)
-	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE);
+	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY);
 #else
 	/*
 	 * Note : on my sample board, watch-dog timeouts occurred when interrupts
@@ -1573,13 +1604,11 @@ static int NCR5380_transfer_dma(struct S
 	 * before the setting of DMA mode to after transfer of the last byte.
 	 */
 
-	/* KLL May need eop and parity in 53c400 */
 	if (hostdata->flags & FLAG_NCR53C400)
-		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE |
-				MR_ENABLE_PAR_CHECK | MR_ENABLE_PAR_INTR |
-				MR_ENABLE_EOP_INTR | MR_MONITOR_BSY);
+		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY |
+		                        MR_ENABLE_EOP_INTR);
 	else
-		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE);
+		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY);
 #endif				/* def REAL_DMA */
 
 	dprintk(NDEBUG_DMA, "scsi%d : mode reg = 0x%X\n", instance->host_no, NCR5380_read(MODE_REG));
@@ -1768,16 +1797,7 @@ static int NCR5380_transfer_dma(struct S
 	}
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-
-	if ((!(p & SR_IO)) && (hostdata->flags & FLAG_NCR53C400)) {
-		dprintk(NDEBUG_C400_PWRITE, "53C400w: Checking for IRQ\n");
-		if (NCR5380_read(BUS_AND_STATUS_REG) & BASR_IRQ) {
-			dprintk(NDEBUG_C400_PWRITE, "53C400w:    got it, reading reset interrupt reg\n");
-			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-		} else {
-			printk("53C400w:    IRQ NOT THERE!\n");
-		}
-	}
+	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	*data = d + c;
 	*count = 0;
 	*phase = NCR5380_read(STATUS_REG) & PHASE_MASK;
@@ -2269,7 +2289,6 @@ static void NCR5380_dma_complete(NCR5380
 
 	NCR5380_poll_politely(instance, BUS_AND_STATUS_REG, BASR_ACK, 0, 5*HZ);
 
-	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
 	/*
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:48.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:50.000000000 +1100
@@ -1144,12 +1144,6 @@ static void NCR5380_dma_complete(struct
 	int saved_data = 0, overrun = 0;
 	unsigned char p;
 
-	if (!hostdata->connected) {
-		printk(KERN_WARNING "scsi%d: received end of DMA interrupt with "
-		       "no connected cmd\n", HOSTNO);
-		return;
-	}
-
 	if (hostdata->read_overruns) {
 		p = hostdata->connected->SCp.phase;
 		if (p & SR_IO) {
@@ -1164,10 +1158,6 @@ static void NCR5380_dma_complete(struct
 		}
 	}
 
-	dprintk(NDEBUG_DMA, "scsi%d: real DMA transfer complete, basr 0x%X, sr 0x%X\n",
-		   HOSTNO, NCR5380_read(BUS_AND_STATUS_REG),
-		   NCR5380_read(STATUS_REG));
-
 #if defined(CONFIG_SUN3)
 	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request)))) {
 		pr_err("scsi%d: overrun in UDC counter -- not prepared to deal with this!\n",
@@ -1186,9 +1176,9 @@ static void NCR5380_dma_complete(struct
 	}
 #endif
 
-	(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 
 	transferred = hostdata->dma_len - NCR5380_dma_residual(instance);
 	hostdata->dma_len = 0;
@@ -1227,83 +1217,97 @@ static void NCR5380_dma_complete(struct
  * Handle interrupts, reestablishing I_T_L or I_T_L_Q nexuses
  * from the disconnected queue, and restarting NCR5380_main()
  * as required.
+ *
+ * The chip can assert IRQ in any of six different conditions. The IRQ flag
+ * is then cleared by reading the Reset Parity/Interrupt Register (RPIR).
+ * Three of these six conditions are latched in the Bus and Status Register:
+ * - End of DMA (cleared by ending DMA Mode)
+ * - Parity error (cleared by reading RPIR)
+ * - Loss of BSY (cleared by reading RPIR)
+ * Two conditions have flag bits that are not latched:
+ * - Bus phase mismatch (non-maskable in DMA Mode, cleared by ending DMA Mode)
+ * - Bus reset (non-maskable)
+ * The remaining condition has no flag bit at all:
+ * - Selection/reselection
+ *
+ * Hence, establishing the cause(s) of any interrupt is partly guesswork.
+ * In "The DP8490 and DP5380 Comparison Guide", National Semiconductor
+ * claimed that "the design of the [DP8490] interrupt logic ensures
+ * interrupts will not be lost (they can be on the DP5380)."
+ * The L5380/53C80 datasheet from LOGIC Devices has more details.
+ *
+ * Checking for bus reset by reading RST is futile because of interrupt
+ * latency, but a bus reset will reset chip logic. Checking for parity error
+ * is unnecessary because that interrupt is never enabled. A Loss of BSY
+ * condition will clear DMA Mode. We can tell when this occurs because the
+ * the Busy Monitor interrupt is enabled together with DMA Mode.
  */
 
 static irqreturn_t NCR5380_intr(int irq, void *dev_id)
 {
 	struct Scsi_Host *instance = dev_id;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	int done = 1, handled = 0;
+	int handled = 0;
 	unsigned char basr;
 
-	dprintk(NDEBUG_INTR, "scsi%d: NCR5380 irq triggered\n", HOSTNO);
-
-	/* Look for pending interrupts */
 	basr = NCR5380_read(BUS_AND_STATUS_REG);
-	dprintk(NDEBUG_INTR, "scsi%d: BASR=%02x\n", HOSTNO, basr);
-	/* dispatch to appropriate routine if found and done=0 */
 	if (basr & BASR_IRQ) {
-		NCR5380_dprint(NDEBUG_INTR, instance);
-		if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
-			done = 0;
-			dprintk(NDEBUG_INTR, "scsi%d: SEL interrupt\n", HOSTNO);
-			NCR5380_reselect(instance);
-			(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-		} else if (basr & BASR_PARITY_ERROR) {
-			dprintk(NDEBUG_INTR, "scsi%d: PARITY interrupt\n", HOSTNO);
-			(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-		} else if ((NCR5380_read(STATUS_REG) & SR_RST) == SR_RST) {
-			dprintk(NDEBUG_INTR, "scsi%d: RESET interrupt\n", HOSTNO);
-			(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-		} else {
-			/*
-			 * The rest of the interrupt conditions can occur only during a
-			 * DMA transfer
-			 */
+		unsigned char mr = NCR5380_read(MODE_REG);
+		unsigned char sr = NCR5380_read(STATUS_REG);
+
+		dprintk(NDEBUG_INTR, "scsi%d: IRQ %d, BASR 0x%02x, SR 0x%02x, MR 0x%02x\n",
+		        HOSTNO, irq, basr, sr, mr);
 
 #if defined(REAL_DMA)
-			/*
-			 * We should only get PHASE MISMATCH and EOP interrupts if we have
-			 * DMA enabled, so do a sanity check based on the current setting
-			 * of the MODE register.
+		if ((mr & MR_DMA_MODE) || (mr & MR_MONITOR_BSY)) {
+			/* Probably End of DMA, Phase Mismatch or Loss of BSY.
+			 * We ack IRQ after clearing Mode Register. Workarounds
+			 * for End of DMA errata need to happen in DMA Mode.
 			 */
 
-			if ((NCR5380_read(MODE_REG) & MR_DMA_MODE) &&
-			    ((basr & BASR_END_DMA_TRANSFER) ||
-			     !(basr & BASR_PHASE_MATCH))) {
-
-				dprintk(NDEBUG_INTR, "scsi%d: PHASE MISM or EOP interrupt\n", HOSTNO);
-				NCR5380_dma_complete( instance );
-				done = 0;
-			} else
+			dprintk(NDEBUG_INTR, "scsi%d: interrupt in DMA mode\n", HOSTNO);
+
+			if (hostdata->connected) {
+				NCR5380_dma_complete(instance);
+				queue_work(hostdata->work_q, &hostdata->main_task);
+			} else {
+				NCR5380_write(MODE_REG, MR_BASE);
+				NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+			}
+		} else
 #endif /* REAL_DMA */
-			{
-/* MS: Ignore unknown phase mismatch interrupts (caused by EOP interrupt) */
-				if (basr & BASR_PHASE_MATCH)
-					dprintk(NDEBUG_INTR, "scsi%d: unknown interrupt, "
-					       "BASR 0x%x, MR 0x%x, SR 0x%x\n",
-					       HOSTNO, basr, NCR5380_read(MODE_REG),
-					       NCR5380_read(STATUS_REG));
-				(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+		if ((NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_mask) &&
+		    (sr & (SR_SEL | SR_IO | SR_BSY | SR_RST)) == (SR_SEL | SR_IO)) {
+			/* Probably reselected */
+			NCR5380_write(SELECT_ENABLE_REG, 0);
+			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+
+			dprintk(NDEBUG_INTR, "scsi%d: interrupt with SEL and IO\n",
+			        HOSTNO);
+
+			if (!hostdata->connected) {
+				NCR5380_reselect(instance);
+				queue_work(hostdata->work_q, &hostdata->main_task);
+			}
+			if (!hostdata->connected)
+				NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+		} else {
+			/* Probably Bus Reset */
+			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+
+			dprintk(NDEBUG_INTR, "scsi%d: unknown interrupt\n", HOSTNO);
 #ifdef SUN3_SCSI_VME
-				dregs->csr |= CSR_DMA_ENABLE;
+			dregs->csr |= CSR_DMA_ENABLE;
 #endif
-			}
-		} /* if !(SELECTION || PARITY) */
+		}
 		handled = 1;
-	} /* BASR & IRQ */ else {
-		printk(KERN_NOTICE "scsi%d: interrupt without IRQ bit set in BASR, "
-		       "BASR 0x%X, MR 0x%X, SR 0x%x\n", HOSTNO, basr,
-		       NCR5380_read(MODE_REG), NCR5380_read(STATUS_REG));
-		(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+	} else {
+		shost_printk(KERN_NOTICE, instance, "interrupt without IRQ bit\n");
 #ifdef SUN3_SCSI_VME
 		dregs->csr |= CSR_DMA_ENABLE;
 #endif
 	}
 
-	if (!done)
-		queue_work(hostdata->work_q, &hostdata->main_task);
-
 	return IRQ_RETVAL(handled);
 }
 
@@ -1509,9 +1513,10 @@ static int NCR5380_select(struct Scsi_Ho
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_reselect(instance);
+		if (!hostdata->connected)
+			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		printk(KERN_ERR "scsi%d: reselection after won arbitration?\n",
 		       HOSTNO);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return -1;
 	}
 
@@ -1871,19 +1876,14 @@ static int NCR5380_transfer_dma(struct S
 	/* send start chain */
 	sun3scsi_dma_start(c, *data);
 
+	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
+	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY |
+	                        MR_ENABLE_EOP_INTR);
 	if (p & SR_IO) {
-		NCR5380_write(TARGET_COMMAND_REG, 1);
-		NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 		NCR5380_write(INITIATOR_COMMAND_REG, 0);
-		NCR5380_write(MODE_REG,
-			      (NCR5380_read(MODE_REG) | MR_DMA_MODE | MR_ENABLE_EOP_INTR));
 		NCR5380_write(START_DMA_INITIATOR_RECEIVE_REG, 0);
 	} else {
-		NCR5380_write(TARGET_COMMAND_REG, 0);
-		NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_ASSERT_DATA);
-		NCR5380_write(MODE_REG,
-			      (NCR5380_read(MODE_REG) | MR_DMA_MODE | MR_ENABLE_EOP_INTR));
 		NCR5380_write(START_DMA_SEND_REG, 0);
 	}
 
@@ -1912,10 +1912,8 @@ static int NCR5380_transfer_dma(struct S
 		   c, (p & SR_IO) ? "to" : "from", d);
 
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
-
-#ifdef REAL_DMA
-	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_ENABLE_EOP_INTR | MR_MONITOR_BSY);
-#endif /* def REAL_DMA  */
+	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY |
+	                        MR_ENABLE_EOP_INTR);
 
 	if (!(hostdata->flags & FLAG_LATE_DMA_SETUP)) {
 		/* On the Medusa, it is a must to initialize the DMA before
@@ -2389,10 +2387,10 @@ static void NCR5380_information_transfer
 #endif
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					maybe_release_dma_irq(instance);
 					local_irq_restore(flags);
 					cmd->scsi_done(cmd);
+					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					return;
 				}
 				msgout = NOP;
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2016-01-03 16:03:49.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2016-01-03 16:03:50.000000000 +1100
@@ -334,8 +334,6 @@ static inline int NCR5380_pread(struct S
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
 	i = 0;
-	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-	NCR5380_write(MODE_REG, MR_ENABLE_EOP_INTR | MR_DMA_MODE);
 	if (instance->irq == NO_IRQ)
 		NCR5380_write(DTC_CONTROL_REG, CSR_DIR_READ);
 	else
@@ -357,9 +355,7 @@ static inline int NCR5380_pread(struct S
 	rtrc(4);
 	while (!(NCR5380_read(DTC_CONTROL_REG) & D_CR_ACCESS))
 		++i;
-	NCR5380_write(MODE_REG, 0);	/* Clear the operating mode */
 	rtrc(0);
-	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	if (i > hostdata->spin_max_r)
 		hostdata->spin_max_r = i;
 	return (0);
@@ -383,9 +379,6 @@ static inline int NCR5380_pwrite(struct
 	int i;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
-	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-	NCR5380_write(MODE_REG, MR_ENABLE_EOP_INTR | MR_DMA_MODE);
-	/* set direction (write) */
 	if (instance->irq == NO_IRQ)
 		NCR5380_write(DTC_CONTROL_REG, 0);
 	else
@@ -410,7 +403,6 @@ static inline int NCR5380_pwrite(struct
 		++i;
 	rtrc(7);
 	/* Check for parity error here. fixme. */
-	NCR5380_write(MODE_REG, 0);	/* Clear the operating mode */
 	rtrc(0);
 	if (i > hostdata->spin_max_w)
 		hostdata->spin_max_w = i;
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:03:33.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:03:50.000000000 +1100
@@ -594,8 +594,6 @@ static inline int NCR5380_pread(struct S
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
 		printk(KERN_ERR "53C400r: no end dma signal\n");
 		
-	NCR5380_write(MODE_REG, MR_BASE);
-	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	return 0;
 }
 
