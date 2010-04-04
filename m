From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 02/21] m68k/scsi: a2091 - Reindentation
Date: Sun,  4 Apr 2010 11:00:32 +0200
Message-ID: <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/a2091.c |  299 +++++++++++++++++++++++++-------------------------
 drivers/scsi/a2091.h |   42 ++++----
 2 files changed, 171 insertions(+), 170 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index f2731a7..f09c8ba 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -18,185 +18,186 @@
 #include "wd33c93.h"
 #include "a2091.h"
 
-#include<linux/stat.h>
+#include <linux/stat.h>
 
-#define DMA(ptr) ((a2091_scsiregs *)((ptr)->base))
-#define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
+
+#define DMA(ptr)	((a2091_scsiregs *)((ptr)->base))
+#define HDATA(ptr)	((struct WD33C93_hostdata *)((ptr)->hostdata))
 
 static int a2091_release(struct Scsi_Host *instance);
 
-static irqreturn_t a2091_intr (int irq, void *_instance)
+static irqreturn_t a2091_intr(int irq, void *_instance)
 {
-    unsigned long flags;
-    unsigned int status;
-    struct Scsi_Host *instance = (struct Scsi_Host *)_instance;
-
-    status = DMA(instance)->ISTR;
-    if (!(status & (ISTR_INT_F|ISTR_INT_P)) || !(status & ISTR_INTS))
-	return IRQ_NONE;
-
-    spin_lock_irqsave(instance->host_lock, flags);
-    wd33c93_intr(instance);
-    spin_unlock_irqrestore(instance->host_lock, flags);
-    return IRQ_HANDLED;
+	unsigned long flags;
+	unsigned int status;
+	struct Scsi_Host *instance = (struct Scsi_Host *)_instance;
+
+	status = DMA(instance)->ISTR;
+	if (!(status & (ISTR_INT_F | ISTR_INT_P)) || !(status & ISTR_INTS))
+		return IRQ_NONE;
+
+	spin_lock_irqsave(instance->host_lock, flags);
+	wd33c93_intr(instance);
+	spin_unlock_irqrestore(instance->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
-    unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
-    unsigned long addr = virt_to_bus(cmd->SCp.ptr);
-    struct Scsi_Host *instance = cmd->device->host;
-
-    /* don't allow DMA if the physical address is bad */
-    if (addr & A2091_XFER_MASK)
-    {
-	HDATA(instance)->dma_bounce_len = (cmd->SCp.this_residual + 511)
-	    & ~0x1ff;
-	HDATA(instance)->dma_bounce_buffer =
-	    kmalloc (HDATA(instance)->dma_bounce_len, GFP_KERNEL);
-	
-	/* can't allocate memory; use PIO */
-	if (!HDATA(instance)->dma_bounce_buffer) {
-	    HDATA(instance)->dma_bounce_len = 0;
-	    return 1;
-	}
-
-	/* get the physical address of the bounce buffer */
-	addr = virt_to_bus(HDATA(instance)->dma_bounce_buffer);
+	unsigned short cntr = CNTR_PDMD | CNTR_INTEN;
+	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
+	struct Scsi_Host *instance = cmd->device->host;
 
-	/* the bounce buffer may not be in the first 16M of physmem */
+	/* don't allow DMA if the physical address is bad */
 	if (addr & A2091_XFER_MASK) {
-	    /* we could use chipmem... maybe later */
-	    kfree (HDATA(instance)->dma_bounce_buffer);
-	    HDATA(instance)->dma_bounce_buffer = NULL;
-	    HDATA(instance)->dma_bounce_len = 0;
-	    return 1;
-	}
-
-	if (!dir_in) {
-		/* copy to bounce buffer for a write */
-		memcpy (HDATA(instance)->dma_bounce_buffer,
-			cmd->SCp.ptr, cmd->SCp.this_residual);
+		HDATA(instance)->dma_bounce_len =
+			(cmd->SCp.this_residual + 511) & ~0x1ff;
+		HDATA(instance)->dma_bounce_buffer =
+			kmalloc(HDATA(instance)->dma_bounce_len, GFP_KERNEL);
+
+		/* can't allocate memory; use PIO */
+		if (!HDATA(instance)->dma_bounce_buffer) {
+			HDATA(instance)->dma_bounce_len = 0;
+			return 1;
+		}
+
+		/* get the physical address of the bounce buffer */
+		addr = virt_to_bus(HDATA(instance)->dma_bounce_buffer);
+
+		/* the bounce buffer may not be in the first 16M of physmem */
+		if (addr & A2091_XFER_MASK) {
+			/* we could use chipmem... maybe later */
+			kfree(HDATA(instance)->dma_bounce_buffer);
+			HDATA(instance)->dma_bounce_buffer = NULL;
+			HDATA(instance)->dma_bounce_len = 0;
+			return 1;
+		}
+
+		if (!dir_in) {
+			/* copy to bounce buffer for a write */
+			memcpy(HDATA(instance)->dma_bounce_buffer,
+			       cmd->SCp.ptr, cmd->SCp.this_residual);
+		}
 	}
-    }
 
-    /* setup dma direction */
-    if (!dir_in)
-	cntr |= CNTR_DDIR;
+	/* setup dma direction */
+	if (!dir_in)
+		cntr |= CNTR_DDIR;
 
-    /* remember direction */
-    HDATA(cmd->device->host)->dma_dir = dir_in;
+	/* remember direction */
+	HDATA(cmd->device->host)->dma_dir = dir_in;
 
-    DMA(cmd->device->host)->CNTR = cntr;
+	DMA(cmd->device->host)->CNTR = cntr;
 
-    /* setup DMA *physical* address */
-    DMA(cmd->device->host)->ACR = addr;
+	/* setup DMA *physical* address */
+	DMA(cmd->device->host)->ACR = addr;
 
-    if (dir_in){
-	/* invalidate any cache */
-	cache_clear (addr, cmd->SCp.this_residual);
-    }else{
-	/* push any dirty cache */
-	cache_push (addr, cmd->SCp.this_residual);
-      }
-    /* start DMA */
-    DMA(cmd->device->host)->ST_DMA = 1;
+	if (dir_in) {
+		/* invalidate any cache */
+		cache_clear(addr, cmd->SCp.this_residual);
+	} else {
+		/* push any dirty cache */
+		cache_push(addr, cmd->SCp.this_residual);
+	}
+	/* start DMA */
+	DMA(cmd->device->host)->ST_DMA = 1;
 
-    /* return success */
-    return 0;
+	/* return success */
+	return 0;
 }
 
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
-		      int status)
+		     int status)
 {
-    /* disable SCSI interrupts */
-    unsigned short cntr = CNTR_PDMD;
-
-    if (!HDATA(instance)->dma_dir)
-	    cntr |= CNTR_DDIR;
-
-    /* disable SCSI interrupts */
-    DMA(instance)->CNTR = cntr;
-
-    /* flush if we were reading */
-    if (HDATA(instance)->dma_dir) {
-	DMA(instance)->FLUSH = 1;
-	while (!(DMA(instance)->ISTR & ISTR_FE_FLG))
-	    ;
-    }
-
-    /* clear a possible interrupt */
-    DMA(instance)->CINT = 1;
-
-    /* stop DMA */
-    DMA(instance)->SP_DMA = 1;
-
-    /* restore the CONTROL bits (minus the direction flag) */
-    DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
-
-    /* copy from a bounce buffer, if necessary */
-    if (status && HDATA(instance)->dma_bounce_buffer) {
-	if( HDATA(instance)->dma_dir )
-		memcpy (SCpnt->SCp.ptr, 
-			HDATA(instance)->dma_bounce_buffer,
-			SCpnt->SCp.this_residual);
-	kfree (HDATA(instance)->dma_bounce_buffer);
-	HDATA(instance)->dma_bounce_buffer = NULL;
-	HDATA(instance)->dma_bounce_len = 0;
-    }
+	/* disable SCSI interrupts */
+	unsigned short cntr = CNTR_PDMD;
+
+	if (!HDATA(instance)->dma_dir)
+		cntr |= CNTR_DDIR;
+
+	/* disable SCSI interrupts */
+	DMA(instance)->CNTR = cntr;
+
+	/* flush if we were reading */
+	if (HDATA(instance)->dma_dir) {
+		DMA(instance)->FLUSH = 1;
+		while (!(DMA(instance)->ISTR & ISTR_FE_FLG))
+			;
+	}
+
+	/* clear a possible interrupt */
+	DMA(instance)->CINT = 1;
+
+	/* stop DMA */
+	DMA(instance)->SP_DMA = 1;
+
+	/* restore the CONTROL bits (minus the direction flag) */
+	DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
+
+	/* copy from a bounce buffer, if necessary */
+	if (status && HDATA(instance)->dma_bounce_buffer) {
+		if (HDATA(instance)->dma_dir)
+			memcpy(SCpnt->SCp.ptr,
+			       HDATA(instance)->dma_bounce_buffer,
+			       SCpnt->SCp.this_residual);
+		kfree(HDATA(instance)->dma_bounce_buffer);
+		HDATA(instance)->dma_bounce_buffer = NULL;
+		HDATA(instance)->dma_bounce_len = 0;
+	}
 }
 
 static int __init a2091_detect(struct scsi_host_template *tpnt)
 {
-    static unsigned char called = 0;
-    struct Scsi_Host *instance;
-    unsigned long address;
-    struct zorro_dev *z = NULL;
-    wd33c93_regs regs;
-    int num_a2091 = 0;
-
-    if (!MACH_IS_AMIGA || called)
-	return 0;
-    called = 1;
-
-    tpnt->proc_name = "A2091";
-    tpnt->proc_info = &wd33c93_proc_info;
-
-    while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
-	if (z->id != ZORRO_PROD_CBM_A590_A2091_1 &&
-	    z->id != ZORRO_PROD_CBM_A590_A2091_2)
-	    continue;
-	address = z->resource.start;
-	if (!request_mem_region(address, 256, "wd33c93"))
-	    continue;
-
-	instance = scsi_register (tpnt, sizeof (struct WD33C93_hostdata));
-	if (instance == NULL)
-	    goto release;
-	instance->base = ZTWO_VADDR(address);
-	instance->irq = IRQ_AMIGA_PORTS;
-	instance->unique_id = z->slotaddr;
-	DMA(instance)->DAWR = DAWR_A2091;
-	regs.SASR = &(DMA(instance)->SASR);
-	regs.SCMD = &(DMA(instance)->SCMD);
-	HDATA(instance)->no_sync = 0xff;
-	HDATA(instance)->fast = 0;
-	HDATA(instance)->dma_mode = CTRL_DMA;
-	wd33c93_init(instance, regs, dma_setup, dma_stop, WD33C93_FS_8_10);
-	if (request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED, "A2091 SCSI",
-			instance))
-	    goto unregister;
-	DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
-	num_a2091++;
-	continue;
+	static unsigned char called = 0;
+	struct Scsi_Host *instance;
+	unsigned long address;
+	struct zorro_dev *z = NULL;
+	wd33c93_regs regs;
+	int num_a2091 = 0;
+
+	if (!MACH_IS_AMIGA || called)
+		return 0;
+	called = 1;
+
+	tpnt->proc_name = "A2091";
+	tpnt->proc_info = &wd33c93_proc_info;
+
+	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
+		if (z->id != ZORRO_PROD_CBM_A590_A2091_1 &&
+		    z->id != ZORRO_PROD_CBM_A590_A2091_2)
+			continue;
+		address = z->resource.start;
+		if (!request_mem_region(address, 256, "wd33c93"))
+			continue;
+
+		instance = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
+		if (instance == NULL)
+			goto release;
+		instance->base = ZTWO_VADDR(address);
+		instance->irq = IRQ_AMIGA_PORTS;
+		instance->unique_id = z->slotaddr;
+		DMA(instance)->DAWR = DAWR_A2091;
+		regs.SASR = &(DMA(instance)->SASR);
+		regs.SCMD = &(DMA(instance)->SCMD);
+		HDATA(instance)->no_sync = 0xff;
+		HDATA(instance)->fast = 0;
+		HDATA(instance)->dma_mode = CTRL_DMA;
+		wd33c93_init(instance, regs, dma_setup, dma_stop,
+			     WD33C93_FS_8_10);
+		if (request_irq(IRQ_AMIGA_PORTS, a2091_intr, IRQF_SHARED,
+				"A2091 SCSI", instance))
+			goto unregister;
+		DMA(instance)->CNTR = CNTR_PDMD | CNTR_INTEN;
+		num_a2091++;
+		continue;
 
 unregister:
