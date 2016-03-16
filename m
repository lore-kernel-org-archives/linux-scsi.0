From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 12/22] sun3_scsi: Adopt NCR5380.c core driver
Date: Wed, 16 Mar 2016 14:18:53 +1100
Message-ID: <20160316031844.941747996@telegraphics.com.au>
References: <20160316031841.911913894@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=sun3_scsi-adopt-NCR5380-c
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

Add support for the custom Sun 3 DMA logic to the NCR5380.c core driver.
This code is copied from atari_NCR5380.c.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---

The Sun 3 DMA code is still configured by macros. I have simplified things
slightly but I have avoided more ambitious refactoring. It's not clear to
me what that should look like and I can't test sun3_scsi anyway. At least
this permits the removal of atari_NCR5380.c.

---
 drivers/scsi/NCR5380.c   |  131 +++++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/sun3_scsi.c |    8 +-
 2 files changed, 124 insertions(+), 15 deletions(-)

Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2016-03-16 14:18:07.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2016-03-16 14:18:25.000000000 +1100
@@ -54,10 +54,8 @@
 #define NCR5380_abort                   sun3scsi_abort
 #define NCR5380_info                    sun3scsi_info
 
-#define NCR5380_dma_read_setup(instance, data, count) \
-        sun3scsi_dma_setup(instance, data, count, 0)
-#define NCR5380_dma_write_setup(instance, data, count) \
-        sun3scsi_dma_setup(instance, data, count, 1)
+#define NCR5380_dma_recv_setup(instance, data, count) (count)
+#define NCR5380_dma_send_setup(instance, data, count) (count)
 #define NCR5380_dma_residual(instance) \
         sun3scsi_dma_residual(instance)
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
@@ -406,7 +404,7 @@ static int sun3scsi_dma_finish(int write
 
 }
 	
-#include "atari_NCR5380.c"
+#include "NCR5380.c"
 
 #ifdef SUN3_SCSI_VME
 #define SUN3_SCSI_NAME          "Sun3 NCR5380 VME SCSI"
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-16 14:18:24.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-16 14:18:25.000000000 +1100
@@ -31,6 +31,8 @@
 
 /* Ported to Atari by Roman Hodek and others. */
 
+/* Adapted for the Sun 3 by Sam Creasey. */
+
 /*
  * Further development / testing that should be done :
  *
@@ -858,6 +860,23 @@ static void NCR5380_dma_complete(struct
 		}
 	}
 
+#ifdef CONFIG_SUN3
+	if ((sun3scsi_dma_finish(rq_data_dir(hostdata->connected->request)))) {
+		pr_err("scsi%d: overrun in UDC counter -- not prepared to deal with this!\n",
+		       instance->host_no);
+		BUG();
+	}
+
+	if ((NCR5380_read(BUS_AND_STATUS_REG) & (BASR_PHASE_MATCH | BASR_ACK)) ==
+	    (BASR_PHASE_MATCH | BASR_ACK)) {
+		pr_err("scsi%d: BASR %02x\n", instance->host_no,
+		       NCR5380_read(BUS_AND_STATUS_REG));
+		pr_err("scsi%d: bus stuck in data phase -- probably a single byte overrun!\n",
+		       instance->host_no);
+		BUG();
+	}
+#endif
+
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
@@ -981,10 +1000,16 @@ static irqreturn_t NCR5380_intr(int irq,
 			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 
 			dsprintk(NDEBUG_INTR, instance, "unknown interrupt\n");
+#ifdef SUN3_SCSI_VME
+			dregs->csr |= CSR_DMA_ENABLE;
+#endif
 		}
 		handled = 1;
 	} else {
 		shost_printk(KERN_NOTICE, instance, "interrupt without IRQ bit\n");
+#ifdef SUN3_SCSI_VME
+		dregs->csr |= CSR_DMA_ENABLE;
+#endif
 	}
 
 	spin_unlock_irqrestore(&hostdata->lock, flags);
@@ -1274,6 +1299,10 @@ static struct scsi_cmnd *NCR5380_select(
 	hostdata->connected = cmd;
 	hostdata->busy[cmd->device->id] |= 1 << cmd->device->lun;
 
+#ifdef SUN3_SCSI_VME
+	dregs->csr |= CSR_INTR;
+#endif
+
 	initialize_SCp(cmd);
 
 	cmd = NULL;
@@ -1557,6 +1586,11 @@ static int NCR5380_transfer_dma(struct S
 	dsprintk(NDEBUG_DMA, instance, "initializing DMA %s: length %d, address %p\n",
 	         (p & SR_IO) ? "receive" : "send", c, d);
 
+#ifdef CONFIG_SUN3
+	/* send start chain */
+	sun3scsi_dma_start(c, *data);
+#endif
+
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
 	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY |
 	                        MR_ENABLE_EOP_INTR);
