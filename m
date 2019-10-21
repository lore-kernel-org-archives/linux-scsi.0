Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5256ECA9EB0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 336CD205ED
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbfJUQ0D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:26:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36394 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729507AbfJUQZg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 12:25:36 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 09693D1E7B5AACAB426E;
        Tue, 22 Oct 2019 00:25:30 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 22 Oct 2019 00:25:20 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 13/18] scsi: hisi_sas: Add debugfs file structure for ITCT cache
Date:   Tue, 22 Oct 2019 00:22:10 +0800
Message-ID: <1571674935-108326-14-git-send-email-john.garry@huawei.com>
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
ITCT cache at debugfs. This structure is bound to the corresponding debugfs
file, it can help callback function of debugfs file to get what it need.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  6 +++++-
 drivers/scsi/hisi_sas/hisi_sas_main.c | 16 ++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 4e32d1b77d16..a608b2bef0b4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -355,6 +355,10 @@ struct hisi_sas_debugfs_iost_cache {
 	struct hisi_sas_iost_itct_cache *cache;
 };
 
+struct hisi_sas_debugfs_itct_cache {
+	struct hisi_sas_iost_itct_cache *cache;
+};
+
 struct hisi_hba {
 	/* This must be the first element, used by SHOST_TO_SAS_HA */
 	struct sas_ha_struct *p;
@@ -444,7 +448,7 @@ struct hisi_hba {
 	struct hisi_sas_debugfs_itct debugfs_itct;
 	u64 debugfs_timestamp;
 	struct hisi_sas_debugfs_iost_cache debugfs_iost_cache;
-	u64 *debugfs_itct_cache;
+	struct hisi_sas_debugfs_itct_cache debugfs_itct_cache;
 
 	struct dentry *debugfs_dir;
 	struct dentry *debugfs_dump_dentry;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 60bd06b29767..2e9ed2c46611 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2781,7 +2781,7 @@ static void hisi_sas_debugfs_snapshot_ras_reg(struct hisi_hba *hisi_hba)
 
 static void hisi_sas_debugfs_snapshot_itct_reg(struct hisi_hba *hisi_hba)
 {
-	void *cachebuf = hisi_hba->debugfs_itct_cache;
+	void *cachebuf = hisi_hba->debugfs_itct_cache.cache;
 	void *databuf = hisi_hba->debugfs_itct.itct;
 	struct hisi_sas_itct *itct;
 	int i;
@@ -3155,9 +3155,8 @@ static const struct file_operations hisi_sas_debugfs_itct_fops = {
 
 static int hisi_sas_debugfs_itct_cache_show(struct seq_file *s, void *p)
 {
-	struct hisi_hba *hisi_hba = s->private;
-	struct hisi_sas_iost_itct_cache *itct_cache =
-		(struct hisi_sas_iost_itct_cache *)hisi_hba->debugfs_itct_cache;
+	struct hisi_sas_debugfs_itct_cache *debugfs_itct_cache = s->private;
+	struct hisi_sas_iost_itct_cache *itct_cache = debugfs_itct_cache->cache;
 	u32 cache_size = HISI_SAS_IOST_ITCT_CACHE_DW_SZ * 4;
 	int i, tab_idx;
 	__le64 *itct;
@@ -3257,7 +3256,8 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 			    &hisi_hba->debugfs_itct,
 			    &hisi_sas_debugfs_itct_fops);
 
-	debugfs_create_file("itct_cache", 0400, dump_dentry, hisi_hba,
+	debugfs_create_file("itct_cache", 0400, dump_dentry,
+			    &hisi_hba->debugfs_itct_cache,
 			    &hisi_sas_debugfs_itct_cache_fops);
 
 	debugfs_create_file("axi", 0400, dump_dentry,
@@ -3716,7 +3716,7 @@ static void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
 	int i;
 
 	devm_kfree(dev, hisi_hba->debugfs_iost_cache.cache);
-	devm_kfree(dev, hisi_hba->debugfs_itct_cache);
+	devm_kfree(dev, hisi_hba->debugfs_itct_cache.cache);
 	devm_kfree(dev, hisi_hba->debugfs_iost.iost);
 
 	for (i = 0; i < hisi_hba->queue_count; i++)
@@ -3799,8 +3799,8 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 	sz = HISI_SAS_IOST_ITCT_CACHE_NUM *
 	     sizeof(struct hisi_sas_iost_itct_cache);
 
-	hisi_hba->debugfs_itct_cache = devm_kmalloc(dev, sz, GFP_KERNEL);
-	if (!hisi_hba->debugfs_itct_cache)
+	hisi_hba->debugfs_itct_cache.cache = devm_kmalloc(dev, sz, GFP_KERNEL);
+	if (!hisi_hba->debugfs_itct_cache.cache)
 		goto fail;
 
 	/* New memory allocation must be locate before itct */
-- 
2.17.1

