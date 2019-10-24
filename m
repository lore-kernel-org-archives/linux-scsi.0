Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9ABCA9EBB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF2D021D71
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502790AbfJXOMh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:12:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5173 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502620AbfJXOLz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:11:55 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B8F8394492D0A05659D7;
        Thu, 24 Oct 2019 22:11:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:11:27 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v2 14/18] scsi: hisi_sas: Allocate memory for multiple dumps of debugfs
Date:   Thu, 24 Oct 2019 22:08:21 +0800
Message-ID: <1571926105-74636-15-git-send-email-john.garry@huawei.com>
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

We add multiple dumps for debugfs, but only allocate memory this time and
only dump #0.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  19 +++--
 drivers/scsi/hisi_sas/hisi_sas_main.c | 110 +++++++++++++++-----------
 2 files changed, 73 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index a608b2bef0b4..b4c6bec4b92c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -323,6 +323,8 @@ struct hisi_sas_hw {
 	const struct hisi_sas_debugfs_reg *debugfs_reg_port;
 };
 
+#define HISI_SAS_MAX_DEBUGFS_DUMP (50)
+
 struct hisi_sas_debugfs_cq {
 	struct hisi_sas_cq *cq;
 	void *complete_hdr;
@@ -440,15 +442,16 @@ struct hisi_hba {
 
 	/* debugfs memories */
 	/* Put Global AXI and RAS Register into register array */
-	struct hisi_sas_debugfs_regs debugfs_regs[DEBUGFS_REGS_NUM];
-	struct hisi_sas_debugfs_port debugfs_port_reg[HISI_SAS_MAX_PHYS];
-	struct hisi_sas_debugfs_cq debugfs_cq[HISI_SAS_MAX_QUEUES];
-	struct hisi_sas_debugfs_dq debugfs_dq[HISI_SAS_MAX_QUEUES];
-	struct hisi_sas_debugfs_iost debugfs_iost;
-	struct hisi_sas_debugfs_itct debugfs_itct;
+	struct hisi_sas_debugfs_regs debugfs_regs[HISI_SAS_MAX_DEBUGFS_DUMP][DEBUGFS_REGS_NUM];
+	struct hisi_sas_debugfs_port debugfs_port_reg[HISI_SAS_MAX_DEBUGFS_DUMP][HISI_SAS_MAX_PHYS];
+	struct hisi_sas_debugfs_cq debugfs_cq[HISI_SAS_MAX_DEBUGFS_DUMP][HISI_SAS_MAX_QUEUES];
+	struct hisi_sas_debugfs_dq debugfs_dq[HISI_SAS_MAX_DEBUGFS_DUMP][HISI_SAS_MAX_QUEUES];
+	struct hisi_sas_debugfs_iost debugfs_iost[HISI_SAS_MAX_DEBUGFS_DUMP];
+	struct hisi_sas_debugfs_itct debugfs_itct[HISI_SAS_MAX_DEBUGFS_DUMP];
+	struct hisi_sas_debugfs_iost_cache debugfs_iost_cache[HISI_SAS_MAX_DEBUGFS_DUMP];
+	struct hisi_sas_debugfs_itct_cache debugfs_itct_cache[HISI_SAS_MAX_DEBUGFS_DUMP];
+
 	u64 debugfs_timestamp;
-	struct hisi_sas_debugfs_iost_cache debugfs_iost_cache;
-	struct hisi_sas_debugfs_itct_cache debugfs_itct_cache;
 
 	struct dentry *debugfs_dir;
 	struct dentry *debugfs_dump_dentry;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5014a7a21aa4..b599595ea095 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1573,7 +1573,7 @@ static int hisi_sas_controller_reset(struct hisi_hba *hisi_hba)
 	struct Scsi_Host *shost = hisi_hba->shost;
 	int rc;
 
-	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct.itct)
+	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
 		queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
 
 	if (!hisi_hba->hw->soft_reset)
@@ -2065,7 +2065,7 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 
 	/* Internal abort timed out */
 	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-		if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct.itct)
