From: Evan Green <evgreen@chromium.org>
Subject: [PATCH 3/7] scsi: ufs: Make sysfs attributes writable
Date: Tue, 29 May 2018 11:17:36 -0700
Message-ID: <20180529181740.195362-4-evgreen@chromium.org>
References: <20180529181740.195362-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529181740.195362-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gwendal Grignou <gwendal@chromium.org>, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change makes the UFS controller's sysfs attributes writable, which
will enable users to provision unprovisioned UFS devices, or
re-provision unlocked UFS devices.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
 drivers/scsi/ufs/ufs-sysfs.c | 58 +++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index a7d65492832a..51bf54e6b47a 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -751,7 +751,7 @@ static const struct attribute_group ufs_sysfs_flags_group = {
 	.attrs = ufs_sysfs_device_flags,
 };
 
-#define UFS_ATTRIBUTE(_name, _uname)					\
+#define UFS_ATTRIBUTE_SHOW(_name, _uname)				\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
 {									\
@@ -761,25 +761,45 @@ static ssize_t _name##_show(struct device *dev,				\
 		QUERY_ATTR_IDN##_uname, 0, 0, &value))			\
 		return -EINVAL;						\
 	return sprintf(buf, "0x%08X\n", value);				\
-}									\
-static DEVICE_ATTR_RO(_name)
+}
 
-UFS_ATTRIBUTE(boot_lun_enabled, _BOOT_LU_EN);
-UFS_ATTRIBUTE(current_power_mode, _POWER_MODE);
-UFS_ATTRIBUTE(active_icc_level, _ACTIVE_ICC_LVL);
-UFS_ATTRIBUTE(ooo_data_enabled, _OOO_DATA_EN);
-UFS_ATTRIBUTE(bkops_status, _BKOPS_STATUS);
-UFS_ATTRIBUTE(purge_status, _PURGE_STATUS);
-UFS_ATTRIBUTE(max_data_in_size, _MAX_DATA_IN);
-UFS_ATTRIBUTE(max_data_out_size, _MAX_DATA_OUT);
-UFS_ATTRIBUTE(reference_clock_frequency, _REF_CLK_FREQ);
-UFS_ATTRIBUTE(configuration_descriptor_lock, _CONF_DESC_LOCK);
-UFS_ATTRIBUTE(max_number_of_rtt, _MAX_NUM_OF_RTT);
-UFS_ATTRIBUTE(exception_event_control, _EE_CONTROL);
-UFS_ATTRIBUTE(exception_event_status, _EE_STATUS);
-UFS_ATTRIBUTE(ffu_status, _FFU_STATUS);
-UFS_ATTRIBUTE(psa_state, _PSA_STATE);
-UFS_ATTRIBUTE(psa_data_size, _PSA_DATA_SIZE);
+#define UFS_ATTRIBUTE_RO(_name, _uname)					\
+UFS_ATTRIBUTE_SHOW(_name, _uname)					\
+DEVICE_ATTR_RO(_name)
+
+#define UFS_ATTRIBUTE_RW(_name, _uname)					\
+UFS_ATTRIBUTE_SHOW(_name, _uname)					\
+static ssize_t _name##_store(struct device *dev,			\
+		struct device_attribute *attr, const char *buf,		\
+		size_t count)						\
+{									\
+	struct ufs_hba *hba = dev_get_drvdata(dev);			\
+	unsigned long value;						\
+	if (kstrtoul(buf, 0, &value))					\
+		return -EINVAL;						\
+	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,	\
+		QUERY_ATTR_IDN##_uname, 0, 0, (u32 *)&value))		\
+		return -EINVAL;						\
+	return count;							\
+}									\
+static DEVICE_ATTR_RW(_name)
+
+UFS_ATTRIBUTE_RW(boot_lun_enabled, _BOOT_LU_EN);
+UFS_ATTRIBUTE_RO(current_power_mode, _POWER_MODE);
+UFS_ATTRIBUTE_RW(active_icc_level, _ACTIVE_ICC_LVL);
+UFS_ATTRIBUTE_RW(ooo_data_enabled, _OOO_DATA_EN);
+UFS_ATTRIBUTE_RO(bkops_status, _BKOPS_STATUS);
+UFS_ATTRIBUTE_RO(purge_status, _PURGE_STATUS);
+UFS_ATTRIBUTE_RW(max_data_in_size, _MAX_DATA_IN);
+UFS_ATTRIBUTE_RW(max_data_out_size, _MAX_DATA_OUT);
+UFS_ATTRIBUTE_RW(reference_clock_frequency, _REF_CLK_FREQ);
+UFS_ATTRIBUTE_RW(configuration_descriptor_lock, _CONF_DESC_LOCK);
+UFS_ATTRIBUTE_RW(max_number_of_rtt, _MAX_NUM_OF_RTT);
+UFS_ATTRIBUTE_RW(exception_event_control, _EE_CONTROL);
+UFS_ATTRIBUTE_RW(exception_event_status, _EE_STATUS);
+UFS_ATTRIBUTE_RO(ffu_status, _FFU_STATUS);
+UFS_ATTRIBUTE_RO(psa_state, _PSA_STATE);
+UFS_ATTRIBUTE_RO(psa_data_size, _PSA_DATA_SIZE);
 
 static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_boot_lun_enabled.attr,
-- 
2.13.5
