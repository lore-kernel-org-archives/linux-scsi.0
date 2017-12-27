From: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: [PATCH v1 5/9] ufs: sysfs: power descriptor
Date: Wed, 27 Dec 2017 15:49:32 +0200
Message-ID: <1514382576-20542-6-git-send-email-stanislav.nijnikov@wdc.com>
References: <1514382576-20542-1-git-send-email-stanislav.nijnikov@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514382576-20542-1-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: alex.lemberg@wdc.com, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  10 +++
 drivers/scsi/ufs/ufs-sysfs.c               | 121 +++++++++++++++++++++++++++++
 2 files changed, 131 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 59399e3..7b86efd 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -440,4 +440,14 @@ Description:	This file shows indication of the device life time
 		(method b). This is one of the UFS health descriptor
 		parameters. The full information about the descriptor
 		could be found at UFS specifications 2.1.
+		The file is read only.
+
+
+What:		/sys/bus/platform/drivers/ufshcd/*/power_descriptor/active_icc_levels_vcc*
+Date:		August 2017
+Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Description:	This file shows maximum VCC, VCCQ and VCCQ2 value for
+		active ICC levels from 0 to 15. This is one of the UFS
+		power descriptor parameters. The full information about
+		the descriptor could be found at UFS specifications 2.1.
 		The file is read only.
\ No newline at end of file
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 441dc87..a1a0636 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -251,11 +251,132 @@ static const struct attribute_group ufs_sysfs_health_descriptor_group = {
 	.attrs = ufs_sysfs_health_descriptor,
 };
 
+#define ufs_sysfs_power_desc_param_show(_name, _puname, _index)               \
+static ssize_t _name##_index##_show(struct device *dev,                       \
+	struct device_attribute *attr, char *buf)                             \
+{                                                                             \
+	struct ufs_hba *hba = dev_get_drvdata(dev);                           \
+	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_POWER, 0, buf,   \
+		PWR_DESC_##_puname##_0 + _index * UFS_PARAM_WORD_SIZE,        \
+		UFS_PARAM_WORD_SIZE);                                         \
+}
+
+#define UFS_POWER_DESC_PARAM(_pname, _puname, _index)                         \
+	ufs_sysfs_power_desc_param_show(_pname, _puname, _index)              \
+	static DEVICE_ATTR_RO(_pname##_index)
+
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 0);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 1);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 2);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 3);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 4);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 5);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 6);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 7);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 8);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 9);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 10);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 11);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 12);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 13);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 14);
+UFS_POWER_DESC_PARAM(active_icc_levels_vcc, ACTIVE_LVLS_VCC, 15);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 0);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 1);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 2);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 3);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 4);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 5);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 6);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 7);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 8);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 9);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 10);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 11);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 12);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 13);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 14);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq, ACTIVE_LVLS_VCCQ, 15);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 0);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 1);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 2);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 3);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 4);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 5);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 6);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 7);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 8);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 9);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 10);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 11);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 12);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 13);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 14);
+UFS_POWER_DESC_PARAM(active_icc_levels_vccq2, ACTIVE_LVLS_VCCQ2, 15);
+
+static struct attribute *ufs_sysfs_power_descriptor[] = {
+	&dev_attr_active_icc_levels_vcc0.attr,
+	&dev_attr_active_icc_levels_vcc1.attr,
+	&dev_attr_active_icc_levels_vcc2.attr,
+	&dev_attr_active_icc_levels_vcc3.attr,
+	&dev_attr_active_icc_levels_vcc4.attr,
+	&dev_attr_active_icc_levels_vcc5.attr,
+	&dev_attr_active_icc_levels_vcc6.attr,
+	&dev_attr_active_icc_levels_vcc7.attr,
+	&dev_attr_active_icc_levels_vcc8.attr,
+	&dev_attr_active_icc_levels_vcc9.attr,
+	&dev_attr_active_icc_levels_vcc10.attr,
+	&dev_attr_active_icc_levels_vcc11.attr,
+	&dev_attr_active_icc_levels_vcc12.attr,
+	&dev_attr_active_icc_levels_vcc13.attr,
+	&dev_attr_active_icc_levels_vcc14.attr,
+	&dev_attr_active_icc_levels_vcc15.attr,
+	&dev_attr_active_icc_levels_vccq0.attr,
+	&dev_attr_active_icc_levels_vccq1.attr,
+	&dev_attr_active_icc_levels_vccq2.attr,
+	&dev_attr_active_icc_levels_vccq3.attr,
+	&dev_attr_active_icc_levels_vccq4.attr,
+	&dev_attr_active_icc_levels_vccq5.attr,
+	&dev_attr_active_icc_levels_vccq6.attr,
+	&dev_attr_active_icc_levels_vccq7.attr,
+	&dev_attr_active_icc_levels_vccq8.attr,
+	&dev_attr_active_icc_levels_vccq9.attr,
+	&dev_attr_active_icc_levels_vccq10.attr,
+	&dev_attr_active_icc_levels_vccq11.attr,
+	&dev_attr_active_icc_levels_vccq12.attr,
+	&dev_attr_active_icc_levels_vccq13.attr,
+	&dev_attr_active_icc_levels_vccq14.attr,
+	&dev_attr_active_icc_levels_vccq15.attr,
+	&dev_attr_active_icc_levels_vccq20.attr,
+	&dev_attr_active_icc_levels_vccq21.attr,
+	&dev_attr_active_icc_levels_vccq22.attr,
+	&dev_attr_active_icc_levels_vccq23.attr,
+	&dev_attr_active_icc_levels_vccq24.attr,
+	&dev_attr_active_icc_levels_vccq25.attr,
+	&dev_attr_active_icc_levels_vccq26.attr,
+	&dev_attr_active_icc_levels_vccq27.attr,
+	&dev_attr_active_icc_levels_vccq28.attr,
+	&dev_attr_active_icc_levels_vccq29.attr,
+	&dev_attr_active_icc_levels_vccq210.attr,
+	&dev_attr_active_icc_levels_vccq211.attr,
+	&dev_attr_active_icc_levels_vccq212.attr,
+	&dev_attr_active_icc_levels_vccq213.attr,
+	&dev_attr_active_icc_levels_vccq214.attr,
+	&dev_attr_active_icc_levels_vccq215.attr,
+	NULL,
+};
+
+static const struct attribute_group ufs_sysfs_power_descriptor_group = {
+	.name = "power_descriptor",
+	.attrs = ufs_sysfs_power_descriptor,
+};
+
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_device_descriptor_group,
 	&ufs_sysfs_interconnect_descriptor_group,
 	&ufs_sysfs_geometry_descriptor_group,
 	&ufs_sysfs_health_descriptor_group,
+	&ufs_sysfs_power_descriptor_group,
 	NULL,
 };
 
-- 
2.7.4
