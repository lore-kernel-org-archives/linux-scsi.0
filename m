Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15326CA9EBB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E04A42166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502283AbfJXOLm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:11:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5163 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390869AbfJXOLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:11:39 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 665D01499C9B7F39CFD2;
        Thu, 24 Oct 2019 22:11:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:11:25 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v2 08/18] scsi: hisi_sas: Add debugfs file structure for registers
Date:   Thu, 24 Oct 2019 22:08:15 +0800
Message-ID: <1571926105-74636-9-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571926105-74636-1-git-send-email-john.garry@huawei.com>
References: <1571926105-74636-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Create a file structure which was used to save the memory address and
hisi_hba pointer for REGS at debugfs. This structure is bound to the
corresponding debugfs file, it can help callback function of debugfs file
to get what it need.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  7 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c | 62 +++++++++++++--------------
 2 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 91c10be3dfb7..1c01e0e76a0e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -333,6 +333,11 @@ struct hisi_sas_debugfs_dq {
 	struct hisi_sas_cmd_hdr *hdr;
 };
 
+struct hisi_sas_debugfs_regs {
+	struct hisi_hba *hisi_hba;
+	u32 *data;
+};
+
 struct hisi_hba {
 	/* This must be the first element, used by SHOST_TO_SAS_HA */
 	struct sas_ha_struct *p;
@@ -414,7 +419,7 @@ struct hisi_hba {
 
 	/* debugfs memories */
 	/* Put Global AXI and RAS Register into register array */
-	u32 *debugfs_regs[DEBUGFS_REGS_NUM];
+	struct hisi_sas_debugfs_regs debugfs_regs[DEBUGFS_REGS_NUM];
 	u32 *debugfs_port_reg[HISI_SAS_MAX_PHYS];
 	struct hisi_sas_debugfs_cq debugfs_cq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_debugfs_dq debugfs_dq[HISI_SAS_MAX_QUEUES];
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 647a14983696..92cf9b514a70 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2743,7 +2743,7 @@ static void hisi_sas_debugfs_snapshot_port_reg(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_debugfs_snapshot_global_reg(struct hisi_hba *hisi_hba)
 {
-	u32 *databuf = hisi_hba->debugfs_regs[DEBUGFS_GLOBAL];
+	u32 *databuf = hisi_hba->debugfs_regs[DEBUGFS_GLOBAL].data;
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	const struct hisi_sas_debugfs_reg *global =
 			hw->debugfs_reg_array[DEBUGFS_GLOBAL];
@@ -2755,7 +2755,7 @@ static void hisi_sas_debugfs_snapshot_global_reg(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_debugfs_snapshot_axi_reg(struct hisi_hba *hisi_hba)
 {
-	u32 *databuf = hisi_hba->debugfs_regs[DEBUGFS_AXI];
+	u32 *databuf = hisi_hba->debugfs_regs[DEBUGFS_AXI].data;
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	const struct hisi_sas_debugfs_reg *axi =
 			hw->debugfs_reg_array[DEBUGFS_AXI];
@@ -2768,7 +2768,7 @@ static void hisi_sas_debugfs_snapshot_axi_reg(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_debugfs_snapshot_ras_reg(struct hisi_hba *hisi_hba)
 {
-	u32 *databuf = hisi_hba->debugfs_regs[DEBUGFS_RAS];
+	u32 *databuf = hisi_hba->debugfs_regs[DEBUGFS_RAS].data;
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	const struct hisi_sas_debugfs_reg *ras =
 			hw->debugfs_reg_array[DEBUGFS_RAS];
@@ -2852,11 +2852,12 @@ static void hisi_sas_debugfs_print_reg(u32 *regs_val, const void *ptr,
 
 static int hisi_sas_debugfs_global_show(struct seq_file *s, void *p)
 {
-	struct hisi_hba *hisi_hba = s->private;
+	struct hisi_sas_debugfs_regs *global = s->private;
+	struct hisi_hba *hisi_hba = global->hisi_hba;
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	const void *reg_global = hw->debugfs_reg_array[DEBUGFS_GLOBAL];
 
-	hisi_sas_debugfs_print_reg(hisi_hba->debugfs_regs[DEBUGFS_GLOBAL],
+	hisi_sas_debugfs_print_reg(global->data,
 				   reg_global, s);
 
 	return 0;
@@ -2878,11 +2879,12 @@ static const struct file_operations hisi_sas_debugfs_global_fops = {
 
 static int hisi_sas_debugfs_axi_show(struct seq_file *s, void *p)
 {
-	struct hisi_hba *hisi_hba = s->private;
+	struct hisi_sas_debugfs_regs *axi = s->private;
+	struct hisi_hba *hisi_hba = axi->hisi_hba;
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	const void *reg_axi = hw->debugfs_reg_array[DEBUGFS_AXI];
 
-	hisi_sas_debugfs_print_reg(hisi_hba->debugfs_regs[DEBUGFS_AXI],
+	hisi_sas_debugfs_print_reg(axi->data,
 				   reg_axi, s);
 
 	return 0;
@@ -2904,11 +2906,12 @@ static const struct file_operations hisi_sas_debugfs_axi_fops = {
 
 static int hisi_sas_debugfs_ras_show(struct seq_file *s, void *p)
 {
-	struct hisi_hba *hisi_hba = s->private;
+	struct hisi_sas_debugfs_regs *ras = s->private;
+	struct hisi_hba *hisi_hba = ras->hisi_hba;
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	const void *reg_ras = hw->debugfs_reg_array[DEBUGFS_RAS];
 
-	hisi_sas_debugfs_print_reg(hisi_hba->debugfs_regs[DEBUGFS_RAS],
+	hisi_sas_debugfs_print_reg(ras->data,
 				   reg_ras, s);
 
 	return 0;
@@ -3209,7 +3212,8 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 	debugfs_create_u64("timestamp", 0400, dump_dentry,
 			   debugfs_timestamp);
 
-	debugfs_create_file("global", 0400, dump_dentry, hisi_hba,
+	debugfs_create_file("global", 0400, dump_dentry,
+			    &hisi_hba->debugfs_regs[DEBUGFS_GLOBAL],
 			    &hisi_sas_debugfs_global_fops);
 
 	/* Create port dir and files */
@@ -3253,10 +3257,12 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 	debugfs_create_file("itct_cache", 0400, dump_dentry, hisi_hba,
 			    &hisi_sas_debugfs_itct_cache_fops);
 
-	debugfs_create_file("axi", 0400, dump_dentry, hisi_hba,
+	debugfs_create_file("axi", 0400, dump_dentry,
+			    &hisi_hba->debugfs_regs[DEBUGFS_AXI],
 			    &hisi_sas_debugfs_axi_fops);
 
-	debugfs_create_file("ras", 0400, dump_dentry, hisi_hba,
+	debugfs_create_file("ras", 0400, dump_dentry,
+			    &hisi_hba->debugfs_regs[DEBUGFS_RAS],
 			    &hisi_sas_debugfs_ras_fops);
 
 	return;
@@ -3718,7 +3724,7 @@ static void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
 		devm_kfree(dev, hisi_hba->debugfs_cq[i].complete_hdr);
 
 	for (i = 0; i < DEBUGFS_REGS_NUM; i++)
-		devm_kfree(dev, hisi_hba->debugfs_regs[i]);
+		devm_kfree(dev, hisi_hba->debugfs_regs[i].data);
 
 	for (i = 0; i < hisi_hba->n_phy; i++)
 		devm_kfree(dev, hisi_hba->debugfs_port_reg[i]);
@@ -3728,15 +3734,19 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 {
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	struct device *dev = hisi_hba->dev;
-	int p, c, d;
+	int p, c, d, r;
 	size_t sz;
 
-	sz = hw->debugfs_reg_array[DEBUGFS_GLOBAL]->count * 4;
-	hisi_hba->debugfs_regs[DEBUGFS_GLOBAL] =
-				devm_kmalloc(dev, sz, GFP_KERNEL);
+	for (r = 0; r < DEBUGFS_REGS_NUM; r++) {
+		struct hisi_sas_debugfs_regs *regs =
+				&hisi_hba->debugfs_regs[r];
 
-	if (!hisi_hba->debugfs_regs[DEBUGFS_GLOBAL])
-		goto fail;
+		sz = hw->debugfs_reg_array[r]->count * 4;
+		regs->data = devm_kmalloc(dev, sz, GFP_KERNEL);
+		if (!regs->data)
+			goto fail;
+		regs->hisi_hba = hisi_hba;
+	}
 
 	sz = hw->debugfs_reg_port->count * 4;
 	for (p = 0; p < hisi_hba->n_phy; p++) {
@@ -3747,20 +3757,6 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 			goto fail;
 	}
 
-	sz = hw->debugfs_reg_array[DEBUGFS_AXI]->count * 4;
-	hisi_hba->debugfs_regs[DEBUGFS_AXI] =
-		devm_kmalloc(dev, sz, GFP_KERNEL);
-
-	if (!hisi_hba->debugfs_regs[DEBUGFS_AXI])
-		goto fail;
-
-	sz = hw->debugfs_reg_array[DEBUGFS_RAS]->count * 4;
-	hisi_hba->debugfs_regs[DEBUGFS_RAS] =
-		devm_kmalloc(dev, sz, GFP_KERNEL);
-
-	if (!hisi_hba->debugfs_regs[DEBUGFS_RAS])
-		goto fail;
-
 	sz = hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
 	for (c = 0; c < hisi_hba->queue_count; c++) {
 		struct hisi_sas_debugfs_cq *cq =
-- 
2.17.1

