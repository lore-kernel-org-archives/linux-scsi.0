From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/7] dtc: remove from tree
Date: Mon, 19 Sep 2016 08:50:53 -0700
Message-ID: <1474300253-31351-8-git-send-email-hch@lst.de>
References: <1474300253-31351-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41635 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbcISPvj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 11:51:39 -0400
In-Reply-To: <1474300253-31351-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: schmitzmic@gmail.com, linux@rainbow-software.org, fthain@telegraphics.com.au

The driver has not seen any maintainer activity or other work that
wasn't tree wide conversion or clenaups in the entire history of
the git tree.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/scsi/dtc3x80.txt         |  43 ----
 Documentation/scsi/scsi-parameters.txt |   3 -
 MAINTAINERS                            |   2 -
 drivers/scsi/Kconfig                   |  14 --
 drivers/scsi/Makefile                  |   1 -
 drivers/scsi/dtc.c                     | 447 ---------------------------------
 drivers/scsi/dtc.h                     |  42 ----
 7 files changed, 552 deletions(-)
 delete mode 100644 Documentation/scsi/dtc3x80.txt
 delete mode 100644 drivers/scsi/dtc.c
 delete mode 100644 drivers/scsi/dtc.h

diff --git a/Documentation/scsi/dtc3x80.txt b/Documentation/scsi/dtc3x80.txt
deleted file mode 100644
index 1d7af9f..0000000
--- a/Documentation/scsi/dtc3x80.txt
+++ /dev/null
@@ -1,43 +0,0 @@
-README file for the Linux DTC3180/3280 scsi driver.
-by Ray Van Tassle (rayvt@comm.mot.com)  March 1996
-Based on the generic & core NCR5380 code by Drew Eckhard
-
-SCSI device driver for the DTC 3180/3280.
-Data Technology Corp---a division of Qume.
-
-The 3280 has a standard floppy interface.
-
-The 3180 does not.  Otherwise, they are identical.
-
-The DTC3x80 does not support DMA but it does have Pseudo-DMA which is
-supported by the driver.
-
-Its DTC406 scsi chip is supposedly compatible with the NCR 53C400.
-It is memory mapped, uses an IRQ, but no dma or io-port.  There is
-internal DMA, between SCSI bus and an on-chip 128-byte buffer.  Double
-buffering is done automagically by the chip.  Data is transferred
-between the on-chip buffer and CPU/RAM via memory moves.
-
-The driver detects the possible memory addresses (jumper selectable):
-	CC00, DC00, C800, and D800
-The possible IRQ's (jumper selectable) are:
-	IRQ 10, 11, 12, 15
-Parity is supported by the chip, but not by this driver.
-Information can be obtained from /proc/scsi/dtc3c80/N.
-
-Note on interrupts:
-
-The documentation says that it can be set to interrupt whenever the
-on-chip buffer needs CPU attention.  I couldn't get this to work.  So
-the driver polls for data-ready in the pseudo-DMA transfer routine.
-The interrupt support routines in the NCR3280.c core modules handle
-scsi disconnect/reconnect, and this (mostly) works.  However.....  I
-have tested it with 4 totally different hard drives (both SCSI-1 and
-SCSI-2), and one CDROM drive.  Interrupts works great for all but one
-specific hard drive.  For this one, the driver will eventually hang in
-the transfer state.  I have tested with: "dd bs=4k count=2k
-of=/dev/null if=/dev/sdb".  It reads ok for a while, then hangs.
-After beating my head against this for a couple of weeks, getting
-nowhere, I give up.  So.....This driver does NOT use interrupts, even
-if you have the card jumpered to an IRQ.  Probably nobody will ever
-care.
diff --git a/Documentation/scsi/scsi-parameters.txt b/Documentation/scsi/scsi-parameters.txt
index 00a03c0..8e66daf 100644
--- a/Documentation/scsi/scsi-parameters.txt
+++ b/Documentation/scsi/scsi-parameters.txt
@@ -34,9 +34,6 @@ parameters may be changed at runtime by the command
 			See drivers/scsi/BusLogic.c, comment before function
 			BusLogic_ParseDriverOptions().
 
