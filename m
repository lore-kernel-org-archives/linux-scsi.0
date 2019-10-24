Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAB8CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E758205C9
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502706AbfJXOMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:12:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5157 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389658AbfJXOMA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:12:00 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 53DB15FF819DE970BAB0;
        Thu, 24 Oct 2019 22:11:30 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:11:23 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v2 01/18] scsi: hisi_sas: Don't create debugfs dump folder twice
Date:   Thu, 24 Oct 2019 22:08:08 +0800
Message-ID: <1571926105-74636-2-git-send-email-john.garry@huawei.com>
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

