From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 10/36] ncr5380: Fix SCSI_IRQ_NONE bugs
Date: Mon, 27 Oct 2014 16:26:17 +1100
Message-ID: <20141027052609.555425104@telegraphics.com.au>
References: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-SCSI_IRQ_NONE-fixes
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Oak scsi doesn't use any IRQ, but it sets irq = IRQ_NONE rather than
SCSI_IRQ_NONE. Problem is, the core NCR5380 driver expects SCSI_IRQ_NONE
if it is to issue IDENTIFY commands that prevent target disconnection.
And, as Geert points out, IRQ_NONE is part of enum irqreturn.

Other drivers, when they can't get an IRQ or can't use one, will set
host->irq = SCSI_IRQ_NONE (that is, 255). But when they exit they will
attempt to free IRQ 255 which was never requested.

Fix these bugs by using NO_IRQ in place of SCSI_IRQ_NONE and IRQ_NONE.
That means IRQ 0 is no longer probed by ISA drivers but I don't think
this matters.

Setting IRQ = 255 for these ISA drivers is understood to mean no IRQ.
This remains supported so as to avoid breaking existing ISA setups (which
can be difficult to get working) and because existing documentation
(SANE, TLDP etc) describes this usage for the ISA NCR5380 driver options.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Changes since v1:
- Define NO_IRQ macro and use that instead of IRQ_NONE.

---
 drivers/scsi/NCR5380.c   |   12 ++++++------
 drivers/scsi/NCR5380.h   |    5 ++++-
 drivers/scsi/arm/oak.c   |    2 +-
 drivers/scsi/dmx3191d.c  |    7 ++++---
 drivers/scsi/dtc.c       |   22 +++++++++++++---------
 drivers/scsi/g_NCR5380.c |   18 +++++++++++-------
 drivers/scsi/mac_scsi.c  |    8 ++++----
 drivers/scsi/pas16.c     |   20 +++++++++++---------
 drivers/scsi/sun3_scsi.c |    6 +++---
 drivers/scsi/t128.c      |   14 +++++++++-----
 10 files changed, 66 insertions(+), 48 deletions(-)

Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2014-10-27 16:25:20.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2014-10-27 16:25:22.000000000 +1100
@@ -254,31 +254,35 @@ found:
 		else
 			instance->irq = NCR5380_probe_irq(instance, DTC_IRQS);
 
+		/* Compatibility with documented NCR5380 kernel parameters */
+		if (instance->irq == 255)
+			instance->irq = NO_IRQ;
+
 #ifndef DONT_USE_INTR
 		/* With interrupts enabled, it will sometimes hang when doing heavy
 		 * reads. So better not enable them until I finger it out. */
