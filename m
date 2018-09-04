From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH 1/3] phy: qcom-ufs: Remove stale methods that handle ref clk
Date: Tue,  4 Sep 2018 15:47:17 +0530
Message-ID: <20180904101719.18049-2-vivek.gautam@codeaurora.org>
References: <20180904101719.18049-1-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180904101719.18049-1-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: subhashj@codeaurora.org, bjorn.andersson@linaro.org, evgreen@chromium.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Remove ufs_qcom_phy_enable/(disable)_dev_ref_clk() that
are not being used by any code.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---
 drivers/phy/qualcomm/phy-qcom-ufs.c | 50 -------------------------------------
 include/linux/phy/phy-qcom-ufs.h    | 14 -----------
 2 files changed, 64 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-ufs.c b/drivers/phy/qualcomm/phy-qcom-ufs.c
index c5493ea51282..f2979ccad00a 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-ufs.c
@@ -431,56 +431,6 @@ static void ufs_qcom_phy_disable_ref_clk(struct ufs_qcom_phy *phy)
 	}
 }
 
-#define UFS_REF_CLK_EN	(1 << 5)
-
-static void ufs_qcom_phy_dev_ref_clk_ctrl(struct phy *generic_phy, bool enable)
-{
-	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
-
-	if (phy->dev_ref_clk_ctrl_mmio &&
-	    (enable ^ phy->is_dev_ref_clk_enabled)) {
-		u32 temp = readl_relaxed(phy->dev_ref_clk_ctrl_mmio);
-
-		if (enable)
-			temp |= UFS_REF_CLK_EN;
-		else
-			temp &= ~UFS_REF_CLK_EN;
-
-		/*
-		 * If we are here to disable this clock immediately after
-		 * entering into hibern8, we need to make sure that device
-		 * ref_clk is active atleast 1us after the hibern8 enter.
-		 */
-		if (!enable)
-			udelay(1);
-
-		writel_relaxed(temp, phy->dev_ref_clk_ctrl_mmio);
-		/* ensure that ref_clk is enabled/disabled before we return */
-		wmb();
-		/*
-		 * If we call hibern8 exit after this, we need to make sure that
-		 * device ref_clk is stable for atleast 1us before the hibern8
-		 * exit command.
-		 */
-		if (enable)
-			udelay(1);
-
-		phy->is_dev_ref_clk_enabled = enable;
-	}
-}
-
-void ufs_qcom_phy_enable_dev_ref_clk(struct phy *generic_phy)
-{
-	ufs_qcom_phy_dev_ref_clk_ctrl(generic_phy, true);
-}
-EXPORT_SYMBOL_GPL(ufs_qcom_phy_enable_dev_ref_clk);
-
-void ufs_qcom_phy_disable_dev_ref_clk(struct phy *generic_phy)
-{
-	ufs_qcom_phy_dev_ref_clk_ctrl(generic_phy, false);
-}
-EXPORT_SYMBOL_GPL(ufs_qcom_phy_disable_dev_ref_clk);
-
 /* Turn ON M-PHY RMMI interface clocks */
 static int ufs_qcom_phy_enable_iface_clk(struct ufs_qcom_phy *phy)
 {
diff --git a/include/linux/phy/phy-qcom-ufs.h b/include/linux/phy/phy-qcom-ufs.h
index 0a2c18a9771d..9dd85071bcce 100644
--- a/include/linux/phy/phy-qcom-ufs.h
+++ b/include/linux/phy/phy-qcom-ufs.h
@@ -17,20 +17,6 @@
 
 #include "phy.h"
 
-/**
- * ufs_qcom_phy_enable_dev_ref_clk() - Enable the device
- * ref clock.
- * @phy: reference to a generic phy.
- */
-void ufs_qcom_phy_enable_dev_ref_clk(struct phy *phy);
-
-/**
- * ufs_qcom_phy_disable_dev_ref_clk() - Disable the device
- * ref clock.
- * @phy: reference to a generic phy.
- */
-void ufs_qcom_phy_disable_dev_ref_clk(struct phy *phy);
-
 int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes);
 void ufs_qcom_phy_save_controller_version(struct phy *phy,
 			u8 major, u16 minor, u16 step);
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
