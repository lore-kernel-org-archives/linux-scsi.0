From: <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 2/2] scsi: ufs-mediatek: Add UFS support for Mediatek SoC
 chips
Date: Thu, 21 Feb 2019 17:50:37 +0800
Message-ID: <1550742637-12385-4-git-send-email-stanley.chu@mediatek.com>
References: <1550742637-12385-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1550742637-12385-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>

This patch adds UFS support for Mediatek SoC chips.

Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/ufs/Kconfig        |  12 +
 drivers/scsi/ufs/Makefile       |   1 +
 drivers/scsi/ufs/ufs-mediatek.c | 526 ++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-mediatek.h |  91 ++++++
 4 files changed, 630 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufs-mediatek.c
 create mode 100644 drivers/scsi/ufs/ufs-mediatek.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 2ddbb26d9c26..a595f06d501d 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -109,6 +109,18 @@ config SCSI_UFS_QCOM
 	  Select this if you have UFS controller on QCOM chipset.
 	  If unsure, say N.
 
+config SCSI_UFS_MEDIATEK
+	tristate "Mediatek specific hooks to UFS controller platform driver"
+	depends on SCSI_UFSHCD_PLATFORM && ARCH_MEDIATEK
+	help
+	  This selects the Mediatek specific additions to UFSHCD platform driver.
+	  UFS host on Mediatek needs some vendor specific configuration before
+	  accessing the hardware which includes PHY configuration and vendor
+	  specific registers.
+
+	  Select this if you have UFS controller on Mediatek chipset.
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
index 000000000000..ded7de0511cd
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -0,0 +1,526 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Authors:
+ *	Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
+ *	Peter Wang <peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
+ *
+ * Copyright (C) 2019 MediaTek Inc.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See http://www.gnu.org/licenses/gpl-2.0.html for more details.
+ */
+
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+
+#include "ufshcd.h"
+#include "ufshcd-pltfrm.h"
+#include "unipro.h"
+#include "ufs-mediatek.h"
+
+#define mphy_readl(host, ofs) readl((host)->mphy_base + (ofs))
+#define mphy_writel(host, val, ofs) writel((val), (host)->mphy_base + (ofs))
+
+int ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
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
+
+	return 0;
+}
+
+int ufs_mtk_parse_dt(struct ufs_hba *hba)
+{
+	struct device_node *node;
+	struct ufs_mtk_host *host;
+	int err = 0;
+
+	host = ufshcd_get_variant(hba);
+
+	/* get mphy_base */
+	node = of_find_compatible_node(NULL, NULL, "mediatek,ufs_mphy");
+
+	if (node) {
+		host->mphy_base = of_iomap(node, 0);
+		if (IS_ERR(*(void **)&host->mphy_base)) {
+			err = PTR_ERR(*(void **)&host->mphy_base);
+			host->mphy_base = NULL;
+		}
+	}
+
+	if (!host->mphy_base)
+		dev_info(hba->dev, "get mphy_base failed %d\n", err);
+
+	return err;
+}
+
+/**
+ * ufs_mtk_init - find other essential mmio bases
+ * @hba: host controller instance
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
+	ufs_mtk_parse_dt(hba);
+
+out:
+	return err;
+}
+
+struct ufs_mtk_dev_params {
+	u32 pwm_rx_gear;        /* pwm rx gear to work in */
+	u32 pwm_tx_gear;        /* pwm tx gear to work in */
+	u32 hs_rx_gear;         /* hs rx gear to work in */
+	u32 hs_tx_gear;         /* hs tx gear to work in */
+	u32 rx_lanes;           /* number of rx lanes */
+	u32 tx_lanes;           /* number of tx lanes */
+	u32 rx_pwr_pwm;         /* rx pwm working pwr */
+	u32 tx_pwr_pwm;         /* tx pwm working pwr */
+	u32 rx_pwr_hs;          /* rx hs working pwr */
+	u32 tx_pwr_hs;          /* tx hs working pwr */
+	u32 hs_rate;            /* rate A/B to work in HS */
+	u32 desired_working_mode;
+};
+
+static int ufs_mtk_get_pwr_dev_param(struct ufs_mtk_dev_params *mtk_param,
+				     struct ufs_pa_layer_attr *dev_max,
+				     struct ufs_pa_layer_attr *agreed_pwr)
+{
+	int min_mtk_gear;
+	int min_dev_gear;
+	bool is_dev_sup_hs = false;
+	bool is_mtk_max_hs = false;
+
+	if (dev_max->pwr_rx == FAST_MODE)
+		is_dev_sup_hs = true;
+
+	if (mtk_param->desired_working_mode == FAST) {
+		is_mtk_max_hs = true;
+		min_mtk_gear = min_t(u32, mtk_param->hs_rx_gear,
+				     mtk_param->hs_tx_gear);
+	} else {
+		min_mtk_gear = min_t(u32, mtk_param->pwm_rx_gear,
+				     mtk_param->pwm_tx_gear);
+	}
+
+	/*
+	 * device doesn't support HS but
+	 * mtk_param->desired_working_mode is HS,
+	 * thus device and mtk_param don't agree
+	 */
+	if (!is_dev_sup_hs && is_mtk_max_hs) {
+		pr_info("%s: device doesn't support HS\n",
+			__func__);
+		return -ENOTSUPP;
+	} else if (is_dev_sup_hs && is_mtk_max_hs) {
+		/*
+		 * since device supports HS, it supports FAST_MODE.
+		 * since mtk_param->desired_working_mode is also HS
+		 * then final decision (FAST/FASTAUTO) is done according
+		 * to mtk_params as it is the restricting factor
+		 */
+		agreed_pwr->pwr_rx = mtk_param->rx_pwr_hs;
+		agreed_pwr->pwr_tx = mtk_param->rx_pwr_hs;
+	} else {
+		/*
+		 * here mtk_param->desired_working_mode is PWM.
+		 * it doesn't matter whether device supports HS or PWM,
+		 * in both cases mtk_param->desired_working_mode will
+		 * determine the mode
+		 */
+		agreed_pwr->pwr_rx = mtk_param->rx_pwr_pwm;
+		agreed_pwr->pwr_tx = mtk_param->rx_pwr_pwm;
+	}
+
+	/*
+	 * we would like tx to work in the minimum number of lanes
+	 * between device capability and vendor preferences.
+	 * the same decision will be made for rx
+	 */
+	agreed_pwr->lane_tx = min_t(u32, dev_max->lane_tx,
+				    mtk_param->tx_lanes);
+	agreed_pwr->lane_rx = min_t(u32, dev_max->lane_rx,
+				    mtk_param->rx_lanes);
+
+	/* device maximum gear is the minimum between device rx and tx gears */
+	min_dev_gear = min_t(u32, dev_max->gear_rx, dev_max->gear_tx);
+
+	/*
+	 * if both device capabilities and vendor pre-defined preferences are
+	 * both HS or both PWM then set the minimum gear to be the chosen
+	 * working gear.
+	 * if one is PWM and one is HS then the one that is PWM get to decide
+	 * what is the gear, as it is the one that also decided previously what
+	 * pwr the device will be configured to.
+	 */
+	if ((is_dev_sup_hs && is_mtk_max_hs) ||
+	    (!is_dev_sup_hs && !is_mtk_max_hs)) {
+		agreed_pwr->gear_rx =
+			min_t(u32, min_dev_gear, min_mtk_gear);
+		agreed_pwr->gear_tx = agreed_pwr->gear_rx;
+	} else if (!is_dev_sup_hs) {
+		agreed_pwr->gear_rx = min_dev_gear;
+		agreed_pwr->gear_tx = min_dev_gear;
+	} else {
+		agreed_pwr->gear_rx = min_mtk_gear;
+		agreed_pwr->gear_tx = min_mtk_gear;
+	}
+
+	agreed_pwr->hs_rate = mtk_param->hs_rate;
+
+	pr_info("final power mode: gear = %d, lane = %d, pwr = %d, rate = %d\n",
+		agreed_pwr->gear_rx, agreed_pwr->lane_rx, agreed_pwr->pwr_rx,
+		agreed_pwr->hs_rate);
+	return 0;
+}
+
+static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
+				  struct ufs_pa_layer_attr *dev_max_params,
+				  struct ufs_pa_layer_attr *dev_req_params)
+{
+	struct ufs_mtk_dev_params ufs_mtk_cap;
+	int ret;
+
+	ufs_mtk_cap.tx_lanes = UFS_MTK_LIMIT_NUM_LANES_TX;
+	ufs_mtk_cap.rx_lanes = UFS_MTK_LIMIT_NUM_LANES_RX;
+	ufs_mtk_cap.hs_rx_gear = UFS_MTK_LIMIT_HSGEAR_RX;
+	ufs_mtk_cap.hs_tx_gear = UFS_MTK_LIMIT_HSGEAR_TX;
+	ufs_mtk_cap.pwm_rx_gear = UFS_MTK_LIMIT_PWMGEAR_RX;
+	ufs_mtk_cap.pwm_tx_gear = UFS_MTK_LIMIT_PWMGEAR_TX;
+	ufs_mtk_cap.rx_pwr_pwm = UFS_MTK_LIMIT_RX_PWR_PWM;
+	ufs_mtk_cap.tx_pwr_pwm = UFS_MTK_LIMIT_TX_PWR_PWM;
+	ufs_mtk_cap.rx_pwr_hs = UFS_MTK_LIMIT_RX_PWR_HS;
+	ufs_mtk_cap.tx_pwr_hs = UFS_MTK_LIMIT_TX_PWR_HS;
+	ufs_mtk_cap.hs_rate = UFS_MTK_LIMIT_HS_RATE;
+	ufs_mtk_cap.desired_working_mode =
+				UFS_MTK_LIMIT_DESIRED_MODE;
+
+	ret = ufs_mtk_get_pwr_dev_param(&ufs_mtk_cap,
+					dev_max_params,
+					dev_req_params);
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
+	ufshcd_dme_set_attr(hba, UIC_ARG_MIB(PA_LOCALTXLCCENABLE),
+			    0, 0, 0);
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
+		break;
+	}
+
+	return ret;
+}
+
+int ufs_mtk_resume_mphy(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	u32 reg;
+
+	/* release DA_MP_PLL_PWR_ON */
+	reg = mphy_readl(host, MP_LN_DIG_RX_8C);
+	reg = reg | PLL_PWR_ON;
+	mphy_writel(host, reg, MP_LN_DIG_RX_8C);
+	reg = mphy_readl(host, MP_LN_DIG_RX_8C);
+	reg = reg & ~PLL_FRC_PWR_ON;
+	mphy_writel(host, reg, MP_LN_DIG_RX_8C);
+
+	/* release DA_MP_PLL_ISO_EN */
+	reg = mphy_readl(host, MP_LN_DIG_RX_8C);
+	reg = reg & ~PLL_ISO_EN1;
+	mphy_writel(host, reg, MP_LN_DIG_RX_8C);
+	reg = mphy_readl(host, MP_LN_DIG_RX_8C);
+	reg = reg & ~PLL_ISO_EN0;
+	mphy_writel(host, reg, MP_LN_DIG_RX_8C);
+
+	/* release DA_MP_CDR_PWR_ON */
+	reg = mphy_readl(host, MP_LN_DIG_RX_44);
+	reg = reg | CDR_PWR_ON;
+	mphy_writel(host, reg, MP_LN_DIG_RX_44);
+	reg = mphy_readl(host, MP_LN_DIG_RX_44);
+	reg = reg & ~CDR_FRC_PWR_ON;
+	mphy_writel(host, reg, MP_LN_DIG_RX_44);
+
+	/* release DA_MP_CDR_ISO_EN */
+	reg = mphy_readl(host, MP_LN_DIG_RX_44);
+	reg = reg & ~CDR_ISO_EN1;
+	mphy_writel(host, reg, MP_LN_DIG_RX_44);
+	reg = mphy_readl(host, MP_LN_DIG_RX_44);
+	reg = reg & ~CDR_ISO_EN0;
+	mphy_writel(host, reg, MP_LN_DIG_RX_44);
+
+	/* release DA_MP_RX0_SQ_EN */
+	reg = mphy_readl(host, MP_LN_DIG_RX_AC);
+	reg = reg | RX_SQ_EN;
+	mphy_writel(host, reg, MP_LN_DIG_RX_AC);
+	reg = mphy_readl(host, MP_LN_DIG_RX_AC);
+	reg = reg & ~RX_FRC_SQ_EN;
+	mphy_writel(host, reg, MP_LN_DIG_RX_AC);
+
+	/* delay 1us to wait DIFZ stable */
+	udelay(1);
+
+	/* release DIFZ */
+	reg = mphy_readl(host, MP_LN_DIG_RX_9C);
+	reg = reg & ~FSM_DIFZ_FRC;
+	mphy_writel(host, reg, MP_LN_DIG_RX_9C);
+
+	return 0;
+}
+
+int ufs_mtk_suspend_mphy(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	u32 reg;
+
+	/* force DIFZ */
+	reg = mphy_readl(host, MP_LN_DIG_RX_9C);
+	reg = reg | FSM_DIFZ_FRC;
+	mphy_writel(host, reg, MP_LN_DIG_RX_9C);
+
+	/* force DA_MP_RX0_SQ_EN */
+	reg = mphy_readl(host, MP_LN_DIG_RX_AC);
+	reg = reg | RX_FRC_SQ_EN;
+	mphy_writel(host, reg, MP_LN_DIG_RX_AC);
+	reg = mphy_readl(host, MP_LN_DIG_RX_AC);
+	reg = reg & ~RX_SQ_EN;
+	mphy_writel(host, reg, MP_LN_DIG_RX_AC);
+
+	/* force DA_MP_CDR_ISO_EN */
+	reg = mphy_readl(host, MP_LN_DIG_RX_44);
+	reg = reg | CDR_ISO_EN0;
+	mphy_writel(host, reg, MP_LN_DIG_RX_44);
+	reg = mphy_readl(host, MP_LN_DIG_RX_44);
+	reg = reg | CDR_ISO_EN1;
+	mphy_writel(host, reg, MP_LN_DIG_RX_44);
+
+	/* force DA_MP_CDR_PWR_ON */
+	reg = mphy_readl(host, MP_LN_DIG_RX_44);
+	reg = reg | CDR_FRC_PWR_ON;
+	mphy_writel(host, reg, MP_LN_DIG_RX_44);
+	reg = mphy_readl(host, MP_LN_DIG_RX_44);
+	reg = reg & ~CDR_PWR_ON;
+	mphy_writel(host, reg, MP_LN_DIG_RX_44);
+
+	/* force DA_MP_PLL_ISO_EN */
+	reg = mphy_readl(host, MP_LN_DIG_RX_8C);
+	reg = reg | PLL_ISO_EN0;
+	mphy_writel(host, reg, MP_LN_DIG_RX_8C);
+	reg = mphy_readl(host, MP_LN_DIG_RX_8C);
+	reg = reg | PLL_ISO_EN1;
+	mphy_writel(host, reg, MP_LN_DIG_RX_8C);
+
+	/* force DA_MP_PLL_PWR_ON */
+	reg = mphy_readl(host, MP_LN_DIG_RX_8C);
+	reg = reg | PLL_FRC_PWR_ON;
+	mphy_writel(host, reg, MP_LN_DIG_RX_8C);
+	reg = mphy_readl(host, MP_LN_DIG_RX_8C);
+	reg = reg & ~PLL_PWR_ON;
+	mphy_writel(host, reg, MP_LN_DIG_RX_8C);
+
+	return 0;
+}
+
+static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	if (ufshcd_is_link_hibern8(hba))
+		ufs_mtk_suspend_mphy(hba);
+
+	return 0;
+}
+
+static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	if (ufshcd_is_link_hibern8(hba))
+		ufs_mtk_resume_mphy(hba);
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
index 000000000000..6431155fc36c
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-mediatek.h
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 MediaTek Inc.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See http://www.gnu.org/licenses/gpl-2.0.html for more details.
+ */
+
+#ifndef _UFS_MEDIATEK_H
+#define _UFS_MEDIATEK_H
+
+/*
+ * Vendor specific pre-defined parameters
+ */
+#define SLOW 1
+#define FAST 2
+
+#define UFS_MTK_LIMIT_NUM_LANES_RX  2
+#define UFS_MTK_LIMIT_NUM_LANES_TX  2
+#define UFS_MTK_LIMIT_HSGEAR_RX     UFS_HS_G3
+#define UFS_MTK_LIMIT_HSGEAR_TX     UFS_HS_G3
+#define UFS_MTK_LIMIT_PWMGEAR_RX    UFS_PWM_G4
+#define UFS_MTK_LIMIT_PWMGEAR_TX    UFS_PWM_G4
+#define UFS_MTK_LIMIT_RX_PWR_PWM    SLOW_MODE
+#define UFS_MTK_LIMIT_TX_PWR_PWM    SLOW_MODE
+#define UFS_MTK_LIMIT_RX_PWR_HS     FAST_MODE
+#define UFS_MTK_LIMIT_TX_PWR_HS     FAST_MODE
+#define UFS_MTK_LIMIT_HS_RATE       PA_HS_MODE_B
+#define UFS_MTK_LIMIT_DESIRED_MODE  FAST
+
+/*
+ * MPHY register and offsets
+ */
+#define MP_LN_DIG_RX_44             0xA044
+#define CDR_FRC_PWR_ON              BIT(17)
+#define CDR_PWR_ON                  BIT(18)
+#define CDR_ISO_EN0                 BIT(19)
+#define CDR_ISO_EN1                 BIT(20)
+
+#define MP_LN_DIG_RX_8C             0xA08C
+#define PLL_ISO_EN0                 BIT(8)
+#define PLL_ISO_EN1                 BIT(9)
+#define PLL_FRC_PWR_ON              BIT(10)
+#define PLL_PWR_ON                  BIT(11)
+
+#define MP_LN_DIG_RX_9C             0xA09C
+#define FSM_DIFZ_FRC                BIT(18)
+
+#define MP_LN_DIG_RX_AC             0xA0AC
+#define RX_FRC_SQ_EN                BIT(0)
+#define RX_SQ_EN                    BIT(1)
+
+/*
+ * PHY Adpater attributes
+ */
+#define PA_LOCALTXLCCENABLE         0x155E
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
+	void __iomem *mphy_base;
+};
+
+#endif /* !_UFS_MEDIATEK_H */
+
-- 
2.18.0
