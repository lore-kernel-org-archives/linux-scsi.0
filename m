From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v8 7/8] scsi: ufs-qcom: add debug prints for test bus
Date: Sun, 25 Oct 2015 12:50:49 +0200
Message-ID: <1445770250-28802-8-git-send-email-ygardi@codeaurora.org>
References: <1445770250-28802-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445770250-28802-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Adds support for configuring and reading the test bus and debug
registers. This change also adds another vops in order to print the
debug registers.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 165 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufs-qcom.h |  37 +++++++++-
 drivers/scsi/ufs/ufshcd.c   |   2 +
 drivers/scsi/ufs/ufshcd.h   |   8 +++
 4 files changed, 208 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index b275a9a..1633808 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -23,6 +23,24 @@
 #include "unipro.h"
 #include "ufs-qcom.h"
 #include "ufshci.h"
+#define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
+	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
+
+enum {
+	TSTBUS_UAWM,
+	TSTBUS_UARM,
+	TSTBUS_TXUC,
+	TSTBUS_RXUC,
+	TSTBUS_DFC,
+	TSTBUS_TRLUT,
+	TSTBUS_TMRLUT,
+	TSTBUS_OCSC,
+	TSTBUS_UTP_HCI,
+	TSTBUS_COMBINED,
+	TSTBUS_WRAPPER,
+	TSTBUS_UNIPRO,
+	TSTBUS_MAX,
+};
 
 static struct ufs_qcom_host *ufs_qcom_hosts[MAX_UFS_QCOM_HOSTS];
 
@@ -30,6 +48,15 @@ static void ufs_qcom_get_speed_mode(struct ufs_pa_layer_attr *p, char *result);
 static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
 		const char *speed_mode);
 static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote);
