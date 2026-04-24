Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354202D8DB5;
	Fri, 24 Apr 2026 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777043719; cv=none; b=EfA4dXoJimMUu124+Qm+xgO2Am0srpDr7V5Op7Rl7i2PiqFuxtA9O5gM+Qkshwvb9+3kfmrVK0Gu0EE6Hw+8pBBKfLQUx7lwm8VFZgWJvPYUwwnTYrBLfyqBArYWwDqTRRsPhX3yK55Ouk8srvI39MNxaYoysUMlj2LBHtv341M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777043719; c=relaxed/simple;
	bh=bGLrb2UNJbAYTNx/vDHD9CS4yQz+QKxQ1wG+sTvEQTg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uYUtnW0aGcDriyKdJp/qCkzgH0q2tPXZS4ePfO5zaFzXQ4zsbOln8M3cqDpOlanlpIWRwBrhSB3det5r/sFgEj10QuHVpezKSjB6Ih4cATyMNygj7S5ffFCN5hsrbQ4s1Ze3Di8qAvpVKBG51uQumWQDS+3F2ig57XkyFNo87j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H0dh4rtq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H0dh4rtq"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63OD6VVs4167719;
	Fri, 24 Apr 2026 15:14:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=VuUvNNd4sSo
	4WUS4TBOY5nxYX4CrAEgoExL2Z+0O494=; b=H0dh4rtq9StGpdBhsFvb7lHOMUy
	0E0T8bMjIAv8o7RYu/arSsWEd3cyBv3eXDf7SLGHhP+MPcI/81+7ssdKzlsZGYgH
	TseTtpHlJYqTxUnJXA4Q80k+wk7C7S17rj18elF4qrwIsABdJLkLUBvrX5R3DFl9
	RiqZL7LmKdUt5lEVMM6xsxV5JLrXuhEfEGFRurCvlvUO8TK7qv/arIp6wIef3eIR
	43RvVr0P7F2RNu9+J7WIA9kpB9O8eN/O9VuS7OYUez+KciwGadMS6zD+ZozIzr81
	ETM1d0og/NxWZfssA9oLiYfL4Wul5UBe7KTxxFgJWVAygd42STGInWTdHyA==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dr48n1y7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 15:14:47 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 63OFElsN024089;
	Fri, 24 Apr 2026 15:14:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4dqnytm4ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 15:14:47 +0000 (GMT)
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63OFEk9p024084;
	Fri, 24 Apr 2026 15:14:46 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 63OFEkJH024083
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 15:14:46 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 68EB45D0; Fri, 24 Apr 2026 08:14:46 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        vamshi gajjela <vamshigajjela@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/2] scsi: ufs: core: Add support to retrieve and store TX Equalization settings
Date: Fri, 24 Apr 2026 08:14:20 -0700
Message-Id: <20260424151420.111675-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
References: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-GUID: 0Z6opkocUg7oXXckBBOutUG-KHn38f_B
X-Authority-Analysis: v=2.4 cv=VOjtWdPX c=1 sm=1 tr=0 ts=69eb88e7 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8 a=YnNmJBSnJMXklHoMRTgA:9
X-Proofpoint-ORIG-GUID: 0Z6opkocUg7oXXckBBOutUG-KHn38f_B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI0MDE0NyBTYWx0ZWRfX9ge49peA41fo
 24wFxOUBc2NtT+B2fI7DuvuV3rxFLCOOvQMt4qz7kU+AzEjPRjCauWNlh4anqg6w69mODeq8OsL
 KsERP66M/w7Hg1z7wST4FyUC/Y7n4mkVlT3cMccyXFl1Vi15bHa+zL4ry4QGJ4OYY3/VHYF2i/q
 5Onu2XDlxd412l2a8oyeFRRzeCgiULR7RQjWgrNeXHTYAD/Mey8tX8kgvCBs45QtzMTvvSf7JPc
 1Om0qhOyA/mt5rMLZ/LsF7BgtJLG6X4YqqN7ETo/oK5VQjVbcYZCW9WvS0FXDzT1Jgk17LijF0x
 E2+4GKZmPccvFEmXQO+XMquxsy+g93m/RgVpGxmCwS6G9Hh9Kp1plGqVAD5nLNBqOrK3Y58uXKm
 4H+wejzywG3i6H/CnSoVWBaf7L/wzEk2P2maKwCAUHm66VAQw+uE/kf3e2hW0mgmCnyJy/ljfM0
 FP7le+0/L9g8x77QTwQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-24_01,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604240147

