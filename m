From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 06/10] scsi: ufs: use devres functions for ufshcd
Date: Wed, 26 Jun 2013 22:34:02 +0530
Message-ID: <1372266246-2725-7-git-send-email-santoshsy@gmail.com>
References: <1372266246-2725-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55400 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3FZRFC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jun 2013 13:05:02 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so14497416pbb.36
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2013 10:05:02 -0700 (PDT)
In-Reply-To: <1372266246-2725-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 00james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Seungwon Jeon <tgih.jun@samsung.com>, Santosh Y <santoshsy@gmail.com>

From: Seungwon Jeon <tgih.jun@samsung.com>

This patch replaces normal calls for resource allocation with devm_*()
derivative functions. It makes resource freeing simpler.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 5cb1d75..48be39a 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -92,7 +92,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 	struct ufs_hba *hba = pci_get_drvdata(pdev);
 
 	disable_irq(pdev->irq);
-	free_irq(pdev->irq, hba);
 	ufshcd_remove(hba);
 	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 3db2ee1..0e48827 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -33,9 +33,10 @@
  * this program.
  */
 
-#include "ufshcd.h"
 #include <linux/platform_device.h>
 
+#include "ufshcd.h"
+
 #ifdef CONFIG_PM
 /**
  * ufshcd_pltfrm_suspend - suspend power management function
@@ -97,62 +98,45 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 	struct ufs_hba *hba;
 	void __iomem *mmio_base;
 	struct resource *mem_res;
-	struct resource *irq_res;
-	resource_size_t mem_size;
-	int err;
+	int irq, err;
 	struct device *dev = &pdev->dev;
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem_res) {
-		dev_err(&pdev->dev,
-			"Memory resource not available\n");
+		dev_err(dev, "Memory resource not available\n");
 		err = -ENODEV;
-		goto out_error;
+		goto out;
 	}
 
-	mem_size = resource_size(mem_res);
-	if (!request_mem_region(mem_res->start, mem_size, "ufshcd")) {
-		dev_err(&pdev->dev,
-			"Cannot reserve the memory resource\n");
-		err = -EBUSY;
-		goto out_error;
+	mmio_base = devm_ioremap_resource(dev, mem_res);
+	if (IS_ERR(mmio_base)) {
+		dev_err(dev, "memory map failed\n");
+		err = PTR_ERR(mmio_base);
+		goto out;
 	}
 
-	mmio_base = ioremap_nocache(mem_res->start, mem_size);
-	if (!mmio_base) {
-		dev_err(&pdev->dev, "memory map failed\n");
-		err = -ENOMEM;
-		goto out_release_regions;
-	}
-
-	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!irq_res) {
-		dev_err(&pdev->dev, "IRQ resource not available\n");
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(dev, "IRQ resource not available\n");
 		err = -ENODEV;
-		goto out_iounmap;
+		goto out;
 	}
 
 	err = dma_set_coherent_mask(dev, dev->coherent_dma_mask);
 	if (err) {
-		dev_err(&pdev->dev, "set dma mask failed\n");
-		goto out_iounmap;
+		dev_err(dev, "set dma mask failed\n");
+		goto out;
 	}
 
-	err = ufshcd_init(&pdev->dev, &hba, mmio_base, irq_res->start);
+	err = ufshcd_init(dev, &hba, mmio_base, irq);
 	if (err) {
-		dev_err(&pdev->dev, "Intialization failed\n");
-		goto out_iounmap;
+		dev_err(dev, "Intialization failed\n");
+		goto out;
 	}
 
 	platform_set_drvdata(pdev, hba);
 
-	return 0;
-
-out_iounmap:
-	iounmap(mmio_base);
-out_release_regions:
-	release_mem_region(mem_res->start, mem_size);
-out_error:
+out:
 	return err;
 }
 
@@ -164,26 +148,10 @@ out_error:
  */
 static int ufshcd_pltfrm_remove(struct platform_device *pdev)
 {
-	struct resource *mem_res;
-	resource_size_t mem_size;
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
 
 	disable_irq(hba->irq);
-
-	/* Some buggy controllers raise interrupt after
-	 * the resources are removed. So first we unregister the
-	 * irq handler and then the resources used by driver
-	 */
-
-	free_irq(hba->irq, hba);
 	ufshcd_remove(hba);
-	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem_res)
-		dev_err(&pdev->dev, "ufshcd: Memory resource not available\n");
-	else {
-		mem_size = resource_size(mem_res);
-		release_mem_region(mem_res->start, mem_size);
-	}
 	return 0;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2230f14..255f5be 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1789,7 +1789,7 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	mutex_init(&hba->uic_cmd_mutex);
 
 	/* IRQ registration */
-	err = request_irq(irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
+	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
 		goto out_lrb_free;
@@ -1799,13 +1799,13 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	err = scsi_init_shared_tag_map(host, host->can_queue);
 	if (err) {
 		dev_err(hba->dev, "init shared queue failed\n");
-		goto out_free_irq;
+		goto out_lrb_free;
 	}
 
 	err = scsi_add_host(host, hba->dev);
 	if (err) {
 		dev_err(hba->dev, "scsi_add_host failed\n");
-		goto out_free_irq;
+		goto out_lrb_free;
 	}
 
 	/* Host controller enable */
@@ -1823,8 +1823,6 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
-out_free_irq:
-	free_irq(irq, hba);
 out_lrb_free:
 	ufshcd_free_hba_memory(hba);
 out_disable:
-- 
1.8.3.1

