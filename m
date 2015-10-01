From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v3 10/13] scsi: ufs: return value of pwr_change_notify
Date: Thu, 01 Oct 2015 13:39:27 +0530
Message-ID: <1443686970-28104-11-git-send-email-alim.akhtar@samsung.com>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
index 66f2fb8..682abbe 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2580,14 +2580,18 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
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
 
@@ -2602,14 +2606,18 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
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
