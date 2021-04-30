Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF93C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 09:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C96661352
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 09:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhD3J02 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Apr 2021 05:26:28 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:60867 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229760AbhD3J0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Apr 2021 05:26:25 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UXFcJAj_1619774730;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UXFcJAj_1619774730)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 30 Apr 2021 17:25:34 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     willy@infradead.org
Cc:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] advansys: Remove redundant assignment to err and n_q_required
Date:   Fri, 30 Apr 2021 17:25:28 +0800
Message-Id: <1619774728-120808-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Variable err and n_q_required is set to '-ENOMEM' and '1', but they are
either overwritten or unused later on, so these are redundant assignments
that can be removed.

Clean up the following clang-analyzer warning:

drivers/scsi/advansys.c:11235:2: warning: Value stored to 'err' is never
read [clang-analyzer-deadcode.DeadStores].

drivers/scsi/advansys.c:8091:2: warning: Value stored to 'n_q_required'
is never read [clang-analyzer-deadcode.DeadStores].

drivers/scsi/advansys.c:11484:2: warning: Value stored to 'err' is never
read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/advansys.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 800052f..f9969d4 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -8088,7 +8088,6 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 	sta = 0;
 	target_ix = scsiq->q2.target_ix;
 	tid_no = ASC_TIX_TO_TID(target_ix);
-	n_q_required = 1;
 	if (scsiq->cdbptr[0] == REQUEST_SENSE) {
 		if ((asc_dvc->init_sdtr & scsiq->q1.target_id) != 0) {
 			asc_dvc->sdtr_done &= ~scsiq->q1.target_id;
@@ -11232,7 +11231,6 @@ static int advansys_vlb_probe(struct device *dev, unsigned int id)
 	if (AscGetChipVersion(iop_base, ASC_IS_VL) > ASC_CHIP_MAX_VER_VL)
 		goto release_region;
 
-	err = -ENOMEM;
 	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
 	if (!shost)
 		goto release_region;
@@ -11457,7 +11455,6 @@ static int advansys_pci_probe(struct pci_dev *pdev,
 
 	ioport = pci_resource_start(pdev, 0);
 
-	err = -ENOMEM;
 	shost = scsi_host_alloc(&advansys_template, sizeof(*board));
 	if (!shost)
 		goto release_region;
-- 
1.8.3.1

