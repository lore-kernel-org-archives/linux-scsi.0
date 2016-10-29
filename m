From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v3 06/12] phy: qcom-ufs-qmp-xx: Discard remove callback for drivers.
Date: Sun, 30 Oct 2016 01:52:08 +0530
Message-ID: <1477772534-14170-7-git-send-email-vivek.gautam@codeaurora.org>
References: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46568 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755347AbcJ2UW4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2016 16:22:56 -0400
In-Reply-To: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com
Cc: sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>

remove() callback does a phy_power_off() only over the phy,
and nothing else now.
The phy_power_off() over the generic phy is called from the phy
consumer, and phy provider driver should not explicitly need to
call any phy ops.
So discard the remove callback for qcom-ufs phy platform drivers.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---

Changes since v2:
 - Addressed review comment about commmit message: s/phy_exit/phy_power_off

 drivers/phy/phy-qcom-ufs-qmp-14nm.c | 16 ----------------
 drivers/phy/phy-qcom-ufs-qmp-20nm.c | 16 ----------------
 drivers/phy/phy-qcom-ufs.c          |  9 ---------
 3 files changed, 41 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs-qmp-14nm.c b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
index b3d2612..560f272 100644
--- a/drivers/phy/phy-qcom-ufs-qmp-14nm.c
+++ b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
@@ -163,21 +163,6 @@ static int ufs_qcom_phy_qmp_14nm_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int ufs_qcom_phy_qmp_14nm_remove(struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct phy *generic_phy = to_phy(dev);
-	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
-	int err = 0;
-
-	err = ufs_qcom_phy_remove(generic_phy, ufs_qcom_phy);
-	if (err)
-		dev_err(dev, "%s: ufs_qcom_phy_remove failed = %d\n",
-			__func__, err);
-
-	return err;
-}
-
 static const struct of_device_id ufs_qcom_phy_qmp_14nm_of_match[] = {
 	{.compatible = "qcom,ufs-phy-qmp-14nm"},
 	{.compatible = "qcom,msm8996-ufs-phy-qmp-14nm"},
@@ -187,7 +172,6 @@ static int ufs_qcom_phy_qmp_14nm_remove(struct platform_device *pdev)
 
 static struct platform_driver ufs_qcom_phy_qmp_14nm_driver = {
 	.probe = ufs_qcom_phy_qmp_14nm_probe,
-	.remove = ufs_qcom_phy_qmp_14nm_remove,
 	.driver = {
 		.of_match_table = ufs_qcom_phy_qmp_14nm_of_match,
 		.name = "ufs_qcom_phy_qmp_14nm",
diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
index e09ecb8c..9a2f53d 100644
--- a/drivers/phy/phy-qcom-ufs-qmp-20nm.c
+++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
@@ -219,21 +219,6 @@ static int ufs_qcom_phy_qmp_20nm_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int ufs_qcom_phy_qmp_20nm_remove(struct platform_device *pdev)
-{
-	struct device *dev = &pdev->dev;
-	struct phy *generic_phy = to_phy(dev);
-	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
-	int err = 0;
-
-	err = ufs_qcom_phy_remove(generic_phy, ufs_qcom_phy);
-	if (err)
-		dev_err(dev, "%s: ufs_qcom_phy_remove failed = %d\n",
-			__func__, err);
-
-	return err;
-}
-
 static const struct of_device_id ufs_qcom_phy_qmp_20nm_of_match[] = {
 	{.compatible = "qcom,ufs-phy-qmp-20nm"},
 	{},
@@ -242,7 +227,6 @@ static int ufs_qcom_phy_qmp_20nm_remove(struct platform_device *pdev)
 
 static struct platform_driver ufs_qcom_phy_qmp_20nm_driver = {
 	.probe = ufs_qcom_phy_qmp_20nm_probe,
-	.remove = ufs_qcom_phy_qmp_20nm_remove,
 	.driver = {
 		.of_match_table = ufs_qcom_phy_qmp_20nm_of_match,
 		.name = "ufs_qcom_phy_qmp_20nm",
diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index 11c8cae..1a0c224 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -625,15 +625,6 @@ int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy, bool is_rate_B)
 }
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_calibrate_phy);
 
-int ufs_qcom_phy_remove(struct phy *generic_phy,
-			struct ufs_qcom_phy *ufs_qcom_phy)
-{
-	phy_power_off(generic_phy);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ufs_qcom_phy_remove);
-
 int ufs_qcom_phy_exit(struct phy *generic_phy)
 {
 	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

