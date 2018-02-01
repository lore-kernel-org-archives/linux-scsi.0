From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v4 08/10] ufs: sysfs: unit descriptor
Date: Thu,  1 Feb 2018 18:15:44 +0200
Message-ID: <1517501746-19075-9-git-send-email-stanislav.nijnikov@wdc.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, jaegeuk@kernel.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

This patch introduces a sysfs group entry for the UFS unit descriptor
parameters. The group adds "unit_descriptor" folder under the corresponding
SCSI device sysfs entry (/sys/class/scsi_device/*/device/). The parameters
are shown as hexadecimal numbers. The full information about the parameters
could be found at UFS specifications 2.1.
In addition the patch presents an additional field in the
scsi_host_template structure - struct attribute_group **sdev_group.
This field allows to define groups of attributes. It will provide an
ability to use binary attributes in addition to device attributes and
to group them under subfolders if necessary.

Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 108 +++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c                  |  14 ++++
 drivers/scsi/ufs/ufs-sysfs.c               |  54 +++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.h               |   2 +
 drivers/scsi/ufs/ufs.h                     |  11 +++
 drivers/scsi/ufs/ufshcd.c                  |  23 ++----
 drivers/scsi/ufs/ufshcd.h                  |  15 ++++
 include/scsi/scsi_host.h                   |   6 ++
 8 files changed, 217 insertions(+), 16 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index c17a968..57c6a90 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -490,3 +490,111 @@ Description:	This file contains a product revision string. The full
 		information about the descriptor could be found at
 		UFS specifications 2.1.
 		The file is read only.
+
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/boot_lun_id
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows boot LUN information. This is one of
+		the UFS unit descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/lun_write_protect
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows LUN write protection status. This is one of
+		the UFS unit descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/lun_queue_depth
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows LUN queue depth. This is one of the UFS
+		unit descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/psa_sensitive
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows PSA sensitivity. This is one of the UFS
+		unit descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/lun_memory_type
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows LUN memory type. This is one of the UFS
+		unit descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/data_reliability
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file defines the device behavior when a power failure
+		occurs during a write operation. This is one of the UFS
+		unit descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/logical_block_size
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the size of addressable logical blocks
+		(calculated as an exponent with base 2). This is one of
+		the UFS unit descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/logical_block_count
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows total number of addressable logical blocks.
+		This is one of the UFS unit descriptor parameters. The full
+		information about the descriptor could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/erase_block_size
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the erase block size. This is one of
+		the UFS unit descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/provisioning_type
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the thin provisioning type. This is one of
+		the UFS unit descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/physical_memory_resourse_count
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the total physical memory resources. This is
+		one of the UFS unit descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/context_capabilities
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the context capabilities. This is one of
+		the UFS unit descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/unit_descriptor/large_unit_granularity
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the granularity of the LUN. This is one of
+		the UFS unit descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index cbc0fe2..69a6a1f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1309,6 +1309,14 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		}
 	}
 
+	if (sdev->host->hostt->sdev_groups) {
+		error = sysfs_create_groups(&sdev->sdev_gendev.kobj,
+			(const struct attribute_group **)
+			sdev->host->hostt->sdev_groups);
+			if (error)
+				return error;
+	}
+
 	scsi_autopm_put_device(sdev);
 	return error;
 }
@@ -1326,6 +1334,12 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	if (sdev->sdev_state == SDEV_DEL)
 		return;
 
+	if (sdev->host->hostt->sdev_groups) {
+		sysfs_remove_groups(&sdev->sdev_gendev.kobj,
+			(const struct attribute_group **)
+			sdev->host->hostt->sdev_groups);
+	}
+
 	if (sdev->is_visible) {
 		/*
 		 * If scsi_internal_target_block() is running concurrently,
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index db5d2f8..265eca6 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -565,6 +565,60 @@ static const struct attribute_group *ufs_sysfs_groups[] = {
 	NULL,
 };
 
+#define UFS_LUN_DESC_PARAM(_pname, _puname, _duname, _size)                   \
+static ssize_t _pname##_show(struct device *dev,                              \
+	struct device_attribute *attr, char *buf)                             \
+{                                                                             \
+	struct scsi_device *sdev = to_scsi_device(dev);                       \
+	struct ufs_hba *hba = shost_priv(sdev->host);                         \
+	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);                          \
+	if (!ufs_is_valid_unit_desc_lun(lun))                                 \
+		return -EINVAL;                                               \
+	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,       \
+		lun, _duname##_DESC_PARAM##_puname,                           \
+		buf, UFS_PARAM_##_size##_SIZE);                               \
+}                                                                             \
+static DEVICE_ATTR_RO(_pname)
+
+#define UFS_UNIT_DESC_PARAM(_name, _uname, _size)                             \
+	UFS_LUN_DESC_PARAM(_name, _uname, UNIT, _size)
+
+UFS_UNIT_DESC_PARAM(boot_lun_id, _BOOT_LUN_ID, BYTE);
+UFS_UNIT_DESC_PARAM(lun_write_protect, _LU_WR_PROTECT, BYTE);
+UFS_UNIT_DESC_PARAM(lun_queue_depth, _LU_Q_DEPTH, BYTE);
+UFS_UNIT_DESC_PARAM(psa_sensitive, _PSA_SENSITIVE, BYTE);
+UFS_UNIT_DESC_PARAM(lun_memory_type, _MEM_TYPE, BYTE);
+UFS_UNIT_DESC_PARAM(data_reliability, _DATA_RELIABILITY, BYTE);
+UFS_UNIT_DESC_PARAM(logical_block_size, _LOGICAL_BLK_SIZE, BYTE);
+UFS_UNIT_DESC_PARAM(logical_block_count, _LOGICAL_BLK_COUNT, QWORD);
+UFS_UNIT_DESC_PARAM(erase_block_size, _ERASE_BLK_SIZE, DWORD);
+UFS_UNIT_DESC_PARAM(provisioning_type, _PROVISIONING_TYPE, BYTE);
+UFS_UNIT_DESC_PARAM(physical_memory_resourse_count, _PHY_MEM_RSRC_CNT, QWORD);
+UFS_UNIT_DESC_PARAM(context_capabilities, _CTX_CAPABILITIES, WORD);
+UFS_UNIT_DESC_PARAM(large_unit_granularity, _LARGE_UNIT_SIZE_M1, BYTE);
+
+static struct attribute *ufs_sysfs_unit_descriptor[] = {
+	&dev_attr_boot_lun_id.attr,
+	&dev_attr_lun_write_protect.attr,
+	&dev_attr_lun_queue_depth.attr,
+	&dev_attr_psa_sensitive.attr,
+	&dev_attr_lun_memory_type.attr,
+	&dev_attr_data_reliability.attr,
+	&dev_attr_logical_block_size.attr,
+	&dev_attr_logical_block_count.attr,
+	&dev_attr_erase_block_size.attr,
+	&dev_attr_provisioning_type.attr,
+	&dev_attr_physical_memory_resourse_count.attr,
+	&dev_attr_context_capabilities.attr,
+	&dev_attr_large_unit_granularity.attr,
+	NULL,
+};
+
+struct attribute_group ufs_sysfs_unit_descriptor_group = {
+	.name = "unit_descriptor",
+	.attrs = ufs_sysfs_unit_descriptor,
+};
+
 void ufs_sysfs_add_nodes(struct device *dev)
 {
 	int ret;
diff --git a/drivers/scsi/ufs/ufs-sysfs.h b/drivers/scsi/ufs/ufs-sysfs.h
index c53c039..4241748 100644
--- a/drivers/scsi/ufs/ufs-sysfs.h
+++ b/drivers/scsi/ufs/ufs-sysfs.h
@@ -19,4 +19,6 @@
 
 void ufs_sysfs_add_nodes(struct device *dev);
 void ufs_sysfs_remove_nodes(struct device *dev);
+
+extern struct attribute_group ufs_sysfs_unit_descriptor_group;
 #endif
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 6bfeedb..7387059 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -182,6 +182,7 @@ enum unit_desc_param {
 	UNIT_DESC_PARAM_BOOT_LUN_ID		= 0x4,
 	UNIT_DESC_PARAM_LU_WR_PROTECT		= 0x5,
 	UNIT_DESC_PARAM_LU_Q_DEPTH		= 0x6,
+	UNIT_DESC_PARAM_PSA_SENSITIVE		= 0x7,
 	UNIT_DESC_PARAM_MEM_TYPE		= 0x8,
 	UNIT_DESC_PARAM_DATA_RELIABILITY	= 0x9,
 	UNIT_DESC_PARAM_LOGICAL_BLK_SIZE	= 0xA,
@@ -592,4 +593,14 @@ struct ufs_dev_desc {
 	char model[MAX_MODEL_LEN + 1];
 };
 
+/**
+ * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descriptor
+ * @lun: LU number to check
+ * @return: true if the lun has a matching unit descriptor, false otherwise
+ */
+static inline bool ufs_is_valid_unit_desc_lun(u8 lun)
+{
+	return lun == UFS_UPIU_RPMB_WLUN || (lun < UFS_UPIU_MAX_GENERAL_LUN);
+}
+
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9cfdd8e..dcda8ac 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2222,21 +2222,6 @@ static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	return ret;
 }
 
