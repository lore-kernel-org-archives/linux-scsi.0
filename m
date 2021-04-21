Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FBDC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 10:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADED961427
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 10:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhDUKe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 06:34:57 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:56014 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234554AbhDUKe4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 06:34:56 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UWI5XGV_1619001242;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWI5XGV_1619001242)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 21 Apr 2021 18:34:22 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2] scsi: a100u2w: Remove useless variable
Date:   Wed, 21 Apr 2021 18:33:59 +0800
Message-Id: <1619001239-129796-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following gcc warning:

drivers/scsi/a100u2w.c:1092:8: warning: variable ‘bios_phys’ set but not
used [-Wunused-but-set-variable].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  - Delete phys_to_virt().

 drivers/scsi/a100u2w.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 66c5143..c99224a 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1089,7 +1089,6 @@ static int inia100_probe_one(struct pci_dev *pdev,
 	int error = -ENODEV;
 	u32 sz;
 	unsigned long biosaddr;
-	char *bios_phys;
 
 	if (pci_enable_device(pdev))
 		goto out;
@@ -1141,7 +1140,6 @@ static int inia100_probe_one(struct pci_dev *pdev,
 
 	biosaddr = host->BIOScfg;
 	biosaddr = (biosaddr << 4);
-	bios_phys = phys_to_virt(biosaddr);
 	if (init_orchid(host)) {	/* Initialize orchid chip */
 		printk("inia100: initial orchid fail!!\n");
 		goto out_free_escb_array;
-- 
1.8.3.1

