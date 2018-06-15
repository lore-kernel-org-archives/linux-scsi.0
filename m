From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v2 4/4] scsi: ufs: Enable writing config descriptor
Date: Fri, 15 Jun 2018 14:00:49 -0700
Message-ID: <20180615210049.126123-5-evgreen@chromium.org>
References: <20180615210049.126123-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615210049.126123-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change enables writing to fields of the config descriptor
via sysfs. It can be used to provision an unprovisioned UFS
device, or reprovision an unlocked device.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
Changes since v2:
        - New common _store function, since I'm using kobj_type now.
        - Tried to make the endianness more explicit as suggested by Bart.
I opted not to go as far as creating rw_desc_param{16,32} and friends,
as those would simply turn around and call the generic function, which
didn't seem all that useful.

 Documentation/ABI/testing/sysfs-driver-ufs | 17 ------
 drivers/scsi/ufs/ufs-sysfs.c               | 83 +++++++++++++++++++++++++++++-
 2 files changed, 81 insertions(+), 19 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index d7477fffe0d1..fef594d912de 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -244,7 +244,6 @@ Description:	This file shows whether or not the UFS boot feature is enabled.
 		This is one of the UFS configuration descriptor parameters.
 		More information about the descriptor can be found in the UFS
 		2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/descriptor_access_enable
 Date:		May 2018
@@ -254,7 +253,6 @@ Description:	This file shows whether or not access will be permitted to the
 		boot sequence. This is one of the UFS configuration descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/high_priority_lun
 Date:		May 2018
@@ -263,7 +261,6 @@ Description:	This file shows the identifier of the high priority logical
 		unit. This is one of the UFS configuration descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/init_active_icc_level
 Date:		May 2018
@@ -272,7 +269,6 @@ Description:	This file shows the ICC level in active mode after device
 		initialization or hardware reset. This is one of the UFS
 		configuration descriptor parameters. More information about the
 		descriptor can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/initial_power_mode
 Date:		May 2018
@@ -281,7 +277,6 @@ Description:	This file shows the power mode after device initialization or
 		hardware reset. This is one of the UFS configuration descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/number_of_luns
 Date:		May 2018
@@ -290,7 +285,6 @@ Description:	This file shows the number of logical units that the device will
 		support. This is one of the UFS configuration descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/periodic_rtc_update
 Date:		May 2018
@@ -299,7 +293,6 @@ Description:	This file shows the frequency and method of real time clock
 		updates. This is one of the UFS configuration descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/secure_removal_type
 Date:		May 2018
@@ -308,7 +301,6 @@ Description:	This file shows the secure removal type of the UFS device. This
 		is one of the UFS configuration descriptor parameters. More
 		information about the descriptor can be found in the UFS 2.1
 		specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/allocation_units
 Date:		May 2018
@@ -317,7 +309,6 @@ Description:	This file shows the number of allocation units assigned to the
 		particular logical unit. This is one of the UFS configuration
 		unit descriptor parameters. More information about the
 		descriptor can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/boot_lun_id
 Date:		May 2018
@@ -327,7 +318,6 @@ Description:	This file shows the boot LUN ID for this particular logical
 		This is one of the UFS configuration unit descriptor parameters.
 		More information about the descriptor can be found in the UFS
 		2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/context_capabilities
 Date:		May 2018
@@ -336,7 +326,6 @@ Description:	This file shows the context capabilities for the particular
 		logical unit. This is one of the UFS configuration unit
 		descriptor parameters. More information about the descriptor
 		can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/data_reliability
 Date:		May 2018
@@ -345,7 +334,6 @@ Description:	This file shows the data reliability for the particular logical
 		unit. This is one of the UFS configuration unit descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/logical_block_size
 Date:		May 2018
@@ -354,7 +342,6 @@ Description:	This file shows the logical block size for the particular
 		logical unit as a power of two. This is one of the UFS
 		configuration unit descriptor parameters. More information
 		about the descriptor can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/lu_enable
 Date:		May 2018
@@ -363,7 +350,6 @@ Description:	This file shows whether or not the particular logical unit is
 		enabled. This is one of the UFS configuration unit descriptor
 		parameters. More information about the descriptor can be found
 		in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/lu_write_protect
 Date:		May 2018
@@ -372,7 +358,6 @@ Description:	This file shows the write protect status for the particular
 		logical unit. This is one of the UFS configuration unit
 		descriptor parameters. More information about the descriptor
 		can be found in the UFS 2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/memory_type
 Date:		May 2018
