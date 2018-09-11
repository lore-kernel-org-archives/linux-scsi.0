From: Can Guo <cang@codeaurora.org>
Subject: [PATCH v9 1/7] phy: Update PHY power control sequence
Date: Tue, 11 Sep 2018 12:37:05 +0800
Message-ID: <20180911044418.15960-1-cang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, asutoshd@codeaurora.org, vivek.gautam@codeaurora.org, evgreen@chromium.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <cang@codeaurora.org>, Kishon Vijay Abraham I <kishon@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Manu Gautam <mgautam@codeaurora.org>, Sasha Levin <alexander.levin@microsoft.com>, "open list:GENERIC PHY FRAMEWORK" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

All PHYs should be powered on before register configuration starts. And
only PCIe PHYs need an extra power control before deasserts reset state.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Manu Gautam <mgautam@codeaurora.org>
Reviewed-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 97ef942..ccb8578 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -935,10 +935,12 @@ static void qcom_qmp_phy_configure(void __iomem *base,
 	}
 }
 
-static int qcom_qmp_phy_com_init(struct qcom_qmp *qmp)
+static int qcom_qmp_phy_com_init(struct qmp_phy *qphy)
 {
+	struct qcom_qmp *qmp = qphy->qmp;
 	const struct qmp_phy_cfg *cfg = qmp->cfg;
 	void __iomem *serdes = qmp->serdes;
+	void __iomem *pcs = qphy->pcs;
 	void __iomem *dp_com = qmp->dp_com;
 	int ret, i;
 
@@ -979,10 +981,6 @@ static int qcom_qmp_phy_com_init(struct qcom_qmp *qmp)
 		goto err_rst;
 	}
 
-	if (cfg->has_phy_com_ctrl)
-		qphy_setbits(serdes, cfg->regs[QPHY_COM_POWER_DOWN_CONTROL],
-			     SW_PWRDN);
-
 	if (cfg->has_phy_dp_com_ctrl) {
 		qphy_setbits(dp_com, QPHY_V3_DP_COM_POWER_DOWN_CTRL,
 			     SW_PWRDN);
@@ -1000,6 +998,12 @@ static int qcom_qmp_phy_com_init(struct qcom_qmp *qmp)
 			     SW_USB3PHY_RESET_MUX | SW_USB3PHY_RESET);
 	}
 
+	if (cfg->has_phy_com_ctrl)
+		qphy_setbits(serdes, cfg->regs[QPHY_COM_POWER_DOWN_CONTROL],
+			     SW_PWRDN);
+	else
+		qphy_setbits(pcs, QPHY_POWER_DOWN_CONTROL, cfg->pwrdn_ctrl);
+
 	/* Serdes configuration */
 	qcom_qmp_phy_configure(serdes, cfg->regs, cfg->serdes_tbl,
 			       cfg->serdes_tbl_num);
@@ -1090,7 +1094,7 @@ static int qcom_qmp_phy_init(struct phy *phy)
 
 	dev_vdbg(qmp->dev, "Initializing QMP phy\n");
 
-	ret = qcom_qmp_phy_com_init(qmp);
+	ret = qcom_qmp_phy_com_init(qphy);
 	if (ret)
 		return ret;
 
@@ -1127,7 +1131,8 @@ static int qcom_qmp_phy_init(struct phy *phy)
 	 * Pull out PHY from POWER DOWN state.
 	 * This is active low enable signal to power-down PHY.
 	 */
-	qphy_setbits(pcs, QPHY_POWER_DOWN_CONTROL, cfg->pwrdn_ctrl);
+	if(cfg->type == PHY_TYPE_PCIE)
+		qphy_setbits(pcs, QPHY_POWER_DOWN_CONTROL, cfg->pwrdn_ctrl);
 
 	if (cfg->has_pwrdn_delay)
 		usleep_range(cfg->pwrdn_delay_min, cfg->pwrdn_delay_max);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
