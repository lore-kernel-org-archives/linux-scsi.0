From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v6 12/17] scsi: ufs: tune UniPro parameters to optimize hibern8 exit time
Date: Sun,  6 Mar 2016 13:55:53 +0200
Message-ID: <1457265358-31635-13-git-send-email-ygardi@codeaurora.org>
References: <1457265358-31635-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1457265358-31635-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Optimal values of local UniPro parameters like PA_Hibern8Time &
PA_TActivate can help reduce the hibern8 exit latency. If both host and
device supports UniPro ver1.6 or later, these parameters will be
automatically tuned during link startup itself. But if either host or
device doesn't support UniPro ver 1.6 or later, we have to manually
tune them. But to keep manual tuning logic simple, we will only do
manual tuning if local unipro version doesn't support ver1.6 or later.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h |   1 +
 drivers/scsi/ufs/ufshci.h |   2 +
 drivers/scsi/ufs/unipro.h |  21 +++++++++
 4 files changed, 142 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d28c629..c9c4d68 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -570,6 +570,34 @@ static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
 	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
 }
 
+u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba)
+{
+	/* HCI version 1.0 and 1.1 supports UniPro 1.41 */
+	if ((hba->ufs_version == UFSHCI_VERSION_10) ||
+	    (hba->ufs_version == UFSHCI_VERSION_11))
+		return UFS_UNIPRO_VER_1_41;
+	else
+		return UFS_UNIPRO_VER_1_6;
+}
+EXPORT_SYMBOL(ufshcd_get_local_unipro_ver);
+
+static bool ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
+{
+	/*
+	 * If both host and device support UniPro ver1.6 or later, PA layer
+	 * parameters tuning happens during link startup itself.
+	 *
+	 * We can manually tune PA layer parameters if either host or device
+	 * doesn't support UniPro ver 1.6 or later. But to keep manual tuning
+	 * logic simple, we will only do manual tuning if local unipro version
+	 * doesn't support ver1.6 or later.
+	 */
+	if (ufshcd_get_local_unipro_ver(hba) < UFS_UNIPRO_VER_1_6)
+		return true;
+	else
+		return false;
+}
+
 static void ufshcd_ungate_work(struct work_struct *work)
 {
 	int ret;
@@ -4783,6 +4811,95 @@ out:
 }
 
 /**
+ * ufshcd_tune_pa_tactivate - Tunes PA_TActivate of local UniPro
+ * @hba: per-adapter instance
+ *
+ * PA_TActivate parameter can be tuned manually if UniPro version is less than
+ * 1.61. PA_TActivate needs to be greater than or equal to peerM-PHY's
+ * RX_MIN_ACTIVATETIME_CAPABILITY attribute. This optimal value can help reduce
+ * the hibern8 exit latency.
+ *
+ * Returns zero on success, non-zero error value on failure.
+ */
+static int ufshcd_tune_pa_tactivate(struct ufs_hba *hba)
+{
+	int ret = 0;
+	u32 peer_rx_min_activatetime = 0, tuned_pa_tactivate;
+
+	ret = ufshcd_dme_peer_get(hba,
+				  UIC_ARG_MIB_SEL(
+					RX_MIN_ACTIVATETIME_CAPABILITY,
+					UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)),
+				  &peer_rx_min_activatetime);
+	if (ret)
+		goto out;
+
+	/* make sure proper unit conversion is applied */
+	tuned_pa_tactivate =
+		((peer_rx_min_activatetime * RX_MIN_ACTIVATETIME_UNIT_US)
+		 / PA_TACTIVATE_TIME_UNIT_US);
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE),
+			     tuned_pa_tactivate);
+
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_tune_pa_hibern8time - Tunes PA_Hibern8Time of local UniPro
+ * @hba: per-adapter instance
+ *
+ * PA_Hibern8Time parameter can be tuned manually if UniPro version is less than
+ * 1.61. PA_Hibern8Time needs to be maximum of local M-PHY's
+ * TX_HIBERN8TIME_CAPABILITY & peer M-PHY's RX_HIBERN8TIME_CAPABILITY.
+ * This optimal value can help reduce the hibern8 exit latency.
+ *
+ * Returns zero on success, non-zero error value on failure.
+ */
+static int ufshcd_tune_pa_hibern8time(struct ufs_hba *hba)
+{
+	int ret = 0;
+	u32 local_tx_hibern8_time_cap = 0, peer_rx_hibern8_time_cap = 0;
+	u32 max_hibern8_time, tuned_pa_hibern8time;
+
+	ret = ufshcd_dme_get(hba,
+			     UIC_ARG_MIB_SEL(TX_HIBERN8TIME_CAPABILITY,
+					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
+				  &local_tx_hibern8_time_cap);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_get(hba,
+				  UIC_ARG_MIB_SEL(RX_HIBERN8TIME_CAPABILITY,
+					UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)),
+				  &peer_rx_hibern8_time_cap);
+	if (ret)
+		goto out;
+
+	max_hibern8_time = max(local_tx_hibern8_time_cap,
+			       peer_rx_hibern8_time_cap);
+	/* make sure proper unit conversion is applied */
+	tuned_pa_hibern8time = ((max_hibern8_time * HIBERN8TIME_UNIT_US)
+				/ PA_HIBERN8_TIME_UNIT_US);
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HIBERN8TIME),
+			     tuned_pa_hibern8time);
+out:
+	return ret;
+}
+
+static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
+{
+	if (ufshcd_is_unipro_pa_params_tuning_req(hba)) {
+		ufshcd_tune_pa_tactivate(hba);
+		ufshcd_tune_pa_hibern8time(hba);
+	}
+
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_PA_TACTIVATE)
+		/* set 1ms timeout for PA_TACTIVATE */
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 10);
+}
+
+/**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
  *
@@ -4814,6 +4931,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		goto out;
 
 	ufs_advertise_fixup_device(hba);
+	ufshcd_tune_unipro_params(hba);
 
 	ret = ufshcd_set_vccq_rail_unused(hba,
 		(hba->dev_quirks & UFS_DEVICE_NO_VCCQ) ? true : false);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 65f29aa..41d9bfd 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -699,6 +699,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
+u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba);
 
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 2b05bfb..4cb1cc6 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -92,6 +92,7 @@ enum {
 	UFSHCI_VERSION_10 = 0x00010000, /* 1.0 */
 	UFSHCI_VERSION_11 = 0x00010100, /* 1.1 */
 	UFSHCI_VERSION_20 = 0x00000200, /* 2.0 */
