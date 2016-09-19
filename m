From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] t128: remove from tree
Date: Mon, 19 Sep 2016 08:50:52 -0700
Message-ID: <1474300253-31351-7-git-send-email-hch@lst.de>
References: <1474300253-31351-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41283 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbcISPva (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 11:51:30 -0400
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
 Documentation/scsi/scsi-parameters.txt |   3 -
 MAINTAINERS                            |   1 -
 drivers/scsi/Kconfig                   |  17 --
 drivers/scsi/Makefile                  |   1 -
 drivers/scsi/t128.c                    | 407 ---------------------------------
 drivers/scsi/t128.h                    |  97 --------
 6 files changed, 526 deletions(-)
 delete mode 100644 drivers/scsi/t128.c
 delete mode 100644 drivers/scsi/t128.h

diff --git a/Documentation/scsi/scsi-parameters.txt b/Documentation/scsi/scsi-parameters.txt
index fe77b5a..00a03c0 100644
--- a/Documentation/scsi/scsi-parameters.txt
+++ b/Documentation/scsi/scsi-parameters.txt
@@ -113,9 +113,6 @@ parameters may be changed at runtime by the command
 	sym53c416=	[HW,SCSI]
 			See header of drivers/scsi/sym53c416.c.
 
-	t128=		[HW,SCSI]
-			See header of drivers/scsi/t128.c.
-
 	tmscsim=	[HW,SCSI]
 			See comment before function dc390_setup() in
 			drivers/scsi/tmscsim.c.
diff --git a/MAINTAINERS b/MAINTAINERS
index 2a0c056..e4ec1b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8054,7 +8054,6 @@ F:	drivers/scsi/g_NCR5380_mmio.c
 F:	drivers/scsi/mac_scsi.*
 F:	drivers/scsi/sun3_scsi.*
 F:	drivers/scsi/sun3_scsi_vme.c
-F:	drivers/scsi/t128.*
 
 NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
 M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index ee83d95..a38e37c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1345,23 +1345,6 @@ config SCSI_AM53C974
 	  To compile this driver as a module, choose M here: the
 	  module will be called am53c974.
 
-config SCSI_T128
-	tristate "Trantor T128/T128F/T228 SCSI support"
-	depends on ISA && SCSI
-	select SCSI_SPI_ATTRS
-	select CHECK_SIGNATURE
-	---help---
-	  This is support for a SCSI host adapter. It is explained in section
-	  3.11 of the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
-	  of the box, you may have to change some settings in
-	  <file:drivers/scsi/t128.h>.  Note that Trantor was purchased by
-	  Adaptec, and some former Trantor products are being sold under the
-	  Adaptec name.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called t128.
-
 config SCSI_NSP32
 	tristate "Workbit NinjaSCSI-32Bi/UDE support"
 	depends on PCI && SCSI && !64BIT
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index be3108c..392609a 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -87,7 +87,6 @@ obj-$(CONFIG_SCSI_QLA_ISCSI)	+= libiscsi.o qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
 obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_CHELSIO_FCOE)	+= csiostor/
