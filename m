From: Dave Jones <davej@redhat.com>
Subject: [PATCH] plug leaks in aic79xx
Date: Thu, 2 Sep 2004 20:19:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409021919.i82JJZ1d016551@delerium.codemonkey.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from delerium.kernelslacker.org ([81.187.208.145]:49286 "EHLO
	delerium.codemonkey.org.uk") by vger.kernel.org with ESMTP
	id S268334AbUIBTTy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Sep 2004 15:19:54 -0400
Received: from delerium.codemonkey.org.uk (localhost.localdomain [127.0.0.1])
	by delerium.codemonkey.org.uk (8.13.1/8.13.1) with ESMTP id i82JJZ1A016552
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2004 20:19:35 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Spotted with the source checker from Coverity.com.

Signed-off-by: Dave Jones <davej@redhat.com>


diff -urpN --exclude-from=/home/davej/.exclude bk-linus/drivers/scsi/aic7xxx/aic79xx_osm.c linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c
--- bk-linus/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-08-28 21:57:23.000000000 +0100
+++ linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c	2004-09-01 13:31:12.000000000 +0100
@@ -1560,6 +1560,8 @@ ahd_linux_dev_reset(Scsi_Cmnd *cmd)
 
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 	recovery_cmd = malloc(sizeof(struct scsi_cmnd), M_DEVBUF, M_WAITOK);
+	if (!recovery_cmd)
+		return (FAILED);
 	memset(recovery_cmd, 0, sizeof(struct scsi_cmnd));
 	recovery_cmd->device = cmd->device;
 	recovery_cmd->scsi_done = ahd_linux_dev_reset_complete;
@@ -1575,10 +1577,12 @@ ahd_linux_dev_reset(Scsi_Cmnd *cmd)
 				   cmd->device->lun, /*alloc*/FALSE);
 	if (dev == NULL) {
 		ahd_midlayer_entrypoint_unlock(ahd, &s);
+		kfree(recovery_cmd);
 		return (FAILED);
 	}
 	if ((scb = ahd_get_scb(ahd, AHD_NEVER_COL_IDX)) == NULL) {
 		ahd_midlayer_entrypoint_unlock(ahd, &s);
+		kfree(recovery_cmd);
 		return (FAILED);
 	}
 	tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
@@ -1773,6 +1777,7 @@ ahd_dmamem_alloc(struct ahd_softc *ahd, 
 	if (ahd->dev_softc != NULL)
 		if (ahd_pci_set_dma_mask(ahd->dev_softc, 0xFFFFFFFF)) {
 			printk(KERN_WARNING "aic79xx: No suitable DMA available.\n");
+			kfree(map);
 			return (ENODEV);
 		}
 	*vaddr = pci_alloc_consistent(ahd->dev_softc,
@@ -1781,6 +1786,7 @@ ahd_dmamem_alloc(struct ahd_softc *ahd, 
 		if (ahd_pci_set_dma_mask(ahd->dev_softc,
 				     ahd->platform_data->hw_dma_mask)) {
 			printk(KERN_WARNING "aic79xx: No suitable DMA available.\n");
+			kfree(map);
 			return (ENODEV);
 		}
 #else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0) */
