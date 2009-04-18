From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC 07/16] m68k: amiga - A3000 SCSI platform device conversion
Date: Sat, 18 Apr 2009 20:52:15 +0200
Message-ID: <1240080744-14995-8-git-send-email-geert@linux-m68k.org>
References: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-2-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-3-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-4-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-5-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-6-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-7-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1240080744-14995-7-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-scsi@vger.kernel.org
---
 arch/m68k/amiga/platform.c |   11 ++
 drivers/scsi/a3000.c       |  373 ++++++++++++++++++++++++-------------------
 2 files changed, 219 insertions(+), 165 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 38f18bf..df1fae3 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -58,6 +58,13 @@ subsys_initcall(amiga_init_bus);
 #endif /* CONFIG_ZORRO */
 
 
+static const struct resource a3000_scsi_resource __initconst = {
+	.start	= 0xdd0000,
+	.end	= 0xdd00ff,
+	.flags	= IORESOURCE_MEM,
+};
+
+
 static int __init amiga_init_devices(void)
 {
 	if (!MACH_IS_AMIGA)
@@ -77,6 +84,10 @@ static int __init amiga_init_devices(void)
 	if (AMIGAHW_PRESENT(AMI_FLOPPY))
 		platform_device_register_simple("amiga-floppy", -1, NULL, 0);
 
+	if (AMIGAHW_PRESENT(A3000_SCSI))
+		platform_device_register_simple("amiga-a3000-scsi", -1,
+						&a3000_scsi_resource, 1);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 6970ce8..73bf9ff 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -1,202 +1,157 @@
 #include <linux/types.h>
 #include <linux/mm.h>
-#include <linux/blkdev.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
 
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
-#include <asm/irq.h>
 
 #include "scsi.h"
-#include <scsi/scsi_host.h>
 #include "wd33c93.h"
 #include "a3000.h"
 
-#include<linux/stat.h>
 
-#define DMA(ptr) ((a3000_scsiregs *)((ptr)->base))
-#define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
-
-static struct Scsi_Host *a3000_host = NULL;
-
-static int a3000_release(struct Scsi_Host *instance);
-
-static irqreturn_t a3000_intr (int irq, void *dummy)
+static irqreturn_t a3000_intr(int irq, void *data)
 {
+	struct Scsi_Host *host = data;
 	unsigned long flags;
-	unsigned int status = DMA(a3000_host)->ISTR;
+	a3000_scsiregs *regs = (a3000_scsiregs *)(host->base);
+	unsigned int status = regs->ISTR;
 
 	if (!(status & ISTR_INT_P))
 		return IRQ_NONE;
-	if (status & ISTR_INTS)
-	{
-		spin_lock_irqsave(a3000_host->host_lock, flags);
-		wd33c93_intr (a3000_host);
-		spin_unlock_irqrestore(a3000_host->host_lock, flags);
+	if (status & ISTR_INTS) {
+		spin_lock_irqsave(host->host_lock, flags);
+		wd33c93_intr(host);
+		spin_unlock_irqrestore(host->host_lock, flags);
 		return IRQ_HANDLED;
 	}
-	printk("Non-serviced A3000 SCSI-interrupt? ISTR = %02x\n", status);
+	pr_warning("Non-serviced A3000 SCSI-interrupt? ISTR = %02x\n", status);
 	return IRQ_NONE;
 }
 
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
+	struct Scsi_Host *host = cmd->device->host;
+	struct WD33C93_hostdata *hdata = shost_priv(host);
+	a3000_scsiregs *regs = (a3000_scsiregs *)(host->base);
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
+		hdata->dma_bounce_len = (cmd->SCp.this_residual + 511) & ~0x1ff;
+		hdata->dma_bounce_buffer = kmalloc(hdata->dma_bounce_len,
+						   GFP_KERNEL);
+
+		/* can't allocate memory; use PIO */
+		if (!hdata->dma_bounce_buffer) {
+			hdata->dma_bounce_len = 0;
+			return 1;
+		}
+
+		if (!dir_in) {
+			/* copy to bounce buffer for a write */
+			memcpy(hdata->dma_bounce_buffer, cmd->SCp.ptr,
+			       cmd->SCp.this_residual);
+		}
+
+		addr = virt_to_bus(hdata->dma_bounce_buffer);
 	}
 
-	addr = virt_to_bus(HDATA(a3000_host)->dma_bounce_buffer);
-    }
+	/* setup dma direction */
+	if (!dir_in)
+		cntr |= CNTR_DDIR;
 
