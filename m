From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v4 8/8] phy: ufs-qcom: Refactor all init steps into phy_poweron
Date: Wed, 13 Feb 2019 15:25:26 -0800
Message-ID: <20190213232526.26995-9-evgreen@chromium.org>
References: <20190213232526.26995-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213232526.26995-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Gross <andy.gross@linaro.org>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Stephen Boyd <swboyd@chromium.org>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Evan Green <evgreen@chromium.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, Grygorii Strashko <grygorii.strashko@ti.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-kernel@vger.kernel.org, Manu Gautam <mgautam@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The phy code was using implicit sequencing between the PHY driver
and the UFS driver to implement certain hardware requirements.
Specifically, the PHY reset register in the UFS controller needs
to be deasserted before serdes start occurs in the PHY.

Before this change, the code was doing this by utilizing the two
phy callbacks, phy_init() and phy_poweron(), as "init step 1" and
"init step 2", where the UFS driver would deassert reset between
these two steps.

This makes it challenging to power off the regulators in suspend,
as regulators are initialized in init, not in poweron(), but only
poweroff() is called during suspend, not exit().

For UFS, move the actual firing up of the PHY to phy_poweron() and
phy_poweroff() callbacks, rather than init()/exit(). UFS calls
phy_poweroff() during suspend, so now all clocks and regulators for
the phy can be powered down during suspend.

QMP is a little tricky because the PHY is also shared with PCIe and
USB3, which have their own definitions for init() and poweron(). Rename
the meaty functions to _enable() and _disable() to disentangle from the
PHY core names, and then create two different ops structures: one for
UFS and one for the other PHY types.

In phy-qcom-ufs, remove the 'is_powered_on' and 'is_started' guards,
as the generic PHY code does the reference counting. The
14/20nm-specific init functions get collapsed into the generic power_on()
function, with the addition of a calibrate() callback specific to 14/20nm.

Signed-off-by: Evan Green <evgreen@chromium.org>
---

Changes in v4:
- Keep doing reset_control* unconditionally through refactor (Stephen).

Changes in v3:
- Refactor init => poweron for all PHYs and UFS in one step (Stephen)

Changes in v2:
- Use devm_ to get the reset (Stephen)
- Removed whitespace changes (Stephen)

 drivers/phy/qualcomm/phy-qcom-qmp.c          | 78 ++++++--------------
 drivers/phy/qualcomm/phy-qcom-ufs-i.h        |  4 +-
 drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c | 33 +--------
 drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c | 33 +--------
 drivers/phy/qualcomm/phy-qcom-ufs.c          | 42 ++++++-----
 drivers/scsi/ufs/ufs-qcom.c                  | 44 +++++------
 6 files changed, 64 insertions(+), 170 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index a808887ab4e2..3b01ebf76f66 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -1339,8 +1339,7 @@ static int qcom_qmp_phy_com_exit(struct qcom_qmp *qmp)
 	return 0;
 }
 
-/* PHY Initialization */
-static int qcom_qmp_phy_init(struct phy *phy)
+static int qcom_qmp_phy_enable(struct phy *phy)
 {
 	struct qmp_phy *qphy = phy_get_drvdata(phy);
 	struct qcom_qmp *qmp = qphy->qmp;
@@ -1418,14 +1417,6 @@ static int qcom_qmp_phy_init(struct phy *phy)
 	if (ret)
 		goto err_lane_rst;
 
-	/*
-	 * UFS PHY requires the deassert of software reset before serdes start.
-	 * For UFS PHYs that do not have software reset control bits, defer
-	 * starting serdes until the power on callback.
-	 */
-	if ((cfg->type == PHY_TYPE_UFS) && cfg->no_pcs_sw_reset)
-		goto out;
-
 	/*
 	 * Pull out PHY from POWER DOWN state.
 	 * This is active low enable signal to power-down PHY.
@@ -1437,7 +1428,9 @@ static int qcom_qmp_phy_init(struct phy *phy)
 		usleep_range(cfg->pwrdn_delay_min, cfg->pwrdn_delay_max);
 
 	/* Pull PHY out of reset state */
-	qphy_clrbits(pcs, cfg->regs[QPHY_SW_RESET], SW_RESET);
+	if (!cfg->no_pcs_sw_reset)
+		qphy_clrbits(pcs, cfg->regs[QPHY_SW_RESET], SW_RESET);
+
 	if (cfg->has_phy_dp_com_ctrl)
 		qphy_clrbits(dp_com, QPHY_V3_DP_COM_SW_RESET, SW_RESET);
 
@@ -1454,11 +1447,10 @@ static int qcom_qmp_phy_init(struct phy *phy)
 		goto err_pcs_ready;
 	}
 	qmp->phy_initialized = true;
