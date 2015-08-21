From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 09/10] scsi: ufs: return value of pwr_change_notify
Date: Fri, 21 Aug 2015 14:58:00 +0530
Message-ID: <1440149281-26336-10-git-send-email-alim.akhtar@samsung.com>
References: <1440149281-26336-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:57800 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbbHUJi7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2015 05:38:59 -0400
In-reply-to: <1440149281-26336-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vinholikatti@gmail.com, JBottomley@odin.com, Seungwon Jeon <tgih.jun@samsung.com>

From: Seungwon Jeon <tgih.jun@samsung.com>

Behavior of the "powwer mode change" contains vendor specific
operation known as pwr_change_notify. This change adds return
for pwr_change_notify to find success or failure.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8982da9..142a927 100644
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

