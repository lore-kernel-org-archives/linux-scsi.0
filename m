Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA31DCA9EB0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82C652173B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbfJUQZ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:25:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33122 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727303AbfJUQZ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 12:25:27 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F056D2AD5D5169600816;
        Tue, 22 Oct 2019 00:25:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 22 Oct 2019 00:25:16 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 01/18] scsi: hisi_sas: Don't create debugfs dump folder twice
Date:   Tue, 22 Oct 2019 00:21:58 +0800
Message-ID: <1571674935-108326-2-git-send-email-john.garry@huawei.com>
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

From: Xiang Chen <chenxiang66@hisilicon.com>

Due to a merge error, we attempt to create 2x debugfs dump folders, which
fails:
[  861.101914] debugfs: Directory 'dump' with parent '0000:74:02.0'
already present!

This breaks the dump function.

To fix, remove the superfluous attempt to create the folder.

Fixes: 7ec7082c57ec ("scsi: hisi_sas: Add hisi_sas_debugfs_alloc() to centralise allocation")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1a25f0f15fd0..ceba1016b77f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3712,9 +3712,6 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 	int p, c, d;
 	size_t sz;
 
-	hisi_hba->debugfs_dump_dentry =
-			debugfs_create_dir("dump", hisi_hba->debugfs_dir);
-
 	sz = hw->debugfs_reg_array[DEBUGFS_GLOBAL]->count * 4;
 	hisi_hba->debugfs_regs[DEBUGFS_GLOBAL] =
 				devm_kmalloc(dev, sz, GFP_KERNEL);
-- 
2.17.1

