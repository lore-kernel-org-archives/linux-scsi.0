Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1770FCA9EB0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E233E205ED
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbfJUQ0P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:26:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33166 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727303AbfJUQZ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 12:25:29 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0F7AA335752A7A844510;
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
Subject: [PATCH 07/18] scsi: hisi_sas: Add debugfs file structure for DQ
Date:   Tue, 22 Oct 2019 00:22:04 +0800
Message-ID: <1571674935-108326-8-git-send-email-john.garry@huawei.com>
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
DQ pointer for DQ at debugfs. This structure is bound to the corresponding
debugfs file, it can help callback function of debugfs file to get what it
need.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  7 ++++++-
 drivers/scsi/hisi_sas/hisi_sas_main.c | 22 ++++++++++++----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 5b0f08286af7..91c10be3dfb7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -328,6 +328,11 @@ struct hisi_sas_debugfs_cq {
 	void *complete_hdr;
 };
 
+struct hisi_sas_debugfs_dq {
+	struct hisi_sas_dq *dq;
+	struct hisi_sas_cmd_hdr *hdr;
+};
+
 struct hisi_hba {
 	/* This must be the first element, used by SHOST_TO_SAS_HA */
 	struct sas_ha_struct *p;
@@ -412,7 +417,7 @@ struct hisi_hba {
 	u32 *debugfs_regs[DEBUGFS_REGS_NUM];
 	u32 *debugfs_port_reg[HISI_SAS_MAX_PHYS];
 	struct hisi_sas_debugfs_cq debugfs_cq[HISI_SAS_MAX_QUEUES];
-	struct hisi_sas_cmd_hdr	*debugfs_cmd_hdr[HISI_SAS_MAX_QUEUES];
+	struct hisi_sas_debugfs_dq debugfs_dq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_iost *debugfs_iost;
 	struct hisi_sas_itct *debugfs_itct;
 	u64 *debugfs_iost_cache;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d2e50d12e075..d28461e65bde 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2711,10 +2711,10 @@ static void hisi_sas_debugfs_snapshot_dq_reg(struct hisi_hba *hisi_hba)
 	int i;
 
 	for (i = 0; i < hisi_hba->queue_count; i++) {
-		struct hisi_sas_cmd_hdr	*debugfs_cmd_hdr, *cmd_hdr;
+		struct hisi_sas_cmd_hdr *debugfs_cmd_hdr, *cmd_hdr;
 		int j;
 
-		debugfs_cmd_hdr = hisi_hba->debugfs_cmd_hdr[i];
+		debugfs_cmd_hdr = hisi_hba->debugfs_dq[i].hdr;
 		cmd_hdr = hisi_hba->cmd_hdr[i];
 
 		for (j = 0; j < HISI_SAS_QUEUE_SLOTS; j++)
@@ -3024,9 +3024,8 @@ static const struct file_operations hisi_sas_debugfs_cq_fops = {
 
 static void hisi_sas_dq_show_slot(struct seq_file *s, int slot, void *dq_ptr)
 {
-	struct hisi_sas_dq *dq = dq_ptr;
-	struct hisi_hba *hisi_hba = dq->hisi_hba;
-	void *cmd_queue = hisi_hba->debugfs_cmd_hdr[dq->id];
+	struct hisi_sas_debugfs_dq *debugfs_dq = dq_ptr;
+	void *cmd_queue = debugfs_dq->hdr;
 	__le32 *cmd_hdr = cmd_queue +
 		sizeof(struct hisi_sas_cmd_hdr) * slot;
 
@@ -3237,7 +3236,8 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 	for (d = 0; d < hisi_hba->queue_count; d++) {
 		snprintf(name, 256, "%d", d);
 
-		debugfs_create_file(name, 0400, dentry, &hisi_hba->dq[d],
+		debugfs_create_file(name, 0400, dentry,
+				    &hisi_hba->debugfs_dq[d],
 				    &hisi_sas_debugfs_dq_fops);
 	}
 
@@ -3711,7 +3711,7 @@ static void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
 	devm_kfree(dev, hisi_hba->debugfs_iost);
 
 	for (i = 0; i < hisi_hba->queue_count; i++)
-		devm_kfree(dev, hisi_hba->debugfs_cmd_hdr[i]);
+		devm_kfree(dev, hisi_hba->debugfs_dq[i].hdr);
 
 	for (i = 0; i < hisi_hba->queue_count; i++)
 		devm_kfree(dev, hisi_hba->debugfs_cq[i].complete_hdr);
@@ -3773,11 +3773,13 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 
 	sz = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
 	for (d = 0; d < hisi_hba->queue_count; d++) {
-		hisi_hba->debugfs_cmd_hdr[d] =
-			devm_kmalloc(dev, sz, GFP_KERNEL);
+		struct hisi_sas_debugfs_dq *dq =
+				&hisi_hba->debugfs_dq[d];
 
-		if (!hisi_hba->debugfs_cmd_hdr[d])
+		dq->hdr = devm_kmalloc(dev, sz, GFP_KERNEL);
+		if (!dq->hdr)
 			goto fail;
+		dq->dq = &hisi_hba->dq[d];
 	}
 
 	sz = HISI_SAS_MAX_COMMANDS * sizeof(struct hisi_sas_iost);
-- 
2.17.1