-obj-$(CONFIG_SCSI_T128)		+= t128.o
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
 obj-$(CONFIG_SCSI_HPSA)		+= hpsa.o
 obj-$(CONFIG_SCSI_SMARTPQI)	+= smartpqi/
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
deleted file mode 100644
index 8a8608a..0000000
--- a/drivers/scsi/t128.c
+++ /dev/null
@@ -1,407 +0,0 @@
-/*
- * Trantor T128/T128F/T228 driver
- *	Note : architecturally, the T100 and T130 are different and won't 
- * 	work
- *
- * Copyright 1993, Drew Eckhardt
- *	Visionary Computing
- *	(Unix and Linux consulting and custom programming)
- *	drew@colorado.edu
- *      +1 (303) 440-4894
- *
- * For more information, please consult 
- *
- * Trantor Systems, Ltd.
- * T128/T128F/T228 SCSI Host Adapter
- * Hardware Specifications
- * 
- * Trantor Systems, Ltd. 
- * 5415 Randall Place
- * Fremont, CA 94538
- * 1+ (415) 770-1400, FAX 1+ (415) 770-9910
- */
-
-/*
- * The card is detected and initialized in one of several ways : 
- * 1.  Autoprobe (default) - since the board is memory mapped, 
- *     a BIOS signature is scanned for to locate the registers.
- *     An interrupt is triggered to autoprobe for the interrupt
- *     line.
- *
- * 2.  With command line overrides - t128=address,irq may be 
- *     used on the LILO command line to override the defaults.
- *
- * 3.  With the T128_OVERRIDE compile time define.  This is 
- *     specified as an array of address, irq tuples.  Ie, for
- *     one board at the default 0xcc000 address, IRQ5, I could say 
- *     -DT128_OVERRIDE={{0xcc000, 5}}
- *	
- *     Note that if the override methods are used, place holders must
- *     be specified for other boards in the system.
- * 
- * T128/T128F jumper/dipswitch settings (note : on my sample, the switches 
- * were epoxy'd shut, meaning I couldn't change the 0xcc000 base address) :
- *
- * T128    Sw7 Sw8 Sw6 = 0ws Sw5 = boot 
- * T128F   Sw6 Sw7 Sw5 = 0ws Sw4 = boot Sw8 = floppy disable
- * cc000   off off      
- * c8000   off on
- * dc000   on  off
- * d8000   on  on
- *
- * 
- * Interrupts 
- * There is a 12 pin jumper block, jp1, numbered as follows : 
- *   T128 (JP1)  	 T128F (J5)
- * 2 4 6 8 10 12	11 9  7 5 3 1
- * 1 3 5 7 9  11	12 10 8 6 4 2
- *
- * 3   2-4
- * 5   1-3
- * 7   3-5
- * T128F only 
- * 10 8-10
- * 12 7-9
- * 14 10-12
- * 15 9-11
- */
- 
-#include <linux/io.h>
-#include <linux/blkdev.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
-#include <linux/module.h>
-
-#include <scsi/scsi_host.h>
-#include "t128.h"
-#include "NCR5380.h"
-
-static struct override {
-    unsigned long address;
-    int irq;
-} overrides
-#ifdef T128_OVERRIDE
-    [] __initdata = T128_OVERRIDE;
-#else
-    [4] __initdata = {{0, IRQ_AUTO}, {0, IRQ_AUTO},
-        {0 ,IRQ_AUTO}, {0, IRQ_AUTO}};
-#endif
-
-#define NO_OVERRIDES ARRAY_SIZE(overrides)
-
-static struct base {
-    unsigned int address;
-    int noauto;
-} bases[] __initdata = {
-    { 0xcc000, 0}, { 0xc8000, 0}, { 0xdc000, 0}, { 0xd8000, 0}
-};
-
-#define NO_BASES ARRAY_SIZE(bases)
-
-static struct signature {
-    const char *string;
-    int offset;
-} signatures[] __initdata = {
-{"TSROM: SCSI BIOS, Version 1.12", 0x36},
-};
-
-#define NO_SIGNATURES ARRAY_SIZE(signatures)
-
-#ifndef MODULE
-/*
- * Function : t128_setup(char *str, int *ints)
- *
- * Purpose : LILO command line initialization of the overrides array,
- * 
- * Inputs : str - unused, ints - array of integer parameters with ints[0]
- *	equal to the number of ints.
- *
- */
-
-static int __init t128_setup(char *str)
-{
-	static int commandline_current;
-    int i;
-    int ints[10];
-
-    get_options(str, ARRAY_SIZE(ints), ints);
-    if (ints[0] != 2) 
-	printk("t128_setup : usage t128=address,irq\n");
-    else 
-	if (commandline_current < NO_OVERRIDES) {
-	    overrides[commandline_current].address = ints[1];
-	    overrides[commandline_current].irq = ints[2];
-	    for (i = 0; i < NO_BASES; ++i)
-		if (bases[i].address == ints[1]) {
-		    bases[i].noauto = 1;
-		    break;
-		}
-	    ++commandline_current;
-	}
-    return 1;
-}
-
-__setup("t128=", t128_setup);
-#endif
-
-/* 
- * Function : int t128_detect(struct scsi_host_template * tpnt)
- *
- * Purpose : detects and initializes T128,T128F, or T228 controllers
- *	that were autoprobed, overridden on the LILO command line, 
- *	or specified at compile time.
- *
- * Inputs : tpnt - template for this SCSI adapter.
- * 
- * Returns : 1 if a host adapter was found, 0 if not.
- *
- */
-
-static int __init t128_detect(struct scsi_host_template *tpnt)
-{
-	static int current_override, current_base;
-    struct Scsi_Host *instance;
-    unsigned long base;
-    void __iomem *p;
-    int sig, count;
-
-    for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
-	base = 0;
-	p = NULL;
-
-	if (overrides[current_override].address) {
-	    base = overrides[current_override].address;
-	    p = ioremap(bases[current_base].address, 0x2000);
-	    if (!p)
-		base = 0;
-	} else 
-	    for (; !base && (current_base < NO_BASES); ++current_base) {
-		dprintk(NDEBUG_INIT, "t128: probing address 0x%08x\n",
-		        bases[current_base].address);
-		if (bases[current_base].noauto)
-			continue;
-		p = ioremap(bases[current_base].address, 0x2000);
-		if (!p)
-			continue;
-		for (sig = 0; sig < NO_SIGNATURES; ++sig) 
-		    if (check_signature(p + signatures[sig].offset,
-					signatures[sig].string,
-					strlen(signatures[sig].string))) {
-			base = bases[current_base].address;
-			dprintk(NDEBUG_INIT, "t128: detected board\n");
-			goto found;
-		    }
-		iounmap(p);
-	    }
-
-	dprintk(NDEBUG_INIT, "t128: base = 0x%08x\n", (unsigned int)base);
-
-	if (!base)
-	    break;
-
-found:
-	instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
-	if(instance == NULL)
-		goto out_unmap;
-
-	instance->base = base;
-	((struct NCR5380_hostdata *)instance->hostdata)->base = p;
-
-	if (NCR5380_init(instance, FLAG_DMA_FIXUP | FLAG_LATE_DMA_SETUP))
-		goto out_unregister;
-
-	NCR5380_maybe_reset_bus(instance);
-
-	if (overrides[current_override].irq != IRQ_AUTO)
-	    instance->irq = overrides[current_override].irq;
-	else 
-	    instance->irq = NCR5380_probe_irq(instance, T128_IRQS);
-
-	/* Compatibility with documented NCR5380 kernel parameters */
-	if (instance->irq == 255)
-		instance->irq = NO_IRQ;
-
-	if (instance->irq != NO_IRQ)
-	    if (request_irq(instance->irq, t128_intr, 0, "t128",
-			    instance)) {
-		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
-		    instance->host_no, instance->irq);
-		instance->irq = NO_IRQ;
-	    } 
-
-	if (instance->irq == NO_IRQ) {
-	    printk("scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
-	    printk("scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
-	}
-
-	dprintk(NDEBUG_INIT, "scsi%d: irq = %d\n",
-	        instance->host_no, instance->irq);
-
-	++current_override;
-	++count;
-    }
-    return count;
-
-out_unregister:
-	scsi_unregister(instance);
-out_unmap:
-	iounmap(p);
-	return count;
-}
-
-static int t128_release(struct Scsi_Host *shost)
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
-/*
- * Function : int t128_biosparam(Disk * disk, struct block_device *dev, int *ip)
- *
- * Purpose : Generates a BIOS / DOS compatible H-C-S mapping for 
- *	the specified device / size.
- * 
- * Inputs : size = size of device in sectors (512 bytes), dev = block device
- *	major / minor, ip[] = {heads, sectors, cylinders}  
- *
- * Returns : always 0 (success), initializes ip
- *	
- */
-
-/* 
- * XXX Most SCSI boards use this mapping, I could be incorrect.  Some one
- * using hard disks on a trantor should verify that this mapping corresponds
- * to that used by the BIOS / ASPI driver by running the linux fdisk program
- * and matching the H_C_S coordinates to what DOS uses.
- */
-
-static int t128_biosparam(struct scsi_device *sdev, struct block_device *bdev,
-                          sector_t capacity, int *ip)
-{
-  ip[0] = 64;
-  ip[1] = 32;
-  ip[2] = capacity >> 11;
-  return 0;
-}
-
-/*
- * Function : int t128_pread (struct Scsi_Host *instance,
- *	unsigned char *dst, int len)
- *
- * Purpose : Fast 5380 pseudo-dma read function, transfers len bytes to 
- *	dst
- * 
- * Inputs : dst = destination, len = length in bytes
- *
- * Returns : 0 on success, non zero on a failure such as a watchdog 
- * 	timeout.
- */
-
-static inline int t128_pread(struct Scsi_Host *instance,
-                             unsigned char *dst, int len)
-{
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	void __iomem *reg, *base = hostdata->base;
-    unsigned char *d = dst;
-    register int i = len;
-
-    reg = base + T_DATA_REG_OFFSET;
-
-#if 0
-    for (; i; --i) {
-	while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
-#else
-    while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
-    for (; i; --i) {
-#endif
-	*d++ = readb(reg);
-    }
-
-    if (readb(base + T_STATUS_REG_OFFSET) & T_ST_TIM) {
-	unsigned char tmp;
-	void __iomem *foo = base + T_CONTROL_REG_OFFSET;
-	tmp = readb(foo);
-	writeb(tmp | T_CR_CT, foo);
-	writeb(tmp, foo);
-	printk("scsi%d : watchdog timer fired in NCR5380_pread()\n",
-	    instance->host_no);
-	return -1;
-    } else
-	return 0;
-}
-
-/*
- * Function : int t128_pwrite (struct Scsi_Host *instance,
- *	unsigned char *src, int len)
- *
- * Purpose : Fast 5380 pseudo-dma write function, transfers len bytes from
- *	src
- * 
- * Inputs : src = source, len = length in bytes
- *
- * Returns : 0 on success, non zero on a failure such as a watchdog 
- * 	timeout.
- */
-
-static inline int t128_pwrite(struct Scsi_Host *instance,
-                              unsigned char *src, int len)
-{
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	void __iomem *reg, *base = hostdata->base;
-    unsigned char *s = src;
-    register int i = len;
-
-    reg = base + T_DATA_REG_OFFSET;
-
-#if 0
-    for (; i; --i) {
-	while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
-#else
-    while (!(readb(base+T_STATUS_REG_OFFSET) & T_ST_RDY)) barrier();
-    for (; i; --i) {
-#endif
-	writeb(*s++, reg);
-    }
-
-    if (readb(base + T_STATUS_REG_OFFSET) & T_ST_TIM) {
-	unsigned char tmp;
-	void __iomem *foo = base + T_CONTROL_REG_OFFSET;
-	tmp = readb(foo);
-	writeb(tmp | T_CR_CT, foo);
-	writeb(tmp, foo);
-	printk("scsi%d : watchdog timer fired in NCR5380_pwrite()\n",
-	    instance->host_no);
-	return -1;
-    } else 
-	return 0;
-}
-
-MODULE_LICENSE("GPL");
-
-#include "NCR5380.c"
-
-static struct scsi_host_template driver_template = {
-	.name			= "Trantor T128/T128F/T228",
-	.detect			= t128_detect,
-	.release		= t128_release,
-	.proc_name		= "t128",
-	.info			= t128_info,
-	.queuecommand		= t128_queue_command,
-	.eh_abort_handler	= t128_abort,
-	.eh_bus_reset_handler	= t128_bus_reset,
-	.bios_param		= t128_biosparam,
-	.can_queue		= 32,
-	.this_id		= 7,
-	.sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 2,
-	.use_clustering		= DISABLE_CLUSTERING,
-	.cmd_size		= NCR5380_CMD_SIZE,
-	.max_sectors		= 128,
-};
-#include "scsi_module.c"
diff --git a/drivers/scsi/t128.h b/drivers/scsi/t128.h
deleted file mode 100644
index c95bcd8..0000000
--- a/drivers/scsi/t128.h
+++ /dev/null
@@ -1,97 +0,0 @@
-/*
- * Trantor T128/T128F/T228 defines
- *	Note : architecturally, the T100 and T128 are different and won't work
- *
- * Copyright 1993, Drew Eckhardt
- *	Visionary Computing
- *	(Unix and Linux consulting and custom programming)
- *	drew@colorado.edu
- *      +1 (303) 440-4894
- *
- * For more information, please consult
- *
- * Trantor Systems, Ltd.
- * T128/T128F/T228 SCSI Host Adapter
- * Hardware Specifications
- *
- * Trantor Systems, Ltd.
- * 5415 Randall Place
- * Fremont, CA 94538
- * 1+ (415) 770-1400, FAX 1+ (415) 770-9910
- */
-
-#ifndef T128_H
-#define T128_H
-
-/*
- * The trantor boards are memory mapped. They use an NCR5380 or
- * equivalent (my sample board had part second sourced from ZILOG).
- * NCR's recommended "Pseudo-DMA" architecture is used, where
- * a PAL drives the DMA signals on the 5380 allowing fast, blind
- * transfers with proper handshaking.
- */
-
-/*
- * Note : a boot switch is provided for the purpose of informing the
- * firmware to boot or not boot from attached SCSI devices.  So, I imagine
- * there are fewer people who've yanked the ROM like they do on the Seagate
- * to make bootup faster, and I'll probably use this for autodetection.
- */
-#define T_ROM_OFFSET		0
-
-/*
- * Note : my sample board *WAS NOT* populated with the SRAM, so this
- * can't be used for autodetection without a ROM present.
- */
-#define T_RAM_OFFSET		0x1800
-
-/*
- * All of the registers are allocated 32 bytes of address space, except
- * for the data register (read/write to/from the 5380 in pseudo-DMA mode)
- */ 
-#define T_CONTROL_REG_OFFSET	0x1c00	/* rw */
-#define T_CR_INT		0x10	/* Enable interrupts */
-#define T_CR_CT			0x02	/* Reset watchdog timer */
-
-#define T_STATUS_REG_OFFSET	0x1c20	/* ro */
-#define T_ST_BOOT		0x80	/* Boot switch */
-#define T_ST_S3			0x40	/* User settable switches, */
-#define T_ST_S2			0x20	/* read 0 when switch is on, 1 off */
-#define T_ST_S1			0x10
-#define T_ST_PS2		0x08	/* Set for Microchannel 228 */
-#define T_ST_RDY		0x04	/* 5380 DRQ */
-#define T_ST_TIM		0x02	/* indicates 40us watchdog timer fired */
-#define T_ST_ZERO		0x01	/* Always zero */
-
-#define T_5380_OFFSET		0x1d00	/* 8 registers here, see NCR5380.h */
-
-#define T_DATA_REG_OFFSET	0x1e00	/* rw 512 bytes long */
-
-#define NCR5380_implementation_fields \
-    void __iomem *base
-
-#define T128_address(reg) \
-	(((struct NCR5380_hostdata *)shost_priv(instance))->base + T_5380_OFFSET + ((reg) * 0x20))
-
-#define NCR5380_read(reg) readb(T128_address(reg))
-#define NCR5380_write(reg, value) writeb((value),(T128_address(reg)))
-
-#define NCR5380_dma_xfer_len(instance, cmd, phase)	(cmd->transfersize)
-#define NCR5380_dma_recv_setup		t128_pread
-#define NCR5380_dma_send_setup		t128_pwrite
-#define NCR5380_dma_residual(instance)	(0)
-
-#define NCR5380_intr t128_intr
-#define NCR5380_queue_command t128_queue_command
-#define NCR5380_abort t128_abort
-#define NCR5380_bus_reset t128_bus_reset
-#define NCR5380_info t128_info
-
-#define NCR5380_io_delay(x)		udelay(x)
-
-/* 15 14 12 10 7 5 3
-   1101 0100 1010 1000 */
-
-#define T128_IRQS 0xc4a8
-
-#endif /* T128_H */
-- 
2.1.4

