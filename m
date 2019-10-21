Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A9ECA9EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 625E521783
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfJUQ0g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:26:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33126 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728292AbfJUQZ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 12:25:27 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0583C20F66B56A14DC87;
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
Subject: [PATCH 05/18] scsi: hisi_sas: Add timestamp for a debugfs dump
Date:   Tue, 22 Oct 2019 00:22:02 +0800
Message-ID: <1571674935-108326-6-git-send-email-john.garry@huawei.com>
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

It's useful to know when the dump occurred, so add a timestamp file for
this.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 83232e8472fb..7069dae4cec9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/regmap.h>
+#include <linux/timer.h>
 #include <scsi/sas_ata.h>
 #include <scsi/libsas.h>
 
@@ -410,6 +411,7 @@ struct hisi_hba {
 	struct hisi_sas_iost *debugfs_iost;
 	struct hisi_sas_itct *debugfs_itct;
 	u64 *debugfs_iost_cache;
+	u64 debugfs_timestamp;
 	u64 *debugfs_itct_cache;
 
 	struct dentry *debugfs_dir;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a7bac5dc389a..a983d08c03aa 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3194,6 +3194,7 @@ static const struct file_operations hisi_sas_debugfs_itct_cache_fops = {
 
 static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 {
+	u64 *debugfs_timestamp;
 	struct dentry *dump_dentry;
 	struct dentry *dentry;
 	char name[256];
@@ -3201,10 +3202,14 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 	int c;
 	int d;
 
+	debugfs_timestamp = &hisi_hba->debugfs_timestamp;
 	/* Create dump dir inside device dir */
 	dump_dentry = debugfs_create_dir("dump", hisi_hba->debugfs_dir);
 	hisi_hba->debugfs_dump_dentry = dump_dentry;
 
+	debugfs_create_u64("timestamp", 0400, dump_dentry,
+			   debugfs_timestamp);
+
 	debugfs_create_file("global", 0400, dump_dentry, hisi_hba,
 			    &hisi_sas_debugfs_global_fops);
 
@@ -3684,7 +3689,9 @@ void hisi_sas_debugfs_work_handler(struct work_struct *work)
 {
 	struct hisi_hba *hisi_hba =
 		container_of(work, struct hisi_hba, debugfs_work);
+	u64 timestamp = local_clock() / NSEC_PER_MSEC;
 
+	hisi_hba->debugfs_timestamp = timestamp;
 	if (hisi_hba->debugfs_snapshot)
 		return;
 	hisi_hba->debugfs_snapshot = true;
-- 
2.17.1

