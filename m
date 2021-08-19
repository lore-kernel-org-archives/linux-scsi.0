Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD044C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB079610CF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbhHSJhz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:37:55 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3673 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237404AbhHSJhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:37:55 -0400
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gr05F0GlWz6D9C6;
        Thu, 19 Aug 2021 17:36:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 19 Aug 2021 11:37:18 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 19 Aug 2021 10:37:15 +0100
From:   John Garry <john.garry@huawei.com>
To:     <mdr@sgi.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bvanassche@acm.org>, <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/2] scsi: qla1280: Stop using scsi_cmnd.tag
Date:   Thu, 19 Aug 2021 17:32:28 +0800
Message-ID: <1629365549-190391-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629365549-190391-1-git-send-email-john.garry@huawei.com>
References: <1629365549-190391-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_cmd_to_rq(cmd)->tag instead of scsi_cmnd.tag as preference.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index aec92471c5f2..b4f7d8d7a01c 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -3980,7 +3980,7 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 	   qla1280_dump_buffer(1, (char *)sg, (cmd->use_sg*sizeof(struct scatterlist)));
 	   } */
 	printk("  tag=%d, transfersize=0x%x \n",
-	       cmd->tag, cmd->transfersize);
+	       scsi_cmd_to_rq(cmd)->tag, cmd->transfersize);
 	printk("  SP=0x%p\n", CMD_SP(cmd));
 	printk(" underflow size = 0x%x, direction=0x%x\n",
 	       cmd->underflow, cmd->sc_data_direction);
-- 
2.17.1