Add support for UFS v5.0 JEDEC attributes qTxEQGnSettings and
wTxEQGnSettingsExt to enable persistent storage and retrieval of
optimal TX Equalization settings.

This provides a fast-path for TX Equalization by reusing previously
stored optimal settings, avoiding TX Equalization Training (EQTR)
procedures during subsequent Power Mode changes.

When no valid TX Equalization settings are found, fall back to full TX
EQTR procedures and optionally save the results for future use.

The validity of one set of TX Equalization settings is indicated by
Bit[15] in wTxEQGnSettingsExt.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-txeq.c    | 287 +++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h |   2 +
 drivers/ufs/core/ufshcd.c      |   5 +
 include/ufs/ufs.h              |   2 +
 include/ufs/ufshcd.h           |   2 +
 5 files changed, 298 insertions(+)

diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index b2dc89124353..4b264adfdf49 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -14,6 +14,9 @@
 #include <ufs/unipro.h>
 #include "ufshcd-priv.h"
 
+#define TX_EQ_SETTING_MASK		0x7
+#define TX_EQ_SETTINGS_VALID_BIT	BIT(15)
+
 static bool use_adaptive_txeq;
 module_param(use_adaptive_txeq, bool, 0644);
 MODULE_PARM_DESC(use_adaptive_txeq, "Find and apply optimal TX Equalization settings before changing Power Mode (default: false)");
