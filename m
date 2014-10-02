From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 21/29] mac_scsi: Convert to platform device
Date: Thu, 02 Oct 2014 16:56:49 +1000
Message-ID: <20141002065633.296184897@telegraphics.com.au>
References: <20141002065628.256592712@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=mac_scsi-convert-to-platform-device
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Convert mac_scsi to platform device and eliminate scsi_register().

Platform resources for chip registers now follow the documentation. This
should fix issues with the Mac IIci (and possibly other models too).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

The new hwreg_present() call is not protected by local_irq_save/restore.
This assumes Geert's patch, "Disable/restore interrupts in
hwreg_present()/hwreg_write()":
http://marc.info/?l=linux-kernel&m=141189640826704&w=2

---
 arch/m68k/include/asm/macintosh.h |    3 
 arch/m68k/mac/config.c            |  101 +++++++++++++--
 drivers/scsi/mac_scsi.c           |  248 +++++++++++++++++++-------------------
 3 files changed, 221 insertions(+), 131 deletions(-)

Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-10-02 16:56:18.000000000 +1000
+++ linux/drivers/scsi/mac_scsi.c	2014-10-02 16:56:19.000000000 +1000
@@ -12,23 +12,18 @@
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
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
 
+#include <asm/hwtest.h>
 #include <asm/io.h>
-#include <asm/irq.h>
-
-#include <asm/macintosh.h>
 #include <asm/macints.h>
-#include <asm/mac_via.h>
+#include <asm/setup.h>
 
 #include <scsi/scsi_host.h>
 
@@ -36,7 +31,7 @@
 
 #define PSEUDO_DMA
 
-#define NCR5380_implementation_fields   /* none */
+#define NCR5380_implementation_fields   unsigned char *pdma_base
 #define NCR5380_local_declare()         struct Scsi_Host *_instance
 #define NCR5380_setup(instance)         _instance = instance
 
@@ -58,10 +53,6 @@
 
 #define RESET_BOOT
 
-#ifdef RESET_BOOT
-static void mac_scsi_reset_boot(struct Scsi_Host *instance);
-#endif
-
 static int setup_can_queue = -1;
 module_param(setup_can_queue, int, 0);
 static int setup_cmd_per_lun = -1;
@@ -86,23 +77,18 @@ module_param(setup_hostid, int, 0);
 #define	AFTER_RESET_DELAY	(HZ/2)
 #endif
 
-static unsigned char *mac_scsi_regp;
-static unsigned char *mac_scsi_drq;
-static unsigned char *mac_scsi_nodrq;
-
-
 /*
  * NCR 5380 register access functions
  */
 
-static __inline__ char macscsi_read(struct Scsi_Host *instance, int reg)
+static inline char macscsi_read(struct Scsi_Host *instance, int reg)
 {
-  return in_8(instance->io_port + (reg<<4));
+	return in_8(instance->base + (reg << 4));
 }
 
-static __inline__ void macscsi_write(struct Scsi_Host *instance, int reg, int value)
+static inline void macscsi_write(struct Scsi_Host *instance, int reg, int value)
 {
-  out_8(instance->io_port + (reg<<4), value);
+	out_8(instance->base + (reg << 4), value);
 }
 
 #ifndef MODULE
