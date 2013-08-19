From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH 1/2] ufs-pltfrm: initialize DMA mask for device-tree probed device
Date: Mon, 19 Aug 2013 22:56:05 +0900
Message-ID: <1376920566-20325-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:41689 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3HSOBE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2013 10:01:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

The device-tree probed device for ARM doesn't have dev->dma_mask.
So dma_set_mask() for the device doesn't succeed.  The popular trick
for this is - dev->dma_mask = &dev->coherent_dma_mask;

Currently there is no dma_set_mask() call in ufs-pltfrm, but the
forthcoming fix needs proper DMA mask setting in ufs core driver.  So
initializing dev->dma_mask as described above is required.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 94ba40c..c780840 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -122,6 +122,9 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 		goto out;
 	}
 
+	if (!dev->dma_mask)
+		dev->dma_mask = &dev->coherent_dma_mask;
+
 	err = ufshcd_init(dev, &hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Intialization failed\n");
-- 
1.8.3.1

