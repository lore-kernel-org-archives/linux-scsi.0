From: Gilad Broner <gbroner@codeaurora.org>
Subject: [PATCH v3 2/4] scsi: ufs: add debugfs for ufs
Date: Mon, 23 Feb 2015 10:08:15 +0200
Message-ID: <1424678898-3723-3-git-send-email-gbroner@codeaurora.org>
References: <1424678898-3723-1-git-send-email-gbroner@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424678898-3723-1-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

From: Lee Susman <lsusman@codeaurora.org>

Adding debugfs capability for ufshcd.

debugfs attributes introduced in this patch:
 - View driver/controller runtime data
 - Command tag statistics for performance analisis
 - Dump device descriptor info
 - Track recoverable errors statistics during runtime
 - Change UFS power mode during runtime
     entry a string in the format 'GGLLMM' where:
         G - selected gear
         L - number of lanes
         M - power mode
             (1=fast mode, 2=slow mode, 4=fast-auto mode,
              5=slow-auto mode)
     First letter is for RX, second is for TX.
 - Get/set DME attributes

Signed-off-by: Lee Susman <lsusman@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
---
 drivers/scsi/ufs/Makefile      |   1 +
 drivers/scsi/ufs/ufs-debugfs.c | 902 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-debugfs.h |  38 ++
 drivers/scsi/ufs/ufshcd.c      | 225 +++++++++-
 drivers/scsi/ufs/ufshcd.h      |  65 +++
 drivers/scsi/ufs/ufshci.h      |   2 +
 6 files changed, 1221 insertions(+), 12 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-debugfs.c
 create mode 100644 drivers/scsi/ufs/ufs-debugfs.h

diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 8303bcc..0692314 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
+obj-$(CONFIG_DEBUG_FS) += ufs-debugfs.o
diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-debugfs.c
new file mode 100644
index 0000000..d1eb4f8
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-debugfs.c
@@ -0,0 +1,902 @@
+/* Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * UFS debugfs - add debugfs interface to the ufshcd.
+ * This is currently used for statistics collection and exporting from the
+ * UFS driver.
+ * This infrastructure can be used for debugging or direct tweaking
+ * of the driver from userspace.
+ *
+ */
+
+#include "ufs-debugfs.h"
+#include "unipro.h"
+
+enum field_width {
+	BYTE	= 1,
+	WORD	= 2,
+};
+
+struct desc_field_offset {
+	char *name;
+	int offset;
+	enum field_width width_byte;
+};
+
+#define UFS_ERR_STATS_PRINT(file, error_index, string, error_seen)	\
+	do {								\
+		if (err_stats[error_index]) {				\
+			seq_printf(file, string,			\
+					err_stats[error_index]);	\
+			error_seen = true;				\
+		}							\
+	} while (0)
+#define DOORBELL_CLR_TOUT_US	(1000 * 1000) /* 1 sec */
+
+#define BUFF_LINE_CAPACITY 16
+#define TAB_CHARS 8
+
+static int ufsdbg_tag_stats_show(struct seq_file *file, void *data)
+{
+	struct ufs_hba *hba = (struct ufs_hba *)file->private;
+	struct ufs_stats *ufs_stats;
+	int i, j;
+	int max_depth;
+	bool is_tag_empty = true;
+	unsigned long flags;
+	char *sep = " | * | ";
+
+	if (!hba)
+		goto exit;
+
+	ufs_stats = &hba->ufs_stats;
+
+	if (!ufs_stats->enabled) {
+		pr_debug("%s: ufs statistics are disabled\n", __func__);
+		seq_puts(file, "ufs statistics are disabled");
+		goto exit;
+	}
+
+	max_depth = hba->nutrs;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	/* Header */
+	seq_printf(file, " Tag Stat\t\t%s Queue Fullness\n", sep);
+	for (i = 0; i < TAB_CHARS * (TS_NUM_STATS + 4); i++) {
+		seq_puts(file, "-");
+		if (i == (TAB_CHARS * 3 - 1))
+			seq_puts(file, sep);
+	}
+	seq_printf(file,
+		"\n #\tnum uses\t%s\t #\tAll\t Read\t Write\t Flush\n",
+		sep);
+
+	/* values */
+	for (i = 0; i < max_depth; i++) {
+		if (ufs_stats->tag_stats[i][0] <= 0 &&
+				ufs_stats->tag_stats[i][1] <= 0 &&
+				ufs_stats->tag_stats[i][2] <= 0 &&
+				ufs_stats->tag_stats[i][3] <= 0)
+			continue;
+
+		is_tag_empty = false;
+		seq_printf(file, " %d\t ", i);
+		for (j = 0; j < TS_NUM_STATS; j++) {
+			seq_printf(file, "%llu\t ", ufs_stats->tag_stats[i][j]);
+			if (j == 0)
+				seq_printf(file, "\t%s\t %d\t%llu\t ", sep, i,
+						ufs_stats->tag_stats[i][j+1] +
+						ufs_stats->tag_stats[i][j+2]);
+		}
+		seq_puts(file, "\n");
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (is_tag_empty)
+		pr_debug("%s: All tags statistics are empty", __func__);
+
+exit:
+	return 0;
+}
+
+static int ufsdbg_tag_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufsdbg_tag_stats_show, inode->i_private);
+}
+
+static ssize_t ufsdbg_tag_stats_write(struct file *filp,
+				      const char __user *ubuf, size_t cnt,
+				       loff_t *ppos)
+{
+	struct ufs_hba *hba = filp->f_mapping->host->i_private;
+	struct ufs_stats *ufs_stats;
+	int val = 0;
+	int ret, bit = 0;
+	unsigned long flags;
+
+	ret = kstrtoint_from_user(ubuf, cnt, 0, &val);
+	if (ret) {
+		dev_err(hba->dev, "%s: Invalid argument\n", __func__);
+		return ret;
+	}
+
+	ufs_stats = &hba->ufs_stats;
+	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	if (!val) {
+		ufs_stats->enabled = false;
+		pr_debug("%s: Disabling UFS tag statistics", __func__);
+	} else {
+		ufs_stats->enabled = true;
+		pr_debug("%s: Enabling & Resetting UFS tag statistics",
+			 __func__);
+		memset(hba->ufs_stats.tag_stats[0], 0,
+			sizeof(**hba->ufs_stats.tag_stats) *
+			TS_NUM_STATS * hba->nutrs);
+
+		/* initialize current queue depth */
+		ufs_stats->q_depth = 0;
+		for_each_set_bit_from(bit, &hba->outstanding_reqs, hba->nutrs)
+			ufs_stats->q_depth++;
+		pr_debug("%s: Enabled UFS tag statistics", __func__);
+	}
+
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	return cnt;
+}
+
+static const struct file_operations ufsdbg_tag_stats_fops = {
+	.open		= ufsdbg_tag_stats_open,
+	.read		= seq_read,
+	.write		= ufsdbg_tag_stats_write,
+};
+
+static int ufsdbg_err_stats_show(struct seq_file *file, void *data)
+{
+	struct ufs_hba *hba = (struct ufs_hba *)file->private;
+	int *err_stats;
+	unsigned long flags;
+	bool error_seen = false;
+
+	if (!hba)
+		goto exit;
+
+	err_stats = hba->ufs_stats.err_stats;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	seq_puts(file, "\n==UFS errors that caused controller reset==\n");
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_HIBERN8_EXIT,
+			"controller reset due to hibern8 exit error:\t %d\n",
+			error_seen);
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_VOPS_SUSPEND,
+			"controller reset due to vops suspend error:\t\t %d\n",
+			error_seen);
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_EH,
+			"controller reset due to error handling:\t\t %d\n",
+			error_seen);
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_CLEAR_PEND_XFER_TM,
+			"controller reset due to clear xfer/tm regs:\t\t %d\n",
+			error_seen);
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_INT_FATAL_ERRORS,
+			"controller reset due to fatal interrupt:\t %d\n",
+			error_seen);
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_INT_UIC_ERROR,
+			"controller reset due to uic interrupt error:\t %d\n",
+			error_seen);
+
+	if (error_seen)
+		error_seen = false;
+	else
+		seq_puts(file,
+			"so far, no errors that caused controller reset\n\n");
+
+	seq_puts(file, "\n\n==UFS other errors==\n");
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_HIBERN8_ENTER,
+			"hibern8 enter:\t\t %d\n", error_seen);
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_RESUME,
+			"resume error:\t\t %d\n", error_seen);
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_SUSPEND,
+			"suspend error:\t\t %d\n", error_seen);
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_LINKSTARTUP,
+			"linkstartup error:\t\t %d\n", error_seen);
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_POWER_MODE_CHANGE,
+			"power change error:\t %d\n", error_seen);
+
+	UFS_ERR_STATS_PRINT(file, UFS_ERR_TASK_ABORT,
+			"abort callback:\t\t %d\n\n", error_seen);
+
+	if (!error_seen)
+		seq_puts(file,
+		"so far, no other UFS related errors\n\n");
+
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+exit:
+	return 0;
+}
+
+static int ufsdbg_err_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufsdbg_err_stats_show, inode->i_private);
+}
+
+static ssize_t ufsdbg_err_stats_write(struct file *filp,
+				      const char __user *ubuf, size_t cnt,
+				       loff_t *ppos)
+{
+	struct ufs_hba *hba = filp->f_mapping->host->i_private;
+	struct ufs_stats *ufs_stats;
+	unsigned long flags;
+
+	ufs_stats = &hba->ufs_stats;
+	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	pr_debug("%s: Resetting UFS error statistics", __func__);
+	memset(ufs_stats->err_stats, 0, sizeof(hba->ufs_stats.err_stats));
+
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	return cnt;
+}
+
+static const struct file_operations ufsdbg_err_stats_fops = {
+	.open		= ufsdbg_err_stats_open,
+	.read		= seq_read,
+	.write		= ufsdbg_err_stats_write,
+};
+
+static int ufshcd_init_statistics(struct ufs_hba *hba)
+{
+	struct ufs_stats *stats = &hba->ufs_stats;
+	int ret = 0;
+	int i;
+
+	stats->enabled = false;
+	stats->tag_stats = kcalloc(hba->nutrs, sizeof(*stats->tag_stats),
+			GFP_KERNEL);
+	if (!hba->ufs_stats.tag_stats)
+		goto no_mem;
+
+	stats->tag_stats[0] = kzalloc(sizeof(**stats->tag_stats) *
+			TS_NUM_STATS * hba->nutrs, GFP_KERNEL);
+	if (!stats->tag_stats[0])
+		goto no_mem;
+
+	for (i = 1; i < hba->nutrs; i++)
+		stats->tag_stats[i] = &stats->tag_stats[0][i * TS_NUM_STATS];
+
+	memset(stats->err_stats, 0, sizeof(hba->ufs_stats.err_stats));
+
+	goto exit;
+
+no_mem:
+	dev_err(hba->dev, "%s: Unable to allocate UFS tag_stats", __func__);
+	ret = -ENOMEM;
+exit:
+	return ret;
+}
+
+static void
+ufsdbg_pr_buf_to_std(struct seq_file *file, void *buff, int size, char *str)
+{
+	int i;
+	char linebuf[38];
+	int lines = size/BUFF_LINE_CAPACITY +
+			(size % BUFF_LINE_CAPACITY ? 1 : 0);
+
+	for (i = 0; i < lines; i++) {
+		hex_dump_to_buffer(buff + i * BUFF_LINE_CAPACITY,
+				BUFF_LINE_CAPACITY, BUFF_LINE_CAPACITY, 4,
+				linebuf, sizeof(linebuf), false);
+		seq_printf(file, "%s [%x]: %s\n", str, i * BUFF_LINE_CAPACITY,
+				linebuf);
+	}
+}
+
+static int ufsdbg_host_regs_show(struct seq_file *file, void *data)
+{
+	struct ufs_hba *hba = (struct ufs_hba *)file->private;
+
+	ufshcd_hold(hba, false);
+	pm_runtime_get_sync(hba->dev);
+	ufsdbg_pr_buf_to_std(file, hba->mmio_base, UFSHCI_REG_SPACE_SIZE,
+				"host regs");
+	pm_runtime_put_sync(hba->dev);
+	ufshcd_release(hba);
+	return 0;
+}
+
+static int ufsdbg_host_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufsdbg_host_regs_show, inode->i_private);
+}
+
+static const struct file_operations ufsdbg_host_regs_fops = {
+	.open		= ufsdbg_host_regs_open,
+	.read		= seq_read,
+};
+
+static int ufsdbg_dump_device_desc_show(struct seq_file *file, void *data)
+{
+	int err = 0;
+	int buff_len = QUERY_DESC_DEVICE_MAX_SIZE;
+	u8 desc_buf[QUERY_DESC_DEVICE_MAX_SIZE];
+	struct ufs_hba *hba = (struct ufs_hba *)file->private;
+
+	struct desc_field_offset device_desc_field_name[] = {
+		{"bLength",		0x00, BYTE},
+		{"bDescriptorType",	0x01, BYTE},
+		{"bDevice",		0x02, BYTE},
+		{"bDeviceClass",	0x03, BYTE},
+		{"bDeviceSubClass",	0x04, BYTE},
+		{"bProtocol",		0x05, BYTE},
+		{"bNumberLU",		0x06, BYTE},
+		{"bNumberWLU",		0x07, BYTE},
+		{"bBootEnable",		0x08, BYTE},
+		{"bDescrAccessEn",	0x09, BYTE},
+		{"bInitPowerMode",	0x0A, BYTE},
+		{"bHighPriorityLUN",	0x0B, BYTE},
+		{"bSecureRemovalType",	0x0C, BYTE},
+		{"bSecurityLU",		0x0D, BYTE},
+		{"Reserved",		0x0E, BYTE},
+		{"bInitActiveICCLevel",	0x0F, BYTE},
+		{"wSpecVersion",	0x10, WORD},
+		{"wManufactureDate",	0x12, WORD},
+		{"iManufactureName",	0x14, BYTE},
+		{"iProductName",	0x15, BYTE},
+		{"iSerialNumber",	0x16, BYTE},
+		{"iOemID",		0x17, BYTE},
+		{"wManufactureID",	0x18, WORD},
+		{"bUD0BaseOffset",	0x1A, BYTE},
+		{"bUDConfigPLength",	0x1B, BYTE},
+		{"bDeviceRTTCap",	0x1C, BYTE},
+		{"wPeriodicRTCUpdate",	0x1D, WORD}
+	};
+
+	pm_runtime_get_sync(hba->dev);
+	err = ufshcd_read_device_desc(hba, desc_buf, buff_len);
+	pm_runtime_put_sync(hba->dev);
+
+	if (!err) {
+		int i;
+		struct desc_field_offset *tmp;
+
+		for (i = 0; i < ARRAY_SIZE(device_desc_field_name); ++i) {
+			tmp = &device_desc_field_name[i];
+
+			if (tmp->width_byte == BYTE) {
+				seq_printf(file,
+					   "Device Descriptor[Byte offset 0x%x]: %s = 0x%x\n",
+					   tmp->offset,
+					   tmp->name,
+					   (u8)desc_buf[tmp->offset]);
+			} else if (tmp->width_byte == WORD) {
+				seq_printf(file,
+					   "Device Descriptor[Byte offset 0x%x]: %s = 0x%x\n",
+					   tmp->offset,
+					   tmp->name,
+					   *(u16 *)&desc_buf[tmp->offset]);
+			} else {
+				seq_printf(file,
+				"Device Descriptor[offset 0x%x]: %s. Wrong Width = %d",
+				tmp->offset, tmp->name, tmp->width_byte);
+			}
+		}
+	} else {
+		seq_printf(file, "Reading Device Descriptor failed. err = %d\n",
+			   err);
+	}
+
+	return err;
+}
+
+static int ufsdbg_show_hba_show(struct seq_file *file, void *data)
+{
+	struct ufs_hba *hba = (struct ufs_hba *)file->private;
+
+	seq_printf(file, "hba->outstanding_tasks = 0x%x\n",
+			(u32)hba->outstanding_tasks);
+	seq_printf(file, "hba->outstanding_reqs = 0x%x\n",
+			(u32)hba->outstanding_reqs);
+
+	seq_printf(file, "hba->capabilities = 0x%x\n", hba->capabilities);
+	seq_printf(file, "hba->nutrs = %d\n", hba->nutrs);
+	seq_printf(file, "hba->nutmrs = %d\n", hba->nutmrs);
+	seq_printf(file, "hba->ufs_version = 0x%x\n", hba->ufs_version);
+	seq_printf(file, "hba->irq = 0x%x\n", hba->irq);
+	seq_printf(file, "hba->auto_bkops_enabled = %d\n",
+			hba->auto_bkops_enabled);
+
+	seq_printf(file, "hba->ufshcd_state = 0x%x\n", hba->ufshcd_state);
+	seq_printf(file, "hba->clk_gating.state = 0x%x\n",
+			hba->clk_gating.state);
+	seq_printf(file, "hba->eh_flags = 0x%x\n", hba->eh_flags);
+	seq_printf(file, "hba->intr_mask = 0x%x\n", hba->intr_mask);
+	seq_printf(file, "hba->ee_ctrl_mask = 0x%x\n", hba->ee_ctrl_mask);
+
+	/* HBA Errors */
+	seq_printf(file, "hba->errors = 0x%x\n", hba->errors);
+	seq_printf(file, "hba->uic_error = 0x%x\n", hba->uic_error);
+	seq_printf(file, "hba->saved_err = 0x%x\n", hba->saved_err);
+	seq_printf(file, "hba->saved_uic_err = 0x%x\n", hba->saved_uic_err);
+
+	return 0;
+}
+
+static int ufsdbg_show_hba_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufsdbg_show_hba_show, inode->i_private);
+}
+
+static const struct file_operations ufsdbg_show_hba_fops = {
+	.open		= ufsdbg_show_hba_open,
+	.read		= seq_read,
+};
+
+static int ufsdbg_dump_device_desc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file,
+			   ufsdbg_dump_device_desc_show, inode->i_private);
+}
+
+static const struct file_operations ufsdbg_dump_device_desc = {
+	.open		= ufsdbg_dump_device_desc_open,
+	.read		= seq_read,
+};
+
+static int ufsdbg_power_mode_show(struct seq_file *file, void *data)
+{
+	struct ufs_hba *hba = (struct ufs_hba *)file->private;
+	static const char * const names[] = {
+		"INVALID MODE",
+		"FAST MODE",
+		"SLOW MODE",
+		"INVALID MODE",
+		"FASTAUTO MODE",
+		"SLOWAUTO MODE",
+		"INVALID MODE",
+	};
+
+	/* Print current status */
+	seq_puts(file, "UFS current power mode [RX, TX]:");
+	seq_printf(file, "gear=[%d,%d], lane=[%d,%d], pwr=[%s,%s], rate = %c",
+		 hba->pwr_info.gear_rx, hba->pwr_info.gear_tx,
+		 hba->pwr_info.lane_rx, hba->pwr_info.lane_tx,
+		 names[hba->pwr_info.pwr_rx],
+		 names[hba->pwr_info.pwr_tx],
+		 hba->pwr_info.hs_rate == PA_HS_MODE_B ? 'B' : 'A');
+	seq_puts(file, "\n\n");
+
+	/* Print usage */
+	seq_puts(file,
+		"To change power mode write 'GGLLMM' where:\n"
+		"G - selected gear\n"
+		"L - number of lanes\n"
+		"M - power mode:\n"
+		"\t1 = fast mode\n"
+		"\t2 = slow mode\n"
+		"\t4 = fast-auto mode\n"
+		"\t5 = slow-auto mode\n"
+		"first letter is for RX, second letter is for TX.\n\n");
+
+	return 0;
+}
+
+static bool ufsdbg_power_mode_validate(struct ufs_pa_layer_attr *pwr_mode)
+{
+	if (pwr_mode->gear_rx < UFS_PWM_G1 || pwr_mode->gear_rx > UFS_PWM_G7 ||
+	    pwr_mode->gear_tx < UFS_PWM_G1 || pwr_mode->gear_tx > UFS_PWM_G7 ||
+	    pwr_mode->lane_rx < 1 || pwr_mode->lane_rx > 2 ||
+	    pwr_mode->lane_tx < 1 || pwr_mode->lane_tx > 2 ||
+	    (pwr_mode->pwr_rx != FAST_MODE && pwr_mode->pwr_rx != SLOW_MODE &&
+	     pwr_mode->pwr_rx != FASTAUTO_MODE &&
+	     pwr_mode->pwr_rx != SLOWAUTO_MODE) ||
+	    (pwr_mode->pwr_tx != FAST_MODE && pwr_mode->pwr_tx != SLOW_MODE &&
+	     pwr_mode->pwr_tx != FASTAUTO_MODE &&
+	     pwr_mode->pwr_tx != SLOWAUTO_MODE)) {
+		pr_err("%s: power parameters are not valid\n", __func__);
+		return false;
+	}
+
+	return true;
+}
+
+static int ufsdbg_cfg_pwr_param(struct ufs_hba *hba,
+				struct ufs_pa_layer_attr *new_pwr,
+				struct ufs_pa_layer_attr *final_pwr)
+{
+	int ret = 0;
+	bool is_dev_sup_hs = false;
+	bool is_new_pwr_hs = false;
+	int dev_pwm_max_rx_gear;
+	int dev_pwm_max_tx_gear;
+
+	if (!hba->max_pwr_info.is_valid) {
+		dev_err(hba->dev, "%s: device max power is not valid. can't configure power\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if (hba->max_pwr_info.info.pwr_rx == FAST_MODE)
+		is_dev_sup_hs = true;
+
+	if (new_pwr->pwr_rx == FAST_MODE || new_pwr->pwr_rx == FASTAUTO_MODE)
+		is_new_pwr_hs = true;
+
+	final_pwr->lane_rx = hba->max_pwr_info.info.lane_rx;
+	final_pwr->lane_tx = hba->max_pwr_info.info.lane_tx;
+
+	/* device doesn't support HS but requested power is HS */
+	if (!is_dev_sup_hs && is_new_pwr_hs) {
+		pr_err("%s: device doesn't support HS. requested power is HS\n",
+			__func__);
+		return -ENOTSUPP;
+	} else if ((is_dev_sup_hs && is_new_pwr_hs) ||
+		   (!is_dev_sup_hs && !is_new_pwr_hs)) {
+		/*
+		 * If device and requested power mode are both HS or both PWM
+		 * then dev_max->gear_xx are the gears to be assign to
+		 * final_pwr->gear_xx
+		 */
+		final_pwr->gear_rx = hba->max_pwr_info.info.gear_rx;
+		final_pwr->gear_tx = hba->max_pwr_info.info.gear_tx;
+	} else if (is_dev_sup_hs && !is_new_pwr_hs) {
+		/*
+		 * If device supports HS but requested power is PWM, then we
+		 * need to find out what is the max gear in PWM the device
+		 * supports
+		 */
+
+		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_MAXRXPWMGEAR),
+			       &dev_pwm_max_rx_gear);
+
+		if (!dev_pwm_max_rx_gear) {
+			pr_err("%s: couldn't get device max pwm rx gear\n",
+				__func__);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXPWMGEAR),
+				    &dev_pwm_max_tx_gear);
+
+		if (!dev_pwm_max_tx_gear) {
+			pr_err("%s: couldn't get device max pwm tx gear\n",
+				__func__);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		final_pwr->gear_rx = dev_pwm_max_rx_gear;
+		final_pwr->gear_tx = dev_pwm_max_tx_gear;
+	}
+
+	if ((new_pwr->gear_rx > final_pwr->gear_rx) ||
+	    (new_pwr->gear_tx > final_pwr->gear_tx) ||
+	    (new_pwr->lane_rx > final_pwr->lane_rx) ||
+	    (new_pwr->lane_tx > final_pwr->lane_tx)) {
+		pr_err("%s: (RX,TX) GG,LL: in PWM/HS new pwr [%d%d,%d%d] exceeds device limitation [%d%d,%d%d]\n",
+			__func__,
+			new_pwr->gear_rx, new_pwr->gear_tx,
+			new_pwr->lane_rx, new_pwr->lane_tx,
+			final_pwr->gear_rx, final_pwr->gear_tx,
+			final_pwr->lane_rx, final_pwr->lane_tx);
+		return -ENOTSUPP;
+	}
+
+	final_pwr->gear_rx = new_pwr->gear_rx;
+	final_pwr->gear_tx = new_pwr->gear_tx;
+	final_pwr->lane_rx = new_pwr->lane_rx;
+	final_pwr->lane_tx = new_pwr->lane_tx;
+	final_pwr->pwr_rx = new_pwr->pwr_rx;
+	final_pwr->pwr_tx = new_pwr->pwr_tx;
+	final_pwr->hs_rate = new_pwr->hs_rate;
+
+out:
+	return ret;
+}
+
+static int ufsdbg_config_pwr_mode(struct ufs_hba *hba,
+		struct ufs_pa_layer_attr *desired_pwr_mode)
+{
+	int ret;
+
+	pm_runtime_get_sync(hba->dev);
+	scsi_block_requests(hba->host);
+	ret = ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US);
+	if (!ret)
+		ret = ufshcd_change_power_mode(hba, desired_pwr_mode);
+	scsi_unblock_requests(hba->host);
+	pm_runtime_put_sync(hba->dev);
+
+	return ret;
+}
+
+static ssize_t ufsdbg_power_mode_write(struct file *file,
+				const char __user *ubuf, size_t cnt,
+				loff_t *ppos)
+{
+	struct ufs_hba *hba = file->f_mapping->host->i_private;
+	struct ufs_pa_layer_attr pwr_mode;
+	struct ufs_pa_layer_attr final_pwr_mode;
+	char pwr_mode_str[BUFF_LINE_CAPACITY] = {0};
+	loff_t buff_pos = 0;
+	int ret;
+	int idx = 0;
+
+	ret = simple_write_to_buffer(pwr_mode_str, BUFF_LINE_CAPACITY,
+		&buff_pos, ubuf, cnt);
+
+	pwr_mode.gear_rx = pwr_mode_str[idx++] - '0';
+	pwr_mode.gear_tx = pwr_mode_str[idx++] - '0';
+	pwr_mode.lane_rx = pwr_mode_str[idx++] - '0';
+	pwr_mode.lane_tx = pwr_mode_str[idx++] - '0';
+	pwr_mode.pwr_rx = pwr_mode_str[idx++] - '0';
+	pwr_mode.pwr_tx = pwr_mode_str[idx++] - '0';
+
+	/*
+	 * Switching between rates is not currently supported so use the
+	 * current rate.
+	 * TODO: add rate switching if and when it is supported in the future
+	 */
+	pwr_mode.hs_rate = hba->pwr_info.hs_rate;
+
+	/* Validate user input */
+	if (!ufsdbg_power_mode_validate(&pwr_mode))
+		return -EINVAL;
+
+	pr_debug("%s: new power mode requested [RX,TX]: Gear=[%d,%d], Lane=[%d,%d], Mode=[%d,%d]\n",
+		__func__,
+		pwr_mode.gear_rx, pwr_mode.gear_tx, pwr_mode.lane_rx,
+		pwr_mode.lane_tx, pwr_mode.pwr_rx, pwr_mode.pwr_tx);
+
+	ret = ufsdbg_cfg_pwr_param(hba, &pwr_mode, &final_pwr_mode);
+	if (ret) {
+		dev_err(hba->dev,
+			"%s: failed to configure new power parameters, ret = %d\n",
+			__func__, ret);
+		return cnt;
+	}
+
+	ret = ufsdbg_config_pwr_mode(hba, &final_pwr_mode);
+	if (ret == -EBUSY)
+		dev_err(hba->dev,
+			"%s: ufshcd_config_pwr_mode failed: system is busy, try again\n",
+			__func__);
+	else if (ret)
+		dev_err(hba->dev,
+			"%s: ufshcd_config_pwr_mode failed, ret=%d\n",
+			__func__, ret);
+
+	return cnt;
+}
+
+static int ufsdbg_power_mode_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufsdbg_power_mode_show, inode->i_private);
+}
+
+static const struct file_operations ufsdbg_power_mode_desc = {
+	.open		= ufsdbg_power_mode_open,
+	.read		= seq_read,
+	.write		= ufsdbg_power_mode_write,
+};
+
+static int ufsdbg_dme_read(void *data, u64 *attr_val, bool peer)
+{
+	int ret;
+	struct ufs_hba *hba = data;
+	u32 attr_id, read_val = 0;
+	int (*read_func)(struct ufs_hba *, u32, u32 *);
+
+	if (!hba)
+		return -EINVAL;
+
+	read_func = peer ? ufshcd_dme_peer_get : ufshcd_dme_get;
+	attr_id = peer ? hba->debugfs_files.dme_peer_attr_id :
+			 hba->debugfs_files.dme_local_attr_id;
+	pm_runtime_get_sync(hba->dev);
+	scsi_block_requests(hba->host);
+	ret = ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US);
+	if (!ret)
+		ret = read_func(hba, UIC_ARG_MIB(attr_id), &read_val);
+	scsi_unblock_requests(hba->host);
+	pm_runtime_put_sync(hba->dev);
+
+	if (!ret)
+		*attr_val = (u64)read_val;
+
+	return ret;
+}
+
+static int ufsdbg_dme_local_set_attr_id(void *data, u64 attr_id)
+{
+	struct ufs_hba *hba = data;
+
+	if (!hba)
+		return -EINVAL;
+
+	hba->debugfs_files.dme_local_attr_id = (u32)attr_id;
+
+	return 0;
+}
+
+static int ufsdbg_dme_local_read(void *data, u64 *attr_val)
+{
+	return ufsdbg_dme_read(data, attr_val, false);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(ufsdbg_dme_local_read_ops,
+			ufsdbg_dme_local_read,
+			ufsdbg_dme_local_set_attr_id,
+			"%llu\n");
+
+static int ufsdbg_dme_peer_read(void *data, u64 *attr_val)
+{
+	struct ufs_hba *hba = data;
+
+	if (!hba)
+		return -EINVAL;
+	else
+		return ufsdbg_dme_read(data, attr_val, true);
+}
+
+static int ufsdbg_dme_peer_set_attr_id(void *data, u64 attr_id)
+{
+	struct ufs_hba *hba = data;
+
+	if (!hba)
+		return -EINVAL;
+
+	hba->debugfs_files.dme_peer_attr_id = (u32)attr_id;
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(ufsdbg_dme_peer_read_ops,
+			ufsdbg_dme_peer_read,
+			ufsdbg_dme_peer_set_attr_id,
+			"%llu\n");
+
+void ufsdbg_add_debugfs(struct ufs_hba *hba)
+{
+	char root_name[32];
+
+	if (!hba) {
+		pr_err("%s: NULL hba, exiting\n", __func__);
+		return;
+	}
+
+	snprintf(root_name, 32, "%s%d", UFSHCD, hba->host->host_no);
+
+	hba->debugfs_files.debugfs_root = debugfs_create_dir(root_name, NULL);
+	if (IS_ERR(hba->debugfs_files.debugfs_root))
+		/* Don't complain -- debugfs just isn't enabled */
+		goto err_no_root;
+	if (!hba->debugfs_files.debugfs_root) {
+		/*
+		 * Complain -- debugfs is enabled, but it failed to
+		 * create the directory
+		 */
+		dev_err(hba->dev,
+			"%s: NULL debugfs root directory, exiting", __func__);
+		goto err_no_root;
+	}
+
+	hba->debugfs_files.tag_stats =
+		debugfs_create_file("tag_stats", S_IRUSR,
+					   hba->debugfs_files.debugfs_root, hba,
+					   &ufsdbg_tag_stats_fops);
+	if (!hba->debugfs_files.tag_stats) {
+		dev_err(hba->dev, "%s:  NULL tag stats file, exiting",
+			__func__);
+		goto err;
+	}
+
+	hba->debugfs_files.err_stats =
+		debugfs_create_file("err_stats", S_IRUSR,
+					   hba->debugfs_files.debugfs_root, hba,
+					   &ufsdbg_err_stats_fops);
+	if (!hba->debugfs_files.err_stats) {
+		dev_err(hba->dev, "%s:  NULL err stats file, exiting",
+			__func__);
+		goto err;
+	}
+
+	if (ufshcd_init_statistics(hba)) {
+		dev_err(hba->dev, "%s: Error initializing statistics",
+			__func__);
+		goto err;
+	}
+
+	hba->debugfs_files.host_regs = debugfs_create_file("host_regs", S_IRUSR,
+				hba->debugfs_files.debugfs_root, hba,
+				&ufsdbg_host_regs_fops);
+	if (!hba->debugfs_files.host_regs) {
+		dev_err(hba->dev, "%s:  NULL hcd regs file, exiting", __func__);
+		goto err;
+	}
+
+	hba->debugfs_files.show_hba = debugfs_create_file("show_hba", S_IRUSR,
+				hba->debugfs_files.debugfs_root, hba,
+				&ufsdbg_show_hba_fops);
+	if (!hba->debugfs_files.show_hba) {
+		dev_err(hba->dev, "%s:  NULL hba file, exiting", __func__);
+		goto err;
+	}
+
+	hba->debugfs_files.dump_dev_desc =
+		debugfs_create_file("dump_device_desc", S_IRUSR,
+				    hba->debugfs_files.debugfs_root, hba,
+				    &ufsdbg_dump_device_desc);
+	if (!hba->debugfs_files.dump_dev_desc) {
+		dev_err(hba->dev,
+			"%s:  NULL dump_device_desc file, exiting", __func__);
+		goto err;
+	}
+
+	hba->debugfs_files.power_mode =
+		debugfs_create_file("power_mode", S_IRUSR | S_IWUSR,
+				    hba->debugfs_files.debugfs_root, hba,
+				    &ufsdbg_power_mode_desc);
+	if (!hba->debugfs_files.power_mode) {
+		dev_err(hba->dev,
+			"%s:  NULL power_mode_desc file, exiting", __func__);
+		goto err;
+	}
+
+	hba->debugfs_files.dme_local_read =
+		debugfs_create_file("dme_local_read", S_IRUSR | S_IWUSR,
+				    hba->debugfs_files.debugfs_root, hba,
+				    &ufsdbg_dme_local_read_ops);
+	if (!hba->debugfs_files.dme_local_read) {
+		dev_err(hba->dev,
+			"%s:  failed create dme_local_read debugfs entry\n",
+			__func__);
+		goto err;
+	}
+
+	hba->debugfs_files.dme_peer_read =
+		debugfs_create_file("dme_peer_read", S_IRUSR | S_IWUSR,
+				    hba->debugfs_files.debugfs_root, hba,
+				    &ufsdbg_dme_peer_read_ops);
+	if (!hba->debugfs_files.dme_peer_read) {
+		dev_err(hba->dev,
+			"%s:  failed create dme_peer_read debugfs entry\n",
+			__func__);
+		goto err;
+	}
+
+	return;
+
+err:
+	debugfs_remove_recursive(hba->debugfs_files.debugfs_root);
+	hba->debugfs_files.debugfs_root = NULL;
+err_no_root:
+	dev_err(hba->dev, "%s: failed to initialize debugfs\n", __func__);
+}
+
+void ufsdbg_remove_debugfs(struct ufs_hba *hba)
+{
+	debugfs_remove_recursive(hba->debugfs_files.debugfs_root);
+	kfree(hba->ufs_stats.tag_stats);
+
+}
diff --git a/drivers/scsi/ufs/ufs-debugfs.h b/drivers/scsi/ufs/ufs-debugfs.h
new file mode 100644
index 0000000..7ed308d
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-debugfs.h
@@ -0,0 +1,38 @@
+/* Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * UFS debugfs - add debugfs interface to the ufshcd.
+ * This is currently used for statistics collection and exporting from the
+ * UFS driver.
+ * This infrastructure can be used for debugging or direct tweaking
+ * of the driver from userspace.
+ *
+ */
+
+#ifndef _UFS_DEBUGFS_H
+#define _UFS_DEBUGFS_H
+
+#include <linux/debugfs.h>
+#include "ufshcd.h"
+
+#ifdef CONFIG_DEBUG_FS
+void ufsdbg_add_debugfs(struct ufs_hba *hba);
+void ufsdbg_remove_debugfs(struct ufs_hba *hba);
+#else
+static inline void ufsdbg_add_debugfs(struct ufs_hba *hba)
+{
+}
+static inline void ufsdbg_remove_debugfs(struct ufs_hba *hba)
+{
+}
+#endif
+
+#endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index cb357f8..84caf6d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -43,6 +43,55 @@
 
 #include "ufshcd.h"
 #include "unipro.h"
+#include "ufs-debugfs.h"
+
+#ifdef CONFIG_DEBUG_FS
+
+#define UFSHCD_UPDATE_ERROR_STATS(hba, type)	\
+	do {					\
+		if (type < UFS_ERR_MAX)	\
+			hba->ufs_stats.err_stats[type]++;	\
+	} while (0)
+
+#define UFSHCD_UPDATE_TAG_STATS(hba, tag)			\
+	do {							\
+		struct request *rq = hba->lrb[task_tag].cmd ?	\
+			hba->lrb[task_tag].cmd->request : NULL;	\
+		u64 **tag_stats = hba->ufs_stats.tag_stats;	\
+		int rq_type = -1;				\
+		if (!hba->ufs_stats.enabled)			\
+			break;					\
+		tag_stats[tag][TS_TAG]++;			\
+		if (!rq)					\
+			break;					\
+		WARN_ON(hba->ufs_stats.q_depth > hba->nutrs);	\
+		if (rq_data_dir(rq) == READ)			\
+			rq_type = TS_READ;			\
+		else if (rq_data_dir(rq) == WRITE)		\
+			rq_type = TS_WRITE;			\
+		else if (rq->cmd_flags & REQ_FLUSH)		\
+			rq_type = TS_FLUSH;			\
+		else						\
+			break;					\
+		tag_stats[hba->ufs_stats.q_depth++][rq_type]++;	\
+	} while (0)
+
+#define UFSHCD_UPDATE_TAG_STATS_COMPLETION(hba, cmd)		\
+	do {							\
+		struct request *rq = cmd ? cmd->request : NULL;	\
+		if (cmd->request &&				\
+				((rq_data_dir(rq) == READ) ||	\
+				(rq_data_dir(rq) == WRITE) ||	\
+				(rq->cmd_flags & REQ_FLUSH)))	\
+			hba->ufs_stats.q_depth--;		\
+	} while (0)
+
+#else
+#define UFSHCD_UPDATE_TAG_STATS(hba, tag)
+#define UFSHCD_UPDATE_TAG_STATS_COMPLETION(hba, cmd)
+#define UFSHCD_UPDATE_ERROR_STATS(hba, type)
+
+#endif
 
 #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
 				 UTP_TASK_REQ_COMPL |\
@@ -50,6 +99,9 @@
 /* UIC command timeout, unit: ms */
 #define UIC_CMD_TIMEOUT	500
 
+/* Retries waiting for doorbells to clear */
+#define POWER_MODE_RETRIES	10
+
 /* NOP OUT retries waiting for NOP IN response */
 #define NOP_OUT_RETRIES    10
 /* Timeout after 30 msecs if NOP OUT hangs without response */
@@ -189,8 +241,6 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
-static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-		struct ufs_pa_layer_attr *desired_pwr_mode);
 
 static inline int ufshcd_enable_irq(struct ufs_hba *hba)
 {
@@ -789,6 +839,7 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	UFSHCD_UPDATE_TAG_STATS(hba, task_tag);
 }
 
 /**
@@ -975,6 +1026,7 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	unsigned long flags;
 
 	ufshcd_hold(hba, false);
+	pm_runtime_get_sync(hba->dev);
 	mutex_lock(&hba->uic_cmd_mutex);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
@@ -983,7 +1035,7 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
 
 	mutex_unlock(&hba->uic_cmd_mutex);
-
+	pm_runtime_put_sync(hba->dev);
 	ufshcd_release(hba);
 	return ret;
 }
@@ -1866,6 +1918,27 @@ static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
 	return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
 }
 
+int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
+{
+	int err = 0;
+	int retries;
+
+	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
+		/* Read descriptor*/
+		err = ufshcd_read_desc(hba,
+				       QUERY_DESC_IDN_DEVICE, 0, buf, size);
+		if (!err)
+			break;
+		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
+	}
+
+	if (err)
+		dev_err(hba->dev, "%s: reading Device Desc failed. err = %d\n",
+			__func__, err);
+
+	return err;
+}
+
 /**
  * ufshcd_read_unit_desc_param - read the specified unit descriptor parameter
  * @hba: Pointer to adapter instance
@@ -2158,11 +2231,42 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	unsigned long flags;
 	u8 status;
 	int ret;
+	u32 tm_doorbell;
+	u32 tr_doorbell;
+	bool uic_ready;
+	int retries = POWER_MODE_RETRIES;
 
+	ufshcd_hold(hba, false);
+	pm_runtime_get_sync(hba->dev);
 	mutex_lock(&hba->uic_cmd_mutex);
 	init_completion(&uic_async_done);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	/*
+	 * Before changing the power mode there should be no outstanding
+	 * tasks/transfer requests. Verify by checking the doorbell registers
+	 * are clear.
+	 */
+	do {
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		uic_ready = ufshcd_ready_for_uic_cmd(hba);
+		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
+		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+		if (!tm_doorbell && !tr_doorbell && uic_ready)
+			break;
+
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		schedule();
+		retries--;
+	} while (retries && (tm_doorbell || tr_doorbell || !uic_ready));
+
+	if (!retries) {
+		dev_err(hba->dev,
+			"%s: too many retries waiting for doorbell to clear (tm=0x%x, tr=0x%x, uicrdy=%d)\n",
+			__func__, tm_doorbell, tr_doorbell, uic_ready);
+		ret = -EBUSY;
+		goto out;
+	}
+
 	hba->uic_async_done = &uic_async_done;
 	ret = __ufshcd_send_uic_cmd(hba, cmd);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -2201,7 +2305,56 @@ out:
 	hba->uic_async_done = NULL;
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
+	pm_runtime_put_sync(hba->dev);
+	ufshcd_release(hba);
+	return ret;
+}
+
+int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba, u64 wait_timeout_us)
+{
+	unsigned long flags;
+	int ret = 0;
+	u32 tm_doorbell;
+	u32 tr_doorbell;
+	bool timeout = false;
+	ktime_t start = ktime_get();
+
+	ufshcd_hold(hba, false);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+		ret = -EBUSY;
+		goto out;
+	}
 