-
-out:
-	return ret;
+	return 0;
 
 err_pcs_ready:
+	reset_control_assert(qmp->ufs_reset);
 	clk_disable_unprepare(qphy->pipe_clk);
 err_clk_enable:
 	if (cfg->has_lane_rst)
@@ -1469,7 +1461,7 @@ static int qcom_qmp_phy_init(struct phy *phy)
 	return ret;
 }
 
-static int qcom_qmp_phy_exit(struct phy *phy)
+static int qcom_qmp_phy_disable(struct phy *phy)
 {
 	struct qmp_phy *qphy = phy_get_drvdata(phy);
 	struct qcom_qmp *qmp = qphy->qmp;
@@ -1497,44 +1489,6 @@ static int qcom_qmp_phy_exit(struct phy *phy)
 	return 0;
 }
 
-static int qcom_qmp_phy_poweron(struct phy *phy)
-{
-	struct qmp_phy *qphy = phy_get_drvdata(phy);
-	struct qcom_qmp *qmp = qphy->qmp;
-	const struct qmp_phy_cfg *cfg = qmp->cfg;
-	void __iomem *pcs = qphy->pcs;
-	void __iomem *status;
-	unsigned int mask, val;
-	int ret = 0;
-
-	if (cfg->type != PHY_TYPE_UFS)
-		return 0;
-
-	/*
-	 * For UFS PHY that has not software reset control, serdes start
-	 * should only happen when UFS driver explicitly calls phy_power_on
-	 * after it deasserts software reset.
-	 */
-	if (cfg->no_pcs_sw_reset && !qmp->phy_initialized &&
-	    (qmp->init_count != 0)) {
-		/* start SerDes and Phy-Coding-Sublayer */
-		qphy_setbits(pcs, cfg->regs[QPHY_START_CTRL], cfg->start_ctrl);
-
-		status = pcs + cfg->regs[QPHY_PCS_READY_STATUS];
-		mask = cfg->mask_pcs_ready;
-
-		ret = readl_poll_timeout(status, val, !(val & mask), 1,
-					 PHY_INIT_COMPLETE_TIMEOUT);
-		if (ret) {
-			dev_err(qmp->dev, "phy initialization timed-out\n");
-			return ret;
-		}
-		qmp->phy_initialized = true;
-	}
-
-	return ret;
-}
-
 static int qcom_qmp_phy_set_mode(struct phy *phy,
 				 enum phy_mode mode, int submode)
 {
@@ -1784,9 +1738,15 @@ static int phy_pipe_clk_register(struct qcom_qmp *qmp, struct device_node *np)
 }
 
 static const struct phy_ops qcom_qmp_phy_gen_ops = {
-	.init		= qcom_qmp_phy_init,
-	.exit		= qcom_qmp_phy_exit,
-	.power_on	= qcom_qmp_phy_poweron,
+	.init		= qcom_qmp_phy_enable,
+	.exit		= qcom_qmp_phy_disable,
+	.set_mode	= qcom_qmp_phy_set_mode,
+	.owner		= THIS_MODULE,
+};
+
+static const struct phy_ops qcom_qmp_ufs_ops = {
+	.power_on	= qcom_qmp_phy_enable,
+	.power_off	= qcom_qmp_phy_disable,
 	.set_mode	= qcom_qmp_phy_set_mode,
 	.owner		= THIS_MODULE,
 };
@@ -1797,6 +1757,7 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id)
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
 	struct phy *generic_phy;
 	struct qmp_phy *qphy;
+	const struct phy_ops *ops = &qcom_qmp_phy_gen_ops;
 	char prop_name[MAX_PROP_NAME];
 	int ret;
 
@@ -1883,7 +1844,10 @@ int qcom_qmp_phy_create(struct device *dev, struct device_node *np, int id)
 		}
 	}
 
