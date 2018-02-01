From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v4 02/10] ufs: sysfs: device descriptor
Date: Thu,  1 Feb 2018 18:15:38 +0200
Message-ID: <1517501746-19075-3-git-send-email-stanislav.nijnikov@wdc.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, jaegeuk@kernel.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

This patch introduces a sysfs group entry for the UFS device descriptor
parameters. The group adds "device_descriptor" folder under the UFS driver
sysfs entry (/sys/bus/platform/drivers/ufshcd/*). The parameters are shown
as hexadecimal numbers. The full information about the parameters could be
found at UFS specifications 2.1.

Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 223 +++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 123 ++++++++++++++++
 drivers/scsi/ufs/ufs.h                     |   8 ++
 drivers/scsi/ufs/ufshcd.c                  |  12 +-
 drivers/scsi/ufs/ufshcd.h                  |   6 +
 5 files changed, 366 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ufs

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
new file mode 100644
index 0000000..8da7b84
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -0,0 +1,223 @@
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_type
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the device type. This is one of the UFS
+		device descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_class
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the device class. This is one of the UFS
+		device descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_sub_class
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the UFS storage subclass. This is one of
+		the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/protocol
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the protocol supported by an UFS device.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/number_of_luns
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows number of logical units. This is one of
+		the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/number_of_wluns
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows number of well known logical units.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/boot_enable
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows value that indicates whether the device is
+		enabled for boot. This is one of the UFS device descriptor
+		parameters. The full information about the descriptor could
+		be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/descriptor_access_enable
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows value that indicates whether the device
+		descriptor could be read after partial initialization phase
+		of the boot sequence. This is one of the UFS device descriptor
+		parameters. The full information about the descriptor could
+		be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/initial_power_mode
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows value that defines the power mode after
+		device initialization or hardware reset. This is one of
+		the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/high_priority_lun
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the high priority lun. This is one of
+		the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/secure_removal_type
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the secure removal type. This is one of
+		the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/support_security_lun
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows whether the security lun is supported.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/bkops_termination_latency
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the background operations termination
+		latency. This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/initial_active_icc_level
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the initial active ICC level. This is one
+		of the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/specification_version
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the specification version. This is one
+		of the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/manufacturing_date
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the manufacturing date in BCD format.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/manufacturer_id
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the manufacturee ID. This is one of the
+		UFS device descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/rtt_capability
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the maximum number of outstanding RTTs
+		supported by the device. This is one of the UFS device
+		descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/rtc_update
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the frequency and method of the realtime
+		clock update. This is one of the UFS device descriptor
+		parameters. The full information about the descriptor
+		could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/ufs_features
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows which features are supported by the device.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be
+		found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/ffu_timeout
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the FFU timeout. This is one of the
+		UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/queue_depth
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the device queue depth. This is one of the
+		UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_version
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the device version. This is one of the
+		UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/number_of_secure_wpa
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows number of secure write protect areas
+		supported by the device. This is one of the UFS device
+		descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/psa_max_data_size
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the maximum amount of data that may be
+		written during the pre-soldering phase of the PSA flow.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/psa_state_timeout
+Date:		February 2018
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the command maximum timeout for a change
+		in PSA state. This is one of the UFS device descriptor
+		parameters. The full information about the descriptor could
+		be found at UFS specifications 2.1.
+		The file is read only.
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index cc68a90..372e281 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -12,8 +12,16 @@
 #include <linux/err.h>
 #include <linux/string.h>
 
+#include "ufs.h"
 #include "ufs-sysfs.h"
 
+enum ufs_desc_param_size {
+	UFS_PARAM_BYTE_SIZE	= 1,
+	UFS_PARAM_WORD_SIZE	= 2,
+	UFS_PARAM_DWORD_SIZE	= 4,
+	UFS_PARAM_QWORD_SIZE	= 8,
+};
+
 static const char *ufschd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
@@ -142,8 +150,123 @@ static const struct attribute_group ufs_sysfs_default_group = {
 	.attrs = ufs_sysfs_ufshcd_attrs,
 };
 
+ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
+				  enum desc_idn desc_id,
+				  u8 desc_index,
+				  u8 param_offset,
+				  u8 *sysfs_buf,
+				  u8 param_size)
+{
+	u8 desc_buf[UFS_PARAM_QWORD_SIZE] = {0};
+	int ret;
+
+	if (param_size > UFS_PARAM_QWORD_SIZE)
+		return -EINVAL;
+
+	ret = ufshcd_read_desc_param(hba, desc_id, desc_index,
+				param_offset, desc_buf, param_size);
+	if (ret)
+		return -EINVAL;
+	switch (param_size) {
+	case UFS_PARAM_BYTE_SIZE:
+		ret = sprintf(sysfs_buf, "0x%02X\n", *desc_buf);
+		break;
+	case UFS_PARAM_WORD_SIZE:
+		ret = sprintf(sysfs_buf, "0x%04X\n",
+			be16_to_cpu(*((u16 *)desc_buf)));
+		break;
+	case UFS_PARAM_DWORD_SIZE:
+		ret = sprintf(sysfs_buf, "0x%08X\n",
+			be32_to_cpu(*((u32 *)desc_buf)));
+		break;
+	case UFS_PARAM_QWORD_SIZE:
+		ret = sprintf(sysfs_buf, "0x%016llX\n",
+			be64_to_cpu(*((u64 *)desc_buf)));
+		break;
+	}
+
+	return ret;
+}
+
+#define UFS_DESC_PARAM(_name, _puname, _duname, _size)                        \
+static ssize_t _name##_show(struct device *dev,                               \
+	struct device_attribute *attr, char *buf)                             \
+{                                                                             \
+	struct ufs_hba *hba = dev_get_drvdata(dev);                           \
+	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,       \
+		0, _duname##_DESC_PARAM##_puname,                             \
+		buf, UFS_PARAM_##_size##_SIZE);                               \
+}                                                                             \
+static DEVICE_ATTR_RO(_name)
+
+#define UFS_DEVICE_DESC_PARAM(_name, _uname, _size)                           \
+	UFS_DESC_PARAM(_name, _uname, DEVICE, _size)
+
+UFS_DEVICE_DESC_PARAM(device_type, _DEVICE_TYPE, BYTE);
+UFS_DEVICE_DESC_PARAM(device_class, _DEVICE_CLASS, BYTE);
+UFS_DEVICE_DESC_PARAM(device_sub_class, _DEVICE_SUB_CLASS, BYTE);
+UFS_DEVICE_DESC_PARAM(protocol, _PRTCL, BYTE);
+UFS_DEVICE_DESC_PARAM(number_of_luns, _NUM_LU, BYTE);
+UFS_DEVICE_DESC_PARAM(number_of_wluns, _NUM_WLU, BYTE);
+UFS_DEVICE_DESC_PARAM(boot_enable, _BOOT_ENBL, BYTE);
+UFS_DEVICE_DESC_PARAM(descriptor_access_enable, _DESC_ACCSS_ENBL, BYTE);
+UFS_DEVICE_DESC_PARAM(initial_power_mode, _INIT_PWR_MODE, BYTE);
+UFS_DEVICE_DESC_PARAM(high_priority_lun, _HIGH_PR_LUN, BYTE);
+UFS_DEVICE_DESC_PARAM(secure_removal_type, _SEC_RMV_TYPE, BYTE);
+UFS_DEVICE_DESC_PARAM(support_security_lun, _SEC_LU, BYTE);
+UFS_DEVICE_DESC_PARAM(bkops_termination_latency, _BKOP_TERM_LT, BYTE);
+UFS_DEVICE_DESC_PARAM(initial_active_icc_level, _ACTVE_ICC_LVL, BYTE);
+UFS_DEVICE_DESC_PARAM(specification_version, _SPEC_VER, WORD);
+UFS_DEVICE_DESC_PARAM(manufacturing_date, _MANF_DATE, WORD);
+UFS_DEVICE_DESC_PARAM(manufacturer_id, _MANF_ID, WORD);
+UFS_DEVICE_DESC_PARAM(rtt_capability, _RTT_CAP, BYTE);
+UFS_DEVICE_DESC_PARAM(rtc_update, _FRQ_RTC, WORD);
+UFS_DEVICE_DESC_PARAM(ufs_features, _UFS_FEAT, BYTE);
+UFS_DEVICE_DESC_PARAM(ffu_timeout, _FFU_TMT, BYTE);
+UFS_DEVICE_DESC_PARAM(queue_depth, _Q_DPTH, BYTE);
+UFS_DEVICE_DESC_PARAM(device_version, _DEV_VER, WORD);
+UFS_DEVICE_DESC_PARAM(number_of_secure_wpa, _NUM_SEC_WPA, BYTE);
+UFS_DEVICE_DESC_PARAM(psa_max_data_size, _PSA_MAX_DATA, DWORD);
+UFS_DEVICE_DESC_PARAM(psa_state_timeout, _PSA_TMT, BYTE);
+
+static struct attribute *ufs_sysfs_device_descriptor[] = {
+	&dev_attr_device_type.attr,
+	&dev_attr_device_class.attr,
+	&dev_attr_device_sub_class.attr,
+	&dev_attr_protocol.attr,
+	&dev_attr_number_of_luns.attr,
+	&dev_attr_number_of_wluns.attr,
+	&dev_attr_boot_enable.attr,
+	&dev_attr_descriptor_access_enable.attr,
+	&dev_attr_initial_power_mode.attr,
+	&dev_attr_high_priority_lun.attr,
+	&dev_attr_secure_removal_type.attr,
+	&dev_attr_support_security_lun.attr,
+	&dev_attr_bkops_termination_latency.attr,
+	&dev_attr_initial_active_icc_level.attr,
+	&dev_attr_specification_version.attr,
+	&dev_attr_manufacturing_date.attr,
+	&dev_attr_manufacturer_id.attr,
+	&dev_attr_rtt_capability.attr,
+	&dev_attr_rtc_update.attr,
+	&dev_attr_ufs_features.attr,
+	&dev_attr_ffu_timeout.attr,
+	&dev_attr_queue_depth.attr,
+	&dev_attr_device_version.attr,
+	&dev_attr_number_of_secure_wpa.attr,
+	&dev_attr_psa_max_data_size.attr,
+	&dev_attr_psa_state_timeout.attr,
+	NULL,
+};
+
+static const struct attribute_group ufs_sysfs_device_descriptor_group = {
+	.name = "device_descriptor",
+	.attrs = ufs_sysfs_device_descriptor,
+};
+
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_default_group,
+	&ufs_sysfs_device_descriptor_group,
 	NULL,
 };
 
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 54deeb7..6ae1e08 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -220,6 +220,14 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_UD_LEN		= 0x1B,
 	DEVICE_DESC_PARAM_RTT_CAP		= 0x1C,
 	DEVICE_DESC_PARAM_FRQ_RTC		= 0x1D,
+	DEVICE_DESC_PARAM_UFS_FEAT		= 0x1F,
+	DEVICE_DESC_PARAM_FFU_TMT		= 0x20,
+	DEVICE_DESC_PARAM_Q_DPTH		= 0x21,
+	DEVICE_DESC_PARAM_DEV_VER		= 0x22,
+	DEVICE_DESC_PARAM_NUM_SEC_WPA		= 0x24,
+	DEVICE_DESC_PARAM_PSA_MAX_DATA		= 0x25,
+	DEVICE_DESC_PARAM_PSA_TMT		= 0x29,
+	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
 };
 
 /*
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e7621a0a..540a431 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2989,12 +2989,12 @@ EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
  *
  * Return 0 in case of success, non-zero otherwise
  */
-static int ufshcd_read_desc_param(struct ufs_hba *hba,
-				  enum desc_idn desc_id,
-				  int desc_index,
-				  u8 param_offset,
-				  u8 *param_read_buf,
-				  u8 param_size)
+int ufshcd_read_desc_param(struct ufs_hba *hba,
+			   enum desc_idn desc_id,
+			   int desc_index,
+			   u8 param_offset,
+			   u8 *param_read_buf,
+			   u8 param_size)
 {
 	int ret;
 	u8 *desc_buf;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 53e2779..38c307d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -841,6 +841,12 @@ static inline bool ufshcd_is_hs_mode(struct ufs_pa_layer_attr *pwr_info)
 }
 
 /* Expose Query-Request API */
+int ufshcd_read_desc_param(struct ufs_hba *hba,
+			   enum desc_idn desc_id,
+			   int desc_index,
+			   u8 param_offset,
+			   u8 *param_read_buf,
+			   u8 param_size);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
 int ufshcd_hold(struct ufs_hba *hba, bool async);
-- 
2.7.4
