From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: [PATCH RFC 3/3] scsi: ufs: Add sysfs support for ufs provision
Date: Tue, 22 May 2018 09:51:40 +0530
Message-ID: <1526962900-20683-4-git-send-email-sayalil@codeaurora.org>
References: <1526962900-20683-1-git-send-email-sayalil@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526962900-20683-1-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org
Cc: linux-scsi@vger.kernel.org, Sayali Lokhande <sayalil@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add sysfs support to trigger ufs provisioning at runtime.
Usage :
echo <desc_buf> > /sys/bus/platform/devices/1d84000.ufshcd/ufs_provision
To check provisioning status:
cat /sys/bus/platform/devices/1d84000.ufshc/ufs_provision
1 -> Success (Reboot device to check updated provisioning)

Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
---
 drivers/scsi/ufs/ufs.h    |   2 +
 drivers/scsi/ufs/ufshcd.c | 125 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h |   6 +++
 3 files changed, 132 insertions(+), 1 deletion(-)

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
index 9ae64e2..0c94885 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1580,6 +1580,106 @@ void ufshcd_release(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_release);
 
+static ssize_t ufshcd_desc_config_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", hba->ufs_provision.is_enabled);
+}
+
+static ssize_t ufshcd_desc_config_store(struct device *dev,
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
+
+	for (i = 0; i < count; i++) {
+		token = strsep(&strbuf, " ");
+		if (!token) {
+			num_luns = desc_buf[i-1];
+			dev_dbg(hba->dev, "%s: token %s, num_luns %d\n",
+				__func__, token, num_luns);
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
+			hba->ufs_provision.is_enabled = 1;
+			dev_err(hba->dev,
+			"%s: UFS Provisioning completed,num_luns %u, reboot now !\n",
+			__func__, cfg->num_luns);
+		}
+	}
+
+	kfree(strbuf_copy);
+	return count;
+}
+
 static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -1638,6 +1738,23 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 	return count;
 }
 
+static void ufshcd_init_ufs_provision(struct ufs_hba *hba)
+{
+	hba->ufs_provision.enable_attr.show = ufshcd_desc_config_show;
+	hba->ufs_provision.enable_attr.store = ufshcd_desc_config_store;
+	sysfs_attr_init(&hba->ufs_provision.enable_attr.attr);
+	hba->ufs_provision.enable_attr.attr.name = "ufs_provision";
+	hba->ufs_provision.enable_attr.attr.mode = 0644;
+	if (device_create_file(hba->dev, &hba->ufs_provision.enable_attr))
+		dev_err(hba->dev, "%s: Failed to create sysfs for ufs_provision\n",
+			__func__);
+}
+
+static void ufshcd_exit_ufs_provision(struct ufs_hba *hba)
+{
+	device_remove_file(hba->dev, &hba->ufs_provision.enable_attr);
+}
+
 static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 {
 	if (!ufshcd_is_clkgating_allowed(hba))
@@ -6383,7 +6500,7 @@ static int ufshcd_do_config_device(struct ufs_hba *hba)
 	u32 blocks_per_alloc_unit = 1024;
 	int geo_len = hba->desc_size.geom_desc;
 	u8 geo_buf[hba->desc_size.geom_desc];
-	unsigned int max_partitions = 9;
+	unsigned int max_partitions = 8;
 
 	WARN_ON(!hba || !cfg);
 	ufshcd_set_dev_ref_clk(hba);
@@ -6530,6 +6647,9 @@ static int ufshcd_do_config_device(struct ufs_hba *hba)
 		pt = pt + 3; // Reserved fields set to 0
 	}
 
+	for (i = 0; i < buff_len; i++)
+		dev_dbg(hba->dev, " desc_buf[%d] 0x%x", i, desc_buf[i]);
+
 	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_WRITE_DESC,
 		QUERY_DESC_IDN_CONFIGURATION, 0, 0, desc_buf, &buff_len);
 
@@ -7888,6 +8008,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufshcd_hba_stop(hba, true);
 
 	ufshcd_exit_clk_gating(hba);
+	ufshcd_exit_ufs_provision(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
 	ufshcd_hba_exit(hba);
@@ -8050,6 +8171,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	init_waitqueue_head(&hba->dev_cmd.tag_wq);
 
 	ufshcd_init_clk_gating(hba);
+	ufshcd_init_ufs_provision(hba);
 
 	/*
 	 * In order to avoid any spurious interrupt immediately after
@@ -8142,6 +8264,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	scsi_remove_host(hba->host);
 exit_gating:
 	ufshcd_exit_clk_gating(hba);
+	ufshcd_exit_ufs_provision(hba);
 out_disable:
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0c4b683..3580631 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -364,6 +364,11 @@ struct ufs_clk_gating {
 	int active_reqs;
 };
 
+struct ufs_provisioning {
+	struct device_attribute enable_attr;
+	bool is_enabled;
+};
+
 struct ufs_saved_pwr_info {
 	struct ufs_pa_layer_attr info;
 	bool is_valid;
@@ -652,6 +657,7 @@ struct ufs_hba {
 	struct ufs_pwr_mode_info max_pwr_info;
 
 	struct ufs_clk_gating clk_gating;
+	struct ufs_provisioning ufs_provision;
 	/* Control to enable/disable host capabilities */
 	u32 caps;
 	/* Allow dynamic clk gating */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
