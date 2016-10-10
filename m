From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 01/12] scsi/g_NCR5380: Merge g_NCR5380 and g_NCR5380_mmio
 drivers
Date: Mon, 10 Oct 2016 00:46:52 -0400 (EDT)
Message-ID: <583104115d0c20e576f0b3b6734a38f86cebe755.1476051962.git.fthain@telegraphics.com.au>
References: <cover.1476051961.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:32786 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750698AbcJJEqz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2016 00:46:55 -0400
In-Reply-To: <cover.1476051961.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

Merge the port-mapped IO and memory-mapped IO support (with the help of
ioport_map) into the g_NCR5380 module and delete g_NCR5380_mmio.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
---
 MAINTAINERS                   |   1 -
 drivers/scsi/Kconfig          |  32 +-----
 drivers/scsi/Makefile         |   1 -
 drivers/scsi/g_NCR5380.c      | 252 ++++++++++++++++++++----------------------
 drivers/scsi/g_NCR5380.h      |  33 ++----
 drivers/scsi/g_NCR5380_mmio.c |  10 --
 6 files changed, 134 insertions(+), 195 deletions(-)
 delete mode 100644 drivers/scsi/g_NCR5380_mmio.c

diff --git a/MAINTAINERS b/MAINTAINERS
index f0ee7a6..29ffef5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8048,7 +8048,6 @@ F:	drivers/scsi/arm/oak.c
 F:	drivers/scsi/atari_scsi.*
 F:	drivers/scsi/dmx3191d.c
 F:	drivers/scsi/g_NCR5380.*
-F:	drivers/scsi/g_NCR5380_mmio.c
 F:	drivers/scsi/mac_scsi.*
 F:	drivers/scsi/sun3_scsi.*
 F:	drivers/scsi/sun3_scsi_vme.c
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3e2bdb9..98451fe 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -743,40 +743,18 @@ config SCSI_ISCI
 	  control unit found in the Intel(R) C600 series chipset.
 
 config SCSI_GENERIC_NCR5380
-	tristate "Generic NCR5380/53c400 SCSI PIO support"
+	tristate "Generic NCR5380/53c400 SCSI ISA card support"
 	depends on ISA && SCSI
 	select SCSI_SPI_ATTRS
 	---help---
-	  This is a driver for the old NCR 53c80 series of SCSI controllers
-	  on boards using PIO. Most boards such as the Trantor T130 fit this
-	  category, along with a large number of ISA 8bit controllers shipped
-	  for free with SCSI scanners. If you have a PAS16, T128 or DMX3191
-	  you should select the specific driver for that card rather than
-	  generic 5380 support.
-
-	  It is explained in section 3.8 of the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
-	  of the box, you may have to change some settings in
-	  <file:drivers/scsi/g_NCR5380.h>.
+	  This is a driver for old ISA card SCSI controllers based on a
+	  NCR 5380, 53C80, 53C400, 53C400A, or DTC 436 device.
+	  Most boards such as the Trantor T130 fit this category, as do
+	  various 8-bit and 16-bit ISA cards bundled with SCSI scanners.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called g_NCR5380.
 
-config SCSI_GENERIC_NCR5380_MMIO
-	tristate "Generic NCR5380/53c400 SCSI MMIO support"
-	depends on ISA && SCSI
-	select SCSI_SPI_ATTRS
-	---help---
-	  This is a driver for the old NCR 53c80 series of SCSI controllers
-	  on boards using memory mapped I/O. 
-	  It is explained in section 3.8 of the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
-	  of the box, you may have to change some settings in
-	  <file:drivers/scsi/g_NCR5380.h>.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called g_NCR5380_mmio.
-
 config SCSI_IPS
 	tristate "IBM ServeRAID support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 38d938d..2ac1b9f 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -74,7 +74,6 @@ obj-$(CONFIG_SCSI_ISCI)		+= isci/
 obj-$(CONFIG_SCSI_IPS)		+= ips.o
 obj-$(CONFIG_SCSI_FUTURE_DOMAIN)+= fdomain.o
 obj-$(CONFIG_SCSI_GENERIC_NCR5380) += g_NCR5380.o
