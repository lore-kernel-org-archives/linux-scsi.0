From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 10/21] m68k/scsi: a2091 - Kill ugly DMA() macro
Date: Sun,  4 Apr 2010 11:00:40 +0200
Message-ID: <1270371651-2584-11-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-6-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-7-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-8-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-9-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-10-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-10-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a2091.c |   48 ++++++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index b890b60..e762cae 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -21,17 +21,15 @@
 #include <linux/stat.h>
 
 
-#define DMA(ptr)	((a2091_scsiregs *)((ptr)->base))
-
 static int a2091_release(struct Scsi_Host *instance);
 
-static irqreturn_t a2091_intr(int irq, void *_instance)
+static irqreturn_t a2091_intr(int irq, void *data)
 {
+	struct Scsi_Host *instance = data;
+	a2091_scsiregs *regs = (a2091_scsiregs *)(instance->base);
+	unsigned int status = regs->ISTR;
 	unsigned long flags;
-	unsigned int status;
-	struct Scsi_Host *instance = (struct Scsi_Host *)_instance;
 
-	status = DMA(instance)->ISTR;
 	if (!(status & (ISTR_INT_F | ISTR_INT_P)) || !(status & ISTR_INTS))
 		return IRQ_NONE;
 
@@ -45,6 +43,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
+	a2091_scsiregs *regs = (a2091_scsiregs *)(instance->base);
 	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
 	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
 
@@ -86,10 +85,10 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	/* remember direction */
 	hdata->dma_dir = dir_in;
 
-	DMA(cmd->device->host)->CNTR = cntr;
+	regs->CNTR = cntr;
 
 	/* setup DMA *physical* address */
-	DMA(cmd->device->host)->ACR = addr;
+	regs->ACR = addr;
 
 	if (dir_in) {
 		/* invalidate any cache */
@@ -99,7 +98,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 		cache_push(addr, cmd->SCp.this_residual);
 	}
 	/* start DMA */
-	DMA(cmd->device->host)->ST_DMA = 1;
+	regs->ST_DMA = 1;
 
 	/* return success */
 	return 0;
@@ -109,6 +108,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
 	struct WD33C93_hostdata *hdata = shost_priv(instance);
+	a2091_scsiregs *regs = (a2091_scsiregs *)(instance->base);
 
 	/* disable SCSI interrupts */
 	unsigned short cntr = CNTR_PDMD;
@@ -117,23 +117,23 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		cntr |= CNTR_DDIR;
 
 	/* disable SCSI interrupts */
-	DMA(instance)->CNTR = cntr;
+	regs->CNTR = cntr;
 
 	/* flush if we were reading */
 	if (hdata->dma_dir) {
-		DMA(instance)->FLUSH = 1;
-		while (!(DMA(instance)->ISTR & ISTR_FE_FLG))
+		regs->FLUSH = 1;
+		while (!(regs->ISTR & ISTR_FE_FLG))
 			;
 	}
 
 	/* clear a possible interrupt */
-	DMA(instance)->CINT = 1;
+	regs->CINT = 1;
 
 	/* stop DMA */
-	DMA(instance)->SP_DMA = 1;
+	regs->SP_DMA = 1;
 
 	/* restore the CONTROL bits (minus the direction flag) */
-	DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
+	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
 
 	/* copy from a bounce buffer, if necessary */
 	if (status && hdata->dma_bounce_buffer) {
@@ -152,7 +152,8 @@ static int __init a2091_detect(struct scsi_host_template *tpnt)
 	struct Scsi_Host *instance;
 	unsigned long address;
 	struct zorro_dev *z = NULL;
-	wd33c93_regs regs;
+	wd33c93_regs wdregs;
+	a2091_scsiregs *regs;
 	struct WD33C93_hostdata *hdata;
 	int num_a2091 = 0;
 
@@ -177,19 +178,20 @@ static int __init a2091_detect(struct scsi_host_template *tpnt)
 		instance->base = ZTWO_VADDR(address);
 		instance->irq = IRQ_AMIGA_PORTS;
 		instance->unique_id = z->slotaddr;
-		DMA(instance)->DAWR = DAWR_A2091;
-		regs.SASR = &(DMA(instance)->SASR);
-		regs.SCMD = &(DMA(instance)->SCMD);
+		regs = (a2091_scsiregs *)(instance->base);
+		regs->DAWR = DAWR_A2091;
+		wdregs.SASR = &regs->SASR;
+		wdregs.SCMD = &regs->SCMD;
 		hdata = shost_priv(instance);
 		hdata->no_sync = 0xff;
 		hdata->fast = 0;
 		hdata->dma_mode = CTRL_DMA;
-		wd33c93_init(instance, regs, dma_setup, dma_stop,
+		wd33c93_init(instance, wdregs, dma_setup, dma_stop,
 			     WD33C93_FS_8_10);
 		if (request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED,
 				"A2091 SCSI", instance))
 			goto unregister;
-		DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
+		regs->CNTR = CNTR_PDMD | CNTR_INTEN;
 		num_a2091++;
 		continue;
 
@@ -240,7 +242,9 @@ static struct scsi_host_template driver_template = {
 static int a2091_release(struct Scsi_Host *instance)
 {
 #ifdef MODULE
-	DMA(instance)->CNTR = 0;
+	a2091_scsiregs *regs = (a2091_scsiregs *)(instance->base);
+
+	regs->CNTR = 0;
 	release_mem_region(ZTWO_PADDR(instance->base), 256);
 	free_irq(IRQ_AMIGA_PORTS, instance);
 #endif
-- 
1.6.0.4
