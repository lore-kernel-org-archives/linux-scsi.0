Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F6AC433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 11:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C228206EB
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 11:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIALfU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 07:35:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:44776 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726722AbgIALec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Sep 2020 07:34:32 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4FCFC7322F11FFCFF2E9;
        Tue,  1 Sep 2020 19:17:07 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Sep 2020 19:16:59 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 5/8] scsi: hisi_sas: Add BIST support for phy FFE
Date:   Tue, 1 Sep 2020 19:13:07 +0800
Message-ID: <1598958790-232272-6-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1598958790-232272-1-git-send-email-john.garry@huawei.com>
References: <1598958790-232272-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Add BIST support for phy FFE(Feed forward equalizer) setting.

Through the new debugfs interface, the user can configure FFE if they
want.

FFE are a kind of parameter which used for link layer of board. They will
affect the link quality between the SAS controller and the backplane. In
the BIST test, FFE parameter interface is provided to assist board tester
in optimizing link parameters.

The modification of the FFE parameter will affect the test after BIST or
the normal running of the board, so user should save FFE's initial value
before modify it, and restore them after BIST test if necessary.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 13 +++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 76 ++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 25 ++++++++-
 3 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2bdd64648ef0..ce6a7d212afe 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -273,6 +273,18 @@ enum hisi_sas_debugfs_cache_type {
 	HISI_SAS_IOST_CACHE,
 };
 
