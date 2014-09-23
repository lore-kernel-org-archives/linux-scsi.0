From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH/RESEND V4 08/17] scsi: ufs: Active Power Mode - configuring bActiveICCLevel
Date: Tue, 23 Sep 2014 10:31:30 +0300
Message-ID: <1411457499-8074-9-git-send-email-draviv@codeaurora.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:40370 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbaIWHcV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2014 03:32:21 -0400
In-Reply-To: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Yaniv Gardi <ygardi@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Yaniv Gardi <ygardi@codeaurora.org>

The maximum power consumption in active is determined by bActiveICCLevel.
The configuration is done by reading max current supported by the
regulators connected to VCC, VCCQ and VCCQ2 rails on the boards, and
reading the current consumption levels from the device for each rails
(vcc/vccq/vccq2) using power descriptor.
We configure the bActiveICCLevel attribute, with the max value that
correspond to the minimum-of(VCC-current-level,VCCQ-current-level,
VCCQ2-current-level).
In order to minimize resume latency, pre-fetch icc levels and reference
clock during initialization and avoid reading them each link startup
during resume.

Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index f76a304..4ca99ed 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -115,6 +115,7 @@ enum flag_idn {
 
 /* Attribute idn for Query requests */
 enum attr_idn {
+	QUERY_ATTR_IDN_ACTIVE_ICC_LVL	= 0x03,
 	QUERY_ATTR_IDN_BKOPS_STATUS	= 0x05,
 	QUERY_ATTR_IDN_EE_CONTROL	= 0x0D,
 	QUERY_ATTR_IDN_EE_STATUS	= 0x0E,
@@ -174,6 +175,31 @@ enum unit_desc_param {
 	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
 };
 
+/* bActiveICCLevel parameter current units */
+enum {
+	UFSHCD_NANO_AMP		= 0,
+	UFSHCD_MICRO_AMP	= 1,
+	UFSHCD_MILI_AMP		= 2,
+	UFSHCD_AMP		= 3,
+};
+
+#define POWER_DESC_MAX_SIZE			0x62
+#define POWER_DESC_MAX_ACTV_ICC_LVLS		16
+
+/* Attribute  bActiveICCLevel parameter bit masks definitions */
+#define ATTR_ICC_LVL_UNIT_OFFSET	14
+#define ATTR_ICC_LVL_UNIT_MASK		(0x3 << ATTR_ICC_LVL_UNIT_OFFSET)
+#define ATTR_ICC_LVL_VALUE_MASK		0x3FF
+
+/* Power descriptor parameters offsets in bytes */
+enum power_desc_param_offset {
+	PWR_DESC_LEN			= 0x0,
+	PWR_DESC_TYPE			= 0x1,
+	PWR_DESC_ACTIVE_LVLS_VCC_0	= 0x2,
+	PWR_DESC_ACTIVE_LVLS_VCCQ_0	= 0x22,
+	PWR_DESC_ACTIVE_LVLS_VCCQ2_0	= 0x42,
+};
+
 /* Exception event mask values */
 enum {
 	MASK_EE_STATUS		= 0xFFFF,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index af29d4c..dc89c48 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3265,6 +3265,125 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 }
 
 /**
+ * ufshcd_get_max_icc_level - calculate the ICC level
+ * @sup_curr_uA: max. current supported by the regulator
+ * @start_scan: row at the desc table to start scan from
+ * @buff: power descriptor buffer
+ *
+ * Returns calculated max ICC level for specific regulator
+ */
+static u32 ufshcd_get_max_icc_level(int sup_curr_uA, u32 start_scan, char *buff)
+{
+	int i;
+	int curr_uA;
+	u16 data;
+	u16 unit;
+
+	for (i = start_scan; i >= 0; i--) {
+		data = be16_to_cpu(*((u16 *)(buff + 2*i)));
+		unit = (data & ATTR_ICC_LVL_UNIT_MASK) >>
+						ATTR_ICC_LVL_UNIT_OFFSET;
+		curr_uA = data & ATTR_ICC_LVL_VALUE_MASK;
+		switch (unit) {
+		case UFSHCD_NANO_AMP:
+			curr_uA = curr_uA / 1000;
+			break;
+		case UFSHCD_MILI_AMP:
+			curr_uA = curr_uA * 1000;
+			break;
+		case UFSHCD_AMP:
+			curr_uA = curr_uA * 1000 * 1000;
+			break;
+		case UFSHCD_MICRO_AMP:
+		default:
+			break;
+		}
+		if (sup_curr_uA >= curr_uA)
+			break;
+	}
+	if (i < 0) {
+		i = 0;
+		pr_err("%s: Couldn't find valid icc_level = %d", __func__, i);
+	}
+
+	return (u32)i;
+}
+
+/**
+ * ufshcd_calc_icc_level - calculate the max ICC level
+ * In case regulators are not initialized we'll return 0
+ * @hba: per-adapter instance
+ * @desc_buf: power descriptor buffer to extract ICC levels from.
+ * @len: length of desc_buff
+ *
+ * Returns calculated ICC level
+ */
+static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
+							u8 *desc_buf, int len)
+{
+	u32 icc_level = 0;
+
+	if (!hba->vreg_info.vcc || !hba->vreg_info.vccq ||
+						!hba->vreg_info.vccq2) {
+		dev_err(hba->dev,
+			"%s: Regulator capability was not set, actvIccLevel=%d",
+							__func__, icc_level);
+		goto out;
+	}
+
+	if (hba->vreg_info.vcc)
+		icc_level = ufshcd_get_max_icc_level(
+				hba->vreg_info.vcc->max_uA,
+				POWER_DESC_MAX_ACTV_ICC_LVLS - 1,
+				&desc_buf[PWR_DESC_ACTIVE_LVLS_VCC_0]);
+
+	if (hba->vreg_info.vccq)
+		icc_level = ufshcd_get_max_icc_level(
+				hba->vreg_info.vccq->max_uA,
+				icc_level,
+				&desc_buf[PWR_DESC_ACTIVE_LVLS_VCCQ_0]);
+
+	if (hba->vreg_info.vccq2)
+		icc_level = ufshcd_get_max_icc_level(
+				hba->vreg_info.vccq2->max_uA,
+				icc_level,
+				&desc_buf[PWR_DESC_ACTIVE_LVLS_VCCQ2_0]);
+out:
+	return icc_level;
+}
+
+static void ufshcd_init_icc_levels(struct ufs_hba *hba)
+{
+	int ret;
+	int buff_len = QUERY_DESC_POWER_MAX_SIZE;
+	u8 desc_buf[QUERY_DESC_POWER_MAX_SIZE];
+
+	ret = ufshcd_read_power_desc(hba, desc_buf, buff_len);
+	if (ret) {
+		dev_err(hba->dev,
+			"%s: Failed reading power descriptor.len = %d ret = %d",
+			__func__, buff_len, ret);
+		return;
+	}
+
+	hba->init_prefetch_data.icc_level =
+			ufshcd_find_max_sup_active_icc_level(hba,
+			desc_buf, buff_len);
+	dev_dbg(hba->dev, "%s: setting icc_level 0x%x",
+			__func__, hba->init_prefetch_data.icc_level);
+
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
+			&hba->init_prefetch_data.icc_level);
+
+	if (ret)
+		dev_err(hba->dev,
+			"%s: Failed configuring bActiveICCLevel = %d ret = %d",
+			__func__, hba->init_prefetch_data.icc_level , ret);
+
+}
+
+/**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
  *
@@ -3293,9 +3412,16 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 
 	/* If we are in error handling context no need to scan the host */
 	if (!ufshcd_eh_in_progress(hba)) {
+		if (!hba->is_init_prefetch)
+			ufshcd_init_icc_levels(hba);
+
 		scsi_scan_host(hba->host);
 		pm_runtime_put_sync(hba->dev);
 	}
