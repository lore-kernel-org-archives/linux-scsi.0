From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: [PATCH V1 3/3] scsi: ufs: Add sysfs support for ufs provision
Date: Fri,  1 Jun 2018 16:12:54 +0530
Message-ID: <1527849774-7623-4-git-send-email-sayalil@codeaurora.org>
References: <1527849774-7623-1-git-send-email-sayalil@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527849774-7623-1-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org
Cc: linux-scsi@vger.kernel.org, Sayali Lokhande <sayalil@codeaurora.org>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Adrian Hunter <adrian.hunter@intel.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add sysfs support to trigger ufs provisioning at runtime.
Usage : echo <desc_buf> > /sys/bus/platform/drivers/*/
	config_descriptor/ufs_provision
To check provisioning status:
cat /sys/bus/platform/drivers/*/config_descriptor/ufs_provision
1- > Success (Reboot device to check updated provisioning)

Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  16 ++++
 drivers/scsi/ufs/ufs-sysfs.c               |  25 ++++++
 drivers/scsi/ufs/ufs.h                     |   2 +
 drivers/scsi/ufs/ufshcd.c                  | 128 +++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h                  |   5 ++
 5 files changed, 176 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 016724e..43419b5 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -883,3 +883,19 @@ Contact:	Subhash Jadavani <subhashj@codeaurora.org>
 Description:	This entry shows the target state of an UFS UIC link
 		for the chosen system power management level.
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/config_descriptor/ufs_provision
+Date:		February 2018
+Contact:	Sayali Lokhande <sayalil@codeaurora.org>
+Description:	This file shows the status of runtime ufs provisioning.
+		This can be used to provision ufs device if bConfigDescrLock is 0.
+		Configuration buffer needs to be written in space separated format
+		specificied as:
+		echo <bNumberLU> <bBootEnable> <bDescrAccessEn> <bInitPowerMode>
+		<bHighPriorityLUN> <bSecureRemovalType> <bInitActiveICCLevel>
+		<wPeriodicRTCUpdate> <bConfigDescrLock> <LUNum> <bLUEnable>
+		<bBootLunID> <size_in_kb> <bDataReliability> <bLUWriteProtect>
+		<bMemoryType> <bLogicalBlockSize> <bProvisioningType>
+		<wContextCapabilities> > ufs_provision
+		To check updated configuration check unit_descriptor and
+		device_descriptor sysfs fields.
diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 8d9332b..8b68813 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -252,6 +252,30 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 	return ret;
 }
 
+static ssize_t ufs_provision_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return ufshcd_desc_config_show(dev, attr, buf);
+}
+
+static ssize_t ufs_provision_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return ufshcd_desc_config_store(dev, attr, buf, count);
+}
+
+DEVICE_ATTR_RW(ufs_provision);
+
+static struct attribute *ufs_sysfs_config_descriptor[] = {
+	&dev_attr_ufs_provision.attr,
+	NULL,
+};
+
+static const struct attribute_group ufs_sysfs_config_descriptor_group = {
+	.name = "config_descriptor",
+	.attrs = ufs_sysfs_config_descriptor,
+};
+
 #define UFS_DESC_PARAM(_name, _puname, _duname, _size)			\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
@@ -713,6 +737,7 @@ static DEVICE_ATTR_RO(_name)
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_default_group,
 	&ufs_sysfs_device_descriptor_group,
+	&ufs_sysfs_config_descriptor_group,
 	&ufs_sysfs_interconnect_descriptor_group,
 	&ufs_sysfs_geometry_descriptor_group,
 	&ufs_sysfs_health_descriptor_group,
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
index 3fd29e0..122c119 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1580,6 +1580,131 @@ void ufshcd_release(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_release);
 
+ssize_t ufshcd_desc_config_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "provision_enabled = %d\n",
+		hba->provision_enabled);
+}
+
+ssize_t ufshcd_desc_config_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
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
 static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -6532,6 +6657,9 @@ static int ufshcd_do_config_device(struct ufs_hba *hba)
 		pt = pt + 3; // Reserved fields set to 0
 	}
 
+	for (i = 0; i < buff_len; i++)
+		dev_dbg(hba->dev, " desc_buf[%d] 0x%x", i, desc_buf[i]);
+
 	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_WRITE_DESC,
 		QUERY_DESC_IDN_CONFIGURATION, 0, 0, desc_buf, &buff_len);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 982bfdf..1b8304f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -651,6 +651,7 @@ struct ufs_hba {
 	struct ufs_pwr_mode_info max_pwr_info;
 
 	struct ufs_clk_gating clk_gating;
+	bool provision_enabled;
 	/* Control to enable/disable host capabilities */
 	u32 caps;
 	/* Allow dynamic clk gating */
@@ -867,6 +868,10 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
 
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
+ssize_t ufshcd_desc_config_show(struct device *dev,
+		struct device_attribute *attr, char *buf);
+ssize_t ufshcd_desc_config_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count);
 
 int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 	int *desc_length);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
