From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: [PATCH V3 3/3] scsi: ufs: Add configfs support for ufs provisioning
Date: Thu, 14 Jun 2018 18:33:52 +0530
Message-ID: <1528981432-23065-4-git-send-email-sayalil@codeaurora.org>
References: <1528981432-23065-1-git-send-email-sayalil@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528981432-23065-1-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org
Cc: linux-scsi@vger.kernel.org, Sayali Lokhande <sayalil@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add configfs support to provision ufs device at runtime.
Usage:
echo <desc_buf> > /config/ufshcd/ufs_provision
To check provisioning status:
cat /config/ufshcd/ufs_provision
1 -> Success (Reboot device to check updated provisioning)

Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
---
 Documentation/ABI/testing/configfs-driver-ufs |  14 ++
 drivers/scsi/ufs/Makefile                     |   1 +
 drivers/scsi/ufs/ufs-configfs.c               | 191 ++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h                        |   2 +
 drivers/scsi/ufs/ufshcd.c                     |   2 +
 drivers/scsi/ufs/ufshcd.h                     |   7 +
 6 files changed, 217 insertions(+)
 create mode 100644 Documentation/ABI/testing/configfs-driver-ufs
 create mode 100644 drivers/scsi/ufs/ufs-configfs.c

diff --git a/Documentation/ABI/testing/configfs-driver-ufs b/Documentation/ABI/testing/configfs-driver-ufs
new file mode 100644
index 0000000..a17fe15
--- /dev/null
+++ b/Documentation/ABI/testing/configfs-driver-ufs
@@ -0,0 +1,14 @@
+What:		/config/ufshcd/ufs_provision
+Date:		Jun 2018
+KernelVersion:	4.14
+Description:
+		This file shows the status of runtime ufs provisioning.
+		This can be used to provision ufs device if bConfigDescrLock is 0.
+		Configuration buffer needs to be written in space separated format
+		specificied as:
+		echo <bNumberLU> <bBootEnable> <bDescrAccessEn> <bInitPowerMode>
+		<bHighPriorityLUN> <bSecureRemovalType> <bInitActiveICCLevel>
+		<wPeriodicRTCUpdate> <bConfigDescrLock> <LUNum> <bLUEnable>
+		<bBootLunID> <size_in_kb> <bDataReliability> <bLUWriteProtect>
+		<bMemoryType> <bLogicalBlockSize> <bProvisioningType>
+		<wContextCapabilities> > /config/ufshcd/ufs_provision
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 918f579..d438e74 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -5,5 +5,6 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-d
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-objs := ufshcd.o ufs-sysfs.o
+obj-$(CONFIG_CONFIGFS_FS) += ufs-configfs.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
diff --git a/drivers/scsi/ufs/ufs-configfs.c b/drivers/scsi/ufs/ufs-configfs.c
new file mode 100644
index 0000000..7655e6b
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-configfs.c
@@ -0,0 +1,191 @@
+/*
+ * drivers/scsi/ufs/ufs-configfs.c
+ *
+ * Copyright (c) 2018, Qualcomm Technologies, Inc.
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/string.h>
+#include <asm/unaligned.h>
+#include <linux/configfs.h>
+
+#include "ufs.h"
+#include "ufshcd.h"
+
+struct ufs_hba *hba;
+
+static ssize_t ufs_provision_show(struct config_item *item, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "provision_enabled = %x\n",
+		hba->provision_enabled);
+}
+
+ssize_t ufshcd_desc_configfs_store(const char *buf, size_t count)
+{
+	struct ufs_config_descr *cfg = &hba->cfgs;
+	char *strbuf;
+	char *strbuf_copy;
+	int desc_buf[count];
+	int *pt;
+	char *token;
+	int i, ret;
+	int value, commit = 0;
+	int num_luns = 0;
+	int KB_per_block = 4;
+
+	/* reserve one byte for null termination */
+	strbuf = kmalloc(count + 1, GFP_KERNEL);
+	if (!strbuf)
+		return -ENOMEM;
+
+	strbuf_copy = strbuf;
+	strlcpy(strbuf, buf, count + 1);
+	memset(desc_buf, 0, count);
+
+	/* Just return if bConfigDescrLock is already set */
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+		QUERY_ATTR_IDN_CONF_DESC_LOCK, 0, 0, &cfg->bConfigDescrLock);
+	if (ret) {
+		dev_err(hba->dev, "%s: Failed reading bConfigDescrLock %d, cannot re-provision device!\n",
+			__func__, ret);
+		hba->provision_enabled = 0;
+		goto out;
+	}
+	if (cfg->bConfigDescrLock == 1) {
+		dev_err(hba->dev, "%s: bConfigDescrLock already set to %u, cannot re-provision device!\n",
+		__func__, cfg->bConfigDescrLock);
+		hba->provision_enabled = 0;
+		goto out;
+	}
+
+	for (i = 0; i < count; i++) {
+		token = strsep(&strbuf, " ");
+		if (!token && i) {
+			num_luns = desc_buf[i-1];
+			dev_dbg(hba->dev, "%s: token %s, num_luns %d\n",
+				__func__, token, num_luns);
+			if (num_luns > 8) {
+				dev_err(hba->dev, "%s: Invalid num_luns %d\n",
+				__func__, num_luns);
+				hba->provision_enabled = 0;
+				goto out;
+			}
+			break;
+		}
+
+		ret = kstrtoint(token, 0, &value);
+		if (ret) {
+			dev_err(hba->dev, "%s: kstrtoint failed %d %s\n",
+				__func__, ret, token);
+			break;
+		}
+		desc_buf[i] = value;
+		dev_dbg(hba->dev, " desc_buf[%d] 0x%x", i, desc_buf[i]);
+	}
+
+	/* Fill in the descriptors with parsed configuration data */
+	pt = desc_buf;
+	cfg->bNumberLU = *pt++;
+	cfg->bBootEnable = *pt++;
+	cfg->bDescrAccessEn = *pt++;
+	cfg->bInitPowerMode = *pt++;
+	cfg->bHighPriorityLUN = *pt++;
+	cfg->bSecureRemovalType = *pt++;
+	cfg->bInitActiveICCLevel = *pt++;
+	cfg->wPeriodicRTCUpdate = *pt++;
+	cfg->bConfigDescrLock = *pt++;
+	dev_dbg(hba->dev, "%s: %u %u %u %u %u %u %u %u %u\n", __func__,
+	cfg->bNumberLU, cfg->bBootEnable, cfg->bDescrAccessEn,
+	cfg->bInitPowerMode, cfg->bHighPriorityLUN, cfg->bSecureRemovalType,
+	cfg->bInitActiveICCLevel, cfg->wPeriodicRTCUpdate,
+	cfg->bConfigDescrLock);
+
+	for (i = 0; i < num_luns; i++) {
+		cfg->unit[i].LUNum = *pt++;
+		cfg->unit[i].bLUEnable = *pt++;
+		cfg->unit[i].bBootLunID = *pt++;
+		/* dNumAllocUnits = size_in_kb/KB_per_block */
+		cfg->unit[i].dNumAllocUnits = (u32)(*pt++ / KB_per_block);
+		cfg->unit[i].bDataReliability = *pt++;
+		cfg->unit[i].bLUWriteProtect = *pt++;
+		cfg->unit[i].bMemoryType = *pt++;
+		cfg->unit[i].bLogicalBlockSize = *pt++;
+		cfg->unit[i].bProvisioningType = *pt++;
+		cfg->unit[i].wContextCapabilities = *pt++;
+	}
+
+	cfg->lun_to_grow = *pt++;
+	commit = *pt++;
+	cfg->num_luns = *pt;
+	dev_dbg(hba->dev, "%s: lun_to_grow %u, commit %u num_luns %u\n",
+		__func__, cfg->lun_to_grow, commit, cfg->num_luns);
+	if (commit == 1) {
+		ret = ufshcd_do_config_device(hba);
+		if (!ret) {
+			hba->provision_enabled = 1;
+			dev_err(hba->dev,
+			"%s: UFS Provisioning completed,num_luns %u, reboot now !\n",
+			__func__, cfg->num_luns);
+		}
+	} else
+		dev_err(hba->dev, "%s: Invalid commit %u\n", __func__, commit);
+out:
+	kfree(strbuf_copy);
+	return count;
+}
+
+static ssize_t ufs_provision_store(struct config_item *item,
+		const char *buf, size_t count)
+{
+	return ufshcd_desc_configfs_store(buf, count);
+}
+
+static struct configfs_attribute ufshcd_attr_provision = {
+	.ca_name	= "ufs_provision",
+	.ca_mode	= S_IRUGO | S_IWUGO,
+	.ca_owner	= THIS_MODULE,
+	.show		= ufs_provision_show,
+	.store		= ufs_provision_store,
+};
+
+static struct configfs_attribute *ufshcd_attrs[] = {
+	&ufshcd_attr_provision,
+	NULL,
+};
+
+static struct config_item_type ufscfg_type = {
+	.ct_attrs	= ufshcd_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct configfs_subsystem ufscfg_subsys = {
+	.su_group = {
+		.cg_item = {
+			.ci_namebuf = "ufshcd",
+			.ci_type = &ufscfg_type,
+		},
+	},
+};
+
+int ufshcd_configfs_init(struct ufs_hba *hba_ufs)
+{
+	int ret;
+	struct configfs_subsystem *subsys = &ufscfg_subsys;
+	hba = hba_ufs;
+
+	config_group_init(&subsys->su_group);
+	mutex_init(&subsys->su_mutex);
+	ret = configfs_register_subsystem(subsys);
+	if (ret) {
+		pr_err("Error %d while registering subsystem %s\n",
+		       ret,
+		       subsys->su_group.cg_item.ci_namebuf);
+	}
+	return ret;
+}
+
+void ufshcd_configfs_exit(void)
+{
+	configfs_unregister_subsystem(&ufscfg_subsys);
+}
\ No newline at end of file
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 1f99904..0b497fc 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -427,6 +427,7 @@ enum {
 };
 
 struct ufs_unit_desc {
+	u8	   LUNum;
 	u8     bLUEnable;              /* 1 for enabled LU */
 	u8     bBootLunID;             /* 0 for using this LU for boot */
 	u8     bLUWriteProtect;        /* 1 = power on WP, 2 = permanent WP */
@@ -451,6 +452,7 @@ struct ufs_config_descr {
 	u32    qVendorConfigCode;      /* Vendor specific configuration code */
 	struct ufs_unit_desc unit[8];
 	u8	lun_to_grow;
+	u8 num_luns;
 };
 
 /* Task management service response */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c0235a4..63d6532 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7854,6 +7854,7 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 void ufshcd_remove(struct ufs_hba *hba)
 {
 	ufs_sysfs_remove_nodes(hba->dev);
+	ufshcd_configfs_exit();
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
@@ -8107,6 +8108,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
+	ufshcd_configfs_init(hba);
 
 	return 0;
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 816b674..fb254c8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -41,6 +41,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/configfs.h>
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
@@ -550,6 +551,7 @@ struct ufs_hba {
 	bool is_irq_enabled;
 	u32 dev_ref_clk_freq;
 	struct ufs_config_descr cfgs;
+	bool provision_enabled;
 
 	/* Interrupt aggregation support is broken */
 	#define UFSHCD_QUIRK_BROKEN_INTR_AGGR			0x1
@@ -867,7 +869,12 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
 
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
+
+/* Expose UFS configfs API's */
 int ufshcd_do_config_device(struct ufs_hba *hba);
+ssize_t ufshcd_desc_configfs_store(const char *buf, size_t count);
+int ufshcd_configfs_init(struct ufs_hba *hba_ufs);
+void ufshcd_configfs_exit(void);
 
 int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 	int *desc_length);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
