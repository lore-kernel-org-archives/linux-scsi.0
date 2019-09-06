Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA33C43140
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 645A12082C
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404947AbfIFM6S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 08:58:18 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56654 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404929AbfIFM6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 08:58:17 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C82602ABB4C0F723D32D;
        Fri,  6 Sep 2019 20:58:15 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 20:58:05 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 12/13] scsi: hisi_sas: Add BIST support for phy loopback
Date:   Fri, 6 Sep 2019 20:55:36 +0800
Message-ID: <1567774537-20003-13-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
References: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add BIST (built in self test) support for phy loopback.

Through the new debugfs interface, the user can configure loopback
mode/linkrate/phy id/code mode before enabling it. And also user can
enable/disable BIST function.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  10 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 407 +++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 126 ++++++++
 3 files changed, 543 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index ccbe4563402a..720c4d6be939 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -310,6 +310,7 @@ struct hisi_sas_hw {
 					   int delay_ms, int timeout_ms);
 	void (*snapshot_prepare)(struct hisi_hba *hisi_hba);
 	void (*snapshot_restore)(struct hisi_hba *hisi_hba);
+	int (*set_bist)(struct hisi_hba *hisi_hba, bool enable);
 	void (*read_iost_itct_cache)(struct hisi_hba *hisi_hba,
 				     enum hisi_sas_debugfs_cache_type type,
 				     u32 *cache);
