From: Grant Grundler <grundler@parisc-linux.org>
Subject: PATCH 2.6.11-rc4 rename IOMAPPED config option
Date: Sun, 20 Feb 2005 18:07:58 -0700
Message-ID: <20050221010758.GC30800@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from colo.lackof.org ([198.49.126.79]:23019 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S261160AbVBUBHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 20:07:08 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: willy@parisc-linux.org
Cc: linux-scsi@vger.kernel.org

Willy,
I'm always confused by what CONFIG_SCSI_SYM53C8XX_IOMAPPED
is supposed to mean. When enabled, the driver uses IO Port space.
But "IOMAPPED" is just too close to "Memory Mapped IO" (MMIO).

Following patch renames this to SCSI_SYM53C8XX_USE_MMIO.
I don't need to read the config help to understand what this means.

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

Index: drivers/scsi/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/Kconfig,v
retrieving revision 1.32
diff -u -p -r1.32 Kconfig
--- drivers/scsi/Kconfig	3 Feb 2005 11:44:46 -0000	1.32
+++ drivers/scsi/Kconfig	21 Feb 2005 00:46:18 -0000
@@ -1016,13 +1016,15 @@ config SCSI_SYM53C8XX_MAX_TAGS
 	  possible. The driver supports up to 256 queued commands per device.
 	  This value is used as a compiled-in hard limit.
 
-config SCSI_SYM53C8XX_IOMAPPED
-	bool "use port IO"
+config SCSI_SYM53C8XX_USE_MMIO
+	bool "use MMIO space"
 	depends on SCSI_SYM53C8XX_2
+	default y
 	help
-	  If you say Y here, the driver will use port IO to access
-	  the card.  This is significantly slower then using memory
-	  mapped IO.  Most people should answer N.
+	  If you say Y here, the driver will use MMIO address space
+	  to access the card.  IO Port space access is significantly
+	  slower than MMIO space access.
+	  Most people should answer Y.
 
 config SCSI_IPR
 	tristate "IBM Power Linux RAID adapter support"
Index: drivers/scsi/sym53c8xx_2/sym53c8xx.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym53c8xx.h,v
retrieving revision 1.14
diff -u -p -r1.14 sym53c8xx.h
--- drivers/scsi/sym53c8xx_2/sym53c8xx.h	8 Jan 2005 22:11:08 -0000	1.14
+++ drivers/scsi/sym53c8xx_2/sym53c8xx.h	21 Feb 2005 00:46:18 -0000
@@ -42,10 +42,6 @@
 
 #include <linux/config.h>
 
-#ifdef CONFIG_SCSI_SYM53C8XX_IOMAPPED
-#define	SYM_CONF_IOMAPPED
-#endif
-
 /*
  *  DMA addressing mode.
  *
Index: drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c,v
retrieving revision 1.84
diff -u -p -r1.84 sym_glue.c
--- drivers/scsi/sym53c8xx_2/sym_glue.c	20 Feb 2005 23:49:27 -0000	1.84
+++ drivers/scsi/sym53c8xx_2/sym_glue.c	21 Feb 2005 00:46:18 -0000
@@ -1915,7 +1915,7 @@ sym_init_device(struct pci_dev *pdev, st
 	i = pci_get_base_address(pdev, 1, &device->s.base);
 	pci_get_base_address(pdev, i, &device->s.base_2);
 
-#ifdef CONFIG_SCSI_SYM53C8XX_IOMAPPED
+#ifndef CONFIG_SCSI_SYM53C8XX_USE_MMIO
 	device->s.ioaddr = pci_iomap(pdev, 0, pci_resource_len(pdev, 0));
 #else
 	device->s.ioaddr = pci_iomap(pdev, 1, pci_resource_len(pdev, 1));
Index: drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c,v
retrieving revision 1.48
diff -u -p -r1.48 sym_hipd.c
--- drivers/scsi/sym53c8xx_2/sym_hipd.c	16 Feb 2005 20:54:02 -0000	1.48
+++ drivers/scsi/sym53c8xx_2/sym_hipd.c	21 Feb 2005 00:46:18 -0000
@@ -1044,7 +1044,7 @@ static int sym_prepare_setting(struct sy
  *
  *  Has to be called with interrupts disabled.
  */
-#ifndef SYM_CONF_IOMAPPED
+#ifdef CONFIG_SCSI_SYM53C8XX_USE_MMIO
 static int sym_regtest (struct sym_hcb *np)
 {
 	register volatile u32 data;
@@ -1073,7 +1073,7 @@ static int sym_snooptest (struct sym_hcb
 {
 	u32	sym_rd, sym_wr, sym_bk, host_rd, host_wr, pc, dstat;
 	int	i, err=0;
-#ifndef SYM_CONF_IOMAPPED
+#ifdef CONFIG_SCSI_SYM53C8XX_USE_MMIO
 	err |= sym_regtest (np);
 	if (err) return (err);
 #endif
