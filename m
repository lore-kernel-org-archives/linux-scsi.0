From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v2 03/10] phy: qcom-ufs: Use devm sibling of kstrdup for regulator names
Date: Tue, 18 Oct 2016 19:58:10 +0530
Message-ID: <1476800897-19898-4-git-send-email-vivek.gautam@codeaurora.org>
References: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

This helps us in avoiding any requirement for kfree() operation
to be called exclusively over the allocated string pointer.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---

No change since v1.

 drivers/phy/phy-qcom-ufs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index 805c91d..f639a7c 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -262,7 +262,7 @@ static int __ufs_qcom_phy_init_vreg(struct phy *phy,
 
 	char prop_name[MAX_PROP_NAME];
 
-	vreg->name = kstrdup(name, GFP_KERNEL);
+	vreg->name = devm_kstrdup(dev, name, GFP_KERNEL);
 	if (!vreg->name) {
 		err = -ENOMEM;
 		goto out;
@@ -650,9 +650,6 @@ int ufs_qcom_phy_remove(struct phy *generic_phy,
 {
 	phy_power_off(generic_phy);
 
-	kfree(ufs_qcom_phy->vdda_pll.name);
-	kfree(ufs_qcom_phy->vdda_phy.name);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_remove);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
