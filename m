From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 01/22] g_ncr5380: Remove CONFIG_SCSI_GENERIC_NCR53C400
Date: Wed, 16 Mar 2016 14:18:42 +1100
Message-ID: <20160316031842.171665501@telegraphics.com.au>
References: <20160316031841.911913894@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=g_NCR5380-remove-CONFIG_SCSI_GENERIC_NCR53C400
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

This change brings a number of improvements: fewer macros, better test
coverage, simpler code and sane Kconfig options. The downside is a small
chance of incompatibility (which seems unavoidable).

CONFIG_SCSI_GENERIC_NCR53C400 exists to enable or inhibit pseudo DMA
transfers when the driver is used with 53C400-compatible cards. Thanks to
Ondrej Zary's patches, PDMA now works which means it can be enabled
unconditionally.

Due to bad design, CONFIG_SCSI_GENERIC_NCR53C400 ties together unrelated
functionality as it sets both PSEUDO_DMA and BIOSPARAM macros. This patch
effectively enables PSEUDO_DMA and disables BIOSPARAM.

The defconfigs and the Kconfig default leave CONFIG_SCSI_GENERIC_NCR53C400
undefined. Red Hat 9 and CentOS 2.1 were the same. This leaves both
PSEUDO_DMA and BIOSPARAM disabled. The effect of this patch should be
better performance from enabling PSEUDO_DMA.

On the other hand, Debian 4 and SLES 10 had CONFIG_SCSI_GENERIC_NCR53C400
enabled, so both PSEUDO_DMA and BIOSPARAM were enabled. This patch might
affect configurations like this by disabling BIOSPARAM. My best guess is
that this could be a problem only in the vanishingly rare case that
1) the CHS values stored in the boot device partition table are wrong and
2) a 5380 card is in use (because PDMA on 53C400 used to be broken).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---

Here are the distro kernel versions I looked at:

CentOS 2.1:

$ strings kernel-2.4.9-e.40.i686/lib/modules/2.4.9-e.40/kernel/drivers/scsi/g_NCR5380.o | grep extension
NO NCR53C400 driver extensions


Red Hat 7:

$ strings kernel-2.4.18-3.i386/lib/modules/2.4.18-3/kernel/drivers/scsi/g_NCR5380.o | grep extension
NO NCR53C400 driver extensions


Red Hat 9:

$ strings kernel-2.4.20-8.i586/lib/modules/2.4.20-8/kernel/drivers/scsi/g_NCR5380.o | grep extension
NO NCR53C400 driver extensions


Debian 4:

$ strings linux-image-2.6.24-etchnhalf.1-486_2.6.24-6-etchnhalf.9etch3_i386/lib/modules/2.6.24-etchnhalf.1-486/kernel/drivers/scsi/g_NCR5380_mmio.ko | grep extension
NCR53C400 extension version %d
$ strings kernel-image-2.6.8-2-386_2.6.8-13_i386/lib/modules/2.6.8-2-386/kernel/drivers/scsi/g_NCR5380_mmio.ko | grep extension
NCR53C400 extension version %d


SLES 10.2:

$ strings kernel-default-2.6.18.2-34.i586/lib/modules/2.6.18.2-34-default/kernel/drivers/scsi/g_NCR5380_mmio.ko | grep extension
NCR53C400 extension version %d

---
 drivers/scsi/Kconfig     |   11 ------
 drivers/scsi/g_NCR5380.c |   75 ++++++++++++++---------------------------------
 drivers/scsi/g_NCR5380.h |   16 +---------
 3 files changed, 25 insertions(+), 77 deletions(-)

Index: linux/drivers/scsi/Kconfig
===================================================================
--- linux.orig/drivers/scsi/Kconfig	2016-03-16 14:16:56.000000000 +1100
+++ linux/drivers/scsi/Kconfig	2016-03-16 14:18:01.000000000 +1100
@@ -812,17 +812,6 @@ config SCSI_GENERIC_NCR5380_MMIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called g_NCR5380_mmio.
 
