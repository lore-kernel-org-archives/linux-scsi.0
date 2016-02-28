From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v5 15/15] scsi: ufs-qcom: set PA_Local_TX_LCC_Enable before link startup
Date: Sun, 28 Feb 2016 15:32:47 +0200
Message-ID: <1456666367-11418-16-git-send-email-ygardi@codeaurora.org>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59270 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933856AbcB1Ndq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2016 08:33:46 -0500
In-Reply-To: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Some UFS devices (and may be host) have issues if LCC is
enabled. So we are setting PA_Local_TX_LCC_Enable to 0
before link startup which will make sure that both host
and device TX LCC are disabled once link startup is
completed.

This change also:
- enables the device ref clock before changing to HS mode
  and disables it if entered to PWM mode
- adds printouts of testbus debug registers

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 116 +++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufs-qcom.h |   9 ++++
 drivers/scsi/ufs/ufshcd.h   |   9 ++++
 drivers/scsi/ufs/unipro.h   |   1 +
 4 files changed, 128 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index ed57729..3aedf73 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -16,8 +16,8 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/phy/phy.h>
-
 #include <linux/phy/phy-qcom-ufs.h>
+
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
 #include "unipro.h"
@@ -58,6 +58,12 @@ static void ufs_qcom_dump_regs(struct ufs_hba *hba, int offset, int len,
 			len * 4, false);
 }
 
+static void ufs_qcom_dump_regs_wrapper(struct ufs_hba *hba, int offset, int len,
+		char *prefix, void *priv)
+{
+	ufs_qcom_dump_regs(hba, offset, len, prefix);
+}
+
 static int ufs_qcom_get_connected_tx_lanes(struct ufs_hba *hba, u32 *tx_lanes)
 {
 	int err = 0;
@@ -106,9 +112,11 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
 	if (!host->is_lane_clks_enabled)
 		return;
 
-	clk_disable_unprepare(host->tx_l1_sync_clk);
+	if (host->hba->lanes_per_direction > 1)
+		clk_disable_unprepare(host->tx_l1_sync_clk);
 	clk_disable_unprepare(host->tx_l0_sync_clk);
-	clk_disable_unprepare(host->rx_l1_sync_clk);
+	if (host->hba->lanes_per_direction > 1)
+		clk_disable_unprepare(host->rx_l1_sync_clk);
 	clk_disable_unprepare(host->rx_l0_sync_clk);
 
 	host->is_lane_clks_enabled = false;
@@ -272,9 +280,8 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 	ret = ufs_qcom_phy_calibrate_phy(phy, is_rate_B);
 
 	if (ret) {
-		dev_err(hba->dev,
-		"%s: ufs_qcom_phy_calibrate_phy()failed, ret = %d\n",
-		__func__, ret);
+		dev_err(hba->dev, "%s: ufs_qcom_phy_calibrate_phy() failed, ret = %d\n",
+			__func__, ret);
 		goto out;
 	}
 
@@ -524,6 +531,18 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 			err = ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div(hba,
 									  150);
 
+		/*
+		 * Some UFS devices (and may be host) have issues if LCC is
+		 * enabled. So we are setting PA_Local_TX_LCC_Enable to 0
+		 * before link startup which will make sure that both host
+		 * and device TX LCC are disabled once link startup is
+		 * completed.
+		 */
+		if (ufshcd_get_local_unipro_ver(hba) != UFS_UNIPRO_VER_1_41)
+			err = ufshcd_dme_set(hba,
+					UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE),
+					0);
+
 		break;
 	case POST_CHANGE:
 		ufs_qcom_link_startup_post_change(hba);
@@ -967,6 +986,10 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 			goto out;
 		}
 
+		/* enable the device ref clock before changing to HS mode */
+		if (!ufshcd_is_hs_mode(&hba->pwr_info) &&
+			ufshcd_is_hs_mode(dev_req_params))
+			ufs_qcom_dev_ref_clk_ctrl(host, true);
 		break;
 	case POST_CHANGE:
 		if (ufs_qcom_cfg_timers(hba, dev_req_params->gear_rx,
@@ -994,6 +1017,11 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 		memcpy(&host->dev_req_params,
 				dev_req_params, sizeof(*dev_req_params));
 		ufs_qcom_update_bus_bw_vote(host);
+
+		/* disable the device ref clock if entered PWM mode */
+		if (ufshcd_is_hs_mode(&hba->pwr_info) &&
+			!ufshcd_is_hs_mode(dev_req_params))
+			ufs_qcom_dev_ref_clk_ctrl(host, false);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1095,6 +1123,9 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on)
 			ufs_qcom_phy_disable_iface_clk(host->generic_phy);
 			goto out;
 		}
+		/* enable the device ref clock for HS mode*/
+		if (ufshcd_is_hs_mode(&hba->pwr_info))
+			ufs_qcom_dev_ref_clk_ctrl(host, true);
 		vote = host->bus_vote.saved_vote;
 		if (vote == host->bus_vote.min_bw_vote)
 			ufs_qcom_update_bus_bw_vote(host);
@@ -1372,6 +1403,74 @@ out:
 	return err;
 }
 