+	/*
+	 * Wait for all the outstanding tasks/transfer requests.
+	 * Verify by checking the doorbell registers are clear.
+	 */
+	do {
+		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
+		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+		if (!tm_doorbell && !tr_doorbell) {
+			timeout = false;
+			break;
+		}
+
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		schedule();
+		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
+		    wait_timeout_us)
+			timeout = true;
+		spin_lock_irqsave(hba->host->host_lock, flags);
+	} while (tm_doorbell || tr_doorbell);
+
+	if (timeout) {
+		dev_err(hba->dev,
+			"%s: timedout waiting for doorbell to clear (tm=0x%x, tr=0x%x)\n",
+			__func__, tm_doorbell, tr_doorbell);
+		ret = -EBUSY;
+	}
+out:
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ufshcd_release(hba);
 	return ret;
 }
 
@@ -2230,11 +2383,20 @@ static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 {
+	int ret;
 	struct uic_command uic_cmd = {0};
 
 	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
 
-	return ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
+
+	if (ret) {
+		UFSHCD_UPDATE_ERROR_STATS(hba, UFS_ERR_HIBERN8_ENTER);
+		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d",
+			__func__, ret);
+	}
+
+	return ret;
 }
 
 static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
@@ -2246,6 +2408,9 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	if (ret) {
 		ufshcd_set_link_off(hba);
+		UFSHCD_UPDATE_ERROR_STATS(hba, UFS_ERR_HIBERN8_EXIT);
+		dev_err(hba->dev, "%s: hibern8 exit failed. ret = %d",
+			__func__, ret);
 		ret = ufshcd_host_reset_and_restore(hba);
 	}
 