-    /* setup dma direction */
-    if (!dir_in)
-	cntr |= CNTR_DDIR;
+	/* remember direction */
+	hdata->dma_dir = dir_in;
 
-    /* remember direction */
-    HDATA(a3000_host)->dma_dir = dir_in;
+	regs->CNTR = cntr;
 
-    DMA(a3000_host)->CNTR = cntr;
+	/* setup DMA *physical* address */
+	regs->ACR = addr;
 
-    /* setup DMA *physical* address */
-    DMA(a3000_host)->ACR = addr;
+	if (dir_in)
+		/* invalidate any cache */
+		cache_clear(addr, cmd->SCp.this_residual);
+	else
+		/* push any dirty cache */
+		cache_push(addr, cmd->SCp.this_residual);
 
-    if (dir_in)
-  	/* invalidate any cache */
-	cache_clear (addr, cmd->SCp.this_residual);
-    else
-	/* push any dirty cache */
-	cache_push (addr, cmd->SCp.this_residual);
+	/* start DMA */
+	mb();			/* make sure setup is completed */
+	regs->ST_DMA = 1;
+	mb();			/* make sure DMA has started before next IO */
 
-    /* start DMA */
-    mb();			/* make sure setup is completed */
-    DMA(a3000_host)->ST_DMA = 1;
-    mb();			/* make sure DMA has started before next IO */
-
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
-	}
-    }
-}
+	struct WD33C93_hostdata *hdata = shost_priv(instance);
+	a3000_scsiregs *regs = (a3000_scsiregs *)(instance->base);
 
-static int __init a3000_detect(struct scsi_host_template *tpnt)
-{
-    wd33c93_regs regs;
+	/* disable SCSI interrupts */
+	unsigned short cntr = CNTR_PDMD;
 
-    if  (!MACH_IS_AMIGA || !AMIGAHW_PRESENT(A3000_SCSI))
-	return 0;
-    if (!request_mem_region(0xDD0000, 256, "wd33c93"))
-	return 0;
+	if (!hdata->dma_dir)
+		cntr |= CNTR_DDIR;
 
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
+	regs->CNTR = cntr;
+	mb();			/* make sure CNTR is updated before next IO */
 
-fail_irq:
-    wd33c93_release();
-    scsi_unregister(a3000_host);
-fail_register:
-    release_mem_region(0xDD0000, 256);
-    return 0;
+	/* flush if we were reading */
+	if (hdata->dma_dir) {
+		regs->FLUSH = 1;
+		mb();			/* don't allow prefetch */
+		while (!(regs->ISTR & ISTR_FE_FLG))
+			barrier();
+		mb();			/* no IO until FLUSH is done */
+	}
+
+	/* clear a possible interrupt */
+	/* I think that this CINT is only necessary if you are
+	 * using the terminal count features.   HM 7 Mar 1994
+	 */
+	regs->CINT = 1;
+
+	/* stop DMA */
+	regs->SP_DMA = 1;
+	mb();			/* make sure DMA is stopped before next IO */
+
+	/* restore the CONTROL bits (minus the direction flag) */
+	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
+	mb();			/* make sure CNTR is updated before next IO */
+
+	/* copy from a bounce buffer, if necessary */
+	if (status && hdata->dma_bounce_buffer) {
+		if (SCpnt) {
+			if (hdata->dma_dir && SCpnt)
+				memcpy(SCpnt->SCp.ptr,
+				       hdata->dma_bounce_buffer,
+				       SCpnt->SCp.this_residual);
+			kfree(hdata->dma_bounce_buffer);
+			hdata->dma_bounce_buffer = NULL;
+			hdata->dma_bounce_len = 0;
+		} else {
+			kfree(hdata->dma_bounce_buffer);
+			hdata->dma_bounce_buffer = NULL;
+			hdata->dma_bounce_len = 0;
+		}
+	}
 }
 
 static int a3000_bus_reset(struct scsi_cmnd *cmd)
@@ -213,13 +168,11 @@ static int a3000_bus_reset(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }
 