+static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
+		void *priv, void (*print_fn)(struct ufs_hba *hba,
+		int offset, int num_regs, char *str, void *priv))
+{
+	u32 reg;
+	struct ufs_qcom_host *host;
+
+	if (unlikely(!hba)) {
+		pr_err("%s: hba is NULL\n", __func__);
+		return;
+	}
+	if (unlikely(!print_fn)) {
+		dev_err(hba->dev, "%s: print_fn is NULL\n", __func__);
+		return;
+	}
+
+	host = ufshcd_get_variant(hba);
+	if (!(host->dbg_print_en & UFS_QCOM_DBG_PRINT_REGS_EN))
+		return;
+
+	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_REG_OCSC);
+	print_fn(hba, reg, 44, "UFS_UFS_DBG_RD_REG_OCSC ", priv);
+
+	reg = ufshcd_readl(hba, REG_UFS_CFG1);
+	reg |= UFS_BIT(17);
+	ufshcd_writel(hba, reg, REG_UFS_CFG1);
+
+	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_EDTL_RAM);
+	print_fn(hba, reg, 32, "UFS_UFS_DBG_RD_EDTL_RAM ", priv);
+
+	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_DESC_RAM);
+	print_fn(hba, reg, 128, "UFS_UFS_DBG_RD_DESC_RAM ", priv);
+
+	reg = ufs_qcom_get_debug_reg_offset(host, UFS_UFS_DBG_RD_PRDT_RAM);
+	print_fn(hba, reg, 64, "UFS_UFS_DBG_RD_PRDT_RAM ", priv);
+
+	ufshcd_writel(hba, (reg & ~UFS_BIT(17)), REG_UFS_CFG1);
+
+	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_UAWM);
+	print_fn(hba, reg, 4, "UFS_DBG_RD_REG_UAWM ", priv);
+
+	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_UARM);
+	print_fn(hba, reg, 4, "UFS_DBG_RD_REG_UARM ", priv);
+
+	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TXUC);
+	print_fn(hba, reg, 48, "UFS_DBG_RD_REG_TXUC ", priv);
+
+	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_RXUC);
+	print_fn(hba, reg, 27, "UFS_DBG_RD_REG_RXUC ", priv);
+
+	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_DFC);
+	print_fn(hba, reg, 19, "UFS_DBG_RD_REG_DFC ", priv);
+
+	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TRLUT);
+	print_fn(hba, reg, 34, "UFS_DBG_RD_REG_TRLUT ", priv);
+
+	reg = ufs_qcom_get_debug_reg_offset(host, UFS_DBG_RD_REG_TMRLUT);
+	print_fn(hba, reg, 9, "UFS_DBG_RD_REG_TMRLUT ", priv);
+}
+
+static void ufs_qcom_enable_test_bus(struct ufs_qcom_host *host)
+{
+	if (host->dbg_print_en & UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
+		ufshcd_rmwl(host->hba, TEST_BUS_EN, TEST_BUS_EN, REG_UFS_CFG1);
+	else
+		ufshcd_rmwl(host->hba, TEST_BUS_EN, 0, REG_UFS_CFG1);
+}
+
 static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host)
 {
 	/* provide a legal default configuration */
@@ -1480,6 +1579,7 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 	ufshcd_rmwl(host->hba, mask,
 		    (u32)host->testbus.select_minor << offset,
 		    reg);
+	ufs_qcom_enable_test_bus(host);
 	ufshcd_release(host->hba);
 	pm_runtime_put_sync(host->hba->dev);
 
@@ -1496,8 +1596,10 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
 	ufs_qcom_dump_regs(hba, REG_UFS_SYS1CLK_1US, 16,
 			"HCI Vendor Specific Registers ");
 
+	ufs_qcom_print_hw_debug_reg_all(hba, NULL, ufs_qcom_dump_regs_wrapper);
 	ufs_qcom_testbus_read(hba);
 }
+
 /**
  * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
  *
@@ -1542,7 +1644,7 @@ static int ufs_qcom_probe(struct platform_device *pdev)
  * ufs_qcom_remove - set driver_data of the device to NULL
  * @pdev: pointer to platform device handle
  *
- * Always return 0
+ * Always returns 0
  */
 static int ufs_qcom_remove(struct platform_device *pdev)
 {
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 36249b3..a19307a 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -241,6 +241,15 @@ struct ufs_qcom_host {
 	struct ufs_qcom_testbus testbus;
 };
 
+static inline u32
+ufs_qcom_get_debug_reg_offset(struct ufs_qcom_host *host, u32 reg)
+{
+	if (host->hw_ver.major <= 0x02)
+		return UFS_CNTLR_2_x_x_VEN_REGS_OFFSET(reg);
+
+	return UFS_CNTLR_3_x_x_VEN_REGS_OFFSET(reg);
+};
+
 #define ufs_qcom_is_link_off(hba) ufshcd_is_link_off(hba)
 #define ufs_qcom_is_link_active(hba) ufshcd_is_link_active(hba)
 #define ufs_qcom_is_link_hibern8(hba) ufshcd_is_link_hibern8(hba)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 41d9bfd..4bb6566 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -54,6 +54,7 @@
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/regulator/consumer.h>
+#include "unipro.h"
 
 #include <asm/irq.h>
 #include <asm/byteorder.h>
@@ -689,6 +690,14 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
 
 int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size);
 
+static inline bool ufshcd_is_hs_mode(struct ufs_pa_layer_attr *pwr_info)
+{
+	return (pwr_info->pwr_rx == FAST_MODE ||
+		pwr_info->pwr_rx == FASTAUTO_MODE) &&
+		(pwr_info->pwr_tx == FAST_MODE ||
+		pwr_info->pwr_tx == FASTAUTO_MODE);
+}
+
 #define ASCII_STD true
 
 int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index, u8 *buf,
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 8082020..e2854e4 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -75,6 +75,7 @@
 #define PA_MAXRXSPEEDFAST	0x1541
 #define PA_MAXRXSPEEDSLOW	0x1542
 #define PA_TXLINKSTARTUPHS	0x1544
+#define PA_LOCAL_TX_LCC_ENABLE	0x155E
 #define PA_TXSPEEDFAST		0x1565
 #define PA_TXSPEEDSLOW		0x1566
 #define PA_REMOTEVERINFO	0x15A0
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
