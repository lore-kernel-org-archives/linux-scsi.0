From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [PATCH 02/19] drivers/scsi/acraid/aachba: Use the DMA_{64,32}BIT_MASK constants
Date: Sun, 20 Feb 2005 17:52:01 +0100
Message-ID: <20050220165201.GB14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:19973 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261871AbVBTQvP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 11:51:15 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@lists.osdl.org
Cc: linux-scsi@vger.kernel.org

Hello,

Description: Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h
when calling pci_set_dma_mask() or pci_set_consistent_dma_mask()
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

--- linux-2.6.11-rc4.orig/drivers/scsi/aacraid/aachba.c	2005-02-13 17:13:06.000000000 +0100
+++ linux-2.6.11-rc4/drivers/scsi/aacraid/aachba.c	2005-02-16 21:28:16.000000000 +0100
@@ -687,12 +687,12 @@ int aac_get_adapter_info(struct aac_dev*
 		dev->dac_support = (dacmode!=0);
 	}
 	if(dev->dac_support != 0) {
-		if (!pci_set_dma_mask(dev->pdev, 0xFFFFFFFFFFFFFFFFULL) &&
-			!pci_set_consistent_dma_mask(dev->pdev, 0xFFFFFFFFFFFFFFFFULL)) {
+		if (!pci_set_dma_mask(dev->pdev, DMA_64BIT_MASK) &&
+			!pci_set_consistent_dma_mask(dev->pdev, DMA_64BIT_MASK)) {
 			printk(KERN_INFO"%s%d: 64 Bit DAC enabled\n",
 				dev->name, dev->id);
-		} else if (!pci_set_dma_mask(dev->pdev, 0xFFFFFFFFULL) &&
-			!pci_set_consistent_dma_mask(dev->pdev, 0xFFFFFFFFULL)) {
+		} else if (!pci_set_dma_mask(dev->pdev, DMA_32BIT_MASK) &&
+			!pci_set_consistent_dma_mask(dev->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_INFO"%s%d: DMA mask set failed, 64 Bit DAC disabled\n",
 				dev->name, dev->id);
 			dev->dac_support = 0;
