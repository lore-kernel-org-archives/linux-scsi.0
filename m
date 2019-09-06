Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4659DC43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 221132082C
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404893AbfIFM6N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 08:58:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6697 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404882AbfIFM6M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 08:58:12 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CA170DB4D3AA848288DE;
        Fri,  6 Sep 2019 20:58:10 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 20:58:04 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 11/13] scsi: hisi_sas: Add hisi_sas_debugfs_alloc() to centralise allocation
Date:   Fri, 6 Sep 2019 20:55:35 +0800
Message-ID: <1567774537-20003-12-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
References: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

We extract the code of memory allocate and construct an new function for
it. We think it's convenient for subsequent optimization.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 102 +++++++++++++++-----------
 1 file changed, 58 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b96732493137..e7056bbad7d7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3307,27 +3307,44 @@ void hisi_sas_debugfs_work_handler(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_debugfs_work_handler);
 
-void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
+void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = hisi_hba->dev;
+	int i;
+
+	devm_kfree(dev, hisi_hba->debugfs_iost_cache);
+	devm_kfree(dev, hisi_hba->debugfs_itct_cache);
+	devm_kfree(dev, hisi_hba->debugfs_iost);
+
+	for (i = 0; i < hisi_hba->queue_count; i++)
+		devm_kfree(dev, hisi_hba->debugfs_cmd_hdr[i]);
+
+	for (i = 0; i < hisi_hba->queue_count; i++)
+		devm_kfree(dev, hisi_hba->debugfs_complete_hdr[i]);
+
+	for (i = 0; i < DEBUGFS_REGS_NUM; i++)
+		devm_kfree(dev, hisi_hba->debugfs_regs[i]);
+
+	for (i = 0; i < hisi_hba->n_phy; i++)
+		devm_kfree(dev, hisi_hba->debugfs_port_reg[i]);
+}
+
+int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 {
-	int max_command_entries = HISI_SAS_MAX_COMMANDS;
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	struct device *dev = hisi_hba->dev;
-	int p, i, c, d;
+	int p, c, d;
 	size_t sz;
 
-	hisi_hba->debugfs_dir = debugfs_create_dir(dev_name(dev),
-						   hisi_sas_debugfs_dir);
-	debugfs_create_file("trigger_dump", 0600,
-			    hisi_hba->debugfs_dir,
-			    hisi_hba,
-			    &hisi_sas_debugfs_trigger_dump_fops);
+	hisi_hba->debugfs_dump_dentry =
+			debugfs_create_dir("dump", hisi_hba->debugfs_dir);
 
 	sz = hw->debugfs_reg_array[DEBUGFS_GLOBAL]->count * 4;
 	hisi_hba->debugfs_regs[DEBUGFS_GLOBAL] =
 				devm_kmalloc(dev, sz, GFP_KERNEL);
 
 	if (!hisi_hba->debugfs_regs[DEBUGFS_GLOBAL])
-		goto fail_global;
+		goto fail;
 
 	sz = hw->debugfs_reg_port->count * 4;
 	for (p = 0; p < hisi_hba->n_phy; p++) {
@@ -3335,7 +3352,7 @@ void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 			devm_kmalloc(dev, sz, GFP_KERNEL);
 
 		if (!hisi_hba->debugfs_port_reg[p])
-			goto fail_port;
+			goto fail;
 	}
 
 	sz = hw->debugfs_reg_array[DEBUGFS_AXI]->count * 4;
@@ -3343,14 +3360,14 @@ void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 		devm_kmalloc(dev, sz, GFP_KERNEL);
 
 	if (!hisi_hba->debugfs_regs[DEBUGFS_AXI])
-		goto fail_axi;
+		goto fail;
 
 	sz = hw->debugfs_reg_array[DEBUGFS_RAS]->count * 4;
 	hisi_hba->debugfs_regs[DEBUGFS_RAS] =
 		devm_kmalloc(dev, sz, GFP_KERNEL);
 
 	if (!hisi_hba->debugfs_regs[DEBUGFS_RAS])
-		goto fail_ras;
+		goto fail;
 
 	sz = hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
 	for (c = 0; c < hisi_hba->queue_count; c++) {
@@ -3358,7 +3375,7 @@ void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 			devm_kmalloc(dev, sz, GFP_KERNEL);
 
 		if (!hisi_hba->debugfs_complete_hdr[c])
-			goto fail_cq;
+			goto fail;
 	}
 
 	sz = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
@@ -3367,60 +3384,57 @@ void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 			devm_kmalloc(dev, sz, GFP_KERNEL);
 
 		if (!hisi_hba->debugfs_cmd_hdr[d])
-			goto fail_iost_dq;
+			goto fail;
 	}
 
