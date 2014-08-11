From: Dolev Raviv <draviv@codeaurora.org>
Subject: [RFC 04/10] scsi: ufs: refactor query descriptor API support
Date: Mon, 11 Aug 2014 15:40:32 +0300
Message-ID: <1407760838-6406-5-git-send-email-draviv@codeaurora.org>
References: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

Currently reading query descriptor is more tightened to each
descriptor type. This patch generalize the approach and allows
reading any parameter from any query descriptor.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 729ce7d..7ea8e71 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -50,6 +50,8 @@
 			cpu_to_be32((byte3 << 24) | (byte2 << 16) |\
 			 (byte1 << 8) | (byte0))
 
+#define UFS_UPIU_MAX_GENERAL_LUN	8
+
 /*
  * UFS Protocol Information Unit related definitions
  */
@@ -129,10 +131,29 @@ enum desc_idn {
 	QUERY_DESC_IDN_RFU_1		= 0x6,
 	QUERY_DESC_IDN_GEOMETRY		= 0x7,
 	QUERY_DESC_IDN_POWER		= 0x8,
-	QUERY_DESC_IDN_RFU_2		= 0x9,
+	QUERY_DESC_IDN_MAX,
+};
+
+enum desc_header_offset {
+	QUERY_DESC_LENGTH_OFFSET	= 0x00,
+	QUERY_DESC_DESC_TYPE_OFFSET	= 0x01,
+};
+
+enum ufs_desc_max_size {
+	QUERY_DESC_DEVICE_MAX_SIZE		= 0x1F,
+	QUERY_DESC_CONFIGURAION_MAX_SIZE	= 0x90,
+	QUERY_DESC_UNIT_MAX_SIZE		= 0x23,
+	QUERY_DESC_INTERCONNECT_MAX_SIZE	= 0x06,
+	/*
+	 * Max. 126 UNICODE characters (2 bytes per character) plus 2 bytes
+	 * of descriptor header.
+	 */
+	QUERY_DESC_STRING_MAX_SIZE		= 0xFE,
+	QUERY_DESC_GEOMETRY_MAZ_SIZE		= 0x44,
+	QUERY_DESC_POWER_MAX_SIZE		= 0x62,
+	QUERY_DESC_RFU_MAX_SIZE			= 0x00,
 };
 
-#define UNIT_DESC_MAX_SIZE       0x22
 /* Unit descriptor parameters offsets in bytes*/
 enum unit_desc_param {
 	UNIT_DESC_PARAM_LEN			= 0x0,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b033702..57a8dbb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -78,6 +78,19 @@
 		_ret;                                                   \
 	})
 
