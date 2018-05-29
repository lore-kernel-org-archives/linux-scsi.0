From: Evan Green <evgreen@chromium.org>
Subject: [PATCH 5/7] scsi: ufs: Refactor descriptor read for write
Date: Tue, 29 May 2018 11:17:38 -0700
Message-ID: <20180529181740.195362-6-evgreen@chromium.org>
References: <20180529181740.195362-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529181740.195362-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gwendal Grignou <gwendal@chromium.org>, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change refactors the ufshcd_read_desc_param function into
one that can both read and write descriptors. Most of the low-level
plumbing for writing to descriptors was already there, this change
simply enables that code path, and manages the incoming data buffer
appropriately.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
 drivers/scsi/ufs/ufs-sysfs.c |  4 +-
 drivers/scsi/ufs/ufshcd.c    | 89 ++++++++++++++++++++++++++++++++------------
 drivers/scsi/ufs/ufshcd.h    | 13 ++++---
 3 files changed, 74 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 51bf54e6b47a..623c56074572 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -227,8 +227,8 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 	if (param_size > 8)
 		return -EINVAL;
 
-	ret = ufshcd_read_desc_param(hba, desc_id, desc_index,
-				param_offset, desc_buf, param_size);
+	ret = ufshcd_rw_desc_param(hba, UPIU_QUERY_OPCODE_READ_DESC, desc_id,
+				desc_index, param_offset, desc_buf, param_size);
 	if (ret)
 		return -EINVAL;
 	switch (param_size) {
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 00e79057f870..6a5939fb5da3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3004,22 +3004,24 @@ int ufshcd_map_desc_id_to_length(struct ufs_hba *hba,
 EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
 
 /**
- * ufshcd_read_desc_param - read the specified descriptor parameter
+ * ufshcd_rw_desc_param - read or write the specified descriptor parameter
  * @hba: Pointer to adapter instance
+ * @opcode: indicates whether to read or write
  * @desc_id: descriptor idn value
  * @desc_index: descriptor index
- * @param_offset: offset of the parameter to read
- * @param_read_buf: pointer to buffer where parameter would be read
- * @param_size: sizeof(param_read_buf)
+ * @param_offset: offset of the parameter to read or write
+ * @param_buf: pointer to buffer to be read or written
+ * @param_size: sizeof(param_buf)
  *
  * Return 0 in case of success, non-zero otherwise
  */
-int ufshcd_read_desc_param(struct ufs_hba *hba,
-			   enum desc_idn desc_id,
-			   int desc_index,
-			   u8 param_offset,
-			   u8 *param_read_buf,
-			   u8 param_size)
+int ufshcd_rw_desc_param(struct ufs_hba *hba,
+			 enum query_opcode opcode,
+			 enum desc_idn desc_id,
+			 int desc_index,
+			 u8 param_offset,
+			 u8 *param_buf,
+			 u8 param_size)
 {
 	int ret;
 	u8 *desc_buf;
@@ -3042,24 +3044,57 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 		return ret;
 	}
 
+	if (param_offset > buff_len)
+		return 0;
+
 	/* Check whether we need temp memory */
 	if (param_offset != 0 || param_size < buff_len) {
-		desc_buf = kmalloc(buff_len, GFP_KERNEL);
+		desc_buf = kzalloc(buff_len, GFP_KERNEL);
 		if (!desc_buf)
 			return -ENOMEM;
+
+		/* If it's a write, first read the complete descriptor, then
+		 * copy in the parts being changed.
+		 */
+		if (opcode == UPIU_QUERY_OPCODE_WRITE_DESC) {
+			if ((int)param_offset + (int)param_size > buff_len) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			ret = ufshcd_query_descriptor_retry(hba,
+						UPIU_QUERY_OPCODE_READ_DESC,
+						desc_id, desc_index, 0,
+						desc_buf, &buff_len);
+
+			if (ret) {
+				dev_err(hba->dev,
+					"%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d",
+					__func__, desc_id, desc_index,
+					param_offset, ret);
+
+				goto out;
+			}
+
+			memcpy(desc_buf + param_offset, param_buf, param_size);
+		}
+
 	} else {
-		desc_buf = param_read_buf;
+		desc_buf = param_buf;
 		is_kmalloc = false;
 	}
 
-	/* Request for full descriptor */
-	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
+	/* Read or write the entire descriptor. */
+	ret = ufshcd_query_descriptor_retry(hba, opcode,
 					desc_id, desc_index, 0,
 					desc_buf, &buff_len);
 
 	if (ret) {
-		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d",
-			__func__, desc_id, desc_index, param_offset, ret);
+		dev_err(hba->dev, "%s: Failed %s descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d",
+			__func__,
+			opcode == UPIU_QUERY_OPCODE_READ_DESC ?
+			"reading" : "writing",
+			desc_id, desc_index, param_offset, ret);
 		goto out;
 	}
 
@@ -3071,12 +3106,16 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 		goto out;
 	}
 
-	/* Check wherher we will not copy more data, than available */
-	if (is_kmalloc && param_size > buff_len)
-		param_size = buff_len;
+	/* Copy data to the output. The offset is already validated to be
+	 * within the buffer.
+	 */
+	if (is_kmalloc && (opcode == UPIU_QUERY_OPCODE_READ_DESC)) {
+		if ((int)param_offset + (int)param_size > buff_len)
+			param_size = buff_len - param_offset;
+
+		memcpy(param_buf, &desc_buf[param_offset], param_size);
+	}
 
-	if (is_kmalloc)
-		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
 out:
 	if (is_kmalloc)
 		kfree(desc_buf);
@@ -3089,7 +3128,8 @@ static inline int ufshcd_read_desc(struct ufs_hba *hba,
 				   u8 *buf,
 				   u32 size)
 {
-	return ufshcd_read_desc_param(hba, desc_id, desc_index, 0, buf, size);
+	return ufshcd_rw_desc_param(hba, UPIU_QUERY_OPCODE_READ_DESC, desc_id,
+					desc_index, 0, buf, size);
 }
 
 static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
@@ -3195,8 +3235,9 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	if (!ufs_is_valid_unit_desc_lun(lun))
 		return -EOPNOTSUPP;
 
-	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
-				      param_offset, param_read_buf, param_size);
+	return ufshcd_rw_desc_param(hba, UPIU_QUERY_OPCODE_READ_DESC,
+				    QUERY_DESC_IDN_UNIT, lun, param_offset,
+				    param_read_buf, param_size);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index fb6dcc490f21..ebbd9d580c4b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -853,12 +853,13 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 				  enum desc_idn idn, u8 index,
 				  u8 selector,
 				  u8 *desc_buf, int *buf_len);
-int ufshcd_read_desc_param(struct ufs_hba *hba,
-			   enum desc_idn desc_id,
-			   int desc_index,
-			   u8 param_offset,
-			   u8 *param_read_buf,
-			   u8 param_size);
+int ufshcd_rw_desc_param(struct ufs_hba *hba,
+			 enum query_opcode opcode,
+			 enum desc_idn desc_id,
+			 int desc_index,
+			 u8 param_offset,
+			 u8 *param_read_buf,
+			 u8 param_size);
 int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
-- 
2.13.5