-#define HOSTS_C
-
-static struct scsi_host_template driver_template = {
-	.proc_name		= "A3000",
+static struct scsi_host_template amiga_a3000_scsi_template = {
+	.module			= THIS_MODULE,
 	.name			= "Amiga 3000 built-in SCSI",
-	.detect			= a3000_detect,
-	.release		= a3000_release,
+	.proc_info		= wd33c93_proc_info,
+	.proc_name		= "A3000",
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
 	.eh_bus_reset_handler	= a3000_bus_reset,
@@ -231,16 +184,106 @@ static struct scsi_host_template driver_template = {
 	.use_clustering		= ENABLE_CLUSTERING
 };
 
+static int __init amiga_a3000_scsi_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct Scsi_Host *host;
+	struct WD33C93_hostdata *hdata;
+	int error;
+	wd33c93_regs wdregs;
+	a3000_scsiregs *regs;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	if (!request_mem_region(res->start, resource_size(res), "wd33c93"))
+		return -EBUSY;
+
+	host = scsi_host_alloc(&amiga_a3000_scsi_template,
+			       sizeof(struct WD33C93_hostdata));
+	if (!host) {
+		error = -ENOMEM;
+		goto fail_register;
+	}
+
+	host->base = ZTWO_VADDR(res->start);
+	host->irq = IRQ_AMIGA_PORTS;
 
-#include "scsi_module.c"
+	regs = (a3000_scsiregs *)(host->base);
+	regs->DAWR = DAWR_A3000;
 
-static int a3000_release(struct Scsi_Host *instance)
+	wdregs.SASR = &regs->SASR;
+	wdregs.SCMD = &regs->SCMD;
+
+	hdata = shost_priv(host);
+	hdata->no_sync = 0xff;
+	hdata->fast = 0;
+	hdata->dma_mode = CTRL_DMA;
+
+	wd33c93_init(host, wdregs, dma_setup, dma_stop, WD33C93_FS_12_15);
+	error = request_irq(IRQ_AMIGA_PORTS, a3000_intr, IRQF_SHARED,
+			    "A3000 SCSI", host);
+	if (error)
+		goto fail_irq;
+
+	regs->CNTR = CNTR_PDMD | CNTR_INTEN;
+
+	error = scsi_add_host(host, NULL);
+	if (error)
+		goto fail_host;
+
+	platform_set_drvdata(pdev, host);
+
+	scsi_scan_host(host);
+	return 0;
+
+fail_host:
+	free_irq(IRQ_AMIGA_PORTS, host);
+fail_irq:
+	scsi_host_put(host);
+fail_register:
+	release_mem_region(res->start, resource_size(res));
+	return error;
+}
+
+static int __exit amiga_a3000_scsi_remove(struct platform_device *pdev)
 {
-    wd33c93_release();
-    DMA(instance)->CNTR = 0;
-    release_mem_region(0xDD0000, 256);
-    free_irq(IRQ_AMIGA_PORTS, a3000_intr);
-    return 1;
+	struct Scsi_Host *host = platform_get_drvdata(pdev);
+	a3000_scsiregs *regs = (a3000_scsiregs *)(host->base);
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	regs->CNTR = 0;
+	scsi_remove_host(host);
+	free_irq(IRQ_AMIGA_PORTS, host);
+	scsi_host_put(host);
+	release_mem_region(res->start, resource_size(res));
+	return 0;
+}
+
+static struct platform_driver amiga_a3000_scsi_driver = {
+	.remove = __exit_p(amiga_a3000_scsi_remove),
+	.driver   = {
+		.name	= "amiga-a3000-scsi",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init amiga_a3000_scsi_init(void)
+{
+	return platform_driver_probe(&amiga_a3000_scsi_driver,
+				     amiga_a3000_scsi_probe);
 }
 
+module_init(amiga_a3000_scsi_init);
+
+static void __exit amiga_a3000_scsi_exit(void)
+{
+	platform_driver_unregister(&amiga_a3000_scsi_driver);
+}
+
+module_exit(amiga_a3000_scsi_exit);
+
+MODULE_DESCRIPTION("Amiga 3000 built-in SCSI");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:amiga-a3000-scsi");
-- 
1.6.2.3

