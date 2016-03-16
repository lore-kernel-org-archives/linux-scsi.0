From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 10/22] ncr5380: Merge DMA implementation from atari_NCR5380
 core driver
Date: Wed, 16 Mar 2016 14:18:51 +1100
Message-ID: <20160316031844.431738797@telegraphics.com.au>
References: <20160316031841.911913894@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline; filename=ncr5380-merge-atari-dma-algorithm
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Sam Creasey <sammy@sammy.net>, Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

Adopt the DMA implementation from atari_NCR5380.c. This means that
atari_scsi and sun3_scsi can make use of the NCR5380.c core driver
and the atari_NCR5380.c driver fork can be made redundant.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/NCR5380.c      |  170 +++++++++++++++++++++++++++++++++++---------
 drivers/scsi/arm/cumana_1.c |    3 
 drivers/scsi/arm/oak.c      |    3 
 drivers/scsi/dmx3191d.c     |    1 
 drivers/scsi/dtc.c          |    2 
 drivers/scsi/dtc.h          |    1 
 drivers/scsi/g_NCR5380.c    |    2 
 drivers/scsi/g_NCR5380.h    |    1 
 drivers/scsi/mac_scsi.c     |    3 
 drivers/scsi/pas16.c        |    2 
 drivers/scsi/pas16.h        |    1 
 drivers/scsi/t128.c         |    2 
 drivers/scsi/t128.h         |    1 
 13 files changed, 152 insertions(+), 40 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-16 14:18:19.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-16 14:18:20.000000000 +1100
@@ -31,9 +31,6 @@
 
 /*
  * Further development / testing that should be done :
- * 1.  Cleanup the NCR5380_transfer_dma function and DMA operation complete
- * code so that everything does the same thing that's done at the
- * end of a pseudo-DMA read operation.
  *
  * 4.  Test SCSI-II tagged queueing (I have no devices which support
  * tagged queueing)
@@ -117,6 +114,8 @@
  *
  * PSEUDO_DMA - if defined, PSEUDO DMA is used during the data transfer phases.
  *
+ * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
+ *
  * These macros MUST be defined :
  *
  * NCR5380_read(register)  - read from the specified register
@@ -801,6 +800,72 @@ static void NCR5380_main(struct work_str
 	} while (!done);
 }
 
+/*
+ * NCR5380_dma_complete - finish DMA transfer
+ * @instance: the scsi host instance
+ *
+ * Called by the interrupt handler when DMA finishes or a phase
+ * mismatch occurs (which would end the DMA transfer).
+ */
+
+static void NCR5380_dma_complete(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	int transferred;
+	unsigned char **data;
+	int *count;
+	int saved_data = 0, overrun = 0;
+	unsigned char p;
+
+	if (hostdata->read_overruns) {
+		p = hostdata->connected->SCp.phase;
+		if (p & SR_IO) {
+			udelay(10);
+			if ((NCR5380_read(BUS_AND_STATUS_REG) &
+			     (BASR_PHASE_MATCH | BASR_ACK)) ==
+			    (BASR_PHASE_MATCH | BASR_ACK)) {
+				saved_data = NCR5380_read(INPUT_DATA_REG);
+				overrun = 1;
+				dsprintk(NDEBUG_DMA, instance, "read overrun handled\n");
+			}
+		}
+	}
+
+	NCR5380_write(MODE_REG, MR_BASE);
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+
+	transferred = hostdata->dma_len - NCR5380_dma_residual(instance);
+	hostdata->dma_len = 0;
+
+	data = (unsigned char **)&hostdata->connected->SCp.ptr;
+	count = &hostdata->connected->SCp.this_residual;
+	*data += transferred;
+	*count -= transferred;
+
+	if (hostdata->read_overruns) {
+		int cnt, toPIO;
+
+		if ((NCR5380_read(STATUS_REG) & PHASE_MASK) == p && (p & SR_IO)) {
+			cnt = toPIO = hostdata->read_overruns;
+			if (overrun) {
+				dsprintk(NDEBUG_DMA, instance,
+				         "Got an input overrun, using saved byte\n");
+				*(*data)++ = saved_data;
+				(*count)--;
+				cnt--;
+				toPIO--;
+			}
+			if (toPIO > 0) {
+				dsprintk(NDEBUG_DMA, instance,
+				         "Doing %d byte PIO to 0x%p\n", cnt, *data);
+				NCR5380_transfer_pio(instance, &p, &cnt, data);
+				*count -= toPIO - cnt;
+			}
+		}
+	}
+}
+
 #ifndef DONT_USE_INTR
 
 /**
@@ -855,7 +920,22 @@ static irqreturn_t NCR5380_intr(int irq,
 		dsprintk(NDEBUG_INTR, instance, "IRQ %d, BASR 0x%02x, SR 0x%02x, MR 0x%02x\n",
 		         irq, basr, sr, mr);
 
-		if ((NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_mask) &&
+		if ((mr & MR_DMA_MODE) || (mr & MR_MONITOR_BSY)) {
+			/* Probably End of DMA, Phase Mismatch or Loss of BSY.
+			 * We ack IRQ after clearing Mode Register. Workarounds
+			 * for End of DMA errata need to happen in DMA Mode.
+			 */
+
+			dsprintk(NDEBUG_INTR, instance, "interrupt in DMA mode\n");
+
+			if (hostdata->connected) {
+				NCR5380_dma_complete(instance);
+				queue_work(hostdata->work_q, &hostdata->main_task);
+			} else {
+				NCR5380_write(MODE_REG, MR_BASE);
+				NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+			}
+		} else if ((NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_mask) &&
 		    (sr & (SR_SEL | SR_IO | SR_BSY | SR_RST)) == (SR_SEL | SR_IO)) {
 			/* Probably reselected */
 			NCR5380_write(SELECT_ENABLE_REG, 0);
@@ -1431,28 +1511,38 @@ static int NCR5380_transfer_dma(struct S
 	register unsigned char p = *phase;
 	register unsigned char *d = *data;
 	unsigned char tmp;
-	int result;
+	int result = 0;
 
 	if ((tmp = (NCR5380_read(STATUS_REG) & PHASE_MASK)) != p) {
 		*phase = tmp;
 		return -1;
 	}
 
-	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
+	hostdata->connected->SCp.phase = p;
 
-	/*
-	 * Note : on my sample board, watch-dog timeouts occurred when interrupts
-	 * were not disabled for the duration of a single DMA transfer, from
-	 * before the setting of DMA mode to after transfer of the last byte.
-	 */
+	if (p & SR_IO) {
+		if (hostdata->read_overruns)
+			c -= hostdata->read_overruns;
+		else if (hostdata->flags & FLAG_DMA_FIXUP)
+			--c;
+	}
 
-	if (hostdata->flags & FLAG_DMA_FIXUP)
-		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY);
-	else
-		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY |
-		                        MR_ENABLE_EOP_INTR);
+	dsprintk(NDEBUG_DMA, instance, "initializing DMA %s: length %d, address %p\n",
+	         (p & SR_IO) ? "receive" : "send", c, d);
 
