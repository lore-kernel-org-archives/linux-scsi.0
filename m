From: willy@parisc-linux.org (Matthew Wilcox)
Subject: [PATCH] [3/5] Zalon updates
Date: Fri, 18 Mar 2005 20:56:31 -0700 (MST)
Message-ID: <20050319035631.CAF2A496108@palinux.hppa>
Received: from palinux.external.hp.com ([192.25.206.14]:50323 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S262060AbVCSD4c
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2005 22:56:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Zalon updates

 - Add KERN_INFO to printk
Signed-off-by: Andrew McGregor <am@misk.net>
Signed-off-by: Domen Puncer <domen@coderock.org>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>

 - Remove iomem-related warnings
 - Improve printk message
 - Use cpu_relax()
Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff -urpNX dontdiff linus-2.6/drivers/scsi/zalon.c parisc-2.6/drivers/scsi/zalon.c
--- linus-2.6/drivers/scsi/zalon.c	2005-03-18 06:21:12.604526151 -0700
+++ parisc-2.6/drivers/scsi/zalon.c	2005-03-18 06:03:07.000000000 -0700
@@ -88,31 +88,30 @@ zalon_probe(struct parisc_device *dev)
 	struct gsc_irq gsc_irq;
 	u32 zalon_vers;
 	int error = -ENODEV;
-	unsigned long zalon = dev->hpa;
-	unsigned long io_port = zalon + GSC_SCSI_ZALON_OFFSET;
+	void __iomem *zalon = ioremap(dev->hpa, 4096);
+	void __iomem *io_port = zalon + GSC_SCSI_ZALON_OFFSET;
 	static int unit = 0;
 	struct Scsi_Host *host;
 	struct ncr_device device;
 
 	__raw_writel(CMD_RESET, zalon + IO_MODULE_IO_COMMAND);
 	while (!(__raw_readl(zalon + IO_MODULE_IO_STATUS) & IOSTATUS_RY))
-		;
+		cpu_relax();
 	__raw_writel(IOIIDATA_MINT5EN | IOIIDATA_PACKEN | IOIIDATA_PREFETCHEN,
 		zalon + IO_MODULE_II_CDATA);
 
 	/* XXX: Save the Zalon version for bug workarounds? */
-	zalon_vers = __raw_readl(dev->hpa + IO_MODULE_II_CDATA) & 0x07000000;
-	zalon_vers >>= 24;
+	zalon_vers = (__raw_readl(zalon + IO_MODULE_II_CDATA) >> 24) & 0x07;
 
 	/* Setup the interrupts first.
 	** Later on request_irq() will register the handler.
 	*/
 	dev->irq = gsc_alloc_irq(&gsc_irq);
 
-	printk("%s: Zalon vers field is 0x%x, IRQ %d\n", __FUNCTION__,
+	printk(KERN_INFO "%s: Zalon version %d, IRQ %d\n", __FUNCTION__,
 		zalon_vers, dev->irq);
 
-	__raw_writel(gsc_irq.txn_addr | gsc_irq.txn_data, dev->hpa + IO_MODULE_EIM);
+	__raw_writel(gsc_irq.txn_addr | gsc_irq.txn_data, zalon + IO_MODULE_EIM);
 
 	if (zalon_vers == 0)
 		printk(KERN_WARNING "%s: Zalon 1.1 or earlier\n", __FUNCTION__);
@@ -120,16 +119,16 @@ zalon_probe(struct parisc_device *dev)
 	memset(&device, 0, sizeof(struct ncr_device));
 
 	/* The following three are needed before any other access. */
-	writeb(0x20, io_port + 0x38); /* DCNTL_REG,  EA  */
-	writeb(0x04, io_port + 0x1b); /* CTEST0_REG, EHP */
-	writeb(0x80, io_port + 0x22); /* CTEST4_REG, MUX */
+	__raw_writeb(0x20, io_port + 0x38); /* DCNTL_REG,  EA  */
+	__raw_writeb(0x04, io_port + 0x1b); /* CTEST0_REG, EHP */
+	__raw_writeb(0x80, io_port + 0x22); /* CTEST4_REG, MUX */
 
 	/* Initialise ncr_device structure with items required by ncr_attach. */
 	device.chip		= zalon720_chip;
 	device.host_id		= 7;
 	device.dev		= &dev->dev;
-	device.slot.base	= (u_long)io_port;
-	device.slot.base_c	= (u_long)io_port;
+	device.slot.base	= dev->hpa + GSC_SCSI_ZALON_OFFSET;
+	device.slot.base_v	= io_port;
 	device.slot.irq		= dev->irq;
 	device.differential	= 2;
 
