From: Stephen Hemminger <shemminger@osdl.org>
Subject: [PATCH] aic7xxx: fix compiler warning from dma mask assignement
Date: Thu, 18 Nov 2004 12:24:15 -0800
Message-ID: <20041118122415.539351f9@zqx3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:14041 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261163AbUKRUVM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 15:21:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Get rid of a compiler warning because assignment truncating a 64 bit constant
and use existing definitions.

Signed-off-by: Stephen Hemminger <shemminger@osdl.org>

--- linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-10-21 09:03:28.000000000 -0700
+++ sk-rev2/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2004-11-18 12:20:03.750111896 -0800
@@ -175,7 +175,6 @@
 ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	char		 buf[80];
-	dma_addr_t	 mask_39bit;
 	struct		 ahc_softc *ahc;
 	ahc_dev_softc_t	 pci;
 	struct		 ahc_pci_identity *entry;
@@ -226,18 +225,18 @@
 	}
 	pci_set_master(pdev);
 
-	mask_39bit = 0x7FFFFFFFFFULL;
-	if (sizeof(dma_addr_t) > 4
+#define DMA_39BIT_MASK	0x0000007fffffffffULL
+	if (sizeof(dma_addr_t) > 4 
 	 && ahc_linux_get_memsize() > 0x80000000
-	 && pci_set_dma_mask(pdev, mask_39bit) == 0) {
+	 && pci_set_dma_mask(pdev, DMA_39BIT_MASK) == 0) {
 		ahc->flags |= AHC_39BIT_ADDRESSING;
-		ahc->platform_data->hw_dma_mask = mask_39bit;
-	} else {
-		if (pci_set_dma_mask(pdev, 0xFFFFFFFF)) {
-			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
-                	return (-ENODEV);
-		}
-		ahc->platform_data->hw_dma_mask = 0xFFFFFFFF;
+		ahc->platform_data->hw_dma_mask = (dma_addr_t) DMA_39BIT_MASK;
+	} 
+	else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) == 0) 
+		ahc->platform_data->hw_dma_mask = DMA_32BIT_MASK;
+	else {
+		printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
+		return (-ENODEV);
 	}
 #endif
 	ahc->dev_softc = pci;
