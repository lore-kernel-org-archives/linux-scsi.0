From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 08/10] ufs: fix register address in UIC error interrupt handling
Date: Wed, 26 Jun 2013 22:34:04 +0530
Message-ID: <1372266246-2725-9-git-send-email-santoshsy@gmail.com>
References: <1372266246-2725-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:34787 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3FZRFL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jun 2013 13:05:11 -0400
Received: by mail-pb0-f42.google.com with SMTP id un1so14428487pbc.29
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2013 10:05:10 -0700 (PDT)
In-Reply-To: <1372266246-2725-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 00james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Akinobu Mita <mita@fixstars.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Santosh Y <santoshsy@gmail.com>

From: Akinobu Mita <mita@fixstars.com>

In UIC error interrupt handling, it checks if UIC data link layer error
code indicates PA_INIT_ERROR in order to determine whether a fatal error
handling is needed or not.

But the code tries to read UIC data link layer error code from wrong
REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER, it should be
REG_UIC_ERROR_CODE_DATA_LINK_LAYER.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 255f5be..19618c6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1349,7 +1349,7 @@ static void ufshcd_err_handler(struct ufs_hba *hba)
 		goto fatal_eh;
 
 	if (hba->errors & UIC_ERROR) {
-		reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
+		reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
 		if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
 			goto fatal_eh;
 	}
-- 
1.8.3.1