@@ -381,7 +366,6 @@ Description:	This file shows the memory type for the particular logical unit.
 		This is one of the UFS configuration unit descriptor parameters.
 		More information about the descriptor can be found in the UFS
 		2.1 specification.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/provisioning_type
 Date:		May 2018
@@ -390,7 +374,6 @@ Description:	This file shows the provisioning type information for the
 		particular logical unit. This is one of the UFS configuration
 		uint descriptor parameters. More information about the
 		descriptor can be found in the UFS 2.1 specification.
-		The file is read only.
 
 
 What:		/sys/bus/platform/drivers/ufshcd/*/interconnect_descriptor/unipro_version
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index d0365e8bf839..9e6e592280bb 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -252,6 +252,56 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
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
+	u8 value8;
+	__be16 value16;
+	__be32 value32;
+	__be64 value64;
+	u8 *valueptr;
+
+	if (kstrtoull(buf, 0, &value))
+		return -EINVAL;
+
+	switch (width) {
+	case 1:
+		value8 = (u8)value;
+		valueptr = &value8;
+		break;
+
+	case 2:
+		value16 = cpu_to_be16(value);
+		valueptr = (u8 *)&value16;
+		break;
+
+	case 4:
+		value32 = cpu_to_be32(value);
+		valueptr = (u8 *)&value32;
+		break;
+
+	case 8:
+		value64 = cpu_to_be64(value);
+		valueptr = (u8 *)&value64;
+		break;
+	}
+
+	ret = ufshcd_rw_desc_param(hba, UPIU_QUERY_OPCODE_WRITE_DESC, desc_id,
+				desc_index, param_offset,
+				valueptr, width);
+	if (ret)
+		return -EINVAL;
+
+	return buf_size;
+}
+
 #define UFS_DESC_PARAM(_name, _puname, _duname, _size)			\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
@@ -346,7 +396,7 @@ struct ufs_config_desc_attr {
 #define UFS_CONFIG_DESC_PARAM(_name, _uname, _size)			\
 static struct ufs_config_desc_attr ufs_cfg_attr_##_name = {		\
 	.attr = {.name = __stringify(_name),				\
-		 .mode = VERIFY_OCTAL_PERMISSIONS(0444) }, \
+		 .mode = VERIFY_OCTAL_PERMISSIONS(0644) }, 		\
 	.offset = CONFIGURATION_DESC_PARAM##_uname,			\
 	.size = _size							\
 }
@@ -375,7 +425,7 @@ static struct attribute *ufs_sysfs_config_descriptor[] = {
 #define UFS_CONFIG_UNIT_DESC_PARAM(_name, _uname, _size)		\
 static struct ufs_config_desc_attr ufs_cfg_unit_attr_##_name = {	\
 	.attr = {.name = __stringify(_name),				\
-		 .mode = VERIFY_OCTAL_PERMISSIONS(0444) },		\
+		 .mode = VERIFY_OCTAL_PERMISSIONS(0644) },		\
 	.offset = CONFIGURATION_UNIT_DESC_PARAM##_uname,		\
 	.size = _size							\
 }
@@ -430,8 +480,37 @@ static ssize_t ufs_cfg_attr_show(struct kobject *kobj, struct attribute *attr,
 					 offset, buf, cfg_attr->size);
 }
 
+static ssize_t ufs_cfg_attr_store(struct kobject *kobj, struct attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct ufs_config_desc_attr *cfg_attr = to_ufs_cfg_desc_attr(attr);
+	struct ufs_cfg_object *cfg_obj = to_ufs_cfg_obj(kobj);
+	u8 offset = cfg_attr->offset;
+	struct device *dev;
+	struct ufs_hba *hba;
+
+	/*
+	 * For unit config descriptors, add the unit's offset and get the
+	 * device parent two up.
+	 */
+	if (cfg_obj->index >= 0) {
+		offset += CONFIGURATION_DESC_PARAM_UNIT0 +
+			(CONFIGURATION_UNIT_DESC_SIZE * cfg_obj->index);
+
+		dev = kobj_to_dev(cfg_obj->kobj.parent->parent);
+
+	} else {
+		dev = kobj_to_dev(cfg_obj->kobj.parent);
+	}
+
+	hba = dev_get_drvdata(dev);
+	return ufs_sysfs_write_desc_param(hba, QUERY_DESC_IDN_CONFIGURATION, 0,
+					 offset, buf, count, cfg_attr->size);
+}
+
 static const struct sysfs_ops ufs_sysfs_config_descriptor_ops = {
 	.show	= ufs_cfg_attr_show,
+	.store	= ufs_cfg_attr_store,
 };
 
 static void ufs_cfg_kobject_release(struct kobject *kobj)
-- 
2.13.5
