From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix compile warning about dma_addr_t in aic7xxx driver
Date: 16 Nov 2004 15:34:22 -0600
Message-ID: <1100640869.2770.65.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62095 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261832AbUKPVek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 16:34:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

an aic compile is giving this:

drivers/scsi/aic7xxx/aic7xxx_osm_pci.c: In function
`ahc_linux_pci_dev_probe':
drivers/scsi/aic7xxx/aic7xxx_osm_pci.c:229: warning: large integer
implicitly truncated to unsigned type

The reason is that mask_39bit is defined as dma_addr_t, so mask_39bit =
0x7FFFFFFFFFULL; is warning if dma_addr_t is only 32 bits.

The attached patch converts all the dma masks in the driver to be their
proper u64 type (or uint64_t to be consistent with aic style).

James

===== drivers/scsi/aic7xxx/aic79xx_osm.h 1.40 vs edited =====
--- 1.40/drivers/scsi/aic7xxx/aic79xx_osm.h	2004-10-20 14:24:37 -05:00
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.h	2004-11-16 15:24:02 -06:00
@@ -540,7 +540,7 @@
 	uint32_t		 irq;		/* IRQ for this adapter */
 	uint32_t		 bios_address;
 	uint32_t		 mem_busaddr;	/* Mem Base Addr */
-	dma_addr_t		 hw_dma_mask;
+	uint64_t		 hw_dma_mask;
 	ahd_linux_softc_flags	 flags;
 };
 
===== drivers/scsi/aic7xxx/aic79xx_osm_pci.c 1.17 vs edited =====
--- 1.17/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-10-20 14:24:38 -05:00
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2004-11-16 15:27:59 -06:00
@@ -170,24 +170,22 @@
 
 	if (sizeof(dma_addr_t) > 4) {
 		uint64_t   memsize;
-		dma_addr_t mask_64bit;
-		dma_addr_t mask_39bit;
+		const uint64_t mask_39bit = 0x7FFFFFFFFFULL;
 
 		memsize = ahd_linux_get_memsize();
-		mask_64bit = (dma_addr_t)0xFFFFFFFFFFFFFFFFULL;
-		mask_39bit = (dma_addr_t)0x7FFFFFFFFFULL;
+
 		if (memsize >= 0x8000000000ULL
-	 	 && pci_set_dma_mask(pdev, mask_64bit) == 0) {
+	 	 && pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0) {
 			ahd->flags |= AHD_64BIT_ADDRESSING;
-			ahd->platform_data->hw_dma_mask = mask_64bit;
+			ahd->platform_data->hw_dma_mask = DMA_64BIT_MASK;
 		} else if (memsize > 0x80000000
 			&& pci_set_dma_mask(pdev, mask_39bit) == 0) {
 			ahd->flags |= AHD_39BIT_ADDRESSING;
 			ahd->platform_data->hw_dma_mask = mask_39bit;
 		}
 	} else {
-		pci_set_dma_mask(pdev, 0xFFFFFFFF);
-		ahd->platform_data->hw_dma_mask = 0xFFFFFFFF;
+		pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		ahd->platform_data->hw_dma_mask = DMA_32BIT_MASK;
 	}
 	ahd->dev_softc = pci;
 	error = ahd_pci_config(ahd, entry);
===== drivers/scsi/aic7xxx/aic7xxx_osm.h 1.57 vs edited =====
--- 1.57/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-10-20 14:24:37 -05:00
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-11-16 15:24:23 -06:00
@@ -545,7 +545,7 @@
 	uint32_t		 irq;		/* IRQ for this adapter */
 	uint32_t		 bios_address;
 	uint32_t		 mem_busaddr;	/* Mem Base Addr */
-	dma_addr_t		 hw_dma_mask;
+	uint64_t		 hw_dma_mask;
 	ahc_linux_softc_flags	 flags;
 };
 
===== drivers/scsi/aic7xxx/aic7xxx_osm_pci.c 1.19 vs edited =====
--- 1.19/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-10-20 14:24:38 -05:00
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-11-16 15:29:03 -06:00
@@ -175,7 +175,7 @@
 ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	char		 buf[80];
-	dma_addr_t	 mask_39bit;
+	const uint64_t	 mask_39bit = 0x7FFFFFFFFFULL;
 	struct		 ahc_softc *ahc;
 	ahc_dev_softc_t	 pci;
 	struct		 ahc_pci_identity *entry;
@@ -226,18 +226,17 @@
 	}
 	pci_set_master(pdev);
 
-	mask_39bit = 0x7FFFFFFFFFULL;
 	if (sizeof(dma_addr_t) > 4
 	 && ahc_linux_get_memsize() > 0x80000000
 	 && pci_set_dma_mask(pdev, mask_39bit) == 0) {
 		ahc->flags |= AHC_39BIT_ADDRESSING;
 		ahc->platform_data->hw_dma_mask = mask_39bit;
 	} else {
-		if (pci_set_dma_mask(pdev, 0xFFFFFFFF)) {
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
                 	return (-ENODEV);
 		}
-		ahc->platform_data->hw_dma_mask = 0xFFFFFFFF;
+		ahc->platform_data->hw_dma_mask = DMA_32BIT_MASK;
 	}
 #endif
 	ahc->dev_softc = pci;

