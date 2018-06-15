From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v2 1/4] scsi: ufs: Add Configuration Descriptor to sysfs
Date: Fri, 15 Jun 2018 14:00:46 -0700
Message-ID: <20180615210049.126123-2-evgreen@chromium.org>
References: <20180615210049.126123-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615210049.126123-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change adds the configuration descriptor to the UFS
sysfs interface. This is done in preparation for making the
interface writable, which will enable provisioning UFS devices
via Linux.

The configuration descriptor is laid out as a header, then a set of
(usually 8) copies of the same descriptor for each unit.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
Changes since v1:
	- Squashed documentation changes into this change.
	- Reworked sysfs layout so that instead of a sysfs file for a
unit selector and then a common set of unit attributes, each unit in
the config descriptor has its own directory. This required a little
bit of kobject magic. Alternatively I could use standard device
attributes and simply allocate N*M of them from a template. I have
that coded up, and can go with that if preferred, but I thought
this was a little nicer since it wasted less memory.

 Documentation/ABI/testing/sysfs-driver-ufs | 156 ++++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 226 +++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.h               |   1 +
 drivers/scsi/ufs/ufs.h                     |  29 ++++
 drivers/scsi/ufs/ufshcd.c                  |   1 +
 drivers/scsi/ufs/ufshcd.h                  |  15 ++
 6 files changed, 428 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 016724ec26d5..eebd95fb1db5 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -237,6 +237,162 @@ Description:	This file shows the command maximum timeout for a change
 		The file is read only.
 
 
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/boot_enable
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows whether or not the UFS boot feature is enabled.
+		This is one of the UFS configuration descriptor parameters.
+		More information about the descriptor can be found in the UFS
+		2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/descriptor_access_enable
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows whether or not access will be permitted to the
+		Device Descriptor after the partial initialization phase of the
+		boot sequence. This is one of the UFS configuration descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/high_priority_lun
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the identifier of the high priority logical
+		unit. This is one of the UFS configuration descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/init_active_icc_level
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the ICC level in active mode after device
+		initialization or hardware reset. This is one of the UFS
+		configuration descriptor parameters. More information about the
+		descriptor can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/initial_power_mode
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the power mode after device initialization or
+		hardware reset. This is one of the UFS configuration descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/number_of_luns
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the number of logical units that the device will
+		support. This is one of the UFS configuration descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/periodic_rtc_update
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the frequency and method of real time clock
+		updates. This is one of the UFS configuration descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/secure_removal_type
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the secure removal type of the UFS device. This
+		is one of the UFS configuration descriptor parameters. More
+		information about the descriptor can be found in the UFS 2.1
+		specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/allocation_units
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the number of allocation units assigned to the
+		particular logical unit. This is one of the UFS configuration
+		unit descriptor parameters. More information about the
+		descriptor can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/boot_lun_id
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the boot LUN ID for this particular logical
+		unit, indicating whether it is Boot A, Boot B, or not special.
+		This is one of the UFS configuration unit descriptor parameters.
+		More information about the descriptor can be found in the UFS
+		2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/context_capabilities
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the context capabilities for the particular
+		logical unit. This is one of the UFS configuration unit
+		descriptor parameters. More information about the descriptor
+		can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/data_reliability
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the data reliability for the particular logical
+		unit. This is one of the UFS configuration unit descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/logical_block_size
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the logical block size for the particular
+		logical unit as a power of two. This is one of the UFS
+		configuration unit descriptor parameters. More information
+		about the descriptor can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/lu_enable
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows whether or not the particular logical unit is
+		enabled. This is one of the UFS configuration unit descriptor
+		parameters. More information about the descriptor can be found
+		in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/lu_write_protect
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the write protect status for the particular
+		logical unit. This is one of the UFS configuration unit
+		descriptor parameters. More information about the descriptor
+		can be found in the UFS 2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/memory_type
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the memory type for the particular logical unit.
+		This is one of the UFS configuration unit descriptor parameters.
+		More information about the descriptor can be found in the UFS
+		2.1 specification.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/unit*/provisioning_type
+Date:		May 2018
+Contact:	Evan Green <evgreen@chromium.org>
+Description:	This file shows the provisioning type information for the
+		particular logical unit. This is one of the UFS configuration
+		uint descriptor parameters. More information about the
+		descriptor can be found in the UFS 2.1 specification.
+		The file is read only.
+
+
 What:		/sys/bus/platform/drivers/ufshcd/*/interconnect_descriptor/unipro_version
 Date:		February 2018
 Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 8d9332bb7d0c..7ac1440c82eb 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -327,6 +327,132 @@ static const struct attribute_group ufs_sysfs_device_descriptor_group = {
 	.attrs = ufs_sysfs_device_descriptor,
 };
 
+/*
+ * Define a unique attribute structure for configuration descriptors, since
+ * the sysfs attributes look at both the description and the parent kobject
+ * to find the index.
+ */
+
+struct ufs_config_desc_attr {
+	struct attribute attr;
+	u8 offset;
+	u8 size;
+};
+
+#define to_ufs_cfg_obj(_kobj) container_of(_kobj, struct ufs_cfg_object, kobj)
+#define to_ufs_cfg_desc_attr(_attr) \
+	container_of(_attr, struct ufs_config_desc_attr, attr)
+
+#define UFS_CONFIG_DESC_PARAM(_name, _uname, _size)			\
+static struct ufs_config_desc_attr ufs_cfg_attr_##_name = {		\
+	.attr = {.name = __stringify(_name),				\
+		 .mode = VERIFY_OCTAL_PERMISSIONS(0444) }, \
+	.offset = CONFIGURATION_DESC_PARAM##_uname,			\
+	.size = _size							\
+}
+
+UFS_CONFIG_DESC_PARAM(number_of_luns, _NUM_LU, 1);
+UFS_CONFIG_DESC_PARAM(boot_enable, _BOOT_ENBL, 1);
+UFS_CONFIG_DESC_PARAM(descriptor_access_enable, _DESC_ACCSS_ENBL, 1);
+UFS_CONFIG_DESC_PARAM(initial_power_mode, _INIT_PWR_MODE, 1);
+UFS_CONFIG_DESC_PARAM(high_priority_lun, _HIGH_PR_LUN, 1);
+UFS_CONFIG_DESC_PARAM(secure_removal_type, _SEC_RMV_TYPE, 1);
+UFS_CONFIG_DESC_PARAM(init_active_icc_level, _ACTVE_ICC_LVL, 1);
+UFS_CONFIG_DESC_PARAM(periodic_rtc_update, _FRQ_RTC, 2);
+
+static struct attribute *ufs_sysfs_config_descriptor[] = {
+	&ufs_cfg_attr_number_of_luns.attr,
+	&ufs_cfg_attr_boot_enable.attr,
+	&ufs_cfg_attr_descriptor_access_enable.attr,
+	&ufs_cfg_attr_initial_power_mode.attr,
+	&ufs_cfg_attr_high_priority_lun.attr,
+	&ufs_cfg_attr_secure_removal_type.attr,
+	&ufs_cfg_attr_init_active_icc_level.attr,
+	&ufs_cfg_attr_periodic_rtc_update.attr,
+	NULL,
+};
+
+#define UFS_CONFIG_UNIT_DESC_PARAM(_name, _uname, _size)		\
+static struct ufs_config_desc_attr ufs_cfg_unit_attr_##_name = {	\
+	.attr = {.name = __stringify(_name),				\
+		 .mode = VERIFY_OCTAL_PERMISSIONS(0444) },		\
+	.offset = CONFIGURATION_UNIT_DESC_PARAM##_uname,		\
+	.size = _size							\
+}
+
+UFS_CONFIG_UNIT_DESC_PARAM(lu_enable, _LU_ENABLE, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(boot_lun_id, _BOOT_LUN_ID, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(lu_write_protect, _LU_WR_PROTECT, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(memory_type, _MEM_TYPE, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(allocation_units, _NUM_ALLOC_UNITS, 4);
+UFS_CONFIG_UNIT_DESC_PARAM(data_reliability, _DATA_RELIABILITY, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(logical_block_size, _LOGICAL_BLK_SIZE, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(provisioning_type, _PROVISIONING_TYPE, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(context_capabilities, _CTX_CAPABILITIES, 2);
+
+static struct attribute *ufs_sysfs_config_unit_descriptor[] = {
+	&ufs_cfg_unit_attr_lu_enable.attr,
+	&ufs_cfg_unit_attr_boot_lun_id.attr,
+	&ufs_cfg_unit_attr_lu_write_protect.attr,
+	&ufs_cfg_unit_attr_memory_type.attr,
+	&ufs_cfg_unit_attr_allocation_units.attr,
+	&ufs_cfg_unit_attr_data_reliability.attr,
+	&ufs_cfg_unit_attr_logical_block_size.attr,
+	&ufs_cfg_unit_attr_provisioning_type.attr,
+	&ufs_cfg_unit_attr_context_capabilities.attr,
+	NULL
+};
+
+static ssize_t ufs_cfg_attr_show(struct kobject *kobj, struct attribute *attr,
+			     char *buf)
+{
+	struct ufs_config_desc_attr *cfg_attr = to_ufs_cfg_desc_attr(attr);
+	struct ufs_cfg_object *cfg_obj = to_ufs_cfg_obj(kobj);
+	u8 offset = cfg_attr->offset;
+	struct device *dev;
+	struct ufs_hba *hba;
+
+	/* For unit config descriptors, add the unit's offset and get the
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
+	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_CONFIGURATION, 0,
+					 offset, buf, cfg_attr->size);
+}
+
+static const struct sysfs_ops ufs_sysfs_config_descriptor_ops = {
+	.show	= ufs_cfg_attr_show,
+};
+
+static void ufs_cfg_kobject_release(struct kobject *kobj)
+{
+	struct ufs_cfg_object *cfg = to_ufs_cfg_obj(kobj);
+
+	kfree(cfg);
+}
+
+static struct kobj_type ufs_cfg_kobject_type = {
+	.release = ufs_cfg_kobject_release,
+	.sysfs_ops = &ufs_sysfs_config_descriptor_ops,
+	.default_attrs = ufs_sysfs_config_descriptor,
+};
+
+static struct kobj_type ufs_cfg_unit_kobject_type = {
+	.release = ufs_cfg_kobject_release,
+	.sysfs_ops = &ufs_sysfs_config_descriptor_ops,
+	.default_attrs = ufs_sysfs_config_unit_descriptor,
+};
+
 #define UFS_INTERCONNECT_DESC_PARAM(_name, _uname, _size)		\
 	UFS_DESC_PARAM(_name, _uname, INTERCONNECT, _size)
 
@@ -800,6 +926,21 @@ const struct attribute_group ufs_sysfs_lun_attributes_group = {
 	.attrs = ufs_sysfs_lun_attributes,
 };
 
+static void ufs_sysfs_destroy_unit_groups(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < hba->cfg_object_count; i++) {
+		kobject_uevent(&hba->cfg_objects[i]->kobj, KOBJ_REMOVE);
+		kobject_put(&hba->cfg_objects[i]->kobj);
+	}
+
+	kfree(hba->cfg_objects);
+	hba->cfg_objects = NULL;
+	hba->cfg_object_count = 0;
+}
+
 void ufs_sysfs_add_nodes(struct device *dev)
 {
 	int ret;
@@ -811,7 +952,92 @@ void ufs_sysfs_add_nodes(struct device *dev)
 			__func__, ret);
 }
 
+void ufs_sysfs_add_units(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int conf_len, i, inited = 0, unit_count, ret;
+
+	/* Determine the number of units from the descriptor length. */
+	ret = ufshcd_map_desc_id_to_length(hba,
+				QUERY_DESC_IDN_CONFIGURATION, &conf_len);
+
+	if (ret || conf_len < CONFIGURATION_DESC_PARAM_UNIT0)
+		return;
+
+	unit_count = (conf_len - CONFIGURATION_DESC_PARAM_UNIT0) /
+			CONFIGURATION_UNIT_DESC_SIZE;
+
+	/* Skip if the right number of units are already set up. */
+	if (hba->cfg_object_count == unit_count + 1)
+		return;
+
+	/* Clean up any old unit descriptor groups. */
+	if (hba->cfg_object_count)
+		ufs_sysfs_destroy_unit_groups(dev);
+
+	/*
+	 * Create kobjects for the config descriptor and each unit descriptor.
+	 * The first element is the config descriptor itself.
+	 */
+	hba->cfg_objects = kzalloc(
+		(unit_count + 1) * sizeof(void *), GFP_ATOMIC);
+
+	if (!hba->cfg_objects)
+		return;
+
+	hba->cfg_objects[0] = kzalloc(sizeof(struct ufs_cfg_object),
+				      GFP_ATOMIC);
+	if (!hba->cfg_objects[0])
+		goto err;
+
+	hba->cfg_objects[0]->index = -1;
+	ret = kobject_init_and_add(&hba->cfg_objects[0]->kobj,
+				   &ufs_cfg_kobject_type, &dev->kobj,
+				   "%s", "config_descriptor");
+
+	if (ret) {
+		kfree(hba->cfg_objects[0]);
+		goto err;
+	}
+
+	inited++;
+	for (i = 0; i < unit_count; i++, inited++) {
+		hba->cfg_objects[i + 1] = kzalloc(sizeof(struct ufs_cfg_object),
+						  GFP_ATOMIC);
+
+		if (!hba->cfg_objects[i + 1])
+			goto err;
+
+		hba->cfg_objects[i + 1]->index = i;
+		ret = kobject_init_and_add(&hba->cfg_objects[i + 1]->kobj,
+					   &ufs_cfg_unit_kobject_type,
+					   &hba->cfg_objects[0]->kobj,
+					   "unit%d", i);
+
+		if (ret) {
+			kfree(hba->cfg_objects[i + 1]);
+			goto err;
+		}
+	}
+
+	hba->cfg_object_count = unit_count + 1;
+	for (i = 0; i < inited; i++)
+		kobject_uevent(&hba->cfg_objects[i]->kobj, KOBJ_ADD);
+
+	return;
+
+err:
+	dev_err(dev, "error %d creating unit sysfs groups\n", ret);
+	for (i = inited - 1; i >= 0; i--)
+		kobject_put(&hba->cfg_objects[i]->kobj);
+
+	kfree(hba->cfg_objects);
+	hba->cfg_objects = NULL;
+	hba->cfg_object_count = 0;
+}
+
 void ufs_sysfs_remove_nodes(struct device *dev)
 {
 	sysfs_remove_groups(&dev->kobj, ufs_sysfs_groups);
+	ufs_sysfs_destroy_unit_groups(dev);
 }
diff --git a/drivers/scsi/ufs/ufs-sysfs.h b/drivers/scsi/ufs/ufs-sysfs.h
index e5621e59a432..a1002f339b1a 100644
--- a/drivers/scsi/ufs/ufs-sysfs.h
+++ b/drivers/scsi/ufs/ufs-sysfs.h
@@ -10,6 +10,7 @@
 #include "ufshcd.h"
 
 void ufs_sysfs_add_nodes(struct device *dev);
+void ufs_sysfs_add_units(struct device *dev);
 void ufs_sysfs_remove_nodes(struct device *dev);
 
 extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 14e5bf7af0bb..a5712b1a07ad 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -260,6 +260,35 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
 };
 
+/* Configuration descriptor parameter offsets in bytes */
+enum configuration_desc_param {
+	CONFIGURATION_DESC_PARAM_LEN			= 0x0,
+	CONFIGURATION_DESC_PARAM_TYPE			= 0x1,
+	CONFIGURATION_DESC_PARAM_NUM_LU			= 0x2,
+	CONFIGURATION_DESC_PARAM_BOOT_ENBL		= 0x3,
+	CONFIGURATION_DESC_PARAM_DESC_ACCSS_ENBL	= 0x4,
+	CONFIGURATION_DESC_PARAM_INIT_PWR_MODE		= 0x5,
+	CONFIGURATION_DESC_PARAM_HIGH_PR_LUN		= 0x6,
+	CONFIGURATION_DESC_PARAM_SEC_RMV_TYPE		= 0x7,
+	CONFIGURATION_DESC_PARAM_ACTVE_ICC_LVL		= 0x8,
+	CONFIGURATION_DESC_PARAM_FRQ_RTC		= 0x9,
+	CONFIGURATION_DESC_PARAM_UNIT0			= 0x10,
+};
+
+/* Configuration unit descriptor parameter offsets in bytes */
+enum configuration_unit_desc_param {
+	CONFIGURATION_UNIT_DESC_PARAM_LU_ENABLE		= 0x0,
+	CONFIGURATION_UNIT_DESC_PARAM_BOOT_LUN_ID	= 0x1,
+	CONFIGURATION_UNIT_DESC_PARAM_LU_WR_PROTECT	= 0x2,
+	CONFIGURATION_UNIT_DESC_PARAM_MEM_TYPE		= 0x3,
+	CONFIGURATION_UNIT_DESC_PARAM_NUM_ALLOC_UNITS	= 0x4,
+	CONFIGURATION_UNIT_DESC_PARAM_DATA_RELIABILITY	= 0x8,
+	CONFIGURATION_UNIT_DESC_PARAM_LOGICAL_BLK_SIZE	= 0x9,
+	CONFIGURATION_UNIT_DESC_PARAM_PROVISIONING_TYPE	= 0xA,
+	CONFIGURATION_UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0xB,
+	CONFIGURATION_UNIT_DESC_SIZE			= 0x10,
+};
+
 /* Interconnect descriptor parameters offsets in bytes*/
 enum interconnect_desc_param {
 	INTERCONNECT_DESC_PARAM_LEN		= 0x0,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 397081d320b1..0baba3fdb112 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6603,6 +6603,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 
 	/* set the state as operational after switching to desired gear */
 	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+	ufs_sysfs_add_units(hba->dev);
 
 	/*
 	 * If we are in error handling context or in power management callbacks
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f51758f1e5cc..bb540a3fd8de 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -448,6 +448,16 @@ struct ufs_stats {
 };
 
 /**
+ * struct ufs_cfg_object - Configuration descriptor unit object.
+ * @kobj: Kernel object
+ * @index: Stores the index of the unit being described.
+ */
+struct ufs_cfg_object {
+	struct kobject kobj;
+	int index;
+};
+
+/**
  * struct ufs_hba - per adapter private structure
  * @mmio_base: UFSHCI base register address
  * @ucdl_base_addr: UFS Command Descriptor base address
@@ -501,6 +511,8 @@ struct ufs_stats {
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
  *  device is known or not.
  * @scsi_block_reqs_cnt: reference counting for scsi block requests
+ * @cfg_objects: Stores the array of kobjects created for the config descriptor.
+ * @cfg_object_count: Stores the number of elements in cfg_objects.
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -702,6 +714,9 @@ struct ufs_hba {
 	struct rw_semaphore clk_scaling_lock;
 	struct ufs_desc_size desc_size;
 	atomic_t scsi_block_reqs_cnt;
+
+	struct ufs_cfg_object **cfg_objects;
+	size_t cfg_object_count;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
-- 
2.13.5
