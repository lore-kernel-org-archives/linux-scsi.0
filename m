Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF422C48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 09:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B15B5613E3
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 09:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhFJJsO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 05:48:14 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9065 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJJsN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 05:48:13 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0zYn32zdzYrkG;
        Thu, 10 Jun 2021 17:43:25 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 17:46:16 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 17:46:15 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 1/1] scsi: pm8001: remove unnecessary oom message
Date:   Thu, 10 Jun 2021 17:46:05 +0800
Message-ID: <20210610094605.16672-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210610094605.16672-1-thunder.leizhen@huawei.com>
References: <20210610094605.16672-1-thunder.leizhen@huawei.com>
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

By the way, change the return error code from "-1" to "-ENOMEM".

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6860d5a9ef83b44..6f33d821e5453d1 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -118,10 +118,8 @@ int pm8001_mem_alloc(struct pci_dev *pdev, void **virt_addr,
 		align_offset = (dma_addr_t)align - 1;
 	mem_virt_alloc = dma_alloc_coherent(&pdev->dev, mem_size + align,
 					    &mem_dma_handle, GFP_KERNEL);
-	if (!mem_virt_alloc) {
-		pr_err("pm80xx: memory allocation error\n");
-		return -1;
-	}
+	if (!mem_virt_alloc)
+		return -ENOMEM;
 	*pphys_addr = mem_dma_handle;
 	phys_align = (*pphys_addr + align_offset) & ~align_offset;
 	*virt_addr = (void *)mem_virt_alloc + phys_align - *pphys_addr;
-- 
2.26.0.106.g9fadedd


