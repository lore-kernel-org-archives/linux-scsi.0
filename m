From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 65/77] atari_scsi, sun3_scsi: Remove global Scsi_Host pointer
Date: Tue, 22 Dec 2015 12:18:43 +1100
Message-ID: <20151222011755.696231952@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_scsi-sun3_scsi-remove-global-instances
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

This refactoring removes two global Scsi_Host pointers. This
improves consistency with other ncr5380 drivers. Adopting the same
conventions as the other drivers makes them easier to read.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_NCR5380.c |    5 +-
 drivers/scsi/atari_scsi.c    |   29 ++++++++---------
 drivers/scsi/sun3_scsi.c     |   72 ++++++++++---------------------------------
 3 files changed, 36 insertions(+), 70 deletions(-)

Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2015-12-22 12:16:58.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2015-12-22 12:17:14.000000000 +1100
@@ -159,14 +159,10 @@ static inline unsigned long SCSI_DMA_GET
 	return adr;
 }
 
-#define HOSTDATA_DMALEN		(((struct NCR5380_hostdata *) \
-				(atari_scsi_host->hostdata))->dma_len)
-
 #ifdef REAL_DMA
 static void atari_scsi_fetch_restbytes(void);
 #endif
 
-static struct Scsi_Host *atari_scsi_host;
 static unsigned char (*atari_scsi_reg_read)(unsigned char reg);
 static void (*atari_scsi_reg_write)(unsigned char reg, unsigned char value);
 
