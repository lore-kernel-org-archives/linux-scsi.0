From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [PATCH 04/19] drivers/scsi/ahci: Use the DMA_{64,32}BIT_MASK constants
Date: Sun, 20 Feb 2005 17:55:30 +0100
Message-ID: <20050220165530.GD14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:25096 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261873AbVBTQyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 11:54:44 -0500
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

--- linux-2.6.11-rc4.orig/drivers/scsi/ahci.c	2005-02-13 17:13:07.000000000 +0100
+++ linux-2.6.11-rc4/drivers/scsi/ahci.c	2005-02-16 21:19:53.000000000 +0100
@@ -756,10 +756,10 @@ static int ahci_host_init(struct ata_pro
 
 	using_dac = hpriv->cap & HOST_CAP_64;
 	if (using_dac &&
-	    !pci_set_dma_mask(pdev, 0xffffffffffffffffULL)) {
-		rc = pci_set_consistent_dma_mask(pdev, 0xffffffffffffffffULL);
+	    !pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
 		if (rc) {
-			rc = pci_set_consistent_dma_mask(pdev, 0xffffffffULL);
+			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 			if (rc) {
 				printk(KERN_ERR DRV_NAME "(%s): 64-bit DMA enable failed\n",
 					pci_name(pdev));
@@ -769,13 +769,13 @@ static int ahci_host_init(struct ata_pro
 
 		hpriv->flags |= HOST_CAP_64;
 	} else {
-		rc = pci_set_dma_mask(pdev, 0xffffffffULL);
+		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 		if (rc) {
 			printk(KERN_ERR DRV_NAME "(%s): 32-bit DMA enable failed\n",
 				pci_name(pdev));
 			return rc;
 		}
-		rc = pci_set_consistent_dma_mask(pdev, 0xffffffffULL);
+		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 		if (rc) {
 			printk(KERN_ERR DRV_NAME "(%s): 32-bit consistent DMA enable failed\n",
 				pci_name(pdev));