-	generic_phy = devm_phy_create(dev, np, &qcom_qmp_phy_gen_ops);
+	if (qmp->cfg->type == PHY_TYPE_UFS)
+		ops = &qcom_qmp_ufs_ops;
+
+	generic_phy = devm_phy_create(dev, np, ops);
 	if (IS_ERR(generic_phy)) {
 		ret = PTR_ERR(generic_phy);
 		dev_err(dev, "failed to create qphy %d\n", ret);
diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-i.h b/drivers/phy/qualcomm/phy-qcom-ufs-i.h
index ba77348d807c..109ddd67be82 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs-i.h
+++ b/drivers/phy/qualcomm/phy-qcom-ufs-i.h
@@ -97,8 +97,6 @@ struct ufs_qcom_phy {
 	char name[UFS_QCOM_PHY_NAME_LEN];
 	struct ufs_qcom_phy_calibration *cached_regs;
 	int cached_regs_table_size;
-	bool is_powered_on;
-	bool is_started;
 	struct ufs_qcom_phy_specific_ops *phy_spec_ops;
 
 	enum phy_mode mode;
@@ -117,6 +115,7 @@ struct ufs_qcom_phy {
  * and writes to QSERDES_RX_SIGDET_CNTRL attribute
  */
 struct ufs_qcom_phy_specific_ops {
+	int (*calibrate)(struct ufs_qcom_phy *ufs_qcom_phy, bool is_rate_B);
 	void (*start_serdes)(struct ufs_qcom_phy *phy);
 	int (*is_physical_coding_sublayer_ready)(struct ufs_qcom_phy *phy);
 	void (*set_tx_lane_enable)(struct ufs_qcom_phy *phy, u32 val);
@@ -134,7 +133,6 @@ struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
 			struct ufs_qcom_phy *common_cfg,
 			const struct phy_ops *ufs_qcom_phy_gen_ops,
 			struct ufs_qcom_phy_specific_ops *phy_spec_ops);
-int ufs_qcom_phy_get_reset(struct ufs_qcom_phy *phy_common);
 int ufs_qcom_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
 			struct ufs_qcom_phy_calibration *tbl_A, int tbl_size_A,
 			struct ufs_qcom_phy_calibration *tbl_B, int tbl_size_B,
diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
index cc343517a2ca..4815546f228c 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
+++ b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
@@ -42,36 +42,6 @@ void ufs_qcom_phy_qmp_14nm_advertise_quirks(struct ufs_qcom_phy *phy_common)
 		UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE;
 }
 
-static int ufs_qcom_phy_qmp_14nm_init(struct phy *generic_phy)
-{
-	struct ufs_qcom_phy *phy_common = get_ufs_qcom_phy(generic_phy);
-	bool is_rate_B = false;
-	int ret;
-
-	ret = ufs_qcom_phy_get_reset(phy_common);
-	if (ret)
-		return ret;
-
-	ret = reset_control_assert(phy_common->ufs_reset);
-	if (ret)
-		return ret;
-
-	if (phy_common->mode == PHY_MODE_UFS_HS_B)
-		is_rate_B = true;
-
-	ret = ufs_qcom_phy_qmp_14nm_phy_calibrate(phy_common, is_rate_B);
-	if (!ret)
-		/* phy calibrated, but yet to be started */
-		phy_common->is_started = false;
-
-	return ret;
-}
-
-static int ufs_qcom_phy_qmp_14nm_exit(struct phy *generic_phy)
-{
-	return 0;
-}
-
 static
 int ufs_qcom_phy_qmp_14nm_set_mode(struct phy *generic_phy,
 				   enum phy_mode mode, int submode)
@@ -132,8 +102,6 @@ static int ufs_qcom_phy_qmp_14nm_is_pcs_ready(struct ufs_qcom_phy *phy_common)
 }
 
 static const struct phy_ops ufs_qcom_phy_qmp_14nm_phy_ops = {
-	.init		= ufs_qcom_phy_qmp_14nm_init,
-	.exit		= ufs_qcom_phy_qmp_14nm_exit,
 	.power_on	= ufs_qcom_phy_power_on,
 	.power_off	= ufs_qcom_phy_power_off,
 	.set_mode	= ufs_qcom_phy_qmp_14nm_set_mode,
@@ -141,6 +109,7 @@ static const struct phy_ops ufs_qcom_phy_qmp_14nm_phy_ops = {
 };
 
 static struct ufs_qcom_phy_specific_ops phy_14nm_ops = {
+	.calibrate		= ufs_qcom_phy_qmp_14nm_phy_calibrate,
 	.start_serdes		= ufs_qcom_phy_qmp_14nm_start_serdes,
 	.is_physical_coding_sublayer_ready = ufs_qcom_phy_qmp_14nm_is_pcs_ready,
 	.set_tx_lane_enable	= ufs_qcom_phy_qmp_14nm_set_tx_lane_enable,
diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
index 54b2af9d8702..f1cf819e12ea 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
+++ b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
@@ -61,36 +61,6 @@ void ufs_qcom_phy_qmp_20nm_advertise_quirks(struct ufs_qcom_phy *phy_common)
 		UFS_QCOM_PHY_QUIRK_HIBERN8_EXIT_AFTER_PHY_PWR_COLLAPSE;
 }
 
-static int ufs_qcom_phy_qmp_20nm_init(struct phy *generic_phy)
-{
-	struct ufs_qcom_phy *phy_common = get_ufs_qcom_phy(generic_phy);
-	bool is_rate_B = false;
-	int ret;
-
-	ret = ufs_qcom_phy_get_reset(phy_common);
-	if (ret)
-		return ret;
-
-	ret = reset_control_assert(phy_common->ufs_reset);
-	if (ret)
-		return ret;
-
-	if (phy_common->mode == PHY_MODE_UFS_HS_B)
-		is_rate_B = true;
-
-	ret = ufs_qcom_phy_qmp_20nm_phy_calibrate(phy_common, is_rate_B);
-	if (!ret)
-		/* phy calibrated, but yet to be started */
-		phy_common->is_started = false;
-
-	return ret;
-}
-
-static int ufs_qcom_phy_qmp_20nm_exit(struct phy *generic_phy)
-{
-	return 0;
-}
-
 static
 int ufs_qcom_phy_qmp_20nm_set_mode(struct phy *generic_phy,
 				   enum phy_mode mode, int submode)
@@ -190,8 +160,6 @@ static int ufs_qcom_phy_qmp_20nm_is_pcs_ready(struct ufs_qcom_phy *phy_common)
 }
 
 static const struct phy_ops ufs_qcom_phy_qmp_20nm_phy_ops = {
-	.init		= ufs_qcom_phy_qmp_20nm_init,
-	.exit		= ufs_qcom_phy_qmp_20nm_exit,
 	.power_on	= ufs_qcom_phy_power_on,
 	.power_off	= ufs_qcom_phy_power_off,
 	.set_mode	= ufs_qcom_phy_qmp_20nm_set_mode,
@@ -199,6 +167,7 @@ static const struct phy_ops ufs_qcom_phy_qmp_20nm_phy_ops = {
 };
 
 static struct ufs_qcom_phy_specific_ops phy_20nm_ops = {
+	.calibrate		= ufs_qcom_phy_qmp_20nm_phy_calibrate,
 	.start_serdes		= ufs_qcom_phy_qmp_20nm_start_serdes,
 	.is_physical_coding_sublayer_ready = ufs_qcom_phy_qmp_20nm_is_pcs_ready,
 	.set_tx_lane_enable	= ufs_qcom_phy_qmp_20nm_set_tx_lane_enable,
diff --git a/drivers/phy/qualcomm/phy-qcom-ufs.c b/drivers/phy/qualcomm/phy-qcom-ufs.c
index fe59785a55f2..0a9f50f086b6 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-ufs.c
@@ -147,7 +147,7 @@ struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
 }
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_generic_probe);
 
-int ufs_qcom_phy_get_reset(struct ufs_qcom_phy *phy_common)
+static int ufs_qcom_phy_get_reset(struct ufs_qcom_phy *phy_common)
 {
 	struct reset_control *reset;
 
@@ -161,7 +161,6 @@ int ufs_qcom_phy_get_reset(struct ufs_qcom_phy *phy_common)
 	phy_common->ufs_reset = reset;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ufs_qcom_phy_get_reset);
 
 static int __ufs_qcom_phy_clk_get(struct device *dev,
 			 const char *name, struct clk **clk_out, bool err_print)
@@ -544,10 +543,23 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 {
 	struct ufs_qcom_phy *phy_common = get_ufs_qcom_phy(generic_phy);
 	struct device *dev = phy_common->dev;
+	bool is_rate_B = false;
 	int err;
 
-	if (phy_common->is_powered_on)
-		return 0;
+	err = ufs_qcom_phy_get_reset(phy_common);
+	if (err)
+		return err;
+
+	err = reset_control_assert(phy_common->ufs_reset);
+	if (err)
+		return err;
+
+	if (phy_common->mode == PHY_MODE_UFS_HS_B)
+		is_rate_B = true;
+
+	err = phy_common->phy_spec_ops->calibrate(phy_common, is_rate_B);
+	if (err)
+		return err;
 
 	err = reset_control_deassert(phy_common->ufs_reset);
 	if (err) {
@@ -555,17 +567,13 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 		return err;
 	}
 
-	if (!phy_common->is_started) {
-		err = ufs_qcom_phy_start_serdes(phy_common);
-		if (err)
-			return err;
-
-		err = ufs_qcom_phy_is_pcs_ready(phy_common);
-		if (err)
-			return err;
+	err = ufs_qcom_phy_start_serdes(phy_common);
+	if (err)
+		return err;
 
-		phy_common->is_started = true;
-	}
+	err = ufs_qcom_phy_is_pcs_ready(phy_common);
+	if (err)
+		return err;
 
 	err = ufs_qcom_phy_enable_vreg(dev, &phy_common->vdda_phy);
 	if (err) {
@@ -609,7 +617,6 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 		}
 	}
 
-	phy_common->is_powered_on = true;
 	goto out;
 
 out_disable_ref_clk:
@@ -629,9 +636,6 @@ int ufs_qcom_phy_power_off(struct phy *generic_phy)
 {
 	struct ufs_qcom_phy *phy_common = get_ufs_qcom_phy(generic_phy);
 
-	if (!phy_common->is_powered_on)
-		return 0;
-
 	phy_common->phy_spec_ops->power_control(phy_common, false);
 
 	if (phy_common->vddp_ref_clk.reg)
@@ -643,8 +647,6 @@ int ufs_qcom_phy_power_off(struct phy *generic_phy)
 	ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_pll);
 	ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_phy);
 	reset_control_assert(phy_common->ufs_reset);
