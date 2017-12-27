From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v2 1/9] ufs: sysfs: device descriptor
Date: Wed, 27 Dec 2017 17:13:39 +0200
Message-ID: <1514387627-27817-2-git-send-email-stanislav.nijnikov@wdc.com>
References: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
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
 drivers/scsi/ufs/Makefile                  |   2 +-
 drivers/scsi/ufs/ufs-sysfs.c               | 158 ++++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.h               |  10 ++
 drivers/scsi/ufs/ufs.h                     |   8 ++
 drivers/scsi/ufs/ufshcd.c                  |  13 +-
 drivers/scsi/ufs/ufshcd.h                  |   4 +
 7 files changed, 412 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ufs
 create mode 100644 drivers/scsi/ufs/ufs-sysfs.c
 create mode 100644 drivers/scsi/ufs/ufs-sysfs.h

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
new file mode 100644
index 0000000..da39c63
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -0,0 +1,223 @@
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_type
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the device type. This is one of the UFS
+		device descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_class
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the device class. This is one of the UFS
+		device descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_sub_class
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the UFS storage subclass. This is one of
+		the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/protocol
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the protocol supported by an UFS device.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/number_of_luns
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows number of logical units. This is one of
+		the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/number_of_wluns
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows number of well known logical units.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/boot_enable
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows value that indicates whether the device is
+		enabled for boot. This is one of the UFS device descriptor
+		parameters. The full information about the descriptor could
+		be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/descriptor_access_enable
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows value that indicates whether the device
+		descriptor could be read after partial initialization phase
+		of the boot sequence. This is one of the UFS device descriptor
+		parameters. The full information about the descriptor could
+		be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/initial_power_mode
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows value that defines the power mode after
+		device initialization or hardware reset. This is one of
+		the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/high_priority_lun
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the high priority lun. This is one of
+		the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/secure_removal_type
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the secure removal type. This is one of
+		the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/support_security_lun
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows whether the security lun is supported.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/bkops_termination_latency
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the background operations termination
+		latency. This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/initial_active_icc_level
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the initial active ICC level. This is one
+		of the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/specification_version
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the specification version. This is one
+		of the UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/manufacturing_date
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the manufacturing date in BCD format.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/manufacturer_id
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the manufacturee ID. This is one of the
+		UFS device descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/rtt_capability
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the maximum number of outstanding RTTs
+		supported by the device. This is one of the UFS device
+		descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/rtc_update
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the frequency and method of the realtime
+		clock update. This is one of the UFS device descriptor
+		parameters. The full information about the descriptor
+		could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/ufs_features
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows which features are supported by the device.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be
+		found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/ffu_timeout
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the FFU timeout. This is one of the
+		UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/queue_depth
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the device queue depth. This is one of the
+		UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_version
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the device version. This is one of the
+		UFS device descriptor parameters. The full information
+		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/number_of_secure_wpa
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows number of secure write protect areas
+		supported by the device. This is one of the UFS device
+		descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/psa_max_data_size
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the maximum amount of data that may be
+		written during the pre-soldering phase of the PSA flow.
+		This is one of the UFS device descriptor parameters.
+		The full information about the descriptor could be found
+		at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/psa_state_timeout
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the command maximum timeout for a change
+		in PSA state. This is one of the UFS device descriptor
+		parameters. The full information about the descriptor could
+		be found at UFS specifications 2.1.
+		The file is read only.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 9310c6c..1fa74c1 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -3,6 +3,6 @@
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
-obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
+obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o ufs-sysfs.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
new file mode 100644
index 0000000..63a8e68
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -0,0 +1,158 @@
+#include <linux/err.h>
+#include <linux/string.h>
+
+#include "ufs.h"
+#include "ufs-sysfs.h"
+/* collision between the device descriptor parameter and the definition */
+#undef DEVICE_CLASS
+
+enum ufs_desc_param_size {
+	UFS_PARAM_BYTE_SIZE	= 1,
+	UFS_PARAM_WORD_SIZE	= 2,
+	UFS_PARAM_DWORD_SIZE	= 4,
+	UFS_PARAM_QWORD_SIZE	= 8,
+};
+
+static inline ssize_t ufs_sysfs_read_desc_param(
+	struct ufs_hba *hba, u8 desc_idn, u8 index, char *buf, u8 off,
+	enum ufs_desc_param_size param_size)
+{
+	int desc_len;
+	int ret;
+	u8 *desc_buf;
+
+	if (ufshcd_map_desc_id_to_length(hba, desc_idn, &desc_len) ||
+		off >= desc_len)
+		return -EINVAL;
+	desc_buf = kzalloc(desc_len, GFP_ATOMIC);
+	if (!desc_buf)
+		return -ENOMEM;
+	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
+		desc_idn, index, 0, desc_buf, &desc_len);
+	if (ret)
+		return -EINVAL;
+	switch (param_size) {
+	case UFS_PARAM_BYTE_SIZE:
+		ret = sprintf(buf, "0x%02X\n", desc_buf[off]);
+		break;
+	case UFS_PARAM_WORD_SIZE:
+		ret = sprintf(buf, "0x%04X\n",
+			be16_to_cpu(*((u16 *)(desc_buf + off))));
+		break;
+	case UFS_PARAM_DWORD_SIZE:
+		ret = sprintf(buf, "0x%08X\n",
+			be32_to_cpu(*((u32 *)(desc_buf + off))));
+		break;
+	case UFS_PARAM_QWORD_SIZE:
+		ret = sprintf(buf, "0x%016llX\n",
+			be64_to_cpu(*((u64 *)(desc_buf + off))));
+		break;
+	}
+	kfree(desc_buf);
+
+	return ret;
+}
+
+#define ufs_sysfs_desc_param_show(_name, _puname, _duname, _size)             \
+static ssize_t _name##_show(struct device *dev,                               \
+	struct device_attribute *attr, char *buf)                             \
+{                                                                             \
+	struct ufs_hba *hba = dev_get_drvdata(dev);                           \
+	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,       \
+		0, buf, _duname##_DESC_PARAM_##_puname,                       \
+		UFS_PARAM_##_size##_SIZE);                                    \
+}
+
+#define UFS_DESC_PARAM(_pname, _puname, _duname, _size)                       \
+	ufs_sysfs_desc_param_show(_pname, _puname, _duname, _size)            \
+	static DEVICE_ATTR_RO(_pname)
+
+#define UFS_DEVICE_DESC_PARAM(_name, _uname, _size)                           \
+	UFS_DESC_PARAM(_name, _uname, DEVICE, _size)
+
+UFS_DEVICE_DESC_PARAM(device_type, DEVICE_TYPE, BYTE);
+UFS_DEVICE_DESC_PARAM(device_class, DEVICE_CLASS, BYTE);
+UFS_DEVICE_DESC_PARAM(device_sub_class, DEVICE_SUB_CLASS, BYTE);
+UFS_DEVICE_DESC_PARAM(protocol, PRTCL, BYTE);
+UFS_DEVICE_DESC_PARAM(number_of_luns, NUM_LU, BYTE);
+UFS_DEVICE_DESC_PARAM(number_of_wluns, NUM_WLU, BYTE);
+UFS_DEVICE_DESC_PARAM(boot_enable, BOOT_ENBL, BYTE);
+UFS_DEVICE_DESC_PARAM(descriptor_access_enable, DESC_ACCSS_ENBL, BYTE);
+UFS_DEVICE_DESC_PARAM(initial_power_mode, INIT_PWR_MODE, BYTE);
+UFS_DEVICE_DESC_PARAM(high_priority_lun, HIGH_PR_LUN, BYTE);
+UFS_DEVICE_DESC_PARAM(secure_removal_type, SEC_RMV_TYPE, BYTE);
+UFS_DEVICE_DESC_PARAM(support_security_lun, SEC_LU, BYTE);
+UFS_DEVICE_DESC_PARAM(bkops_termination_latency, BKOP_TERM_LT, BYTE);
+UFS_DEVICE_DESC_PARAM(initial_active_icc_level, ACTVE_ICC_LVL, BYTE);
+UFS_DEVICE_DESC_PARAM(specification_version, SPEC_VER, WORD);
+UFS_DEVICE_DESC_PARAM(manufacturing_date, MANF_DATE, WORD);
+UFS_DEVICE_DESC_PARAM(manufacturer_id, MANF_ID, WORD);
+UFS_DEVICE_DESC_PARAM(rtt_capability, RTT_CAP, BYTE);
+UFS_DEVICE_DESC_PARAM(rtc_update, FRQ_RTC, WORD);
+UFS_DEVICE_DESC_PARAM(ufs_features, UFS_FEAT, BYTE);
+UFS_DEVICE_DESC_PARAM(ffu_timeout, FFU_TMT, BYTE);
+UFS_DEVICE_DESC_PARAM(queue_depth, Q_DPTH, BYTE);
+UFS_DEVICE_DESC_PARAM(device_version, DEV_VER, WORD);
+UFS_DEVICE_DESC_PARAM(number_of_secure_wpa, NUM_SEC_WPA, BYTE);
+UFS_DEVICE_DESC_PARAM(psa_max_data_size, PSA_MAX_DATA, DWORD);
+UFS_DEVICE_DESC_PARAM(psa_state_timeout, PSA_TMT, BYTE);
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
+static const struct attribute_group *ufs_sysfs_groups[] = {
+	&ufs_sysfs_device_descriptor_group,
+	NULL,
+};
+
+void ufs_sysfs_add_device_management(struct ufs_hba *hba)
+{
+	int ret;
+
+	ret = sysfs_create_groups(&hba->dev->kobj, ufs_sysfs_groups);
+	if (ret)
+		dev_err(hba->dev,
+			"%s: sysfs groups creation failed (err = %d)\n",
+			__func__, ret);
+}
+EXPORT_SYMBOL(ufs_sysfs_add_device_management);
+
+void ufs_sysfs_remove_device_management(struct ufs_hba *hba)
+{
+	sysfs_remove_groups(&hba->dev->kobj, ufs_sysfs_groups);
+}
+EXPORT_SYMBOL(ufs_sysfs_remove_device_management);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/ufs/ufs-sysfs.h b/drivers/scsi/ufs/ufs-sysfs.h
new file mode 100644
index 0000000..369ba21
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-sysfs.h
@@ -0,0 +1,10 @@
+#ifndef __UFS_SYSFS_H__
+#define __UFS_SYSFS_H__
+
+#include <linux/sysfs.h>
+
+#include "ufshcd.h"
+
+void ufs_sysfs_add_device_management(struct ufs_hba *hba);
+void ufs_sysfs_remove_device_management(struct ufs_hba *hba);
+#endif
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
index a355d98..6e15cda 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -44,6 +44,7 @@
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
+#include "ufs-sysfs.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ufs.h>
@@ -2894,11 +2895,10 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
  * The buf_len parameter will contain, on return, the length parameter
  * received on the response.
  */