+static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
+static void ufs_qcom_dump_regs(struct ufs_hba *hba, int offset, int len,
+		char *prefix)
+{
+	print_hex_dump(KERN_ERR, prefix,
+			len > 4 ? DUMP_PREFIX_OFFSET : DUMP_PREFIX_NONE,
+			16, 4, (void __force *)hba->mmio_base + offset,
+			len * 4, false);
+}
 
 static int ufs_qcom_get_connected_tx_lanes(struct ufs_hba *hba, u32 *tx_lanes)
 {
@@ -996,6 +1023,15 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	if (hba->dev->id < MAX_UFS_QCOM_HOSTS)
 		ufs_qcom_hosts[hba->dev->id] = host;
 
+	host->dbg_print_en |= UFS_QCOM_DEFAULT_DBG_PRINT_EN;
+	ufs_qcom_get_default_testbus_cfg(host);
+	err = ufs_qcom_testbus_config(host);
+	if (err) {
+		dev_warn(dev, "%s: failed to configure the testbus %d\n",
+				__func__, err);
+		err = 0;
+	}
+
 	goto out;
 
 out_disable_phy:
@@ -1025,12 +1061,134 @@ void ufs_qcom_clk_scale_notify(struct ufs_hba *hba)
 
 	if (!dev_req_params)
 		return;
+}
+
+static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host)
+{
+	/* provide a legal default configuration */
+	host->testbus.select_major = TSTBUS_UAWM;
+	host->testbus.select_minor = 1;
+}
+
+static bool ufs_qcom_testbus_cfg_is_ok(struct ufs_qcom_host *host)
+{
+	if (host->testbus.select_major >= TSTBUS_MAX) {
+		dev_err(host->hba->dev,
+			"%s: UFS_CFG1[TEST_BUS_SEL} may not equal 0x%05X\n",
+			__func__, host->testbus.select_major);
+		return false;
+	}
+
+	/*
+	 * Not performing check for each individual select_major
+	 * mappings of select_minor, since there is no harm in
+	 * configuring a non-existent select_minor
+	 */
+	if (host->testbus.select_minor > 0x1F) {
+		dev_err(host->hba->dev,
+			"%s: 0x%05X is not a legal testbus option\n",
+			__func__, host->testbus.select_minor);
+		return false;
+	}
+
+	return true;
+}
+
+int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
+{
+	int reg;
+	int offset;
+	u32 mask = TEST_BUS_SUB_SEL_MASK;
+
+	if (!host)
+		return -EINVAL;
 
-	ufs_qcom_cfg_timers(hba, dev_req_params->gear_rx,
-				dev_req_params->pwr_rx,
-				dev_req_params->hs_rate);
+	if (!ufs_qcom_testbus_cfg_is_ok(host))
+		return -EPERM;
+
+	switch (host->testbus.select_major) {
+	case TSTBUS_UAWM:
+		reg = UFS_TEST_BUS_CTRL_0;
+		offset = 24;
+		break;
+	case TSTBUS_UARM:
+		reg = UFS_TEST_BUS_CTRL_0;
+		offset = 16;
+		break;
+	case TSTBUS_TXUC:
+		reg = UFS_TEST_BUS_CTRL_0;
+		offset = 8;
+		break;
+	case TSTBUS_RXUC:
+		reg = UFS_TEST_BUS_CTRL_0;
+		offset = 0;
+		break;
+	case TSTBUS_DFC:
+		reg = UFS_TEST_BUS_CTRL_1;
+		offset = 24;
+		break;
+	case TSTBUS_TRLUT:
+		reg = UFS_TEST_BUS_CTRL_1;
+		offset = 16;
+		break;
+	case TSTBUS_TMRLUT:
+		reg = UFS_TEST_BUS_CTRL_1;
+		offset = 8;
+		break;
+	case TSTBUS_OCSC:
+		reg = UFS_TEST_BUS_CTRL_1;
+		offset = 0;
+		break;
+	case TSTBUS_WRAPPER:
+		reg = UFS_TEST_BUS_CTRL_2;
+		offset = 16;
+		break;
+	case TSTBUS_COMBINED:
+		reg = UFS_TEST_BUS_CTRL_2;
+		offset = 8;
+		break;
+	case TSTBUS_UTP_HCI:
+		reg = UFS_TEST_BUS_CTRL_2;
+		offset = 0;
+		break;
+	case TSTBUS_UNIPRO:
+		reg = UFS_UNIPRO_CFG;
+		offset = 1;
+		break;
+	/*
+	 * No need for a default case, since
+	 * ufs_qcom_testbus_cfg_is_ok() checks that the configuration
+	 * is legal
+	 */
+	}
+	mask <<= offset;
+
+	pm_runtime_get_sync(host->hba->dev);
+	ufshcd_hold(host->hba, false);
+	ufshcd_rmwl(host->hba, TEST_BUS_SEL,
+		    (u32)host->testbus.select_major << 19,
+		    REG_UFS_CFG1);
+	ufshcd_rmwl(host->hba, mask,
+		    (u32)host->testbus.select_minor << offset,
+		    reg);
+	ufshcd_release(host->hba);
+	pm_runtime_put_sync(host->hba->dev);
+
+	return 0;
 }
 
