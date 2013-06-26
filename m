From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 09/10] ufshcd-pltfrm: remove unnecessary dma_set_coherent_mask() call
Date: Wed, 26 Jun 2013 22:39:34 +0530
Message-ID: <1372266575-3468-10-git-send-email-santoshsy@gmail.com>
References: <1372266575-3468-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59122 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab3FZRKZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jun 2013 13:10:25 -0400
Received: by mail-pb0-f52.google.com with SMTP id xa12so14468951pbc.11
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2013 10:10:25 -0700 (PDT)
In-Reply-To: <1372266575-3468-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Akinobu Mita <mita@fixstars.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Santosh Y <santoshsy@gmail.com>

From: Akinobu Mita <mita@fixstars.com>

Changing the device coherent dma mask to the value that currently set
has no effect.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 6829a16..c42db40 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -122,12 +122,6 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	err = dma_set_coherent_mask(dev, dev->coherent_dma_mask);
-	if (err) {
-		dev_err(dev, "set dma mask failed\n");
-		goto out;
-	}
-
 	err = ufshcd_init(dev, &hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Intialization failed\n");
-- 
1.8.3.1

