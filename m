From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [PATCH 19/19] drivers/scsi/sata_vsc: Use the DMA_{64,32}BIT_MASK constants
Date: Sun, 20 Feb 2005 18:13:31 +0100
Message-ID: <20050220171331.GT14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:42503 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261895AbVBTRMq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 12:12:46 -0500
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

--- linux-2.6.11-rc4.orig/drivers/scsi/sata_vsc.c	2005-02-13 17:13:07.000000000 +0100
+++ linux-2.6.11-rc4/drivers/scsi/sata_vsc.c	2005-02-16 21:25:01.000000000 +0100
@@ -280,10 +280,10 @@ static int __devinit vsc_sata_init_one (
 	/*
 	 * Use 32 bit DMA mask, because 64 bit address support is poor.
 	 */
-	rc = pci_set_dma_mask(pdev, 0xFFFFFFFFULL);
+	rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (rc)
 		goto err_out_regions;
-	rc = pci_set_consistent_dma_mask(pdev, 0xFFFFFFFFULL);
+	rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 	if (rc)
 		goto err_out_regions;
 
