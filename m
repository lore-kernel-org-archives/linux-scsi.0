Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E746C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 04:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03EF064FEF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 04:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhCJEQs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 23:16:48 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:49197 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229485AbhCJEQU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 23:16:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0URBRf4e_1615349772;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0URBRf4e_1615349772)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Mar 2021 12:16:18 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: mac53c94: fix warning comparing pointer to 0
Date:   Wed, 10 Mar 2021 12:16:11 +0800
Message-Id: <1615349771-81106-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

./drivers/scsi/mac53c94.c:470:29-30: WARNING comparing pointer to 0.
./drivers/scsi/mac53c94.c:349:12-13: WARNING comparing pointer to 0.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/mac53c94.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index 9e98977..ec9840d 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -346,7 +346,7 @@ static void cmd_done(struct fsc_state *state, int result)
 	struct scsi_cmnd *cmd;
 
 	cmd = state->current_req;
-	if (cmd != 0) {
+	if (cmd) {
 		cmd->result = result;
 		(*cmd->scsi_done)(cmd);
 		state->current_req = NULL;
@@ -467,12 +467,13 @@ static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *mat
        	dma_cmd_space = kmalloc_array(host->sg_tablesize + 2,
 					     sizeof(struct dbdma_cmd),
 					     GFP_KERNEL);
-       	if (dma_cmd_space == 0) {
-       		printk(KERN_ERR "mac53c94: couldn't allocate dma "
-       		       "command space for %pOF\n", node);
+	if (!dma_cmd_space) {
+		printk(KERN_ERR "mac53c94: couldn't allocate dma "
+		       "command space for %pOF\n", node);
 		rc = -ENOMEM;
-       		goto out_free;
-       	}
+		goto out_free;
+	}
+
 	state->dma_cmds = (struct dbdma_cmd *)DBDMA_ALIGN(dma_cmd_space);
 	memset(state->dma_cmds, 0, (host->sg_tablesize + 1)
 	       * sizeof(struct dbdma_cmd));
-- 
1.8.3.1

