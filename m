From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 01/10] Change Kconfig option from IOMAPPED to MMIO
Date: Tue, 28 Mar 2006 11:03:43 -0500
Message-ID: <1143561823406-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.magma.ca ([206.191.0.250]:34998 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1751200AbWC1QDa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 11:03:30 -0500
In-Reply-To: 20060328160156.GJ3486@parisc-linux.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Most of the Kconfig options for switching between IO Port and MMIO
operations use the opposite sense from sym2.  Really, this option
should be set at a chipset level rather than per-driver.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/Kconfig                |   15 ++++++++-------
 drivers/scsi/sym53c8xx_2/sym_glue.c |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   29 +++++++++++++++++------------
 3 files changed, 26 insertions(+), 20 deletions(-)

c3c9b1f23af291e2dee3497401cea5ec7f6e8b44
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4035920..79cefe0 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1079,7 +1079,7 @@ config SCSI_SYM53C8XX_DMA_ADDRESSING_MOD
 	  memory using PCI DAC cycles.
 
 config SCSI_SYM53C8XX_DEFAULT_TAGS
-	int "default tagged command queue depth"
+	int "Default tagged command queue depth"
 	depends on SCSI_SYM53C8XX_2
 	default "16"
 	help
@@ -1090,7 +1090,7 @@ config SCSI_SYM53C8XX_DEFAULT_TAGS
 	  exceed CONFIG_SCSI_SYM53C8XX_MAX_TAGS.
 
 config SCSI_SYM53C8XX_MAX_TAGS
-	int "maximum number of queued commands"
+	int "Maximum number of queued commands"
 	depends on SCSI_SYM53C8XX_2
 	default "64"
 	help
@@ -1099,13 +1099,14 @@ config SCSI_SYM53C8XX_MAX_TAGS
 	  possible. The driver supports up to 256 queued commands per device.
 	  This value is used as a compiled-in hard limit.
 
-config SCSI_SYM53C8XX_IOMAPPED
-	bool "use port IO"
+config SCSI_SYM53C8XX_MMIO
+	bool "Use memory mapped IO"
 	depends on SCSI_SYM53C8XX_2
+	default y
 	help
-	  If you say Y here, the driver will use port IO to access
-	  the card.  This is significantly slower then using memory
-	  mapped IO.  Most people should answer N.
+	  Memory mapped IO is faster than Port IO.  Most people should
+	  answer Y here, but some machines may have problems.  If you have
+	  to answer N here, please report the problem to the maintainer.
 
 config SCSI_IPR
 	tristate "IBM Power Linux RAID adapter support"
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 1fffd2b..ec9d93a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1874,7 +1874,7 @@ sym_init_device(struct pci_dev *pdev, st
 	i = pci_get_base_address(pdev, 1, &device->mmio_base);
 	pci_get_base_address(pdev, i, &device->ram_base);
 
-#ifndef CONFIG_SCSI_SYM53C8XX_IOMAPPED
+#ifdef CONFIG_SCSI_SYM53C8XX_MMIO
 	if (device->mmio_base)
 		device->s.ioaddr = pci_iomap(pdev, 1,
 						pci_resource_len(pdev, 1));
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 60850cb..a95b262 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -973,8 +973,8 @@ static int sym_prepare_setting(struct Sc
  *
  *  Has to be called with interrupts disabled.
  */
-#ifndef CONFIG_SCSI_SYM53C8XX_IOMAPPED
-static int sym_regtest (struct sym_hcb *np)
+#ifdef CONFIG_SCSI_SYM53C8XX_MMIO
+static int sym_regtest(struct sym_hcb *np)
 {
 	register volatile u32 data;
 	/*
@@ -992,20 +992,25 @@ static int sym_regtest (struct sym_hcb *
 #endif
 		printf ("CACHE TEST FAILED: reg dstat-sstat2 readback %x.\n",
 			(unsigned) data);
-		return (0x10);
+		return 0x10;
 	}
-	return (0);
+	return 0;
+}
+#else
+static inline int sym_regtest(struct sym_hcb *np)
+{
+	return 0;
 }
 #endif
 
-static int sym_snooptest (struct sym_hcb *np)
+static int sym_snooptest(struct sym_hcb *np)
 {
-	u32	sym_rd, sym_wr, sym_bk, host_rd, host_wr, pc, dstat;
-	int	i, err=0;
-#ifndef CONFIG_SCSI_SYM53C8XX_IOMAPPED
-	err |= sym_regtest (np);
-	if (err) return (err);
-#endif
+	u32 sym_rd, sym_wr, sym_bk, host_rd, host_wr, pc, dstat;
+	int i, err;
+
+	err = sym_regtest(np);
+	if (err)
+		return err;
 restart_test:
 	/*
 	 *  Enable Master Parity Checking as we intend 
@@ -1094,7 +1099,7 @@ restart_test:
 		err |= 4;
 	}
 
-	return (err);
+	return err;
 }
 
 /*
-- 
1.2.4.g375a5