+enum hisi_sas_debugfs_bist_ffe_cfg {
+	FFE_SAS_1_5_GBPS,
+	FFE_SAS_3_0_GBPS,
+	FFE_SAS_6_0_GBPS,
+	FFE_SAS_12_0_GBPS,
+	FFE_RESV,
+	FFE_SATA_1_5_GBPS,
+	FFE_SATA_3_0_GBPS,
+	FFE_SATA_6_0_GBPS,
+	FFE_CFG_MAX
+};
+
 struct hisi_sas_hw {
 	int (*hw_init)(struct hisi_hba *hisi_hba);
 	void (*setup_itct)(struct hisi_hba *hisi_hba,
@@ -440,6 +452,7 @@ struct hisi_hba {
 	int debugfs_bist_mode;
 	u32 debugfs_bist_cnt;
 	int debugfs_bist_enable;
+	u32 debugfs_bist_ffe[HISI_SAS_MAX_PHYS][FFE_CFG_MAX];
 
 	/* debugfs memories */
 	/* Put Global AXI and RAS Register into register array */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index fdf5f0f1b60b..6cd9b25fbbe7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3704,6 +3704,58 @@ static const struct file_operations hisi_sas_debugfs_bist_enable_ops = {
 	.owner = THIS_MODULE,
 };
 
+static const struct {
+	char *name;
+} hisi_sas_debugfs_ffe_name[FFE_CFG_MAX] = {
+	{ "SAS_1_5_GBPS" },
+	{ "SAS_3_0_GBPS" },
+	{ "SAS_6_0_GBPS" },
+	{ "SAS_12_0_GBPS" },
+	{ "FFE_RESV" },
+	{ "SATA_1_5_GBPS" },
+	{ "SATA_3_0_GBPS" },
+	{ "SATA_6_0_GBPS" },
+};
+
+static ssize_t hisi_sas_debugfs_write(struct file *filp,
+				      const char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	struct seq_file *m = filp->private_data;
+	u32 *val = m->private;
+	int res;
+
+	res = kstrtouint_from_user(buf, count, 0, val);
+	if (res)
+		return res;
+
+	return count;
+}
+
+static int hisi_sas_debugfs_show(struct seq_file *s, void *p)
+{
+	u32 *val = s->private;
+
+	seq_printf(s, "0x%x\n", *val);
+
+	return 0;
+}
+
+static int hisi_sas_debugfs_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, hisi_sas_debugfs_show,
+			   inode->i_private);
+}
+
+static const struct file_operations hisi_sas_debugfs_ops = {
+	.open = hisi_sas_debugfs_open,
+	.read = seq_read,
+	.write = hisi_sas_debugfs_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static ssize_t hisi_sas_debugfs_phy_down_cnt_write(struct file *filp,
 						   const char __user *buf,
 						   size_t count, loff_t *ppos)
@@ -3901,6 +3953,9 @@ static void hisi_sas_debugfs_phy_down_cnt_init(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
 {
+	struct dentry *ports_dentry;
+	int phy_no;
+
 	hisi_hba->debugfs_bist_dentry =
 			debugfs_create_dir("bist", hisi_hba->debugfs_dir);
 	debugfs_create_file("link_rate", 0600,
@@ -3924,6 +3979,27 @@ static void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
 	debugfs_create_file("enable", 0600, hisi_hba->debugfs_bist_dentry,
 			    hisi_hba, &hisi_sas_debugfs_bist_enable_ops);
 
+	ports_dentry = debugfs_create_dir("port", hisi_hba->debugfs_bist_dentry);
+
+	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++) {
+		struct dentry *port_dentry;
+		struct dentry *ffe_dentry;
+		char name[256];
+		int i;
+
+		snprintf(name, 256, "%d", phy_no);
+		port_dentry = debugfs_create_dir(name, ports_dentry);
+		ffe_dentry = debugfs_create_dir("ffe", port_dentry);
+		for (i = 0; i < FFE_CFG_MAX; i++) {
+			if (i == FFE_RESV)
+				continue;
+			debugfs_create_file(hisi_sas_debugfs_ffe_name[i].name,
+					    0600, ffe_dentry,
+					    &hisi_hba->debugfs_bist_ffe[phy_no][i],
+					    &hisi_sas_debugfs_ops);
+		}
+	}
+
 	hisi_hba->debugfs_bist_linkrate = SAS_LINK_RATE_1_5_GBPS;
 }
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 8a5c6f5e2a7a..f5d566832d6c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -297,6 +297,7 @@
 #define DMA_RX_STATUS_BUSY_MSK		(0x1 << DMA_RX_STATUS_BUSY_OFF)
 
 #define COARSETUNE_TIME			(PORT_BASE + 0x304)
+#define TXDEEMPH_G1			(PORT_BASE + 0x350)
 #define ERR_CNT_DWS_LOST		(PORT_BASE + 0x380)
 #define ERR_CNT_RESET_PROB		(PORT_BASE + 0x384)
 #define ERR_CNT_INVLD_DW		(PORT_BASE + 0x390)
@@ -567,7 +568,7 @@ static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
 
 static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 {
-	int i;
+	int i, j;
 
 	/* Global registers init */
 	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE,
@@ -637,6 +638,13 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 		/* used for 12G negotiate */
 		hisi_sas_phy_write32(hisi_hba, i, COARSETUNE_TIME, 0x1e);
 		hisi_sas_phy_write32(hisi_hba, i, AIP_LIMIT, 0x2ffff);
+
+		/* get default FFE configuration for BIST */
+		for (j = 0; j < FFE_CFG_MAX; j++) {
+			u32 val = hisi_sas_phy_read32(hisi_hba, i,
+						      TXDEEMPH_G1 + (j * 0x4));
+			hisi_hba->debugfs_bist_ffe[i][j] = val;
+		}
 	}
 
 	for (i = 0; i < hisi_hba->queue_count; i++) {
@@ -2972,10 +2980,16 @@ static void hisi_sas_bist_test_prep_v3_hw(struct hisi_hba *hisi_hba)
 {
 	u32 reg_val;
 	int phy_no = hisi_hba->debugfs_bist_phy_no;
+	int i;
 
 	/* disable PHY */
 	hisi_sas_phy_enable(hisi_hba, phy_no, 0);
 
+	/* update FFE */
+	for (i = 0; i < FFE_CFG_MAX; i++)
+		hisi_sas_phy_write32(hisi_hba, phy_no, TXDEEMPH_G1 + (i * 0x4),
+				     hisi_hba->debugfs_bist_ffe[phy_no][i]);
+
 	/* disable ALOS */
 	reg_val = hisi_sas_phy_read32(hisi_hba, phy_no, SERDES_CFG);
 	reg_val |= CFG_ALOS_CHK_DISABLE_MSK;
@@ -3016,12 +3030,17 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 	u32 reg_val, mode_tmp;
 	u32 linkrate = hisi_hba->debugfs_bist_linkrate;
 	u32 phy_no = hisi_hba->debugfs_bist_phy_no;
+	u32 *ffe = hisi_hba->debugfs_bist_ffe[phy_no];
 	u32 code_mode = hisi_hba->debugfs_bist_code_mode;
 	u32 path_mode = hisi_hba->debugfs_bist_mode;
 	struct device *dev = hisi_hba->dev;
 
-	dev_info(dev, "BIST info:linkrate=%d phy_no=%d code_mode=%d path_mode=%d\n",
-		 linkrate, phy_no, code_mode, path_mode);
+	dev_info(dev, "BIST info:phy%d link_rate=%d code_mode=%d path_mode=%d ffe={0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x}\n",
+		 phy_no, linkrate, code_mode, path_mode,
+		 ffe[FFE_SAS_1_5_GBPS], ffe[FFE_SAS_3_0_GBPS],
+		 ffe[FFE_SAS_6_0_GBPS], ffe[FFE_SAS_12_0_GBPS],
+		 ffe[FFE_SATA_1_5_GBPS], ffe[FFE_SATA_3_0_GBPS],
+		 ffe[FFE_SATA_6_0_GBPS]);
 	mode_tmp = path_mode ? 2 : 1;
 	if (enable) {
 		/* some preparations before bist test */
-- 
2.26.2