-	sz = max_command_entries * sizeof(struct hisi_sas_iost);
+	sz = HISI_SAS_MAX_COMMANDS * sizeof(struct hisi_sas_iost);
 
 	hisi_hba->debugfs_iost = devm_kmalloc(dev, sz, GFP_KERNEL);
 	if (!hisi_hba->debugfs_iost)
-		goto fail_iost_dq;
+		goto fail;
 
 	sz = HISI_SAS_IOST_ITCT_CACHE_NUM *
 	     sizeof(struct hisi_sas_iost_itct_cache);
 
 	hisi_hba->debugfs_iost_cache = devm_kmalloc(dev, sz, GFP_KERNEL);
 	if (!hisi_hba->debugfs_iost_cache)
-		goto fail_iost_cache;
+		goto fail;
 
 	sz = HISI_SAS_IOST_ITCT_CACHE_NUM *
 	     sizeof(struct hisi_sas_iost_itct_cache);
 
 	hisi_hba->debugfs_itct_cache = devm_kmalloc(dev, sz, GFP_KERNEL);
 	if (!hisi_hba->debugfs_itct_cache)
-		goto fail_itct_cache;
+		goto fail;
 
 	/* New memory allocation must be locate before itct */
 	sz = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_itct);
 
 	hisi_hba->debugfs_itct = devm_kmalloc(dev, sz, GFP_KERNEL);
 	if (!hisi_hba->debugfs_itct)
-		goto fail_itct;
+		goto fail;
 
-	return;
-fail_itct:
-	devm_kfree(dev, hisi_hba->debugfs_iost_cache);
-fail_itct_cache:
-	devm_kfree(dev, hisi_hba->debugfs_iost_cache);
-fail_iost_cache:
-	devm_kfree(dev, hisi_hba->debugfs_iost);
-fail_iost_dq:
-	for (i = 0; i < d; i++)
-		devm_kfree(dev, hisi_hba->debugfs_cmd_hdr[i]);
-fail_cq:
-	for (i = 0; i < c; i++)
-		devm_kfree(dev, hisi_hba->debugfs_complete_hdr[i]);
-	devm_kfree(dev, hisi_hba->debugfs_regs[DEBUGFS_RAS]);
-fail_ras:
-	devm_kfree(dev, hisi_hba->debugfs_regs[DEBUGFS_AXI]);
-fail_axi:
-fail_port:
-	for (i = 0; i < p; i++)
-		devm_kfree(dev, hisi_hba->debugfs_port_reg[i]);
-	devm_kfree(dev, hisi_hba->debugfs_regs[DEBUGFS_GLOBAL]);
-fail_global:
-	debugfs_remove_recursive(hisi_hba->debugfs_dir);
-	dev_dbg(dev, "failed to init debugfs!\n");
+	return 0;
+fail:
+	hisi_sas_debugfs_release(hisi_hba);
+	return -ENOMEM;
+}
+
+void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = hisi_hba->dev;
+
+	hisi_hba->debugfs_dir = debugfs_create_dir(dev_name(dev),
+						   hisi_sas_debugfs_dir);
+	debugfs_create_file("trigger_dump", 0600,
+			    hisi_hba->debugfs_dir,
+			    hisi_hba,
+			    &hisi_sas_debugfs_trigger_dump_fops);
+
+	if (hisi_sas_debugfs_alloc(hisi_hba)) {
+		debugfs_remove_recursive(hisi_hba->debugfs_dir);
+		dev_dbg(dev, "failed to init debugfs!\n");
+	}
 }
 EXPORT_SYMBOL_GPL(hisi_sas_debugfs_init);
 
-- 
2.17.1

