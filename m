From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 03/21] m68k/scsi: gvp11 - Reindentation
Date: Sun,  4 Apr 2010 11:00:33 +0200
Message-ID: <1270371651-2584-4-git-send-email-geert@linux-m68k.org>
References: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-2-git-send-email-geert@linux-m68k.org>
 <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1270371651-2584-3-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/gvp11.c |  562 +++++++++++++++++++++++++-------------------------
 drivers/scsi/gvp11.h |   36 ++--
 2 files changed, 301 insertions(+), 297 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 0b09c0d..6ec7520 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -18,331 +18,335 @@
 #include "wd33c93.h"
 #include "gvp11.h"
 
-#include<linux/stat.h>
+#include <linux/stat.h>
 
-#define DMA(ptr) ((gvp11_scsiregs *)((ptr)->base))
-#define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
-static irqreturn_t gvp11_intr (int irq, void *_instance)
+#define DMA(ptr)	((gvp11_scsiregs *)((ptr)->base))
+#define HDATA(ptr)	((struct WD33C93_hostdata *)((ptr)->hostdata))
+
+static irqreturn_t gvp11_intr(int irq, void *_instance)
 {
-    unsigned long flags;
-    unsigned int status;
-    struct Scsi_Host *instance = (struct Scsi_Host *)_instance;
-
-    status = DMA(instance)->CNTR;
-    if (!(status & GVP11_DMAC_INT_PENDING))
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
+	status = DMA(instance)->CNTR;
+	if (!(status & GVP11_DMAC_INT_PENDING))
+		return IRQ_NONE;
+
+	spin_lock_irqsave(instance->host_lock, flags);
+	wd33c93_intr(instance);
+	spin_unlock_irqrestore(instance->host_lock, flags);
+	return IRQ_HANDLED;
 }
 
 static int gvp11_xfer_mask = 0;
 