-	dprintk(NDEBUG_DMA, "scsi%d : mode reg = 0x%X\n", instance->host_no, NCR5380_read(MODE_REG));
+	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
+	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY |
+	                        MR_ENABLE_EOP_INTR);
+
+	if (!(hostdata->flags & FLAG_LATE_DMA_SETUP)) {
+		/* On the Medusa, it is a must to initialize the DMA before
+		 * starting the NCR. This is also the cleaner way for the TT.
+		 */
+		if (p & SR_IO)
+			result = NCR5380_dma_recv_setup(instance, d, c);
+		else
+			result = NCR5380_dma_send_setup(instance, d, c);
+	}
 
 	/*
 	 * On the PAS16 at least I/O recovery delays are not needed here.
@@ -1470,6 +1560,29 @@ static int NCR5380_transfer_dma(struct S
 		NCR5380_io_delay(1);
 	}
 
+	if (hostdata->flags & FLAG_LATE_DMA_SETUP) {
+		/* On the Falcon, the DMA setup must be done after the last
+		 * NCR access, else the DMA setup gets trashed!
+		 */
+		if (p & SR_IO)
+			result = NCR5380_dma_recv_setup(instance, d, c);
+		else
+			result = NCR5380_dma_send_setup(instance, d, c);
+	}
+
+	/* On failure, NCR5380_dma_xxxx_setup() returns a negative int. */
+	if (result < 0)
+		return result;
+
+	/* For real DMA, result is the byte count. DMA interrupt is expected. */
+	if (result > 0) {
+		hostdata->dma_len = result;
+		return 0;
+	}
+
+	/* The result is zero iff pseudo DMA send/receive was completed. */
+	hostdata->dma_len = c;
+
 /*
  * A note regarding the DMA errata workarounds for early NMOS silicon.
  *
@@ -1504,10 +1617,8 @@ static int NCR5380_transfer_dma(struct S
  * request.
  */
 
