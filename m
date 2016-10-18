From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH 1/7] phy: qcom-ufs: remove failure when rx/tx_iface_clk are absent
Date: Tue, 18 Oct 2016 10:18:59 +0530
Message-ID: <1476766145-27583-2-git-send-email-vivek.gautam@codeaurora.org>
References: <1476766145-27583-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476766145-27583-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

From: Yaniv Gardi <ygardi@codeaurora.org>

Since in future UFS Phy's the tx_iface_clk and rx_iface_clk
are no longer exist, we should not fail when their initialization
fail, but rather just report with debug message.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---
 drivers/phy/phy-qcom-ufs.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
index 107cb57..183ec04 100644
--- a/drivers/phy/phy-qcom-ufs.c
+++ b/drivers/phy/phy-qcom-ufs.c
@@ -186,16 +186,27 @@ ufs_qcom_phy_init_clks(struct phy *generic_phy,
 		       struct ufs_qcom_phy *phy_common)
 {
 	int err;
+	struct ufs_qcom_phy *phy = get_ufs_qcom_phy(generic_phy);
 
 	err = ufs_qcom_phy_clk_get(generic_phy, "tx_iface_clk",
 				   &phy_common->tx_iface_clk);
+	/*
+	 * tx_iface_clk does not exist in newer version of ufs-phy HW,
+	 * so don't return error if it is not found
+	 */
 	if (err)
-		goto out;
+		dev_dbg(phy->dev, "%s: failed to get tx_iface_clk\n",
+			__func__);
 
 	err = ufs_qcom_phy_clk_get(generic_phy, "rx_iface_clk",
 				   &phy_common->rx_iface_clk);
+	/*
+	 * rx_iface_clk does not exist in newer version of ufs-phy HW,
+	 * so don't return error if it is not found
+	 */
 	if (err)
-		goto out;
+		dev_dbg(phy->dev, "%s: failed to get rx_iface_clk\n",
+			__func__);
 
 	err = ufs_qcom_phy_clk_get(generic_phy, "ref_clk_src",
 				   &phy_common->ref_clk_src);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
