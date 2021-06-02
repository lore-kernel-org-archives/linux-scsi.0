Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8C7C47083
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 10:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96ADE61263
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 10:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhFBKEt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 06:04:49 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:55187 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229967AbhFBKEr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 06:04:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Ub2X3Cs_1622628181;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Ub2X3Cs_1622628181)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Jun 2021 18:03:03 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     aradford@gmail.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] scsi: 3ware: fix return 0 on the error path of probe
Date:   Wed,  2 Jun 2021 18:02:56 +0800
Message-Id: <1622628176-84924-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When tw_reset_sequence() failed and returns 1, the tw_probe() returns 
retval with a value of 0. We set retval to -ENOMEM in this case.

Clean up smatch warning:
drivers/scsi/3w-xxxx.c:2309 tw_probe() warn: missing error code
'retval'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/scsi/3w-xxxx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index a729288..6557663 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2305,8 +2305,10 @@ static int tw_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	TW_DISABLE_INTERRUPTS(tw_dev);
 
 	/* Initialize the card */
-	if (tw_reset_sequence(tw_dev))
+	if (tw_reset_sequence(tw_dev)) {
+		retval = -ENOMEM;
 		goto out_release_mem_region;
+	}
 
 	/* Set host specific parameters */
 	host->max_id = TW_MAX_UNITS;
-- 
1.8.3.1

