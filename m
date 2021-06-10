Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57E4C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 07:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91C3B613C8
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 07:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhFJHuS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 03:50:18 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3936 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhFJHuS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 03:50:18 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0wxS3HbMz6xCG;
        Thu, 10 Jun 2021 15:45:16 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:48:21 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 15:48:20 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] scsi: bnx2i: remove unnecessary oom message
Date:   Thu, 10 Jun 2021 15:48:15 +0800
Message-ID: <20210610074815.15712-1-thunder.leizhen@huawei.com>
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
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1b5f3e143f0710b..a66ca1ebba15f01 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -529,7 +529,6 @@ static int bnx2i_setup_mp_bdt(struct bnx2i_hba *hba)
 	hba->mp_bd_tbl = dma_alloc_coherent(&hba->pcidev->dev, CNIC_PAGE_SIZE,
 					    &hba->mp_bd_dma, GFP_KERNEL);
 	if (!hba->mp_bd_tbl) {
-		printk(KERN_ERR "unable to allocate Middle Path BDT\n");
 		rc = -1;
 		goto out;
 	}
@@ -538,7 +537,6 @@ static int bnx2i_setup_mp_bdt(struct bnx2i_hba *hba)
 					       CNIC_PAGE_SIZE,
 					       &hba->dummy_buf_dma, GFP_KERNEL);
 	if (!hba->dummy_buffer) {
-		printk(KERN_ERR "unable to alloc Middle Path Dummy Buffer\n");
 		dma_free_coherent(&hba->pcidev->dev, CNIC_PAGE_SIZE,
 				  hba->mp_bd_tbl, hba->mp_bd_dma);
 		hba->mp_bd_tbl = NULL;
-- 
2.26.0.106.g9fadedd


