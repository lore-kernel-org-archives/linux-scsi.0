Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68296C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 06:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347583AbiBHGhM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 01:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347556AbiBHGhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 01:37:12 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FE5C0401EF;
        Mon,  7 Feb 2022 22:37:10 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V3vCHFq_1644302227;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V3vCHFq_1644302227)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Feb 2022 14:37:08 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, bostroesser@gmail.com,
        kanie@linux.alibaba.com
Subject: [PATCH 1/2] scsi: add scsi_done_direct() helper
Date:   Tue,  8 Feb 2022 14:37:06 +0800
Message-Id: <20220208063707.4781-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For scsi commands that are known to be completed in non-interrupt
context, scsi_done_direct() calling blk_mq_complete_request_direct()
can be used to completes commands directly instead deferring it
to softirq, which can give throughput improvement.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 drivers/scsi/scsi_lib.c  | 32 +++++++++++++++++++++++++++-----
 include/scsi/scsi_cmnd.h |  1 +
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0a70aa763a96..c37879f46eaf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1625,26 +1625,48 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
-void scsi_done(struct scsi_cmnd *cmd)
+static bool __scsi_done(struct scsi_cmnd *cmd)
 {
 	switch (cmd->submitter) {
 	case SUBMITTED_BY_BLOCK_LAYER:
-		break;
+		return false;
 	case SUBMITTED_BY_SCSI_ERROR_HANDLER:
-		return scsi_eh_done(cmd);
+		scsi_eh_done(cmd);
+		return true;
 	case SUBMITTED_BY_SCSI_RESET_IOCTL:
-		return;
+		return true;
 	}
 
 	if (unlikely(blk_should_fake_timeout(scsi_cmd_to_rq(cmd)->q)))
-		return;
+		return true;
 	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
+		return true;
+	return false;
+}
+
+void scsi_done(struct scsi_cmnd *cmd)
+{
+	if (__scsi_done(cmd))
 		return;
+
 	trace_scsi_dispatch_cmd_done(cmd);
 	blk_mq_complete_request(scsi_cmd_to_rq(cmd));
 }
 EXPORT_SYMBOL(scsi_done);
 
+/* Complete cmds directly, useful in preemptible instead of an interrupt. */
+void scsi_done_direct(struct scsi_cmnd *cmd)
+{
+	struct request *rq = scsi_cmd_to_rq(cmd);
+
+	if (__scsi_done(cmd))
+		return;
+
+	trace_scsi_dispatch_cmd_done(cmd);
+	blk_mq_complete_request_direct(rq, rq->q->mq_ops->complete);
+}
+EXPORT_SYMBOL(scsi_done_direct);
+
 static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
 {
 	struct scsi_device *sdev = q->queuedata;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 6794d7322cbd..ff1c4b51f7ae 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -168,6 +168,7 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 }
 
 void scsi_done(struct scsi_cmnd *cmd);
+void scsi_done_direct(struct scsi_cmnd *cmd);
 
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
-- 
2.14.4.44.g2045bb6