-	if (p & SR_IO) {
-		result = NCR5380_dma_recv_setup(instance, d,
-			hostdata->flags & FLAG_DMA_FIXUP ? c - 1 : c);
-		if (!result && (hostdata->flags & FLAG_DMA_FIXUP)) {
+	if (hostdata->flags & FLAG_DMA_FIXUP) {
+		if (p & SR_IO) {
 			/*
 			 * The workaround was to transfer fewer bytes than we
 			 * intended to with the pseudo-DMA read function, wait for
@@ -1533,11 +1644,8 @@ static int NCR5380_transfer_dma(struct S
 				result = -1;
 				shost_printk(KERN_ERR, instance, "PDMA read: !REQ timeout\n");
 			}
-			d[c - 1] = NCR5380_read(INPUT_DATA_REG);
-		}
-	} else {
-		result = NCR5380_dma_send_setup(instance, d, c);
-		if (!result && (hostdata->flags & FLAG_DMA_FIXUP)) {
+			d[*count - 1] = NCR5380_read(INPUT_DATA_REG);
+		} else {
 			/*
 			 * Wait for the last byte to be sent.  If REQ is being asserted for
 			 * the byte we're interested, we'll ACK it and it will go false.
@@ -1550,11 +1658,8 @@ static int NCR5380_transfer_dma(struct S
 			}
 		}
 	}
-	NCR5380_write(MODE_REG, MR_BASE);
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-	*data = d + c;
-	*count = 0;
+
+	NCR5380_dma_complete(instance);
 	return result;
 }
 
@@ -1667,8 +1772,7 @@ static void NCR5380_information_transfer
 						do_abort(instance);
 						cmd->result = DID_ERROR << 16;
 						/* XXX - need to source or sink data here, as appropriate */
-					} else
-						cmd->SCp.this_residual -= transfersize - len;
+					}
 				} else {
 					/* Break up transfer into 3 ms chunks,
 					 * presuming 6 accesses per handshake.
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2016-03-16 14:18:19.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2016-03-16 14:18:20.000000000 +1100
@@ -20,6 +20,7 @@
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
 #define NCR5380_dma_recv_setup		cumanascsi_pread
 #define NCR5380_dma_send_setup		cumanascsi_pwrite
+#define NCR5380_dma_residual(instance)	(0)
 
 #define NCR5380_intr			cumanascsi_intr
 #define NCR5380_queue_command		cumanascsi_queue_command
@@ -245,7 +246,7 @@ static int cumanascsi1_probe(struct expa
 
 	host->irq = ec->irq;
 
-	ret = NCR5380_init(host, FLAG_DMA_FIXUP);
+	ret = NCR5380_init(host, FLAG_DMA_FIXUP | FLAG_LATE_DMA_SETUP);
 	if (ret)
 		goto out_unmap;
 
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2016-03-16 14:18:19.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2016-03-16 14:18:20.000000000 +1100
@@ -26,6 +26,7 @@
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
 #define NCR5380_dma_recv_setup		oakscsi_pread
 #define NCR5380_dma_send_setup		oakscsi_pwrite
+#define NCR5380_dma_residual(instance)	(0)
 
 #define NCR5380_queue_command		oakscsi_queue_command
 #define NCR5380_info			oakscsi_info
@@ -144,7 +145,7 @@ static int oakscsi_probe(struct expansio
 	host->irq = NO_IRQ;
 	host->n_io_port = 255;
 
-	ret = NCR5380_init(host, FLAG_DMA_FIXUP);
+	ret = NCR5380_init(host, FLAG_DMA_FIXUP | FLAG_LATE_DMA_SETUP);
 	if (ret)
 		goto out_unmap;
 
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2016-03-16 14:18:15.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2016-03-16 14:18:20.000000000 +1100
@@ -42,6 +42,7 @@
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(0)
 #define NCR5380_dma_recv_setup(instance, dst, len)	(0)
 #define NCR5380_dma_send_setup(instance, src, len)	(0)
+#define NCR5380_dma_residual(instance)			(0)
 
 #define NCR5380_implementation_fields	/* none */
 
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2016-03-16 14:18:15.000000000 +1100
+++ linux/drivers/scsi/dtc.h	2016-03-16 14:18:20.000000000 +1100
@@ -23,6 +23,7 @@
         dtc_dma_xfer_len(cmd)
 #define NCR5380_dma_recv_setup		dtc_pread
 #define NCR5380_dma_send_setup		dtc_pwrite
+#define NCR5380_dma_residual(instance)	(0)
 
 #define NCR5380_intr			dtc_intr
 #define NCR5380_queue_command		dtc_queue_command
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-03-16 14:18:15.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-03-16 14:18:20.000000000 +1100
@@ -64,6 +64,7 @@
         generic_NCR5380_dma_xfer_len(instance, cmd)
 #define NCR5380_dma_recv_setup		generic_NCR5380_pread
 #define NCR5380_dma_send_setup		generic_NCR5380_pwrite
+#define NCR5380_dma_residual(instance)	(0)
 
 #define NCR5380_intr generic_NCR5380_intr
 #define NCR5380_queue_command generic_NCR5380_queue_command
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2016-03-16 14:18:15.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2016-03-16 14:18:20.000000000 +1100
@@ -37,6 +37,7 @@
         macscsi_dma_xfer_len(instance, cmd)
 #define NCR5380_dma_recv_setup          macscsi_pread
 #define NCR5380_dma_send_setup          macscsi_pwrite
+#define NCR5380_dma_residual(instance)  (0)
 
 #define NCR5380_intr                    macscsi_intr
 #define NCR5380_queue_command           macscsi_queue_command
@@ -386,7 +387,7 @@ static int __init mac_scsi_probe(struct
 #endif
 	host_flags |= setup_toshiba_delay > 0 ? FLAG_TOSHIBA_DELAY : 0;
 
-	error = NCR5380_init(instance, host_flags);
+	error = NCR5380_init(instance, host_flags | FLAG_LATE_DMA_SETUP);
 	if (error)
 		goto fail_init;
 
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2016-03-16 14:18:15.000000000 +1100
+++ linux/drivers/scsi/pas16.h	2016-03-16 14:18:20.000000000 +1100
@@ -105,6 +105,7 @@
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
 #define NCR5380_dma_recv_setup		pas16_pread
 #define NCR5380_dma_send_setup		pas16_pwrite
+#define NCR5380_dma_residual(instance)	(0)
 
 #define NCR5380_intr pas16_intr
 #define NCR5380_queue_command pas16_queue_command
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2016-03-16 14:18:15.000000000 +1100
+++ linux/drivers/scsi/t128.h	2016-03-16 14:18:20.000000000 +1100
@@ -79,6 +79,7 @@
 #define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
 #define NCR5380_dma_recv_setup		t128_pread
 #define NCR5380_dma_send_setup		t128_pwrite
+#define NCR5380_dma_residual(instance)	(0)
 
 #define NCR5380_intr t128_intr
 #define NCR5380_queue_command t128_queue_command
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2016-03-16 14:18:15.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2016-03-16 14:18:20.000000000 +1100
@@ -228,7 +228,7 @@ found:
 		instance->base = addr;
 		((struct NCR5380_hostdata *)(instance)->hostdata)->base = base;
 
-		if (NCR5380_init(instance, 0))
+		if (NCR5380_init(instance, FLAG_LATE_DMA_SETUP))
 			goto out_unregister;
 
 		NCR5380_maybe_reset_bus(instance);
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-03-16 14:18:15.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-03-16 14:18:20.000000000 +1100
@@ -466,7 +466,7 @@ static int __init generic_NCR5380_detect
 		}
 #endif
 
-		if (NCR5380_init(instance, flags))
+		if (NCR5380_init(instance, flags | FLAG_LATE_DMA_SETUP))
 			goto out_unregister;
 
 		switch (overrides[current_override].board) {
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2016-03-16 14:18:15.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2016-03-16 14:18:20.000000000 +1100
@@ -375,7 +375,7 @@ static int __init pas16_detect(struct sc
 		
 	instance->io_port = io_port;
 
-	if (NCR5380_init(instance, FLAG_DMA_FIXUP))
+	if (NCR5380_init(instance, FLAG_DMA_FIXUP | FLAG_LATE_DMA_SETUP))
 		goto out_unregister;
 
 	NCR5380_maybe_reset_bus(instance);
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2016-03-16 14:18:15.000000000 +1100
+++ linux/drivers/scsi/t128.c	2016-03-16 14:18:20.000000000 +1100
@@ -208,7 +208,7 @@ found:
 	instance->base = base;
 	((struct NCR5380_hostdata *)instance->hostdata)->base = p;
 
-	if (NCR5380_init(instance, FLAG_DMA_FIXUP))
+	if (NCR5380_init(instance, FLAG_DMA_FIXUP | FLAG_LATE_DMA_SETUP))
 		goto out_unregister;
 
 	NCR5380_maybe_reset_bus(instance);
