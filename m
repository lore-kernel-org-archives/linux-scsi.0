From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 25/37] sun3_scsi: Convert to platform device
Date: Thu, 13 Nov 2014 12:21:28 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1411131120140.15724@nippy.intranet>
References: <20141112051146.525489687@telegraphics.com.au> <20141112051152.395473503@telegraphics.com.au> <CAMuHMdVtKc782AfiC0g0+tNn-uGCOig88vHsFx3yEj3dz2=U1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdVtKc782AfiC0g0+tNn-uGCOig88vHsFx3yEj3dz2=U1A@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert sun3_scsi to platform device and eliminate scsi_register().

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

---

Changes since v1:
- Use NO_IRQ instead of IRQ_NONE.
- Move device IRQ and address constants to platform resources.
- Test idprom->id_machtype before registering platform device instead of
  during platform driver probe.
- Omit pointless instance->n_io_port assignment.

Changes since v2:
- Give more precise addresses in platform resource initializers and
  move PAGE_SIZE back to ioremap() arguments.

Changes since v3:
- Use resource_size() in ioremap() arguments instead of PAGE_SIZE.

---
 arch/m68k/sun3/config.c  |   60 +++++++
 drivers/scsi/sun3_scsi.c |  390 ++++++++++++++++++++++-------------------------
 drivers/scsi/sun3_scsi.h |   17 --
 3 files changed, 245 insertions(+), 222 deletions(-)

Index: linux/arch/m68k/sun3/config.c
===================================================================
--- linux.orig/arch/m68k/sun3/config.c	2014-11-13 11:19:22.000000000 +1100
+++ linux/arch/m68k/sun3/config.c	2014-11-13 11:20:10.000000000 +1100
@@ -16,6 +16,7 @@
 #include <linux/console.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
+#include <linux/platform_device.h>
 
 #include <asm/oplib.h>
 #include <asm/setup.h>
@@ -27,6 +28,7 @@
 #include <asm/sun3mmu.h>
 #include <asm/rtc.h>
 #include <asm/machdep.h>
+#include <asm/machines.h>
 #include <asm/idprom.h>
 #include <asm/intersil.h>
 #include <asm/irq.h>
@@ -169,3 +171,61 @@ static void __init sun3_sched_init(irq_h
         intersil_clear();
 }
 
+#ifdef CONFIG_SUN3_SCSI
+
+static const struct resource sun3_scsi_vme_rsrc[] __initconst = {
+	{
+		.flags = IORESOURCE_IRQ,
+		.start = SUN3_VEC_VMESCSI0,
+		.end   = SUN3_VEC_VMESCSI0,
+	}, {
+		.flags = IORESOURCE_MEM,
+		.start = 0xff200000,
+		.end   = 0xff200021,
+	}, {
+		.flags = IORESOURCE_IRQ,
+		.start = SUN3_VEC_VMESCSI1,
+		.end   = SUN3_VEC_VMESCSI1,
+	}, {
+		.flags = IORESOURCE_MEM,
+		.start = 0xff204000,
+		.end   = 0xff204021,
+	},
+};
+
+/*
+ * Int: level 2 autovector
+ * IO: type 1, base 0x00140000, 5 bits phys space: A<4..0>
+ */
+static const struct resource sun3_scsi_rsrc[] __initconst = {
+	{
+		.flags = IORESOURCE_IRQ,
+		.start = 2,
+		.end   = 2,
+	}, {
+		.flags = IORESOURCE_MEM,
+		.start = 0x00140000,
+		.end   = 0x0014001f,
+	},
+};
+
+int __init sun3_platform_init(void)
+{
+	switch (idprom->id_machtype) {
+	case SM_SUN3 | SM_3_160:
+	case SM_SUN3 | SM_3_260:
+		platform_device_register_simple("sun3_scsi_vme", -1,
+			sun3_scsi_vme_rsrc, ARRAY_SIZE(sun3_scsi_vme_rsrc));
+		break;
+	case SM_SUN3 | SM_3_50:
+	case SM_SUN3 | SM_3_60:
+		platform_device_register_simple("sun3_scsi", -1,
+			sun3_scsi_rsrc, ARRAY_SIZE(sun3_scsi_rsrc));
+		break;
+	}
+	return 0;
+}
+
+arch_initcall(sun3_platform_init);
+
+#endif
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-11-13 11:19:57.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-11-13 11:20:10.000000000 +1100
@@ -23,22 +23,15 @@
  */
 
 #include <linux/types.h>
