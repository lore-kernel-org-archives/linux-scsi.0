From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH] [SCSI] ufs: fix register address in UIC error interrupt handling
Date: Sun,  2 Jun 2013 13:04:20 +0900
Message-ID: <1370145860-16336-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:40090 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3FBEIF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jun 2013 00:08:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

In UIC error interrupt handling, it checks if UIC data link layer error
code indicates PA_INIT_ERROR in order to determine whether a fatal error
handling is needed or not.

But the code tries to read UIC data link layer error code from wrong
REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER, it should be
REG_UIC_ERROR_CODE_DATA_LINK_LAYER.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c32a478..492f2b7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1246,7 +1246,7 @@ static void ufshcd_err_handler(struct ufs_hba *hba)
 	if (hba->errors & UIC_ERROR) {
 
 		reg = readl(hba->mmio_base +
-			    REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
+			    REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
 		if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
 			goto fatal_eh;
 	}
-- 
1.8.1.4

