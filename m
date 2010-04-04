From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 05/21] m68k/scsi: a3000 - Reindentation
Date: Sun,  4 Apr 2010 11:00:35 +0200
Message-ID: <1270371651-2584-6-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-5-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a3000.c |  280 +++++++++++++++++++++++++-------------------------
 drivers/scsi/a3000.h |   46 ++++----
 2 files changed, 163 insertions(+), 163 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 50b10df..b27458e 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -18,26 +18,26 @@
 #include "wd33c93.h"
 #include "a3000.h"
 
-#include<linux/stat.h>
+#include <linux/stat.h>
 
-#define DMA(ptr) ((a3000_scsiregs *)((ptr)->base))
-#define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
+
+#define DMA(ptr)	((a3000_scsiregs *)((ptr)->base))
+#define HDATA(ptr)	((struct WD33C93_hostdata *)((ptr)->hostdata))
 
 static struct Scsi_Host *a3000_host = NULL;
 
 static int a3000_release(struct Scsi_Host *instance);
 
-static irqreturn_t a3000_intr (int irq, void *dummy)
+static irqreturn_t a3000_intr(int irq, void *dummy)
 {
 	unsigned long flags;
 	unsigned int status = DMA(a3000_host)->ISTR;
 
 	if (!(status & ISTR_INT_P))
 		return IRQ_NONE;
-	if (status & ISTR_INTS)
-	{
+	if (status & ISTR_INTS) {
 		spin_lock_irqsave(a3000_host->host_lock, flags);
-		wd33c93_intr (a3000_host);
+		wd33c93_intr(a3000_host);
 		spin_unlock_irqrestore(a3000_host->host_lock, flags);
 		return IRQ_HANDLED;
 	}
@@ -47,161 +47,161 @@ static irqreturn_t a3000_intr (int irq, void *dummy)
 
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
-    unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
-    unsigned long addr = virt_to_bus(cmd->SCp.ptr);
-
-    /*
-     * if the physical address has the wrong alignment, or if
-     * physical address is bad, or if it is a write and at the
-     * end of a physical memory chunk, then allocate a bounce
-     * buffer
-     */
-    if (addr & A3000_XFER_MASK)
-    {
-	HDATA(a3000_host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
-	    & ~0x1ff;
-	HDATA(a3000_host)->dma_bounce_buffer =
-	    kmalloc (HDATA(a3000_host)->dma_bounce_len, GFP_KERNEL);
-	
-	/* can't allocate memory; use PIO */
-	if (!HDATA(a3000_host)->dma_bounce_buffer) {
-	    HDATA(a3000_host)->dma_bounce_len = 0;
-	    return 1;
-	}
-
-	if (!dir_in) {
-	    /* copy to bounce buffer for a write */
-	    memcpy (HDATA(a3000_host)->dma_bounce_buffer,
-		cmd->SCp.ptr, cmd->SCp.this_residual);
+	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
+	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
+
+	/*
+	 * if the physical address has the wrong alignment, or if
+	 * physical address is bad, or if it is a write and at the
+	 * end of a physical memory chunk, then allocate a bounce
+	 * buffer
+	 */
+	if (addr & A3000_XFER_MASK) {
+		HDATA(a3000_host)->dma_bounce_len =
+			(cmd->SCp.this_residual + 511) & ~0x1ff;
+		HDATA(a3000_host)->dma_bounce_buffer =
+			kmalloc(HDATA(a3000_host)->dma_bounce_len, GFP_KERNEL);
+
+		/* can't allocate memory; use PIO */
+		if (!HDATA(a3000_host)->dma_bounce_buffer) {
+			HDATA(a3000_host)->dma_bounce_len = 0;
+			return 1;
+		}
+
+		if (!dir_in) {
+			/* copy to bounce buffer for a write */
+			memcpy(HDATA(a3000_host)->dma_bounce_buffer,
+			       cmd->SCp.ptr, cmd->SCp.this_residual);
+		}
+
+		addr = virt_to_bus(HDATA(a3000_host)->dma_bounce_buffer);
 	}
 
-	addr = virt_to_bus(HDATA(a3000_host)->dma_bounce_buffer);
-    }
-
-    /* setup dma direction */
-    if (!dir_in)
-	cntr |= CNTR_DDIR;
+	/* setup dma direction */
+	if (!dir_in)
+		cntr |= CNTR_DDIR;
 
-    /* remember direction */
-    HDATA(a3000_host)->dma_dir = dir_in;
+	/* remember direction */
+	HDATA(a3000_host)->dma_dir = dir_in;
 
-    DMA(a3000_host)->CNTR = cntr;
+	DMA(a3000_host)->CNTR = cntr;
 
-    /* setup DMA *physical* address */
-    DMA(a3000_host)->ACR = addr;
+	/* setup DMA *physical* address */
+	DMA(a3000_host)->ACR = addr;
 
-    if (dir_in)
-  	/* invalidate any cache */
-	cache_clear (addr, cmd->SCp.this_residual);
-    else
-	/* push any dirty cache */
-	cache_push (addr, cmd->SCp.this_residual);
+	if (dir_in) {
+		/* invalidate any cache */
+		cache_clear(addr, cmd->SCp.this_residual);
+	} else {
+		/* push any dirty cache */
+		cache_push(addr, cmd->SCp.this_residual);
+	}
 
-    /* start DMA */
-    mb();			/* make sure setup is completed */
-    DMA(a3000_host)->ST_DMA = 1;
-    mb();			/* make sure DMA has started before next IO */
+	/* start DMA */
+	mb();			/* make sure setup is completed */
+	DMA(a3000_host)->ST_DMA = 1;
+	mb();			/* make sure DMA has started before next IO */
 
-    /* return success */
-    return 0;
+	/* return success */
+	return 0;
 }
 
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
-    /* disable SCSI interrupts */
-    unsigned short cntr = CNTR_PDMD;
-
-    if (!HDATA(instance)->dma_dir)
-	cntr |= CNTR_DDIR;
-
-    DMA(instance)->CNTR = cntr;
-    mb();			/* make sure CNTR is updated before next IO */
-
-    /* flush if we were reading */
-    if (HDATA(instance)->dma_dir) {
-	DMA(instance)->FLUSH = 1;
-	mb();			/* don't allow prefetch */
-	while (!(DMA(instance)->ISTR & ISTR_FE_FLG))
-	    barrier();
-	mb();			/* no IO until FLUSH is done */
-    }
-
-    /* clear a possible interrupt */
-    /* I think that this CINT is only necessary if you are
-     * using the terminal count features.   HM 7 Mar 1994
-     */
-    DMA(instance)->CINT = 1;
-
-    /* stop DMA */
-    DMA(instance)->SP_DMA = 1;
-    mb();			/* make sure DMA is stopped before next IO */
-
-    /* restore the CONTROL bits (minus the direction flag) */
-    DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
-    mb();			/* make sure CNTR is updated before next IO */
-
-    /* copy from a bounce buffer, if necessary */
-    if (status && HDATA(instance)->dma_bounce_buffer) {
-	if (SCpnt) {
-	    if (HDATA(instance)->dma_dir && SCpnt)
-		memcpy (SCpnt->SCp.ptr,
-			HDATA(instance)->dma_bounce_buffer,
-			SCpnt->SCp.this_residual);
-	    kfree (HDATA(instance)->dma_bounce_buffer);
-	    HDATA(instance)->dma_bounce_buffer = NULL;
-	    HDATA(instance)->dma_bounce_len = 0;
-	} else {
-	    kfree (HDATA(instance)->dma_bounce_buffer);
-	    HDATA(instance)->dma_bounce_buffer = NULL;
-	    HDATA(instance)->dma_bounce_len = 0;
+	/* disable SCSI interrupts */
+	unsigned short cntr = CNTR_PDMD;
+
+	if (!HDATA(instance)->dma_dir)
+		cntr |= CNTR_DDIR;
+
+	DMA(instance)->CNTR = cntr;
+	mb();			/* make sure CNTR is updated before next IO */
+
+	/* flush if we were reading */
+	if (HDATA(instance)->dma_dir) {
+		DMA(instance)->FLUSH = 1;
+		mb();		/* don't allow prefetch */
+		while (!(DMA(instance)->ISTR & ISTR_FE_FLG))
+			barrier();
+		mb();		/* no IO until FLUSH is done */
+	}
+
+	/* clear a possible interrupt */
+	/* I think that this CINT is only necessary if you are
+	 * using the terminal count features.   HM 7 Mar 1994
+	 */
+	DMA(instance)->CINT = 1;
+
+	/* stop DMA */
+	DMA(instance)->SP_DMA = 1;
+	mb();			/* make sure DMA is stopped before next IO */
+
+	/* restore the CONTROL bits (minus the direction flag) */
+	DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
+	mb();			/* make sure CNTR is updated before next IO */
+
+	/* copy from a bounce buffer, if necessary */
+	if (status && HDATA(instance)->dma_bounce_buffer) {
+		if (SCpnt) {
+			if (HDATA(instance)->dma_dir && SCpnt)
+				memcpy(SCpnt->SCp.ptr,
+				       HDATA(instance)->dma_bounce_buffer,
+				       SCpnt->SCp.this_residual);
+			kfree(HDATA(instance)->dma_bounce_buffer);
+			HDATA(instance)->dma_bounce_buffer = NULL;
+			HDATA(instance)->dma_bounce_len = 0;
+		} else {
+			kfree(HDATA(instance)->dma_bounce_buffer);
+			HDATA(instance)->dma_bounce_buffer = NULL;
+			HDATA(instance)->dma_bounce_len = 0;
+		}
 	}
-    }
 }
 
 static int __init a3000_detect(struct scsi_host_template *tpnt)
 {
-    wd33c93_regs regs;
-
-    if  (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(A3000_SCSI))
-	return 0;
-    if (!request_mem_region(0xDD0000, 256, "wd33c93"))
-	return 0;
-
-    tpnt->proc_name = "A3000";
-    tpnt->proc_info = &wd33c93_proc_info;
-
-    a3000_host = scsi_register (tpnt, sizeof(struct WD33C93_hostdata));
-    if (a3000_host == NULL)
-	goto fail_register;
-
-    a3000_host->base = ZTWO_VADDR(0xDD0000);
-    a3000_host->irq = IRQ_AMIGA_PORTS;
-    DMA(a3000_host)->DAWR = DAWR_A3000;
-    regs.SASR = &(DMA(a3000_host)->SASR);
-    regs.SCMD = &(DMA(a3000_host)->SCMD);
-    HDATA(a3000_host)->no_sync = 0xff;
-    HDATA(a3000_host)->fast = 0;
-    HDATA(a3000_host)->dma_mode = CTRL_DMA;
-    wd33c93_init(a3000_host, regs, dma_setup, dma_stop, WD33C93_FS_12_15);
-    if (request_irq(IRQ_AMIGA_PORTS, a3000_intr, IRQF_SHARED, "A3000 SCSI",
-		    a3000_intr))
-        goto fail_irq;
-    DMA(a3000_host)->CNTR = CNTR_PDMD | CNTR_INTEN;
-
-    return 1;
+	wd33c93_regs regs;
+
+	if (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(A3000_SCSI))
+		return 0;
+	if (!request_mem_region(0xDD0000, 256, "wd33c93"))
+		return 0;
+
+	tpnt->proc_name = "A3000";
+	tpnt->proc_info = &wd33c93_proc_info;
+
+	a3000_host = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
+	if (a3000_host == NULL)
+		goto fail_register;
+
+	a3000_host->base = ZTWO_VADDR(0xDD0000);
+	a3000_host->irq = IRQ_AMIGA_PORTS;
+	DMA(a3000_host)->DAWR = DAWR_A3000;
+	regs.SASR = &(DMA(a3000_host)->SASR);
+	regs.SCMD = &(DMA(a3000_host)->SCMD);
+	HDATA(a3000_host)->no_sync = 0xff;
+	HDATA(a3000_host)->fast = 0;
+	HDATA(a3000_host)->dma_mode = CTRL_DMA;
+	wd33c93_init(a3000_host, regs, dma_setup, dma_stop, WD33C93_FS_12_15);
+	if (request_irq(IRQ_AMIGA_PORTS, a3000_intr, IRQF_SHARED, "A3000 SCSI",
+			a3000_intr))
+		goto fail_irq;
+	DMA(a3000_host)->CNTR = CNTR_PDMD | CNTR_INTEN;
+
+	return 1;
 
 fail_irq:
-    scsi_unregister(a3000_host);
+	scsi_unregister(a3000_host);
 fail_register:
-    release_mem_region(0xDD0000, 256);
-    return 0;
+	release_mem_region(0xDD0000, 256);
+	return 0;
 }
 
 static int a3000_bus_reset(struct scsi_cmnd *cmd)
 {
 	/* FIXME perform bus-specific reset */
-	
+
 	/* FIXME 2: kill this entire function, which should
 	   cause mid-layer to call wd33c93_host_reset anyway? */
 
@@ -235,10 +235,10 @@ static struct scsi_host_template driver_template = {
 
 static int a3000_release(struct Scsi_Host *instance)
 {
-    DMA(instance)->CNTR = 0;
-    release_mem_region(0xDD0000, 256);
-    free_irq(IRQ_AMIGA_PORTS, a3000_intr);
-    return 1;
+	DMA(instance)->CNTR = 0;
+	release_mem_region(0xDD0000, 256);
+	free_irq(IRQ_AMIGA_PORTS, a3000_intr);
+	return 1;
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/a3000.h b/drivers/scsi/a3000.h
index c7afe16..684813e 100644
--- a/drivers/scsi/a3000.h
+++ b/drivers/scsi/a3000.h
@@ -12,40 +12,40 @@
 #include <linux/types.h>
 
 #ifndef CMD_PER_LUN
-#define CMD_PER_LUN 2
+#define CMD_PER_LUN		2
 #endif
 
 #ifndef CAN_QUEUE
-#define CAN_QUEUE 16
+#define CAN_QUEUE		16
 #endif
 
 /*
  * if the transfer address ANDed with this results in a non-zero
  * result, then we can't use DMA.
  */
-#define A3000_XFER_MASK  (0x00000003)
+#define A3000_XFER_MASK		(0x00000003)
 
 typedef struct {
-             unsigned char      pad1[2];
-    volatile unsigned short     DAWR;
-    volatile unsigned int       WTC;
-             unsigned char      pad2[2];
-    volatile unsigned short     CNTR;
-    volatile unsigned long      ACR;
-             unsigned char      pad3[2];
-    volatile unsigned short     ST_DMA;
-             unsigned char      pad4[2];
-    volatile unsigned short     FLUSH;
-             unsigned char      pad5[2];
-    volatile unsigned short     CINT;
-             unsigned char      pad6[2];
-    volatile unsigned short     ISTR;
-	     unsigned char      pad7[30];
-    volatile unsigned short     SP_DMA;
-             unsigned char      pad8;
-    volatile unsigned char      SASR;
-             unsigned char      pad9;
-    volatile unsigned char      SCMD;
+		 unsigned char	pad1[2];
+	volatile unsigned short	DAWR;
+	volatile unsigned int	WTC;
+		 unsigned char	pad2[2];
+	volatile unsigned short	CNTR;
+	volatile unsigned long	ACR;
+		 unsigned char	pad3[2];
+	volatile unsigned short	ST_DMA;
+		 unsigned char	pad4[2];
+	volatile unsigned short	FLUSH;
+		 unsigned char	pad5[2];
+	volatile unsigned short	CINT;
+		 unsigned char	pad6[2];
+	volatile unsigned short	ISTR;
+		 unsigned char	pad7[30];
+	volatile unsigned short	SP_DMA;
+		 unsigned char	pad8;
+	volatile unsigned char	SASR;
+		 unsigned char	pad9;
+	volatile unsigned char	SCMD;
 } a3000_scsiregs;
 
 #define DAWR_A3000		(3)
-- 
1.6.0.4
