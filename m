From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v3 6/9] ufs: sysfs: string descriptors
Date: Thu, 28 Dec 2017 15:29:11 +0200
Message-ID: <1514467754-24499-7-git-send-email-stanislav.nijnikov@wdc.com>
References: <1514467754-24499-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514467754-24499-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

This patch introduces a sysfs group entry for the UFS string descriptors.
The group adds "string_descriptors" folder under the UFS driver
sysfs entry (/sys/bus/platform/drivers/ufshcd/*). The folder will contain
5 files that will show string values defined by the UFS spec:
a manufacturer name, a product name, an OEM id, a serial number and a
product revision.  The full information about the string descriptors
could be found at UFS specifications 2.1.

Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 39 ++++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 58 ++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c                  |  4 +--
 drivers/scsi/ufs/ufshcd.h                  |  3 ++
 4 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 48cd49c..ff292127 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -451,3 +451,42 @@ Description:	This file shows maximum VCC, VCCQ and VCCQ2 value for
 		power descriptor parameters. The full information about
 		the descriptor could be found at UFS specifications 2.1.
 		The file is read only.
+
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/manufacturer_name
+Date:		December 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file contains a device manufactureer name string.
+		The full information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/product_name
+Date:		December 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file contains a product name string. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/oem_id
+Date:		December 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file contains a OEM ID string. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/serial_number
+Date:		December 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file contains a device serial number string. The full
+		information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/product_revision
+Date:		December 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file contains a product revision string. The full
+		information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 0db4bed..f3ef281 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -387,12 +387,70 @@ static const struct attribute_group ufs_sysfs_power_descriptor_group = {
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
index 6ed31ca..8703c81 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3114,8 +3114,8 @@ static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
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
index 2235e7d..e5c2615 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -848,6 +848,9 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
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
