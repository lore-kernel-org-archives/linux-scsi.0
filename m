Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B30C43465
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 09:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A0C421741
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 09:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgISJby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Sep 2020 05:31:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40258 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbgISJby (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Sep 2020 05:31:54 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B044449D66C75A6A7B2A;
        Sat, 19 Sep 2020 17:31:37 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 17:31:29 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <lee.jones@linaro.org>, <gustavoars@kernel.org>, <axboe@kernel.dk>,
        <colin.king@canonical.com>, <thenzl@redhat.com>,
        <ching2048@areca.com.tw>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jingxiangfeng@huawei.com>
Subject: [PATCH v2] scsi: arcmsr: Remove the superfluous break
Date:   Sat, 19 Sep 2020 17:31:51 +0800
Message-ID: <20200919093151.167830-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the superfluous break, as there is a 'return' before it.

Fixes: 6b3937227479 ("arcmsr: fix command timeout under heavy load")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index ec895d0319f0..74add6d247d5 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2699,10 +2699,8 @@ static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A:
 		return arcmsr_hbaA_handle_isr(acb);
-		break;
 	case ACB_ADAPTER_TYPE_B:
 		return arcmsr_hbaB_handle_isr(acb);
-		break;
 	case ACB_ADAPTER_TYPE_C:
 		return arcmsr_hbaC_handle_isr(acb);
 	case ACB_ADAPTER_TYPE_D:
-- 
2.17.1

