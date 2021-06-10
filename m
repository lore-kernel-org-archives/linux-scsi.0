Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3BBC48BE6
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 08:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B5B61432
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 08:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhFJIZB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 04:25:01 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5368 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhFJIYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 04:24:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G0xhM28M4z6txh;
        Thu, 10 Jun 2021 16:18:59 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 16:22:52 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 16:22:51 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] scsi: zorro_esp: remove unnecessary oom message
Date:   Thu, 10 Jun 2021 16:22:46 +0800
Message-ID: <20210610082246.16613-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 drivers/scsi/zorro_esp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index 928c8adf5cb33f4..b03870b4d8dcaaf 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -727,10 +727,8 @@ static int zorro_esp_probe(struct zorro_dev *z,
 	pr_info("%s found at address 0x%lx.\n", zdd->name, board);
 
 	zep = kzalloc(sizeof(*zep), GFP_KERNEL);
-	if (!zep) {
-		pr_err("Can't allocate device private data!\n");
+	if (!zep)
 		return -ENOMEM;
-	}
 
 	/* let's figure out whether we have a Zorro II or Zorro III board */
 	if ((z->rom.er_Type & ERT_TYPEMASK) == ERT_ZORROIII) {
-- 
2.26.0.106.g9fadedd


