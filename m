From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [PATCH 06/19] drivers/scsi/aic7xxx/aic7xxx_osm: Use the DMA_{64,32}BIT_MASK constants
Date: Sun, 20 Feb 2005 17:58:02 +0100
Message-ID: <20050220165802.GF14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:18949 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261879AbVBTQ5R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 11:57:17 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hello,

Description: Use the DMA_{64,32}BIT_MASK constants from dma-mapping.h
when calling pci_set_dma_mask() or pci_set_consistent_dma_mask()
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

--- linux-2.6.11-rc4.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-02-13 17:13:06.000000000 +0100
+++ linux-2.6.11-rc4/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-02-16 21:07:01.000000000 +0100
@@ -1361,7 +1361,7 @@ ahc_dmamem_alloc(struct ahc_softc *ahc, 
 	 * our dma mask when doing allocations.
 	 */
 	if (ahc->dev_softc != NULL)
-		if (pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF)) {
+		if (pci_set_dma_mask(ahc->dev_softc, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
 			kfree(map);
 			return (ENODEV);
