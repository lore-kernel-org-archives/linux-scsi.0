Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9F3CA9EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2385205ED
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbfJUQZh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:25:37 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36528 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729777AbfJUQZh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 12:25:37 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1800A6E216A3CD5C584D;
        Tue, 22 Oct 2019 00:25:30 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 22 Oct 2019 00:25:19 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 10/18] scsi: hisi_sas: Add debugfs file structure for IOST
Date:   Tue, 22 Oct 2019 00:22:07 +0800
Message-ID: <1571674935-108326-11-git-send-email-john.garry@huawei.com>
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

Create a file structure which was used to save the memory address for
IOST at debugfs. This structure is bound to the corresponding debugfs file,
it can help callback function of debugfs file to get what it need.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  6 +++++-
 drivers/scsi/hisi_sas/hisi_sas_main.c | 21 +++++++++++----------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index af5f836e5807..c4bcaa5aff8a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -343,6 +343,10 @@ struct hisi_sas_debugfs_port {
 	u32 *data;
 };
 
+struct hisi_sas_debugfs_iost {
+	struct hisi_sas_iost *iost;
+};
+
 struct hisi_hba {
 	/* This must be the first element, used by SHOST_TO_SAS_HA */
 	struct sas_ha_struct *p;
@@ -428,7 +432,7 @@ struct hisi_hba {
 	struct hisi_sas_debugfs_port debugfs_port_reg[HISI_SAS_MAX_PHYS];
 	struct hisi_sas_debugfs_cq debugfs_cq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_debugfs_dq debugfs_dq[HISI_SAS_MAX_QUEUES];
-	struct hisi_sas_iost *debugfs_iost;
+	struct hisi_sas_debugfs_iost debugfs_iost;
 	struct hisi_sas_itct *debugfs_itct;
 	u64 *debugfs_iost_cache;
 	u64 debugfs_timestamp;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b225717a6b0a..0d647ffef06e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2801,7 +2801,7 @@ static void hisi_sas_debugfs_snapshot_iost_reg(struct hisi_hba *hisi_hba)
 {
 	int max_command_entries = HISI_SAS_MAX_COMMANDS;
 	void *cachebuf = hisi_hba->debugfs_iost_cache;
-	void *databuf = hisi_hba->debugfs_iost;
+	void *databuf = hisi_hba->debugfs_iost.iost;
 	struct hisi_sas_iost *iost;
 	int i;
 
@@ -3060,14 +3060,14 @@ static const struct file_operations hisi_sas_debugfs_dq_fops = {
 
 static int hisi_sas_debugfs_iost_show(struct seq_file *s, void *p)
 {
-	struct hisi_hba *hisi_hba = s->private;
-	struct hisi_sas_iost *debugfs_iost = hisi_hba->debugfs_iost;
+	struct hisi_sas_debugfs_iost *debugfs_iost = s->private;
+	struct hisi_sas_iost *iost = debugfs_iost->iost;
 	int i, max_command_entries = HISI_SAS_MAX_COMMANDS;
 
-	for (i = 0; i < max_command_entries; i++, debugfs_iost++) {
-		__le64 *iost = &debugfs_iost->qw0;
+	for (i = 0; i < max_command_entries; i++, iost++) {
+		__le64 *data = &iost->qw0;
 
-		hisi_sas_show_row_64(s, i, sizeof(*debugfs_iost), iost);
+		hisi_sas_show_row_64(s, i, sizeof(*iost), data);
 	}
 
 	return 0;
@@ -3246,7 +3246,8 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 				    &hisi_sas_debugfs_dq_fops);
 	}
 
-	debugfs_create_file("iost", 0400, dump_dentry, hisi_hba,
+	debugfs_create_file("iost", 0400, dump_dentry,
+			    &hisi_hba->debugfs_iost,
 			    &hisi_sas_debugfs_iost_fops);
 
 	debugfs_create_file("iost_cache", 0400, dump_dentry, hisi_hba,
@@ -3715,7 +3716,7 @@ static void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
 
 	devm_kfree(dev, hisi_hba->debugfs_iost_cache);
 	devm_kfree(dev, hisi_hba->debugfs_itct_cache);
-	devm_kfree(dev, hisi_hba->debugfs_iost);
+	devm_kfree(dev, hisi_hba->debugfs_iost.iost);
 
 	for (i = 0; i < hisi_hba->queue_count; i++)
 		devm_kfree(dev, hisi_hba->debugfs_dq[i].hdr);
@@ -3783,8 +3784,8 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 
 	sz = HISI_SAS_MAX_COMMANDS * sizeof(struct hisi_sas_iost);
 
-	hisi_hba->debugfs_iost = devm_kmalloc(dev, sz, GFP_KERNEL);
-	if (!hisi_hba->debugfs_iost)
+	hisi_hba->debugfs_iost.iost = devm_kmalloc(dev, sz, GFP_KERNEL);
+	if (!hisi_hba->debugfs_iost.iost)
 		goto fail;
 
 	sz = HISI_SAS_IOST_ITCT_CACHE_NUM *
-- 
2.17.1

