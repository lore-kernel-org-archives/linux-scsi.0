From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v2 07/10] phy: qcom-ufs-qmp-xx: Move clock and regulator init out of phy init
Date: Tue, 18 Oct 2016 19:58:14 +0530
Message-ID: <1476800897-19898-8-git-send-email-vivek.gautam@codeaurora.org>
References: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42098 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933204AbcJRO3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 10:29:17 -0400
In-Reply-To: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>

The phy init is meant to do phy initialization rather than
just getting the clock and regulator. Move these clock and
regulator get to probe(), to make room for actual phy
initialization sequence.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---

No change since v1.

 drivers/phy/phy-qcom-ufs-qmp-14nm.c | 52 ++++++++++++++++++-------------------
 drivers/phy/phy-qcom-ufs-qmp-20nm.c | 46 +++++++++++++++-----------------
 2 files changed, 46 insertions(+), 52 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs-qmp-14nm.c b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
index 55fecbb..a60cf34 100644
--- a/drivers/phy/phy-qcom-ufs-qmp-14nm.c
+++ b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
@@ -44,30 +44,7 @@ void ufs_qcom_phy_qmp_14nm_advertise_quirks(struct ufs_qcom_phy *phy_common)
 
 static int ufs_qcom_phy_qmp_14nm_init(struct phy *generic_phy)
 {
-	struct ufs_qcom_phy_qmp_14nm *phy = phy_get_drvdata(generic_phy);
-	struct ufs_qcom_phy *phy_common = &phy->common_cfg;
-	int err;
-
-	err = ufs_qcom_phy_init_clks(phy_common);
-	if (err) {
-		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_clks() failed %d\n",
-			__func__, err);
-		goto out;
-	}
-
-	err = ufs_qcom_phy_init_vregulators(phy_common);
-	if (err) {
-		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_vregulators() failed %d\n",
-			__func__, err);
-		goto out;
-	}
-	phy_common->vdda_phy.max_uV = UFS_PHY_VDDA_PHY_UV;
-	phy_common->vdda_phy.min_uV = UFS_PHY_VDDA_PHY_UV;
-
-	ufs_qcom_phy_qmp_14nm_advertise_quirks(phy_common);
-
-out:
-	return err;
+	return 0;
 }
 
 static
@@ -136,6 +113,7 @@ static int ufs_qcom_phy_qmp_14nm_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct phy *generic_phy;
 	struct ufs_qcom_phy_qmp_14nm *phy;
+	struct ufs_qcom_phy *phy_common;
 	int err = 0;
 
 	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
@@ -143,8 +121,9 @@ static int ufs_qcom_phy_qmp_14nm_probe(struct platform_device *pdev)
 		err = -ENOMEM;
 		goto out;
 	}
+	phy_common = &phy->common_cfg;
 
-	generic_phy = ufs_qcom_phy_generic_probe(pdev, &phy->common_cfg,
+	generic_phy = ufs_qcom_phy_generic_probe(pdev, phy_common,
 				&ufs_qcom_phy_qmp_14nm_phy_ops, &phy_14nm_ops);
 
 	if (!generic_phy) {
@@ -154,10 +133,29 @@ static int ufs_qcom_phy_qmp_14nm_probe(struct platform_device *pdev)
 		goto out;
 	}
 
+	err = ufs_qcom_phy_init_clks(phy_common);
+	if (err) {
+		dev_err(phy_common->dev,
+			"%s: ufs_qcom_phy_init_clks() failed %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	err = ufs_qcom_phy_init_vregulators(phy_common);
+	if (err) {
+		dev_err(phy_common->dev,
+			"%s: ufs_qcom_phy_init_vregulators() failed %d\n",
+			__func__, err);
+		goto out;
+	}
+	phy_common->vdda_phy.max_uV = UFS_PHY_VDDA_PHY_UV;
+	phy_common->vdda_phy.min_uV = UFS_PHY_VDDA_PHY_UV;
+
+	ufs_qcom_phy_qmp_14nm_advertise_quirks(phy_common);
+
 	phy_set_drvdata(generic_phy, phy);
 
-	strlcpy(phy->common_cfg.name, UFS_PHY_NAME,
-		sizeof(phy->common_cfg.name));
+	strlcpy(phy_common->name, UFS_PHY_NAME, sizeof(phy_common->name));
 
 out:
 	return err;
diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
index 9a2f53d..dfc5175 100644
--- a/drivers/phy/phy-qcom-ufs-qmp-20nm.c
+++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
@@ -63,28 +63,7 @@ void ufs_qcom_phy_qmp_20nm_advertise_quirks(struct ufs_qcom_phy *phy_common)
 
 static int ufs_qcom_phy_qmp_20nm_init(struct phy *generic_phy)
 {
-	struct ufs_qcom_phy_qmp_20nm *phy = phy_get_drvdata(generic_phy);
-	struct ufs_qcom_phy *phy_common = &phy->common_cfg;
-	int err = 0;
-
-	err = ufs_qcom_phy_init_clks(phy_common);
-	if (err) {
-		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_clks() failed %d\n",
-			__func__, err);
-		goto out;
-	}
-
-	err = ufs_qcom_phy_init_vregulators(phy_common);
-	if (err) {
-		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_vregulators() failed %d\n",
-			__func__, err);
-		goto out;
-	}
-
-	ufs_qcom_phy_qmp_20nm_advertise_quirks(phy_common);
-
-out:
-	return err;
+	return 0;
 }
 
 static
@@ -192,6 +171,7 @@ static int ufs_qcom_phy_qmp_20nm_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct phy *generic_phy;
 	struct ufs_qcom_phy_qmp_20nm *phy;
+	struct ufs_qcom_phy *phy_common;
 	int err = 0;
 
 	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
@@ -199,8 +179,9 @@ static int ufs_qcom_phy_qmp_20nm_probe(struct platform_device *pdev)
 		err = -ENOMEM;
 		goto out;
 	}
+	phy_common = &phy->common_cfg;
 
-	generic_phy = ufs_qcom_phy_generic_probe(pdev, &phy->common_cfg,
+	generic_phy = ufs_qcom_phy_generic_probe(pdev, phy_common,
 				&ufs_qcom_phy_qmp_20nm_phy_ops, &phy_20nm_ops);
 
 	if (!generic_phy) {
@@ -210,10 +191,25 @@ static int ufs_qcom_phy_qmp_20nm_probe(struct platform_device *pdev)
 		goto out;
 	}
 
+	err = ufs_qcom_phy_init_clks(phy_common);
+	if (err) {
+		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_clks() failed %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	err = ufs_qcom_phy_init_vregulators(phy_common);
+	if (err) {
+		dev_err(phy_common->dev, "%s: ufs_qcom_phy_init_vregulators() failed %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	ufs_qcom_phy_qmp_20nm_advertise_quirks(phy_common);
+
 	phy_set_drvdata(generic_phy, phy);
 
-	strlcpy(phy->common_cfg.name, UFS_PHY_NAME,
-			sizeof(phy->common_cfg.name));
+	strlcpy(phy_common->name, UFS_PHY_NAME, sizeof(phy_common->name));
 
 out:
 	return err;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