+
+	if (!hba->is_init_prefetch)
+		hba->is_init_prefetch = true;
+
 out:
 	/*
 	 * If we failed to initialize the device or the device is not
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index eddb3f3..8365ad4 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -196,6 +196,15 @@ struct ufs_hba_variant_ops {
 };
 
 /**
+ * struct ufs_init_prefetch - contains data that is pre-fetched once during
+ * initialization
+ * @icc_level: icc level which was read during initialization
+ */
+struct ufs_init_prefetch {
+	u32 icc_level;
+};
+
+/**
  * struct ufs_hba - per adapter private structure
  * @mmio_base: UFSHCI base register address
  * @ucdl_base_addr: UFS Command Descriptor base address
@@ -229,6 +238,8 @@ struct ufs_hba_variant_ops {
  * @intr_mask: Interrupt Mask Bits
  * @ee_ctrl_mask: Exception event control mask
  * @is_powered: flag to check if HBA is powered
+ * @is_init_prefetch: flag to check if data was pre-fetched in initialization
+ * @init_prefetch_data: data pre-fetched during initialization
  * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
  * @errors: HBA errors
@@ -285,6 +296,8 @@ struct ufs_hba {
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
 	bool is_powered;
+	bool is_init_prefetch;
+	struct ufs_init_prefetch init_prefetch_data;
 
 	/* Work Queues */
 	struct work_struct eh_work;
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

