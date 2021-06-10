Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09613C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 08:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E51D5613CB
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 08:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhFJIXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 04:23:48 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5484 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbhFJIXj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 04:23:39 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0xhC4cSxzZfyT;
        Thu, 10 Jun 2021 16:18:51 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 16:21:42 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 16:21:41 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] scsi: zorro7xx: remove unnecessary oom message
Date:   Thu, 10 Jun 2021 16:21:34 +0800
Message-ID: <20210610082134.16560-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes scripts/checkpatch.pl warning:
WARNING: Possible unnecessary 'out of memory' message

Remove it can help us save a bit of memory.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/scsi/zorro7xx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 27b9e2baab1a61c..1ecbb603897a27f 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -96,10 +96,8 @@ static int zorro7xx_init_one(struct zorro_dev *z,
 	}
 
 	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (!hostdata) {
-		printk(KERN_ERR "zorro7xx: Failed to allocate host data\n");
+	if (!hostdata)
 		goto out_release;
-	}
 
 	/* Fill in the required pieces of hostdata */
 	if (ioaddr > 0x01000000)
-- 
2.26.0.106.g9fadedd


