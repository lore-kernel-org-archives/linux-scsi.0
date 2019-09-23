Return-Path: <SRS0=msWv=XS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5C7C3A5A6
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 05:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F2B820835
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 05:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbfIWFmH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 01:42:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58114 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729356AbfIWFmH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Sep 2019 01:42:07 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 83243E3C813AB3B23445;
        Mon, 23 Sep 2019 13:42:05 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Mon, 23 Sep 2019
 13:41:55 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: hisi_sas: Make three functions static
Date:   Mon, 23 Sep 2019 13:40:35 +0800
Message-ID: <20190923054035.19036-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix sparse warnings:

drivers/scsi/hisi_sas/hisi_sas_main.c:3686:6:
 warning: symbol 'hisi_sas_debugfs_release' was not declared. Should it be static?
drivers/scsi/hisi_sas/hisi_sas_main.c:3708:5:
 warning: symbol 'hisi_sas_debugfs_alloc' was not declared. Should it be static?
drivers/scsi/hisi_sas/hisi_sas_main.c:3799:6:
 warning: symbol 'hisi_sas_debugfs_bist_init' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d1513fd..0847e68 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3683,7 +3683,7 @@ void hisi_sas_debugfs_work_handler(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_debugfs_work_handler);
 
-void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
+static void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
 	int i;
@@ -3705,7 +3705,7 @@ void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
 		devm_kfree(dev, hisi_hba->debugfs_port_reg[i]);
 }
 
-int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
+static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 {
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	struct device *dev = hisi_hba->dev;
@@ -3796,7 +3796,7 @@ int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 	return -ENOMEM;
 }
 
-void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
+static void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
 {
 	hisi_hba->debugfs_bist_dentry =
 			debugfs_create_dir("bist", hisi_hba->debugfs_dir);
-- 
2.7.4