@@ -1577,6 +1611,7 @@ static int NCR5380_transfer_dma(struct S
 	 */
 
 	if (p & SR_IO) {
+		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_io_delay(1);
 		NCR5380_write(START_DMA_INITIATOR_RECEIVE_REG, 0);
 	} else {
@@ -1587,6 +1622,13 @@ static int NCR5380_transfer_dma(struct S
 		NCR5380_io_delay(1);
 	}
 
+#ifdef CONFIG_SUN3
+#ifdef SUN3_SCSI_VME
+	dregs->csr |= CSR_DMA_ENABLE;
+#endif
+	sun3_dma_active = 1;
+#endif
+
 	if (hostdata->flags & FLAG_LATE_DMA_SETUP) {
 		/* On the Falcon, the DMA setup must be done after the last
 		 * NCR access, else the DMA setup gets trashed!
@@ -1718,6 +1760,10 @@ static void NCR5380_information_transfer
 	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
 	struct scsi_cmnd *cmd;
 
+#ifdef SUN3_SCSI_VME
+	dregs->csr |= CSR_INTR;
+#endif
+
 	while ((cmd = hostdata->connected)) {
 		struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
 
@@ -1729,6 +1775,31 @@ static void NCR5380_information_transfer
 				old_phase = phase;
 				NCR5380_dprint_phase(NDEBUG_INFORMATION, instance);
 			}
+#ifdef CONFIG_SUN3
+			if (phase == PHASE_CMDOUT) {
+				void *d;
+				unsigned long count;
+
+				if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
+					count = cmd->SCp.buffer->length;
+					d = sg_virt(cmd->SCp.buffer);
+				} else {
+					count = cmd->SCp.this_residual;
+					d = cmd->SCp.ptr;
+				}
+
+				if (sun3_dma_setup_done != cmd &&
+				    sun3scsi_dma_xfer_len(count, cmd) > 0) {
+					sun3scsi_dma_setup(instance, d, count,
+					                   rq_data_dir(cmd->request));
+					sun3_dma_setup_done = cmd;
+				}
+#ifdef SUN3_SCSI_VME
+				dregs->csr |= CSR_INTR;
+#endif
+			}
+#endif /* CONFIG_SUN3 */
+
 			if (sink && (phase != PHASE_MSGOUT)) {
 				NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
 
@@ -1811,6 +1882,10 @@ static void NCR5380_information_transfer
 					                     (unsigned char **)&cmd->SCp.ptr);
 					cmd->SCp.this_residual -= transfersize - len;
 				}
+#ifdef CONFIG_SUN3
+				if (sun3_dma_setup_done == cmd)
+					sun3_dma_setup_done = NULL;
+#endif
 				return;
 			case PHASE_MSGIN:
 				len = 1;
@@ -1889,6 +1964,9 @@ static void NCR5380_information_transfer
 
 					/* Enable reselect interrupts */
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+#ifdef SUN3_SCSI_VME
+					dregs->csr |= CSR_DMA_ENABLE;
+#endif
 					return;
 					/*
 					 * The SCSI data pointer is *IMPLICITLY* saved on a disconnect
@@ -2040,10 +2118,8 @@ static void NCR5380_reselect(struct Scsi
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char target_mask;
-	unsigned char lun, phase;
-	int len;
+	unsigned char lun;
 	unsigned char msg[3];
-	unsigned char *data;
 	struct NCR5380_cmd *ncmd;
 	struct scsi_cmnd *tmp;
 
@@ -2085,15 +2161,26 @@ static void NCR5380_reselect(struct Scsi
 		return;
 	}
 
-	len = 1;
-	data = msg;
-	phase = PHASE_MSGIN;
-	NCR5380_transfer_pio(instance, &phase, &len, &data);
+#ifdef CONFIG_SUN3
+	/* acknowledge toggle to MSGIN */
+	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(PHASE_MSGIN));
+
+	/* peek at the byte without really hitting the bus */
+	msg[0] = NCR5380_read(CURRENT_SCSI_DATA_REG);
+#else
+	{
+		int len = 1;
+		unsigned char *data = msg;
+		unsigned char phase = PHASE_MSGIN;
 
-	if (len) {
-		do_abort(instance);
-		return;
+		NCR5380_transfer_pio(instance, &phase, &len, &data);
+
+		if (len) {
+			do_abort(instance);
+			return;
+		}
 	}
+#endif /* CONFIG_SUN3 */
 
 	if (!(msg[0] & 0x80)) {
 		shost_printk(KERN_ERR, instance, "expecting IDENTIFY message, got ");
@@ -2141,6 +2228,30 @@ static void NCR5380_reselect(struct Scsi
 		return;
 	}
 
+#ifdef CONFIG_SUN3
+	{
+		void *d;
+		unsigned long count;
+
+		if (!tmp->SCp.this_residual && tmp->SCp.buffers_residual) {
+			count = tmp->SCp.buffer->length;
+			d = sg_virt(tmp->SCp.buffer);
+		} else {
+			count = tmp->SCp.this_residual;
+			d = tmp->SCp.ptr;
+		}
+
+		if (sun3_dma_setup_done != tmp &&
+		    sun3scsi_dma_xfer_len(count, tmp) > 0) {
+			sun3scsi_dma_setup(instance, d, count,
+			                   rq_data_dir(tmp->request));
+			sun3_dma_setup_done = tmp;
+		}
+	}
+
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
+#endif /* CONFIG_SUN3 */
+
 	/* Accept message by clearing ACK */
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
