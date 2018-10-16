From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: [PATCH V15 2/2] scsi: ufs: Add configfs support for UFS provisioning
Date: Tue, 16 Oct 2018 14:29:42 +0530
Message-ID: <1539680382-31136-3-git-send-email-sayalil@codeaurora.org>
References: <1539680382-31136-1-git-send-email-sayalil@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539680382-31136-1-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org
Cc: stummala@codeaurora.org, adrian.hunter@intel.com, jlbec@evilplan.org, linux-scsi@vger.kernel.org, Sayali Lokhande <sayalil@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch adds configfs support to provision UFS device at
runtime. This feature can be primarily useful in factory or
assembly line as some devices may be required to be configured
multiple times during initial system development phase.
Configuration Descriptors can be written multiple times until
bConfigDescrLock attribute is zero.

Configuration descriptor buffer consists of Device and Unit
descriptor configurable parameters which are parsed from vendor
specific provisioning file and then passed via configfs node at
runtime to provision ufs device.
CONFIG_CONFIGFS_FS and CONFIG_SCSI_UFS_PROVISION needs to be enabled
for using this feature.

Usage:
1) To read current configuration descriptor with index X
   (where index X can be 0/1/2/3) :
   cat /config/<device_name>/ufs_config_desc_X

2) To write configuration descriptor with index X :
   echo <config_desc_buf> > /config/<device_name>/ufs_config_desc_X

Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
---
 Documentation/ABI/testing/configfs-driver-ufs |  12 ++
 drivers/scsi/ufs/Kconfig                      |  10 ++
 drivers/scsi/ufs/Makefile                     |   4 +-
 drivers/scsi/ufs/ufs-configfs.c               | 237 ++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c                     |   3 +-
 drivers/scsi/ufs/ufshcd.h                     |  18 ++
 6 files changed, 282 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-driver-ufs
 create mode 100644 drivers/scsi/ufs/ufs-configfs.c

