From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 5/9] ufshcd-pci: release ioremapped region during removing driver
Date: Tue, 30 Jul 2013 00:36:01 +0530
Message-ID: <1375124765-4110-6-git-send-email-santoshsy@gmail.com>
References: <1375124765-4110-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60947 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3G2THr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 15:07:47 -0400
Received: by mail-pd0-f182.google.com with SMTP id r11so1530095pdi.41
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 12:07:46 -0700 (PDT)
In-Reply-To: <1375124765-4110-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Akinobu Mita <mita@fixstars.com>, Seungwon Jeon <tgih.jun@samsung.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Santosh Y <santoshsy@gmail.com>

From: Akinobu Mita <mita@fixstars.com>

Before commit 2953f850c3b80bdca004967c83733365d8aa0aa2 ("[SCSI] ufs:
use devres functions for ufshcd"), UFSHCI register was ioremapped by
each glue-driver (ufshcd-pltfrm and ufshcd-pci) during probing and it
was iounmapped by core-driver during removing driver.  The commit
converted ufshcd-pltfrm to use devres functions, but it didn't convert
ufshcd-pci.

Therefore, the change causes ufshcd-pci driver not to iounmap UFSHCI
register region during removing driver.  This fixes it by converting
ufshcd-pci to use devres functions.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 57ea9dd..24d6ba7 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -134,10 +134,7 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 
 	disable_irq(pdev->irq);
 	ufshcd_remove(hba);
-	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
-	pci_clear_master(pdev);
-	pci_disable_device(pdev);
 }
 
 /**
@@ -174,38 +171,32 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	void __iomem *mmio_base;
 	int err;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
-		dev_err(&pdev->dev, "pci_enable_device failed\n");
-		goto out_error;
+		dev_err(&pdev->dev, "pcim_enable_device failed\n");
+		return err;
 	}
 
 	pci_set_master(pdev);
 
-
-	err = pci_request_regions(pdev, UFSHCD);
+	err = pcim_iomap_regions(pdev, 1 << 0, UFSHCD);
 	if (err < 0) {
-		dev_err(&pdev->dev, "request regions failed\n");
-		goto out_disable;
+		dev_err(&pdev->dev, "request and iomap failed\n");
+		return err;
 	}
 
-	mmio_base = pci_ioremap_bar(pdev, 0);
-	if (!mmio_base) {
-		dev_err(&pdev->dev, "memory map failed\n");
-		err = -ENOMEM;
-		goto out_release_regions;
-	}
+	mmio_base = pcim_iomap_table(pdev)[0];
 
 	err = ufshcd_set_dma_mask(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "set dma mask failed\n");
-		goto out_iounmap;
+		return err;
 	}
 
 	err = ufshcd_init(&pdev->dev, &hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
-		goto out_iounmap;
+		return err;
 	}
 
 	pci_set_drvdata(pdev, hba);
@@ -213,16 +204,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pm_runtime_allow(&pdev->dev);
 
 	return 0;
-
-out_iounmap:
-	iounmap(mmio_base);
-out_release_regions:
-	pci_release_regions(pdev);
-out_disable:
-	pci_clear_master(pdev);
-	pci_disable_device(pdev);
-out_error:
-	return err;
 }
 
 static const struct dev_pm_ops ufshcd_pci_pm_ops = {
-- 
1.8.3.1

