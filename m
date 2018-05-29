From: Evan Green <evgreen@chromium.org>
Subject: [PATCH 1/7] scsi: ufs: Add Configuration Descriptor to sysfs
Date: Tue, 29 May 2018 11:17:34 -0700
Message-ID: <20180529181740.195362-2-evgreen@chromium.org>
References: <20180529181740.195362-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529181740.195362-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gwendal Grignou <gwendal@chromium.org>, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change adds the configuration descriptor to the UFS
sysfs interface. This is done in preparation for making the
interface writable, which will enable provisioning UFS devices
via Linux.

The configuration descriptor is laid out as a header, then a set of
(usually 8) copies of the same descriptor for each unit. Rather than
creating 8 sets of the same attribute, this interface adds a cfg_unit
file, which can be set as an index that defines which of the 8
configuration unit descriptors are being shown through sysfs.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
In this change, I used cfg_unit as a selector because it matched the
precedent set by rpm_lvl and spm_lvl, and was frankly the easiest option.

It was pointed out to me that this creates a synchronization problem for
user mode, as it means only one process can be safely using this interface
at a time. If it's preferred, I can change the interface to enumerate a
sysfs group for each unit descriptor in the config descriptor.

The argument for keeping it the way it currently is goes like:
1) On the read side, all the information available here is
available elsewhere in other descriptors. I suppose that doesn't
stop apps from doing it anyway and interfering with a write.
2) On the write side, there's probably already something wrong
if more than one process is trying to provision the disk.

Let me know what you think. I think I'm leaning towards the dynamic groups,
but I could be convinced either way.
---
 drivers/scsi/ufs/ufs-sysfs.c | 97 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h       | 29 +++++++++++++
 drivers/scsi/ufs/ufshcd.h    |  3 ++
 3 files changed, 129 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 8d9332bb7d0c..a7d65492832a 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -327,6 +327,102 @@ static const struct attribute_group ufs_sysfs_device_descriptor_group = {
 	.attrs = ufs_sysfs_device_descriptor,
 };
 