@@ -40,6 +43,28 @@ static bool txeq_presets_selected[UFS_TX_EQ_PRESET_MAX] = {[0 ... (UFS_TX_EQ_PRE
 module_param_array(txeq_presets_selected, bool, NULL, 0644);
 MODULE_PARM_DESC(txeq_presets_selected, "Use only the selected Presets out of the 8 TX Equalization Presets for TX EQTR");
 
+static int txeq_setting_sel_set(const char *val, const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, 0, 1);
+}
+
+static const struct kernel_param_ops txeq_setting_sel_ops = {
+	.set = txeq_setting_sel_set,
+	.get = param_get_uint,
+};
+
+static unsigned int txeq_setting_sel;
+module_param_cb(txeq_setting_sel, &txeq_setting_sel_ops, &txeq_setting_sel, 0644);
+MODULE_PARM_DESC(txeq_setting_sel, "The qTxEQGnSettings and wTxEQGnSettingsExt Attributes selector used to retrieve and store TX Equalization settings");
+
+static bool retrieve_txeq_setting = true;
+module_param(retrieve_txeq_setting, bool, 0644);
+MODULE_PARM_DESC(retrieve_txeq_setting, "Retrieve TX Equalization settings from qTxEQGnSettings and wTxEQGnSettingsExt Attributes (default: true)");
+
+static bool store_txeq_setting = true;
+module_param(store_txeq_setting, bool, 0644);
+MODULE_PARM_DESC(store_txeq_setting, "Store the optimal TX Equalization settings to qTxEQGnSettings and wTxEQGnSettingsExt Attributes (default: true)");
+
 /*
  * ufs_tx_eq_preset - Table of minimum required list of presets.
  *
@@ -117,6 +142,126 @@ static const u32 pa_tx_eq_setting[UFS_HS_GEAR_MAX] = {
 	PA_TXEQG6SETTING
 };
 
+/*
+ * Decode Device TX Equalization PreShoot value based on qTxEQGnSettings bit assignment:
+ * bit[3:0]: Device TX Logical LANE 0 PreShoot
+ * bit[7:4]: Device TX Logical LANE 1 PreShoot
+ */
+static inline u8 tx_eq_device_preshoot_decode(u64 eq, u8 lane)
+{
+	return (u8)((eq >> (lane * TX_HS_PRESHOOT_SHIFT)) & TX_EQ_SETTING_MASK);
+}
+
+/*
+ * Decode Device TX Equalization DeEmphasis value based on qTxEQGnSettings bit assignment:
+ * bit[19:16]: Device TX Logical LANE 0 DeEmphasis
+ * bit[23:20]: Device TX Logical LANE 1 DeEmphasis
+ */
+static inline u8 tx_eq_device_deemphasis_decode(u64 eq, u8 lane)
+{
+	return (u8)((eq >> (lane * TX_HS_DEEMPHASIS_SHIFT + 16)) & TX_EQ_SETTING_MASK);
+}
+
+/*
+ * Decode Host TX Equalization PreShoot value based on qTxEQGnSettings bit assignment:
+ * bit[35:32]: Host TX Logical LANE 0 PreShoot
+ * bit[39:36]: Host TX Logical LANE 1 PreShoot
+ */
+static inline u8 tx_eq_host_preshoot_decode(u64 eq, u8 lane)
+{
+	return (u8)((eq >> (lane * TX_HS_PRESHOOT_SHIFT + 32)) & TX_EQ_SETTING_MASK);
+}
+
+/*
+ * Decode Host TX Equalization DeEmphasis value based on qTxEQGnSettings bit assignment:
+ * bit[51:48]: Host TX Logical LANE 0 DeEmphasis
+ * bit[55:52]: Host TX Logical LANE 1 DeEmphasis
+ */
+static inline u8 tx_eq_host_deemphasis_decode(u64 eq, u8 lane)
+{
+	return (u8)((eq >> (lane * TX_HS_DEEMPHASIS_SHIFT + 48)) & TX_EQ_SETTING_MASK);
+}
+
+/*
+ * Decode Device TX precode_en indication based on wTxEQGnSettingsExt bit assignment:
+ * bit[0]: PreCodeEn for Device TX Logical LANE 0
+ * bit[1]: PreCodeEn for Device TX Logical LANE 1
+ */
+static inline bool tx_eq_device_precode_en_decode(u16 eq_ext, u8 lane)
+{
+	return eq_ext & BIT(lane);
+}
+
+/*
+ * Decode Host TX precode_en indication based on wTxEQGnSettingsExt bit assignment:
+ * bit[4]: PreCodeEn for Device RX Logical LANE 0
+ * bit[5]: PreCodeEn for Device RX Logical LANE 1
+ */
+static inline bool tx_eq_host_precode_en_decode(u16 eq_ext, u8 lane)
+{
+	return eq_ext & BIT(lane + 4);
+}
+
+/*
+ * Encode Device TX Equalization PreShoot value based on qTxEQGnSettings bit assignment:
+ * bit[3:0]: Device TX Logical LANE 0 PreShoot
+ * bit[7:4]: Device TX Logical LANE 1 PreShoot
+ */
+static inline u64 tx_eq_device_preshoot_encode(u64 val, u8 lane)
+{
+	return (val & TX_EQ_SETTING_MASK) << (lane * TX_HS_PRESHOOT_SHIFT);
+}
+
+/*
+ * Encode Device TX Equalization DeEmphasis value based on qTxEQGnSettings bit assignment:
+ * bit[19:16]: Device TX Logical LANE 0 DeEmphasis
+ * bit[23:20]: Device TX Logical LANE 1 DeEmphasis
+ */
+static inline u64 tx_eq_device_deemphasis_encode(u64 val, u8 lane)
+{
+	return (val & TX_EQ_SETTING_MASK) << (lane * TX_HS_DEEMPHASIS_SHIFT + 16);
+}
+
+/*
+ * Encode Host TX Equalization PreShoot value based on qTxEQGnSettings bit assignment:
+ * bit[35:32]: Host TX Logical LANE 0 PreShoot
+ * bit[39:36]: Host TX Logical LANE 1 PreShoot
+ */
+static inline u64 tx_eq_host_preshoot_encode(u64 val, u8 lane)
+{
+	return (val & TX_EQ_SETTING_MASK) << (lane * TX_HS_PRESHOOT_SHIFT + 32);
+}
+
+/*
+ * Encode Host TX Equalization DeEmphasis value based on qTxEQGnSettings bit assignment:
+ * bit[51:48]: Host TX Logical LANE 0 DeEmphasis
+ * bit[55:52]: Host TX Logical LANE 1 DeEmphasis
+ */
+static inline u64 tx_eq_host_deemphasis_encode(u64 val, u8 lane)
+{
+	return (val & TX_EQ_SETTING_MASK) << (lane * TX_HS_DEEMPHASIS_SHIFT + 48);
+}
+
+/*
+ * Encode Device precode_en based on wTxEQGnSettingsExt bit assignment:
+ * bit[0]: PreCodeEn for Device TX Logical LANE 0
+ * bit[1]: PreCodeEn for Device TX Logical LANE 1
+ */
+static inline u16 tx_eq_device_precode_en_encode(bool en, u8 lane)
+{
+	return (u16)en << lane;
+}
+
+/*
+ * Encode Host precode_en based on wTxEQGnSettingsExt bit assignment:
+ * bit[4]: PreCodeEn for Device RX Logical LANE 0
+ * bit[5]: PreCodeEn for Device RX Logical LANE 1
+ */
+static inline u16 tx_eq_host_precode_en_encode(bool en, u8 lane)
+{
+	return (u16)en << (lane + 4);
+}
+
 /**
  * ufshcd_configure_precoding - Configure Pre-Coding for all active lanes
  * @hba: per adapter instance
@@ -1164,6 +1309,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 
 		/* Mark TX Equalization settings as valid */
 		params->is_valid = true;
+		params->is_trained = true;
 		params->is_applied = false;
 	}
 
@@ -1291,3 +1437,144 @@ int ufshcd_retrain_tx_eq(struct ufs_hba *hba, u32 gear)
 
 	return ret;
 }