-	phy_common->is_powered_on = false;
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_power_off);
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 1c25b1c82314..de9d3f56b58c 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -544,19 +544,11 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		 */
 		ufs_qcom_disable_lane_clks(host);
 		phy_power_off(phy);
-		goto out;
-	}
 
-	/*
-	 * If UniPro link is not active, PHY ref_clk, main PHY analog power
-	 * rail and low noise analog power rail for PLL can be switched off.
-	 */
-	if (!ufs_qcom_is_link_active(hba)) {
+	} else if (!ufs_qcom_is_link_active(hba)) {
 		ufs_qcom_disable_lane_clks(host);
-		phy_power_off(phy);
 	}
 
-out:
 	return ret;
 }
 
@@ -566,21 +558,26 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	struct phy *phy = host->generic_phy;
 	int err;
 
-	err = phy_power_on(phy);
-	if (err) {
-		dev_err(hba->dev, "%s: failed enabling regs, err = %d\n",
-			__func__, err);
-		goto out;
-	}
+	if (ufs_qcom_is_link_off(hba)) {
+		err = phy_power_on(phy);
+		if (err) {
+			dev_err(hba->dev, "%s: failed PHY power on: %d\n",
+				__func__, err);
+			return err;
+		}
 
-	err = ufs_qcom_enable_lane_clks(host);
-	if (err)
-		goto out;
+		err = ufs_qcom_enable_lane_clks(host);
+		if (err)
+			return err;
 
-	hba->is_sys_suspended = false;
+	} else if (!ufs_qcom_is_link_active(hba)) {
+		err = ufs_qcom_enable_lane_clks(host);
+		if (err)
+			return err;
+	}
 
-out:
-	return err;
+	hba->is_sys_suspended = false;
+	return 0;
 }
 
 struct ufs_qcom_dev_params {
@@ -1106,8 +1103,6 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 		return 0;
 
 	if (on && (status == POST_CHANGE)) {
-		phy_power_on(host->generic_phy);
-
 		/* enable the device ref clock for HS mode*/
 		if (ufshcd_is_hs_mode(&hba->pwr_info))
 			ufs_qcom_dev_ref_clk_ctrl(host, true);
@@ -1119,9 +1114,6 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 		if (!ufs_qcom_is_link_active(hba)) {
 			/* disable device ref_clk */
 			ufs_qcom_dev_ref_clk_ctrl(host, false);
-
-			/* powering off PHY during aggressive clk gating */
-			phy_power_off(host->generic_phy);
 		}
 
 		vote = host->bus_vote.min_bw_vote;
-- 
2.20.1
