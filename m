Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB10CA9EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F27F2084B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfJUQ0O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:26:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33168 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728639AbfJUQZ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 12:25:29 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 00945D827347EB20B329;
        Tue, 22 Oct 2019 00:25:25 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 22 Oct 2019 00:25:18 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 06/18] scsi: hisi_sas: Add debugfs file structure for CQ
Date:   Tue, 22 Oct 2019 00:22:03 +0800
Message-ID: <1571674935-108326-7-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571674935-108326-1-git-send-email-john.garry@huawei.com>
References: <1571674935-108326-1-git-send-email-john.garry@huawei.com>
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
CQ pointer for CQ at debugfs. This structure is bound to the corresponding
debugfs file, it can help callback function of debugfs file to get what it
need.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  7 ++++++-
 drivers/scsi/hisi_sas/hisi_sas_main.c | 29 +++++++++++++++------------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 7069dae4cec9..5b0f08286af7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -323,6 +323,11 @@ struct hisi_sas_hw {
 	const struct hisi_sas_debugfs_reg *debugfs_reg_port;
 };
 
+struct hisi_sas_debugfs_cq {
+	struct hisi_sas_cq *cq;
+	void *complete_hdr;
+};
+
 struct hisi_hba {
 	/* This must be the first element, used by SHOST_TO_SAS_HA */
 	struct sas_ha_struct *p;
@@ -406,7 +411,7 @@ struct hisi_hba {
 	/* Put Global AXI and RAS Register into register array */
 	u32 *debugfs_regs[DEBUGFS_REGS_NUM];
 	u32 *debugfs_port_reg[HISI_SAS_MAX_PHYS];
-	void *debugfs_complete_hdr[HISI_SAS_MAX_QUEUES];
+	struct hisi_sas_debugfs_cq debugfs_cq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_cmd_hdr	*debugfs_cmd_hdr[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_iost *debugfs_iost;
 	struct hisi_sas_itct *debugfs_itct;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a983d08c03aa..d2e50d12e075 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2700,7 +2700,7 @@ static void hisi_sas_debugfs_snapshot_cq_reg(struct hisi_hba *hisi_hba)
 	int i;
 
 	for (i = 0; i < hisi_hba->queue_count; i++)
-		memcpy(hisi_hba->debugfs_complete_hdr[i],
+		memcpy(hisi_hba->debugfs_cq[i].complete_hdr,
 		       hisi_hba->complete_hdr[i],
 		       HISI_SAS_QUEUE_SLOTS * queue_entry_size);
 }
@@ -2985,13 +2985,13 @@ static void hisi_sas_show_row_32(struct seq_file *s, int index,
 	seq_puts(s, "\n");
 }
 
-static void hisi_sas_cq_show_slot(struct seq_file *s, int slot, void *cq_ptr)
+static void hisi_sas_cq_show_slot(struct seq_file *s, int slot,
+				  struct hisi_sas_debugfs_cq *debugfs_cq)
 {
-	struct hisi_sas_cq *cq = cq_ptr;
+	struct hisi_sas_cq *cq = debugfs_cq->cq;
 	struct hisi_hba *hisi_hba = cq->hisi_hba;
-	void *complete_queue = hisi_hba->debugfs_complete_hdr[cq->id];
-	__le32 *complete_hdr = complete_queue +
-			(hisi_hba->hw->complete_hdr_size * slot);
+	__le32 *complete_hdr = debugfs_cq->complete_hdr +
+			       (hisi_hba->hw->complete_hdr_size * slot);
 
 	hisi_sas_show_row_32(s, slot,
 			     hisi_hba->hw->complete_hdr_size,
@@ -3000,11 +3000,11 @@ static void hisi_sas_cq_show_slot(struct seq_file *s, int slot, void *cq_ptr)
 
 static int hisi_sas_debugfs_cq_show(struct seq_file *s, void *p)
 {
-	struct hisi_sas_cq *cq = s->private;
+	struct hisi_sas_debugfs_cq *debugfs_cq = s->private;
 	int slot;
 
 	for (slot = 0; slot < HISI_SAS_QUEUE_SLOTS; slot++) {
-		hisi_sas_cq_show_slot(s, slot, cq);
+		hisi_sas_cq_show_slot(s, slot, debugfs_cq);
 	}
 	return 0;
 }
@@ -3227,7 +3227,8 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 	for (c = 0; c < hisi_hba->queue_count; c++) {
 		snprintf(name, 256, "%d", c);
 
-		debugfs_create_file(name, 0400, dentry, &hisi_hba->cq[c],
+		debugfs_create_file(name, 0400, dentry,
+				    &hisi_hba->debugfs_cq[c],
 				    &hisi_sas_debugfs_cq_fops);
 	}
 
@@ -3713,7 +3714,7 @@ static void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
 		devm_kfree(dev, hisi_hba->debugfs_cmd_hdr[i]);
 
 	for (i = 0; i < hisi_hba->queue_count; i++)
-		devm_kfree(dev, hisi_hba->debugfs_complete_hdr[i]);
+		devm_kfree(dev, hisi_hba->debugfs_cq[i].complete_hdr);
 
 	for (i = 0; i < DEBUGFS_REGS_NUM; i++)
 		devm_kfree(dev, hisi_hba->debugfs_regs[i]);
@@ -3761,11 +3762,13 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 
 	sz = hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
 	for (c = 0; c < hisi_hba->queue_count; c++) {
-		hisi_hba->debugfs_complete_hdr[c] =
-			devm_kmalloc(dev, sz, GFP_KERNEL);
+		struct hisi_sas_debugfs_cq *cq =
+				&hisi_hba->debugfs_cq[c];
 
-		if (!hisi_hba->debugfs_complete_hdr[c])
+		cq->complete_hdr = devm_kmalloc(dev, sz, GFP_KERNEL);
+		if (!cq->complete_hdr)
 			goto fail;
+		cq->cq = &hisi_hba->cq[c];
 	}
 
 	sz = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
-- 
2.17.1

