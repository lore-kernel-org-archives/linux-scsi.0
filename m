From: Dave Jones <davej@redhat.com>
Subject: [PATCH] plug leaks in aic7xxx_osm
Date: Thu, 2 Sep 2004 20:19:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409021919.i82JJZkj016556@delerium.codemonkey.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from delerium.kernelslacker.org ([81.187.208.145]:49798 "EHLO
	delerium.codemonkey.org.uk") by vger.kernel.org with ESMTP
	id S268336AbUIBTTy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Sep 2004 15:19:54 -0400
Received: from delerium.codemonkey.org.uk (localhost.localdomain [127.0.0.1])
	by delerium.codemonkey.org.uk (8.13.1/8.13.1) with ESMTP id i82JJZVp016557
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2004 20:19:35 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Spotted with the source checker from Coverity.com.

Signed-off-by: Dave Jones <davej@redhat.com>


diff -urpN --exclude-from=/home/davej/.exclude bk-linus/drivers/scsi/aic7xxx/aic7xxx_osm.c linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- bk-linus/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-08-28 21:57:23.000000000 +0100
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-09-01 13:31:12.000000000 +0100
@@ -1408,6 +1408,7 @@ ahc_dmamem_alloc(struct ahc_softc *ahc, 
 	if (ahc->dev_softc != NULL)
 		if (ahc_pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF)) {
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
+			kfree(map);
 			return (ENODEV);
 		}
 	*vaddr = pci_alloc_consistent(ahc->dev_softc,
@@ -1416,6 +1417,7 @@ ahc_dmamem_alloc(struct ahc_softc *ahc, 
 		if (ahc_pci_set_dma_mask(ahc->dev_softc,
 				     ahc->platform_data->hw_dma_mask)) {
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
+			kfree(map);
 			return (ENODEV);
 		}
 #else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0) */
