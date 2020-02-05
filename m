Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A42C35254
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 14:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A45AB217BA
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 14:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgBEOCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Feb 2020 09:02:43 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:57912 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727468AbgBEOCn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Feb 2020 09:02:43 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6D4B654E713B6850B9A8;
        Wed,  5 Feb 2020 22:02:39 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 5 Feb 2020 22:02:29 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <brking@us.ibm.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH -next] scsi: ipr: remove redundant NULL check
Date:   Wed, 5 Feb 2020 21:56:49 +0800
Message-ID: <20200205135649.163926-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Free function dma_pool_destroy() does NULL check, so the NULL check
before dma_pool_destroy() is unnecessary, just remove it.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/scsi/ipr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index ae45cbe..f027cf3 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9529,8 +9529,7 @@ static void ipr_free_cmd_blks(struct ipr_ioa_cfg *ioa_cfg)
 		}
 	}
 
-	if (ioa_cfg->ipr_cmd_pool)
-		dma_pool_destroy(ioa_cfg->ipr_cmd_pool);
+	dma_pool_destroy(ioa_cfg->ipr_cmd_pool);
 
 	kfree(ioa_cfg->ipr_cmnd_list);
 	kfree(ioa_cfg->ipr_cmnd_list_dma);
-- 
2.7.4