+	UFSHCI_VERSION_21 = 0x00000210, /* 2.1 */
 };
 
 /*
@@ -211,6 +212,7 @@ enum {
 
 /* GenSelectorIndex calculation macros for M-PHY attributes */
 #define UIC_ARG_MPHY_TX_GEN_SEL_INDEX(lane) (lane)
+#define UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane) (PA_MAXDATALANES + (lane))
 
 #define UIC_ARG_MIB_SEL(attr, sel)	((((attr) & 0xFFFF) << 16) |\
 					 ((sel) & 0xFFFF))
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 816a8a4..8082020 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -15,6 +15,7 @@
 /*
  * M-TX Configuration Attributes
  */
+#define TX_HIBERN8TIME_CAPABILITY		0x000F
 #define TX_MODE					0x0021
 #define TX_HSRATE_SERIES			0x0022
 #define TX_HSGEAR				0x0023
@@ -48,8 +49,12 @@
 #define RX_ENTER_HIBERN8			0x00A7
 #define RX_BYPASS_8B10B_ENABLE			0x00A8
 #define RX_TERMINATION_FORCE_ENABLE		0x0089
+#define RX_MIN_ACTIVATETIME_CAPABILITY		0x008F
+#define RX_HIBERN8TIME_CAPABILITY		0x0092
 
 #define is_mphy_tx_attr(attr)			(attr < RX_MODE)
+#define RX_MIN_ACTIVATETIME_UNIT_US		100
+#define HIBERN8TIME_UNIT_US			100
 /*
  * PHY Adpater attributes
  */
@@ -110,6 +115,12 @@
 #define PA_STALLNOCONFIGTIME	0x15A3
 #define PA_SAVECONFIGTIME	0x15A4
 
+#define PA_TACTIVATE_TIME_UNIT_US	10
+#define PA_HIBERN8_TIME_UNIT_US		100
+
+/* PHY Adapter Protocol Constants */
+#define PA_MAXDATALANES	4
+
 /* PA power modes */
 enum {
 	FAST_MODE	= 1,
@@ -143,6 +154,16 @@ enum ufs_hs_gear_tag {
 	UFS_HS_G3,		/* HS Gear 3 */
 };
 
+enum ufs_unipro_ver {
+	UFS_UNIPRO_VER_RESERVED = 0,
+	UFS_UNIPRO_VER_1_40 = 1, /* UniPro version 1.40 */
+	UFS_UNIPRO_VER_1_41 = 2, /* UniPro version 1.41 */
+	UFS_UNIPRO_VER_1_6 = 3,  /* UniPro version 1.6 */
+	UFS_UNIPRO_VER_MAX = 4,  /* UniPro unsupported version */
+	/* UniPro version field mask in PA_LOCALVERINFO */
+	UFS_UNIPRO_VER_MASK = 0xF,
+};
+
 /*
  * Data Link Layer Attributes
  */
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