diff --git a/Documentation/ABI/testing/configfs-driver-ufs b/Documentation/ABI/testing/configfs-driver-ufs
new file mode 100644
index 0000000..6743ea9
--- /dev/null
+++ b/Documentation/ABI/testing/configfs-driver-ufs
@@ -0,0 +1,12 @@
+What:		/config/*/ufs_config_desc_X
+Date:		Jun 2018
+KernelVersion:	4.20
+Description:
+		This file shows bytes of the current ufs configuration descriptor
+		with index X (where X = 0/1/2/3) set in device. This can be used to
+		provision ufs device if bConfigDescrLock is 0.
+		For more details, refer 14.1.6.3 Configuration Descriptor and
+		table 14-12 - Unit Descriptor configurable parameters from specs for
+		description and format of each configuration descriptor parameter.
+		Parameters of Configuration descriptor buffer for respective index
+		needs to be passed as bytes in space separated format.
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e27b4d4..6e7ff35 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -100,3 +100,13 @@ config SCSI_UFS_QCOM
 
 	  Select this if you have UFS controller on QCOM chipset.
 	  If unsure, say N.
+
+config SCSI_UFS_PROVISION
+	bool "Runtime UFS Provisioning support"
+	depends on SCSI_UFSHCD && CONFIGFS_FS
+	help
+	  This enables runtime UFS provisioning support. This can be used
+	  primarily during assembly line as some devices may be required to
+	  be configured multiple times during initial development phase.
+
+	  If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 918f579..946eac2 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -4,6 +4,8 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
-ufshcd-core-objs := ufshcd.o ufs-sysfs.o
+ufshcd-core-objs-y := ufshcd.o ufs-sysfs.o
+ufshcd-core-objs-$(CONFIG_SCSI_UFS_PROVISION) += ufs-configfs.o
+ufshcd-core-objs := $(ufshcd-core-objs-y)
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
diff --git a/drivers/scsi/ufs/ufs-configfs.c b/drivers/scsi/ufs/ufs-configfs.c
new file mode 100644
index 0000000..7be5ac3
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-configfs.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: GPL-2.0+
+// Copyright (c) 2018, Linux Foundation.
+
+#include <linux/configfs.h>
+#include <linux/err.h>
+#include <linux/string.h>
+
+#include "ufs.h"
+#include "ufshcd.h"
+
+static inline struct ufs_hba *config_item_to_hba(struct config_item *item)
+{
+	struct config_group *group = to_config_group(item);
+	struct configfs_subsystem *subsys = to_configfs_subsystem(group);
+	struct ufs_hba *hba = container_of(subsys, struct ufs_hba, subsys);
+
+	return hba;
+}
+
+static ssize_t ufs_config_desc_show(struct config_item *item, char *buf,
+				    u8 index)
+{
+	struct ufs_hba *hba = config_item_to_hba(item);
+	u8 *desc_buf = NULL;
+	int desc_buf_len = hba->desc_size.conf_desc;
+	int i, ret, curr_len = 0;
+
+	desc_buf = kzalloc(desc_buf_len, GFP_KERNEL);
+	if (!desc_buf)
+		return -ENOMEM;
+
+	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
+					    QUERY_DESC_IDN_CONFIGURATION, index,
+					    0, desc_buf, &desc_buf_len);
+	if (ret)
+		goto out;
+
+	for (i = 0; i < desc_buf_len; i++)
+		curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
+				"0x%x ", desc_buf[i]);
+
+out:
+	kfree(desc_buf);
+	return ret ? ret : curr_len;
+}
+
+ssize_t ufshcd_desc_configfs_store(struct config_item *item, const char *buf,
+				   size_t count, u8 index)
+{
+	char *strbuf;
+	char *strbuf_copy;
+	struct ufs_hba *hba = config_item_to_hba(item);
+	u8 *desc_buf = NULL;
+	int desc_buf_len = hba->desc_size.conf_desc;
+	char *token;
+	int i, ret;
+	u8 value;
+	u32 config_desc_lock = 0;
+
+	desc_buf = kzalloc(desc_buf_len, GFP_KERNEL);
+	if (!desc_buf)
+		return -ENOMEM;
+
+	strbuf = kstrdup(buf, GFP_KERNEL);
+	if (!strbuf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	strbuf_copy = strbuf;
+
+	/* Just return if bConfigDescrLock is already set */
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				QUERY_ATTR_IDN_CONF_DESC_LOCK, 0, 0,
+				&config_desc_lock);
+	if (ret)
+		goto out;
+
+	if (config_desc_lock) {
+		dev_err(hba->dev, "bConfigDescrLock already set to %u, cannot re-provision device!\n",
+			config_desc_lock);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * First read the current configuration descriptor
+	 * and then update with user provided parameters
+	 */
+	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
+					    QUERY_DESC_IDN_CONFIGURATION, index,
+					    0, desc_buf, &desc_buf_len);
+	if (ret)
+		goto out;
+
+	for (i = 0; i < desc_buf_len; i++) {
+		token = strsep(&strbuf_copy, " ");
+		if (!token)
+			break;
+
+		ret = kstrtou8(token, 0, &value);
+		if (ret) {
+			dev_err(hba->dev, "Invalid value %s writing UFS configuration descriptor %u\n",
+				token, index);
+			ret = -EINVAL;
+			goto out;
+		}
+		desc_buf[i] = value;
+	}
+
+	/* Write configuration descriptor to provision ufs */
+	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_WRITE_DESC,
+					    QUERY_DESC_IDN_CONFIGURATION, index,
+					    0, desc_buf, &desc_buf_len);
+	if (!ret)
+		dev_info(hba->dev, "UFS Configuration Descriptor %u written\n",
+			index);
+
+out:
+	kfree(strbuf);
+	kfree(desc_buf);
+	return ret ? ret : count;
+}
+
+static ssize_t ufs_config_desc_0_show(struct config_item *item, char *buf)
+{
+	return ufs_config_desc_show(item, buf, 0);
+}
+
+static ssize_t ufs_config_desc_0_store(struct config_item *item,
+				       const char *buf, size_t count)
+{
+	return ufshcd_desc_configfs_store(item, buf, count, 0);
+}
+
+static ssize_t ufs_config_desc_1_show(struct config_item *item, char *buf)
+{
+	return ufs_config_desc_show(item, buf, 1);
+}
+
+static ssize_t ufs_config_desc_1_store(struct config_item *item,
+				       const char *buf, size_t count)
+{
+	return ufshcd_desc_configfs_store(item, buf, count, 1);
+}
+
+static ssize_t ufs_config_desc_2_show(struct config_item *item, char *buf)
+{
+	return ufs_config_desc_show(item, buf, 2);
+}
+
+static ssize_t ufs_config_desc_2_store(struct config_item *item,
+				       const char *buf, size_t count)
+{
+	return ufshcd_desc_configfs_store(item, buf, count, 2);
+}
+
+static ssize_t ufs_config_desc_3_show(struct config_item *item, char *buf)
+{
+	return ufs_config_desc_show(item, buf, 3);
+}
+
+static ssize_t ufs_config_desc_3_store(struct config_item *item,
+				       const char *buf, size_t count)
+{
+	return ufshcd_desc_configfs_store(item, buf, count, 3);
+}
+
+static struct configfs_attribute ufshcd_attr_provision_0 = {
+	.ca_name	= "ufs_config_desc_0",
+	.ca_mode	= 0644,
+	.ca_owner	= THIS_MODULE,
+	.show		= ufs_config_desc_0_show,
+	.store		= ufs_config_desc_0_store,
+};
+
+static struct configfs_attribute ufshcd_attr_provision_1 = {
+	.ca_name	= "ufs_config_desc_1",
+	.ca_mode	= 0644,
+	.ca_owner	= THIS_MODULE,
+	.show		= ufs_config_desc_1_show,
+	.store		= ufs_config_desc_1_store,
+};
+
+static struct configfs_attribute ufshcd_attr_provision_2 = {
+	.ca_name	= "ufs_config_desc_2",
+	.ca_mode	= 0644,
+	.ca_owner	= THIS_MODULE,
+	.show		= ufs_config_desc_2_show,
+	.store		= ufs_config_desc_2_store,
+};
+
+static struct configfs_attribute ufshcd_attr_provision_3 = {
+	.ca_name	= "ufs_config_desc_3",
+	.ca_mode	= 0644,
+	.ca_owner	= THIS_MODULE,
+	.show		= ufs_config_desc_3_show,
+	.store		= ufs_config_desc_3_store,
+};
+
+static struct configfs_attribute *ufshcd_attrs[] = {
+	&ufshcd_attr_provision_0,
+	&ufshcd_attr_provision_1,
+	&ufshcd_attr_provision_2,
+	&ufshcd_attr_provision_3,
+	NULL,
+};
+
+static struct config_item_type ufscfg_type = {
+	.ct_attrs	= ufshcd_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
+void ufshcd_configfs_init(struct ufs_hba *hba, const char *name)
+{
+	int ret;
+	struct config_item *cg_item;
+	struct configfs_subsystem *subsys;
+
+	cg_item = &hba->subsys.su_group.cg_item;
+	snprintf(cg_item->ci_namebuf, CONFIGFS_ITEM_NAME_LEN, "%s", name);
+	cg_item->ci_type = &ufscfg_type;
+
+	subsys = &hba->subsys;
+	config_group_init(&subsys->su_group);
+	mutex_init(&subsys->su_mutex);
+	ret = configfs_register_subsystem(subsys);
+	if (ret)
+		pr_err("Error %d while registering subsystem %s\n",
+		       ret,
+		       subsys->su_group.cg_item.ci_namebuf);
+}
+
+void ufshcd_configfs_exit(struct ufs_hba *hba)
+{
+	configfs_unregister_subsystem(&hba->subsys);
+}
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9be9fa1..618e4cb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7704,6 +7704,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 void ufshcd_remove(struct ufs_hba *hba)
 {
 	ufs_sysfs_remove_nodes(hba->dev);
+	ufshcd_configfs_exit(hba);
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
@@ -7958,7 +7959,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
-
+	ufshcd_configfs_init(hba, dev_name(hba->dev));
 	return 0;
 
 out_remove_scsi_host:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4b5584b..4149647 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -37,6 +37,7 @@
 #ifndef _UFSHCD_H
 #define _UFSHCD_H
 
+#include <linux/configfs.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -515,6 +516,9 @@ struct ufs_hba {
 
 	struct Scsi_Host *host;
 	struct device *dev;
+#ifdef CONFIG_SCSI_UFS_PROVISION
+	struct configfs_subsystem subsys;
+#endif
 	/*
 	 * This field is to keep a reference to "scsi_device" corresponding to
 	 * "UFS device" W-LU.
@@ -868,6 +872,20 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
 
+/* Expose UFS configfs API's */
+#ifndef CONFIG_SCSI_UFS_PROVISION
+static inline void ufshcd_configfs_init(struct ufs_hba *hba, const char *name)
+{
+}
+
+static inline void ufshcd_configfs_exit(struct ufs_hba *hba)
+{
+}
+#else
+void ufshcd_configfs_init(struct ufs_hba *hba, const char *name);
+void ufshcd_configfs_exit(struct ufs_hba *hba);
+#endif
+
 int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 	int *desc_length);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
