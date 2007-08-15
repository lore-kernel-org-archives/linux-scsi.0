From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] aic94xx: Free scsi host on error
Date: Wed, 15 Aug 2007 12:56:55 -0600
Message-ID: <11872042213665-git-send-email-matthew@wil.cx>
References: <11872042213451-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:36459 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763896AbXHOS45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 14:56:57 -0400
In-Reply-To: <11872042213451-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

If an error occurred during initialisation, we would sometimes fail to
call scsi_host_put() and thus end up with a leaked scsi_host.  It was
also possible to miss calling scsi_remove_host().

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/aic94xx/aic94xx_init.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 63bcde2..12738bc 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -583,7 +583,7 @@ static int __devinit asd_pci_probe(struct pci_dev *dev,
 	asd_ha = kzalloc(sizeof(*asd_ha), GFP_KERNEL);
 	if (!asd_ha) {
 		asd_printk("out of memory\n");
-		goto Err;
+		goto Err_put;
 	}
 	asd_ha->pcidev = dev;
 	asd_ha->sas_ha.dev = &asd_ha->pcidev->dev;
@@ -600,14 +600,12 @@ static int __devinit asd_pci_probe(struct pci_dev *dev,
 	shost->max_cmd_len = 16;
 
 	err = scsi_add_host(shost, &dev->dev);
-	if (err) {
-		scsi_host_put(shost);
+	if (err)
 		goto Err_free;
-	}
 
 	err = asd_dev->setup(asd_ha);
 	if (err)
-		goto Err_free;
+		goto Err_remove;
 
 	err = -ENODEV;
 	if (!pci_set_dma_mask(dev, DMA_64BIT_MASK)
@@ -618,14 +616,14 @@ static int __devinit asd_pci_probe(struct pci_dev *dev,
 		;
 	else {
 		asd_printk("no suitable DMA mask for %s\n", pci_name(dev));
-		goto Err_free;
+		goto Err_remove;
 	}
 
 	pci_set_drvdata(dev, asd_ha);
 
 	err = asd_map_ha(asd_ha);
 	if (err)
-		goto Err_free;
+		goto Err_remove;
 
 	err = asd_create_ha_caches(asd_ha);
         if (err)
@@ -692,9 +690,12 @@ Err_free_cache:
 	asd_destroy_ha_caches(asd_ha);
 Err_unmap:
 	asd_unmap_ha(asd_ha);
+Err_remove:
+	scsi_remove_host(shost);
 Err_free:
 	kfree(asd_ha);
-	scsi_remove_host(shost);
+Err_put:
+	scsi_host_put(shost);
 Err:
 	pci_disable_device(dev);
 	return err;
-- 
1.5.2.4

