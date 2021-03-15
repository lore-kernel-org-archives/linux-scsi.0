Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAEFC43381
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 03:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8F3B64E64
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 03:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhCODtd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Mar 2021 23:49:33 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:58915 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229776AbhCODt3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 14 Mar 2021 23:49:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0URu6hRL_1615780160;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0URu6hRL_1615780160)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 15 Mar 2021 11:49:27 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     mdr@sgi.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: qla1280: fix warning comparing pointer to 0
Date:   Mon, 15 Mar 2021 11:49:19 +0800
Message-Id: <1615780159-94708-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

./drivers/scsi/qla1280.c:3057:37-38: WARNING comparing pointer to 0.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 46de254..699da47 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -3054,7 +3054,7 @@ static void qla1280_mailbox_timeout(struct timer_list *t)
 
 	/* Check for empty slot in outstanding command list. */
 	for (cnt = 0; cnt < MAX_OUTSTANDING_COMMANDS &&
-		     (ha->outstanding_cmds[cnt] != 0); cnt++) ;
+	     ha->outstanding_cmds[cnt]; cnt++);
 
 	if (cnt >= MAX_OUTSTANDING_COMMANDS) {
 		status = SCSI_MLQUEUE_HOST_BUSY;
-- 
1.8.3.1