-obj-$(CONFIG_SCSI_GENERIC_NCR5380_MMIO) += g_NCR5380_mmio.o
 obj-$(CONFIG_SCSI_NCR53C406A)	+= NCR53c406a.o
 obj-$(CONFIG_SCSI_NCR_D700)	+= 53c700.o NCR_D700.o
 obj-$(CONFIG_SCSI_NCR_Q720)	+= NCR_Q720_mod.o
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index cbf0103..4d7a9de 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -64,9 +64,9 @@ static int card[] = { -1, -1, -1, -1, -1, -1, -1, -1 };
 module_param_array(card, int, NULL, 0);
 MODULE_PARM_DESC(card, "card type (0=NCR5380, 1=NCR53C400, 2=NCR53C400A, 3=DTC3181E, 4=HP C2502)");
 
+MODULE_ALIAS("g_NCR5380_mmio");
 MODULE_LICENSE("GPL");
 
-#ifndef SCSI_G_NCR5380_MEM
 /*
  * Configure I/O address of 53C400A or DTC436 by writing magic numbers
  * to ports 0x779 and 0x379.
@@ -88,40 +88,35 @@ static void magic_configure(int idx, u8 irq, u8 magic[])
 		cfg = 0x80 | idx | (irq << 4);
 	outb(cfg, 0x379);
 }
-#endif
+
+static unsigned int ncr_53c400a_ports[] = {
+	0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
+};
+static unsigned int dtc_3181e_ports[] = {
+	0x220, 0x240, 0x280, 0x2a0, 0x2c0, 0x300, 0x320, 0x340, 0
+};
+static u8 ncr_53c400a_magic[] = {	/* 53C400A & DTC436 */
+	0x59, 0xb9, 0xc5, 0xae, 0xa6
+};
+static u8 hp_c2502_magic[] = {	/* HP C2502 */
+	0x0f, 0x22, 0xf0, 0x20, 0x80
+};
 
 static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 			struct device *pdev, int base, int irq, int board)
 {
-	unsigned int *ports;
+	bool is_pmio = base <= 0xffff;
+	int ret;
+	int flags = 0;
+	unsigned int *ports = NULL;
 	u8 *magic = NULL;
-#ifndef SCSI_G_NCR5380_MEM
 	int i;
 	int port_idx = -1;
 	unsigned long region_size;
-#endif
-	static unsigned int ncr_53c400a_ports[] = {
-		0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
-	};
-	static unsigned int dtc_3181e_ports[] = {
-		0x220, 0x240, 0x280, 0x2a0, 0x2c0, 0x300, 0x320, 0x340, 0
-	};
-	static u8 ncr_53c400a_magic[] = {	/* 53C400A & DTC436 */
-		0x59, 0xb9, 0xc5, 0xae, 0xa6
-	};
-	static u8 hp_c2502_magic[] = {	/* HP C2502 */
-		0x0f, 0x22, 0xf0, 0x20, 0x80
-	};
-	int flags, ret;
 	struct Scsi_Host *instance;
 	struct NCR5380_hostdata *hostdata;
-#ifdef SCSI_G_NCR5380_MEM
 	void __iomem *iomem;
-	resource_size_t iomem_size;
-#endif
 
-	ports = NULL;
-	flags = 0;
 	switch (board) {
 	case BOARD_NCR5380:
 		flags = FLAG_NO_PSEUDO_DMA | FLAG_DMA_FIXUP;
@@ -140,8 +135,7 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 		break;
 	}
 
-#ifndef SCSI_G_NCR5380_MEM
-	if (ports && magic) {
+	if (is_pmio && ports && magic) {
 		/* wakeup sequence for the NCR53C400A and DTC3181E */
 
 		/* Disable the adapter and look for a free io port */
@@ -179,75 +173,81 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 			port_idx = i;
 		} else
 			return -EINVAL;
-	}
-	else
-	{
+	} else if (is_pmio) {
 		/* NCR5380 - no configuration, just grab */
 		region_size = 8;
 		if (!base || !request_region(base, region_size, "ncr5380"))
 			return -EBUSY;
+	} else {	/* MMIO */
+		region_size = NCR53C400_region_size;
+		if (!request_mem_region(base, region_size, "ncr5380"))
+			return -EBUSY;
 	}
-#else
-	iomem_size = NCR53C400_region_size;
-	if (!request_mem_region(base, iomem_size, "ncr5380"))
-		return -EBUSY;
-	iomem = ioremap(base, iomem_size);
+
+	if (is_pmio)
+		iomem = ioport_map(base, region_size);
+	else
+		iomem = ioremap(base, region_size);
+
 	if (!iomem) {
-		release_mem_region(base, iomem_size);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_release;
 	}
-#endif
+
 	instance = scsi_host_alloc(tpnt, sizeof(struct NCR5380_hostdata));
 	if (instance == NULL) {
 		ret = -ENOMEM;
-		goto out_release;
+		goto out_unmap;
 	}
 	hostdata = shost_priv(instance);
 
-#ifndef SCSI_G_NCR5380_MEM
-	instance->io_port = base;
-	instance->n_io_port = region_size;
-	hostdata->io_width = 1; /* 8-bit PDMA by default */
-
-	/*
-	 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
-	 * the base address.
-	 */
-	switch (board) {
-	case BOARD_NCR53C400:
-		instance->io_port += 8;
-		hostdata->c400_ctl_status = 0;
-		hostdata->c400_blk_cnt = 1;
-		hostdata->c400_host_buf = 4;
-		break;
-	case BOARD_DTC3181E:
-		hostdata->io_width = 2;	/* 16-bit PDMA */
-		/* fall through */
-	case BOARD_NCR53C400A:
-	case BOARD_HP_C2502:
-		hostdata->c400_ctl_status = 9;
-		hostdata->c400_blk_cnt = 10;
-		hostdata->c400_host_buf = 8;
-		break;
-	}
-#else
-	instance->base = base;
 	hostdata->iomem = iomem;
-	hostdata->iomem_size = iomem_size;
-	switch (board) {
-	case BOARD_NCR53C400:
-		hostdata->c400_ctl_status = 0x100;
-		hostdata->c400_blk_cnt = 0x101;
-		hostdata->c400_host_buf = 0x104;
-		break;
-	case BOARD_DTC3181E:
-	case BOARD_NCR53C400A:
-	case BOARD_HP_C2502:
-		pr_err(DRV_MODULE_NAME ": unknown register offsets\n");
-		ret = -EINVAL;
-		goto out_unregister;
+
+	if (is_pmio) {
+		instance->io_port = base;
+		instance->n_io_port = region_size;
+		hostdata->io_width = 1; /* 8-bit PDMA by default */
+		hostdata->offset = 0;
+
+		/*
+		 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
+		 * the base address.
+		 */
+		switch (board) {
+		case BOARD_NCR53C400:
+			instance->io_port += 8;
+			hostdata->c400_ctl_status = 0;
+			hostdata->c400_blk_cnt = 1;
+			hostdata->c400_host_buf = 4;
+			break;
+		case BOARD_DTC3181E:
+			hostdata->io_width = 2;	/* 16-bit PDMA */
+			/* fall through */
+		case BOARD_NCR53C400A:
+		case BOARD_HP_C2502:
+			hostdata->c400_ctl_status = 9;
+			hostdata->c400_blk_cnt = 10;
+			hostdata->c400_host_buf = 8;
+			break;
+		}
+	} else {
+		instance->base = base;
+		hostdata->iomem_size = region_size;
+		hostdata->offset = NCR53C400_mem_base;
+		switch (board) {
+		case BOARD_NCR53C400:
+			hostdata->c400_ctl_status = 0x100;
+			hostdata->c400_blk_cnt = 0x101;
+			hostdata->c400_host_buf = 0x104;
+			break;
+		case BOARD_DTC3181E:
+		case BOARD_NCR53C400A:
+		case BOARD_HP_C2502:
+			pr_err(DRV_MODULE_NAME ": unknown register offsets\n");
+			ret = -EINVAL;
+			goto out_unregister;
+		}
 	}
-#endif
 
 	ret = NCR5380_init(instance, flags | FLAG_LATE_DMA_SETUP);
 	if (ret)
@@ -273,11 +273,9 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 		instance->irq = NO_IRQ;
 
 	if (instance->irq != NO_IRQ) {
-#ifndef SCSI_G_NCR5380_MEM
 		/* set IRQ for HP C2502 */
 		if (board == BOARD_HP_C2502)
 			magic_configure(port_idx, instance->irq, magic);
-#endif
 		if (request_irq(instance->irq, generic_NCR5380_intr,
 				0, "NCR5380", instance)) {
 			printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
@@ -303,32 +301,29 @@ out_free_irq:
 	NCR5380_exit(instance);
 out_unregister:
 	scsi_host_put(instance);
-out_release:
-#ifndef SCSI_G_NCR5380_MEM
-	release_region(base, region_size);
-#else
+out_unmap:
 	iounmap(iomem);
-	release_mem_region(base, iomem_size);
-#endif
+out_release:
+	if (is_pmio)
+		release_region(base, region_size);
+	else
+		release_mem_region(base, region_size);
 	return ret;
 }
 
 static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
 {
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
 	scsi_remove_host(instance);
 	if (instance->irq != NO_IRQ)
 		free_irq(instance->irq, instance);
 	NCR5380_exit(instance);
-#ifndef SCSI_G_NCR5380_MEM
-	release_region(instance->io_port, instance->n_io_port);
-#else
-	{
-		struct NCR5380_hostdata *hostdata = shost_priv(instance);
-
-		iounmap(hostdata->iomem);
+	iounmap(hostdata->iomem);
+	if (instance->io_port)
+		release_region(instance->io_port, instance->n_io_port);
+	else
 		release_mem_region(instance->base, hostdata->iomem_size);
-	}
-#endif
 	scsi_host_put(instance);
 }
 
@@ -361,18 +356,16 @@ static inline int generic_NCR5380_pread(struct Scsi_Host *instance,
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; /* FIXME - no timeout */
 
-#ifndef SCSI_G_NCR5380_MEM
-		if (hostdata->io_width == 2)
+		if (instance->io_port && hostdata->io_width == 2)
 			insw(instance->io_port + hostdata->c400_host_buf,
 							dst + start, 64);
-		else
+		else if (instance->io_port)
 			insb(instance->io_port + hostdata->c400_host_buf,
 							dst + start, 128);
-#else
-		/* implies SCSI_G_NCR5380_MEM */
-		memcpy_fromio(dst + start,
-		              hostdata->iomem + NCR53C400_host_buffer, 128);
-#endif
+		else
+			memcpy_fromio(dst + start,
+				hostdata->iomem + NCR53C400_host_buffer, 128);
+
 		start += 128;
 		blocks--;
 	}
@@ -381,18 +374,16 @@ static inline int generic_NCR5380_pread(struct Scsi_Host *instance,
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; /* FIXME - no timeout */
 
-#ifndef SCSI_G_NCR5380_MEM
-		if (hostdata->io_width == 2)
+		if (instance->io_port && hostdata->io_width == 2)
 			insw(instance->io_port + hostdata->c400_host_buf,
 							dst + start, 64);
-		else
+		else if (instance->io_port)
 			insb(instance->io_port + hostdata->c400_host_buf,
 							dst + start, 128);
-#else
-		/* implies SCSI_G_NCR5380_MEM */
-		memcpy_fromio(dst + start,
-		              hostdata->iomem + NCR53C400_host_buffer, 128);
-#endif
+		else
+			memcpy_fromio(dst + start,
+				hostdata->iomem + NCR53C400_host_buffer, 128);
+
 		start += 128;
 		blocks--;
 	}
@@ -439,18 +430,17 @@ static inline int generic_NCR5380_pwrite(struct Scsi_Host *instance,
 			break;
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - timeout
-#ifndef SCSI_G_NCR5380_MEM
-		if (hostdata->io_width == 2)
+
+		if (instance->io_port && hostdata->io_width == 2)
 			outsw(instance->io_port + hostdata->c400_host_buf,
 							src + start, 64);
-		else
+		else if (instance->io_port)
 			outsb(instance->io_port + hostdata->c400_host_buf,
 							src + start, 128);
-#else
-		/* implies SCSI_G_NCR5380_MEM */
-		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
-		            src + start, 128);
-#endif
+		else
+			memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
+			            src + start, 128);
+
 		start += 128;
 		blocks--;
 	}
@@ -458,18 +448,16 @@ static inline int generic_NCR5380_pwrite(struct Scsi_Host *instance,
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - no timeout
 
-#ifndef SCSI_G_NCR5380_MEM
-		if (hostdata->io_width == 2)
+		if (instance->io_port && hostdata->io_width == 2)
 			outsw(instance->io_port + hostdata->c400_host_buf,
 							src + start, 64);
-		else
+		else if (instance->io_port)
 			outsb(instance->io_port + hostdata->c400_host_buf,
 							src + start, 128);
-#else
-		/* implies SCSI_G_NCR5380_MEM */
-		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
-		            src + start, 128);
-#endif
+		else
+			memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
+			            src + start, 128);
+
 		start += 128;
 		blocks--;
 	}
