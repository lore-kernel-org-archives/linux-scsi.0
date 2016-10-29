From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH v3 10/12] phy: qcom-ufs: Remove common layer phy exit callback
Date: Sun, 30 Oct 2016 01:52:12 +0530
Message-ID: <1477772534-14170-11-git-send-email-vivek.gautam@codeaurora.org>
References: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47032 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753507AbcJ2UXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2016 16:23:11 -0400
In-Reply-To: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com
Cc: sboyd@codeaurora.org, subhashj@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>

The common layer phy exit callback ufs_qcom_phy_exit()
calls phy_power_off() that has no meaning when phy_power_off()
callback is already registered with the phy provider and
the consumer makes use of the same.
Instead, add a no-op specific phy_exit() callback for now
to add the exit sequence at a later point.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---

No changes since v2.

 drivers/phy/phy-qcom-ufs-i.h        |  1 -
 drivers/phy/phy-qcom-ufs-qmp-14nm.c |  7 ++++++-
 drivers/phy/phy-qcom-ufs-qmp-20nm.c |  7 ++++++-
 drivers/phy/phy-qcom-ufs.c          | 17 ++++++-----------
 4 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs-i.h b/drivers/phy/phy-qcom-ufs-i.h
index 69e836d..d505d98 100644
--- a/drivers/phy/phy-qcom-ufs-i.h
+++ b/drivers/phy/phy-qcom-ufs-i.h
@@ -141,7 +141,6 @@ struct ufs_qcom_phy_specific_ops {
 struct ufs_qcom_phy *get_ufs_qcom_phy(struct phy *generic_phy);
 int ufs_qcom_phy_power_on(struct phy *generic_phy);
 int ufs_qcom_phy_power_off(struct phy *generic_phy);
-int ufs_qcom_phy_exit(struct phy *generic_phy);
 int ufs_qcom_phy_init_clks(struct ufs_qcom_phy *phy_common);
 int ufs_qcom_phy_init_vregulators(struct ufs_qcom_phy *phy_common);
 int ufs_qcom_phy_remove(struct phy *generic_phy,
diff --git a/drivers/phy/phy-qcom-ufs-qmp-14nm.c b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
index ae74614..c71c847 100644
--- a/drivers/phy/phy-qcom-ufs-qmp-14nm.c
+++ b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
@@ -47,6 +47,11 @@ static int ufs_qcom_phy_qmp_14nm_init(struct phy *generic_phy)
 	return 0;
 }
 
+static int ufs_qcom_phy_qmp_14nm_exit(struct phy *generic_phy)
+{
+	return 0;
+}
+
 static
 void ufs_qcom_phy_qmp_14nm_power_control(struct ufs_qcom_phy *phy, bool val)
 {
@@ -94,7 +99,7 @@ static int ufs_qcom_phy_qmp_14nm_is_pcs_ready(struct ufs_qcom_phy *phy_common)
 
 static const struct phy_ops ufs_qcom_phy_qmp_14nm_phy_ops = {
 	.init		= ufs_qcom_phy_qmp_14nm_init,
-	.exit		= ufs_qcom_phy_exit,
+	.exit		= ufs_qcom_phy_qmp_14nm_exit,
 	.power_on	= ufs_qcom_phy_power_on,
 	.power_off	= ufs_qcom_phy_power_off,
 	.owner		= THIS_MODULE,
diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
index dfc5175..1a26a64 100644
--- a/drivers/phy/phy-qcom-ufs-qmp-20nm.c
+++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
@@ -66,6 +66,11 @@ static int ufs_qcom_phy_qmp_20nm_init(struct phy *generic_phy)
 	return 0;
 }
 
+static int ufs_qcom_phy_qmp_20nm_exit(struct phy *generic_phy)
+{
+	return 0;
+}
+
 static
 void ufs_qcom_phy_qmp_20nm_power_control(struct ufs_qcom_phy *phy, bool val)
 {
@@ -152,7 +157,7 @@ static int ufs_qcom_phy_qmp_20nm_is_pcs_ready(struct ufs_qcom_phy *phy_common)
 
 static const struct phy_ops ufs_qcom_phy_qmp_20nm_phy_ops = {
 	.init		= ufs_qcom_phy_qmp_20nm_init,
-	.exit		= ufs_qcom_phy_exit,
+	.exit		= ufs_qcom_phy_qmp_20nm_exit,
 	.power_on	= ufs_qcom_phy_power_on,
 	.power_off	= ufs_qcom_phy_power_off,
 	.owner		= THIS_MODULE,
diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index 9dff4c2..ef340d6 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -608,17 +608,6 @@ int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy, bool is_rate_B)
 }
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_calibrate_phy);
 
-int ufs_qcom_phy_exit(struct phy *generic_phy)
-{
-	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
-
-	if (ufs_qcom_phy->is_powered_on)
-		phy_power_off(generic_phy);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ufs_qcom_phy_exit);
-
 int ufs_qcom_phy_is_pcs_ready(struct phy *generic_phy)
 {
 	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
@@ -640,6 +629,9 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 	struct device *dev = phy_common->dev;
 	int err;
 
+	if (phy_common->is_powered_on)
+		return 0;
+
 	err = ufs_qcom_phy_enable_vreg(dev, &phy_common->vdda_phy);
 	if (err) {
 		dev_err(dev, "%s enable vdda_phy failed, err=%d\n",
@@ -702,6 +694,9 @@ int ufs_qcom_phy_power_off(struct phy *generic_phy)
 {
 	struct ufs_qcom_phy *phy_common = get_ufs_qcom_phy(generic_phy);
 
+	if (!phy_common->is_powered_on)
+		return 0;
+
 	phy_common->phy_spec_ops->power_control(phy_common, false);
 
 	if (phy_common->vddp_ref_clk.reg)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

