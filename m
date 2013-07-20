From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH v2 1/3] ufshcd-pci: release ioremapped region during removing driver
Date: Sat, 20 Jul 2013 09:41:23 +0900
Message-ID: <1374280885-11526-2-git-send-email-mita@fixstars.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:45352 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3GTAqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jul 2013 20:46:05 -0400
In-Reply-To: <1374280885-11526-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Seungwon Jeon <tgih.jun@samsung.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

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
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd-pci.c | 37 +++++++++----------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 48be39a..de4c52b 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -93,10 +93,7 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 
 	disable_irq(pdev->irq);
 	ufshcd_remove(hba);
-	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
-	pci_clear_master(pdev);
-	pci_disable_device(pdev);
 }
 
 /**
@@ -133,53 +130,37 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
 
 static DEFINE_PCI_DEVICE_TABLE(ufshcd_pci_tbl) = {
-- 
1.8.3.1