-	scsi_unregister(instance);
+		scsi_unregister(instance);
 release:
-	release_mem_region(address, 256);
-    }
+		release_mem_region(address, 256);
+	}
 
-    return num_a2091;
+	return num_a2091;
 }
 
 static int a2091_bus_reset(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/a2091.h b/drivers/scsi/a2091.h
index 252528f..1c3daa1 100644
--- a/drivers/scsi/a2091.h
+++ b/drivers/scsi/a2091.h
@@ -12,38 +12,38 @@
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
-#define A2091_XFER_MASK  (0xff000001)
+#define A2091_XFER_MASK		(0xff000001)
 
 typedef struct {
-             unsigned char      pad1[64];
-    volatile unsigned short     ISTR;
-    volatile unsigned short     CNTR;
-             unsigned char      pad2[60];
-    volatile unsigned int       WTC;
-    volatile unsigned long      ACR;
-             unsigned char      pad3[6];
-    volatile unsigned short     DAWR;
-             unsigned char      pad4;
-    volatile unsigned char      SASR;
-             unsigned char      pad5;
-    volatile unsigned char      SCMD;
-             unsigned char      pad6[76];
-    volatile unsigned short     ST_DMA;
-    volatile unsigned short     SP_DMA;
-    volatile unsigned short     CINT;
-             unsigned char      pad7[2];
-    volatile unsigned short     FLUSH;
+		 unsigned char	pad1[64];
+	volatile unsigned short	ISTR;
+	volatile unsigned short	CNTR;
+		 unsigned char	pad2[60];
+	volatile unsigned int	WTC;
+	volatile unsigned long	ACR;
+		 unsigned char	pad3[6];
+	volatile unsigned short	DAWR;
+		 unsigned char	pad4;
+	volatile unsigned char	SASR;
+		 unsigned char	pad5;
+	volatile unsigned char	SCMD;
+		 unsigned char	pad6[76];
+	volatile unsigned short	ST_DMA;
+	volatile unsigned short	SP_DMA;
+	volatile unsigned short	CINT;
+		 unsigned char	pad7[2];
+	volatile unsigned short	FLUSH;
 } a2091_scsiregs;
 
 #define DAWR_A2091		(3)
-- 
1.6.0.4