@@ -134,96 +120,6 @@ static int __init mac_scsi_setup(char *s
 __setup("mac5380=", mac_scsi_setup);
 #endif /* !MODULE */
 
-/*
- * Function : int macscsi_detect(struct scsi_host_template * tpnt)
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
-int __init macscsi_detect(struct scsi_host_template * tpnt)
-{
-    static int called = 0;
-    int flags = 0;
-    struct Scsi_Host *instance;
-
-    if (!MACH_IS_MAC || called)
-	return( 0 );
-
-    if (macintosh_config->scsi_type != MAC_SCSI_OLD)
-	return( 0 );
-
-	if (setup_can_queue > 0)
-		tpnt->can_queue = setup_can_queue;
-	if (setup_cmd_per_lun > 0)
-		tpnt->cmd_per_lun = setup_cmd_per_lun;
-	if (setup_sg_tablesize >= 0)
-		tpnt->sg_tablesize = setup_sg_tablesize;
-	if (setup_hostid >= 0)
-		tpnt->this_id = setup_hostid & 7;
-
-#ifdef SUPPORT_TAGS
-    if (setup_use_tagged_queuing < 0)
-	setup_use_tagged_queuing = 0;
-#endif
-
-    /* Once we support multiple 5380s (e.g. DuoDock) we'll do
-       something different here */
-    instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
-    if (instance == NULL)
-	return 0;
-
-    if (macintosh_config->ident == MAC_MODEL_IIFX) {
-	mac_scsi_regp  = (unsigned char *) VIA1_BASE + 0x8000;
-	mac_scsi_drq   = (unsigned char *) VIA1_BASE + 0xE000;
-	mac_scsi_nodrq = (unsigned char *) VIA1_BASE + 0xC000;
-	/* The IIFX should be able to do true DMA, but pseudo-dma doesn't work */
-	flags = FLAG_NO_PSEUDO_DMA;
-    } else {
-	mac_scsi_regp  = (unsigned char *) VIA1_BASE + 0x10000;
-	mac_scsi_drq   = (unsigned char *) VIA1_BASE + 0x6000;
-	mac_scsi_nodrq = (unsigned char *) VIA1_BASE + 0x12000;
-    }
-
-    if (! setup_use_pdma)
-	flags = FLAG_NO_PSEUDO_DMA;
-	
-    instance->io_port = (unsigned long) mac_scsi_regp;
-    instance->irq = IRQ_MAC_SCSI;
-
-#ifdef RESET_BOOT   
-    mac_scsi_reset_boot(instance);
-#endif
-    
-    NCR5380_init(instance, flags);
-
-    instance->n_io_port = 255;
-
-    if (instance->irq != IRQ_NONE)
-	if (request_irq(instance->irq, NCR5380_intr, 0, "ncr5380", instance)) {
-	    printk(KERN_WARNING "scsi%d: IRQ%d not free, interrupts disabled\n",
-		   instance->host_no, instance->irq);
-	    instance->irq = IRQ_NONE;
-	}
-
-    called = 1;
-    return 1;
-}
-
-int macscsi_release (struct Scsi_Host *shpnt)
-{
-	if (shpnt->irq != IRQ_NONE)
-		free_irq(shpnt->irq, shpnt);
-	NCR5380_exit(shpnt);
-
-	return 0;
-}
-
 #ifdef RESET_BOOT
 /*
  * Our 'bus reset on boot' function
@@ -335,13 +231,14 @@ __asm__ __volatile__					\
 static int macscsi_pread(struct Scsi_Host *instance,
                          unsigned char *dst, int len)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char *d;
 	unsigned char *s;
 
 	NCR5380_local_declare();
 	NCR5380_setup(instance);
 
-	s = mac_scsi_drq + (INPUT_DATA_REG << 4);
+	s = hostdata->pdma_base + (INPUT_DATA_REG << 4);
 	d = dst;
 
 	/* These conditions are derived from MacOS */
@@ -428,6 +325,7 @@ __asm__ __volatile__					\
 static int macscsi_pwrite(struct Scsi_Host *instance,
                           unsigned char *src, int len)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char *s;
 	unsigned char *d;
 