-void gvp11_setup (char *str, int *ints)
+void gvp11_setup(char *str, int *ints)
 {
-    gvp11_xfer_mask = ints[1];
+	gvp11_xfer_mask = ints[1];
 }
 
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
-    unsigned short cntr = GVP11_DMAC_INT_ENABLE;
-    unsigned long addr = virt_to_bus(cmd->SCp.ptr);
-    int bank_mask;
-    static int scsi_alloc_out_of_range = 0;
-
-    /* use bounce buffer if the physical address is bad */
-    if (addr & HDATA(cmd->device->host)->dma_xfer_mask)
-    {
-	HDATA(cmd->device->host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
-	    & ~0x1ff;
-
- 	if( !scsi_alloc_out_of_range ) {
-	    HDATA(cmd->device->host)->dma_bounce_buffer =
-		kmalloc (HDATA(cmd->device->host)->dma_bounce_len, GFP_KERNEL);
-	    HDATA(cmd->device->host)->dma_buffer_pool = BUF_SCSI_ALLOCED;
-	}
+	unsigned short cntr = GVP11_DMAC_INT_ENABLE;
+	unsigned long addr = virt_to_bus(cmd->SCp.ptr);
+	int bank_mask;
+	static int scsi_alloc_out_of_range = 0;
 
-	if (scsi_alloc_out_of_range ||
-	    !HDATA(cmd->device->host)->dma_bounce_buffer) {
-	    HDATA(cmd->device->host)->dma_bounce_buffer =
-		amiga_chip_alloc(HDATA(cmd->device->host)->dma_bounce_len,
-				       "GVP II SCSI Bounce Buffer");
+	/* use bounce buffer if the physical address is bad */
+	if (addr & HDATA(cmd->device->host)->dma_xfer_mask) {
+		HDATA(cmd->device->host)->dma_bounce_len =
+			(cmd->SCp.this_residual + 511) & ~0x1ff;
+
+		if (!scsi_alloc_out_of_range) {
+			HDATA(cmd->device->host)->dma_bounce_buffer =
+				kmalloc(HDATA(cmd->device->host)->dma_bounce_len,
+					GFP_KERNEL);
+			HDATA(cmd->device->host)->dma_buffer_pool =
+				BUF_SCSI_ALLOCED;
+		}
 
-	    if(!HDATA(cmd->device->host)->dma_bounce_buffer)
-	    {
-		HDATA(cmd->device->host)->dma_bounce_len = 0;
-		return 1;
-	    }
+		if (scsi_alloc_out_of_range ||
+		    !HDATA(cmd->device->host)->dma_bounce_buffer) {
+			HDATA(cmd->device->host)->dma_bounce_buffer =
+				amiga_chip_alloc(HDATA(cmd->device->host)->dma_bounce_len,
+						 "GVP II SCSI Bounce Buffer");
 
-	    HDATA(cmd->device->host)->dma_buffer_pool = BUF_CHIP_ALLOCED;
-	}
+			if (!HDATA(cmd->device->host)->dma_bounce_buffer) {
+				HDATA(cmd->device->host)->dma_bounce_len = 0;
+				return 1;
+			}
 
-	/* check if the address of the bounce buffer is OK */
-	addr = virt_to_bus(HDATA(cmd->device->host)->dma_bounce_buffer);
+			HDATA(cmd->device->host)->dma_buffer_pool =
+				BUF_CHIP_ALLOCED;
+		}
 
-	if (addr & HDATA(cmd->device->host)->dma_xfer_mask) {
-	    /* fall back to Chip RAM if address out of range */
-	    if( HDATA(cmd->device->host)->dma_buffer_pool == BUF_SCSI_ALLOCED) {
-		kfree (HDATA(cmd->device->host)->dma_bounce_buffer);
-		scsi_alloc_out_of_range = 1;
-	    } else {
-		amiga_chip_free (HDATA(cmd->device->host)->dma_bounce_buffer);
-            }
-		
-	    HDATA(cmd->device->host)->dma_bounce_buffer =
-		amiga_chip_alloc(HDATA(cmd->device->host)->dma_bounce_len,
-				       "GVP II SCSI Bounce Buffer");
-
-	    if(!HDATA(cmd->device->host)->dma_bounce_buffer)
-	    {
-		HDATA(cmd->device->host)->dma_bounce_len = 0;
-		return 1;
-	    }
-
-	    addr = virt_to_bus(HDATA(cmd->device->host)->dma_bounce_buffer);
-	    HDATA(cmd->device->host)->dma_buffer_pool = BUF_CHIP_ALLOCED;
-	}
-	    
-	if (!dir_in) {
-	    /* copy to bounce buffer for a write */
-	    memcpy (HDATA(cmd->device->host)->dma_bounce_buffer,
-		    cmd->SCp.ptr, cmd->SCp.this_residual);
+		/* check if the address of the bounce buffer is OK */
+		addr = virt_to_bus(HDATA(cmd->device->host)->dma_bounce_buffer);
+
+		if (addr & HDATA(cmd->device->host)->dma_xfer_mask) {
+			/* fall back to Chip RAM if address out of range */
+			if (HDATA(cmd->device->host)->dma_buffer_pool ==
+			    BUF_SCSI_ALLOCED) {
+				kfree(HDATA(cmd->device->host)->dma_bounce_buffer);
+				scsi_alloc_out_of_range = 1;
+			} else {
+				amiga_chip_free(HDATA(cmd->device->host)->dma_bounce_buffer);
+			}
+
+			HDATA(cmd->device->host)->dma_bounce_buffer =
+				amiga_chip_alloc(HDATA(cmd->device->host)->dma_bounce_len,
+						 "GVP II SCSI Bounce Buffer");
+
+			if (!HDATA(cmd->device->host)->dma_bounce_buffer) {
+				HDATA(cmd->device->host)->dma_bounce_len = 0;
+				return 1;
+			}
+
+			addr = virt_to_bus(HDATA(cmd->device->host)->dma_bounce_buffer);
+			HDATA(cmd->device->host)->dma_buffer_pool =
+				BUF_CHIP_ALLOCED;
+		}
+
+		if (!dir_in) {
+			/* copy to bounce buffer for a write */
+			memcpy(HDATA(cmd->device->host)->dma_bounce_buffer,
+			       cmd->SCp.ptr, cmd->SCp.this_residual);
+		}
 	}
-    }
 
-    /* setup dma direction */
-    if (!dir_in)
-	cntr |= GVP11_DMAC_DIR_WRITE;
+	/* setup dma direction */
+	if (!dir_in)
+		cntr |= GVP11_DMAC_DIR_WRITE;
 
-    HDATA(cmd->device->host)->dma_dir = dir_in;
-    DMA(cmd->device->host)->CNTR = cntr;
+	HDATA(cmd->device->host)->dma_dir = dir_in;
+	DMA(cmd->device->host)->CNTR = cntr;
 
-    /* setup DMA *physical* address */
-    DMA(cmd->device->host)->ACR = addr;
+	/* setup DMA *physical* address */
+	DMA(cmd->device->host)->ACR = addr;
 
-    if (dir_in)
-	/* invalidate any cache */
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
 
-    if ((bank_mask = (~HDATA(cmd->device->host)->dma_xfer_mask >> 18) & 0x01c0))
-	    DMA(cmd->device->host)->BANK = bank_mask & (addr >> 18);
+	if ((bank_mask = (~HDATA(cmd->device->host)->dma_xfer_mask >> 18) & 0x01c0))
+		DMA(cmd->device->host)->BANK = bank_mask & (addr >> 18);
 
-    /* start DMA */
-    DMA(cmd->device->host)->ST_DMA = 1;
+	/* start DMA */
+	DMA(cmd->device->host)->ST_DMA = 1;
 
-    /* return success */
-    return 0;
+	/* return success */
+	return 0;
 }
 
 static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 		     int status)
 {
-    /* stop DMA */
-    DMA(instance)->SP_DMA = 1;
-    /* remove write bit from CONTROL bits */
-    DMA(instance)->CNTR = GVP11_DMAC_INT_ENABLE;
-
-    /* copy from a bounce buffer, if necessary */
-    if (status && HDATA(instance)->dma_bounce_buffer) {
-	if (HDATA(instance)->dma_dir && SCpnt)
-	    memcpy (SCpnt->SCp.ptr, 
-		    HDATA(instance)->dma_bounce_buffer,
-		    SCpnt->SCp.this_residual);
-	
-	if (HDATA(instance)->dma_buffer_pool == BUF_SCSI_ALLOCED)
-	    kfree (HDATA(instance)->dma_bounce_buffer);
-	else
-	    amiga_chip_free(HDATA(instance)->dma_bounce_buffer);
-	
-	HDATA(instance)->dma_bounce_buffer = NULL;
-	HDATA(instance)->dma_bounce_len = 0;
-    }
+	/* stop DMA */
+	DMA(instance)->SP_DMA = 1;
+	/* remove write bit from CONTROL bits */
+	DMA(instance)->CNTR = GVP11_DMAC_INT_ENABLE;
+
+	/* copy from a bounce buffer, if necessary */
+	if (status && HDATA(instance)->dma_bounce_buffer) {
+		if (HDATA(instance)->dma_dir && SCpnt)
+			memcpy(SCpnt->SCp.ptr,
+			       HDATA(instance)->dma_bounce_buffer,
+			       SCpnt->SCp.this_residual);
+
+		if (HDATA(instance)->dma_buffer_pool == BUF_SCSI_ALLOCED)
+			kfree(HDATA(instance)->dma_bounce_buffer);
+		else
+			amiga_chip_free(HDATA(instance)->dma_bounce_buffer);
+
+		HDATA(instance)->dma_bounce_buffer = NULL;
+		HDATA(instance)->dma_bounce_len = 0;
+	}
 }
 
 #define CHECK_WD33C93
 
 int __init gvp11_detect(struct scsi_host_template *tpnt)
 {
-    static unsigned char called = 0;
-    struct Scsi_Host *instance;
-    unsigned long address;
-    unsigned int epc;
-    struct zorro_dev *z = NULL;
-    unsigned int default_dma_xfer_mask;
-    wd33c93_regs regs;
-    int num_gvp11 = 0;
+	static unsigned char called = 0;
+	struct Scsi_Host *instance;
+	unsigned long address;
+	unsigned int epc;
+	struct zorro_dev *z = NULL;
+	unsigned int default_dma_xfer_mask;
+	wd33c93_regs regs;
+	int num_gvp11 = 0;
 #ifdef CHECK_WD33C93
-    volatile unsigned char *sasr_3393, *scmd_3393;
-    unsigned char save_sasr;
-    unsigned char q, qq;
+	volatile unsigned char *sasr_3393, *scmd_3393;
+	unsigned char save_sasr;
+	unsigned char q, qq;
 #endif
 
-    if (!MACH_IS_AMIGA || called)
-	return 0;
-    called = 1;
-
-    tpnt->proc_name = "GVP11";
-    tpnt->proc_info = &wd33c93_proc_info;
-
-    while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
-	/* 
-	 * This should (hopefully) be the correct way to identify
-	 * all the different GVP SCSI controllers (except for the
-	 * SERIES I though).
-	 */
-
-	if (z->id == ZORRO_PROD_GVP_COMBO_030_R3_SCSI ||
-	    z->id == ZORRO_PROD_GVP_SERIES_II)
-	    default_dma_xfer_mask = ~0x00ffffff;
-	else if (z->id == ZORRO_PROD_GVP_GFORCE_030_SCSI ||
-		 z->id == ZORRO_PROD_GVP_A530_SCSI ||
-		 z->id == ZORRO_PROD_GVP_COMBO_030_R4_SCSI)
-	    default_dma_xfer_mask = ~0x01ffffff;
-	else if (z->id == ZORRO_PROD_GVP_A1291 ||
-		 z->id == ZORRO_PROD_GVP_GFORCE_040_SCSI_1)
-	    default_dma_xfer_mask = ~0x07ffffff;
-	else
-	    continue;
-
-	/*
-	 * Rumors state that some GVP ram boards use the same product
-	 * code as the SCSI controllers. Therefore if the board-size
-	 * is not 64KB we asume it is a ram board and bail out.
-	 */
-	if (z->resource.end-z->resource.start != 0xffff)
-		continue;
-
-	address = z->resource.start;
-	if (!request_mem_region(address, 256, "wd33c93"))
-	    continue;
+	if (!MACH_IS_AMIGA || called)
+		return 0;
+	called = 1;
+
+	tpnt->proc_name = "GVP11";
+	tpnt->proc_info = &wd33c93_proc_info;
+
+	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
+		/*
+		 * This should (hopefully) be the correct way to identify
+		 * all the different GVP SCSI controllers (except for the
+		 * SERIES I though).
+		 */
+
+		if (z->id == ZORRO_PROD_GVP_COMBO_030_R3_SCSI ||
+		    z->id == ZORRO_PROD_GVP_SERIES_II)
+			default_dma_xfer_mask = ~0x00ffffff;
+		else if (z->id == ZORRO_PROD_GVP_GFORCE_030_SCSI ||
+			 z->id == ZORRO_PROD_GVP_A530_SCSI ||
+			 z->id == ZORRO_PROD_GVP_COMBO_030_R4_SCSI)
+			default_dma_xfer_mask = ~0x01ffffff;
+		else if (z->id == ZORRO_PROD_GVP_A1291 ||
+			 z->id == ZORRO_PROD_GVP_GFORCE_040_SCSI_1)
+			default_dma_xfer_mask = ~0x07ffffff;
+		else
+			continue;
+
+		/*
+		 * Rumors state that some GVP ram boards use the same product
+		 * code as the SCSI controllers. Therefore if the board-size
+		 * is not 64KB we asume it is a ram board and bail out.
+		 */
+		if (z->resource.end - z->resource.start != 0xffff)
+			continue;
+
+		address = z->resource.start;
+		if (!request_mem_region(address, 256, "wd33c93"))
+			continue;
 
 #ifdef CHECK_WD33C93
 
-	/*
-	 * These darn GVP boards are a problem - it can be tough to tell
-	 * whether or not they include a SCSI controller. This is the
-	 * ultimate Yet-Another-GVP-Detection-Hack in that it actually
-	 * probes for a WD33c93 chip: If we find one, it's extremely
-	 * likely that this card supports SCSI, regardless of Product_
-	 * Code, Board_Size, etc. 
-	 */
-
-    /* Get pointers to the presumed register locations and save contents */
-
-	sasr_3393 = &(((gvp11_scsiregs *)(ZTWO_VADDR(address)))->SASR);
-	scmd_3393 = &(((gvp11_scsiregs *)(ZTWO_VADDR(address)))->SCMD);
-	save_sasr = *sasr_3393;
-
-    /* First test the AuxStatus Reg */
-
-	q = *sasr_3393;		/* read it */
-	if (q & 0x08)		/* bit 3 should always be clear */
-		goto release;
-	*sasr_3393 = WD_AUXILIARY_STATUS;	 /* setup indirect address */
-	if (*sasr_3393 == WD_AUXILIARY_STATUS) { /* shouldn't retain the write */
-		*sasr_3393 = save_sasr;	/* Oops - restore this byte */
-		goto release;
+		/*
+		 * These darn GVP boards are a problem - it can be tough to tell
+		 * whether or not they include a SCSI controller. This is the
+		 * ultimate Yet-Another-GVP-Detection-Hack in that it actually
+		 * probes for a WD33c93 chip: If we find one, it's extremely
+		 * likely that this card supports SCSI, regardless of Product_
+		 * Code, Board_Size, etc.
+		 */
+
+		/* Get pointers to the presumed register locations and save contents */
+
+		sasr_3393 = &(((gvp11_scsiregs *)(ZTWO_VADDR(address)))->SASR);
+		scmd_3393 = &(((gvp11_scsiregs *)(ZTWO_VADDR(address)))->SCMD);
+		save_sasr = *sasr_3393;
+
+		/* First test the AuxStatus Reg */
+
+		q = *sasr_3393;	/* read it */
+		if (q & 0x08)	/* bit 3 should always be clear */
+			goto release;
+		*sasr_3393 = WD_AUXILIARY_STATUS;	/* setup indirect address */
+		if (*sasr_3393 == WD_AUXILIARY_STATUS) {	/* shouldn't retain the write */
+			*sasr_3393 = save_sasr;	/* Oops - restore this byte */
+			goto release;
 		}
-	if (*sasr_3393 != q) {	/* should still read the same */
-		*sasr_3393 = save_sasr;	/* Oops - restore this byte */
-		goto release;
+		if (*sasr_3393 != q) {	/* should still read the same */
+			*sasr_3393 = save_sasr;	/* Oops - restore this byte */
+			goto release;
 		}
-	if (*scmd_3393 != q)	/* and so should the image at 0x1f */
-		goto release;
-
-
-    /* Ok, we probably have a wd33c93, but let's check a few other places
-     * for good measure. Make sure that this works for both 'A and 'B    
-     * chip versions.
-     */
-
-	*sasr_3393 = WD_SCSI_STATUS;
-	q = *scmd_3393;
-	*sasr_3393 = WD_SCSI_STATUS;
-	*scmd_3393 = ~q;
-	*sasr_3393 = WD_SCSI_STATUS;
-	qq = *scmd_3393;
-	*sasr_3393 = WD_SCSI_STATUS;
-	*scmd_3393 = q;
-	if (qq != q)			/* should be read only */
-		goto release;
-	*sasr_3393 = 0x1e;	/* this register is unimplemented */
-	q = *scmd_3393;
-	*sasr_3393 = 0x1e;
-	*scmd_3393 = ~q;
-	*sasr_3393 = 0x1e;
-	qq = *scmd_3393;
-	*sasr_3393 = 0x1e;
-	*scmd_3393 = q;
-	if (qq != q || qq != 0xff)	/* should be read only, all 1's */
-		goto release;
-	*sasr_3393 = WD_TIMEOUT_PERIOD;
-	q = *scmd_3393;
-	*sasr_3393 = WD_TIMEOUT_PERIOD;
-	*scmd_3393 = ~q;
-	*sasr_3393 = WD_TIMEOUT_PERIOD;
-	qq = *scmd_3393;
-	*sasr_3393 = WD_TIMEOUT_PERIOD;
-	*scmd_3393 = q;
-	if (qq != (~q & 0xff))		/* should be read/write */
-		goto release;
+		if (*scmd_3393 != q)	/* and so should the image at 0x1f */
+			goto release;
+
+		/*
+		 * Ok, we probably have a wd33c93, but let's check a few other places
+		 * for good measure. Make sure that this works for both 'A and 'B
+		 * chip versions.
+		 */
+
+		*sasr_3393 = WD_SCSI_STATUS;
+		q = *scmd_3393;
+		*sasr_3393 = WD_SCSI_STATUS;
+		*scmd_3393 = ~q;
+		*sasr_3393 = WD_SCSI_STATUS;
+		qq = *scmd_3393;
+		*sasr_3393 = WD_SCSI_STATUS;
+		*scmd_3393 = q;
+		if (qq != q)	/* should be read only */
+			goto release;
+		*sasr_3393 = 0x1e;	/* this register is unimplemented */
+		q = *scmd_3393;
+		*sasr_3393 = 0x1e;
+		*scmd_3393 = ~q;
+		*sasr_3393 = 0x1e;
+		qq = *scmd_3393;
+		*sasr_3393 = 0x1e;
+		*scmd_3393 = q;
+		if (qq != q || qq != 0xff)	/* should be read only, all 1's */
+			goto release;
+		*sasr_3393 = WD_TIMEOUT_PERIOD;
+		q = *scmd_3393;
+		*sasr_3393 = WD_TIMEOUT_PERIOD;
+		*scmd_3393 = ~q;
+		*sasr_3393 = WD_TIMEOUT_PERIOD;
+		qq = *scmd_3393;
+		*sasr_3393 = WD_TIMEOUT_PERIOD;
+		*scmd_3393 = q;
+		if (qq != (~q & 0xff))	/* should be read/write */
+			goto release;
 #endif
 
-	instance = scsi_register (tpnt, sizeof (struct WD33C93_hostdata));
-	if(instance == NULL)
-		goto release;
-	instance->base = ZTWO_VADDR(address);
-	instance->irq = IRQ_AMIGA_PORTS;
-	instance->unique_id = z->slotaddr;
-
-	if (gvp11_xfer_mask)
-		HDATA(instance)->dma_xfer_mask = gvp11_xfer_mask;
-	else
-		HDATA(instance)->dma_xfer_mask = default_dma_xfer_mask;
-
-
-	DMA(instance)->secret2 = 1;
-	DMA(instance)->secret1 = 0;
-	DMA(instance)->secret3 = 15;
-	while (DMA(instance)->CNTR & GVP11_DMAC_BUSY) ;
-	DMA(instance)->CNTR = 0;
-
-	DMA(instance)->BANK = 0;
-
-	epc = *(unsigned short *)(ZTWO_VADDR(address) + 0x8000);
-
-	/*
-	 * Check for 14MHz SCSI clock
-	 */
-	regs.SASR = &(DMA(instance)->SASR);
-	regs.SCMD = &(DMA(instance)->SCMD);
-	HDATA(instance)->no_sync = 0xff;
-	HDATA(instance)->fast = 0;
-	HDATA(instance)->dma_mode = CTRL_DMA;
-	wd33c93_init(instance, regs, dma_setup, dma_stop,
-		     (epc & GVP_SCSICLKMASK) ? WD33C93_FS_8_10
-					     : WD33C93_FS_12_15);
-
-	if (request_irq(IRQ_AMIGA_PORTS, gvp11_intr, IRQF_SHARED, "GVP11 SCSI",
-			instance))
-		goto unregister;
-	DMA(instance)->CNTR = GVP11_DMAC_INT_ENABLE;
-	num_gvp11++;
-	continue;
+		instance = scsi_register(tpnt, sizeof(struct WD33C93_hostdata));
+		if (instance == NULL)
+			goto release;
+		instance->base = ZTWO_VADDR(address);
+		instance->irq = IRQ_AMIGA_PORTS;
+		instance->unique_id = z->slotaddr;
+
+		if (gvp11_xfer_mask)
+			HDATA(instance)->dma_xfer_mask = gvp11_xfer_mask;
+		else
+			HDATA(instance)->dma_xfer_mask = default_dma_xfer_mask;
+
+		DMA(instance)->secret2 = 1;
+		DMA(instance)->secret1 = 0;
+		DMA(instance)->secret3 = 15;
+		while (DMA(instance)->CNTR & GVP11_DMAC_BUSY)
+			;
+		DMA(instance)->CNTR = 0;
+
+		DMA(instance)->BANK = 0;
+
+		epc = *(unsigned short *)(ZTWO_VADDR(address) + 0x8000);
+
+		/*
+		 * Check for 14MHz SCSI clock
+		 */
+		regs.SASR = &(DMA(instance)->SASR);
+		regs.SCMD = &(DMA(instance)->SCMD);
+		HDATA(instance)->no_sync = 0xff;
+		HDATA(instance)->fast = 0;
+		HDATA(instance)->dma_mode = CTRL_DMA;
+		wd33c93_init(instance, regs, dma_setup, dma_stop,
+			     (epc & GVP_SCSICLKMASK) ? WD33C93_FS_8_10
+						     : WD33C93_FS_12_15);
+
+		if (request_irq(IRQ_AMIGA_PORTS, gvp11_intr, IRQF_SHARED,
+				"GVP11 SCSI", instance))
+			goto unregister;
+		DMA(instance)->CNTR = GVP11_DMAC_INT_ENABLE;
+		num_gvp11++;
+		continue;
 
 unregister:
-	scsi_unregister(instance);
+		scsi_unregister(instance);
 release:
-	release_mem_region(address, 256);
-    }
+		release_mem_region(address, 256);
+	}
 
-    return num_gvp11;
+	return num_gvp11;
 }
 
 static int gvp11_bus_reset(struct scsi_cmnd *cmd)