@@ -566,7 +554,7 @@ static struct isa_driver generic_NCR5380_isa_driver = {
 	},
 };
 
-#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
+#ifdef CONFIG_PNP
 static struct pnp_device_id generic_NCR5380_pnp_ids[] = {
 	{ .id = "DTC436e", .driver_data = BOARD_DTC3181E },
 	{ .id = "" }
@@ -600,7 +588,7 @@ static struct pnp_driver generic_NCR5380_pnp_driver = {
 	.probe		= generic_NCR5380_pnp_probe,
 	.remove		= generic_NCR5380_pnp_remove,
 };
-#endif /* !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP) */
+#endif /* defined(CONFIG_PNP) */
 
 static int pnp_registered, isa_registered;
 
@@ -624,7 +612,7 @@ static int __init generic_NCR5380_init(void)
 			card[0] = BOARD_HP_C2502;
 	}
 
-#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
+#ifdef CONFIG_PNP
 	if (!pnp_register_driver(&generic_NCR5380_pnp_driver))
 		pnp_registered = 1;
 #endif
@@ -637,7 +625,7 @@ static int __init generic_NCR5380_init(void)
 
 static void __exit generic_NCR5380_exit(void)
 {
-#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
+#ifdef CONFIG_PNP
 	if (pnp_registered)
 		pnp_unregister_driver(&generic_NCR5380_pnp_driver);
 #endif
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index b175b92..2b777824 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -14,44 +14,30 @@
 #ifndef GENERIC_NCR5380_H
 #define GENERIC_NCR5380_H
 
-#ifndef SCSI_G_NCR5380_MEM
 #define DRV_MODULE_NAME "g_NCR5380"
 
 #define NCR5380_read(reg) \
-	inb(instance->io_port + (reg))
+	ioread8(((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
+		((struct NCR5380_hostdata *)shost_priv(instance))->offset + \
+		(reg))
 #define NCR5380_write(reg, value) \
-	outb(value, instance->io_port + (reg))
+	iowrite8(value, ((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
+		((struct NCR5380_hostdata *)shost_priv(instance))->offset + \
+		(reg))
 
 #define NCR5380_implementation_fields \
+	int offset; \
+	void __iomem *iomem; \
+	resource_size_t iomem_size; \
 	int c400_ctl_status; \
 	int c400_blk_cnt; \
 	int c400_host_buf; \
 	int io_width;
 
-#else 
-/* therefore SCSI_G_NCR5380_MEM */
-#define DRV_MODULE_NAME "g_NCR5380_mmio"
-
 #define NCR53C400_mem_base 0x3880
 #define NCR53C400_host_buffer 0x3900
 #define NCR53C400_region_size 0x3a00
 
-#define NCR5380_read(reg) \
-	readb(((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
-	      NCR53C400_mem_base + (reg))
-#define NCR5380_write(reg, value) \
-	writeb(value, ((struct NCR5380_hostdata *)shost_priv(instance))->iomem + \
-	       NCR53C400_mem_base + (reg))
-
-#define NCR5380_implementation_fields \
-	void __iomem *iomem; \
-	resource_size_t iomem_size; \
-	int c400_ctl_status; \
-	int c400_blk_cnt; \
-	int c400_host_buf;
-
-#endif
-
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
         generic_NCR5380_dma_xfer_len(instance, cmd)
 #define NCR5380_dma_recv_setup		generic_NCR5380_pread
@@ -73,4 +59,3 @@
 #define BOARD_HP_C2502	4
 
 #endif /* GENERIC_NCR5380_H */
-
diff --git a/drivers/scsi/g_NCR5380_mmio.c b/drivers/scsi/g_NCR5380_mmio.c
deleted file mode 100644
index 8cdde71..0000000
--- a/drivers/scsi/g_NCR5380_mmio.c
+++ /dev/null
@@ -1,10 +0,0 @@
-/*
- *	There is probably a nicer way to do this but this one makes
- *	pretty obvious what is happening. We rebuild the same file with
- *	different options for mmio versus pio.
- */
-
-#define SCSI_G_NCR5380_MEM
-
-#include "g_NCR5380.c"
-
-- 
2.7.3

