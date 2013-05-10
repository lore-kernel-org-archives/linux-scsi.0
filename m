From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH resend] scsi: ufs: use devres functions for ufshcd
Date: Fri, 10 May 2013 20:05:33 +0900
Message-ID: <000101ce4d6e$4aecd760$e0c68620$%jun@samsung.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
 <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <001201ce4d6b$1658c980$430a5c80$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:54476 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3EJLFw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 May 2013 07:05:52 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MMK00D02XHAQE11@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 10 May 2013 20:05:34 +0900 (KST)
In-reply-to: <001201ce4d6b$1658c980$430a5c80$%jun@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

This patches replaces normal calls for resource allocation with devm_*()
derivative functions. It makes the routine to free resources simpler.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/scsi/ufs/ufshcd-pci.c    |    1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c |   72 +++++++++----------------------------
 drivers/scsi/ufs/ufshcd.c        |    8 ++---
 3 files changed, 21 insertions(+), 60 deletions(-)

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
index 03319ac..81d3db5 100644
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
@@ -97,63 +98,42 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
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
-		err = -ENODEV;
-		goto out_error;
+		dev_err(dev, "Memory resource not available\n");
+		return -ENODEV;
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
+		return PTR_ERR(mmio_base);
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
-		err = -ENODEV;
-		goto out_iounmap;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(dev, "IRQ resource not available\n");
+		return -ENODEV;
 	}
 
 	err = dma_set_coherent_mask(dev, dev->coherent_dma_mask);
 	if (err) {
-		dev_err(&pdev->dev, "set dma mask failed\n");
-		goto out_iounmap;
+		dev_err(dev, "set dma mask failed\n");
+		return err;
 	}
 
-	err = ufshcd_init(&pdev->dev, &hba, mmio_base, irq_res->start);
+	err = ufshcd_init(dev, &hba, mmio_base, irq);
 	if (err) {
-		dev_err(&pdev->dev, "Intialization failed\n");
-		goto out_iounmap;
+		dev_err(dev, "Intialization failed\n");
+		return err;
 	}
 
 	platform_set_drvdata(pdev, hba);
 
 	return 0;
-
-out_iounmap:
-	iounmap(mmio_base);
-out_release_regions:
-	release_mem_region(mem_res->start, mem_size);
-out_error:
-	return err;
 }
 
 /**
@@ -164,26 +144,10 @@ out_error:
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
 	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8363b92..eb8a328 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2050,7 +2050,7 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	mutex_init(&hba->uic_cmd_mutex);
 
 	/* IRQ registration */
-	err = request_irq(irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
+	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
 		goto out_lrb_free;
@@ -2060,13 +2060,13 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
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
@@ -2084,8 +2084,6 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
-out_free_irq:
-	free_irq(irq, hba);
 out_lrb_free:
 	ufshcd_free_hba_memory(hba);
 out_disable:
-- 
1.7.0.4


