Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA481CA9EBB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87F582166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502601AbfJXOLo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:11:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5168 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502311AbfJXOLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:11:43 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 87A609AA9AABC151AA19;
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
Subject: [PATCH v2 12/18] scsi: hisi_sas: Add debugfs file structure for IOST cache
Date:   Thu, 24 Oct 2019 22:08:19 +0800
Message-ID: <1571926105-74636-13-git-send-email-john.garry@huawei.com>
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
IOST cache at debugfs. This structure is bound to the corresponding debugfs
file, it can help callback function of debugfs file to get what it need.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  6 +++++-
 drivers/scsi/hisi_sas/hisi_sas_main.c | 16 ++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index f42f1b34f843..4e32d1b77d16 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -351,6 +351,10 @@ struct hisi_sas_debugfs_itct {
 	struct hisi_sas_itct *itct;
 };
 
+struct hisi_sas_debugfs_iost_cache {
+	struct hisi_sas_iost_itct_cache *cache;
+};
+
 struct hisi_hba {
 	/* This must be the first element, used by SHOST_TO_SAS_HA */
 	struct sas_ha_struct *p;
@@ -438,8 +442,8 @@ struct hisi_hba {
 	struct hisi_sas_debugfs_dq debugfs_dq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_debugfs_iost debugfs_iost;
 	struct hisi_sas_debugfs_itct debugfs_itct;
-	u64 *debugfs_iost_cache;
 	u64 debugfs_timestamp;
+	struct hisi_sas_debugfs_iost_cache debugfs_iost_cache;
 	u64 *debugfs_itct_cache;
 
 	struct dentry *debugfs_dir;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a35d3a76ac11..499a733f9a5a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2800,7 +2800,7 @@ static void hisi_sas_debugfs_snapshot_itct_reg(struct hisi_hba *hisi_hba)
 static void hisi_sas_debugfs_snapshot_iost_reg(struct hisi_hba *hisi_hba)
 {
 	int max_command_entries = HISI_SAS_MAX_COMMANDS;
-	void *cachebuf = hisi_hba->debugfs_iost_cache;
+	void *cachebuf = hisi_hba->debugfs_iost_cache.cache;
 	void *databuf = hisi_hba->debugfs_iost.iost;
 	struct hisi_sas_iost *iost;
 	int i;
@@ -3088,9 +3088,8 @@ static const struct file_operations hisi_sas_debugfs_iost_fops = {
 
 static int hisi_sas_debugfs_iost_cache_show(struct seq_file *s, void *p)
 {
-	struct hisi_hba *hisi_hba = s->private;
-	struct hisi_sas_iost_itct_cache *iost_cache =
-		(struct hisi_sas_iost_itct_cache *)hisi_hba->debugfs_iost_cache;
+	struct hisi_sas_debugfs_iost_cache *debugfs_iost_cache = s->private;
+	struct hisi_sas_iost_itct_cache *iost_cache = debugfs_iost_cache->cache;
 	u32 cache_size = HISI_SAS_IOST_ITCT_CACHE_DW_SZ * 4;
 	int i, tab_idx;
 	__le64 *iost;
@@ -3250,7 +3249,8 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 			    &hisi_hba->debugfs_iost,
 			    &hisi_sas_debugfs_iost_fops);
 
-	debugfs_create_file("iost_cache", 0400, dump_dentry, hisi_hba,
+	debugfs_create_file("iost_cache", 0400, dump_dentry,
+			    &hisi_hba->debugfs_iost_cache,
 			    &hisi_sas_debugfs_iost_cache_fops);
 
 	debugfs_create_file("itct", 0400, dump_dentry,
@@ -3716,7 +3716,7 @@ static void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
 	struct device *dev = hisi_hba->dev;
 	int i;
 
-	devm_kfree(dev, hisi_hba->debugfs_iost_cache);
+	devm_kfree(dev, hisi_hba->debugfs_iost_cache.cache);
 	devm_kfree(dev, hisi_hba->debugfs_itct_cache);
 	devm_kfree(dev, hisi_hba->debugfs_iost.iost);
 
@@ -3793,8 +3793,8 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 	sz = HISI_SAS_IOST_ITCT_CACHE_NUM *
 	     sizeof(struct hisi_sas_iost_itct_cache);
 
-	hisi_hba->debugfs_iost_cache = devm_kmalloc(dev, sz, GFP_KERNEL);
-	if (!hisi_hba->debugfs_iost_cache)
+	hisi_hba->debugfs_iost_cache.cache = devm_kmalloc(dev, sz, GFP_KERNEL);
+	if (!hisi_hba->debugfs_iost_cache.cache)
 		goto fail;
 
 	sz = HISI_SAS_IOST_ITCT_CACHE_NUM *
-- 
2.17.1