-		if (instance->irq != SCSI_IRQ_NONE)
+		if (instance->irq != NO_IRQ)
 			if (request_irq(instance->irq, dtc_intr, 0,
 					"dtc", instance)) {
 				printk(KERN_ERR "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
-				instance->irq = SCSI_IRQ_NONE;
+				instance->irq = NO_IRQ;
 			}
 
-		if (instance->irq == SCSI_IRQ_NONE) {
+		if (instance->irq == NO_IRQ) {
 			printk(KERN_WARNING "scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
 			printk(KERN_WARNING "scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
 		}
 #else
-		if (instance->irq != SCSI_IRQ_NONE)
+		if (instance->irq != NO_IRQ)
 			printk(KERN_WARNING "scsi%d : interrupts not used. Might as well not jumper it.\n", instance->host_no);
-		instance->irq = SCSI_IRQ_NONE;
+		instance->irq = NO_IRQ;
 #endif
 #if defined(DTCDEBUG) && (DTCDEBUG & DTCDEBUG_INIT)
 		printk("scsi%d : irq = %d\n", instance->host_no, instance->irq);
 #endif
 
 		printk(KERN_INFO "scsi%d : at 0x%05X", instance->host_no, (int) instance->base);
-		if (instance->irq == SCSI_IRQ_NONE)
+		if (instance->irq == NO_IRQ)
 			printk(" interrupts disabled");
 		else
 			printk(" irq %d", instance->irq);
@@ -350,7 +354,7 @@ static inline int NCR5380_pread(struct S
 	i = 0;
 	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	NCR5380_write(MODE_REG, MR_ENABLE_EOP_INTR | MR_DMA_MODE);
-	if (instance->irq == SCSI_IRQ_NONE)
+	if (instance->irq == NO_IRQ)
 		NCR5380_write(DTC_CONTROL_REG, CSR_DIR_READ);
 	else
 		NCR5380_write(DTC_CONTROL_REG, CSR_DIR_READ | CSR_INT_BASE);
@@ -401,7 +405,7 @@ static inline int NCR5380_pwrite(struct
 	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 	NCR5380_write(MODE_REG, MR_ENABLE_EOP_INTR | MR_DMA_MODE);
 	/* set direction (write) */
-	if (instance->irq == SCSI_IRQ_NONE)
+	if (instance->irq == NO_IRQ)
 		NCR5380_write(DTC_CONTROL_REG, 0);
 	else
 		NCR5380_write(DTC_CONTROL_REG, CSR_5380_INTR);
@@ -440,7 +444,7 @@ static int dtc_release(struct Scsi_Host
 {
 	NCR5380_local_declare();
 	NCR5380_setup(shost);
-	if (shost->irq)
+	if (shost->irq != NO_IRQ)
 		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2014-10-27 16:25:20.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2014-10-27 16:25:22.000000000 +1100
@@ -62,13 +62,11 @@
  *   If you have problems with your card not being recognized, use
  *   the LILO command line override.  Try to get it recognized without
  *   interrupts.  Ie, for a board at the default 0x388 base port,
- *   boot: linux pas16=0x388,255
+ *   boot: linux pas16=0x388,0
  *
- *   SCSI_IRQ_NONE (255) should be specified for no interrupt,
+ *   NO_IRQ (0) should be specified for no interrupt,
  *   IRQ_AUTO (254) to autoprobe for an IRQ line if overridden
  *   on the command line.
- *
- *   (IRQ_AUTO == 254, SCSI_IRQ_NONE == 255 in NCR5380.h)
  */
  
 #include <linux/module.h>
@@ -416,15 +414,19 @@ static int __init pas16_detect(struct sc
 	else 
 	    instance->irq = NCR5380_probe_irq(instance, PAS16_IRQS);
 
-	if (instance->irq != SCSI_IRQ_NONE) 
+	/* Compatibility with documented NCR5380 kernel parameters */
+	if (instance->irq == 255)
+		instance->irq = NO_IRQ;
+
+	if (instance->irq != NO_IRQ)
 	    if (request_irq(instance->irq, pas16_intr, 0,
 			    "pas16", instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
-		instance->irq = SCSI_IRQ_NONE;
+		instance->irq = NO_IRQ;
 	    } 
 
-	if (instance->irq == SCSI_IRQ_NONE) {
+	if (instance->irq == NO_IRQ) {
 	    printk("scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
 	    printk("scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
 	    /* Disable 5380 interrupts, leave drive params the same */
@@ -438,7 +440,7 @@ static int __init pas16_detect(struct sc
 
 	printk("scsi%d : at 0x%04x", instance->host_no, (int) 
 	    instance->io_port);
-	if (instance->irq == SCSI_IRQ_NONE)
+	if (instance->irq == NO_IRQ)
 	    printk (" interrupts disabled");
 	else 
 	    printk (" irq %d", instance->irq);
@@ -568,7 +570,7 @@ static inline int NCR5380_pwrite (struct
 
 static int pas16_release(struct Scsi_Host *shost)
 {
-	if (shost->irq)
+	if (shost->irq != NO_IRQ)
 		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2014-10-27 16:25:20.000000000 +1100
+++ linux/drivers/scsi/t128.c	2014-10-27 16:25:22.000000000 +1100
@@ -228,15 +228,19 @@ found:
 	else 
 	    instance->irq = NCR5380_probe_irq(instance, T128_IRQS);
 
-	if (instance->irq != SCSI_IRQ_NONE) 
+	/* Compatibility with documented NCR5380 kernel parameters */
+	if (instance->irq == 255)
+		instance->irq = NO_IRQ;
+
+	if (instance->irq != NO_IRQ)
 	    if (request_irq(instance->irq, t128_intr, 0, "t128",
 			    instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
-		instance->irq = SCSI_IRQ_NONE;
+		instance->irq = NO_IRQ;
 	    } 
 
-	if (instance->irq == SCSI_IRQ_NONE) {
+	if (instance->irq == NO_IRQ) {
 	    printk("scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
 	    printk("scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
 	}
@@ -246,7 +250,7 @@ found:
 #endif
 
 	printk("scsi%d : at 0x%08lx", instance->host_no, instance->base);
-	if (instance->irq == SCSI_IRQ_NONE)
+	if (instance->irq == NO_IRQ)
 	    printk (" interrupts disabled");
 	else 
 	    printk (" irq %d", instance->irq);
@@ -265,7 +269,7 @@ static int t128_release(struct Scsi_Host
 {
 	NCR5380_local_declare();
 	NCR5380_setup(shost);
-	if (shost->irq)
+	if (shost->irq != NO_IRQ)
 		free_irq(shost->irq, shost);
 	NCR5380_exit(shost);
 	if (shost->io_port && shost->n_io_port)
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2014-10-27 16:25:17.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2014-10-27 16:25:22.000000000 +1100
@@ -574,12 +574,12 @@ static int __init __maybe_unused NCR5380
 	int trying_irqs, i, mask;
 	NCR5380_setup(instance);
 
-	for (trying_irqs = i = 0, mask = 1; i < 16; ++i, mask <<= 1)
+	for (trying_irqs = 0, i = 1, mask = 2; i < 16; ++i, mask <<= 1)
 		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe", NULL) == 0))
 			trying_irqs |= mask;
 
 	timeout = jiffies + (250 * HZ / 1000);
-	probe_irq = SCSI_IRQ_NONE;
+	probe_irq = NO_IRQ;
 
 	/*
 	 * A interrupt is triggered whenever BSY = false, SEL = true
@@ -596,13 +596,13 @@ static int __init __maybe_unused NCR5380
 	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_SEL);
 
-	while (probe_irq == SCSI_IRQ_NONE && time_before(jiffies, timeout))
+	while (probe_irq == NO_IRQ && time_before(jiffies, timeout))
 		schedule_timeout_uninterruptible(1);
 	
 	NCR5380_write(SELECT_ENABLE_REG, 0);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
-	for (i = 0, mask = 1; i < 16; ++i, mask <<= 1)
+	for (i = 1, mask = 2; i < 16; ++i, mask <<= 1)
 		if (trying_irqs & mask)
 			free_irq(i, NULL);
 
@@ -730,7 +730,7 @@ static int __maybe_unused NCR5380_show_i
 
 	SPRINTF("\nBase Addr: 0x%05lX    ", (long) instance->base);
 	SPRINTF("io_port: %04x      ", (int) instance->io_port);
-	if (instance->irq == SCSI_IRQ_NONE)
+	if (instance->irq == NO_IRQ)
 		SPRINTF("IRQ: None.\n");
 	else
 		SPRINTF("IRQ: %d.\n", instance->irq);
@@ -1501,7 +1501,7 @@ part2:
 	}
 
 	dprintk(NDEBUG_SELECTION, "scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id);
-	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), cmd->device->lun);
+	tmp[0] = IDENTIFY(((instance->irq == NO_IRQ) ? 0 : 1), cmd->device->lun);
 
 	len = 1;
 	cmd->tag = 0;
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-10-27 16:25:17.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-10-27 16:25:22.000000000 +1100
@@ -232,12 +232,15 @@
  * Scsi_Host structure
  */
 
-#define SCSI_IRQ_NONE	255
 #define DMA_NONE	255
 #define IRQ_AUTO	254
 #define DMA_AUTO	254
 #define PORT_AUTO	0xffff	/* autoprobe io port for 53c400a */
 
+#ifndef NO_IRQ
+#define NO_IRQ		0
+#endif
+
 #define FLAG_HAS_LAST_BYTE_SENT		1	/* NCR53c81 or better */
 #define FLAG_CHECK_LAST_BYTE_SENT	2	/* Only test once */
 #define FLAG_NCR53C400			4	/* NCR53c400 */
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2014-10-27 16:25:17.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2014-10-27 16:25:22.000000000 +1100
@@ -100,7 +100,7 @@ static int dmx3191d_probe_one(struct pci
 		 */
 		printk(KERN_WARNING "dmx3191: IRQ %d not available - "
 				    "switching to polled mode.\n", pdev->irq);
-		shost->irq = SCSI_IRQ_NONE;
+		shost->irq = NO_IRQ;
 	}
 
 	pci_set_drvdata(pdev, shost);
@@ -113,7 +113,8 @@ static int dmx3191d_probe_one(struct pci
 	return 0;
 
  out_free_irq:
-	free_irq(shost->irq, shost);
+	if (shost->irq != NO_IRQ)
+		free_irq(shost->irq, shost);
  out_release_region:
 	release_region(io, DMX3191D_REGION_LEN);
  out_disable_device:
@@ -130,7 +131,7 @@ static void dmx3191d_remove_one(struct p
 
 	NCR5380_exit(shost);
 
-	if (shost->irq != SCSI_IRQ_NONE)
+	if (shost->irq != NO_IRQ)
 		free_irq(shost->irq, shost);
 	release_region(shost->io_port, DMX3191D_REGION_LEN);
 	pci_disable_device(pdev);
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2014-10-27 16:25:20.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2014-10-27 16:25:22.000000000 +1100
@@ -312,7 +312,7 @@ static int __init generic_NCR5380_detect
 			if (pnp_irq_valid(dev, 0))
 				overrides[count].irq = pnp_irq(dev, 0);
 			else
-				overrides[count].irq = SCSI_IRQ_NONE;
+				overrides[count].irq = NO_IRQ;
 			if (pnp_dma_valid(dev, 0))
 				overrides[count].dma = pnp_dma(dev, 0);
 			else
@@ -432,20 +432,24 @@ static int __init generic_NCR5380_detect
 		else
 			instance->irq = NCR5380_probe_irq(instance, 0xffff);
 
-		if (instance->irq != SCSI_IRQ_NONE)
+		/* Compatibility with documented NCR5380 kernel parameters */
+		if (instance->irq == 255)
+			instance->irq = NO_IRQ;
+
+		if (instance->irq != NO_IRQ)
 			if (request_irq(instance->irq, generic_NCR5380_intr,
 					0, "NCR5380", instance)) {
 				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
-				instance->irq = SCSI_IRQ_NONE;
+				instance->irq = NO_IRQ;
 			}
 
-		if (instance->irq == SCSI_IRQ_NONE) {
+		if (instance->irq == NO_IRQ) {
 			printk(KERN_INFO "scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
 			printk(KERN_INFO "scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
 		}
 
 		printk(KERN_INFO "scsi%d : at " STRVAL(NCR5380_map_name) " 0x%x", instance->host_no, (unsigned int) instance->NCR5380_instance_name);
-		if (instance->irq == SCSI_IRQ_NONE)
+		if (instance->irq == NO_IRQ)
 			printk(" interrupts disabled");
 		else
 			printk(" irq %d", instance->irq);
@@ -486,7 +490,7 @@ static int generic_NCR5380_release_resou
 	NCR5380_local_declare();
 	NCR5380_setup(instance);
 	
-	if (instance->irq != SCSI_IRQ_NONE)
+	if (instance->irq != NO_IRQ)
 		free_irq(instance->irq, instance);
 	NCR5380_exit(instance);
 
@@ -796,7 +800,7 @@ static int generic_NCR5380_show_info(str
 	PRINTP("NO NCR53C400 driver extensions\n");
 #endif
 	PRINTP("Using %s mapping at %s 0x%lx, " ANDP STRVAL(NCR5380_map_config) ANDP STRVAL(NCR5380_map_name) ANDP scsi_ptr->NCR5380_instance_name);
-	if (scsi_ptr->irq == SCSI_IRQ_NONE)
+	if (scsi_ptr->irq == NO_IRQ)
 		PRINTP("no interrupt\n");
 	else
 		PRINTP("on interrupt %d\n" ANDP scsi_ptr->irq);
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-10-27 16:25:20.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2014-10-27 16:25:22.000000000 +1100
@@ -229,15 +229,15 @@ int __init macscsi_detect(struct scsi_ho
 
     instance->n_io_port = 255;
 
-    if (instance->irq != SCSI_IRQ_NONE)
+    if (instance->irq != NO_IRQ)
 	if (request_irq(instance->irq, NCR5380_intr, 0, "ncr5380", instance)) {
 	    printk(KERN_WARNING "scsi%d: IRQ%d not free, interrupts disabled\n",
 		   instance->host_no, instance->irq);
-	    instance->irq = SCSI_IRQ_NONE;
+	    instance->irq = NO_IRQ;
 	}
 
     printk(KERN_INFO "scsi%d: generic 5380 at port %lX irq", instance->host_no, instance->io_port);
-    if (instance->irq == SCSI_IRQ_NONE)
+    if (instance->irq == NO_IRQ)
 	printk (KERN_INFO "s disabled");
     else
 	printk (KERN_INFO " %d", instance->irq);
@@ -252,7 +252,7 @@ int __init macscsi_detect(struct scsi_ho
 
 int macscsi_release (struct Scsi_Host *shpnt)
 {
-	if (shpnt->irq != SCSI_IRQ_NONE)
+	if (shpnt->irq != NO_IRQ)
 		free_irq(shpnt->irq, shpnt);
 	NCR5380_exit(shpnt);
 
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-27 16:25:20.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-27 16:25:22.000000000 +1100
@@ -278,7 +278,7 @@ static int __init sun3scsi_detect(struct
 #ifndef REAL_DMA
 		printk("scsi%d: IRQ%d not free, interrupts disabled\n",
 		       instance->host_no, instance->irq);
-		instance->irq = SCSI_IRQ_NONE;
+		instance->irq = NO_IRQ;
 #else
 		printk("scsi%d: IRQ%d not free, bailing out\n",
 		       instance->host_no, instance->irq);
@@ -288,7 +288,7 @@ static int __init sun3scsi_detect(struct
 	
 	pr_info("scsi%d: %s at port %lX irq", instance->host_no,
 		tpnt->proc_name, instance->io_port);
-	if (instance->irq == SCSI_IRQ_NONE)
+	if (instance->irq == NO_IRQ)
 		printk ("s disabled");
 	else
 		printk (" %d", instance->irq);
@@ -325,7 +325,7 @@ static int __init sun3scsi_detect(struct
 
 static int sun3scsi_release(struct Scsi_Host *shpnt)
 {
-	if (shpnt->irq != SCSI_IRQ_NONE)
+	if (shpnt->irq != NO_IRQ)
 		free_irq(shpnt->irq, shpnt);
 
 	iounmap((void *)sun3_scsi_regp);
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2014-10-27 16:25:17.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2014-10-27 16:25:22.000000000 +1100
@@ -148,7 +148,7 @@ static int oakscsi_probe(struct expansio
 		goto unreg;
 	}
 
-	host->irq = IRQ_NONE;
+	host->irq = NO_IRQ;
 	host->n_io_port = 255;
 
 	NCR5380_init(host, 0);
