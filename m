From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v4 7/8] phy: qcom: Utilize UFS reset controller
Date: Wed, 13 Feb 2019 15:25:25 -0800
Message-ID: <20190213232526.26995-8-evgreen@chromium.org>
References: <20190213232526.26995-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213232526.26995-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Gross <andy.gross@linaro.org>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Stephen Boyd <swboyd@chromium.org>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Evan Green <evgreen@chromium.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, Grygorii Strashko <grygorii.strashko@ti.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-kernel@vger.kernel.org, Manu Gautam <mgautam@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Move the PHY reset from ufs-qcom into the respective PHYs. This will
allow us to merge the two phases of UFS PHY initialization.

Signed-off-by: Evan Green <evgreen@chromium.org>

---

Changes in v4:
- Do reset_control_* unconditionally since null is handled (Stephen).

Changes in v3:
- Refactored to move reset control in a single commit (Stephen)
- Use no_pcs_sw_reset as an indicator of UFS reset in qmp-phy (Stephen).
- Assign ret = PTR_ERR() earlier, for better reuse (Stephen).

Changes in v2:
- Use devm_* to get the reset (Stephen)
- Clear ufs_reset on error getting it
- Remove needless error print (Stephen)

 drivers/phy/qualcomm/phy-qcom-qmp.c          | 34 ++++++++++++++++++++
 drivers/phy/qualcomm/phy-qcom-ufs-i.h        |  3 ++
 drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c |  8 +++++
 drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c |  8 +++++
 drivers/phy/qualcomm/phy-qcom-ufs.c          | 23 +++++++++++++
 drivers/scsi/ufs/ufs-qcom.c                  | 18 -----------
 6 files changed, 76 insertions(+), 18 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index 08d6f6f7f039..a808887ab4e2 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -897,6 +897,7 @@ struct qmp_phy {
  * @init_count: phy common block initialization count
  * @phy_initialized: indicate if PHY has been initialized
  * @mode: current PHY mode
+ * @ufs_reset: optional UFS PHY reset handle
  */
 struct qcom_qmp {
 	struct device *dev;
@@ -914,6 +915,8 @@ struct qcom_qmp {
 	int init_count;
 	bool phy_initialized;
 	enum phy_mode mode;
+
+	struct reset_control *ufs_reset;
 };
 
 static inline void qphy_setbits(void __iomem *base, u32 offset, u32 val)
@@ -1314,6 +1317,7 @@ static int qcom_qmp_phy_com_exit(struct qcom_qmp *qmp)
 		return 0;
 	}
 
+	reset_control_assert(qmp->ufs_reset);
 	if (cfg->has_phy_com_ctrl) {
 		qphy_setbits(serdes, cfg->regs[QPHY_COM_START_CONTROL],
 			     SERDES_START | PCS_START);
@@ -1351,6 +1355,33 @@ static int qcom_qmp_phy_init(struct phy *phy)
 
 	dev_vdbg(qmp->dev, "Initializing QMP phy\n");
 
+	if (cfg->no_pcs_sw_reset) {
+		/*
+		 * Get UFS reset, which is delayed until now to avoid a
+		 * circular dependency where UFS needs its PHY, but the PHY
+		 * needs this UFS reset.
+		 */
+		if (!qmp->ufs_reset) {
+			qmp->ufs_reset =
+				devm_reset_control_get_exclusive(qmp->dev,
+								 "ufsphy");
+
+			if (IS_ERR(qmp->ufs_reset)) {
+				ret = PTR_ERR(qmp->ufs_reset);
+				dev_err(qmp->dev,
+					"failed to get UFS reset: %d\n",
+					ret);
+
+				qmp->ufs_reset = NULL;
+				return ret;
+			}
+		}
+
+		ret = reset_control_assert(qmp->ufs_reset);
+		if (ret)
+			goto err_lane_rst;
+	}
+
 	ret = qcom_qmp_phy_com_init(qphy);
 	if (ret)
 		return ret;
@@ -1383,6 +1414,9 @@ static int qcom_qmp_phy_init(struct phy *phy)
 				       cfg->rx_tbl, cfg->rx_tbl_num);
 
 	qcom_qmp_phy_configure(pcs, cfg->regs, cfg->pcs_tbl, cfg->pcs_tbl_num);
+	ret = reset_control_deassert(qmp->ufs_reset);
+	if (ret)
+		goto err_lane_rst;
 
 	/*
 	 * UFS PHY requires the deassert of software reset before serdes start.
diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-i.h b/drivers/phy/qualcomm/phy-qcom-ufs-i.h
index f798fb64de94..ba77348d807c 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs-i.h
+++ b/drivers/phy/qualcomm/phy-qcom-ufs-i.h
@@ -19,6 +19,7 @@
 #include <linux/clk.h>
 #include <linux/phy/phy.h>
 #include <linux/regulator/consumer.h>
+#include <linux/reset.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
@@ -101,6 +102,7 @@ struct ufs_qcom_phy {
 	struct ufs_qcom_phy_specific_ops *phy_spec_ops;
 
 	enum phy_mode mode;
+	struct reset_control *ufs_reset;
 };
 
 /**
@@ -132,6 +134,7 @@ struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
 			struct ufs_qcom_phy *common_cfg,
 			const struct phy_ops *ufs_qcom_phy_gen_ops,
 			struct ufs_qcom_phy_specific_ops *phy_spec_ops);
+int ufs_qcom_phy_get_reset(struct ufs_qcom_phy *phy_common);
 int ufs_qcom_phy_calibrate(struct ufs_qcom_phy *ufs_qcom_phy,
 			struct ufs_qcom_phy_calibration *tbl_A, int tbl_size_A,
 			struct ufs_qcom_phy_calibration *tbl_B, int tbl_size_B,
diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
index 1e0d4f2046a4..cc343517a2ca 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
+++ b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
@@ -48,6 +48,14 @@ static int ufs_qcom_phy_qmp_14nm_init(struct phy *generic_phy)
 	bool is_rate_B = false;
 	int ret;
 
+	ret = ufs_qcom_phy_get_reset(phy_common);
+	if (ret)
+		return ret;
+
+	ret = reset_control_assert(phy_common->ufs_reset);
+	if (ret)
+		return ret;
+
 	if (phy_common->mode == PHY_MODE_UFS_HS_B)
 		is_rate_B = true;
 
diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
index aef40f7a41d4..54b2af9d8702 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
+++ b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
@@ -67,6 +67,14 @@ static int ufs_qcom_phy_qmp_20nm_init(struct phy *generic_phy)
 	bool is_rate_B = false;
 	int ret;
 
+	ret = ufs_qcom_phy_get_reset(phy_common);
+	if (ret)
+		return ret;
+
+	ret = reset_control_assert(phy_common->ufs_reset);
+	if (ret)
+		return ret;
+
 	if (phy_common->mode == PHY_MODE_UFS_HS_B)
 		is_rate_B = true;
 
diff --git a/drivers/phy/qualcomm/phy-qcom-ufs.c b/drivers/phy/qualcomm/phy-qcom-ufs.c
index f2979ccad00a..fe59785a55f2 100644
--- a/drivers/phy/qualcomm/phy-qcom-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-ufs.c
@@ -147,6 +147,22 @@ struct phy *ufs_qcom_phy_generic_probe(struct platform_device *pdev,
 }
 EXPORT_SYMBOL_GPL(ufs_qcom_phy_generic_probe);
 
+int ufs_qcom_phy_get_reset(struct ufs_qcom_phy *phy_common)
+{
+	struct reset_control *reset;
+
+	if (phy_common->ufs_reset)
+		return 0;
+
+	reset = devm_reset_control_get_exclusive_by_index(phy_common->dev, 0);
+	if (IS_ERR(reset))
+		return PTR_ERR(reset);
+
+	phy_common->ufs_reset = reset;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ufs_qcom_phy_get_reset);
+
 static int __ufs_qcom_phy_clk_get(struct device *dev,
 			 const char *name, struct clk **clk_out, bool err_print)
 {
@@ -533,6 +549,12 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
 	if (phy_common->is_powered_on)
 		return 0;
 
+	err = reset_control_deassert(phy_common->ufs_reset);
+	if (err) {
+		dev_err(dev, "Failed to assert UFS PHY reset");
+		return err;
+	}
+
 	if (!phy_common->is_started) {
 		err = ufs_qcom_phy_start_serdes(phy_common);
 		if (err)
@@ -620,6 +642,7 @@ int ufs_qcom_phy_power_off(struct phy *generic_phy)
 
 	ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_pll);
 	ufs_qcom_phy_disable_vreg(phy_common->dev, &phy_common->vdda_phy);
+	reset_control_assert(phy_common->ufs_reset);
 	phy_common->is_powered_on = false;
 
 	return 0;
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index ab05ef5cfdcd..1c25b1c82314 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -261,11 +261,6 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 	if (is_rate_B)
 		phy_set_mode(phy, PHY_MODE_UFS_HS_B);
 
-	/* Assert PHY reset and apply PHY calibration values */
-	ufs_qcom_assert_reset(hba);
-	/* provide 1ms delay to let the reset pulse propagate */
-	usleep_range(1000, 1100);
-
 	/* phy initialization - calibrate the phy */
 	ret = phy_init(phy);
 	if (ret) {
@@ -274,15 +269,6 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 		goto out;
 	}
 
-	/* De-assert PHY reset and start serdes */
-	ufs_qcom_deassert_reset(hba);
-
-	/*
-	 * after reset deassertion, phy will need all ref clocks,
-	 * voltage, current to settle down before starting serdes.
-	 */
-	usleep_range(1000, 1100);
-
 	/* power on phy - start serdes and phy's power and clocks */
 	ret = phy_power_on(phy);
 	if (ret) {
@@ -296,7 +282,6 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 	return 0;
 
 out_disable_phy:
-	ufs_qcom_assert_reset(hba);
 	phy_exit(phy);
 out:
 	return ret;
@@ -559,9 +544,6 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		 */
 		ufs_qcom_disable_lane_clks(host);
 		phy_power_off(phy);
-
-		/* Assert PHY soft reset */
-		ufs_qcom_assert_reset(hba);
 		goto out;
 	}
 
-- 
2.20.1