-#include <linux/stddef.h>
-#include <linux/ctype.h>
 #include <linux/delay.h>
-
 #include <linux/module.h>
-#include <linux/signal.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
+#include <linux/platform_device.h>
 
 #include <asm/io.h>
-
-#include <asm/sun3ints.h>
 #include <asm/dvma.h>
-#include <asm/idprom.h>
-#include <asm/machines.h>
 
 /* dma on! */
 #define REAL_DMA
@@ -59,8 +52,6 @@ extern int sun3_map_test(unsigned long,
 #endif
 
 
-static irqreturn_t scsi_sun3_intr(int irq, void *dummy);
-
 static int setup_can_queue = -1;
 module_param(setup_can_queue, int, 0);
 static int setup_cmd_per_lun = -1;
@@ -89,15 +80,14 @@ static struct scsi_cmnd *sun3_dma_setup_
 /* minimum number of bytes to do dma on */
 #define SUN3_DMA_MINSIZE 128
 
-static volatile unsigned char *sun3_scsi_regp;
+static unsigned char *sun3_scsi_regp;
 static volatile struct sun3_dma_regs *dregs;
-#ifndef SUN3_SCSI_VME
-static struct sun3_udc_regs *udc_regs = NULL;
-#endif
+static struct sun3_udc_regs *udc_regs;
 static unsigned char *sun3_dma_orig_addr = NULL;
 static unsigned long sun3_dma_orig_count = 0;
 static int sun3_dma_active = 0;
 static unsigned long last_residual = 0;
+static struct Scsi_Host *default_instance;
 
 /*
  * NCR 5380 register access functions
@@ -105,12 +95,12 @@ static unsigned long last_residual = 0;
 
 static inline unsigned char sun3scsi_read(int reg)
 {
-	return( sun3_scsi_regp[reg] );
+	return in_8(sun3_scsi_regp + reg);
 }
 
 static inline void sun3scsi_write(int reg, int value)
 {
-	sun3_scsi_regp[reg] = value;
+	out_8(sun3_scsi_regp + reg, value);
 }
 
 #ifndef SUN3_SCSI_VME
@@ -137,192 +127,7 @@ static inline void sun3_udc_write(unsign
 }
 #endif
 
-/*
- * XXX: status debug
- */
-static struct Scsi_Host *default_instance;
-
-/*
- * Function : int sun3scsi_detect(struct scsi_host_template * tpnt)
- *
- * Purpose : initializes mac NCR5380 driver based on the
- *	command line / compile time port and irq definitions.
- *
- * Inputs : tpnt - template for this SCSI adapter.
- *
- * Returns : 1 if a host adapter was found, 0 if not.
- *
- */
- 
-static int __init sun3scsi_detect(struct scsi_host_template *tpnt)
-{
-	unsigned long ioaddr, irq;
-	static int called = 0;
-	struct Scsi_Host *instance;
-#ifdef SUN3_SCSI_VME
-	int i;
-	unsigned long addrs[3] = { IOBASE_SUN3_VMESCSI,
-				   IOBASE_SUN3_VMESCSI + 0x4000,
-				   0 };
-	unsigned long vecs[3] = { SUN3_VEC_VMESCSI0,
-				  SUN3_VEC_VMESCSI1,
-				  0 };
-#endif
-
-	/* check that this machine has an onboard 5380 */
-	switch(idprom->id_machtype) {
-#ifdef SUN3_SCSI_VME
-	case SM_SUN3|SM_3_160:
-	case SM_SUN3|SM_3_260:
-		break;
-#else
-	case SM_SUN3|SM_3_50:
-	case SM_SUN3|SM_3_60:
-		break;
-#endif
-
-	default:
-		return 0;
-	}
-
-	if(called)
-		return 0;
-
-#ifdef SUN3_SCSI_VME
-	tpnt->proc_name = "Sun3 5380 VME SCSI";
-#else
-	tpnt->proc_name = "Sun3 5380 SCSI";
-#endif
-
-	/* setup variables */
-	if (setup_can_queue > 0)
-		tpnt->can_queue = setup_can_queue;
-	if (setup_cmd_per_lun > 0)
-		tpnt->cmd_per_lun = setup_cmd_per_lun;
-	if (setup_sg_tablesize >= 0)
-		tpnt->sg_tablesize = setup_sg_tablesize;
-
-	if (setup_hostid >= 0)
-		tpnt->this_id = setup_hostid;
-	else {
-		/* use 7 as default */
-		tpnt->this_id = 7;
-	}
-
-#ifdef SUN3_SCSI_VME
-	ioaddr = 0;
-	for (i = 0; addrs[i] != 0; i++) {
-		unsigned char x;
-
-		ioaddr = (unsigned long)sun3_ioremap(addrs[i], PAGE_SIZE,
-						     SUN3_PAGE_TYPE_VME16);
-		irq = vecs[i];
-		sun3_scsi_regp = (unsigned char *)ioaddr;
-
-		dregs = (struct sun3_dma_regs *)(((unsigned char *)ioaddr) + 8);
-
-		if (sun3_map_test((unsigned long)dregs, &x)) {
-			unsigned short oldcsr;
-
-			oldcsr = dregs->csr;
-			dregs->csr = 0;
-			udelay(SUN3_DMA_DELAY);
-			if (dregs->csr == 0x1400)
-				break;
-
-			dregs->csr = oldcsr;
-		}
-
-		iounmap((void *)ioaddr);
-		ioaddr = 0;
-	}
-
-	if (!ioaddr)
-		return 0;
-#else
-	irq = IRQ_SUN3_SCSI;
-	ioaddr = (unsigned long)ioremap(IOBASE_SUN3_SCSI, PAGE_SIZE);
-	sun3_scsi_regp = (unsigned char *)ioaddr;
-
-	dregs = (struct sun3_dma_regs *)(((unsigned char *)ioaddr) + 8);
-
-	if((udc_regs = dvma_malloc(sizeof(struct sun3_udc_regs)))
-	   == NULL) {
-	     printk("SUN3 Scsi couldn't allocate DVMA memory!\n");
-	     return 0;
-	}
-#endif
-#ifdef SUPPORT_TAGS
-	if (setup_use_tagged_queuing < 0)
-		setup_use_tagged_queuing = 1;
-#endif
-
-	instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
-	if(instance == NULL)
-		return 0;
-		
-	default_instance = instance;
-
-        instance->io_port = (unsigned long) ioaddr;
-	instance->irq = irq;
-
-	NCR5380_init(instance, 0);
-
-	instance->n_io_port = 32;
-
-	if (request_irq(instance->irq, scsi_sun3_intr,
-			     0, "Sun3SCSI-5380", instance)) {
-#ifndef REAL_DMA
-		printk("scsi%d: IRQ%d not free, interrupts disabled\n",
-		       instance->host_no, instance->irq);
-		instance->irq = NO_IRQ;
-#else
-		printk("scsi%d: IRQ%d not free, bailing out\n",
-		       instance->host_no, instance->irq);
-		return 0;
-#endif
-	}
-	
-	dregs->csr = 0;
-	udelay(SUN3_DMA_DELAY);
-	dregs->csr = CSR_SCSI | CSR_FIFO | CSR_INTR;
-	udelay(SUN3_DMA_DELAY);
-	dregs->fifo_count = 0;
-#ifdef SUN3_SCSI_VME
-	dregs->fifo_count_hi = 0;
-	dregs->dma_addr_hi = 0;
-	dregs->dma_addr_lo = 0;
-	dregs->dma_count_hi = 0;
-	dregs->dma_count_lo = 0;
-
-	dregs->ivect = VME_DATA24 | (instance->irq & 0xff);
-#endif
-
-	called = 1;
-
-#ifdef RESET_BOOT
-	sun3_scsi_reset_boot(instance);
-#endif
-
-	return 1;
-}
-
-static int sun3scsi_release(struct Scsi_Host *shpnt)
-{
-	if (shpnt->irq != NO_IRQ)
-		free_irq(shpnt->irq, shpnt);
-
-	iounmap((void *)sun3_scsi_regp);
-
-	NCR5380_exit(shpnt);
-	return 0;
-}
-
 #ifdef RESET_BOOT
-/*
- * Our 'bus reset on boot' function
- */
-
 static void sun3_scsi_reset_boot(struct Scsi_Host *instance)
 {
 	unsigned long end;
@@ -671,11 +476,21 @@ static int sun3scsi_dma_finish(int write
 	
 #include "sun3_NCR5380.c"
 
-static struct scsi_host_template driver_template = {
+#ifdef SUN3_SCSI_VME
+#define SUN3_SCSI_NAME          "Sun3 NCR5380 VME SCSI"
+#define DRV_MODULE_NAME         "sun3_scsi_vme"
+#else
+#define SUN3_SCSI_NAME          "Sun3 NCR5380 SCSI"
+#define DRV_MODULE_NAME         "sun3_scsi"
+#endif
+
+#define PFX                     DRV_MODULE_NAME ": "
+
+static struct scsi_host_template sun3_scsi_template = {
+	.module			= THIS_MODULE,
+	.proc_name		= DRV_MODULE_NAME,
 	.show_info		= sun3scsi_show_info,
 	.name			= SUN3_SCSI_NAME,
-	.detect			= sun3scsi_detect,
-	.release		= sun3scsi_release,
 	.info			= sun3scsi_info,
 	.queuecommand		= sun3scsi_queue_command,
 	.eh_abort_handler      	= sun3scsi_abort,
@@ -687,7 +502,172 @@ static struct scsi_host_template driver_
 	.use_clustering		= DISABLE_CLUSTERING
 };
 
+static int __init sun3_scsi_probe(struct platform_device *pdev)
+{
+	struct Scsi_Host *instance;
+	int error;
+	struct resource *irq, *mem;
+	unsigned char *ioaddr;
+#ifdef SUN3_SCSI_VME
+	int i;
+#endif
+
+	if (setup_can_queue > 0)
+		sun3_scsi_template.can_queue = setup_can_queue;
+	if (setup_cmd_per_lun > 0)
+		sun3_scsi_template.cmd_per_lun = setup_cmd_per_lun;
+	if (setup_sg_tablesize >= 0)
+		sun3_scsi_template.sg_tablesize = setup_sg_tablesize;
+	if (setup_hostid >= 0)
+		sun3_scsi_template.this_id = setup_hostid & 7;
+
+#ifdef SUPPORT_TAGS
+	if (setup_use_tagged_queuing < 0)
+		setup_use_tagged_queuing = 1;
+#endif
+
+#ifdef SUN3_SCSI_VME
+	ioaddr = NULL;
+	for (i = 0; i < 2; i++) {
+		unsigned char x;
+
+		irq = platform_get_resource(pdev, IORESOURCE_IRQ, i);
+		mem = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!irq || !mem)
+			break;
+
+		ioaddr = sun3_ioremap(mem->start, resource_size(mem),
+		                      SUN3_PAGE_TYPE_VME16);
+		dregs = (struct sun3_dma_regs *)(ioaddr + 8);
+
+		if (sun3_map_test((unsigned long)dregs, &x)) {
+			unsigned short oldcsr;
+
+			oldcsr = dregs->csr;
+			dregs->csr = 0;
+			udelay(SUN3_DMA_DELAY);
+			if (dregs->csr == 0x1400)
+				break;
+
+			dregs->csr = oldcsr;
+		}
+
+		iounmap(ioaddr);
+		ioaddr = NULL;
+	}
+	if (!ioaddr)
+		return -ENODEV;
+#else
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!irq || !mem)
+		return -ENODEV;
+
+	ioaddr = ioremap(mem->start, resource_size(mem));
+	dregs = (struct sun3_dma_regs *)(ioaddr + 8);
+
+	udc_regs = dvma_malloc(sizeof(struct sun3_udc_regs));
+	if (!udc_regs) {
+		pr_err(PFX "couldn't allocate DVMA memory!\n");
+		iounmap(ioaddr);
+		return -ENOMEM;
+	}
+#endif
+
+	sun3_scsi_regp = ioaddr;
+
+	instance = scsi_host_alloc(&sun3_scsi_template,
+	                           sizeof(struct NCR5380_hostdata));
+	if (!instance) {
+		error = -ENOMEM;
+		goto fail_alloc;
+	}
+	default_instance = instance;
+
+	instance->io_port = (unsigned long)ioaddr;
+	instance->irq = irq->start;
+
+	NCR5380_init(instance, 0);
+
+	error = request_irq(instance->irq, scsi_sun3_intr, 0,
+	                    "NCR5380", instance);
+	if (error) {
+#ifdef REAL_DMA
+		pr_err(PFX "scsi%d: IRQ %d not free, bailing out\n",
+		       instance->host_no, instance->irq);
+		goto fail_irq;
+#else
+		pr_warn(PFX "scsi%d: IRQ %d not free, interrupts disabled\n",
+		        instance->host_no, instance->irq);
+		instance->irq = NO_IRQ;
+#endif
+	}
+
+	dregs->csr = 0;
+	udelay(SUN3_DMA_DELAY);
+	dregs->csr = CSR_SCSI | CSR_FIFO | CSR_INTR;
+	udelay(SUN3_DMA_DELAY);
+	dregs->fifo_count = 0;
+#ifdef SUN3_SCSI_VME
+	dregs->fifo_count_hi = 0;
+	dregs->dma_addr_hi = 0;
+	dregs->dma_addr_lo = 0;
+	dregs->dma_count_hi = 0;
+	dregs->dma_count_lo = 0;
+
+	dregs->ivect = VME_DATA24 | (instance->irq & 0xff);
+#endif
+
+#ifdef RESET_BOOT
+	sun3_scsi_reset_boot(instance);
+#endif
+
+	error = scsi_add_host(instance, NULL);
+	if (error)
+		goto fail_host;
+
+	platform_set_drvdata(pdev, instance);
+
+	scsi_scan_host(instance);
+	return 0;
+
+fail_host:
+	if (instance->irq != NO_IRQ)
+		free_irq(instance->irq, instance);
+fail_irq:
+	NCR5380_exit(instance);
+	scsi_host_put(instance);
+fail_alloc:
+	if (udc_regs)
+		dvma_free(udc_regs);
+	iounmap(sun3_scsi_regp);
+	return error;
+}
+
+static int __exit sun3_scsi_remove(struct platform_device *pdev)
+{
+	struct Scsi_Host *instance = platform_get_drvdata(pdev);
+
+	scsi_remove_host(instance);
+	if (instance->irq != NO_IRQ)
+		free_irq(instance->irq, instance);
+	NCR5380_exit(instance);
+	scsi_host_put(instance);
+	if (udc_regs)
+		dvma_free(udc_regs);
+	iounmap(sun3_scsi_regp);
+	return 0;
+}
+
+static struct platform_driver sun3_scsi_driver = {
+	.remove = __exit_p(sun3_scsi_remove),
+	.driver = {
+		.name	= DRV_MODULE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
 
-#include "scsi_module.c"
+module_platform_driver_probe(sun3_scsi_driver, sun3_scsi_probe);
 
+MODULE_ALIAS("platform:" DRV_MODULE_NAME);
 MODULE_LICENSE("GPL");
Index: linux/drivers/scsi/sun3_scsi.h
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.h	2014-11-13 11:19:54.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.h	2014-11-13 11:20:10.000000000 +1100
@@ -18,25 +18,8 @@
 #ifndef SUN3_SCSI_H
 #define SUN3_SCSI_H
 
-/*
- * Int: level 2 autovector
- * IO: type 1, base 0x00140000, 5 bits phys space: A<4..0>
- */
-#define IRQ_SUN3_SCSI 2
-#define IOBASE_SUN3_SCSI 0x00140000
-
-#define IOBASE_SUN3_VMESCSI 0xff200000
-
 #define MAX_TAGS 32
 
-#include <scsi/scsicam.h>
-
-#ifdef SUN3_SCSI_VME
-#define SUN3_SCSI_NAME "Sun3 NCR5380 VME SCSI"
-#else
-#define SUN3_SCSI_NAME "Sun3 NCR5380 SCSI"
-#endif
-
 #define NCR5380_implementation_fields /* none */
 
 #define NCR5380_local_declare() \
