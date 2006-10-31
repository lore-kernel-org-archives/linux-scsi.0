From: Kars de Jong <jongk@linux-m68k.org>
Subject: [RFC PATCH] m68k: switch to 53c700 driver
Date: Tue, 31 Oct 2006 22:47:04 +0100
Message-ID: <1162331224.7805.18.camel@kars.perseus.home>
References: <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
	 <20051007134232.GA6490@levanta.com>
	 <1128693232.5041.7.camel@laptop-lcs.localdomain>
	 <20051115095152.GA23470@infradead.org>
	 <20051115101709.GK7031@2004.bluespice.org>
	 <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
	 <20060707124444.GA11199@infradead.org> <20060709111648.GR15414@levanta.com>
	 <1152444304.5567.2.camel@kars.perseus.home>
	 <20061030111311.GA756@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56474 "EHLO
	smtpq2.tilbu1.nb.home.nl") by vger.kernel.org with ESMTP
	id S1423651AbWJaVqa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 16:46:30 -0500
In-Reply-To: <20061030111311.GA756@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Richard Hirst <rhirst@levanta.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On ma, 2006-10-30 at 11:13 +0000, Christoph Hellwig wrote:
> Any updates?  Honestly, I do not plan to touch the current 53c7xx/etc
> mess in the upoming request_buffer transition, and unless the m68k
> folks provide the new 53c700-based driver I'll just submit a patch to
> rip 53c7xx and users out without replacement.

OK, here's the patch, without the m68k generic iomap changes.

If there are no objections, I will commit it to our CVS repository so
Geert can send it upstream (with proper Signed-Off-By: headers and
everything).

This patch is relative to the m68k CVS repository, which is at kernel
version 2.6.18.

I have renamed the mvme16x.c and bvme6000.c files to mvme16x_scsi.c and
bvme6000_scsi.c respectively, I'm not sure if this is a good idea
though.


Kind regards,

Kars.


