Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B695FC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 10:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F85F6143E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 10:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhEMKvL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 06:51:11 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:51657 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232106AbhEMKu5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 May 2021 06:50:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UYk7jUl_1620902979;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UYk7jUl_1620902979)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 May 2021 18:49:45 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     bootc@bootc.net
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: target: sbp_target: Remove redundant assignment to pg_size
Date:   Thu, 13 May 2021 18:49:37 +0800
Message-Id: <1620902977-57076-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Variable pg_size is set to '0x100 << pg_size', but this value is
never read as it is not used later on, hence it is a redundant
assignment and can be removed.

Clean up the following clang-analyzer warning:

drivers/target/sbp/sbp_target.c:1264:3: warning: Value stored to
'pg_size' is never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/target/sbp/sbp_target.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index ce84f93..4d3ceee 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1261,7 +1261,6 @@ static int sbp_rw_data(struct sbp_target_request *req)
 	pg_size = CMDBLK_ORB_PG_SIZE(be32_to_cpu(req->orb.misc));
 	if (pg_size) {
 		pr_err("sbp_run_transaction: page size ignored\n");
-		pg_size = 0x100 << pg_size;
 	}
 
 	spin_lock_bh(&sess->lock);
-- 
1.8.3.1