@@ -387,11 +391,11 @@ static struct scsi_host_template driver_template = {
 int gvp11_release(struct Scsi_Host *instance)
 {
 #ifdef MODULE
-    DMA(instance)->CNTR = 0;
-    release_mem_region(ZTWO_PADDR(instance->base), 256);
-    free_irq(IRQ_AMIGA_PORTS, instance);
+	DMA(instance)->CNTR = 0;
+	release_mem_region(ZTWO_PADDR(instance->base), 256);
+	free_irq(IRQ_AMIGA_PORTS, instance);
 #endif
-    return 1;
+	return 1;
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/gvp11.h b/drivers/scsi/gvp11.h
index bf22859..e2efdf9 100644
--- a/drivers/scsi/gvp11.h
+++ b/drivers/scsi/gvp11.h
@@ -15,11 +15,11 @@ int gvp11_detect(struct scsi_host_template *);
 int gvp11_release(struct Scsi_Host *);
 
 #ifndef CMD_PER_LUN
-#define CMD_PER_LUN 2
+#define CMD_PER_LUN		2
 #endif
 
 #ifndef CAN_QUEUE
-#define CAN_QUEUE 16
+#define CAN_QUEUE		16
 #endif
 
 #ifndef HOSTS_C
@@ -28,24 +28,24 @@ int gvp11_release(struct Scsi_Host *);
  * if the transfer address ANDed with this results in a non-zero
  * result, then we can't use DMA.
  */
-#define GVP11_XFER_MASK  (0xff000001)
+#define GVP11_XFER_MASK		(0xff000001)
 
 typedef struct {
-             unsigned char      pad1[64];
-    volatile unsigned short     CNTR;
-             unsigned char      pad2[31];
-    volatile unsigned char      SASR;
-             unsigned char      pad3;
-    volatile unsigned char      SCMD;
-             unsigned char      pad4[4];
-    volatile unsigned short     BANK;
-             unsigned char      pad5[6];
-    volatile unsigned long      ACR;
-    volatile unsigned short     secret1; /* store 0 here */
-    volatile unsigned short     ST_DMA;
-    volatile unsigned short     SP_DMA;
-    volatile unsigned short     secret2; /* store 1 here */
-    volatile unsigned short     secret3; /* store 15 here */
+		 unsigned char	pad1[64];
+	volatile unsigned short	CNTR;
+		 unsigned char	pad2[31];
+	volatile unsigned char	SASR;
+		 unsigned char	pad3;
+	volatile unsigned char	SCMD;
+		 unsigned char	pad4[4];
+	volatile unsigned short	BANK;
+		 unsigned char	pad5[6];
+	volatile unsigned long	ACR;
+	volatile unsigned short	secret1; /* store 0 here */
+	volatile unsigned short	ST_DMA;
+	volatile unsigned short	SP_DMA;
+	volatile unsigned short	secret2; /* store 1 here */
+	volatile unsigned short	secret3; /* store 15 here */
 } gvp11_scsiregs;
 
 /* bits in CNTR */
-- 
1.6.0.4
