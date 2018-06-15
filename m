From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v2 2/4] scsi: ufs: Make sysfs attributes writable
Date: Fri, 15 Jun 2018 14:00:47 -0700
Message-ID: <20180615210049.126123-3-evgreen@chromium.org>
References: <20180615210049.126123-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180615210049.126123-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change makes the UFS controller's sysfs attributes writable, which
will enable users to provision unprovisioned UFS devices, or
re-provision unlocked UFS devices.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
Changes since v1:
	- Fixed u32 cast in _store function as suggested by Bart.
	- Squashed documentation change into this change.

 Documentation/ABI/testing/sysfs-driver-ufs | 17 +--------
 drivers/scsi/ufs/ufs-sysfs.c               | 58 ++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index eebd95fb1db5..d7477fffe0d1 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -841,7 +841,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the boot lun enabled UFS device attribute.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/current_power_mode
 Date:		February 2018
@@ -849,7 +848,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the current power mode UFS device attribute.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/active_icc_level
 Date:		February 2018
@@ -857,7 +855,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the active icc level UFS device attribute.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/ooo_data_enabled
 Date:		February 2018
@@ -865,7 +862,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the out of order data transfer enabled UFS
 		device attribute. The full information about the attribute
 		could be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/bkops_status
 Date:		February 2018
@@ -873,7 +869,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the background operations status UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/purge_status
 Date:		February 2018
@@ -881,7 +876,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the purge operation status UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_in_size
 Date:		February 2018
@@ -889,7 +883,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows the maximum data size in a DATA IN
 		UPIU. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_out_size
 Date:		February 2018
@@ -897,7 +890,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows the maximum number of bytes that can be
 		requested with a READY TO TRANSFER UPIU. The full information
 		about the attribute could be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/reference_clock_frequency
 Date:		February 2018
@@ -905,14 +897,13 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the reference clock frequency UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/configuration_descriptor_lock
 Date:		February 2018
 Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows whether the configuration descriptor is locked.
 		The full information about the attribute could be found at
-		UFS specifications 2.1. The file is read only.
+		UFS specifications 2.1.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_number_of_rtt
 Date:		February 2018
@@ -921,7 +912,6 @@ Description:	This file provides the maximum current number of
 		outstanding RTTs in device that is allowed. The full
 		information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/exception_event_control
 Date:		February 2018
@@ -929,7 +919,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the exception event control UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/exception_event_status
 Date:		February 2018
@@ -937,7 +926,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the exception event status UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/ffu_status
 Date:		February 2018
@@ -945,14 +933,12 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the ffu status UFS device attribute.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/psa_state
 Date:		February 2018
 Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file show the PSA feature status. The full information
 		about the attribute could be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/psa_data_size
 Date:		February 2018
@@ -961,7 +947,6 @@ Description:	This file shows the amount of data that the host plans to
 		load to all logical units in pre-soldering state.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 
 What:		/sys/class/scsi_device/*/device/dyn_cap_needed
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 7ac1440c82eb..4726c05bb085 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -781,7 +781,7 @@ static const struct attribute_group ufs_sysfs_flags_group = {
 	.attrs = ufs_sysfs_device_flags,
 };
 
-#define UFS_ATTRIBUTE(_name, _uname)					\
+#define UFS_ATTRIBUTE_SHOW(_name, _uname)				\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
 {									\
@@ -791,25 +791,45 @@ static ssize_t _name##_show(struct device *dev,				\
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
+	u32 value;							\
+	if (kstrtou32(buf, 0, &value))					\
+		return -EINVAL;						\
+	if (ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,	\
+		QUERY_ATTR_IDN##_uname, 0, 0, &value))			\
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
