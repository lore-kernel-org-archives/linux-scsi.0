Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881D7C43465
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 14:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47307221EC
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 14:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgIUO0M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 10:26:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34004 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727131AbgIUO0L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Sep 2020 10:26:11 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F3610FCBA3A5F19E4271;
        Mon, 21 Sep 2020 22:26:06 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Mon, 21 Sep 2020
 22:25:57 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <aacraid@microsemi.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <balsundar.p@microsemi.com>,
        <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: aacraid: move declaration of 'aac_sync_mode' to aacraid.h
Date:   Mon, 21 Sep 2020 22:27:07 +0800
Message-ID: <20200921142707.874888-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following sparse warning:

drivers/scsi/aacraid/aachba.c:244:5: warning: symbol 'aac_sync_mode' was
not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/aacraid/aacraid.h  | 1 +
 drivers/scsi/aacraid/comminit.c | 1 -
 drivers/scsi/aacraid/linit.c    | 1 -
 drivers/scsi/aacraid/src.c      | 1 -
 4 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index e3e4ecbea726..31aa752c39dd 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2769,4 +2769,5 @@ extern int update_interval;
 extern int check_interval;
 extern int aac_check_reset;
 extern int aac_fib_dump;
+extern int aac_sync_mode;
 #endif
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 355b16f0b145..e627271b3f15 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -511,7 +511,6 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 {
 	u32 status[5];
 	struct Scsi_Host * host = dev->scsi_host_ptr;
-	extern int aac_sync_mode;
 
 	/*
 	 *	Check the preferred comm settings, defaults from template.
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 8f3772480582..d820995a826f 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1636,7 +1636,6 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	int unique_id = 0;
 	u64 dmamask;
 	int mask_bits = 0;
-	extern int aac_sync_mode;
 
 	/*
 	 * Only series 7 needs freset.
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 11ef58204e96..a63976deab4f 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -78,7 +78,6 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 		unsigned long sflags;
 		struct list_head *entry;
 		int send_it = 0;
-		extern int aac_sync_mode;
 
 		if (!aac_sync_mode && !dev->msi_enabled) {
 			src_writel(dev, MUnit.ODR_C, bellbits);
-- 
2.25.4

