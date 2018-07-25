From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v3] scsi: ufs: Make sysfs attributes writable
Date: Wed, 25 Jul 2018 13:14:52 -0700
Message-ID: <20180725201452.81235-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This change makes the UFS controller's sysfs attributes writable, which
will enable users to modify attributes. This can be useful during factory
provisioning for setting up critical attributes like the reference clock
frequency.

Signed-off-by: Evan Green <evgreen@chromium.org>
---
Configfs was determined to be the preferred mechanism for writing the
config descriptor, but attributes also need to be written during setup,
and are already present in sysfs. Making these attributes writable is
also helpful for debugging and experimentation.

Changes since v2:
	- Removed the configuration descriptor changes from the series,
since configfs was the preferred way to write to that, leaving only
this change.

Changes since v1:
	- Reworked the interface to show each unit of the config
descriptor as a separate directory, rather than the previous method I
had of a file for selecting the unit, and then a common set of files
that interacted with whichever unit was selected. I did some kobject
magic to accomplish this. I noticed from Greg KH's reply to Sayali's
patches [1] that configfs might be the preferred method. Let me know
if I should abandon this series in favor of Sayali's, with the
possible exception of "Make sysfs attributes writable".
	- Squashed documentation changes into their respective code
changes.
	- I decided to keep the config descriptor attributes as their
own files, rather than hiding writes behind device descriptor and unit
descriptor, as I think that's more future proof and true to the UFS spec.

[1] https://lkml.org/lkml/2018/6/8/210

 Documentation/ABI/testing/sysfs-driver-ufs | 17 +--------
 drivers/scsi/ufs/ufs-sysfs.c               | 58 ++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 016724ec26d5..44f3b9691e59 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -685,7 +685,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the boot lun enabled UFS device attribute.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/current_power_mode
 Date:		February 2018
@@ -693,7 +692,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the current power mode UFS device attribute.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/active_icc_level
 Date:		February 2018
@@ -701,7 +699,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the active icc level UFS device attribute.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/ooo_data_enabled
 Date:		February 2018
@@ -709,7 +706,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the out of order data transfer enabled UFS
 		device attribute. The full information about the attribute
 		could be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/bkops_status
 Date:		February 2018
@@ -717,7 +713,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the background operations status UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/purge_status
 Date:		February 2018
@@ -725,7 +720,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the purge operation status UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_in_size
 Date:		February 2018
@@ -733,7 +727,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows the maximum data size in a DATA IN
 		UPIU. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_out_size
 Date:		February 2018
@@ -741,7 +734,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows the maximum number of bytes that can be
 		requested with a READY TO TRANSFER UPIU. The full information
 		about the attribute could be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/reference_clock_frequency
 Date:		February 2018
@@ -749,14 +741,13 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
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
@@ -765,7 +756,6 @@ Description:	This file provides the maximum current number of
 		outstanding RTTs in device that is allowed. The full
 		information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/exception_event_control
 Date:		February 2018
@@ -773,7 +763,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the exception event control UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/exception_event_status
 Date:		February 2018
@@ -781,7 +770,6 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file provides the exception event status UFS device
 		attribute. The full information about the attribute could
 		be found at UFS specifications 2.1.
-		The file is read only.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/ffu_status
 Date:		February 2018
@@ -789,14 +777,12 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
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
@@ -805,7 +791,6 @@ Description:	This file shows the amount of data that the host plans to
 		load to all logical units in pre-soldering state.
 		The full information about the attribute could be found at
 		UFS specifications 2.1.
-		The file is read only.
 
 
 What:		/sys/class/scsi_device/*/device/dyn_cap_needed
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 8d9332bb7d0c..5e286b9d1aea 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -655,7 +655,7 @@ static const struct attribute_group ufs_sysfs_flags_group = {
 	.attrs = ufs_sysfs_device_flags,
 };
 
-#define UFS_ATTRIBUTE(_name, _uname)					\
+#define UFS_ATTRIBUTE_SHOW(_name, _uname)				\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
 {									\
@@ -665,25 +665,45 @@ static ssize_t _name##_show(struct device *dev,				\
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
2.16.4