+		if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
 			queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
 
 		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
@@ -2700,7 +2700,7 @@ static void hisi_sas_debugfs_snapshot_cq_reg(struct hisi_hba *hisi_hba)
 	int i;
 
 	for (i = 0; i < hisi_hba->queue_count; i++)
-		memcpy(hisi_hba->debugfs_cq[i].complete_hdr,
+		memcpy(hisi_hba->debugfs_cq[0][i].complete_hdr,
 		       hisi_hba->complete_hdr[i],
 		       HISI_SAS_QUEUE_SLOTS * queue_entry_size);
 }
@@ -2714,7 +2714,7 @@ static void hisi_sas_debugfs_snapshot_dq_reg(struct hisi_hba *hisi_hba)
 		struct hisi_sas_cmd_hdr *debugfs_cmd_hdr, *cmd_hdr;
 		int j;
 
-		debugfs_cmd_hdr = hisi_hba->debugfs_dq[i].hdr;
+		debugfs_cmd_hdr = hisi_hba->debugfs_dq[0][i].hdr;
 		cmd_hdr = hisi_hba->cmd_hdr[i];
 
 		for (j = 0; j < HISI_SAS_QUEUE_SLOTS; j++)
@@ -2732,7 +2732,7 @@ static void hisi_sas_debugfs_snapshot_port_reg(struct hisi_hba *hisi_hba)
 	u32 *databuf;
 
 	for (phy_cnt = 0; phy_cnt < hisi_hba->n_phy; phy_cnt++) {
-		databuf = hisi_hba->debugfs_port_reg[phy_cnt].data;
+		databuf = hisi_hba->debugfs_port_reg[0][phy_cnt].data;
 		for (i = 0; i < port->count; i++, databuf++) {
 			offset = port->base_off + 4 * i;
 			*databuf = port->read_port_reg(hisi_hba, phy_cnt,
@@ -2743,7 +2743,7 @@ static void hisi_sas_debugfs_snapshot_port_reg(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_debugfs_snapshot_global_reg(struct hisi_hba *hisi_hba)
 {
-	u32 *databuf = hisi_hba->debugfs_regs[DEBUGFS_GLOBAL].data;
+	u32 *databuf = hisi_hba->debugfs_regs[0][DEBUGFS_GLOBAL].data;
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	const struct hisi_sas_debugfs_reg *global =
 			hw->debugfs_reg_array[DEBUGFS_GLOBAL];
@@ -2755,7 +2755,7 @@ static void hisi_sas_debugfs_snapshot_global_reg(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_debugfs_snapshot_axi_reg(struct hisi_hba *hisi_hba)
 {
-	u32 *databuf = hisi_hba->debugfs_regs[DEBUGFS_AXI].data;
+	u32 *databuf = hisi_hba->debugfs_regs[0][DEBUGFS_AXI].data;
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	const struct hisi_sas_debugfs_reg *axi =
 			hw->debugfs_reg_array[DEBUGFS_AXI];
@@ -2768,7 +2768,7 @@ static void hisi_sas_debugfs_snapshot_axi_reg(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_debugfs_snapshot_ras_reg(struct hisi_hba *hisi_hba)
 {
-	u32 *databuf = hisi_hba->debugfs_regs[DEBUGFS_RAS].data;
+	u32 *databuf = hisi_hba->debugfs_regs[0][DEBUGFS_RAS].data;
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	const struct hisi_sas_debugfs_reg *ras =
 			hw->debugfs_reg_array[DEBUGFS_RAS];
@@ -2781,8 +2781,8 @@ static void hisi_sas_debugfs_snapshot_ras_reg(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_debugfs_snapshot_itct_reg(struct hisi_hba *hisi_hba)
 {
-	void *cachebuf = hisi_hba->debugfs_itct_cache.cache;
-	void *databuf = hisi_hba->debugfs_itct.itct;
+	void *cachebuf = hisi_hba->debugfs_itct_cache[0].cache;
+	void *databuf = hisi_hba->debugfs_itct[0].itct;
 	struct hisi_sas_itct *itct;
 	int i;
 
@@ -2800,8 +2800,8 @@ static void hisi_sas_debugfs_snapshot_itct_reg(struct hisi_hba *hisi_hba)
 static void hisi_sas_debugfs_snapshot_iost_reg(struct hisi_hba *hisi_hba)
 {
 	int max_command_entries = HISI_SAS_MAX_COMMANDS;
-	void *cachebuf = hisi_hba->debugfs_iost_cache.cache;
-	void *databuf = hisi_hba->debugfs_iost.iost;
+	void *cachebuf = hisi_hba->debugfs_iost_cache[0].cache;
+	void *databuf = hisi_hba->debugfs_iost[0].iost;
 	struct hisi_sas_iost *iost;
 	int i;
 
@@ -3211,7 +3211,7 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 			   debugfs_timestamp);
 
 	debugfs_create_file("global", 0400, dump_dentry,
-			    &hisi_hba->debugfs_regs[DEBUGFS_GLOBAL],
+			    &hisi_hba->debugfs_regs[0][DEBUGFS_GLOBAL],
 			    &hisi_sas_debugfs_global_fops);
 
 	/* Create port dir and files */
@@ -3220,7 +3220,7 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 		snprintf(name, 256, "%d", p);
 
 		debugfs_create_file(name, 0400, dentry,
-				    &hisi_hba->debugfs_port_reg[p],
+				    &hisi_hba->debugfs_port_reg[0][p],
 				    &hisi_sas_debugfs_port_fops);
 	}
 
@@ -3230,7 +3230,7 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 		snprintf(name, 256, "%d", c);
 
 		debugfs_create_file(name, 0400, dentry,
-				    &hisi_hba->debugfs_cq[c],
+				    &hisi_hba->debugfs_cq[0][c],
 				    &hisi_sas_debugfs_cq_fops);
 	}
 
@@ -3240,32 +3240,32 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 		snprintf(name, 256, "%d", d);
 
 		debugfs_create_file(name, 0400, dentry,
-				    &hisi_hba->debugfs_dq[d],
+				    &hisi_hba->debugfs_dq[0][d],
 				    &hisi_sas_debugfs_dq_fops);
 	}
 
 	debugfs_create_file("iost", 0400, dump_dentry,
-			    &hisi_hba->debugfs_iost,
+			    &hisi_hba->debugfs_iost[0],
 			    &hisi_sas_debugfs_iost_fops);
 
 	debugfs_create_file("iost_cache", 0400, dump_dentry,
-			    &hisi_hba->debugfs_iost_cache,
+			    &hisi_hba->debugfs_iost_cache[0],
 			    &hisi_sas_debugfs_iost_cache_fops);
 
 	debugfs_create_file("itct", 0400, dump_dentry,
-			    &hisi_hba->debugfs_itct,
+			    &hisi_hba->debugfs_itct[0],
 			    &hisi_sas_debugfs_itct_fops);
 
 	debugfs_create_file("itct_cache", 0400, dump_dentry,
-			    &hisi_hba->debugfs_itct_cache,
+			    &hisi_hba->debugfs_itct_cache[0],
 			    &hisi_sas_debugfs_itct_cache_fops);
 
 	debugfs_create_file("axi", 0400, dump_dentry,
-			    &hisi_hba->debugfs_regs[DEBUGFS_AXI],
+			    &hisi_hba->debugfs_regs[0][DEBUGFS_AXI],
 			    &hisi_sas_debugfs_axi_fops);
 
 	debugfs_create_file("ras", 0400, dump_dentry,
-			    &hisi_hba->debugfs_regs[DEBUGFS_RAS],
+			    &hisi_hba->debugfs_regs[0][DEBUGFS_RAS],
 			    &hisi_sas_debugfs_ras_fops);
 
 	return;
@@ -3711,38 +3711,40 @@ void hisi_sas_debugfs_work_handler(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_debugfs_work_handler);
 
-static void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
+static void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba, int dump_index)
 {
 	struct device *dev = hisi_hba->dev;
 	int i;
 
-	devm_kfree(dev, hisi_hba->debugfs_iost_cache.cache);
-	devm_kfree(dev, hisi_hba->debugfs_itct_cache.cache);
-	devm_kfree(dev, hisi_hba->debugfs_iost.iost);
+	devm_kfree(dev, hisi_hba->debugfs_iost_cache[dump_index].cache);
+	devm_kfree(dev, hisi_hba->debugfs_itct_cache[dump_index].cache);
+	devm_kfree(dev, hisi_hba->debugfs_iost[dump_index].iost);
+	devm_kfree(dev, hisi_hba->debugfs_itct[dump_index].itct);
 
 	for (i = 0; i < hisi_hba->queue_count; i++)
-		devm_kfree(dev, hisi_hba->debugfs_dq[i].hdr);
+		devm_kfree(dev, hisi_hba->debugfs_dq[dump_index][i].hdr);
 
 	for (i = 0; i < hisi_hba->queue_count; i++)
-		devm_kfree(dev, hisi_hba->debugfs_cq[i].complete_hdr);
+		devm_kfree(dev,
+			   hisi_hba->debugfs_cq[dump_index][i].complete_hdr);
 
 	for (i = 0; i < DEBUGFS_REGS_NUM; i++)
-		devm_kfree(dev, hisi_hba->debugfs_regs[i].data);
+		devm_kfree(dev, hisi_hba->debugfs_regs[dump_index][i].data);
 
 	for (i = 0; i < hisi_hba->n_phy; i++)
-		devm_kfree(dev, hisi_hba->debugfs_port_reg[i].data);
+		devm_kfree(dev, hisi_hba->debugfs_port_reg[dump_index][i].data);
 }
 
-static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
+static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba, int dump_index)
 {
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	struct device *dev = hisi_hba->dev;
-	int p, c, d, r;
+	int p, c, d, r, i;
 	size_t sz;
 
 	for (r = 0; r < DEBUGFS_REGS_NUM; r++) {
 		struct hisi_sas_debugfs_regs *regs =
-				&hisi_hba->debugfs_regs[r];
+				&hisi_hba->debugfs_regs[dump_index][r];
 
 		sz = hw->debugfs_reg_array[r]->count * 4;
 		regs->data = devm_kmalloc(dev, sz, GFP_KERNEL);
@@ -3754,7 +3756,7 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 	sz = hw->debugfs_reg_port->count * 4;
 	for (p = 0; p < hisi_hba->n_phy; p++) {
 		struct hisi_sas_debugfs_port *port =
-				&hisi_hba->debugfs_port_reg[p];
+				&hisi_hba->debugfs_port_reg[dump_index][p];
 
 		port->data = devm_kmalloc(dev, sz, GFP_KERNEL);
 		if (!port->data)
@@ -3765,7 +3767,7 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 	sz = hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
 	for (c = 0; c < hisi_hba->queue_count; c++) {
 		struct hisi_sas_debugfs_cq *cq =
-				&hisi_hba->debugfs_cq[c];
+				&hisi_hba->debugfs_cq[dump_index][c];
 
 		cq->complete_hdr = devm_kmalloc(dev, sz, GFP_KERNEL);
 		if (!cq->complete_hdr)
@@ -3776,7 +3778,7 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 	sz = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
 	for (d = 0; d < hisi_hba->queue_count; d++) {
 		struct hisi_sas_debugfs_dq *dq =
-				&hisi_hba->debugfs_dq[d];
+				&hisi_hba->debugfs_dq[dump_index][d];
 
 		dq->hdr = devm_kmalloc(dev, sz, GFP_KERNEL);
 		if (!dq->hdr)
@@ -3786,34 +3788,39 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 
 	sz = HISI_SAS_MAX_COMMANDS * sizeof(struct hisi_sas_iost);
 
-	hisi_hba->debugfs_iost.iost = devm_kmalloc(dev, sz, GFP_KERNEL);
-	if (!hisi_hba->debugfs_iost.iost)
+	hisi_hba->debugfs_iost[dump_index].iost =
+				devm_kmalloc(dev, sz, GFP_KERNEL);
+	if (!hisi_hba->debugfs_iost[dump_index].iost)
 		goto fail;
 
 	sz = HISI_SAS_IOST_ITCT_CACHE_NUM *
 	     sizeof(struct hisi_sas_iost_itct_cache);
 
-	hisi_hba->debugfs_iost_cache.cache = devm_kmalloc(dev, sz, GFP_KERNEL);
-	if (!hisi_hba->debugfs_iost_cache.cache)
+	hisi_hba->debugfs_iost_cache[dump_index].cache =
+				devm_kmalloc(dev, sz, GFP_KERNEL);
+	if (!hisi_hba->debugfs_iost_cache[dump_index].cache)
 		goto fail;
 
 	sz = HISI_SAS_IOST_ITCT_CACHE_NUM *
 	     sizeof(struct hisi_sas_iost_itct_cache);
 
-	hisi_hba->debugfs_itct_cache.cache = devm_kmalloc(dev, sz, GFP_KERNEL);
-	if (!hisi_hba->debugfs_itct_cache.cache)
+	hisi_hba->debugfs_itct_cache[dump_index].cache =
+				devm_kmalloc(dev, sz, GFP_KERNEL);
+	if (!hisi_hba->debugfs_itct_cache[dump_index].cache)
 		goto fail;
 
 	/* New memory allocation must be locate before itct */
 	sz = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_itct);
 
-	hisi_hba->debugfs_itct.itct = devm_kmalloc(dev, sz, GFP_KERNEL);
-	if (!hisi_hba->debugfs_itct.itct)
+	hisi_hba->debugfs_itct[dump_index].itct =
+				devm_kmalloc(dev, sz, GFP_KERNEL);
+	if (!hisi_hba->debugfs_itct[dump_index].itct)
 		goto fail;
 
 	return 0;
 fail:
-	hisi_sas_debugfs_release(hisi_hba);
+	for (i = 0; i < HISI_SAS_MAX_DEBUGFS_DUMP; i++)
+		hisi_sas_debugfs_release(hisi_hba, i);
 	return -ENOMEM;
 }
 
@@ -3848,6 +3855,7 @@ static void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
 void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
+	int i;
 
 	hisi_hba->debugfs_dir = debugfs_create_dir(dev_name(dev),
 						   hisi_sas_debugfs_dir);
@@ -3859,9 +3867,15 @@ void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 	/* create bist structures */
 	hisi_sas_debugfs_bist_init(hisi_hba);
 
-	if (hisi_sas_debugfs_alloc(hisi_hba)) {
-		debugfs_remove_recursive(hisi_hba->debugfs_dir);
-		dev_dbg(dev, "failed to init debugfs!\n");
+	hisi_hba->debugfs_dump_dentry =
+			debugfs_create_dir("dump", hisi_hba->debugfs_dir);
+
+	for (i = 0; i < HISI_SAS_MAX_DEBUGFS_DUMP; i++) {
+		if (hisi_sas_debugfs_alloc(hisi_hba, i)) {
+			debugfs_remove_recursive(hisi_hba->debugfs_dir);
+			dev_dbg(dev, "failed to init debugfs!\n");
+			break;
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(hisi_sas_debugfs_init);
-- 
2.17.1

