Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F247C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BCDF218AC
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 08:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgIIITy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 04:19:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52390 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728617AbgIIITp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Sep 2020 04:19:45 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E7DFA6AB45DDACCC0567;
        Wed,  9 Sep 2020 16:19:40 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 16:19:34 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH] scsi: pmcraid: Remove set but not used 'res'
Date:   Wed, 9 Sep 2020 16:26:27 +0800
Message-ID: <20200909082627.101984-2-yebin10@huawei.com>
X-Mailer: git-send-email 2.16.2.dirty
In-Reply-To: <20200909082627.101984-1-yebin10@huawei.com>
References: <20200909082627.101984-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 This addresses the following gcc warning with "make W=1":

 drivers/scsi/pmcraid.c: In function ‘pmcraid_abort_cmd’:
 drivers/scsi/pmcraid.c:2863:33: warning: variable ‘res’ set but not
 used [-Wunused-but-set-variable]
   struct pmcraid_resource_entry *res;
                                    ^
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/pmcraid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index d99568fdf4af..cbe5fab793eb 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -2860,10 +2860,8 @@ static struct pmcraid_cmd *pmcraid_abort_cmd(struct pmcraid_cmd *cmd)
 {
 	struct pmcraid_cmd *cancel_cmd;
 	struct pmcraid_instance *pinstance;
-	struct pmcraid_resource_entry *res;
 
 	pinstance = (struct pmcraid_instance *)cmd->drv_inst;
-	res = cmd->scsi_cmd->device->hostdata;
 
 	cancel_cmd = pmcraid_get_free_cmd(pinstance);
 
-- 
2.16.2.dirty

