From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH 1/2] [SCSI] ufshcd-pltfrm: remove unnecessary dma_set_coherent_mask() call
Date: Sun,  9 Jun 2013 20:19:58 +0900
Message-ID: <1370776799-12373-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:33476 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3FILYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jun 2013 07:24:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

Changing the device coherent dma mask to the value that currently set
has no effect.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 0014e28..969c9bc 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -100,7 +100,6 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 	struct resource *irq_res;
 	resource_size_t mem_size;
 	int err;
-	struct device *dev = &pdev->dev;
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem_res) {
@@ -132,12 +131,6 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 		goto out_iounmap;
 	}
 
-	err = dma_set_coherent_mask(dev, dev->coherent_dma_mask);
-	if (err) {
-		dev_err(&pdev->dev, "set dma mask failed\n");
-		goto out_iounmap;
-	}
-
 	err = ufshcd_init(&pdev->dev, &hba, mmio_base, irq_res->start);
 	if (err) {
 		dev_err(&pdev->dev, "Intialization failed\n");
-- 
1.8.1.4