@@ -435,7 +333,7 @@ static int macscsi_pwrite(struct Scsi_Ho
 	NCR5380_setup(instance);
 
 	s = src;
-	d = mac_scsi_drq + (OUTPUT_DATA_REG << 4);
+	d = hostdata->pdma_base + (OUTPUT_DATA_REG << 4);
 
 	/* These conditions are derived from MacOS */
 
@@ -462,13 +360,15 @@ static int macscsi_pwrite(struct Scsi_Ho
 
 #include "NCR5380.c"
 
-static struct scsi_host_template driver_template = {
-	.proc_name			= "Mac5380",
+#define DRV_MODULE_NAME         "mac_scsi"
+#define PFX                     DRV_MODULE_NAME ": "
+
+static struct scsi_host_template mac_scsi_template = {
+	.module				= THIS_MODULE,
+	.proc_name			= DRV_MODULE_NAME,
 	.show_info			= macscsi_show_info,
 	.write_info			= macscsi_write_info,
 	.name				= "Macintosh NCR5380 SCSI",
-	.detect				= macscsi_detect,
-	.release			= macscsi_release,
 	.info				= macscsi_info,
 	.queuecommand			= macscsi_queue_command,
 	.eh_abort_handler		= macscsi_abort,
@@ -480,7 +380,117 @@ static struct scsi_host_template driver_
 	.use_clustering			= DISABLE_CLUSTERING
 };
 
+static int __init mac_scsi_probe(struct platform_device *pdev)
+{
+	struct Scsi_Host *instance;
+	int error;
+	int host_flags = 0;
+	struct resource *irq, *pio_mem, *pdma_mem = NULL;
+
+	if (!MACH_IS_MAC)
+		return -ENODEV;
+
+	pio_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!pio_mem)
+		return -ENODEV;
+
+#ifdef PSEUDO_DMA
+	pdma_mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+#endif
+
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+
+	if (!hwreg_present((unsigned char *)pio_mem->start +
+	                   (STATUS_REG << 4))) {
+		pr_info(PFX "no device detected at %pap\n", &pio_mem->start);
+		return -ENODEV;
+	}
+
+	if (setup_can_queue > 0)
+		mac_scsi_template.can_queue = setup_can_queue;
+	if (setup_cmd_per_lun > 0)
+		mac_scsi_template.cmd_per_lun = setup_cmd_per_lun;
+	if (setup_sg_tablesize >= 0)
+		mac_scsi_template.sg_tablesize = setup_sg_tablesize;
+	if (setup_hostid >= 0)
+		mac_scsi_template.this_id = setup_hostid & 7;
+#ifdef SUPPORT_TAGS
+	if (setup_use_tagged_queuing < 0)
+		setup_use_tagged_queuing = 0;
+#endif
+	if (setup_use_pdma < 0)
+		setup_use_pdma = 0;
+
+	instance = scsi_host_alloc(&mac_scsi_template,
+	                           sizeof(struct NCR5380_hostdata));
+	if (!instance)
+		return -ENOMEM;
+
+	instance->base = pio_mem->start;
+	if (irq)
+		instance->irq = irq->start;
+	else
+		instance->irq = IRQ_NONE;
+
+	if (pdma_mem && setup_use_pdma) {
+		struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+		hostdata->pdma_base = (unsigned char *)pdma_mem->start;
+	} else
+		host_flags |= FLAG_NO_PSEUDO_DMA;
+
+#ifdef RESET_BOOT
+	mac_scsi_reset_boot(instance);
+#endif
+
+	NCR5380_init(instance, host_flags);
+
+	if (instance->irq != IRQ_NONE) {
+		error = request_irq(instance->irq, macscsi_intr, 0,
+		                    "NCR5380", instance);
+		if (error)
+			goto fail_irq;
+	}
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
+	if (instance->irq != IRQ_NONE)
+		free_irq(instance->irq, instance);
+fail_irq:
+	NCR5380_exit(instance);
+	scsi_host_put(instance);
+	return error;
+}
+
+static int __exit mac_scsi_remove(struct platform_device *pdev)
+{
+	struct Scsi_Host *instance = platform_get_drvdata(pdev);
+
+	scsi_remove_host(instance);
+	if (instance->irq != IRQ_NONE)
+		free_irq(instance->irq, instance);
+	NCR5380_exit(instance);
+	scsi_host_put(instance);
+	return 0;
+}
+
+static struct platform_driver mac_scsi_driver = {
+	.remove = __exit_p(mac_scsi_remove),
+	.driver = {
+		.name	= DRV_MODULE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
 
-#include "scsi_module.c"
+module_platform_driver_probe(mac_scsi_driver, mac_scsi_probe);
 
+MODULE_ALIAS("platform:" DRV_MODULE_NAME);
 MODULE_LICENSE("GPL");
Index: linux/arch/m68k/mac/config.c
===================================================================
--- linux.orig/arch/m68k/mac/config.c	2014-10-02 16:55:28.000000000 +1000
+++ linux/arch/m68k/mac/config.c	2014-10-02 16:56:19.000000000 +1000
@@ -278,7 +278,7 @@ static struct mac_model mac_data_table[]
 		.name		= "IIfx",
 		.adb_type	= MAC_ADB_IOP,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_IIFX,
 		.scc_type	= MAC_SCC_IOP,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_IOP,
@@ -329,7 +329,7 @@ static struct mac_model mac_data_table[]
 		.name		= "Color Classic",
 		.adb_type	= MAC_ADB_CUDA,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_CCL,
 		.scc_type	= MAC_SCC_II,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_ADDR2,
@@ -338,7 +338,7 @@ static struct mac_model mac_data_table[]
 		.name		= "Color Classic II",
 		.adb_type	= MAC_ADB_CUDA,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_CCL,
 		.scc_type	= MAC_SCC_II,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_ADDR2,
@@ -526,7 +526,7 @@ static struct mac_model mac_data_table[]
 		.name		= "Performa 520",
 		.adb_type	= MAC_ADB_CUDA,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_CCL,
 		.scc_type	= MAC_SCC_II,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_ADDR2,
@@ -535,7 +535,7 @@ static struct mac_model mac_data_table[]
 		.name		= "Performa 550",
 		.adb_type	= MAC_ADB_CUDA,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_CCL,
 		.scc_type	= MAC_SCC_II,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_ADDR2,
@@ -567,7 +567,7 @@ static struct mac_model mac_data_table[]
 		.name		= "TV",
 		.adb_type	= MAC_ADB_CUDA,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_CCL,
 		.scc_type	= MAC_SCC_II,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_ADDR2,
@@ -740,7 +740,7 @@ static struct mac_model mac_data_table[]
 		.name		= "PowerBook Duo 210",
 		.adb_type	= MAC_ADB_PB2,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_DUO,
 		.scc_type	= MAC_SCC_QUADRA,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_ADDR2,
@@ -749,7 +749,7 @@ static struct mac_model mac_data_table[]
 		.name		= "PowerBook Duo 230",
 		.adb_type	= MAC_ADB_PB2,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_DUO,
 		.scc_type	= MAC_SCC_QUADRA,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_ADDR2,
@@ -758,7 +758,7 @@ static struct mac_model mac_data_table[]
 		.name		= "PowerBook Duo 250",
 		.adb_type	= MAC_ADB_PB2,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_DUO,
 		.scc_type	= MAC_SCC_QUADRA,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_ADDR2,
@@ -767,7 +767,7 @@ static struct mac_model mac_data_table[]
 		.name		= "PowerBook Duo 270c",
 		.adb_type	= MAC_ADB_PB2,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_DUO,
 		.scc_type	= MAC_SCC_QUADRA,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_ADDR2,
@@ -776,7 +776,7 @@ static struct mac_model mac_data_table[]
 		.name		= "PowerBook Duo 280",
 		.adb_type	= MAC_ADB_PB2,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_DUO,
 		.scc_type	= MAC_SCC_QUADRA,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_ADDR2,
@@ -785,7 +785,7 @@ static struct mac_model mac_data_table[]
 		.name		= "PowerBook Duo 280c",
 		.adb_type	= MAC_ADB_PB2,
 		.via_type	= MAC_VIA_IICI,
-		.scsi_type	= MAC_SCSI_OLD,
+		.scsi_type	= MAC_SCSI_DUO,
 		.scc_type	= MAC_SCC_QUADRA,
 		.nubus_type	= MAC_NUBUS,
 		.floppy_type	= MAC_FLOPPY_SWIM_ADDR2,
@@ -929,6 +929,36 @@ static struct platform_device swim_pdev
 	.resource	= &swim_rsrc,
 };
 
+static struct resource mac_scsi_0_rsrc[] = {
+	{
+		.flags = IORESOURCE_IRQ,
+		.start = IRQ_MAC_SCSI,
+		.end   = IRQ_MAC_SCSI,
+	},
+	{ .flags = IORESOURCE_MEM },
+	{ .flags = IORESOURCE_MEM },
+};
+
+static struct resource mac_scsi_1_rsrc[] = {
+	/* IRQ_NUBUS_E maybe? */
+	{ .flags = IORESOURCE_MEM },
+	{ .flags = IORESOURCE_MEM },
+};
+
+static struct platform_device mac_scsi_0_pdev = {
+	.name		= "mac_scsi",
+	.id		= 0,
+	.resource	= mac_scsi_0_rsrc,
+	.num_resources  = ARRAY_SIZE(mac_scsi_0_rsrc),
+};
+
+static struct platform_device mac_scsi_1_pdev = {
+	.name		= "mac_scsi",
+	.id		= 1,
+	.resource	= mac_scsi_1_rsrc,
+	.num_resources	= ARRAY_SIZE(mac_scsi_1_rsrc),
+};
+
 static struct platform_device esp_0_pdev = {
 	.name		= "mac_esp",
 	.id		= 0,
@@ -1000,6 +1030,53 @@ int __init mac_platform_init(void)
 		    (macintosh_config->ident == MAC_MODEL_Q950))
 			platform_device_register(&esp_1_pdev);
 		break;
+	case MAC_SCSI_IIFX:
+		/* Addresses from The Guide to Mac Family Hardware. */
+		mac_scsi_0_rsrc[1].start = 0x50008000; /* SCSI DMA */
+		mac_scsi_0_rsrc[1].end = mac_scsi_0_rsrc[1].start + 0x1FFF;
+		/* $5000 E000 - $5000 FFFF: Alternate SCSI (Hsk) */
+		/* $5000 C000 - $5000 DFFF: Alternate SCSI (DMA) */
+		/* The SCSI DMA custom IC embeds the 53C80 core. mac_scsi does
+		 * not make use of its DMA or hardware handshaking logic.
+		 */
+		mac_scsi_0_pdev.num_resources--;
+		platform_device_register(&mac_scsi_0_pdev);
+		break;
+	case MAC_SCSI_DUO:
+		/* Addresses from the Duo Dock II Developer Note. */
+		mac_scsi_1_rsrc[0].start = 0xFEE02000; /* normal mode */
+		mac_scsi_1_rsrc[0].end = mac_scsi_1_rsrc[0].start + 0x1FFF;
+		mac_scsi_1_rsrc[1].start = 0xFEE06000;/* pseudo DMA with /DRQ */
+		mac_scsi_1_rsrc[1].end = mac_scsi_1_rsrc[1].start + 0x1FFF;
+		/* $FEE0 4000 - $FEE0 5FFF: pseudo DMA without /DRQ */
+		platform_device_register(&mac_scsi_1_pdev);
+		/* fall through */
+	case MAC_SCSI_OLD:
+		/* Addresses from Developer Notes for Duo System,
+		 * PowerBook 180 & 160, 140 & 170, Macintosh IIsi
+		 * and also from The Guide to Mac Family Hardware for
+		 * SE/30, II, IIx, IIcx, IIci.
+		 * GMFH says that $5000 0000 - $50FF FFFF "wraps
+		 * $5000 0000 - $5001 FFFF eight times"...
+		 * mess.org says IIci and Color Classic do not alias
+		 * I/O address space.
+		 */
+		mac_scsi_0_rsrc[1].start = 0x50010000; /* normal mode */
+		mac_scsi_0_rsrc[1].end = mac_scsi_0_rsrc[1].start + 0x1FFF;
+		mac_scsi_0_rsrc[2].start = 0x50006000;/* pseudo DMA with /DRQ */
+		mac_scsi_0_rsrc[2].end = mac_scsi_0_rsrc[2].start + 0x1FFF;
+		/* $5001 2000 - $5001 3FFF: pseudo DMA without /DRQ */
+		platform_device_register(&mac_scsi_0_pdev);
+		break;
+	case MAC_SCSI_CCL:
+		/* Addresses from the Color Classic Developer Note. */
+		mac_scsi_0_rsrc[1].start = 0x50F10000; /* SCSI */
+		mac_scsi_0_rsrc[1].end = mac_scsi_0_rsrc[1].start + 0x1FFF;
+		mac_scsi_0_rsrc[2].start = 0x50F06000; /* SCSI handshake */
+		mac_scsi_0_rsrc[2].end = mac_scsi_0_rsrc[2].start + 0x1FFF;
+		/* $50F1 2000 - $50F1 3FFF: SCSI DMA */
+		platform_device_register(&mac_scsi_0_pdev);
+		break;
 	}
 
 	/*
Index: linux/arch/m68k/include/asm/macintosh.h
===================================================================
--- linux.orig/arch/m68k/include/asm/macintosh.h	2014-10-02 16:55:28.000000000 +1000
+++ linux/arch/m68k/include/asm/macintosh.h	2014-10-02 16:56:19.000000000 +1000
@@ -53,6 +53,9 @@ struct mac_model
 #define MAC_SCSI_QUADRA		2
 #define MAC_SCSI_QUADRA2	3
 #define MAC_SCSI_QUADRA3	4
+#define MAC_SCSI_IIFX		5
+#define MAC_SCSI_DUO		6
+#define MAC_SCSI_CCL		7
 
 #define MAC_IDE_NONE		0
 #define MAC_IDE_QUADRA		1
