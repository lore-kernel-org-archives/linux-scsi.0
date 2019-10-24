Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1BDCA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE2952166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409382AbfJXOLm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:11:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5160 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393687AbfJXOLl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:11:41 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5B33FF7F16871DCC4F29;
        Thu, 24 Oct 2019 22:11:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:11:26 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v2 11/18] scsi: hisi_sas: Add debugfs file structure for ITCT
Date:   Thu, 24 Oct 2019 22:08:18 +0800
Message-ID: <1571926105-74636-12-git-send-email-john.garry@huawei.com>
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

Create a file structure which was used to save the memory address for
ITCT at debugfs. This structure is bound to the corresponding debugfs file,
it can help callback function of debugfs file to get what it need.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  6 +++++-
 drivers/scsi/hisi_sas/hisi_sas_main.c | 23 ++++++++++++-----------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index c4bcaa5aff8a..f42f1b34f843 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -347,6 +347,10 @@ struct hisi_sas_debugfs_iost {
 	struct hisi_sas_iost *iost;
 };
 
+struct hisi_sas_debugfs_itct {
+	struct hisi_sas_itct *itct;
+};
+
 struct hisi_hba {
 	/* This must be the first element, used by SHOST_TO_SAS_HA */
 	struct sas_ha_struct *p;
@@ -433,7 +437,7 @@ struct hisi_hba {
 	struct hisi_sas_debugfs_cq debugfs_cq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_debugfs_dq debugfs_dq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_debugfs_iost debugfs_iost;
-	struct hisi_sas_itct *debugfs_itct;
+	struct hisi_sas_debugfs_itct debugfs_itct;
 	u64 *debugfs_iost_cache;
 	u64 debugfs_timestamp;
 	u64 *debugfs_itct_cache;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 55191056f37f..a35d3a76ac11 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1573,7 +1573,7 @@ static int hisi_sas_controller_reset(struct hisi_hba *hisi_hba)
 	struct Scsi_Host *shost = hisi_hba->shost;
 	int rc;
 
-	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct)
+	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct.itct)
 		queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
 
 	if (!hisi_hba->hw->soft_reset)
@@ -2065,7 +2065,7 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 
 	/* Internal abort timed out */
 	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-		if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct)
+		if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct.itct)
 			queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
 
 		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
@@ -2782,7 +2782,7 @@ static void hisi_sas_debugfs_snapshot_ras_reg(struct hisi_hba *hisi_hba)
 static void hisi_sas_debugfs_snapshot_itct_reg(struct hisi_hba *hisi_hba)
 {
 	void *cachebuf = hisi_hba->debugfs_itct_cache;
-	void *databuf = hisi_hba->debugfs_itct;
+	void *databuf = hisi_hba->debugfs_itct.itct;
 	struct hisi_sas_itct *itct;
 	int i;
 
@@ -3129,13 +3129,13 @@ static const struct file_operations hisi_sas_debugfs_iost_cache_fops = {
 static int hisi_sas_debugfs_itct_show(struct seq_file *s, void *p)
 {
 	int i;
-	struct hisi_hba *hisi_hba = s->private;
-	struct hisi_sas_itct *debugfs_itct = hisi_hba->debugfs_itct;
+	struct hisi_sas_debugfs_itct *debugfs_itct = s->private;
+	struct hisi_sas_itct *itct = debugfs_itct->itct;
 
-	for (i = 0; i < HISI_SAS_MAX_ITCT_ENTRIES; i++, debugfs_itct++) {
-		__le64 *itct = &debugfs_itct->qw0;
+	for (i = 0; i < HISI_SAS_MAX_ITCT_ENTRIES; i++, itct++) {
+		__le64 *data = &itct->qw0;
 
-		hisi_sas_show_row_64(s, i, sizeof(*debugfs_itct), itct);
+		hisi_sas_show_row_64(s, i, sizeof(*itct), data);
 	}
 
 	return 0;
@@ -3253,7 +3253,8 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 	debugfs_create_file("iost_cache", 0400, dump_dentry, hisi_hba,
 			    &hisi_sas_debugfs_iost_cache_fops);
 
-	debugfs_create_file("itct", 0400, dump_dentry, hisi_hba,
+	debugfs_create_file("itct", 0400, dump_dentry,
+			    &hisi_hba->debugfs_itct,
 			    &hisi_sas_debugfs_itct_fops);
 
 	debugfs_create_file("itct_cache", 0400, dump_dentry, hisi_hba,
@@ -3806,8 +3807,8 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 	/* New memory allocation must be locate before itct */
 	sz = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_itct);
 
-	hisi_hba->debugfs_itct = devm_kmalloc(dev, sz, GFP_KERNEL);
-	if (!hisi_hba->debugfs_itct)
+	hisi_hba->debugfs_itct.itct = devm_kmalloc(dev, sz, GFP_KERNEL);
+	if (!hisi_hba->debugfs_itct.itct)
 		goto fail;
 
 	return 0;
-- 
2.17.1

