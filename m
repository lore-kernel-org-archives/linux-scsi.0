Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF06BC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 09:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78BFF6191D
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 09:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbhC2JP5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 05:15:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14181 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbhC2JP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 05:15:26 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F86L74jBqzmbKD;
        Mon, 29 Mar 2021 17:12:47 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.498.0; Mon, 29 Mar 2021
 17:15:16 +0800
From:   Shixin Liu <liushixin2@huawei.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shixin Liu <liushixin2@huawei.com>
Subject: [PATCH -next] scsi: megaraid_sas: Use DEFINE_SPINLOCK() for spinlock
Date:   Mon, 29 Mar 2021 17:45:32 +0800
Message-ID: <20210329094532.4165147-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 4d4e9dbe5193..8ed347eebf07 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -213,7 +213,7 @@ static bool support_nvme_encapsulation;
 static bool support_pci_lane_margining;
 
 /* define lock for aen poll */
-static spinlock_t poll_aen_lock;
+static DEFINE_SPINLOCK(poll_aen_lock);
 
 extern struct dentry *megasas_debugfs_root;
 extern int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
@@ -8934,8 +8934,6 @@ static int __init megasas_init(void)
 	 */
 	pr_info("megasas: %s\n", MEGASAS_VERSION);
 
-	spin_lock_init(&poll_aen_lock);
-
 	support_poll_for_event = 2;
 	support_device_change = 1;
 	support_nvme_encapsulation = true;
-- 
2.25.1

