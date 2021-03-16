Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854FAC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 07:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DEE764FC3
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 07:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhCPHt3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 03:49:29 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:58046 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231724AbhCPHtF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Mar 2021 03:49:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0US7mNHE_1615880931;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0US7mNHE_1615880931)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Mar 2021 15:49:03 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     anil.gurumurthy@qlogic.com
Cc:     sudarsana.kalluru@qlogic.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: bfa: fix warning comparing pointer to 0
Date:   Tue, 16 Mar 2021 15:48:50 +0800
Message-Id: <1615880930-120780-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

./drivers/scsi/bfa/bfad_bsg.c:3412:29-30: WARNING comparing pointer to
0.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/bfa/bfad_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index fc51542..be8dfbe 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3409,7 +3409,7 @@
 
 	drv_fcxp->port = fcs_port->bfad_port;
 
-	if (drv_fcxp->port->bfad == 0)
+	if (!drv_fcxp->port->bfad)
 		drv_fcxp->port->bfad = bfad;
 
 	/* Fetch the bfa_rport - if nexus needed */
-- 
1.8.3.1