+
+/**
+ * ufshcd_extract_tx_eq_settings_attrs - Extract TX Equalization settings from UFS attributes
+ * @hba: per adapter instance
+ * @gear: target gear
+ *
+ * This function extracts previously stored TX Equalization settings from UFS
+ * attributes qTxEQGnSettings and wTxEQGnSettingsExt. These attributes contain
+ * the optimal TX Equalization parameters (PreShoot, DeEmphasis, and PreCoding
+ * enable) that were determined during a previous EQTR procedure.
+ *
+ * The function reads:
+ * 1. qTxEQGnSettings (64-bit): Main attribute containing PreShoot and
+ *    DeEmphasis values for both host and device TX lanes
+ * 2. wTxEQGnSettingsExt (16-bit): Extended attribute containing PreCoding
+ *    enable flags and validity indicator
+ */
+static void ufshcd_extract_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
+{
+	struct ufshcd_tx_eq_params *params;
+	u32 lane, eq_ext;
+	int ret;
+	u64 eq;
+
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				QUERY_ATTR_IDN_TX_EQ_GN_SETTINGS_EXT, gear - 1,
+				(u8)txeq_setting_sel, &eq_ext);
+	if (ret)
+		return;
+
+	dev_dbg(hba->dev, "%s: HS-G%u wTxEQGnSettingsExt (Selector %u) = 0x%08x\n",
+		__func__, gear, txeq_setting_sel, eq_ext);
+
+	if (!(eq_ext & TX_EQ_SETTINGS_VALID_BIT))
+		return;
+
+	ret = ufshcd_query_attr_qword(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				      QUERY_ATTR_IDN_TX_EQ_GN_SETTINGS,
+				      gear - 1, (u8)txeq_setting_sel, &eq);
+	if (ret)
+		return;
+
+	dev_dbg(hba->dev, "%s: HS-G%u qTxEQGnSettings (Selector %u) = 0x%016llx\n",
+		__func__, gear, txeq_setting_sel, eq);
+
+	params = &hba->tx_eq_params[gear - 1];
+
+	for (lane = 0; lane < UFS_MAX_LANES; lane++) {
+		params->host[lane].preshoot = tx_eq_host_preshoot_decode(eq, lane);
+		params->host[lane].deemphasis = tx_eq_host_deemphasis_decode(eq, lane);
+		params->host[lane].precode_en = tx_eq_host_precode_en_decode(eq_ext, lane);
+
+		params->device[lane].preshoot = tx_eq_device_preshoot_decode(eq, lane);
+		params->device[lane].deemphasis = tx_eq_device_deemphasis_decode(eq, lane);
+		params->device[lane].precode_en = tx_eq_device_precode_en_decode(eq_ext, lane);
+	}
+
+	params->is_valid = true;
+}
+
+void ufshcd_retrieve_tx_eq_settings(struct ufs_hba *hba)
+{
+	u8 gear = (u8)adaptive_txeq_gear;
+
+	if (!hba->max_pwr_info.is_valid || !ufshcd_is_tx_eq_supported(hba) ||
+	    !use_adaptive_txeq || !retrieve_txeq_setting)
+		return;
+
+	for (; gear <= UFS_HS_GEAR_MAX; gear++)
+		ufshcd_extract_tx_eq_settings_attrs(hba, gear);
+}
+
+/**
+ * ufshcd_update_tx_eq_settings_attrs - Update TX EQ settings in UFS attributes
+ * @hba: per adapter instance
+ * @gear: target gear
+ *
+ * This function stores the optimal TX Equalization settings obtained from
+ * TX EQTR procedure into UFS device attributes for future fast-path retrieval.
+ * The settings are stored in two complementary attributes:
+ *
+ * 1. qTxEQGnSettings (64-bit): Main attribute containing PreShoot and
+ *    DeEmphasis values for both host and device TX lanes
+ * 2. wTxEQGnSettingsExt (16-bit): Extended attribute containing PreCoding
+ *    enable flags and validity indicator
+ */
+static void ufshcd_update_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
+{
+	struct ufshcd_tx_eq_params *params;
+	u32 lane, eq_ext = 0;
+	u64 eq = 0;
+	int ret;
+
+	params = &hba->tx_eq_params[gear - 1];
+	if (!params->is_valid || !params->is_trained)
+		return;
+
+	for (lane = 0; lane < UFS_MAX_LANES; lane++) {
+		eq |= tx_eq_host_preshoot_encode((u64)params->host[lane].preshoot, lane);
+		eq |= tx_eq_host_deemphasis_encode((u64)params->host[lane].deemphasis, lane);
+		eq_ext |= tx_eq_host_precode_en_encode(params->host[lane].precode_en, lane);
+
+		eq |= tx_eq_device_preshoot_encode((u64)params->device[lane].preshoot, lane);
+		eq |= tx_eq_device_deemphasis_encode((u64)params->device[lane].deemphasis, lane);
+		eq_ext |= tx_eq_device_precode_en_encode(params->device[lane].precode_en, lane);
+	}
+
+	/* Set validity flag to indicate valid settings are stored */
+	eq_ext |= TX_EQ_SETTINGS_VALID_BIT;
+
+	/* Write qTxEQGnSettings */
+	ret = ufshcd_query_attr_qword(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				      QUERY_ATTR_IDN_TX_EQ_GN_SETTINGS,
+				      gear - 1, (u8)txeq_setting_sel, &eq);
+	if (ret)
+		return;
+
+	/* Write wTxEQGnSettingsExt */
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				QUERY_ATTR_IDN_TX_EQ_GN_SETTINGS_EXT, gear - 1,
+				(u8)txeq_setting_sel, &eq_ext);
+	if (ret)
+		return;
+
+	dev_dbg(hba->dev, "%s: Saved HS-G%u qTxEQGnSettings (Selector %u) = 0x%016llx\n",
+		__func__, gear, txeq_setting_sel, eq);
+	dev_dbg(hba->dev, "%s: Saved HS-G%u wTxEQGnSettingsExt (Selector %u) = 0x%08x\n",
+		__func__, gear, txeq_setting_sel, eq_ext);
+}
+
+void ufshcd_store_tx_eq_settings(struct ufs_hba *hba)
+{
+	u8 gear = (u8)adaptive_txeq_gear;
+
+	if (!hba->max_pwr_info.is_valid || !ufshcd_is_tx_eq_supported(hba) ||
+	    !use_adaptive_txeq || !store_txeq_setting)
+		return;
+
+	for (; gear <= UFS_HS_GEAR_MAX; gear++)
+		ufshcd_update_tx_eq_settings_attrs(hba, gear);
+}
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index ed1adeb22ec6..70f90d97f217 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -118,6 +118,8 @@ void ufshcd_print_tx_eq_params(struct ufs_hba *hba);
 bool ufshcd_is_txeq_presets_used(struct ufs_hba *hba);
 bool ufshcd_is_txeq_preset_selected(u8 preshoot, u8 deemphasis);
 int ufshcd_retrain_tx_eq(struct ufs_hba *hba, u32 gear);