@@ -391,6 +392,14 @@ struct hisi_hba {
 	int cq_nvecs;
 	unsigned int *reply_map;
 
+	/* bist */
+	enum sas_linkrate debugfs_bist_linkrate;
+	int debugfs_bist_code_mode;
+	int debugfs_bist_phy_no;
+	int debugfs_bist_mode;
+	u32 debugfs_bist_cnt;
+	int debugfs_bist_enable;
+
 	/* debugfs memories */
 	/* Put Global AXI and RAS Register into register array */
 	u32 *debugfs_regs[DEBUGFS_REGS_NUM];
@@ -404,6 +413,7 @@ struct hisi_hba {
 
 	struct dentry *debugfs_dir;
 	struct dentry *debugfs_dump_dentry;
+	struct dentry *debugfs_bist_dentry;
 	bool debugfs_snapshot;
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index e7056bbad7d7..04cbc54be387 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3294,6 +3294,382 @@ static const struct file_operations hisi_sas_debugfs_trigger_dump_fops = {
 	.owner = THIS_MODULE,
 };
 
+enum {
+	HISI_SAS_BIST_LOOPBACK_MODE_DIGITAL = 0,
+	HISI_SAS_BIST_LOOPBACK_MODE_SERDES,
+	HISI_SAS_BIST_LOOPBACK_MODE_REMOTE,
+};
+
+enum {
+	HISI_SAS_BIST_CODE_MODE_PRBS7 = 0,
+	HISI_SAS_BIST_CODE_MODE_PRBS23,
+	HISI_SAS_BIST_CODE_MODE_PRBS31,
+	HISI_SAS_BIST_CODE_MODE_JTPAT,
+	HISI_SAS_BIST_CODE_MODE_CJTPAT,
+	HISI_SAS_BIST_CODE_MODE_SCRAMBED_0,
+	HISI_SAS_BIST_CODE_MODE_TRAIN,
+	HISI_SAS_BIST_CODE_MODE_TRAIN_DONE,
+	HISI_SAS_BIST_CODE_MODE_HFTP,
+	HISI_SAS_BIST_CODE_MODE_MFTP,
+	HISI_SAS_BIST_CODE_MODE_LFTP,
+	HISI_SAS_BIST_CODE_MODE_FIXED_DATA,
+};
+
+static const struct {
+	int		value;
+	char		*name;
+} hisi_sas_debugfs_loop_linkrate[] = {
+	{ SAS_LINK_RATE_1_5_GBPS, "1.5 Gbit" },
+	{ SAS_LINK_RATE_3_0_GBPS, "3.0 Gbit" },
+	{ SAS_LINK_RATE_6_0_GBPS, "6.0 Gbit" },
+	{ SAS_LINK_RATE_12_0_GBPS, "12.0 Gbit" },
+};
+
+static int hisi_sas_debugfs_bist_linkrate_show(struct seq_file *s, void *p)
+{
+	struct hisi_hba *hisi_hba = s->private;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hisi_sas_debugfs_loop_linkrate); i++) {
+		int match = (hisi_hba->debugfs_bist_linkrate ==
+			     hisi_sas_debugfs_loop_linkrate[i].value);
+
+		seq_printf(s, "%s%s%s ", match ? "[" : "",
+			   hisi_sas_debugfs_loop_linkrate[i].name,
+			   match ? "]" : "");
+	}
+	seq_puts(s, "\n");
+
+	return 0;
+}
+
+static ssize_t hisi_sas_debugfs_bist_linkrate_write(struct file *filp,
+						    const char __user *buf,
+						    size_t count, loff_t *ppos)
+{
+	struct seq_file *m = filp->private_data;
+	struct hisi_hba *hisi_hba = m->private;
+	char kbuf[16] = {}, *pkbuf;
+	bool found = false;
+	int i;
+
+	if (hisi_hba->debugfs_bist_enable)
+		return -EPERM;
+
+	if (count >= sizeof(kbuf))
+		return -EOVERFLOW;
+
+	if (copy_from_user(kbuf, buf, count))
+		return -EINVAL;
+
+	pkbuf = strstrip(kbuf);
+
+	for (i = 0; i < ARRAY_SIZE(hisi_sas_debugfs_loop_linkrate); i++) {
+		if (!strncmp(hisi_sas_debugfs_loop_linkrate[i].name,
+			     pkbuf, 16)) {
+			hisi_hba->debugfs_bist_linkrate =
+				hisi_sas_debugfs_loop_linkrate[i].value;
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return -EINVAL;
+
+	return count;
+}
+
+static int hisi_sas_debugfs_bist_linkrate_open(struct inode *inode,
+					       struct file *filp)
+{
+	return single_open(filp, hisi_sas_debugfs_bist_linkrate_show,
+			   inode->i_private);
+}
+
+static const struct file_operations hisi_sas_debugfs_bist_linkrate_ops = {
+	.open = hisi_sas_debugfs_bist_linkrate_open,
+	.read = seq_read,
+	.write = hisi_sas_debugfs_bist_linkrate_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static const struct {
+	int		value;
+	char		*name;
+} hisi_sas_debugfs_loop_code_mode[] = {
+	{ HISI_SAS_BIST_CODE_MODE_PRBS7, "PRBS7" },
+	{ HISI_SAS_BIST_CODE_MODE_PRBS23, "PRBS23" },
+	{ HISI_SAS_BIST_CODE_MODE_PRBS31, "PRBS31" },
+	{ HISI_SAS_BIST_CODE_MODE_JTPAT, "JTPAT" },
+	{ HISI_SAS_BIST_CODE_MODE_CJTPAT, "CJTPAT" },
+	{ HISI_SAS_BIST_CODE_MODE_SCRAMBED_0, "SCRAMBED_0" },
+	{ HISI_SAS_BIST_CODE_MODE_TRAIN, "TRAIN" },
+	{ HISI_SAS_BIST_CODE_MODE_TRAIN_DONE, "TRAIN_DONE" },
+	{ HISI_SAS_BIST_CODE_MODE_HFTP, "HFTP" },
+	{ HISI_SAS_BIST_CODE_MODE_MFTP, "MFTP" },
+	{ HISI_SAS_BIST_CODE_MODE_LFTP, "LFTP" },
+	{ HISI_SAS_BIST_CODE_MODE_FIXED_DATA, "FIXED_DATA" },
+};
+
+static int hisi_sas_debugfs_bist_code_mode_show(struct seq_file *s, void *p)
+{
+	struct hisi_hba *hisi_hba = s->private;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hisi_sas_debugfs_loop_code_mode); i++) {
+		int match = (hisi_hba->debugfs_bist_code_mode ==
+			     hisi_sas_debugfs_loop_code_mode[i].value);
+
+		seq_printf(s, "%s%s%s ", match ? "[" : "",
+			   hisi_sas_debugfs_loop_code_mode[i].name,
+			   match ? "]" : "");
+	}
+	seq_puts(s, "\n");
+
+	return 0;
+}
+
+static ssize_t hisi_sas_debugfs_bist_code_mode_write(struct file *filp,
+						     const char __user *buf,
+						     size_t count,
+						     loff_t *ppos)
+{
+	struct seq_file *m = filp->private_data;
+	struct hisi_hba *hisi_hba = m->private;
+	char kbuf[16] = {}, *pkbuf;
+	bool found = false;
+	int i;
+
+	if (hisi_hba->debugfs_bist_enable)
+		return -EPERM;
+
+	if (count >= sizeof(kbuf))
+		return -EINVAL;
+
+	if (copy_from_user(kbuf, buf, count))
+		return -EOVERFLOW;
+
+	pkbuf = strstrip(kbuf);
+
+	for (i = 0; i < ARRAY_SIZE(hisi_sas_debugfs_loop_code_mode); i++) {
+		if (!strncmp(hisi_sas_debugfs_loop_code_mode[i].name,
+			     pkbuf, 16)) {
+			hisi_hba->debugfs_bist_code_mode =
+				hisi_sas_debugfs_loop_code_mode[i].value;
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return -EINVAL;
+
+	return count;
+}
+
+static int hisi_sas_debugfs_bist_code_mode_open(struct inode *inode,
+						struct file *filp)
+{
+	return single_open(filp, hisi_sas_debugfs_bist_code_mode_show,
+			   inode->i_private);
+}
+
+static const struct file_operations hisi_sas_debugfs_bist_code_mode_ops = {
+	.open = hisi_sas_debugfs_bist_code_mode_open,
+	.read = seq_read,
+	.write = hisi_sas_debugfs_bist_code_mode_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static ssize_t hisi_sas_debugfs_bist_phy_write(struct file *filp,
+					       const char __user *buf,
+					       size_t count, loff_t *ppos)
+{
+	struct seq_file *m = filp->private_data;
+	struct hisi_hba *hisi_hba = m->private;
+	unsigned int phy_no;
+	int val;
+
+	if (hisi_hba->debugfs_bist_enable)
+		return -EPERM;
+
+	val = kstrtouint_from_user(buf, count, 0, &phy_no);
+	if (val)
+		return val;
+
+	if (phy_no >= hisi_hba->n_phy)
+		return -EINVAL;
+
+	hisi_hba->debugfs_bist_phy_no = phy_no;
+
+	return count;
+}
+
+static int hisi_sas_debugfs_bist_phy_show(struct seq_file *s, void *p)
+{
+	struct hisi_hba *hisi_hba = s->private;
+
+	seq_printf(s, "%d\n", hisi_hba->debugfs_bist_phy_no);
+
+	return 0;
+}
+
+static int hisi_sas_debugfs_bist_phy_open(struct inode *inode,
+					  struct file *filp)
+{
+	return single_open(filp, hisi_sas_debugfs_bist_phy_show,
+			   inode->i_private);
+}
+
+static const struct file_operations hisi_sas_debugfs_bist_phy_ops = {
+	.open = hisi_sas_debugfs_bist_phy_open,
+	.read = seq_read,
+	.write = hisi_sas_debugfs_bist_phy_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static const struct {
+	int		value;
+	char		*name;
+} hisi_sas_debugfs_loop_modes[] = {
+	{ HISI_SAS_BIST_LOOPBACK_MODE_DIGITAL, "digial" },
+	{ HISI_SAS_BIST_LOOPBACK_MODE_SERDES, "serdes" },
+	{ HISI_SAS_BIST_LOOPBACK_MODE_REMOTE, "remote" },
+};
+
+static int hisi_sas_debugfs_bist_mode_show(struct seq_file *s, void *p)
+{
+	struct hisi_hba *hisi_hba = s->private;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hisi_sas_debugfs_loop_modes); i++) {
+		int match = (hisi_hba->debugfs_bist_mode ==
+			     hisi_sas_debugfs_loop_modes[i].value);
+
+		seq_printf(s, "%s%s%s ", match ? "[" : "",
+			   hisi_sas_debugfs_loop_modes[i].name,
+			   match ? "]" : "");
+	}
+	seq_puts(s, "\n");
+
+	return 0;
+}
+
+static ssize_t hisi_sas_debugfs_bist_mode_write(struct file *filp,
+						const char __user *buf,
+						size_t count, loff_t *ppos)
+{
+	struct seq_file *m = filp->private_data;
+	struct hisi_hba *hisi_hba = m->private;
+	char kbuf[16] = {}, *pkbuf;
+	bool found = false;
+	int i;
+
+	if (hisi_hba->debugfs_bist_enable)
+		return -EPERM;
+
+	if (count >= sizeof(kbuf))
+		return -EINVAL;
+
+	if (copy_from_user(kbuf, buf, count))
+		return -EOVERFLOW;
+
+	pkbuf = strstrip(kbuf);
+
+	for (i = 0; i < ARRAY_SIZE(hisi_sas_debugfs_loop_modes); i++) {
+		if (!strncmp(hisi_sas_debugfs_loop_modes[i].name, pkbuf, 16)) {
+			hisi_hba->debugfs_bist_mode =
+				hisi_sas_debugfs_loop_modes[i].value;
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return -EINVAL;
+
+	return count;
+}
+
+static int hisi_sas_debugfs_bist_mode_open(struct inode *inode,
+					   struct file *filp)
+{
+	return single_open(filp, hisi_sas_debugfs_bist_mode_show,
+			   inode->i_private);
+}
+
+static const struct file_operations hisi_sas_debugfs_bist_mode_ops = {
+	.open = hisi_sas_debugfs_bist_mode_open,
+	.read = seq_read,
+	.write = hisi_sas_debugfs_bist_mode_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
+static ssize_t hisi_sas_debugfs_bist_enable_write(struct file *filp,
+						  const char __user *buf,
+						  size_t count, loff_t *ppos)
+{
+	struct seq_file *m = filp->private_data;
+	struct hisi_hba *hisi_hba = m->private;
+	unsigned int enable;
+	int val;
+
+	val = kstrtouint_from_user(buf, count, 0, &enable);
+	if (val)
+		return val;
+
+	if (enable > 1)
+		return -EINVAL;
+
+	if (enable == hisi_hba->debugfs_bist_enable)
+		return count;
+
+	if (!hisi_hba->hw->set_bist)
+		return -EPERM;
+
+	val = hisi_hba->hw->set_bist(hisi_hba, enable);
+	if (val < 0)
+		return val;
+
+	hisi_hba->debugfs_bist_enable = enable;
+
+	return count;
+}
+
+static int hisi_sas_debugfs_bist_enable_show(struct seq_file *s, void *p)
+{
+	struct hisi_hba *hisi_hba = s->private;
+
+	seq_printf(s, "%d\n", hisi_hba->debugfs_bist_enable);
+
+	return 0;
+}
+
+static int hisi_sas_debugfs_bist_enable_open(struct inode *inode,
+					     struct file *filp)
+{
+	return single_open(filp, hisi_sas_debugfs_bist_enable_show,
+			   inode->i_private);
+}
+
+static const struct file_operations hisi_sas_debugfs_bist_enable_ops = {
+	.open = hisi_sas_debugfs_bist_enable_open,
+	.read = seq_read,
+	.write = hisi_sas_debugfs_bist_enable_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 void hisi_sas_debugfs_work_handler(struct work_struct *work)
 {
 	struct hisi_hba *hisi_hba =
@@ -3420,6 +3796,34 @@ int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 	return -ENOMEM;
 }
 
+void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
+{
+	hisi_hba->debugfs_bist_dentry =
+			debugfs_create_dir("bist", hisi_hba->debugfs_dir);
+	debugfs_create_file("link_rate", 0600,
+			    hisi_hba->debugfs_bist_dentry, hisi_hba,
+			    &hisi_sas_debugfs_bist_linkrate_ops);
+
+	debugfs_create_file("code_mode", 0600,
+			    hisi_hba->debugfs_bist_dentry, hisi_hba,
+			    &hisi_sas_debugfs_bist_code_mode_ops);
+
+	debugfs_create_file("phy_id", 0600, hisi_hba->debugfs_bist_dentry,
+			    hisi_hba, &hisi_sas_debugfs_bist_phy_ops);
+
+	debugfs_create_u32("cnt", 0600, hisi_hba->debugfs_bist_dentry,
+			   &hisi_hba->debugfs_bist_cnt);
+
+	debugfs_create_file("loopback_mode", 0600,
+			    hisi_hba->debugfs_bist_dentry,
+			    hisi_hba, &hisi_sas_debugfs_bist_mode_ops);
+
+	debugfs_create_file("enable", 0600, hisi_hba->debugfs_bist_dentry,
+			    hisi_hba, &hisi_sas_debugfs_bist_enable_ops);
+
+	hisi_hba->debugfs_bist_linkrate = SAS_LINK_RATE_1_5_GBPS;
+}
+
 void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
@@ -3431,6 +3835,9 @@ void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 			    hisi_hba,
 			    &hisi_sas_debugfs_trigger_dump_fops);
 
+	/* create bist structures */
+	hisi_sas_debugfs_bist_init(hisi_hba);
+
 	if (hisi_sas_debugfs_alloc(hisi_hba)) {
 		debugfs_remove_recursive(hisi_hba->debugfs_dir);
 		dev_dbg(dev, "failed to init debugfs!\n");
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e4db85b8af3e..cb8d087762db 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -191,12 +191,30 @@
 #define PHY_CFG_PHY_RST_OFF		3
 #define PHY_CFG_PHY_RST_MSK		(0x1 << PHY_CFG_PHY_RST_OFF)
 #define PROG_PHY_LINK_RATE		(PORT_BASE + 0x8)
+#define CFG_PROG_PHY_LINK_RATE_OFF	8
+#define CFG_PROG_PHY_LINK_RATE_MSK	(0xf << CFG_PROG_PHY_LINK_RATE_OFF)
 #define PHY_CTRL			(PORT_BASE + 0x14)
 #define PHY_CTRL_RESET_OFF		0
 #define PHY_CTRL_RESET_MSK		(0x1 << PHY_CTRL_RESET_OFF)
 #define CMD_HDR_PIR_OFF			8
 #define CMD_HDR_PIR_MSK			(0x1 << CMD_HDR_PIR_OFF)
 #define SERDES_CFG			(PORT_BASE + 0x1c)
+#define CFG_ALOS_CHK_DISABLE_OFF	9
+#define CFG_ALOS_CHK_DISABLE_MSK	(0x1 << CFG_ALOS_CHK_DISABLE_OFF)
+#define SAS_PHY_BIST_CTRL		(PORT_BASE + 0x2c)
+#define CFG_BIST_MODE_SEL_OFF		0
+#define CFG_BIST_MODE_SEL_MSK		(0xf << CFG_BIST_MODE_SEL_OFF)
+#define CFG_LOOP_TEST_MODE_OFF		14
+#define CFG_LOOP_TEST_MODE_MSK		(0x3 << CFG_LOOP_TEST_MODE_OFF)
+#define CFG_RX_BIST_EN_OFF		16
+#define CFG_RX_BIST_EN_MSK		(0x1 << CFG_RX_BIST_EN_OFF)
+#define CFG_TX_BIST_EN_OFF		17
+#define CFG_TX_BIST_EN_MSK		(0x1 << CFG_TX_BIST_EN_OFF)
+#define CFG_BIST_TEST_OFF		18
+#define CFG_BIST_TEST_MSK		(0x1 << CFG_BIST_TEST_OFF)
+#define SAS_PHY_BIST_CODE		(PORT_BASE + 0x30)
+#define SAS_PHY_BIST_CODE1		(PORT_BASE + 0x34)
+#define SAS_BIST_ERR_CNT		(PORT_BASE + 0x38)
 #define SL_CFG				(PORT_BASE + 0x84)
 #define AIP_LIMIT			(PORT_BASE + 0x90)
 #define SL_CONTROL			(PORT_BASE + 0x94)
@@ -2923,6 +2941,113 @@ static void read_iost_itct_cache_v3_hw(struct hisi_hba *hisi_hba,
 		buf[i] = hisi_sas_read32(hisi_hba, TAB_DFX);
 }
 
+static void hisi_sas_bist_test_prep_v3_hw(struct hisi_hba *hisi_hba)
+{
+	u32 reg_val;
+	int phy_id = hisi_hba->debugfs_bist_phy_no;
+
+	/* disable PHY */
+	hisi_sas_phy_enable(hisi_hba, phy_id, 0);
+
+	/* disable ALOS */
+	reg_val = hisi_sas_phy_read32(hisi_hba, phy_id, SERDES_CFG);
+	reg_val |= CFG_ALOS_CHK_DISABLE_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_id, SERDES_CFG, reg_val);
+}
+
+static void hisi_sas_bist_test_restore_v3_hw(struct hisi_hba *hisi_hba)
+{
+	u32 reg_val;
+	int phy_id = hisi_hba->debugfs_bist_phy_no;
+
+	/* disable loopback */
+	reg_val = hisi_sas_phy_read32(hisi_hba, phy_id, SAS_PHY_BIST_CTRL);
+	reg_val &= ~(CFG_RX_BIST_EN_MSK | CFG_TX_BIST_EN_MSK |
+		     CFG_BIST_TEST_MSK);
+	hisi_sas_phy_write32(hisi_hba, phy_id, SAS_PHY_BIST_CTRL, reg_val);
+
+	/* enable ALOS */
+	reg_val = hisi_sas_phy_read32(hisi_hba, phy_id, SERDES_CFG);
+	reg_val &= ~CFG_ALOS_CHK_DISABLE_MSK;
+	hisi_sas_phy_write32(hisi_hba, phy_id, SERDES_CFG, reg_val);
+
+	/* restore the linkrate */
+	reg_val = hisi_sas_phy_read32(hisi_hba, phy_id, PROG_PHY_LINK_RATE);
+	/* init OOB link rate as 1.5 Gbits */
+	reg_val &= ~CFG_PROG_PHY_LINK_RATE_MSK;
+	reg_val |= (0x8 << CFG_PROG_PHY_LINK_RATE_OFF);
+	hisi_sas_phy_write32(hisi_hba, phy_id, PROG_PHY_LINK_RATE, reg_val);
+
+	/* enable PHY */
+	hisi_sas_phy_enable(hisi_hba, phy_id, 1);
+}
+
+#define SAS_PHY_BIST_CODE_INIT	0x1
+#define SAS_PHY_BIST_CODE1_INIT	0X80
+static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
+{
+	u32 reg_val, mode_tmp;
+	u32 linkrate = hisi_hba->debugfs_bist_linkrate;
+	u32 phy_id = hisi_hba->debugfs_bist_phy_no;
+	u32 code_mode = hisi_hba->debugfs_bist_code_mode;
+	u32 path_mode = hisi_hba->debugfs_bist_mode;
+	struct device *dev = hisi_hba->dev;
+
+	dev_info(dev, "BIST info:linkrate=%d phy_id=%d code_mode=%d path_mode=%d\n",
+		 linkrate, phy_id, code_mode, path_mode);
+	mode_tmp = path_mode ? 2 : 1;
+	if (enable) {
+		/* some preparations before bist test */
+		hisi_sas_bist_test_prep_v3_hw(hisi_hba);
+
+		/* set linkrate of bit test*/
+		reg_val = hisi_sas_phy_read32(hisi_hba, phy_id,
+					      PROG_PHY_LINK_RATE);
+		reg_val &= ~CFG_PROG_PHY_LINK_RATE_MSK;
+		reg_val |= (linkrate << CFG_PROG_PHY_LINK_RATE_OFF);
+		hisi_sas_phy_write32(hisi_hba, phy_id,
+				     PROG_PHY_LINK_RATE, reg_val);
+
+		/* set code mode of bit test */
+		reg_val = hisi_sas_phy_read32(hisi_hba, phy_id,
+					      SAS_PHY_BIST_CTRL);
+		reg_val &= ~(CFG_BIST_MODE_SEL_MSK |
+				CFG_LOOP_TEST_MODE_MSK |
+				CFG_RX_BIST_EN_MSK |
+				CFG_TX_BIST_EN_MSK |
+				CFG_BIST_TEST_MSK);
+		reg_val |= ((code_mode << CFG_BIST_MODE_SEL_OFF) |
+			    (mode_tmp << CFG_LOOP_TEST_MODE_OFF) |
+			    CFG_BIST_TEST_MSK);
+		hisi_sas_phy_write32(hisi_hba, phy_id,
+				     SAS_PHY_BIST_CTRL, reg_val);
+
+		mdelay(100);
+		reg_val |= (CFG_RX_BIST_EN_MSK | CFG_TX_BIST_EN_MSK);
+		hisi_sas_phy_write32(hisi_hba, phy_id,
+				     SAS_PHY_BIST_CTRL, reg_val);
+
+		/* set the bist init value */
+		hisi_sas_phy_write32(hisi_hba, phy_id,
+				     SAS_PHY_BIST_CODE,
+				     SAS_PHY_BIST_CODE_INIT);
+		hisi_sas_phy_write32(hisi_hba, phy_id,
+				     SAS_PHY_BIST_CODE1,
+				     SAS_PHY_BIST_CODE1_INIT);
+
+		/* clear error bit */
+		mdelay(100);
+		hisi_sas_phy_read32(hisi_hba, phy_id, SAS_BIST_ERR_CNT);
+	} else {
+		/* disable bist test and recover it */
+		hisi_hba->debugfs_bist_cnt += hisi_sas_phy_read32(hisi_hba,
+				phy_id, SAS_BIST_ERR_CNT);
+		hisi_sas_bist_test_restore_v3_hw(hisi_hba);
+	}
+
+	return 0;
+}
+
 static struct scsi_host_template sht_v3_hw = {
 	.name			= DRV_NAME,
 	.module			= THIS_MODULE,
@@ -2977,6 +3102,7 @@ static const struct hisi_sas_hw hisi_sas_v3_hw = {
 	.snapshot_prepare = debugfs_snapshot_prepare_v3_hw,
 	.snapshot_restore = debugfs_snapshot_restore_v3_hw,
 	.read_iost_itct_cache = read_iost_itct_cache_v3_hw,
+	.set_bist = debugfs_set_bist_v3_hw,
 };
 
 static struct Scsi_Host *
-- 
2.17.1

