From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v2 3/4] scsi: ufs: Refactor descriptor read for write
Date: Fri, 15 Jun 2018 14:00:48 -0700
Message-ID: <20180615210049.126123-4-evgreen@chromium.org>
References: <20180615210049.126123-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615210049.126123-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change refactors the ufshcd_read_desc_param function into
one that can both read and write descriptors. Most of the low-level
plumbing for writing to descriptors was already there, this change
simply enables that code path, and manages the incoming data buffer
appropriately.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
Changes since v1:
	- Fail if requesting a region fully outside the descriptor.
	- Clear the remaining buffer if requesting a region partially
outside the descriptor.
	- Add a mutex around the read-modify-write operation as
suggested by Bart.
	- Fixed comment style in this function as suggested by Bart.
	- Refactored error prints to the end of the function, which I
think addresses the appearance that the function is nested too deeply
(as it only actually has 3 levels of nesting).

 drivers/scsi/ufs/ufs-sysfs.c |   4 +-
 drivers/scsi/ufs/ufshcd.c    | 109 +++++++++++++++++++++++++++++++------------
 drivers/scsi/ufs/ufshcd.h    |  15 +++---
 3 files changed, 90 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 4726c05bb085..d0365e8bf839 100644
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
index 0baba3fdb112..110157877823 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3092,22 +3092,24 @@ int ufshcd_map_desc_id_to_length(struct ufs_hba *hba,
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
@@ -3118,7 +3120,8 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 	if (desc_id >= QUERY_DESC_IDN_MAX || !param_size)
 		return -EINVAL;
 
-	/* Get the max length of descriptor from structure filled up at probe
+	/*
+	 * Get the max length of descriptor from structure filled up at probe
 	 * time.
 	 */
 	ret = ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
@@ -3130,26 +3133,53 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 		return ret;
 	}
 
+	if (param_offset > buff_len)
+		return -EINVAL;
+
+	/* Lock the descriptor mutex to prevent simultaneous changes. */
+	mutex_lock(&hba->desc_mutex);
+
 	/* Check whether we need temp memory */
 	if (param_offset != 0 || param_size < buff_len) {
-		desc_buf = kmalloc(buff_len, GFP_KERNEL);
-		if (!desc_buf)
-			return -ENOMEM;
+		desc_buf = kzalloc(buff_len, GFP_KERNEL);
+		if (!desc_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		/*
+		 * If it's a write, first read the complete descriptor, then
+		 * copy in the parts being changed.
+		 */
+		if (opcode == UPIU_QUERY_OPCODE_WRITE_DESC) {
+			if (param_offset + param_size > buff_len) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			ret = ufshcd_query_descriptor_retry(hba,
+						UPIU_QUERY_OPCODE_READ_DESC,
+						desc_id, desc_index, 0,
+						desc_buf, &buff_len);
+
+			if (ret)
+				goto out;
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
 
-	if (ret) {
-		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d",
-			__func__, desc_id, desc_index, param_offset, ret);
+	if (ret)
 		goto out;
-	}
 
 	/* Sanity check */
 	if (desc_buf[QUERY_DESC_DESC_TYPE_OFFSET] != desc_id) {
@@ -3159,13 +3189,29 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 		goto out;
 	}
 
-	/* Check wherher we will not copy more data, than available */
-	if (is_kmalloc && param_size > buff_len)
-		param_size = buff_len;
+	/*
+	 * Copy data to the output. The offset is already validated to be
+	 * within the buffer.
+	 */
+	if (is_kmalloc && (opcode == UPIU_QUERY_OPCODE_READ_DESC)) {
+		if (param_offset + param_size > buff_len) {
+			memset(param_buf + buff_len - param_offset, 0,
+			       param_offset + param_size - buff_len);
+
+			param_size = buff_len - param_offset;
+		}
+
+		memcpy(param_buf, &desc_buf[param_offset], param_size);
+	}
 
-	if (is_kmalloc)
-		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
 out:
+	mutex_unlock(&hba->desc_mutex);
+	if (ret)
+		dev_err(hba->dev, "Failed %s descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d",
+			opcode == UPIU_QUERY_OPCODE_READ_DESC ?
+			"reading" : "writing",
+			desc_id, desc_index, param_offset, ret);
+
 	if (is_kmalloc)
 		kfree(desc_buf);
 	return ret;
@@ -3177,7 +3223,8 @@ static inline int ufshcd_read_desc(struct ufs_hba *hba,
 				   u8 *buf,
 				   u32 size)
 {
-	return ufshcd_read_desc_param(hba, desc_id, desc_index, 0, buf, size);
+	return ufshcd_rw_desc_param(hba, UPIU_QUERY_OPCODE_READ_DESC, desc_id,
+					desc_index, 0, buf, size);
 }
 
 static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
@@ -3283,8 +3330,9 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	if (!ufs_is_valid_unit_desc_lun(lun))
 		return -EOPNOTSUPP;
 
-	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
-				      param_offset, param_read_buf, param_size);
+	return ufshcd_rw_desc_param(hba, UPIU_QUERY_OPCODE_READ_DESC,
+				    QUERY_DESC_IDN_UNIT, lun, param_offset,
+				    param_read_buf, param_size);
 }
 
 /**
@@ -8019,8 +8067,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
 
-	/* Initialize UIC command mutex */
+	/* Initialize UIC command and descriptor mutexes */
 	mutex_init(&hba->uic_cmd_mutex);
+	mutex_init(&hba->desc_mutex);
 
 	/* Initialize mutex for device management commands */
 	mutex_init(&hba->dev_cmd.lock);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index bb540a3fd8de..c6305a458100 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -513,6 +513,7 @@ struct ufs_cfg_object {
  * @scsi_block_reqs_cnt: reference counting for scsi block requests
  * @cfg_objects: Stores the array of kobjects created for the config descriptor.
  * @cfg_object_count: Stores the number of elements in cfg_objects.
+ * @desc_mutex: Mutex to serialize modifications to UFS descriptors.
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -717,6 +718,7 @@ struct ufs_hba {
 
 	struct ufs_cfg_object **cfg_objects;
 	size_t cfg_object_count;
+	struct mutex desc_mutex;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
@@ -886,12 +888,13 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
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
+			 u8 *param_buf,
+			 u8 param_size);
 int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
-- 
2.13.5