-static int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
-					 enum query_opcode opcode,
-					 enum desc_idn idn, u8 index,
-					 u8 selector,
-					 u8 *desc_buf, int *buf_len)
+int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
+				  enum query_opcode opcode,
+				  enum desc_idn idn, u8 index, u8 selector,
+				  u8 *desc_buf, int *buf_len)
 {
 	int err;
 	int retries;
@@ -2912,6 +2912,7 @@ static int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 
 	return err;
 }
+EXPORT_SYMBOL(ufshcd_query_descriptor_retry);
 
 /**
  * ufshcd_read_desc_length - read the specified descriptor length from header
@@ -7704,10 +7705,12 @@ static inline void ufshcd_add_sysfs_nodes(struct ufs_hba *hba)
 {
 	ufshcd_add_rpm_lvl_sysfs_nodes(hba);
 	ufshcd_add_spm_lvl_sysfs_nodes(hba);
+	ufs_sysfs_add_device_management(hba);
 }
 
 static inline void ufshcd_remove_sysfs_nodes(struct ufs_hba *hba)
 {
+	ufs_sysfs_remove_device_management(hba);
 	device_remove_file(hba->dev, &hba->rpm_lvl_attr);
 	device_remove_file(hba->dev, &hba->spm_lvl_attr);
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1332e54..6a0ec4b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -841,6 +841,10 @@ static inline bool ufshcd_is_hs_mode(struct ufs_pa_layer_attr *pwr_info)
 }
 
 /* Expose Query-Request API */
+int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
+				  enum query_opcode opcode,
+				  enum desc_idn idn, u8 index, u8 selector,
+				  u8 *desc_buf, int *buf_len);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
 int ufshcd_hold(struct ufs_hba *hba, bool async);
-- 
2.7.4
