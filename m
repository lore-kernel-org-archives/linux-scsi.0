From: Evan Green <evgreen@chromium.org>
Subject: [PATCH 6/7] scsi: ufs: Enable writing config descriptor
Date: Tue, 29 May 2018 11:17:39 -0700
Message-ID: <20180529181740.195362-7-evgreen@chromium.org>
References: <20180529181740.195362-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529181740.195362-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gwendal Grignou <gwendal@chromium.org>, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change enables writing to fields of the config descriptor
via sysfs. It can be used to provision an unprovisioned UFS
device, or reprovision an unlocked device.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
 drivers/scsi/ufs/ufs-sysfs.c | 64 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 623c56074572..54e9f3bca9db 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -252,6 +252,31 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 	return ret;
 }
 
+static ssize_t ufs_sysfs_write_desc_param(struct ufs_hba *hba,
+				  enum desc_idn desc_id,
+				  u8 desc_index,
+				  u8 param_offset,
+				  const char *buf,
+				  ssize_t buf_size,
+				  u8 width)
+{
+	int ret;
+	unsigned long long value;
+
+	if (kstrtoull(buf, 0, &value))
+		return -EINVAL;
+
+	/* Convert to big endian, and send only the appropriate width. */
+	value = cpu_to_be64(value);
+	ret = ufshcd_rw_desc_param(hba, UPIU_QUERY_OPCODE_WRITE_DESC, desc_id,
+				desc_index, param_offset,
+				(u8 *)&value + 8 - width, width);
+	if (ret)
+		return -EINVAL;
+
+	return buf_size;
+}
+
 #define UFS_DESC_PARAM(_name, _puname, _duname, _size)			\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
@@ -357,8 +382,25 @@ static ssize_t cfg_unit_store(struct device *dev,
 	return count;
 }
 
-#define UFS_CONFIG_DESC_PARAM(_name, _uname, _size)			\
-	UFS_DESC_PARAM(cfg_##_name, _uname, CONFIGURATION, _size)
+#define UFS_CONFIG_DESC_PARAM(_name, _puname, _size)			\
+static ssize_t cfg_##_name##_show(struct device *dev,			\
+	struct device_attribute *attr, char *buf)			\
+{									\
+	struct ufs_hba *hba = dev_get_drvdata(dev);			\
+	return ufs_sysfs_read_desc_param(hba,				\
+		QUERY_DESC_IDN_CONFIGURATION, 0,			\
+		CONFIGURATION_DESC_PARAM##_puname, buf, _size);		\
+}									\
+static ssize_t cfg_##_name##_store(struct device *dev,			\
+		struct device_attribute *attr, const char *buf,		\
+		size_t count)						\
+{									\
+	struct ufs_hba *hba = dev_get_drvdata(dev);			\
+	return ufs_sysfs_write_desc_param(hba,				\
+		QUERY_DESC_IDN_CONFIGURATION, 0,			\
+		CONFIGURATION_DESC_PARAM##_puname, buf, count, _size);	\
+}									\
+static DEVICE_ATTR_RW(cfg_##_name)
 
 #define UFS_CONFIG_UNIT_DESC_PARAM(_name, _uname, _size)		\
 static ssize_t unit_##_name##_show(struct device *dev,			\
@@ -375,7 +417,23 @@ static ssize_t unit_##_name##_show(struct device *dev,			\
 	return ufs_sysfs_read_desc_param(hba,				\
 		QUERY_DESC_IDN_CONFIGURATION, 0, offset, buf, _size);	\
 }									\
-static DEVICE_ATTR_RO(unit_##_name)
+static ssize_t unit_##_name##_store(struct device *dev,			\
+		struct device_attribute *attr, const char *buf,		\
+		size_t count)						\
+{									\
+	struct ufs_hba *hba = dev_get_drvdata(dev);			\
+	size_t offset = CONFIGURATION_DESC_PARAM_UNIT0 +		\
+		(hba->sysfs_config_unit *				\
+		 CONFIGURATION_UNIT_DESC_SIZE) +			\
+		 CONFIGURATION_UNIT_DESC_PARAM_##_uname;		\
+	if (offset + _size > hba->desc_size.conf_desc) {		\
+		return -EINVAL;						\
+	}								\
+	return ufs_sysfs_write_desc_param(hba,				\
+		QUERY_DESC_IDN_CONFIGURATION, 0, offset, buf, count,	\
+		_size);							\
+}									\
+static DEVICE_ATTR_RW(unit_##_name)
 
 UFS_CONFIG_DESC_PARAM(number_of_luns, _NUM_LU, 1);
 UFS_CONFIG_DESC_PARAM(boot_enable, _BOOT_ENBL, 1);
-- 
2.13.5