Index: linux-2.6-m68k-vme/drivers/scsi/53c700.c
===================================================================
RCS file: /home/linux-m68k/cvsroot/linux/drivers/scsi/53c700.c,v
retrieving revision 1.1.1.37
diff -u -r1.1.1.37 53c700.c
--- linux-2.6-m68k-vme/drivers/scsi/53c700.c	23 Sep 2006 16:55:51 -0000	1.1.1.37
+++ linux-2.6-m68k-vme/drivers/scsi/53c700.c	31 Oct 2006 21:38:48 -0000
@@ -660,20 +660,20 @@
 {
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)host->hostdata[0];
-	__u32 dcntl_extra = 0;
 	__u8 min_period;
 	__u8 min_xferp = (hostdata->chip710 ? NCR_710_MIN_XFERP : NCR_700_MIN_XFERP);
 
 	if(hostdata->chip710) {
 		__u8 burst_disable = hostdata->burst_disable
 			? BURST_DISABLE : 0;
-		dcntl_extra = COMPAT_700_MODE;
+		hostdata->dcntl_extra |= COMPAT_700_MODE;
 
-		NCR_700_writeb(dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(hostdata->dcntl_extra, host, DCNTL_REG);
 		NCR_700_writeb(BURST_LENGTH_8  | hostdata->dmode_extra,
 			       host, DMODE_710_REG);
-		NCR_700_writeb(burst_disable | (hostdata->differential ? 
-						DIFF : 0), host, CTEST7_REG);
+		NCR_700_writeb(burst_disable | hostdata->ctest7_extra |
+			       (hostdata->differential ? DIFF : 0),
+			       host, CTEST7_REG);
 		NCR_700_writeb(BTB_TIMER_DISABLE, host, CTEST0_REG);
 		NCR_700_writeb(FULL_ARBITRATION | ENABLE_PARITY | PARITY
 			       | AUTO_ATN, host, SCNTL0_REG);
@@ -708,13 +708,13 @@
 		 * of spec: sync divider 2, async divider 3 */
 		DEBUG(("53c700: sync 2 async 3\n"));
 		NCR_700_writeb(SYNC_DIV_2_0, host, SBCL_REG);
-		NCR_700_writeb(ASYNC_DIV_3_0 | dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(ASYNC_DIV_3_0 | hostdata->dcntl_extra, host, DCNTL_REG);
 		hostdata->sync_clock = hostdata->clock/2;
 	} else	if(hostdata->clock > 50  && hostdata->clock <= 75) {
 		/* sync divider 1.5, async divider 3 */
 		DEBUG(("53c700: sync 1.5 async 3\n"));
 		NCR_700_writeb(SYNC_DIV_1_5, host, SBCL_REG);
-		NCR_700_writeb(ASYNC_DIV_3_0 | dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(ASYNC_DIV_3_0 | hostdata->dcntl_extra, host, DCNTL_REG);
 		hostdata->sync_clock = hostdata->clock*2;
 		hostdata->sync_clock /= 3;
 		
@@ -722,18 +722,18 @@
 		/* sync divider 1, async divider 2 */
 		DEBUG(("53c700: sync 1 async 2\n"));
 		NCR_700_writeb(SYNC_DIV_1_0, host, SBCL_REG);
-		NCR_700_writeb(ASYNC_DIV_2_0 | dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(ASYNC_DIV_2_0 | hostdata->dcntl_extra, host, DCNTL_REG);
 		hostdata->sync_clock = hostdata->clock;
 	} else if(hostdata->clock > 25 && hostdata->clock <=37) {
 		/* sync divider 1, async divider 1.5 */
 		DEBUG(("53c700: sync 1 async 1.5\n"));
 		NCR_700_writeb(SYNC_DIV_1_0, host, SBCL_REG);
-		NCR_700_writeb(ASYNC_DIV_1_5 | dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(ASYNC_DIV_1_5 | hostdata->dcntl_extra, host, DCNTL_REG);
 		hostdata->sync_clock = hostdata->clock;
 	} else {
 		DEBUG(("53c700: sync 1 async 1\n"));
 		NCR_700_writeb(SYNC_DIV_1_0, host, SBCL_REG);
-		NCR_700_writeb(ASYNC_DIV_1_0 | dcntl_extra, host, DCNTL_REG);
+		NCR_700_writeb(ASYNC_DIV_1_0 | hostdata->dcntl_extra, host, DCNTL_REG);
 		/* sync divider 1, async divider 1 */
 		hostdata->sync_clock = hostdata->clock;
 	}
Index: linux-2.6-m68k-vme/drivers/scsi/53c700.h
===================================================================
RCS file: /home/linux-m68k/cvsroot/linux/drivers/scsi/53c700.h,v
retrieving revision 1.1.1.20
diff -u -r1.1.1.20 53c700.h
--- linux-2.6-m68k-vme/drivers/scsi/53c700.h	23 Sep 2006 16:55:52 -0000	1.1.1.20
+++ linux-2.6-m68k-vme/drivers/scsi/53c700.h	31 Oct 2006 21:38:48 -0000
@@ -177,6 +177,7 @@
 	__u8	state;
 	#define NCR_700_FLAG_AUTOSENSE	0x01
 	__u8	flags;
+	__u8	pad1[2];	/* Needed for m68k where min alignment is 2 bytes */
 	int	tag;
 	__u32	resume_offset;
 	struct scsi_cmnd *cmnd;
@@ -196,6 +197,8 @@
 	void __iomem	*base;		/* the base for the port (copied to host) */
 	struct device	*dev;
 	__u32	dmode_extra;	/* adjustable bus settings */
+	__u32	dcntl_extra;	/* adjustable bus settings */
+	__u32	ctest7_extra;	/* adjustable bus settings */
 	__u32	differential:1;	/* if we are differential */
 #ifdef CONFIG_53C700_LE_ON_BE
 	/* This option is for HP only.  Set it if your chip is wired for
@@ -352,6 +355,7 @@
 #define		SEL_TIMEOUT_DISABLE	0x10 /* 710 only */
 #define         DFP                     0x08
 #define         EVP                     0x04
+#define         CTEST7_TT1              0x02
 #define		DIFF			0x01
 #define CTEST6_REG                      0x1A
 #define	TEMP_REG			0x1C
@@ -385,6 +389,7 @@
 #define		SOFTWARE_RESET		0x01
 #define		COMPAT_700_MODE		0x01
 #define 	SCRPTS_16BITS		0x20
+#define		EA_710			0x20
 #define		ASYNC_DIV_2_0		0x00
 #define		ASYNC_DIV_1_5		0x40
 #define		ASYNC_DIV_1_0		0x80
Index: linux-2.6-m68k-vme/drivers/scsi/Kconfig
===================================================================
RCS file: /home/linux-m68k/cvsroot/linux/drivers/scsi/Kconfig,v
retrieving revision 1.24
diff -u -r1.24 Kconfig
--- linux-2.6-m68k-vme/drivers/scsi/Kconfig	21 Oct 2006 18:47:48 -0000	1.24
+++ linux-2.6-m68k-vme/drivers/scsi/Kconfig	31 Oct 2006 21:38:49 -0000
@@ -1053,6 +1053,11 @@
 	depends on SCSI_LASI700
 	default y
 
+config 53C700_BE_BUS
+	bool
+	depends on SCSI_AMIGA7XX || MVME16x_SCSI || BVME6000_SCSI
+	default y
+
 config SCSI_SYM53C8XX_2
 	tristate "SYM53C8XX Version 2 SCSI support"
 	depends on PCI && SCSI
@@ -1670,7 +1675,7 @@
 	  one in the near future, say Y to this question. Otherwise, say N.
 
 config SCSI_AMIGA7XX
-	bool "Amiga NCR53c710 SCSI support (EXPERIMENTAL)"
+	tristate "Amiga NCR53c710 SCSI support (EXPERIMENTAL)"
 	depends on AMIGA && SCSI && EXPERIMENTAL
 	select SCSI_SPI_ATTRS
 	help
@@ -1771,7 +1776,7 @@
 	  single-board computer.
 
 config MVME16x_SCSI
-	bool "NCR53C710 SCSI driver for MVME16x"
+	tristate "NCR53C710 SCSI driver for MVME16x"
 	depends on MVME16x && SCSI
 	select SCSI_SPI_ATTRS
 	help
@@ -1780,7 +1785,7 @@
 	  will want to say Y to this question.
 
 config BVME6000_SCSI
-	bool "NCR53C710 SCSI driver for BVME6000"
+	tristate "NCR53C710 SCSI driver for BVME6000"
 	depends on BVME6000 && SCSI
 	select SCSI_SPI_ATTRS
 	help
@@ -1788,14 +1793,6 @@
 	  SCSI controller chip.  Almost everyone using one of these boards
 	  will want to say Y to this question.
 
-config SCSI_NCR53C7xx_FAST
-	bool "allow FAST-SCSI [10MHz]"
-	depends on SCSI_AMIGA7XX || MVME16x_SCSI || BVME6000_SCSI
-	help
-	  This will enable 10MHz FAST-SCSI transfers with your host
-	  adapter. Some systems have problems with that speed, so it's safest
-	  to say N here.
-
 config SUN3_SCSI
 	tristate "Sun3 NCR5380 SCSI"
 	depends on SUN3 && SCSI
Index: linux-2.6-m68k-vme/drivers/scsi/Makefile
===================================================================
RCS file: /home/linux-m68k/cvsroot/linux/drivers/scsi/Makefile,v
retrieving revision 1.1.1.46
diff -u -r1.1.1.46 Makefile
--- linux-2.6-m68k-vme/drivers/scsi/Makefile	23 Sep 2006 16:55:57 -0000	1.1.1.46
+++ linux-2.6-m68k-vme/drivers/scsi/Makefile	31 Oct 2006 21:38:49 -0000
@@ -35,7 +35,7 @@
 
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
-obj-$(CONFIG_SCSI_AMIGA7XX)	+= amiga7xx.o	53c7xx.o
+obj-$(CONFIG_SCSI_AMIGA7XX)	+= 53c700.o	amiga7xx.o
 obj-$(CONFIG_A3000_SCSI)	+= a3000.o	wd33c93.o
 obj-$(CONFIG_A2091_SCSI)	+= a2091.o	wd33c93.o
 obj-$(CONFIG_GVP11_SCSI)	+= gvp11.o	wd33c93.o
@@ -51,8 +51,8 @@
 obj-$(CONFIG_MAC_SCSI)		+= mac_scsi.o
 obj-$(CONFIG_SCSI_MAC_ESP)	+= mac_esp.o	NCR53C9x.o
 obj-$(CONFIG_SUN3_SCSI)		+= sun3_scsi.o  sun3_scsi_vme.o
-obj-$(CONFIG_MVME16x_SCSI)	+= mvme16x.o	53c7xx.o
-obj-$(CONFIG_BVME6000_SCSI)	+= bvme6000.o	53c7xx.o
+obj-$(CONFIG_MVME16x_SCSI)	+= 53c700.o	mvme16x_scsi.o
+obj-$(CONFIG_BVME6000_SCSI)	+= 53c700.o	bvme6000_scsi.o
 obj-$(CONFIG_SCSI_SIM710)	+= 53c700.o	sim710.o
 obj-$(CONFIG_SCSI_ADVANSYS)	+= advansys.o
 obj-$(CONFIG_SCSI_PSI240I)	+= psi240i.o
@@ -170,10 +170,8 @@
 oktagon_esp_mod-objs	:= oktagon_esp.o oktagon_io.o
 
 # Files generated that shall be removed upon make clean
-clean-files :=	53c7xx_d.h 53c700_d.h	\
-		53c7xx_u.h 53c700_u.h
+clean-files :=	53c700_d.h 53c700_u.h
 
-$(obj)/53c7xx.o:   $(obj)/53c7xx_d.h $(obj)/53c7xx_u.h
 $(obj)/53c700.o $(MODVERDIR)/$(obj)/53c700.ver: $(obj)/53c700_d.h
 
 # If you want to play with the firmware, uncomment
@@ -181,11 +179,6 @@
 
 ifdef GENERATE_FIRMWARE
 
-$(obj)/53c7xx_d.h: $(src)/53c7xx.scr $(src)/script_asm.pl
-	$(CPP) -traditional -DCHIP=710 - < $< | grep -v '^#' | $(PERL) -s $(src)/script_asm.pl -ncr7x0_family $@ $(@:_d.h=_u.h)
-
-$(obj)/53c7xx_u.h: $(obj)/53c7xx_d.h
-
 $(obj)/53c700_d.h: $(src)/53c700.scr $(src)/script_asm.pl
 	$(PERL) -s $(src)/script_asm.pl -ncr7x0_family $@ $(@:_d.h=_u.h) < $<
 
Index: linux-2.6-m68k-vme/drivers/scsi/amiga7xx.c
===================================================================
RCS file: /home/linux-m68k/cvsroot/linux/drivers/scsi/amiga7xx.c,v
retrieving revision 1.11
diff -u -r1.11 amiga7xx.c
--- linux-2.6-m68k-vme/drivers/scsi/amiga7xx.c	23 Sep 2006 20:44:56 -0000	1.11
+++ linux-2.6-m68k-vme/drivers/scsi/amiga7xx.c	31 Oct 2006 21:38:49 -0000
@@ -6,143 +6,287 @@
  *
  * Written 1997 by Alan Hourihane <alanh@fairlite.demon.co.uk>
  * plus modifications of the 53c7xx.c driver to support the Amiga.
+ *
+ * Rewritten to use 53c700.c by Kars de Jong <jongk@linux-m68k.org>
  */
-#include <linux/types.h>
-#include <linux/mm.h>
+
+#include <linux/module.h>
 #include <linux/blkdev.h>
-#include <linux/sched.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/zorro.h>
-#include <linux/stat.h>
-
-#include <asm/setup.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
-#include <asm/amigaints.h>
 #include <asm/amigahw.h>
-#include <asm/dma.h>
-#include <asm/irq.h>
-
-#include "scsi.h"
+#include <asm/amigaints.h>
 #include <scsi/scsi_host.h>
-#include "53c7xx.h"
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+
+#include "53c700.h"
+
+MODULE_AUTHOR("Alan Hourihane <alanh@fairlite.demon.co.uk> / Kars de Jong <jongk@linux-m68k.org>");
+MODULE_DESCRIPTION("Amiga NCR53C710 driver");
+MODULE_LICENSE("GPL");
+
+static struct scsi_host_template amiga7xx_scsi_driver_template = {
+	.name		= "A4000T builtin SCSI",
+	.proc_name	= "Amiga7xx",
+	.this_id	= 7,
+	.module		= THIS_MODULE,
+};
 
-#ifndef CMD_PER_LUN
-#define CMD_PER_LUN 3
-#endif
+static struct platform_device *a4000t_scsi_device;
 
-#ifndef CAN_QUEUE
-#define CAN_QUEUE 24
-#endif
+#ifdef CONFIG_ZORRO
+
+static struct zorro_driver_data {
+	const char *name;
+	unsigned long offset;
+	int absolute;	/* offset is absolute address */
+} amiga7xx_driver_data[] __devinitdata = {
+	{ .name = "PowerUP 603e+", .offset = 0xf40000, .absolute = 1 },
+	{ .name = "WarpEngine 40xx", .offset = 0x40000 },
+	{ .name = "A4091", .offset = 0x800000 },
+	{ .name = "GForce 040/060", .offset = 0x40000 },
+	{ 0 }
+};
+
+static struct zorro_device_id amiga7xx_zorro_tbl[] __devinitdata = {
+	{
+		.id = ZORRO_PROD_PHASE5_BLIZZARD_603E_PLUS,
+		.driver_data = (unsigned long)&amiga7xx_driver_data[0],
+	},
+	{
+		.id = ZORRO_PROD_MACROSYSTEMS_WARP_ENGINE_40xx,
+		.driver_data = (unsigned long)&amiga7xx_driver_data[1],
+	},
+	{
+		.id = ZORRO_PROD_CBM_A4091_1,
+		.driver_data = (unsigned long)&amiga7xx_driver_data[2],
+	},
+	{
+		.id = ZORRO_PROD_CBM_A4091_2,
+		.driver_data = (unsigned long)&amiga7xx_driver_data[2],
+	},
+	{
+		.id = ZORRO_PROD_GVP_GFORCE_040_060,
+		.driver_data = (unsigned long)&amiga7xx_driver_data[3],
+	},
+	{ 0 }
+};
 
-static int amiga7xx_register_one(struct scsi_host_template *tpnt,
-				 unsigned long address)
+static int __devinit amiga7xx_init_one(struct zorro_dev *z,
+				   const struct zorro_device_id *ent)
 {
-    long long options;
-    int clock;
+	struct Scsi_Host * host = NULL;
+	struct NCR_700_Host_Parameters *hostdata;
+	struct zorro_driver_data *zdd;
+	unsigned long board, ioaddr;
+
+	board = zorro_resource_start(z);
+	zdd = (struct zorro_driver_data *)ent->driver_data;
+
+	if (zdd->absolute) {
+		ioaddr = zdd->offset;
+	} else {
+		ioaddr = board + zdd->offset;
+	}
+
+	if (!zorro_request_device(z, zdd->name)) {
+		printk(KERN_ERR "amiga7xx: cannot reserve region 0x%lx, abort\n",
+		       board);
+		return -EBUSY;
+	}
+
+	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+
+	if (hostdata == NULL) {
+		printk(KERN_ERR "amiga7xx: Failed to allocate host data\n");
+		goto out_release;
+	}
+
+	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+
+	/* Fill in the required pieces of hostdata */
+	if (ioaddr > 0x01000000)
+		hostdata->base = ioremap(ioaddr, zorro_resource_len(z));
+	else
+		hostdata->base = (void __iomem *)ZTWO_VADDR(ioaddr);
 
-    if (!request_mem_region(address, 0x1000, "ncr53c710"))
-	return 0;
+	hostdata->clock = 50;
+	hostdata->chip710 = 1;
 
-    address = (unsigned long)z_ioremap(address, 0x1000);
-    options = OPTION_MEMORY_MAPPED | OPTION_DEBUG_TEST1 | OPTION_INTFLY |
-	      OPTION_SYNCHRONOUS | OPTION_ALWAYS_SYNCHRONOUS |
-	      OPTION_DISCONNECT;
-    clock = 50000000;	/* 50 MHz SCSI Clock */
-    ncr53c7xx_init(tpnt, 0, 710, address, 0, IRQ_AMIGA_PORTS, DMA_NONE,
-		   options, clock);
-    return 1;
-}
+	/* Settings for at least WarpEngine 40xx */
+	hostdata->ctest7_extra = CTEST7_TT1;
 
+	amiga7xx_scsi_driver_template.name = zdd->name;
 
-#ifdef CONFIG_ZORRO
+	/* and register the chip */
+	if ((host = NCR_700_detect(&amiga7xx_scsi_driver_template, hostdata, &z->dev))
+	   == NULL) {
+		printk(KERN_ERR "amiga7xx-scsi: No host detected; board configuration problem?\n");
+		goto out_free;
+	}
 
-static struct {
-    zorro_id id;
-    unsigned long offset;
-    int absolute;	/* offset is absolute address */
-} amiga7xx_table[] = {
-    { .id = ZORRO_PROD_PHASE5_BLIZZARD_603E_PLUS, .offset = 0xf40000,
-      .absolute = 1 },
-    { .id = ZORRO_PROD_MACROSYSTEMS_WARP_ENGINE_40xx, .offset = 0x40000 },
-    { .id = ZORRO_PROD_CBM_A4091_1, .offset = 0x800000 },
-    { .id = ZORRO_PROD_CBM_A4091_2, .offset = 0x800000 },
-    { .id = ZORRO_PROD_GVP_GFORCE_040_060, .offset = 0x40000 },
-    { 0 }
-};
+	host->this_id = 7;
+	host->base = ioaddr;
+	host->irq = IRQ_AMIGA_PORTS;
 
-static int __init amiga7xx_zorro_detect(struct scsi_host_template *tpnt)
+	if (request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "amiga7xx-scsi", host)) {
+		printk(KERN_ERR "amiga7xx-scsi: request_irq failed\n");
+		goto out_put_host;
+	}
+
+	scsi_scan_host(host);
+
+	return 0;
+
+ out_put_host:
+	scsi_host_put(host);
+ out_free:
+	if (ioaddr > 0x01000000)
+		iounmap(hostdata->base);
+	kfree(hostdata);
+ out_release:
+	zorro_release_device(z);
+
+	return -ENODEV;
+}
+
+static __devexit void amiga7xx_remove_one(struct zorro_dev *z)
 {
-    int num = 0, i;
-    struct zorro_dev *z = NULL;
-    unsigned long address;
-
-    while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
-	for (i = 0; amiga7xx_table[i].id; i++)
-	    if (z->id == amiga7xx_table[i].id)
-		break;
-	if (!amiga7xx_table[i].id)
-	    continue;
-	if (amiga7xx_table[i].absolute)
-	    address = amiga7xx_table[i].offset;
-	else
-	    address = z->resource.start + amiga7xx_table[i].offset;
-	num += amiga7xx_register_one(tpnt, address);
-    }
-    return num;
+	struct Scsi_Host *host = dev_to_shost(&z->dev);
+	struct NCR_700_Host_Parameters *hostdata =
+		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+
+	scsi_remove_host(host);
+
+	NCR_700_release(host);
+	kfree(hostdata);
+	free_irq(host->irq, host);
+	zorro_release_device(z);
 }
 
+static struct zorro_driver amiga7xx_driver = {
+	.name	  = "amiga7xx-scsi",
+	.id_table = amiga7xx_zorro_tbl,
+	.probe	  = amiga7xx_init_one,
+	.remove	  = __devexit_p(amiga7xx_remove_one),
+};
+
 #endif /* CONFIG_ZORRO */
 
+#define A4000T_SCSI_ADDR 0xdd0040
 
-int __init amiga7xx_detect(struct scsi_host_template *tpnt)
+static int __devinit a4000t_probe(struct device *dev)
 {
-    static unsigned char called = 0;
-    int num = 0;
+	struct Scsi_Host * host = NULL;
+	struct NCR_700_Host_Parameters *hostdata;
+
+	if (!(MACH_IS_AMIGA && AMIGAHW_PRESENT(A4000_SCSI)))
+		goto out;
+	
+	if (!request_mem_region(A4000T_SCSI_ADDR, 0x1000, "A4000T builtin SCSI"))
+		goto out;
+
+	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (hostdata == NULL) {
+		printk(KERN_ERR "a4000t-scsi: Failed to allocate host data\n");
+		goto out_release;
+	}
+	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+
+	/* Fill in the required pieces of hostdata */
+	hostdata->base = (void __iomem *)ZTWO_VADDR(A4000T_SCSI_ADDR);
+	hostdata->clock = 50;
+	hostdata->chip710 = 1;
+	hostdata->dmode_extra = DMODE_FC2;
+	hostdata->dcntl_extra = EA_710;
+
+	/* and register the chip */
+	if ((host = NCR_700_detect(&amiga7xx_scsi_driver_template, hostdata, dev))
+	   == NULL) {
+		printk(KERN_ERR "a4000t-scsi: No host detected; board configuration problem?\n");
+		goto out_free;
+	}
+
+	host->this_id = 7;
+	host->base = A4000T_SCSI_ADDR;
+	host->irq = IRQ_AMIGA_PORTS;
+
+	if (request_irq(host->irq, NCR_700_intr, IRQF_SHARED, "a4000t-scsi", host)) {
+		printk(KERN_ERR "a4000t-scsi: request_irq failed\n");
+		goto out_put_host;
+	}
+
+	scsi_scan_host(host);
 
-    if (called || !MACH_IS_AMIGA)
 	return 0;
 
-    tpnt->proc_name = "Amiga7xx";
+ out_put_host:
+	scsi_host_put(host);
+ out_free:
+	kfree(hostdata);
+ out_release:
+	release_mem_region(A4000T_SCSI_ADDR, 0x1000);
+ out:
+	return -ENODEV;
+}
+
+static __devexit int a4000t_device_remove(struct device *dev)
+{
+	struct Scsi_Host *host = dev_to_shost(dev);
+	struct NCR_700_Host_Parameters *hostdata =
+		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+
+	scsi_remove_host(host);
+
+	NCR_700_release(host);
+	kfree(hostdata);
+	free_irq(host->irq, host);
+	release_mem_region(A4000T_SCSI_ADDR, 0x1000);
 
-    if (AMIGAHW_PRESENT(A4000_SCSI))
-	num += amiga7xx_register_one(tpnt, 0xdd0040);
+	return 0;
+}
+
+static struct device_driver a4000t_scsi_driver = {
+	.name	= "a4000t-scsi",
+	.bus	= &platform_bus_type,
+	.probe	= a4000t_probe,
+	.remove	= __devexit_p(a4000t_device_remove),
+};
+
+static int __init amiga7xx_scsi_init(void)
+{
+	int err;
+
+	if ((err = driver_register(&a4000t_scsi_driver)))
+		return err;
+
+	a4000t_scsi_device = platform_device_register_simple("a4000t-scsi", -1, NULL, 0);
+
+	if (IS_ERR(a4000t_scsi_device)) {
+		driver_unregister(&a4000t_scsi_driver);
+		return PTR_ERR(a4000t_scsi_device);
+	}
 
 #ifdef CONFIG_ZORRO
-    num += amiga7xx_zorro_detect(tpnt);
+	err = zorro_module_init(&amiga7xx_driver);
 #endif
 
-    called = 1;
-    return num;
+	return err;
 }
 
-static int amiga7xx_release(struct Scsi_Host *shost)
+static void __exit amiga7xx_scsi_exit(void)
 {
-	if (shost->irq)
-		free_irq(shost->irq, NULL);
-#ifdef CONFIG_ISA
-	if (shost->dma_channel != 0xff)
-		free_dma(shost->dma_channel);
+	platform_device_unregister(a4000t_scsi_device);
+	driver_unregister(&a4000t_scsi_driver);
+#ifdef CONFIG_ZORRO
+	zorro_unregister_driver(&amiga7xx_driver);
 #endif
-	if (shost->io_port && shost->n_io_port)
-		release_region(shost->io_port, shost->n_io_port);
-	scsi_unregister(shost);
-	return 0;
 }
 
-static struct scsi_host_template driver_template = {
-	.name			= "Amiga NCR53c710 SCSI",
-	.detect			= amiga7xx_detect,
-	.release		= amiga7xx_release,
-	.queuecommand		= NCR53c7xx_queue_command,
-	.eh_abort_handler	= NCR53c7xx_abort,
-	.eh_bus_reset_handler	= NCR53c7xx_reset,
-	.slave_configure	= NCR53c7xx_slave_configure,
-	.can_queue		= 24,
-	.this_id		= 7,
-	.sg_tablesize		= 63,
-	.cmd_per_lun		= 3,
-	.use_clustering		= DISABLE_CLUSTERING
-};
-
-
-#include "scsi_module.c"
+module_init(amiga7xx_scsi_init);
+module_exit(amiga7xx_scsi_exit);
Index: linux-2.6-m68k-vme/drivers/scsi/bvme6000_scsi.c
===================================================================
RCS file: linux-2.6-m68k-vme/drivers/scsi/bvme6000_scsi.c
diff -N linux-2.6-m68k-vme/drivers/scsi/bvme6000_scsi.c
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ linux-2.6-m68k-vme/drivers/scsi/bvme6000_scsi.c	31 Oct 2006 21:38:49 -0000
@@ -0,0 +1,132 @@
+/*
+ * Detection routine for the NCR53c710 based BVME6000 SCSI Controllers for Linux.
+ *
+ * Based on work by Alan Hourihane and Kars de Jong
+ *
+ * Rewritten to use 53c700.c by Richard Hirst <richard@sleepie.demon.co.uk>
+ */
+
+#include <linux/module.h>
+#include <linux/blkdev.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <asm/bvme6000hw.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+
+#include "53c700.h"
+
+MODULE_AUTHOR("Richard Hirst <richard@sleepie.demon.co.uk>");
+MODULE_DESCRIPTION("BVME6000 NCR53C710 driver");
+MODULE_LICENSE("GPL");
+
+static struct scsi_host_template bvme6000_scsi_driver_template = {
+	.name			= "BVME6000 NCR53c710 SCSI",
+	.proc_name		= "BVME6000",
+	.this_id		= 7,
+	.module			= THIS_MODULE,
+};
+
+static struct platform_device *bvme6000_scsi_device;
+
+static __devinit int
+bvme6000_probe(struct device *dev)
+{
+	struct Scsi_Host * host = NULL;
+	struct NCR_700_Host_Parameters *hostdata;
+
+	if (!MACH_IS_BVME6000)
+		goto out;
+
+	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (hostdata == NULL) {
+		printk(KERN_ERR "bvme6000-scsi: Failed to allocate host data\n");
+		goto out;
+	}
+	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+
+	/* Fill in the required pieces of hostdata */
+	hostdata->base = (void __iomem *)BVME_NCR53C710_BASE;
+	hostdata->clock = 40;	/* XXX - depends on the CPU clock! */
+	hostdata->chip710 = 1;
+	hostdata->dmode_extra = DMODE_FC2;
+	hostdata->dcntl_extra = EA_710;
+	hostdata->ctest7_extra = CTEST7_TT1;
+
+	/* and register the chip */
+	if ((host = NCR_700_detect(&bvme6000_scsi_driver_template, hostdata, dev))
+	   == NULL) {
+		printk(KERN_ERR "bvme6000-scsi: No host detected; board configuration problem?\n");
+		goto out_free;
+	}
+	host->base = BVME_NCR53C710_BASE;
+	host->this_id = 7;
+	host->irq = BVME_IRQ_SCSI;
+	if (request_irq(BVME_IRQ_SCSI, NCR_700_intr, 0, "bvme6000-scsi", host)) {
+		printk(KERN_ERR "bvme6000-scsi: request_irq failed\n");
+		goto out_put_host;
+	}
+
+	scsi_scan_host(host);
+
+	return 0;
+
+ out_put_host:
+	scsi_host_put(host);
+ out_free:
+	kfree(hostdata);
+ out:
+	return -ENODEV;
+}
+
+static __devexit int
+bvme6000_device_remove(struct device *dev)
+{
+	struct Scsi_Host *host = dev_to_shost(dev);
+	struct NCR_700_Host_Parameters *hostdata =
+		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+
+	scsi_remove_host(host);
+	NCR_700_release(host);
+	kfree(hostdata);
+	free_irq(host->irq, host);
+
+	return 0;
+}
+
+static struct device_driver bvme6000_scsi_driver = {
+	.name	= "bvme6000-scsi",
+	.bus	= &platform_bus_type,
+	.probe	= bvme6000_probe,
+	.remove	= __devexit_p(bvme6000_device_remove),
+};
+
+static int __init bvme6000_scsi_init(void)
+{
+	int err;
+
+	if ((err = driver_register(&bvme6000_scsi_driver)))
+		return err;
+
+	bvme6000_scsi_device = platform_device_register_simple("bvme6000-scsi", -1, NULL, 0);
+
+	if (IS_ERR(bvme6000_scsi_device)) {
+		driver_unregister(&bvme6000_scsi_driver);
+		return PTR_ERR(bvme6000_scsi_device);
+	}
+
+	return 0;
+}
+
+static void __exit bvme6000_scsi_exit(void)
+{
+	platform_device_unregister(bvme6000_scsi_device);
+	driver_unregister(&bvme6000_scsi_driver);
+}
+
+module_init(bvme6000_scsi_init);
+module_exit(bvme6000_scsi_exit);
Index: linux-2.6-m68k-vme/drivers/scsi/mvme16x_scsi.c
===================================================================
RCS file: linux-2.6-m68k-vme/drivers/scsi/mvme16x_scsi.c
diff -N linux-2.6-m68k-vme/drivers/scsi/mvme16x_scsi.c
--- /dev/null	1 Jan 1970 00:00:00 -0000
+++ linux-2.6-m68k-vme/drivers/scsi/mvme16x_scsi.c	31 Oct 2006 21:38:49 -0000
@@ -0,0 +1,155 @@
+/*
+ * Detection routine for the NCR53c710 based MVME16x SCSI Controllers for Linux.
+ *
+ * Based on work by Alan Hourihane
+ *
+ * Rewritten to use 53c700.c by Kars de Jong <jongk@linux-m68k.org>
+ */
+
+#include <linux/module.h>
+#include <linux/blkdev.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <asm/mvme16xhw.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
+
+#include "53c700.h"
+
+MODULE_AUTHOR("Kars de Jong <jongk@linux-m68k.org>");
+MODULE_DESCRIPTION("MVME16x NCR53C710 driver");
+MODULE_LICENSE("GPL");
+
+static struct scsi_host_template mvme16x_scsi_driver_template = {
+	.name			= "MVME16x NCR53c710 SCSI",
+	.proc_name		= "MVME16x",
+	.this_id		= 7,
+	.module			= THIS_MODULE,
+};
+
+static struct platform_device *mvme16x_scsi_device;
+
+static __devinit int
+mvme16x_probe(struct device *dev)
+{
+	struct Scsi_Host * host = NULL;
+	struct NCR_700_Host_Parameters *hostdata;
+
+	if (!MACH_IS_MVME16x)
+		goto out;
+
+	if (mvme16x_config & MVME16x_CONFIG_NO_SCSICHIP) {
+		printk(KERN_INFO "mvme16x-scsi: detection disabled, SCSI chip not present\n");
+		goto out;
+	}
+
+	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (hostdata == NULL) {
+		printk(KERN_ERR "mvme16x-scsi: Failed to allocate host data\n");
+		goto out;
+	}
+	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
+
+	/* Fill in the required pieces of hostdata */
+	hostdata->base = (void __iomem *)0xfff47000UL;
+	hostdata->clock = 50;	/* XXX - depends on the CPU clock! */
+	hostdata->chip710 = 1;
+	hostdata->dmode_extra = DMODE_FC2;
+	hostdata->dcntl_extra = EA_710;
+	hostdata->ctest7_extra = CTEST7_TT1;
+
+	/* and register the chip */
+	if ((host = NCR_700_detect(&mvme16x_scsi_driver_template, hostdata, dev))
+	   == NULL) {
+		printk(KERN_ERR "mvme16x-scsi: No host detected; board configuration problem?\n");
+		goto out_free;
+	}
+	host->this_id = 7;
+	host->base = 0xfff47000UL;
+	host->irq = MVME16x_IRQ_SCSI;
+	if (request_irq(host->irq, NCR_700_intr, 0, "mvme16x-scsi", host)) {
+		printk(KERN_ERR "mvme16x-scsi: request_irq failed\n");
+		goto out_put_host;
+	}
+
+	/* Enable scsi chip ints */
+	{
+		volatile unsigned long v;
+
+		/* Enable scsi interrupts at level 4 in PCCchip2 */
+		v = in_be32(0xfff4202c);
+		v = (v & ~0xff) | 0x10 | 4;
+		out_be32(0xfff4202c, v);
+	}
+
+	scsi_scan_host(host);
+
+	return 0;
+
+ out_put_host:
+	scsi_host_put(host);
+ out_free:
+	kfree(hostdata);
+ out:
+	return -ENODEV;
+}
+
+static __devexit int
+mvme16x_device_remove(struct device *dev)
+{
+	struct Scsi_Host *host = dev_to_shost(dev);
+	struct NCR_700_Host_Parameters *hostdata =
+		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+
+	/* Disable scsi chip ints */
+	{
+		volatile unsigned long v;
+
+		v = in_be32(0xfff4202c);
+		v &= ~0x10;
+		out_be32(0xfff4202c, v);
+	}
+	scsi_remove_host(host);
+	NCR_700_release(host);
+	kfree(hostdata);
+	free_irq(host->irq, host);
+
+	return 0;
+}
+
+static struct device_driver mvme16x_scsi_driver = {
+	.name	= "mvme16x-scsi",
+	.bus	= &platform_bus_type,
+	.probe	= mvme16x_probe,
+	.remove	= __devexit_p(mvme16x_device_remove),
+};
+
+static int __init mvme16x_scsi_init(void)
+{
+	int err;
+
+	if ((err = driver_register(&mvme16x_scsi_driver)))
+		return err;
+
+	mvme16x_scsi_device = platform_device_register_simple("mvme16x-scsi", -1, NULL, 0);
+
+	if (IS_ERR(mvme16x_scsi_device)) {
+		driver_unregister(&mvme16x_scsi_driver);
+		return PTR_ERR(mvme16x_scsi_device);
+	}
+
+	return 0;
+}
+
+static void __exit mvme16x_scsi_exit(void)
+{
+	platform_device_unregister(mvme16x_scsi_device);
+	driver_unregister(&mvme16x_scsi_driver);
+}
+
+module_init(mvme16x_scsi_init);
+module_exit(mvme16x_scsi_exit);


