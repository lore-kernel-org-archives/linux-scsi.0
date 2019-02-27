From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 7/7] scsi: ufs-mediatek: Add UFS support for Mediatek SoC
 chips
Date: Wed, 27 Feb 2019 15:23:12 +0800
Message-ID: <1551252192-535-9-git-send-email-stanley.chu@mediatek.com>
References: <1551252192-535-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1551252192-535-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, chunfeng.yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kishon-l0cyMroinI0@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org
Cc: chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This patch adds UFS support for MediaTek SoC chips.

Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Reviewed-by: Avri Altman <avri.altman-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/scsi/ufs/Kconfig        |  14 ++
 drivers/scsi/ufs/Makefile       |   1 +
 drivers/scsi/ufs/ufs-mediatek.c | 368 ++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-mediatek.h |  54 +++++
 4 files changed, 437 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-mediatek.c
 create mode 100644 drivers/scsi/ufs/ufs-mediatek.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 2ddbb26d9c26..58e5a9c8eb5d 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -109,6 +109,20 @@ config SCSI_UFS_QCOM
 	  Select this if you have UFS controller on QCOM chipset.
 	  If unsure, say N.
 
+config SCSI_UFS_MEDIATEK
+	tristate "Mediatek specific hooks to UFS controller platform driver"
+	depends on SCSI_UFSHCD_PLATFORM && ARCH_MEDIATEK
+	select PHY_MTK_UFS
+	help
+	  This selects the Mediatek specific additions to UFSHCD platform driver.
+	  UFS host on Mediatek needs some vendor specific configuration before
+	  accessing the hardware which includes PHY configuration and vendor
+	  specific registers.
+
+	  Select this if you have UFS controller on Mediatek chipset.
+
+	  If unsure, say N.
+
 config SCSI_UFS_HISI
 	tristate "Hisilicon specific hooks to UFS controller platform driver"
 	depends on (ARCH_HISI || COMPILE_TEST) && SCSI_UFSHCD_PLATFORM
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index a3bd70c3652c..2a9097939bcb 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -10,3 +10,4 @@ ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
+obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
new file mode 100644
index 000000000000..ede843f88603
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -0,0 +1,368 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 MediaTek Inc.
+ * Authors:
+ *	Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
+ *	Peter Wang <peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
+ */
+
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+
+#include "ufshcd.h"
+#include "ufshcd-pltfrm.h"
+#include "unipro.h"
+#include "ufs-mediatek.h"
+
+void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
+{
+	u32 tmp;
+
+	if (enable) {
+		ufshcd_dme_get(hba,
+			       UIC_ARG_MIB(VS_SAVEPOWERCONTROL), &tmp);
+		tmp = tmp |
+		      (1 << RX_SYMBOL_CLK_GATE_EN) |
+		      (1 << SYS_CLK_GATE_EN) |
+		      (1 << TX_CLK_GATE_EN);
+		ufshcd_dme_set(hba,
+			       UIC_ARG_MIB(VS_SAVEPOWERCONTROL), tmp);
+
+		ufshcd_dme_get(hba,
+			       UIC_ARG_MIB(VS_DEBUGCLOCKENABLE), &tmp);
+		tmp = tmp & ~(1 << TX_SYMBOL_CLK_REQ_FORCE);
+		ufshcd_dme_set(hba,
+			       UIC_ARG_MIB(VS_DEBUGCLOCKENABLE), tmp);
+	} else {
+		ufshcd_dme_get(hba,
+			       UIC_ARG_MIB(VS_SAVEPOWERCONTROL), &tmp);
+		tmp = tmp & ~((1 << RX_SYMBOL_CLK_GATE_EN) |
+			      (1 << SYS_CLK_GATE_EN) |
+			      (1 << TX_CLK_GATE_EN));
+		ufshcd_dme_set(hba,
+			       UIC_ARG_MIB(VS_SAVEPOWERCONTROL), tmp);
+
+		ufshcd_dme_get(hba,
+			       UIC_ARG_MIB(VS_DEBUGCLOCKENABLE), &tmp);
+		tmp = tmp | (1 << TX_SYMBOL_CLK_REQ_FORCE);
+		ufshcd_dme_set(hba,
+			       UIC_ARG_MIB(VS_DEBUGCLOCKENABLE), tmp);
+	}
+}
+
+int ufs_mtk_bind_mphy(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+	struct device_node *np = dev->of_node;
+	int err = 0;
+
+	host->mphy = devm_of_phy_get_by_index(dev, np, 0);
+
+	if (host->mphy == ERR_PTR(-EPROBE_DEFER)) {
+		/*
+		 * UFS driver might be probed before the phy driver does.
+		 * In that case we would like to return EPROBE_DEFER code.
+		 */
+		err = -EPROBE_DEFER;
+		dev_info(dev,
+			 "%s: required phy hasn't probed yet. err = %d\n",
+			__func__, err);
+	} else if (IS_ERR(host->mphy)) {
+		err = PTR_ERR(host->mphy);
+		dev_info(dev, "%s: PHY get failed %d\n", __func__, err);
+	}
+
+	if (err)
+		host->mphy = NULL;
+
+	return err;
+}
+
+/**
+ * ufs_mtk_setup_clocks - enables/disable clocks
+ * @hba: host controller instance
+ * @on: If true, enable clocks else disable them.
+ * @status: PRE_CHANGE or POST_CHANGE notify
+ *
+ * Returns 0 on success, non-zero on failure.
+ */
+static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
+				enum ufs_notify_change_status status)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	int ret;
+
+	/*
+	 * In case ufs_mtk_init() is not yet done, simply ignore.
+	 * This ufs_mtk_setup_clocks() shall be called from
+	 * ufs_mtk_init() after init is done.
+	 */
+	if (!host)
+		return 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		if (!on)
+			ret = phy_power_off(host->mphy);
+		break;
+	case POST_CHANGE:
+		if (on)
+			ret = phy_power_on(host->mphy);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * ufs_mtk_init - find other essential mmio bases
+ * @hba: host controller instance
+ *
+ * Binds PHY with controller and powers up PHY enabling clocks
+ * and regulators.
+ *
+ * Returns -EPROBE_DEFER if binding fails, returns negative error
+ * on phy power up failure and returns zero on success.
+ */
+static int ufs_mtk_init(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host;
+	struct device *dev = hba->dev;
+	int err = 0;
+
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+	if (!host) {
+		err = -ENOMEM;
+		dev_info(dev, "%s: no memory for mtk ufs host\n", __func__);
+		goto out;
+	}
+
+	host->hba = hba;
+	ufshcd_set_variant(hba, host);
+
+	err = ufs_mtk_bind_mphy(hba);
+	if (err)
+		goto out_variant_clear;
+
+	/*
+	 * ufshcd_vops_init() is invoked after
+	 * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
+	 * phy clock setup is skipped.
+	 *
+	 * Enable phy clocks specifically here.
+	 */
+	ufs_mtk_setup_clocks(hba, true, POST_CHANGE);
+
+	goto out;
+
+out_variant_clear:
+	ufshcd_set_variant(hba, NULL);
+out:
+	return err;
+}
+
+static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
+				  struct ufs_pa_layer_attr *dev_max_params,
+				  struct ufs_pa_layer_attr *dev_req_params)
+{
+	struct ufs_dev_params host_cap;
+	int ret;
+
+	host_cap.tx_lanes = UFS_MTK_LIMIT_NUM_LANES_TX;
+	host_cap.rx_lanes = UFS_MTK_LIMIT_NUM_LANES_RX;
+	host_cap.hs_rx_gear = UFS_MTK_LIMIT_HSGEAR_RX;
+	host_cap.hs_tx_gear = UFS_MTK_LIMIT_HSGEAR_TX;
+	host_cap.pwm_rx_gear = UFS_MTK_LIMIT_PWMGEAR_RX;
+	host_cap.pwm_tx_gear = UFS_MTK_LIMIT_PWMGEAR_TX;
+	host_cap.rx_pwr_pwm = UFS_MTK_LIMIT_RX_PWR_PWM;
+	host_cap.tx_pwr_pwm = UFS_MTK_LIMIT_TX_PWR_PWM;
+	host_cap.rx_pwr_hs = UFS_MTK_LIMIT_RX_PWR_HS;
+	host_cap.tx_pwr_hs = UFS_MTK_LIMIT_TX_PWR_HS;
+	host_cap.hs_rate = UFS_MTK_LIMIT_HS_RATE;
+	host_cap.desired_working_mode =
+				UFS_MTK_LIMIT_DESIRED_MODE;
+
+	ret = ufshcd_get_pwr_dev_param(&host_cap,
+				       dev_max_params,
+				       dev_req_params);
+	if (ret) {
+		pr_info("%s: failed to determine capabilities\n",
+			__func__);
+	}
+
+	return ret;
+}
+
+static int ufs_mtk_pwr_change_notify(struct ufs_hba *hba,
+				     enum ufs_notify_change_status stage,
+				     struct ufs_pa_layer_attr *dev_max_params,
+				     struct ufs_pa_layer_attr *dev_req_params)
+{
+	int ret = 0;
+
+	switch (stage) {
+	case PRE_CHANGE:
+		ret = ufs_mtk_pre_pwr_change(hba, dev_max_params,
+					     dev_req_params);
+		break;
+	case POST_CHANGE:
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int ufs_mtk_pre_link(struct ufs_hba *hba)
+{
+	int ret;
+	u32 tmp;
+
+	/* disable deep stall */
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_SAVEPOWERCONTROL), &tmp);
+	if (ret)
+		return ret;
+
+	tmp &= ~(1 << 6);
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_SAVEPOWERCONTROL), tmp);
+
+	return ret;
+}
+
+static int ufs_mtk_post_link(struct ufs_hba *hba)
+{
+	/* disable device LCC */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
+
+	/* enable unipro clock gating feature */
+	ufs_mtk_cfg_unipro_cg(hba, true);
+
+	return 0;
+}
+
+static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
+				       enum ufs_notify_change_status stage)
+{
+	int ret = 0;
+
+	switch (stage) {
+	case PRE_CHANGE:
+		ret = ufs_mtk_pre_link(hba);
+		break;
+	case POST_CHANGE:
+		ret = ufs_mtk_post_link(hba);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	if (ufshcd_is_link_hibern8(hba))
+		phy_power_off(host->mphy);
+
+	return 0;
+}
+
+static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	if (ufshcd_is_link_hibern8(hba))
+		phy_power_on(host->mphy);
+
+	return 0;
+}
+
+/**
+ * struct ufs_hba_mtk_vops - UFS MTK specific variant operations
+ *
+ * The variant operations configure the necessary controller and PHY
+ * handshake during initialization.
+ */
+static struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
+	.name                = "mediatek.ufshci",
+	.init                = ufs_mtk_init,
+	.setup_clocks        = ufs_mtk_setup_clocks,
+	.link_startup_notify = ufs_mtk_link_startup_notify,
+	.pwr_change_notify   = ufs_mtk_pwr_change_notify,
+	.suspend             = ufs_mtk_suspend,
+	.resume              = ufs_mtk_resume,
+};
+
+/**
+ * ufs_mtk_probe - probe routine of the driver
+ * @pdev: pointer to Platform device handle
+ *
+ * Return zero for success and non-zero for failure
+ */
+static int ufs_mtk_probe(struct platform_device *pdev)
+{
+	int err;
+	struct device *dev = &pdev->dev;
+
+	/* perform generic probe */
+	err = ufshcd_pltfrm_init(pdev, &ufs_hba_mtk_vops);
+	if (err)
+		dev_info(dev, "probe failed %d\n", err);
+
+	return err;
+}
+
+/**
+ * ufs_mtk_remove - set driver_data of the device to NULL
+ * @pdev: pointer to platform device handle
+ *
+ * Always return 0
+ */
+static int ufs_mtk_remove(struct platform_device *pdev)
+{
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	pm_runtime_get_sync(&(pdev)->dev);
+	ufshcd_remove(hba);
+	return 0;
+}
+
+const struct of_device_id ufs_mtk_of_match[] = {
+	{ .compatible = "mediatek,ufshci"},
+	{},
+};
+
+static const struct dev_pm_ops ufs_mtk_pm_ops = {
+	.suspend         = ufshcd_pltfrm_suspend,
+	.resume          = ufshcd_pltfrm_resume,
+	.runtime_suspend = ufshcd_pltfrm_runtime_suspend,
+	.runtime_resume  = ufshcd_pltfrm_runtime_resume,
+	.runtime_idle    = ufshcd_pltfrm_runtime_idle,
+};
+
+static struct platform_driver ufs_mtk_pltform = {
+	.probe      = ufs_mtk_probe,
+	.remove     = ufs_mtk_remove,
+	.shutdown   = ufshcd_pltfrm_shutdown,
+	.driver = {
+		.name   = "ufshcd-mtk",
+		.owner  = THIS_MODULE,
+		.pm     = &ufs_mtk_pm_ops,
+		.of_match_table = ufs_mtk_of_match,
+	},
+};
+
+module_platform_driver(ufs_mtk_pltform);
+
diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-mediatek.h
new file mode 100644
index 000000000000..cc633b627ef0
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-mediatek.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 MediaTek Inc.
+ */
+
+#ifndef _UFS_MEDIATEK_H
+#define _UFS_MEDIATEK_H
+
+/*
+ * Vendor specific pre-defined parameters
+ */
+#define UFS_MTK_LIMIT_NUM_LANES_RX  1
+#define UFS_MTK_LIMIT_NUM_LANES_TX  1
+#define UFS_MTK_LIMIT_HSGEAR_RX     UFS_HS_G3
+#define UFS_MTK_LIMIT_HSGEAR_TX     UFS_HS_G3
+#define UFS_MTK_LIMIT_PWMGEAR_RX    UFS_PWM_G4
+#define UFS_MTK_LIMIT_PWMGEAR_TX    UFS_PWM_G4
+#define UFS_MTK_LIMIT_RX_PWR_PWM    SLOW_MODE
+#define UFS_MTK_LIMIT_TX_PWR_PWM    SLOW_MODE
+#define UFS_MTK_LIMIT_RX_PWR_HS     FAST_MODE
+#define UFS_MTK_LIMIT_TX_PWR_HS     FAST_MODE
+#define UFS_MTK_LIMIT_HS_RATE       PA_HS_MODE_B
+#define UFS_MTK_LIMIT_DESIRED_MODE  UFS_HS_MODE
+
+/*
+ * Other attributes
+ */
+#define VS_DEBUGCLOCKENABLE         0xD0A1
+#define VS_SAVEPOWERCONTROL         0xD0A6
+#define VS_UNIPROPOWERDOWNCONTROL   0xD0A8
+
+/*
+ * VS_DEBUGCLOCKENABLE
+ */
+enum {
+	TX_SYMBOL_CLK_REQ_FORCE = 5,
+};
+
+/*
+ * VS_SAVEPOWERCONTROL
+ */
+enum {
+	RX_SYMBOL_CLK_GATE_EN   = 0,
+	SYS_CLK_GATE_EN         = 2,
+	TX_CLK_GATE_EN          = 3,
+};
+
+struct ufs_mtk_host {
+	struct ufs_hba *hba;
+	struct phy *mphy;
+};
+
+#endif /* !_UFS_MEDIATEK_H */
+
-- 
2.18.0