+static ssize_t cfg_unit_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", hba->sysfs_config_unit);
+}
+
+static ssize_t cfg_unit_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned long max_value, value;
+
+	if (kstrtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (hba->desc_size.conf_desc < CONFIGURATION_DESC_PARAM_UNIT0)
+		return -EINVAL;
+
+	max_value = (hba->desc_size.conf_desc -
+		CONFIGURATION_DESC_PARAM_UNIT0) / CONFIGURATION_UNIT_DESC_SIZE;
+
+	if (value >= max_value)
+		return -EINVAL;
+
+	hba->sysfs_config_unit = value;
+	return count;
+}
+
+#define UFS_CONFIG_DESC_PARAM(_name, _uname, _size)			\
+	UFS_DESC_PARAM(cfg_##_name, _uname, CONFIGURATION, _size)
+
+#define UFS_CONFIG_UNIT_DESC_PARAM(_name, _uname, _size)		\
+static ssize_t unit_##_name##_show(struct device *dev,			\
+	struct device_attribute *attr, char *buf)			\
+{									\
+	struct ufs_hba *hba = dev_get_drvdata(dev);			\
+	size_t offset = CONFIGURATION_DESC_PARAM_UNIT0 +		\
+		(hba->sysfs_config_unit *				\
+		 CONFIGURATION_UNIT_DESC_SIZE) +			\
+		 CONFIGURATION_UNIT_DESC_PARAM_##_uname;		\
+	if (offset + _size > hba->desc_size.conf_desc) {		\
+		return -EINVAL;						\
+	}								\
+	return ufs_sysfs_read_desc_param(hba,				\
+		QUERY_DESC_IDN_CONFIGURATION, 0, offset, buf, _size);	\
+}									\
+static DEVICE_ATTR_RO(unit_##_name)
+
+UFS_CONFIG_DESC_PARAM(number_of_luns, _NUM_LU, 1);
+UFS_CONFIG_DESC_PARAM(boot_enable, _BOOT_ENBL, 1);
+UFS_CONFIG_DESC_PARAM(descriptor_access_enable, _DESC_ACCSS_ENBL, 1);
+UFS_CONFIG_DESC_PARAM(initial_power_mode, _INIT_PWR_MODE, 1);
+UFS_CONFIG_DESC_PARAM(high_priority_lun, _HIGH_PR_LUN, 1);
+UFS_CONFIG_DESC_PARAM(secure_removal_type, _SEC_RMV_TYPE, 1);
+UFS_CONFIG_DESC_PARAM(init_active_icc_level, _ACTVE_ICC_LVL, 1);
+UFS_CONFIG_DESC_PARAM(periodic_rtc_update, _FRQ_RTC, 2);
+DEVICE_ATTR_RW(cfg_unit);
+UFS_CONFIG_UNIT_DESC_PARAM(lu_enable, LU_ENABLE, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(boot_lun_id, BOOT_LUN_ID, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(lu_write_protect, LU_WR_PROTECT, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(memory_type, MEM_TYPE, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(allocation_units, NUM_ALLOC_UNITS, 4);
+UFS_CONFIG_UNIT_DESC_PARAM(data_reliability, DATA_RELIABILITY, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(logical_block_size, LOGICAL_BLK_SIZE, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(provisioning_type, PROVISIONING_TYPE, 1);
+UFS_CONFIG_UNIT_DESC_PARAM(context_capabilities, CTX_CAPABILITIES, 2);
+
+static struct attribute *ufs_sysfs_config_descriptor[] = {
+	&dev_attr_cfg_number_of_luns.attr,
+	&dev_attr_cfg_boot_enable.attr,
+	&dev_attr_cfg_descriptor_access_enable.attr,
+	&dev_attr_cfg_initial_power_mode.attr,
+	&dev_attr_cfg_high_priority_lun.attr,
+	&dev_attr_cfg_secure_removal_type.attr,
+	&dev_attr_cfg_init_active_icc_level.attr,
+	&dev_attr_cfg_periodic_rtc_update.attr,
+	&dev_attr_cfg_unit.attr,
+	&dev_attr_unit_lu_enable.attr,
+	&dev_attr_unit_boot_lun_id.attr,
+	&dev_attr_unit_lu_write_protect.attr,
+	&dev_attr_unit_memory_type.attr,
+	&dev_attr_unit_allocation_units.attr,
+	&dev_attr_unit_data_reliability.attr,
+	&dev_attr_unit_logical_block_size.attr,
+	&dev_attr_unit_provisioning_type.attr,
+	&dev_attr_unit_context_capabilities.attr,
+	NULL,
+};
+
+static const struct attribute_group ufs_sysfs_config_descriptor_group = {
+	.name = "config_descriptor",
+	.attrs = ufs_sysfs_config_descriptor,
+};
+
 #define UFS_INTERCONNECT_DESC_PARAM(_name, _uname, _size)		\
 	UFS_DESC_PARAM(_name, _uname, INTERCONNECT, _size)
 
@@ -713,6 +809,7 @@ static const struct attribute_group ufs_sysfs_attributes_group = {
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_default_group,
 	&ufs_sysfs_device_descriptor_group,
+	&ufs_sysfs_config_descriptor_group,
 	&ufs_sysfs_interconnect_descriptor_group,
 	&ufs_sysfs_geometry_descriptor_group,
 	&ufs_sysfs_health_descriptor_group,
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
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8110dcd04d22..fb6dcc490f21 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -683,6 +683,9 @@ struct ufs_hba {
 
 	struct rw_semaphore clk_scaling_lock;
 	struct ufs_desc_size desc_size;
+
+	/* Which unit descriptor is showing in the sysfs config descriptor. */
+	int sysfs_config_unit;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
-- 
2.13.5
