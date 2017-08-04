From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH 3/5] phy: qcom-ufs: Add support to set phy mode
Date: Fri,  4 Aug 2017 12:18:50 +0530
Message-ID: <1501829332-5183-4-git-send-email-vivek.gautam@codeaurora.org>
References: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org
Cc: linux-arm-msm@vger.kernel.org, subhashj@codeaurora.org, bjorn.andersson@linaro.org, devicetree@vger.kernel.org, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Adding support to set desired UFS phy mode that can be set
from the host controller.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---
 drivers/phy/qualcomm/phy-qcom-ufs-i.h        |  2 ++
 drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c | 14 ++++++++++++++
 drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c | 14 ++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-i.h b/drivers/phy/qualcomm/phy-qcom-ufs-i.h
index 13b02b7de30b..94326ed107c3 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs-i.h
+++ b/drivers/phy/qualcomm/phy-qcom-ufs-i.h
@@ -115,6 +115,8 @@ struct ufs_qcom_phy {
 	int cached_regs_table_size;
 	bool is_powered_on;
 	struct ufs_qcom_phy_specific_ops *phy_spec_ops;
+
+	enum phy_mode mode;
 };
 
 /**
diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
index 12a1b498dc4b..af65785230b5 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
+++ b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
@@ -53,6 +53,19 @@ static int ufs_qcom_phy_qmp_14nm_exit(struct phy *generic_phy)
 }
 
 static
+int ufs_qcom_phy_qmp_14nm_set_mode(struct phy *generic_phy, enum phy_mode mode)
+{
+	struct ufs_qcom_phy *phy_common = get_ufs_qcom_phy(generic_phy);
+
+	phy_common->mode = PHY_MODE_INVALID;
+
+	if (mode > 0)
+		phy_common->mode = mode;
+
+	return 0;
+}
+
+static
 void ufs_qcom_phy_qmp_14nm_power_control(struct ufs_qcom_phy *phy, bool val)
 {
 	writel_relaxed(val ? 0x1 : 0x0, phy->mmio + UFS_PHY_POWER_DOWN_CONTROL);
@@ -102,6 +115,7 @@ static int ufs_qcom_phy_qmp_14nm_is_pcs_ready(struct ufs_qcom_phy *phy_common)
 	.exit		= ufs_qcom_phy_qmp_14nm_exit,
 	.power_on	= ufs_qcom_phy_power_on,
 	.power_off	= ufs_qcom_phy_power_off,
+	.set_mode	= ufs_qcom_phy_qmp_14nm_set_mode,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
index 4f68acb58b73..5c18c41dbdb4 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
+++ b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
@@ -72,6 +72,19 @@ static int ufs_qcom_phy_qmp_20nm_exit(struct phy *generic_phy)
 }
 
 static
+int ufs_qcom_phy_qmp_20nm_set_mode(struct phy *generic_phy, enum phy_mode mode)
+{
+	struct ufs_qcom_phy *phy_common = get_ufs_qcom_phy(generic_phy);
+
+	phy_common->mode = PHY_MODE_INVALID;
+
+	if (mode > 0)
+		phy_common->mode = mode;
+
+	return 0;
+}
+
+static
 void ufs_qcom_phy_qmp_20nm_power_control(struct ufs_qcom_phy *phy, bool val)
 {
 	bool hibern8_exit_after_pwr_collapse = phy->quirks &
@@ -160,6 +173,7 @@ static int ufs_qcom_phy_qmp_20nm_is_pcs_ready(struct ufs_qcom_phy *phy_common)
 	.exit		= ufs_qcom_phy_qmp_20nm_exit,
 	.power_on	= ufs_qcom_phy_power_on,
 	.power_off	= ufs_qcom_phy_power_off,
+	.set_mode	= ufs_qcom_phy_qmp_20nm_set_mode,
 	.owner		= THIS_MODULE,
 };
 
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