+static u32 ufs_query_desc_max_size[] = {
+	QUERY_DESC_DEVICE_MAX_SIZE,
+	QUERY_DESC_CONFIGURAION_MAX_SIZE,
+	QUERY_DESC_UNIT_MAX_SIZE,
+	QUERY_DESC_RFU_MAX_SIZE,
+	QUERY_DESC_INTERCONNECT_MAX_SIZE,
+	QUERY_DESC_STRING_MAX_SIZE,
+	QUERY_DESC_RFU_MAX_SIZE,
+	QUERY_DESC_GEOMETRY_MAZ_SIZE,
+	QUERY_DESC_POWER_MAX_SIZE,
+	QUERY_DESC_RFU_MAX_SIZE,
+};
+
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
@@ -124,8 +137,6 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
-static int ufshcd_read_sdev_qdepth(struct ufs_hba *hba,
-					struct scsi_device *sdev);
 
 /*
  * ufshcd_wait_for_register - wait for register value to change
@@ -1393,6 +1404,115 @@ out:
 }
 
 /**
+ * ufshcd_read_desc_param - read the specified descriptor parameter
+ * @hba: Pointer to adapter instance
+ * @desc_id: descriptor idn value
+ * @desc_index: descriptor index
+ * @param_offset: offset of the parameter to read
+ * @param_read_buf: pointer to buffer where parameter would be read
+ * @param_size: sizeof(param_read_buf)
+ *
+ * Return 0 in case of success, non-zero otherwise
+ */
+static int ufshcd_read_desc_param(struct ufs_hba *hba,
+				  enum desc_idn desc_id,
+				  int desc_index,
+				  u32 param_offset,
+				  u8 *param_read_buf,
+				  u32 param_size)
+{
+	int ret;
+	u8 *desc_buf;
+	u32 buff_len;
+	bool is_kmalloc = true;
+
+	/* safety checks */
+	if (desc_id >= QUERY_DESC_IDN_MAX)
+		return -EINVAL;
+
+	buff_len = ufs_query_desc_max_size[desc_id];
+	if ((param_offset + param_size) > buff_len)
+		return -EINVAL;
+
+	if (!param_offset && (param_size == buff_len)) {
+		/* memory space already available to hold full descriptor */
+		desc_buf = param_read_buf;
+		is_kmalloc = false;
+	} else {
+		/* allocate memory to hold full descriptor */
+		desc_buf = kmalloc(buff_len, GFP_KERNEL);
+		if (!desc_buf)
+			return -ENOMEM;
+	}
+
+	ret = ufshcd_query_descriptor(hba, UPIU_QUERY_OPCODE_READ_DESC,
+				      desc_id, desc_index, 0, desc_buf,
+				      &buff_len);
+
+	if (ret || (buff_len < ufs_query_desc_max_size[desc_id]) ||
+	    (desc_buf[QUERY_DESC_LENGTH_OFFSET] !=
+	     ufs_query_desc_max_size[desc_id])
+	    || (desc_buf[QUERY_DESC_DESC_TYPE_OFFSET] != desc_id)) {
+		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d param_offset %d buff_len %d ret %d",
+			__func__, desc_id, param_offset, buff_len, ret);
+		if (!ret)
+			ret = -EINVAL;
+
+		goto out;
+	}
+
+	if (is_kmalloc)
+		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
+out:
+	if (is_kmalloc)
+		kfree(desc_buf);
+	return ret;
+}
+
+static inline int ufshcd_read_desc(struct ufs_hba *hba,
+				   enum desc_idn desc_id,
+				   int desc_index,
+				   u8 *buf,
+				   u32 size)
+{
+	return ufshcd_read_desc_param(hba, desc_id, desc_index, 0, buf, size);
+}
+
+static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
+					 u8 *buf,
+					 u32 size)
+{
+	return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
+}
+
+/**
+ * ufshcd_read_unit_desc_param - read the specified unit descriptor parameter
+ * @hba: Pointer to adapter instance
+ * @lun: lun id
+ * @param_offset: offset of the parameter to read
+ * @param_read_buf: pointer to buffer where parameter would be read
+ * @param_size: sizeof(param_read_buf)
+ *
+ * Return 0 in case of success, non-zero otherwise
+ */
+static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
+					      int lun,
+					      enum unit_desc_param param_offset,
+					      u8 *param_read_buf,
+					      u32 param_size)
+{
+	/*
+	 * Unit descriptors are only available for general purpose LUs (LUN id
+	 * from 0 to 7) and RPMB Well known LU.
+	 */
+	if (lun >= UFS_UPIU_MAX_GENERAL_LUN)
+		return -EOPNOTSUPP;
+
+	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
+				      param_offset, param_read_buf, param_size);
+}
+
+/**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
  *
@@ -2011,7 +2131,8 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 static int ufshcd_slave_alloc(struct scsi_device *sdev)
 {
 	struct ufs_hba *hba;
-	int lun_qdepth;
+	u8 lun_qdepth;
+	int ret;
 
 	hba = shost_priv(sdev->host);
 	sdev->tagged_supported = 1;
@@ -2026,8 +2147,12 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	/* REPORT SUPPORTED OPERATION CODES is not supported */
 	sdev->no_report_opcodes = 1;
 
-	lun_qdepth = ufshcd_read_sdev_qdepth(hba, sdev);
-	if (lun_qdepth <= 0)
+	ret = ufshcd_read_unit_desc_param(hba,
+					  sdev->lun,
+					  UNIT_DESC_PARAM_LU_Q_DEPTH,
+					  &lun_qdepth,
+					  sizeof(lun_qdepth));
+	if (!ret || !lun_qdepth)
 		/* eventually, we can figure out the real queue depth */
 		lun_qdepth = hba->nutrs;
 	else
@@ -3118,38 +3243,6 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 }
 
 /**
- * ufshcd_read_sdev_qdepth - read the lun command queue depth
- * @hba: Pointer to adapter instance
- * @sdev: pointer to SCSI device
- *
- * Return in case of success the lun's queue depth else error.
- */
-static int ufshcd_read_sdev_qdepth(struct ufs_hba *hba,
-				struct scsi_device *sdev)
-{
-	int ret;
-	int buff_len = UNIT_DESC_MAX_SIZE;
-	u8 desc_buf[UNIT_DESC_MAX_SIZE];
-
-	ret = ufshcd_query_descriptor(hba, UPIU_QUERY_OPCODE_READ_DESC,
-			QUERY_DESC_IDN_UNIT, sdev->lun, 0, desc_buf, &buff_len);
-
-	if (ret || (buff_len < UNIT_DESC_PARAM_LU_Q_DEPTH)) {
-		dev_err(hba->dev,
-			"%s:Failed reading unit descriptor. len = %d ret = %d"
-			, __func__, buff_len, ret);
-		if (!ret)
-			ret = -EINVAL;
-
-		goto out;
-	}
-
-	ret = desc_buf[UNIT_DESC_PARAM_LU_Q_DEPTH] & 0xFF;
-out:
-	return ret;
-}
-
-/**
  * ufshcd_async_scan - asynchronous execution for link startup
  * @data: data pointer to pass to this function
  * @cookie: cookie data
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
