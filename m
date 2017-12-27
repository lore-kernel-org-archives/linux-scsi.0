From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v2 8/9] ufs: sysfs: flags
Date: Wed, 27 Dec 2017 17:13:46 +0200
Message-ID: <1514387627-27817-9-git-send-email-stanislav.nijnikov@wdc.com>
References: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

This patch introduces a sysfs group entry for the UFS flags. The group adds
"flags" folder under the UFS driver sysfs entry
(/sys/bus/platform/drivers/ufshcd/*). The flags are shown as boolean value
("true" or "false"). The full information about the UFS flags could be
found at UFS specifications 2.1.

Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 65 ++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 42 +++++++++++++++++++
 drivers/scsi/ufs/ufs.h                     | 14 +++++--
 drivers/scsi/ufs/ufshcd.c                  |  1 +
 4 files changed, 119 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 5ff8dfa..832da97 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -597,4 +597,69 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows the granularity of the LUN. This is one of
 		the UFS unit descriptor parameters. The full information
 		about the descriptor could be found at UFS specifications 2.1.
+		The file is read only.
+
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/device_init
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows the device init status. The full information
+		about the flag could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/permanent_wpe
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows whether permanent write protection is enabled.
+		The full information about the flag could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/power_on_wpe
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows whether write protection is enabled on all
+		logical units configured as power on write protected. The
+		full information about the flag could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/bkops_enable
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows whether the device background operations are
+		enabled. The full information about the flag could be
+		found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/life_span_mode_enable
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows whether the device life span mode is enabled.
+		The full information about the flag could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/phy_resource_removal
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows whether physical resource removal is enable.
+		The full information about the flag could be found at
+		UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/busy_rtc
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows whether the device is executing internal
+		operation related to real time clock. The full information
+		about the flag could be found at UFS specifications 2.1.
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/disable_fw_update
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows whether the device FW update is permanently
+		disabled. The full information about the flag could be found
+		at UFS specifications 2.1.
 		The file is read only.
\ No newline at end of file
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 509abc9..de80c20 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -427,6 +427,47 @@ static const struct attribute_group ufs_sysfs_string_descriptors_group = {
 	.attrs = ufs_sysfs_string_descriptors,
 };
 
+#define ufs_sysfs_flag_show(_name, _uname)                                    \
+static ssize_t _name##_show(struct device *dev,                               \
+	struct device_attribute *attr, char *buf)                             \
+{                                                                             \
+	bool flag;                                                            \
+	struct ufs_hba *hba = dev_get_drvdata(dev);                           \
+	if (ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,               \
+		QUERY_FLAG_IDN_##_uname, &flag))                              \
+		return -EINVAL;                                               \
+	return sprintf(buf, "%s\n", flag ? "true" : "false");                 \
+}
+
+#define UFS_FLAG(_name, _uname)                                               \
+	ufs_sysfs_flag_show(_name, _uname)                                    \
+	static DEVICE_ATTR_RO(_name)
+
+UFS_FLAG(device_init, FDEVICEINIT);
+UFS_FLAG(permanent_wpe, PERMANENT_WPE);
+UFS_FLAG(power_on_wpe, PWR_ON_WPE);
+UFS_FLAG(bkops_enable, BKOPS_EN);
+UFS_FLAG(life_span_mode_enable, LIFE_SPAN_MODE_ENABLE);
+UFS_FLAG(phy_resource_removal, FPHYRESOURCEREMOVAL);
+UFS_FLAG(busy_rtc, BUSY_RTC);
+UFS_FLAG(disable_fw_update, PERMANENTLY_DISABLE_FW_UPDATE);
+
+static struct attribute *ufs_sysfs_device_flags[] = {
+	&dev_attr_device_init.attr,
+	&dev_attr_permanent_wpe.attr,
+	&dev_attr_power_on_wpe.attr,
+	&dev_attr_bkops_enable.attr,
+	&dev_attr_life_span_mode_enable.attr,
+	&dev_attr_phy_resource_removal.attr,
+	&dev_attr_busy_rtc.attr,
+	&dev_attr_disable_fw_update.attr,
+	NULL,
+};
+
+static const struct attribute_group ufs_sysfs_flags_group = {
+	.name = "flags",
+	.attrs = ufs_sysfs_device_flags,
+};
 
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_device_descriptor_group,
@@ -435,6 +476,7 @@ static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_health_descriptor_group,
 	&ufs_sysfs_power_descriptor_group,
 	&ufs_sysfs_string_descriptors_group,
+	&ufs_sysfs_flags_group,
 	NULL,
 };
 
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 7387059..df5e73e 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -130,9 +130,17 @@ enum {
 
 /* Flag idn for Query Requests*/
 enum flag_idn {
-	QUERY_FLAG_IDN_FDEVICEINIT      = 0x01,
-	QUERY_FLAG_IDN_PWR_ON_WPE	= 0x03,
-	QUERY_FLAG_IDN_BKOPS_EN         = 0x04,
+	QUERY_FLAG_IDN_FDEVICEINIT			= 0x01,
+	QUERY_FLAG_IDN_PERMANENT_WPE			= 0x02,
+	QUERY_FLAG_IDN_PWR_ON_WPE			= 0x03,
+	QUERY_FLAG_IDN_BKOPS_EN				= 0x04,
+	QUERY_FLAG_IDN_LIFE_SPAN_MODE_ENABLE		= 0x05,
+	QUERY_FLAG_IDN_PURGE_ENABLE			= 0x06,
+	QUERY_FLAG_IDN_RESERVED2			= 0x07,
+	QUERY_FLAG_IDN_FPHYRESOURCEREMOVAL		= 0x08,
+	QUERY_FLAG_IDN_BUSY_RTC				= 0x09,
+	QUERY_FLAG_IDN_RESERVED3			= 0x0A,
+	QUERY_FLAG_IDN_PERMANENTLY_DISABLE_FW_UPDATE	= 0x0B,
 };
 
 /* Attribute idn for Query requests */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0fb89a6..72e5b9a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2699,6 +2699,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	ufshcd_release(hba);
 	return err;
 }
+EXPORT_SYMBOL(ufshcd_query_flag);
 
 /**
  * ufshcd_query_attr - API function for sending attribute requests
-- 
2.7.4