+void ufshcd_retrieve_tx_eq_settings(struct ufs_hba *hba);
+void ufshcd_store_tx_eq_settings(struct ufs_hba *hba);
 
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c92e0409c793..a6026cc4b2f4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9128,6 +9128,8 @@ static int ufshcd_device_params_init(struct ufs_hba *hba)
 		dev_err(hba->dev,
 			"%s: Failed getting max supported power mode\n",
 			__func__);
+
+	ufshcd_retrieve_tx_eq_settings(hba);
 out:
 	return ret;
 }
@@ -10748,6 +10750,9 @@ static void ufshcd_wl_shutdown(struct scsi_device *sdev)
 
 	/* Turn on everything while shutting down */
 	ufshcd_rpm_get_sync(hba);
+
+	ufshcd_store_tx_eq_settings(hba);
+
 	scsi_device_quiesce(sdev);
 	shost_for_each_device(sdev, hba->host) {
 		if (sdev == hba->ufs_device_wlun)
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 602aa34c9822..0d48e137d66d 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -191,6 +191,8 @@ enum attr_idn {
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
+	QUERY_ATTR_IDN_TX_EQ_GN_SETTINGS        = 0x47,
+	QUERY_ATTR_IDN_TX_EQ_GN_SETTINGS_EXT    = 0x48,
 };
 
 /* Descriptor idn for Query requests */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cfbc75d8df83..f48d6416e299 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -358,6 +358,7 @@ struct ufshcd_tx_eqtr_record {
  * @eqtr_record: Pointer to TX EQTR record
  * @is_valid: True if parameter contains valid TX Equalization settings
  * @is_applied: True if settings have been applied to UniPro of both sides
+ * @is_trained: True if parameters obtained from TX EQTR procedure
  */
 struct ufshcd_tx_eq_params {
 	struct ufshcd_tx_eq_settings host[UFS_MAX_LANES];
@@ -365,6 +366,7 @@ struct ufshcd_tx_eq_params {
 	struct ufshcd_tx_eqtr_record *eqtr_record;
 	bool is_valid;
 	bool is_applied;
+	bool is_trained;
 };
 
 /**
-- 
2.34.1

