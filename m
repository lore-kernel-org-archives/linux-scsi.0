From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: [UPDATE PATCH 05/19] drivers/scsi/aic7xxx/aic79xx_osm: Use the DMA_32BIT_MASK constant
Date: Sun, 20 Mar 2005 13:40:08 +0100
Message-ID: <20050320124008.GE3491@localhost.localdomain>
References: <20050220165632.GE14375@helium.tklauser.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from server3.hostpoint.ch ([217.26.52.13]:52237 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261180AbVCTMkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 07:40:11 -0500
Content-Disposition: inline
In-Reply-To: <20050220165632.GE14375@helium.tklauser.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@lists.osdl.org
Cc: linux-scsi@vger.kernel.org

The previous patch did not compile cleanly on all architectures so
here's a fixed one.

Use the DMA_32BIT_MASK constant from dma-mapping.h when calling
pci_set_dma_mask() or pci_set_consistent_dma_mask()
This patch includes dma-mapping.h explicitly because it caused errors
on some architectures otherwise.
See http://marc.theaimsgroup.com/?t=108001993000001&r=1&w=2 for details

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>

--- linux-2.6.11.orig/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-03-02 12:50:36.000000000 +0100
+++ linux-2.6.11/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-03-20 13:27:54.000000000 +0100
@@ -60,6 +60,7 @@
 
 #include <linux/mm.h>		/* For fetching system memory size */
 #include <linux/delay.h>	/* For ssleep/msleep */
+#include <linux/dma-mapping.h>
 
 /*
  * Lock protecting manipulation of the ahd softc list.
@@ -1706,7 +1707,7 @@ ahd_dmamem_alloc(struct ahd_softc *ahd, 
 	 * our dma mask when doing allocations.
 	 */
 	if (ahd->dev_softc != NULL)
-		if (pci_set_dma_mask(ahd->dev_softc, 0xFFFFFFFF)) {
+		if (pci_set_dma_mask(ahd->dev_softc, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "aic79xx: No suitable DMA available.\n");
 			kfree(map);
 			return (ENODEV);