-	dtc3181e=	[HW,SCSI]
-			See Documentation/scsi/g_NCR5380.txt.
-
 	eata=		[HW,SCSI]
 
 	fdomain=	[HW,SCSI]
diff --git a/MAINTAINERS b/MAINTAINERS
index e4ec1b8..48f2b48 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8042,13 +8042,11 @@ M:	Michael Schmitz <schmitzmic@gmail.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/g_NCR5380.txt
-F:	Documentation/scsi/dtc3x80.txt
 F:	drivers/scsi/NCR5380.*
 F:	drivers/scsi/arm/cumana_1.c
 F:	drivers/scsi/arm/oak.c
 F:	drivers/scsi/atari_scsi.*
 F:	drivers/scsi/dmx3191d.c
-F:	drivers/scsi/dtc.*
 F:	drivers/scsi/g_NCR5380.*
 F:	drivers/scsi/g_NCR5380_mmio.c
 F:	drivers/scsi/mac_scsi.*
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a38e37c..3e2bdb9 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -637,20 +637,6 @@ config SCSI_DMX3191D
 	  To compile this driver as a module, choose M here: the
 	  module will be called dmx3191d.
 
-config SCSI_DTC3280
-	tristate "DTC3180/3280 SCSI support"
-	depends on ISA && SCSI
-	select SCSI_SPI_ATTRS
-	select CHECK_SIGNATURE
-	help
-	  This is support for DTC 3180/3280 SCSI Host Adapters.  Please read
-	  the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, and the file
-	  <file:Documentation/scsi/dtc3x80.txt>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called dtc.
-
 config SCSI_EATA
 	tristate "EATA ISA/EISA/PCI (DPT and generic EATA/DMA-compliant boards) support"
 	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 392609a..38d938d 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -90,7 +90,6 @@ obj-$(CONFIG_SCSI_CHELSIO_FCOE)	+= csiostor/
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
 obj-$(CONFIG_SCSI_HPSA)		+= hpsa.o
 obj-$(CONFIG_SCSI_SMARTPQI)	+= smartpqi/
