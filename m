From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v1 6/9] ufs: sysfs: string descriptors
Date: Mon, 25 Dec 2017 10:34:35 +0200
Message-ID: <1514190878-5571-7-git-send-email-stanislav.nijnikov@wdc.com>
References: <1514190878-5571-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:53156 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751986AbdLYIfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Dec 2017 03:35:07 -0500
In-Reply-To: <1514190878-5571-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 39 ++++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 58 ++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c                  |  4 +--
 drivers/scsi/ufs/ufshcd.h                  |  3 ++
 4 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 7b86efd..736280e 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -450,4 +450,43 @@ Description:	This file shows maximum VCC, VCCQ and VCCQ2 value for
 		active ICC levels from 0 to 15. This is one of the UFS
 		power descriptor parameters. The full information about
 		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/manufacturer_name
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file contains a device manufactureer name string.
+		The full information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/product_name
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file contains a product name string. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/oem_id
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file contains a OEM ID string. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/serial_number
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file contains a device serial number string. The full
+		information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/product_revision
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file contains a product revision string. The full
+		information about the descriptor could be found at
+		UFS specifications 2.1.
 		The file is read only.
\ No newline at end of file
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index b47cd2a..3a20f8d 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -371,12 +371,70 @@ static const struct attribute_group ufs_sysfs_power_descriptor_group = {
 	.attrs = ufs_sysfs_power_descriptor,
 };
 
+#define ufs_sysfs_string_descriptor_show(_name, _pname)                       \
+static ssize_t _name##_show(struct device *dev,                               \
+	struct device_attribute *attr, char *buf)                             \
+{                                                                             \
+	u8 index;                                                             \
+	struct ufs_hba *hba = dev_get_drvdata(dev);                           \
+	int ret;                                                              \
+	int desc_len = QUERY_DESC_MAX_SIZE;                                   \
+	u8 *desc_buf;                                                         \
+	desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_ATOMIC);                  \
+	if (!desc_buf)                                                        \
+		return -ENOMEM;                                               \
+	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC, \
+		QUERY_DESC_IDN_DEVICE, 0, 0, desc_buf, &desc_len);            \
+	if (ret) {                                                            \
+		ret = -EINVAL;                                                \
+		goto out;                                                     \
+	}                                                                     \
+	index = desc_buf[DEVICE_DESC_PARAM_##_pname];                         \
+	memset(desc_buf, 0, QUERY_DESC_MAX_SIZE);                             \
+	if (ufshcd_read_string_desc(hba, index, desc_buf,                     \
+		QUERY_DESC_MAX_SIZE, true)) {                                 \
+		ret = -EINVAL;                                                \
+		goto out;                                                     \
+	}                                                                     \
+	ret = snprintf(buf, PAGE_SIZE, "%s\n",                                \
+		desc_buf + QUERY_DESC_HDR_SIZE);                              \
+out:                                                                          \
+	kfree(desc_buf);                                                      \
+	return ret;                                                           \
+}
+
+#define UFS_STRING_DESCRIPTOR(_name, _pname)                                  \
+	ufs_sysfs_string_descriptor_show(_name, _pname)                       \
+	static DEVICE_ATTR_RO(_name)
+
+UFS_STRING_DESCRIPTOR(manufacturer_name, MANF_NAME);
+UFS_STRING_DESCRIPTOR(product_name, PRDCT_NAME);
+UFS_STRING_DESCRIPTOR(oem_id, OEM_ID);
+UFS_STRING_DESCRIPTOR(serial_number, SN);
+UFS_STRING_DESCRIPTOR(product_revision, PRDCT_REV);
+
+static struct attribute *ufs_sysfs_string_descriptors[] = {
+	&dev_attr_manufacturer_name.attr,
+	&dev_attr_product_name.attr,
+	&dev_attr_oem_id.attr,
+	&dev_attr_serial_number.attr,
+	&dev_attr_product_revision.attr,
+	NULL,
+};
+
+static const struct attribute_group ufs_sysfs_string_descriptors_group = {
+	.name = "string_descriptors",
+	.attrs = ufs_sysfs_string_descriptors,
+};
+
+
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_device_descriptor_group,
 	&ufs_sysfs_interconnect_descriptor_group,
 	&ufs_sysfs_geometry_descriptor_group,
 	&ufs_sysfs_health_descriptor_group,
 	&ufs_sysfs_power_descriptor_group,
+	&ufs_sysfs_string_descriptors_group,
 	NULL,
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e75866e..9e2231d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3109,8 +3109,8 @@ static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
  * Return 0 in case of success, non-zero otherwise
  */
 #define ASCII_STD true
-static int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
-				   u8 *buf, u32 size, bool ascii)
+int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
+			    u8 *buf, u32 size, bool ascii)
 {
 	int err = 0;
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4a27b74..522c634 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -846,6 +846,9 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 				  u8 *desc_buf, int *buf_len);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
+int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
+			    u8 *buf, u32 size, bool ascii);
+
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
 
-- 
2.7.4
