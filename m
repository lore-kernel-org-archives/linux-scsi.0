Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4ECC8300A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266FC2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgD3NUF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:60560 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgD3NUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BC9B3AF0C;
        Thu, 30 Apr 2020 13:20:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v3 03/41] scsi: Implement scsi_cmd_is_reserved()
Date:   Thu, 30 Apr 2020 15:18:26 +0200
Message-Id: <20200430131904.5847-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add function to check if a SCSI command originates from the reserved
tag pool and update scsi_put_reserved_cmd() to only free commands if
they originate from the reserved tag pool.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-mq.c           | 15 +++++++++++++++
 drivers/scsi/scsi_lib.c  |  7 +++++--
 include/linux/blk-mq.h   |  1 +
 include/scsi/scsi_cmnd.h | 13 +++++++++++++
 4 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8e56884fd2e9..44482aaed11e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -604,6 +604,21 @@ static void __blk_mq_complete_request(struct request *rq)
 	put_cpu();
 }
 
+/**
+ * blk_mq_rq_is_reserved - Check for reserved request
+ *
+ * @rq: Request to check
+ *
+ * Returns true if the request originates from the reserved tag pool.
+ */
+bool blk_mq_rq_is_reserved(struct request *rq)
+{
+	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
+
+	return blk_mq_tag_is_reserved(hctx->tags, rq->tag);
+}
+EXPORT_SYMBOL_GPL(blk_mq_rq_is_reserved);
+
 static void hctx_unlock(struct blk_mq_hw_ctx *hctx, int srcu_idx)
 	__releases(hctx->srcu)
 {
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d0972744ea7f..30f9ca9fce22 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1930,9 +1930,12 @@ EXPORT_SYMBOL_GPL(scsi_get_reserved_cmd);
  */
 void scsi_put_reserved_cmd(struct scsi_cmnd *scmd)
 {
-	struct request *rq = blk_mq_rq_from_pdu(scmd);
+	struct request *rq;
 
-	blk_mq_free_request(rq);
+	if (scmd && scsi_cmd_is_reserved(scmd)) {
+		rq = blk_mq_rq_from_pdu(scmd);
+		blk_mq_free_request(rq);
+	}
 }
 EXPORT_SYMBOL_GPL(scsi_put_reserved_cmd);
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index f389d7c724bd..c186dc25fc1c 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -494,6 +494,7 @@ void blk_mq_requeue_request(struct request *rq, bool kick_requeue_list);
 void blk_mq_kick_requeue_list(struct request_queue *q);
 void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long msecs);
 bool blk_mq_complete_request(struct request *rq);
+bool blk_mq_rq_is_reserved(struct request *rq);
 bool blk_mq_bio_list_merge(struct request_queue *q, struct list_head *list,
 			   struct bio *bio, unsigned int nr_segs);
 bool blk_mq_queue_stopped(struct request_queue *q);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 80ac89e47b47..2cd894fbdcfa 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -159,6 +159,19 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
+/**
+ * scsi_cmd_is_reserved - check for reserved scsi command
+ * @scmd: command to check
+ *
+ * Returns true if @scmd originates from the reserved tag pool.
+ */
+static inline bool scsi_cmd_is_reserved(struct scsi_cmnd *scmd)
+{
+	struct request *rq = blk_mq_rq_from_pdu(scmd);
+
+	return blk_mq_rq_is_reserved(rq);
+}
+
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
-- 
2.16.4

