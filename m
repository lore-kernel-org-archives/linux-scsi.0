From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [PATCH 12/19] drivers/scsi/initio: Use the DMA_{64,32}BIT_MASK constants
Date: Sun, 20 Feb 2005 18:06:52 +0100
Message-ID: <20050220170652.GM14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:42768 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261885AbVBTRGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 12:06:06 -0500
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

--- linux-2.6.11-rc4.orig/drivers/scsi/initio.c	2005-02-13 17:13:07.000000000 +0100
+++ linux-2.6.11-rc4/drivers/scsi/initio.c	2005-02-16 21:20:34.000000000 +0100
@@ -2793,7 +2793,7 @@ static int tul_NewReturnNumberOfAdapters
 			if (((dRegValue & 0xFF00) >> 8) == 0xFF)
 				dRegValue = 0;
 			wBIOS = (wBIOS << 8) + ((UWORD) ((dRegValue & 0xFF00) >> 8));
-			if (pci_set_dma_mask(pDev, 0xffffffff)) {
+			if (pci_set_dma_mask(pDev, DMA_32BIT_MASK)) {
 				printk(KERN_WARNING 
 				       "i91u: Could not set 32 bit DMA mask\n");
 				continue;