-config SCSI_GENERIC_NCR53C400
-	bool "Enable NCR53c400 extensions"
-	depends on SCSI_GENERIC_NCR5380
-	help
-	  This enables certain optimizations for the NCR53c400 SCSI cards.
-	  You might as well try it out.  Note that this driver will only probe
-	  for the Trantor T130B in its default configuration; you might have
-	  to pass a command line option to the kernel at boot time if it does
-	  not detect your card.  See the file
-	  <file:Documentation/scsi/g_NCR5380.txt> for details.
-
 config SCSI_IPS
 	tristate "IBM ServeRAID support"
 	depends on PCI && SCSI
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-03-16 14:16:56.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-03-16 14:18:01.000000000 +1100
@@ -57,10 +57,7 @@
  */
 
 #define AUTOPROBE_IRQ
-
-#ifdef CONFIG_SCSI_GENERIC_NCR53C400
 #define PSEUDO_DMA
-#endif
 
 #include <asm/io.h>
 #include <linux/blkdev.h>
@@ -270,7 +267,7 @@ static int __init generic_NCR5380_detect
 #ifndef SCSI_G_NCR5380_MEM
 	int i;
 	int port_idx = -1;
-	unsigned long region_size = 16;
+	unsigned long region_size;
 #endif
 	static unsigned int __initdata ncr_53c400a_ports[] = {
 		0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
@@ -290,6 +287,7 @@ static int __init generic_NCR5380_detect
 #ifdef SCSI_G_NCR5380_MEM
 	unsigned long base;
 	void __iomem *iomem;
+	resource_size_t iomem_size;
 #endif
 
 	if (ncr_irq)
@@ -353,9 +351,7 @@ static int __init generic_NCR5380_detect
 			flags = FLAG_NO_PSEUDO_DMA;
 			break;
 		case BOARD_NCR53C400:
-#ifdef PSEUDO_DMA
 			flags = FLAG_NO_DMA_FIXUP;
-#endif
 			break;
 		case BOARD_NCR53C400A:
 			flags = FLAG_NO_DMA_FIXUP;
@@ -381,20 +377,22 @@ static int __init generic_NCR5380_detect
 			/* Disable the adapter and look for a free io port */
 			magic_configure(-1, 0, magic);
 
+			region_size = 16;
+
 			if (overrides[current_override].NCR5380_map_name != PORT_AUTO)
 				for (i = 0; ports[i]; i++) {
-					if (!request_region(ports[i],  16, "ncr53c80"))
+					if (!request_region(ports[i], region_size, "ncr53c80"))
 						continue;
 					if (overrides[current_override].NCR5380_map_name == ports[i])
 						break;
-					release_region(ports[i], 16);
+					release_region(ports[i], region_size);
 			} else
 				for (i = 0; ports[i]; i++) {
-					if (!request_region(ports[i],  16, "ncr53c80"))
+					if (!request_region(ports[i], region_size, "ncr53c80"))
 						continue;
 					if (inb(ports[i]) == 0xff)
 						break;
-					release_region(ports[i], 16);
+					release_region(ports[i], region_size);
 				}
 			if (ports[i]) {
 				/* At this point we have our region reserved */
@@ -410,17 +408,19 @@ static int __init generic_NCR5380_detect
 		else
 		{
 			/* Not a 53C400A style setup - just grab */
-			if(!(request_region(overrides[current_override].NCR5380_map_name, NCR5380_region_size, "ncr5380")))
+			region_size = 8;
+			if (!request_region(overrides[current_override].NCR5380_map_name,
+			                    region_size, "ncr5380"))
 				continue;
-			region_size = NCR5380_region_size;
 		}
 #else
 		base = overrides[current_override].NCR5380_map_name;
-		if (!request_mem_region(base, NCR5380_region_size, "ncr5380"))
+		iomem_size = NCR53C400_region_size;
+		if (!request_mem_region(base, iomem_size, "ncr5380"))
 			continue;
-		iomem = ioremap(base, NCR5380_region_size);
+		iomem = ioremap(base, iomem_size);
 		if (!iomem) {
-			release_mem_region(base, NCR5380_region_size);
+			release_mem_region(base, iomem_size);
 			continue;
 		}
 #endif
@@ -458,6 +458,7 @@ static int __init generic_NCR5380_detect
 #else
 		instance->base = overrides[current_override].NCR5380_map_name;
 		hostdata->iomem = iomem;
+		hostdata->iomem_size = iomem_size;
 		switch (overrides[current_override].board) {
 		case BOARD_NCR53C400:
 			hostdata->c400_ctl_status = 0x100;
@@ -524,7 +525,7 @@ out_release:
 	release_region(overrides[current_override].NCR5380_map_name, region_size);
 #else
 	iounmap(iomem);
-	release_mem_region(base, NCR5380_region_size);
+	release_mem_region(base, iomem_size);
 #endif
 	return count;
 }
@@ -546,42 +547,15 @@ static int generic_NCR5380_release_resou
 #ifndef SCSI_G_NCR5380_MEM
 	release_region(instance->io_port, instance->n_io_port);
 #else
-	iounmap(((struct NCR5380_hostdata *)instance->hostdata)->iomem);
-	release_mem_region(instance->base, NCR5380_region_size);
-#endif
-	return 0;
-}
+	{
+		struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
-#ifdef BIOSPARAM
-/**
- *	generic_NCR5380_biosparam
- *	@disk: disk to compute geometry for
- *	@dev: device identifier for this disk
- *	@ip: sizes to fill in
- *
- *	Generates a BIOS / DOS compatible H-C-S mapping for the specified 
- *	device / size.
- * 
- * 	XXX Most SCSI boards use this mapping, I could be incorrect.  Someone
- *	using hard disks on a trantor should verify that this mapping
- *	corresponds to that used by the BIOS / ASPI driver by running the linux
- *	fdisk program and matching the H_C_S coordinates to what DOS uses.
- *
- *	Locks: none
- */
-
-static int
-generic_NCR5380_biosparam(struct scsi_device *sdev, struct block_device *bdev,
-			  sector_t capacity, int *ip)
-{
-	ip[0] = 64;
-	ip[1] = 32;
-	ip[2] = capacity >> 11;
+		iounmap(hostdata->iomem);
+		release_mem_region(instance->base, hostdata->iomem_size);
+	}
+#endif
 	return 0;
 }
-#endif
-
-#ifdef PSEUDO_DMA
 
 /**
  *	NCR5380_pread		-	pseudo DMA read
@@ -756,8 +730,6 @@ static int generic_NCR5380_dma_xfer_len(
 	return transfersize;
 }
 
-#endif /* PSEUDO_DMA */
-
 /*
  *	Include the NCR5380 core code that we build our driver around	
  */
@@ -773,7 +745,6 @@ static struct scsi_host_template driver_
 	.queuecommand		= generic_NCR5380_queue_command,
 	.eh_abort_handler	= generic_NCR5380_abort,
 	.eh_bus_reset_handler	= generic_NCR5380_bus_reset,
-	.bios_param		= NCR5380_BIOSPARAM,
 	.can_queue		= 16,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-03-16 14:16:56.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-03-16 14:18:01.000000000 +1100
@@ -14,13 +14,6 @@
 #ifndef GENERIC_NCR5380_H
 #define GENERIC_NCR5380_H
 
-#ifdef CONFIG_SCSI_GENERIC_NCR53C400
-#define BIOSPARAM
-#define NCR5380_BIOSPARAM generic_NCR5380_biosparam
-#else
-#define NCR5380_BIOSPARAM NULL
-#endif
-
 #define __STRVAL(x) #x
 #define STRVAL(x) __STRVAL(x)
 
@@ -30,12 +23,6 @@
 #define NCR5380_map_type int
 #define NCR5380_map_name port
 
-#ifdef CONFIG_SCSI_GENERIC_NCR53C400
-#define NCR5380_region_size 16
-#else
-#define NCR5380_region_size 8
-#endif
-
 #define NCR5380_read(reg) \
 	inb(instance->io_port + (reg))
 #define NCR5380_write(reg, value) \
@@ -55,7 +42,7 @@
 #define NCR5380_map_name base
 #define NCR53C400_mem_base 0x3880
 #define NCR53C400_host_buffer 0x3900
-#define NCR5380_region_size 0x3a00
+#define NCR53C400_region_size 0x3a00
 
 #define NCR5380_read(reg) \
 	readb(((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
@@ -66,6 +53,7 @@
 
 #define NCR5380_implementation_fields \
 	void __iomem *iomem; \
+	resource_size_t iomem_size; \
 	int c400_ctl_status; \
 	int c400_blk_cnt; \
 	int c400_host_buf;