@@ -262,15 +258,17 @@ static void scsi_dma_buserr(int irq, voi
 #endif
 
 
-static irqreturn_t scsi_tt_intr(int irq, void *dummy)
+static irqreturn_t scsi_tt_intr(int irq, void *dev)
 {
 #ifdef REAL_DMA
+	struct Scsi_Host *instance = dev;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int dma_stat;
 
 	dma_stat = tt_scsi_dma.dma_ctrl;
 
-	dprintk(NDEBUG_INTR, "scsi%d: NCR5380 interrupt, DMA status = %02x\n",
-		   atari_scsi_host->host_no, dma_stat & 0xff);
+	dsprintk(NDEBUG_INTR, instance, "NCR5380 interrupt, DMA status = %02x\n",
+	         dma_stat & 0xff);
 
 	/* Look if it was the DMA that has interrupted: First possibility
 	 * is that a bus error occurred...
@@ -293,7 +291,8 @@ static irqreturn_t scsi_tt_intr(int irq,
 	 * data reg!
 	 */
 	if ((dma_stat & 0x02) && !(dma_stat & 0x40)) {
-		atari_dma_residual = HOSTDATA_DMALEN - (SCSI_DMA_READ_P(dma_addr) - atari_dma_startaddr);
+		atari_dma_residual = hostdata->dma_len -
+			(SCSI_DMA_READ_P(dma_addr) - atari_dma_startaddr);
 
 		dprintk(NDEBUG_DMA, "SCSI DMA: There are %ld residual bytes.\n",
 			   atari_dma_residual);
@@ -345,15 +344,17 @@ static irqreturn_t scsi_tt_intr(int irq,
 
 #endif /* REAL_DMA */
 
-	NCR5380_intr(irq, dummy);
+	NCR5380_intr(irq, dev);
 
 	return IRQ_HANDLED;
 }
 
 
-static irqreturn_t scsi_falcon_intr(int irq, void *dummy)
+static irqreturn_t scsi_falcon_intr(int irq, void *dev)
 {
 #ifdef REAL_DMA
+	struct Scsi_Host *instance = dev;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int dma_stat;
 
 	/* Turn off DMA and select sector counter register before
@@ -388,7 +389,7 @@ static irqreturn_t scsi_falcon_intr(int
 			printk(KERN_ERR "SCSI DMA error: %ld bytes lost in "
 			       "ST-DMA fifo\n", transferred & 15);
 
-		atari_dma_residual = HOSTDATA_DMALEN - transferred;
+		atari_dma_residual = hostdata->dma_len - transferred;
 		dprintk(NDEBUG_DMA, "SCSI DMA: There are %ld residual bytes.\n",
 			   atari_dma_residual);
 	} else
@@ -400,13 +401,14 @@ static irqreturn_t scsi_falcon_intr(int
 		 * data to the original destination address.
 		 */
 		memcpy(atari_dma_orig_addr, phys_to_virt(atari_dma_startaddr),
-		       HOSTDATA_DMALEN - atari_dma_residual);
+		       hostdata->dma_len - atari_dma_residual);
 		atari_dma_orig_addr = NULL;
 	}
 
 #endif /* REAL_DMA */
 
-	NCR5380_intr(irq, dummy);
+	NCR5380_intr(irq, dev);
+
 	return IRQ_HANDLED;
 }
 
@@ -873,7 +875,6 @@ static int __init atari_scsi_probe(struc
 		error = -ENOMEM;
 		goto fail_alloc;
 	}
-	atari_scsi_host = instance;
 
 	instance->irq = irq->start;
 
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2015-12-22 12:16:58.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2015-12-22 12:17:14.000000000 +1100
@@ -56,9 +56,9 @@
 #define NCR5380_info                    sun3scsi_info
 
 #define NCR5380_dma_read_setup(instance, data, count) \
-        sun3scsi_dma_setup(data, count, 0)
+        sun3scsi_dma_setup(instance, data, count, 0)
 #define NCR5380_dma_write_setup(instance, data, count) \
-        sun3scsi_dma_setup(data, count, 1)
+        sun3scsi_dma_setup(instance, data, count, 1)
 #define NCR5380_dma_residual(instance) \
         sun3scsi_dma_residual(instance)
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
@@ -99,7 +99,6 @@ static unsigned char *sun3_dma_orig_addr
 static unsigned long sun3_dma_orig_count;
 static int sun3_dma_active;
 static unsigned long last_residual;
-static struct Scsi_Host *default_instance;
 
 /*
  * NCR 5380 register access functions
@@ -142,8 +141,9 @@ static inline void sun3_udc_write(unsign
 // safe bits for the CSR
 #define CSR_GOOD 0x060f
 
-static irqreturn_t scsi_sun3_intr(int irq, void *dummy)
+static irqreturn_t scsi_sun3_intr(int irq, void *dev)
 {
+	struct Scsi_Host *instance = dev;
 	unsigned short csr = dregs->csr;
 	int handled = 0;
 
@@ -152,46 +152,24 @@ static irqreturn_t scsi_sun3_intr(int ir
 #endif
 
 	if(csr & ~CSR_GOOD) {
-		if(csr & CSR_DMA_BUSERR) {
-			printk("scsi%d: bus error in dma\n", default_instance->host_no);
-		}
-
-		if(csr & CSR_DMA_CONFLICT) {
-			printk("scsi%d: dma conflict\n", default_instance->host_no);
-		}
+		if (csr & CSR_DMA_BUSERR)
+			shost_printk(KERN_ERR, instance, "bus error in DMA\n");
+		if (csr & CSR_DMA_CONFLICT)
+			shost_printk(KERN_ERR, instance, "DMA conflict\n");
 		handled = 1;
 	}
 
 	if(csr & (CSR_SDB_INT | CSR_DMA_INT)) {
-		NCR5380_intr(irq, dummy);
+		NCR5380_intr(irq, dev);
 		handled = 1;
 	}
 
 	return IRQ_RETVAL(handled);
 }
 
-/*
- * Debug stuff - to be called on NMI, or sysrq key. Use at your own risk; 
- * reentering NCR5380_print_status seems to have ugly side effects
- */
-
-/* this doesn't seem to get used at all -- sam */
-#if 0
-void sun3_sun3_debug (void)
-{
-	unsigned long flags;
-
-	if (default_instance) {
-			local_irq_save(flags);
-			NCR5380_print_status(default_instance);
-			local_irq_restore(flags);
-	}
-}
-#endif
-
-
 /* sun3scsi_dma_setup() -- initialize the dma controller for a read/write */
-static unsigned long sun3scsi_dma_setup(void *data, unsigned long count, int write_flag)
+static unsigned long sun3scsi_dma_setup(struct Scsi_Host *instance,
+                                void *data, unsigned long count, int write_flag)
 {
 	void *addr;
 
@@ -243,10 +221,9 @@ static unsigned long sun3scsi_dma_setup(
 	dregs->csr |= CSR_FIFO;
 	
 	if(dregs->fifo_count != count) { 
-		printk("scsi%d: fifo_mismatch %04x not %04x\n",
-		       default_instance->host_no, dregs->fifo_count,
-		       (unsigned int) count);
-		NCR5380_dprint(NDEBUG_DMA, default_instance);
+		shost_printk(KERN_ERR, instance, "FIFO mismatch %04x not %04x\n",
+		             dregs->fifo_count, (unsigned int) count);
+		NCR5380_dprint(NDEBUG_DMA, instance);
 	}
 
 	/* setup udc */
@@ -281,21 +258,6 @@ static unsigned long sun3scsi_dma_setup(
 
 }
 
-#ifndef SUN3_SCSI_VME
-static inline unsigned long sun3scsi_dma_count(struct Scsi_Host *instance)
-{
-	unsigned short resid;
-
-	dregs->udc_addr = 0x32; 
-	udelay(SUN3_DMA_DELAY);
-	resid = dregs->udc_data;
-	udelay(SUN3_DMA_DELAY);
-	resid *= 2;
-
-	return (unsigned long) resid;
-}
-#endif
-
 static inline unsigned long sun3scsi_dma_residual(struct Scsi_Host *instance)
 {
 	return last_residual;
@@ -393,7 +355,10 @@ static int sun3scsi_dma_finish(int write
 		}
 	}
 
-	count = sun3scsi_dma_count(default_instance);
+	dregs->udc_addr = 0x32;
+	udelay(SUN3_DMA_DELAY);
+	count = 2 * dregs->udc_data;
+	udelay(SUN3_DMA_DELAY);
 
 	fifo = dregs->fifo_count;
 	last_residual = fifo;
@@ -547,7 +512,6 @@ static int __init sun3_scsi_probe(struct
 		error = -ENOMEM;
 		goto fail_alloc;
 	}
-	default_instance = instance;
 
 	instance->io_port = (unsigned long)ioaddr;
 	instance->irq = irq->start;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:12.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:14.000000000 +1100
@@ -1920,7 +1920,7 @@ static void NCR5380_information_transfer
 				/* this command setup for dma yet? */
 				if ((count >= DMA_MIN_SIZE) && (sun3_dma_setup_done != cmd)) {
 					if (cmd->request->cmd_type == REQ_TYPE_FS) {
-						sun3scsi_dma_setup(d, count,
+						sun3scsi_dma_setup(instance, d, count,
 						                   rq_data_dir(cmd->request));
 						sun3_dma_setup_done = cmd;
 					}
@@ -2458,7 +2458,8 @@ static void NCR5380_reselect(struct Scsi
 		}
 		/* setup this command for dma if not already */
 		if ((count >= DMA_MIN_SIZE) && (sun3_dma_setup_done != tmp)) {
-			sun3scsi_dma_setup(d, count, rq_data_dir(tmp->request));
+			sun3scsi_dma_setup(instance, d, count,
+			                   rq_data_dir(tmp->request));
 			sun3_dma_setup_done = tmp;
 		}
 	}
