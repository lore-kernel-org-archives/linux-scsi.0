From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 09/11] scsi: ufs: return value of pwr_change_notify
Date: Thu, 17 Sep 2015 15:15:35 +0530
Message-ID: <1442483137-32376-10-git-send-email-alim.akhtar@samsung.com>
References: <1442483137-32376-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:55923 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbbIQJy4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 05:54:56 -0400
In-reply-to: <1442483137-32376-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org

From: Seungwon Jeon <essuuj@gmail.com>

Behavior of the "power mode change" contains vendor specific
operation known as pwr_change_notify. This change adds return
for pwr_change_notify to find success or failure.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index da52c45..0c9f319 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2579,14 +2579,18 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 		dev_err(hba->dev,
 			"%s: power mode change failed %d\n", __func__, ret);
 	} else {
-		if (hba->vops && hba->vops->pwr_change_notify)
-			hba->vops->pwr_change_notify(hba,
-				POST_CHANGE, NULL, pwr_mode);
+		if (hba->vops && hba->vops->pwr_change_notify) {
+			ret = hba->vops->pwr_change_notify(hba,
+					POST_CHANGE, NULL, pwr_mode);
+			if (ret)
+				goto out;
+		}
 
 		memcpy(&hba->pwr_info, pwr_mode,
 			sizeof(struct ufs_pa_layer_attr));
 	}
 
+out:
 	return ret;
 }
 
@@ -2601,14 +2605,18 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 	struct ufs_pa_layer_attr final_params = { 0 };
 	int ret;
 
-	if (hba->vops && hba->vops->pwr_change_notify)
-		hba->vops->pwr_change_notify(hba,
-		     PRE_CHANGE, desired_pwr_mode, &final_params);
-	else
+	if (hba->vops && hba->vops->pwr_change_notify) {
+		ret = hba->vops->pwr_change_notify(hba,
+			PRE_CHANGE, desired_pwr_mode, &final_params);
+		if (ret)
+			goto out;
+	} else {
 		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
+	}
 
 	ret = ufshcd_change_power_mode(hba, &final_params);
 
+out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
-- 
1.7.10.4

