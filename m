From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [PATCH 18/19] drivers/scsi/qlogicfc: Use the DMA_{64,32}BIT_MASK constants
Date: Sun, 20 Feb 2005 18:12:44 +0100
Message-ID: <20050220171244.GS14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:7436 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261892AbVBTRL5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 12:11:57 -0500
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

--- linux-2.6.11-rc4.orig/drivers/scsi/qlogicfc.c	2005-02-13 17:13:07.000000000 +0100
+++ linux-2.6.11-rc4/drivers/scsi/qlogicfc.c	2005-02-16 21:24:00.000000000 +0100
@@ -719,8 +719,8 @@ int isp2x00_detect(Scsi_Host_Template * 
 				continue;
 
 			/* Try to configure DMA attributes. */
-			if (pci_set_dma_mask(pdev, 0xffffffffffffffffULL) &&
-			    pci_set_dma_mask(pdev, 0xffffffffULL))
+			if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) &&
+			    pci_set_dma_mask(pdev, DMA_32BIT_MASK))
 					continue;
 
 		        host = scsi_register(tmpt, sizeof(struct isp2x00_hostdata));
