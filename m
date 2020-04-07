Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FEBC2BABC
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 09:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0398E20719
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 09:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgDGJan (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 05:30:43 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35592 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726716AbgDGJan (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Apr 2020 05:30:43 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 88D00879BDBBB93E2E5B;
        Tue,  7 Apr 2020 17:30:03 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 7 Apr 2020
 17:29:56 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <megaraidlinux.pdl@broadcom.com>,
        <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 4/4] scsi: megaraid: make two symbols static in megaraid_sas_base.c
Date:   Tue, 7 Apr 2020 17:28:27 +0800
Message-ID: <20200407092827.18074-5-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200407092827.18074-1-yanaijie@huawei.com>
References: <20200407092827.18074-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following sparse warning:

drivers/scsi/megaraid/megaraid_sas_base.c:84:5: warning: symbol
'rdpq_enable' was not declared. Should it be static?
drivers/scsi/megaraid/megaraid_sas_base.c:92:14: warning: symbol
'scmd_timeout' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index babe85d7b537..fb9c3ceed508 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -81,7 +81,7 @@ int smp_affinity_enable = 1;
 module_param(smp_affinity_enable, int, 0444);
 MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disable Default: enable(1)");
 
-int rdpq_enable = 1;
+static int rdpq_enable = 1;
 module_param(rdpq_enable, int, 0444);
 MODULE_PARM_DESC(rdpq_enable, "Allocate reply queue in chunks for large queue depth enable/disable Default: enable(1)");
 
@@ -89,7 +89,7 @@ unsigned int dual_qdepth_disable;
 module_param(dual_qdepth_disable, int, 0444);
 MODULE_PARM_DESC(dual_qdepth_disable, "Disable dual queue depth feature. Default: 0");
 
-unsigned int scmd_timeout = MEGASAS_DEFAULT_CMD_TIMEOUT;
+static unsigned int scmd_timeout = MEGASAS_DEFAULT_CMD_TIMEOUT;
 module_param(scmd_timeout, int, 0444);
 MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s), default 90s. See megasas_reset_timer.");
 
-- 
2.17.2