-obj-$(CONFIG_SCSI_DTC3280)	+= dtc.o
 obj-$(CONFIG_SCSI_SYM53C8XX_2)	+= sym53c8xx_2/
 obj-$(CONFIG_SCSI_ZALON)	+= zalon7xx.o
 obj-$(CONFIG_SCSI_EATA_PIO)	+= eata_pio.o
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
deleted file mode 100644
index 459863f..0000000
--- a/drivers/scsi/dtc.c
+++ /dev/null
@@ -1,447 +0,0 @@
-/*
- * DTC 3180/3280 driver, by
- *	Ray Van Tassle	rayvt@comm.mot.com
- *
- *	taken from ...
- *	Trantor T128/T128F/T228 driver by...
- *
- * 	Drew Eckhardt
- *	Visionary Computing
- *	(Unix and Linux consulting and custom programming)
- *	drew@colorado.edu
- *      +1 (303) 440-4894
- */
-
-/*
- * The card is detected and initialized in one of several ways : 
- * 1.  Autoprobe (default) - since the board is memory mapped, 
- *     a BIOS signature is scanned for to locate the registers.
- *     An interrupt is triggered to autoprobe for the interrupt
- *     line.
- *
- * 2.  With command line overrides - dtc=address,irq may be 
- *     used on the LILO command line to override the defaults.
- * 
-*/
-
-/*----------------------------------------------------------------*/
-/* the following will set the monitor border color (useful to find
- where something crashed or gets stuck at */
-/* 1 = blue
- 2 = green
- 3 = cyan
- 4 = red
- 5 = magenta
- 6 = yellow
- 7 = white
-*/
-#if 0
-#define rtrc(i) {inb(0x3da); outb(0x31, 0x3c0); outb((i), 0x3c0);}
-#else
-#define rtrc(i) {}
-#endif
-
-
-#include <linux/module.h>
-#include <linux/blkdev.h>
-#include <linux/string.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <scsi/scsi_host.h>
-
-#include "dtc.h"
-#include "NCR5380.h"
-
-/*
- * The DTC3180 & 3280 boards are memory mapped.
- * 
- */
-
-/*
- */
-/* Offset from DTC_5380_OFFSET */
-#define DTC_CONTROL_REG		0x100	/* rw */
-#define D_CR_ACCESS		0x80	/* ro set=can access 3280 registers */
-#define CSR_DIR_READ		0x40	/* rw direction, 1 = read 0 = write */
-
-#define CSR_RESET              0x80	/* wo  Resets 53c400 */
-#define CSR_5380_REG           0x80	/* ro  5380 registers can be accessed */
-#define CSR_TRANS_DIR          0x40	/* rw  Data transfer direction */
-#define CSR_SCSI_BUFF_INTR     0x20	/* rw  Enable int on transfer ready */
-#define CSR_5380_INTR          0x10	/* rw  Enable 5380 interrupts */
-#define CSR_SHARED_INTR        0x08	/* rw  Interrupt sharing */
-#define CSR_HOST_BUF_NOT_RDY   0x04	/* ro  Host buffer not ready */
-#define CSR_SCSI_BUF_RDY       0x02	/* ro  SCSI buffer ready */
-#define CSR_GATED_5380_IRQ     0x01	/* ro  Last block xferred */
-#define CSR_INT_BASE (CSR_SCSI_BUFF_INTR | CSR_5380_INTR)
-
-
-#define DTC_BLK_CNT		0x101	/* rw 
-					 * # of 128-byte blocks to transfer */
-
-
-#define D_CR_ACCESS             0x80	/* ro set=can access 3280 registers */
-
-#define DTC_SWITCH_REG		0x3982	/* ro - DIP switches */
-#define DTC_RESUME_XFER		0x3982	/* wo - resume data xfer 
-					 * after disconnect/reconnect*/
-
-#define DTC_5380_OFFSET		0x3880	/* 8 registers here, see NCR5380.h */
-
-/*!!!! for dtc, it's a 128 byte buffer at 3900 !!! */
-#define DTC_DATA_BUF		0x3900	/* rw 128 bytes long */
-
-static struct override {
-	unsigned int address;
-	int irq;
-} overrides
-#ifdef OVERRIDE
-[] __initdata = OVERRIDE;
-#else
-[4] __initdata = {
-	{ 0, IRQ_AUTO }, { 0, IRQ_AUTO }, { 0, IRQ_AUTO }, { 0, IRQ_AUTO }
-};
-#endif
-
-#define NO_OVERRIDES ARRAY_SIZE(overrides)
-
-static struct base {
-	unsigned long address;
-	int noauto;
-} bases[] __initdata = {
-	{ 0xcc000, 0 },
-	{ 0xc8000, 0 },
-	{ 0xdc000, 0 },
-	{ 0xd8000, 0 }
-};
-
-#define NO_BASES ARRAY_SIZE(bases)
-
-static const struct signature {
-	const char *string;
-	int offset;
-} signatures[] = {
-	{"DATA TECHNOLOGY CORPORATION BIOS", 0x25},
-};
-
-#define NO_SIGNATURES ARRAY_SIZE(signatures)
-
-#ifndef MODULE
-/*
- * Function : dtc_setup(char *str, int *ints)
- *
- * Purpose : LILO command line initialization of the overrides array,
- *
- * Inputs : str - unused, ints - array of integer parameters with ints[0]
- *	equal to the number of ints.
- *
- */
-
-static int __init dtc_setup(char *str)
-{
-	static int commandline_current;
-	int i;
-	int ints[10];
-
-	get_options(str, ARRAY_SIZE(ints), ints);
-	if (ints[0] != 2)
-		printk("dtc_setup: usage dtc=address,irq\n");
-	else if (commandline_current < NO_OVERRIDES) {
-		overrides[commandline_current].address = ints[1];
-		overrides[commandline_current].irq = ints[2];
-		for (i = 0; i < NO_BASES; ++i)
-			if (bases[i].address == ints[1]) {
-				bases[i].noauto = 1;
-				break;
-			}
-		++commandline_current;
-	}
-	return 1;
-}
-
-__setup("dtc=", dtc_setup);
-#endif
-
-/* 
- * Function : int dtc_detect(struct scsi_host_template * tpnt)
- *
- * Purpose : detects and initializes DTC 3180/3280 controllers
- *	that were autoprobed, overridden on the LILO command line, 
- *	or specified at compile time.
- *
- * Inputs : tpnt - template for this SCSI adapter.
- * 
- * Returns : 1 if a host adapter was found, 0 if not.
- *
-*/
-
-static int __init dtc_detect(struct scsi_host_template * tpnt)
-{
-	static int current_override, current_base;
-	struct Scsi_Host *instance;
-	unsigned int addr;
-	void __iomem *base;
-	int sig, count;
-
-	for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
-		addr = 0;
-		base = NULL;
-
-		if (overrides[current_override].address) {
-			addr = overrides[current_override].address;
-			base = ioremap(addr, 0x2000);
-			if (!base)
-				addr = 0;
-		} else
-			for (; !addr && (current_base < NO_BASES); ++current_base) {
-				dprintk(NDEBUG_INIT, "dtc: probing address 0x%08x\n",
-				        (unsigned int)bases[current_base].address);
-				if (bases[current_base].noauto)
-					continue;
-				base = ioremap(bases[current_base].address, 0x2000);
-				if (!base)
-					continue;
-				for (sig = 0; sig < NO_SIGNATURES; ++sig) {
-					if (check_signature(base + signatures[sig].offset, signatures[sig].string, strlen(signatures[sig].string))) {
-						addr = bases[current_base].address;
-						dprintk(NDEBUG_INIT, "dtc: detected board\n");
-						goto found;
-					}
-				}
-				iounmap(base);
-			}
-
-		dprintk(NDEBUG_INIT, "dtc: addr = 0x%08x\n", addr);
-
-		if (!addr)
-			break;
-
-found:
-		instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
-		if (instance == NULL)
-			goto out_unmap;
-
-		instance->base = addr;
-		((struct NCR5380_hostdata *)(instance)->hostdata)->base = base;
-
-		if (NCR5380_init(instance, FLAG_LATE_DMA_SETUP))
-			goto out_unregister;
-
-		NCR5380_maybe_reset_bus(instance);
-
-		NCR5380_write(DTC_CONTROL_REG, CSR_5380_INTR);	/* Enable int's */
-		if (overrides[current_override].irq != IRQ_AUTO)
-			instance->irq = overrides[current_override].irq;
-		else
-			instance->irq = NCR5380_probe_irq(instance, DTC_IRQS);
-
-		/* Compatibility with documented NCR5380 kernel parameters */
-		if (instance->irq == 255)
-			instance->irq = NO_IRQ;
-
-		/* With interrupts enabled, it will sometimes hang when doing heavy
-		 * reads. So better not enable them until I finger it out. */
-		instance->irq = NO_IRQ;
-
-		if (instance->irq != NO_IRQ)
-			if (request_irq(instance->irq, dtc_intr, 0,
-					"dtc", instance)) {
-				printk(KERN_ERR "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
-				instance->irq = NO_IRQ;
-			}
-
-		if (instance->irq == NO_IRQ) {
-			printk(KERN_WARNING "scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
-			printk(KERN_WARNING "scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
-		}
-
-		dprintk(NDEBUG_INIT, "scsi%d : irq = %d\n",
-		        instance->host_no, instance->irq);
-
-		++current_override;
-		++count;
-	}
-	return count;
-
-out_unregister:
-	scsi_unregister(instance);
-out_unmap:
-	iounmap(base);
-	return count;
-}
-
-/*
- * Function : int dtc_biosparam(Disk * disk, struct block_device *dev, int *ip)
- *
- * Purpose : Generates a BIOS / DOS compatible H-C-S mapping for 
- *	the specified device / size.
- * 
- * Inputs : size = size of device in sectors (512 bytes), dev = block device
- *	major / minor, ip[] = {heads, sectors, cylinders}  
- *
- * Returns : always 0 (success), initializes ip
- *	
-*/
-
-/* 
- * XXX Most SCSI boards use this mapping, I could be incorrect.  Some one
- * using hard disks on a trantor should verify that this mapping corresponds
- * to that used by the BIOS / ASPI driver by running the linux fdisk program
- * and matching the H_C_S coordinates to what DOS uses.
-*/
-
-static int dtc_biosparam(struct scsi_device *sdev, struct block_device *dev,
-			 sector_t capacity, int *ip)
-{
-	int size = capacity;
-
-	ip[0] = 64;
-	ip[1] = 32;
-	ip[2] = size >> 11;
-	return 0;
-}
-
-
-/****************************************************************
- * Function : int NCR5380_pread (struct Scsi_Host *instance, 
- *	unsigned char *dst, int len)
- *
- * Purpose : Fast 5380 pseudo-dma read function, reads len bytes to 
- *	dst
- * 
- * Inputs : dst = destination, len = length in bytes
- *
- * Returns : 0 on success, non zero on a failure such as a watchdog 
- * 	timeout.
-*/
-
-static inline int dtc_pread(struct Scsi_Host *instance,
-                            unsigned char *dst, int len)
-{
-	unsigned char *d = dst;
-	int i;			/* For counting time spent in the poll-loop */
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-
-	i = 0;
-	if (instance->irq == NO_IRQ)
-		NCR5380_write(DTC_CONTROL_REG, CSR_DIR_READ);
-	else
-		NCR5380_write(DTC_CONTROL_REG, CSR_DIR_READ | CSR_INT_BASE);
-	NCR5380_write(DTC_BLK_CNT, len >> 7);	/* Block count */
-	rtrc(1);
-	while (len > 0) {
-		rtrc(2);
-		while (NCR5380_read(DTC_CONTROL_REG) & CSR_HOST_BUF_NOT_RDY)
-			++i;
-		rtrc(3);
-		memcpy_fromio(d, hostdata->base + DTC_DATA_BUF, 128);
-		d += 128;
-		len -= 128;
-		rtrc(7);
-		/*** with int's on, it sometimes hangs after here.
-		 * Looks like something makes HBNR go away. */
-	}
-	rtrc(4);
-	while (!(NCR5380_read(DTC_CONTROL_REG) & D_CR_ACCESS))
-		++i;
-	rtrc(0);
-	return (0);
-}
-
-/****************************************************************
- * Function : int NCR5380_pwrite (struct Scsi_Host *instance, 
- *	unsigned char *src, int len)
- *
- * Purpose : Fast 5380 pseudo-dma write function, transfers len bytes from
- *	src
- * 
- * Inputs : src = source, len = length in bytes
- *
- * Returns : 0 on success, non zero on a failure such as a watchdog 
- * 	timeout.
-*/
-
-static inline int dtc_pwrite(struct Scsi_Host *instance,
-                             unsigned char *src, int len)
-{
-	int i;
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-
-	if (instance->irq == NO_IRQ)
-		NCR5380_write(DTC_CONTROL_REG, 0);
-	else
-		NCR5380_write(DTC_CONTROL_REG, CSR_5380_INTR);
-	NCR5380_write(DTC_BLK_CNT, len >> 7);	/* Block count */
-	for (i = 0; len > 0; ++i) {
-		rtrc(5);
-		/* Poll until the host buffer can accept data. */
-		while (NCR5380_read(DTC_CONTROL_REG) & CSR_HOST_BUF_NOT_RDY)
-			++i;
-		rtrc(3);
-		memcpy_toio(hostdata->base + DTC_DATA_BUF, src, 128);
-		src += 128;
-		len -= 128;
-	}
-	rtrc(4);
-	while (!(NCR5380_read(DTC_CONTROL_REG) & D_CR_ACCESS))
-		++i;
-	rtrc(6);
-	/* Wait until the last byte has been sent to the disk */
-	while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT))
-		++i;
-	rtrc(7);
-	/* Check for parity error here. fixme. */
-	rtrc(0);
-	return (0);
-}
-
-static int dtc_dma_xfer_len(struct scsi_cmnd *cmd)
-{
-	int transfersize = cmd->transfersize;
-
-	/* Limit transfers to 32K, for xx400 & xx406
-	 * pseudoDMA that transfers in 128 bytes blocks.
-	 */
-	if (transfersize > 32 * 1024 && cmd->SCp.this_residual &&
-	    !(cmd->SCp.this_residual % transfersize))
-		transfersize = 32 * 1024;
-
-	return transfersize;
-}
-
-MODULE_LICENSE("GPL");
-
-#include "NCR5380.c"
-
-static int dtc_release(struct Scsi_Host *shost)
-{
-	struct NCR5380_hostdata *hostdata = shost_priv(shost);
-
-	if (shost->irq != NO_IRQ)
-		free_irq(shost->irq, shost);
-	NCR5380_exit(shost);
-	scsi_unregister(shost);
-	iounmap(hostdata->base);
-	return 0;
-}
-
-static struct scsi_host_template driver_template = {
-	.name			= "DTC 3180/3280",
-	.detect			= dtc_detect,
-	.release		= dtc_release,
-	.proc_name		= "dtc3x80",
-	.info			= dtc_info,
-	.queuecommand		= dtc_queue_command,
-	.eh_abort_handler	= dtc_abort,
-	.eh_bus_reset_handler	= dtc_bus_reset,
-	.bios_param		= dtc_biosparam,
-	.can_queue		= 32,
-	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 2,
-	.use_clustering		= DISABLE_CLUSTERING,
-	.cmd_size		= NCR5380_CMD_SIZE,
-	.max_sectors		= 128,
-};
-#include "scsi_module.c"
diff --git a/drivers/scsi/dtc.h b/drivers/scsi/dtc.h
deleted file mode 100644
index fcb0a8e..0000000
--- a/drivers/scsi/dtc.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * DTC controller, taken from T128 driver by...
- * Copyright 1993, Drew Eckhardt
- *	Visionary Computing
- *	(Unix and Linux consulting and custom programming)
- *	drew@colorado.edu
- *      +1 (303) 440-4894
- */
-
-#ifndef DTC3280_H
-#define DTC3280_H
-
-#define NCR5380_implementation_fields \
-    void __iomem *base
-
-#define DTC_address(reg) \
-	(((struct NCR5380_hostdata *)shost_priv(instance))->base + DTC_5380_OFFSET + reg)
-
-#define NCR5380_read(reg) (readb(DTC_address(reg)))
-#define NCR5380_write(reg, value) (writeb(value, DTC_address(reg)))
-
-#define NCR5380_dma_xfer_len(instance, cmd, phase) \
-        dtc_dma_xfer_len(cmd)
-#define NCR5380_dma_recv_setup		dtc_pread
-#define NCR5380_dma_send_setup		dtc_pwrite
-#define NCR5380_dma_residual(instance)	(0)
-
-#define NCR5380_intr			dtc_intr
-#define NCR5380_queue_command		dtc_queue_command
-#define NCR5380_abort			dtc_abort
-#define NCR5380_bus_reset		dtc_bus_reset
-#define NCR5380_info			dtc_info
-
-#define NCR5380_io_delay(x)		udelay(x)
-
-/* 15 12 11 10
-   1001 1100 0000 0000 */
-
-#define DTC_IRQS 0x9c00
-
-
-#endif /* DTC3280_H */
-- 
2.1.4