@@ -2279,8 +2444,8 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 	if (hba->max_pwr_info.is_valid)
 		return 0;
 
-	pwr_info->pwr_tx = FASTAUTO_MODE;
-	pwr_info->pwr_rx = FASTAUTO_MODE;
+	pwr_info->pwr_tx = FAST_MODE;
+	pwr_info->pwr_rx = FAST_MODE;
 	pwr_info->hs_rate = PA_HS_MODE_B;
 
 	/* Get the connected lane count */
@@ -2311,7 +2476,7 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 				__func__, pwr_info->gear_rx);
 			return -EINVAL;
 		}
-		pwr_info->pwr_rx = SLOWAUTO_MODE;
+		pwr_info->pwr_rx = SLOW_MODE;
 	}
 
 	ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR),
@@ -2324,14 +2489,14 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 				__func__, pwr_info->gear_tx);
 			return -EINVAL;
 		}
-		pwr_info->pwr_tx = SLOWAUTO_MODE;
+		pwr_info->pwr_tx = SLOW_MODE;
 	}
 
 	hba->max_pwr_info.is_valid = true;
 	return 0;
 }
 
-static int ufshcd_change_power_mode(struct ufs_hba *hba,
+int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode)
 {
 	int ret;
@@ -2383,6 +2548,7 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			| pwr_mode->pwr_tx);
 
 	if (ret) {
+		UFSHCD_UPDATE_ERROR_STATS(hba, UFS_ERR_POWER_MODE_CHANGE);
 		dev_err(hba->dev,
 			"%s: power mode change failed %d\n", __func__, ret);
 	} else {
@@ -2613,9 +2779,12 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 			hba->vops->link_startup_notify(hba, PRE_CHANGE);
 
 		ret = ufshcd_dme_link_startup(hba);
+		if (ret)
+			UFSHCD_UPDATE_ERROR_STATS(hba, UFS_ERR_LINKSTARTUP);
 
 		/* check if device is detected by inter-connect layer */
 		if (!ret && !ufshcd_is_device_present(hba)) {
+			UFSHCD_UPDATE_ERROR_STATS(hba, UFS_ERR_LINKSTARTUP);
 			dev_err(hba->dev, "%s: Device not present\n", __func__);
 			ret = -ENXIO;
 			goto out;
@@ -3051,6 +3220,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 		lrbp = &hba->lrb[index];
 		cmd = lrbp->cmd;
 		if (cmd) {
+			UFSHCD_UPDATE_TAG_STATS_COMPLETION(hba, cmd);
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
 			cmd->result = result;
@@ -3382,6 +3552,19 @@ static void ufshcd_err_handler(struct work_struct *work)
 	if (err_xfer || err_tm || (hba->saved_err & INT_FATAL_ERRORS) ||
 			((hba->saved_err & UIC_ERROR) &&
 			 (hba->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR))) {
+
+		if (hba->saved_err & INT_FATAL_ERRORS)
+			UFSHCD_UPDATE_ERROR_STATS(hba,
+						  UFS_ERR_INT_FATAL_ERRORS);
+
+		if (hba->saved_err & UIC_ERROR)
+			UFSHCD_UPDATE_ERROR_STATS(hba,
+						  UFS_ERR_INT_UIC_ERROR);
+
+		if (err_xfer || err_tm)
+			UFSHCD_UPDATE_ERROR_STATS(hba,
+						  UFS_ERR_CLEAR_PEND_XFER_TM);
+
 		err = ufshcd_reset_and_restore(hba);
 		if (err) {
 			dev_err(hba->dev, "%s: reset and restore failed\n",
@@ -3719,6 +3902,9 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	hba = shost_priv(host);
 	tag = cmd->request->tag;
 
+	UFSHCD_UPDATE_ERROR_STATS(hba, UFS_ERR_TASK_ABORT);
+
+
 	ufshcd_hold(hba, false);
 	/* If command is already aborted/completed, return SUCCESS */
 	if (!(test_bit(tag, &hba->outstanding_reqs)))
@@ -3903,6 +4089,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	UFSHCD_UPDATE_ERROR_STATS(hba, UFS_ERR_EH);
 	err = ufshcd_reset_and_restore(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -5188,10 +5375,12 @@ vops_resume:
 		hba->vops->resume(hba, pm_op);
 set_link_active:
 	ufshcd_vreg_set_hpm(hba);
-	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
+	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba)) {
 		ufshcd_set_link_active(hba);
-	else if (ufshcd_is_link_off(hba))
+	} else if (ufshcd_is_link_off(hba)) {
+		UFSHCD_UPDATE_ERROR_STATS(hba, UFS_ERR_VOPS_SUSPEND);
 		ufshcd_host_reset_and_restore(hba);
+	}
 set_dev_active:
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
 		ufshcd_disable_auto_bkops(hba);
@@ -5200,6 +5389,10 @@ enable_gating:
 	ufshcd_release(hba);
 out:
 	hba->pm_op_in_progress = 0;
+
+	if (ret)
+		UFSHCD_UPDATE_ERROR_STATS(hba, UFS_ERR_SUSPEND);
+
 	return ret;
 }
 
@@ -5295,6 +5488,10 @@ disable_irq_and_vops_clks:
 	ufshcd_setup_clocks(hba, false);
 out:
 	hba->pm_op_in_progress = 0;
+
+	if (ret)
+		UFSHCD_UPDATE_ERROR_STATS(hba, UFS_ERR_RESUME);
+
 	return ret;
 }
 
@@ -5466,6 +5663,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	if (ufshcd_is_clkscaling_enabled(hba))
 		devfreq_remove_device(hba->devfreq);
 	ufshcd_hba_exit(hba);
+	ufsdbg_remove_debugfs(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
 
@@ -5760,6 +5958,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	async_schedule(ufshcd_async_scan, hba);
 
+	ufsdbg_add_debugfs(hba);
+
 	return 0;
 
 out_remove_scsi_host:
@@ -5769,6 +5969,7 @@ exit_gating:
 out_disable:
 	hba->is_irq_enabled = false;
 	scsi_host_put(host);
+	ufsdbg_remove_debugfs(hba);
 	ufshcd_hba_exit(hba);
 out_error:
 	return err;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4a574aa..d9b1251 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -3,6 +3,7 @@
  *
  * This code is based on drivers/scsi/ufs/ufshcd.h
  * Copyright (C) 2011-2013 Samsung India Software Operations
+ * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  *
  * Authors:
  *	Santosh Yaraganavi <santosh.sy@samsung.com>
@@ -125,6 +126,25 @@ enum uic_link_state {
 #define ufshcd_set_link_hibern8(hba) ((hba)->uic_link_state = \
 				    UIC_LINK_HIBERN8_STATE)
 
+enum {
+	/* errors which require the host controller reset for recovery */
+	UFS_ERR_HIBERN8_EXIT,
+	UFS_ERR_VOPS_SUSPEND,
+	UFS_ERR_EH,
+	UFS_ERR_CLEAR_PEND_XFER_TM,
+	UFS_ERR_INT_FATAL_ERRORS,
+	UFS_ERR_INT_UIC_ERROR,
+
+	/* other errors */
+	UFS_ERR_HIBERN8_ENTER,
+	UFS_ERR_RESUME,
+	UFS_ERR_SUSPEND,
+	UFS_ERR_LINKSTARTUP,
+	UFS_ERR_POWER_MODE_CHANGE,
+	UFS_ERR_TASK_ABORT,
+	UFS_ERR_MAX,
+};
+
 /*
  * UFS Power management levels.
  * Each level is in increasing order of power savings.
@@ -203,6 +223,39 @@ struct ufs_dev_cmd {
 	struct ufs_query query;
 };
 
+#ifdef CONFIG_DEBUG_FS
+struct ufs_stats {
+	bool enabled;
+	u64 **tag_stats;
+	int q_depth;
+	int err_stats[UFS_ERR_MAX];
+};
+
+struct debugfs_files {
+	struct dentry *debugfs_root;
+	struct dentry *tag_stats;
+	struct dentry *err_stats;
+	struct dentry *show_hba;
+	struct dentry *host_regs;
+	struct dentry *dump_dev_desc;
+	struct dentry *power_mode;
+	struct dentry *dme_local_read;
+	struct dentry *dme_peer_read;
+	u32 dme_local_attr_id;
+	u32 dme_peer_attr_id;
+};
+
+/* tag stats statistics types */
+enum ts_types {
+	TS_NOT_SUPPORTED	= -1,
+	TS_TAG			= 0,
+	TS_READ			= 1,
+	TS_WRITE		= 2,
+	TS_FLUSH		= 3,
+	TS_NUM_STATS		= 4,
+};
+#endif
+
 /**
  * struct ufs_clk_info - UFS clock related info
  * @list: list headed by hba->clk_list_head
@@ -371,6 +424,8 @@ struct ufs_init_prefetch {
  * @clk_list_head: UFS host controller clocks list node head
  * @pwr_info: holds current power mode
  * @max_pwr_info: keeps the device max valid pwm
+ * @ufs_stats: ufshcd statistics to be used via debugfs
+ * @debugfs_files: debugfs files associated with the ufs stats
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -473,6 +528,10 @@ struct ufs_hba {
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
 	bool is_sys_suspended;
+#ifdef CONFIG_DEBUG_FS
+	struct ufs_stats ufs_stats;
+	struct debugfs_files debugfs_files;
+#endif
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
@@ -593,4 +652,10 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
 
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
+int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size);
+
+/* Expose Query-Request API */
+int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba, u64 wait_timeout_us);
+int ufshcd_change_power_mode(struct ufs_hba *hba,
+			     struct ufs_pa_layer_attr *pwr_mode);
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index d572119..c8b178f 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -72,6 +72,8 @@ enum {
 	REG_UIC_COMMAND_ARG_1			= 0x94,
 	REG_UIC_COMMAND_ARG_2			= 0x98,
 	REG_UIC_COMMAND_ARG_3			= 0x9C,
+
+	UFSHCI_REG_SPACE_SIZE			= 0xA0,
 };
 
 /* Controller capability masks */
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