-/*
- * ufshcd_scsi_to_upiu_lun - maps scsi LUN to UPIU LUN
- * @scsi_lun: scsi LUN id
- *
- * Returns UPIU LUN id
- */
-static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
-{
-	if (scsi_is_wlun(scsi_lun))
-		return (scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID)
-			| UFS_UPIU_WLUN_ID;
-	else
-		return scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID;
-}
-
 /**
  * ufshcd_upiu_wlun_to_scsi_wlun - maps UPIU W-LUN id to SCSI W-LUN ID
  * @scsi_lun: UPIU W-LUN id
@@ -3171,7 +3156,7 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	 * Unit descriptors are only available for general purpose LUs (LUN id
 	 * from 0 to 7) and RPMB Well known LU.
 	 */
-	if (lun != UFS_UPIU_RPMB_WLUN && (lun >= UFS_UPIU_MAX_GENERAL_LUN))
+	if (!ufs_is_valid_unit_desc_lun(lun))
 		return -EOPNOTSUPP;
 
 	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
@@ -6481,6 +6466,11 @@ static enum blk_eh_timer_return ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 	return found ? BLK_EH_NOT_HANDLED : BLK_EH_RESET_TIMER;
 }
 
+static struct attribute_group *ufshcd_driver_groups[] = {
+	&ufs_sysfs_unit_descriptor_group,
+	NULL,
+};
+
 static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
@@ -6500,6 +6490,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.can_queue		= UFSHCD_CAN_QUEUE,
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
+	.sdev_groups		= ufshcd_driver_groups,
 };
 
 static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2dad9da..f4cb31b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1003,4 +1003,19 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
 
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
+/*
+ * ufshcd_scsi_to_upiu_lun - maps scsi LUN to UPIU LUN
+ * @scsi_lun: scsi LUN id
+ *
+ * Returns UPIU LUN id
+ */
+static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
+{
+	if (scsi_is_wlun(scsi_lun))
+		return (scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID)
+			| UFS_UPIU_WLUN_ID;
+	else
+		return scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID;
+}
+
 #endif /* End of Header */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 1a1df0d..face126 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -477,6 +477,12 @@ struct scsi_host_template {
 	struct device_attribute **sdev_attrs;
 
 	/*
+	 * Pointer to the SCSI device attribute groups for this host,
+	 * NULL terminated.
+	 */
+	struct attribute_group **sdev_groups;
+
+	/*
 	 * List of hosts per template.
 	 *
 	 * This is only for use by scsi_module.c for legacy templates.
-- 
2.7.4
