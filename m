From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH v2 06/10] scsi: ufs: use devres functions for ufshcd
Date: Thu, 27 Jun 2013 13:31:54 +0900
Message-ID: <001801ce72ef$40725cf0$c15716d0$%jun@samsung.com>
References: <1372266575-3468-1-git-send-email-santoshsy@gmail.com>
 <1372266575-3468-7-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26363 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3F0Eb4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jun 2013 00:31:56 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MP10080KB8DZ710@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 27 Jun 2013 13:31:54 +0900 (KST)
In-reply-to: <1372266575-3468-7-git-send-email-santoshsy@gmail.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, 'Santosh Y' <santoshsy@gmail.com>, vinholikatti@gmail.com

This patch replaces normal calls for resource allocation with devm_*()
derivative functions. It makes resource freeing simpler.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Signed-off-by: Santosh Y <santoshsy@gmail.com>
---
Change in v2:
	[NOTE: There are no conflicts with the following series(07~10)]
	- Remove iounmap which is remained.
	- Apply devres to ufshcd_memory_alloc[dmam_alloc_coherent, devm_kzalloc]
	  Accordingly, 'free' related functions are removed.

 drivers/scsi/ufs/ufshcd-pci.c    |    1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c |   72 +++++++++-----------------------
 drivers/scsi/ufs/ufshcd.c        |   86 ++++++++-----------------------------
 3 files changed, 39 insertions(+), 120 deletions(-)

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
index 2230f14..aba461f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -191,38 +191,6 @@ static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_free_hba_memory - Free allocated memory for LRB, request
- *			    and task lists
- * @hba: Pointer to adapter instance
- */
-static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
-{
-	size_t utmrdl_size, utrdl_size, ucdl_size;
-
-	kfree(hba->lrb);
-
-	if (hba->utmrdl_base_addr) {
-		utmrdl_size = sizeof(struct utp_task_req_desc) * hba->nutmrs;
-		dma_free_coherent(hba->dev, utmrdl_size,
-				  hba->utmrdl_base_addr, hba->utmrdl_dma_addr);
-	}
-
-	if (hba->utrdl_base_addr) {
-		utrdl_size =
-		(sizeof(struct utp_transfer_req_desc) * hba->nutrs);
-		dma_free_coherent(hba->dev, utrdl_size,
-				  hba->utrdl_base_addr, hba->utrdl_dma_addr);
-	}
-
-	if (hba->ucdl_base_addr) {
-		ucdl_size =
-		(sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
-		dma_free_coherent(hba->dev, ucdl_size,
-				  hba->ucdl_base_addr, hba->ucdl_dma_addr);
-	}
-}
-
-/**
  * ufshcd_is_valid_req_rsp - checks if controller TR response is valid
  * @ucd_rsp_ptr: pointer to response UPIU
  *
@@ -690,10 +658,10 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 
 	/* Allocate memory for UTP command descriptors */
 	ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
-	hba->ucdl_base_addr = dma_alloc_coherent(hba->dev,
-						 ucdl_size,
-						 &hba->ucdl_dma_addr,
-						 GFP_KERNEL);
+	hba->ucdl_base_addr = dmam_alloc_coherent(hba->dev,
+						  ucdl_size,
+						  &hba->ucdl_dma_addr,
+						  GFP_KERNEL);
 
 	/*
 	 * UFSHCI requires UTP command descriptor to be 128 byte aligned.
@@ -713,10 +681,10 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * UFSHCI requires 1024 byte alignment of UTRD
 	 */
 	utrdl_size = (sizeof(struct utp_transfer_req_desc) * hba->nutrs);
-	hba->utrdl_base_addr = dma_alloc_coherent(hba->dev,
-						  utrdl_size,
-						  &hba->utrdl_dma_addr,
-						  GFP_KERNEL);
+	hba->utrdl_base_addr = dmam_alloc_coherent(hba->dev,
+						   utrdl_size,
+						   &hba->utrdl_dma_addr,
+						   GFP_KERNEL);
 	if (!hba->utrdl_base_addr ||
 	    WARN_ON(hba->utrdl_dma_addr & (PAGE_SIZE - 1))) {
 		dev_err(hba->dev,
@@ -729,10 +697,10 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	 * UFSHCI requires 1024 byte alignment of UTMRD
 	 */
 	utmrdl_size = sizeof(struct utp_task_req_desc) * hba->nutmrs;
-	hba->utmrdl_base_addr = dma_alloc_coherent(hba->dev,
-						   utmrdl_size,
-						   &hba->utmrdl_dma_addr,
-						   GFP_KERNEL);
+	hba->utmrdl_base_addr = dmam_alloc_coherent(hba->dev,
+						    utmrdl_size,
+						    &hba->utmrdl_dma_addr,
+						    GFP_KERNEL);
 	if (!hba->utmrdl_base_addr ||
 	    WARN_ON(hba->utmrdl_dma_addr & (PAGE_SIZE - 1))) {
 		dev_err(hba->dev,
@@ -741,14 +709,15 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	}
 
 	/* Allocate memory for local reference block */
-	hba->lrb = kcalloc(hba->nutrs, sizeof(struct ufshcd_lrb), GFP_KERNEL);
+	hba->lrb = devm_kzalloc(hba->dev,
+				hba->nutrs * sizeof(struct ufshcd_lrb),
+				GFP_KERNEL);
 	if (!hba->lrb) {
 		dev_err(hba->dev, "LRB Memory allocation failed\n");
 		goto out;
 	}
 	return 0;
 out:
-	ufshcd_free_hba_memory(hba);
 	return -ENOMEM;
 }
 
@@ -1682,17 +1651,6 @@ int ufshcd_resume(struct ufs_hba *hba)
 EXPORT_SYMBOL_GPL(ufshcd_resume);
 
 /**
- * ufshcd_hba_free - free allocated memory for
- *			host memory space data structures
- * @hba: per adapter instance
- */
-static void ufshcd_hba_free(struct ufs_hba *hba)
-{
-	iounmap(hba->mmio_base);
-	ufshcd_free_hba_memory(hba);
-}
-
-/**
  * ufshcd_remove - de-allocate SCSI host and host memory space
  *		data structure memory
  * @hba - per adapter instance
@@ -1701,9 +1659,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 {
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
-
 	ufshcd_hba_stop(hba);
-	ufshcd_hba_free(hba);
 
 	scsi_remove_host(hba->host);
 	scsi_host_put(hba->host);
@@ -1789,23 +1745,23 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	mutex_init(&hba->uic_cmd_mutex);
 
 	/* IRQ registration */
-	err = request_irq(irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
+	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
-		goto out_lrb_free;
+		goto out_disable;
 	}
 
 	/* Enable SCSI tag mapping */
 	err = scsi_init_shared_tag_map(host, host->can_queue);
 	if (err) {
 		dev_err(hba->dev, "init shared queue failed\n");
-		goto out_free_irq;
+		goto out_disable;
 	}
 
 	err = scsi_add_host(host, hba->dev);
 	if (err) {
 		dev_err(hba->dev, "scsi_add_host failed\n");
-		goto out_free_irq;
+		goto out_disable;
 	}
 
 	/* Host controller enable */
@@ -1823,10 +1779,6 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
-out_free_irq:
-	free_irq(irq, hba);
-out_lrb_free:
-	ufshcd_free_hba_memory(hba);
 out_disable:
 	scsi_host_put(host);
 out_error:
-- 
1.7.0.4


