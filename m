Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11937C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 09:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C53E922B2B
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 09:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbhAVJfQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 04:35:16 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:51158 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727345AbhAVJcp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Jan 2021 04:32:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UMVZgRJ_1611307911;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMVZgRJ_1611307911)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Jan 2021 17:32:00 +0800
From:   Yang Li <abaci-bugfix@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, satishkh@cisco.com, sebaddel@cisco.com,
        kartilak@cisco.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] scsi: fnic: remove redundant NULL check
Date:   Fri, 22 Jan 2021 17:31:50 +0800
Message-Id: <1611307910-115635-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix below warnings reported by coccicheck:
./drivers/scsi/fnic/fnic_debugfs.c:91:2-7: WARNING: NULL check before
some freeing functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
---
 drivers/scsi/fnic/fnic_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index 6c04936..6dce1cd 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -87,8 +87,7 @@ void fnic_debugfs_terminate(void)
 	debugfs_remove(fnic_trace_debugfs_root);
 	fnic_trace_debugfs_root = NULL;
 
-	if (fc_trc_flag)
-		vfree(fc_trc_flag);
+	vfree(fc_trc_flag);
 }
 
 /*
-- 
1.8.3.1

