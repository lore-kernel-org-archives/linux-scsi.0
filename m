Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C31CC47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 07:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F9E6613C8
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 07:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFJHxa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 03:53:30 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9062 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhFJHxa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 03:53:30 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0x1P5RbgzZcVb;
        Thu, 10 Jun 2021 15:48:41 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:51:32 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:51:31 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Hannes Reinecke <hare@suse.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] scsi: fcoe: remove unnecessary oom message
Date:   Thu, 10 Jun 2021 15:51:24 +0800
Message-ID: <20210610075124.15818-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
 drivers/scsi/fcoe/fcoe_transport.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 4d0e19e7c84b91a..815915734d88d43 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -639,10 +639,8 @@ static int fcoe_add_netdev_mapping(struct net_device *netdev,
 	struct fcoe_netdev_mapping *nm;
 
 	nm = kmalloc(sizeof(*nm), GFP_KERNEL);
-	if (!nm) {
-		printk(KERN_ERR "Unable to allocate netdev_mapping");
+	if (!nm)
 		return -ENOMEM;
-	}
 
 	nm->netdev = netdev;
 	nm->ft = ft;
-- 
2.26.0.106.g9fadedd