+static void ufs_qcom_testbus_read(struct ufs_hba *hba)
+{
+	ufs_qcom_dump_regs(hba, UFS_TEST_BUS, 1, "UFS_TEST_BUS ");
+}
+
+static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
+{
+	ufs_qcom_dump_regs(hba, REG_UFS_SYS1CLK_1US, 16,
+			"HCI Vendor Specific Registers ");
+
+	ufs_qcom_testbus_read(hba);
+}
 /**
  * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
  *
@@ -1049,6 +1207,7 @@ static struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.pwr_change_notify	= ufs_qcom_pwr_change_notify,
 	.suspend		= ufs_qcom_suspend,
 	.resume			= ufs_qcom_resume,
+	.dbg_register_dump	= ufs_qcom_dump_dbg_regs,
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index db2c0a0..1b71a1b 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -58,6 +58,16 @@ enum {
 	REG_UFS_CFG2                        = 0xE0,
 	REG_UFS_HW_VERSION                  = 0xE4,
 
+	UFS_TEST_BUS				= 0xE8,
+	UFS_TEST_BUS_CTRL_0			= 0xEC,
+	UFS_TEST_BUS_CTRL_1			= 0xF0,
+	UFS_TEST_BUS_CTRL_2			= 0xF4,
+	UFS_UNIPRO_CFG				= 0xF8,
+
+};
+
+/* QCOM UFS host controller vendor specific debug registers */
+enum {
 	UFS_DBG_RD_REG_UAWM			= 0x100,
 	UFS_DBG_RD_REG_UARM			= 0x200,
 	UFS_DBG_RD_REG_TXUC			= 0x300,
@@ -73,6 +83,9 @@ enum {
 	UFS_UFS_DBG_RD_EDTL_RAM			= 0x1900,
 };
 
+#define TEST_BUS_EN		BIT(18)
+#define TEST_BUS_SEL		GENMASK(22, 19)
+
 /* bit definitions for REG_UFS_CFG2 register */
 #define UAWM_HW_CGC_EN		(1 << 0)
 #define UARM_HW_CGC_EN		(1 << 1)
@@ -83,6 +96,9 @@ enum {
 #define TMRLUT_HW_CGC_EN	(1 << 6)
 #define OCSC_HW_CGC_EN		(1 << 7)
 
+/* bit definition for UFS_UFS_TEST_BUS_CTRL_n */
+#define TEST_BUS_SUB_SEL_MASK	0x1F  /* All XXX_SEL fields are 5 bits wide */
+
 #define REG_UFS_CFG2_CGC_EN_ALL (UAWM_HW_CGC_EN | UARM_HW_CGC_EN |\
 				 TXUC_HW_CGC_EN | RXUC_HW_CGC_EN |\
 				 DFC_HW_CGC_EN | TRLUT_HW_CGC_EN |\
@@ -106,6 +122,15 @@ enum ufs_qcom_phy_init_type {
 	UFS_PHY_INIT_CFG_RESTORE,
 };
 
+/* QCOM UFS debug print bit mask */
+#define UFS_QCOM_DBG_PRINT_REGS_EN	BIT(0)
+#define UFS_QCOM_DBG_PRINT_ICE_REGS_EN	BIT(1)
+#define UFS_QCOM_DBG_PRINT_TEST_BUS_EN	BIT(2)
+
+#define UFS_QCOM_DBG_PRINT_ALL	\
+	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_ICE_REGS_EN | \
+	 UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
+
 static inline void
 ufs_qcom_get_controller_revision(struct ufs_hba *hba,
 				 u8 *major, u16 *minor, u16 *step)
@@ -157,8 +182,13 @@ struct ufs_hw_version {
 	u16 minor;
 	u8 major;
 };
-struct ufs_qcom_host {
 
+struct ufs_qcom_testbus {
+	u8 select_major;
+	u8 select_minor;
+};
+
+struct ufs_qcom_host {
 	/*
 	 * Set this capability if host controller supports the QUniPro mode
 	 * and if driver wants the Host controller to operate in QUniPro mode.
@@ -179,12 +209,17 @@ struct ufs_qcom_host {
 	bool is_lane_clks_enabled;
 
 	struct ufs_hw_version hw_ver;
+	/* Bitmask for enabling debug prints */
+	u32 dbg_print_en;
+	struct ufs_qcom_testbus testbus;
 };
 
 #define ufs_qcom_is_link_off(hba) ufshcd_is_link_off(hba)
 #define ufs_qcom_is_link_active(hba) ufshcd_is_link_active(hba)
 #define ufs_qcom_is_link_hibern8(hba) ufshcd_is_link_hibern8(hba)
 
+int ufs_qcom_testbus_config(struct ufs_qcom_host *host);
+
 static inline bool ufs_qcom_cap_qunipro(struct ufs_qcom_host *host)
 {
 	if (host->caps & UFS_QCOM_CAP_QUNIPRO)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2ef9834..52f9dad 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -625,6 +625,7 @@ start:
 out:
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ufshcd_hold);
 
 static void ufshcd_gate_work(struct work_struct *work)
 {
@@ -712,6 +713,7 @@ void ufshcd_release(struct ufs_hba *hba)
 	__ufshcd_release(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
+EXPORT_SYMBOL_GPL(ufshcd_release);
 
 static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f2aa47e..471c667 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -259,6 +259,7 @@ struct ufs_pwr_mode_info {
  *			to be set.
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
+ * @dbg_register_dump: used to dump controller debug information
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -275,6 +276,7 @@ struct ufs_hba_variant_ops {
 					struct ufs_pa_layer_attr *);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
+	void	(*dbg_register_dump)(struct ufs_hba *hba);
 };
 
 /* clock gating state  */
@@ -773,4 +775,10 @@ static inline int ufshcd_vops_resume(struct ufs_hba *hba, enum ufs_pm_op op)
 	return 0;
 }
 
+static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->dbg_register_dump)
+		hba->vops->dbg_register_dump(hba);
+}
+
 #endif /* End of Header */
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
