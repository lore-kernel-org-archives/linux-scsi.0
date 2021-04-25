Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9CEC433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 08:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4490F613BD
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 08:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhDYI7K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 04:59:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229699AbhDYI7J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Apr 2021 04:59:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619341110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RbUbE3u61b64kWZ58krCM3rw6W+Wwws3IIUxJ6lIUWg=;
        b=dol0Y08hczStcZSdJl2CJU/Bgy4BZI/bXaeOw7Qk+payVcPwr7EGj67CGuhuHfMOJa0j0X
        UTsVUeTRmo1cW55lo7GWDdL3gSjdUceDG4ka9goIRf6Xj+UqNFluHMWdRozdQaRs2hToBQ
        AcJmh+PFSiJ5qmhEv/oJJKNXoSaulLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-xnhAsOmFO4ePFiIFQb7OIQ-1; Sun, 25 Apr 2021 04:58:28 -0400
X-MC-Unique: xnhAsOmFO4ePFiIFQb7OIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85D01107ACC7;
        Sun, 25 Apr 2021 08:58:26 +0000 (UTC)
Received: from localhost (ovpn-13-143.pek2.redhat.com [10.72.13.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA43062665;
        Sun, 25 Apr 2021 08:58:22 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 4/8] Revert "blk-mq: Introduce atomic variants of blk_mq_(all_tag|tagset_busy)_iter"
Date:   Sun, 25 Apr 2021 16:57:49 +0800
Message-Id: <20210425085753.2617424-5-ming.lei@redhat.com>
In-Reply-To: <20210425085753.2617424-1-ming.lei@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This reverts commit 5d39098af969f222253036b1b2e7ffc57c734570.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-tag.c        | 38 +++++---------------------------------
 block/blk-mq-tag.h        |  2 +-
 block/blk-mq.c            |  2 +-
 drivers/scsi/hosts.c      | 16 ++++++++--------
 drivers/scsi/ufs/ufshcd.c |  4 ++--
 include/linux/blk-mq.h    |  2 --
 6 files changed, 17 insertions(+), 47 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d8eaa38a1bd1..2a37731e8244 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -322,19 +322,18 @@ static void __blk_mq_all_tag_iter(struct blk_mq_tags *tags,
 }
 
 /**
- * blk_mq_all_tag_iter_atomic - iterate over all requests in a tag map
+ * blk_mq_all_tag_iter - iterate over all requests in a tag map
  * @tags:	Tag map to iterate over.
  * @fn:		Pointer to the function that will be called for each
  *		request. @fn will be called as follows: @fn(rq, @priv,
  *		reserved) where rq is a pointer to a request. 'reserved'
  *		indicates whether or not @rq is a reserved request. Return
- *		true to continue iterating tags, false to stop. Must not
- *		sleep.
+ *		true to continue iterating tags, false to stop.
  * @priv:	Will be passed as second argument to @fn.
  *
- * Does not sleep.
+ * Caller has to pass the tag map from which requests are allocated.
  */
-void blk_mq_all_tag_iter_atomic(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
+void blk_mq_all_tag_iter(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
 		void *priv)
 {
 	__blk_mq_all_tag_iter(tags, fn, priv, BT_TAG_ITER_STATIC_RQS);
@@ -349,8 +348,6 @@ void blk_mq_all_tag_iter_atomic(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
  *		indicates whether or not @rq is a reserved request. Return
  *		true to continue iterating tags, false to stop.
  * @priv:	Will be passed as second argument to @fn.
- *
- * May sleep.
  */
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv)
@@ -365,31 +362,6 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 }
 EXPORT_SYMBOL(blk_mq_tagset_busy_iter);
 
-/**
- * blk_mq_tagset_busy_iter_atomic - iterate over all started requests in a tag set
- * @tagset:	Tag set to iterate over.
- * @fn:		Pointer to the function that will be called for each started
- *		request. @fn will be called as follows: @fn(rq, @priv,
- *		reserved) where rq is a pointer to a request. 'reserved'
- *		indicates whether or not @rq is a reserved request. Return
- *		true to continue iterating tags, false to stop. Must not sleep.
- * @priv:	Will be passed as second argument to @fn.
- *
- * Does not sleep.
- */
-void blk_mq_tagset_busy_iter_atomic(struct blk_mq_tag_set *tagset,
-		busy_tag_iter_fn *fn, void *priv)
-{
-	int i;
-
-	for (i = 0; i < tagset->nr_hw_queues; i++) {
-		if (tagset->tags && tagset->tags[i])
-			__blk_mq_all_tag_iter(tagset->tags[i], fn, priv,
-					      BT_TAG_ITER_STARTED);
-	}
-}
-EXPORT_SYMBOL(blk_mq_tagset_busy_iter_atomic);
-
 static bool blk_mq_tagset_count_completed_rqs(struct request *rq,
 		void *data, bool reserved)
 {
@@ -412,7 +384,7 @@ void blk_mq_tagset_wait_completed_request(struct blk_mq_tag_set *tagset)
 	while (true) {
 		unsigned count = 0;
 
-		blk_mq_tagset_busy_iter_atomic(tagset,
+		blk_mq_tagset_busy_iter(tagset,
 				blk_mq_tagset_count_completed_rqs, &count);
 		if (!count)
 			break;
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 0290c308ece9..7d3e6b333a4a 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -43,7 +43,7 @@ extern void blk_mq_tag_resize_shared_sbitmap(struct blk_mq_tag_set *set,
 extern void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool);
 void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
 		void *priv);
-void blk_mq_all_tag_iter_atomic(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
+void blk_mq_all_tag_iter(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
 		void *priv);
 
 static inline struct sbq_wait_state *bt_wait_ptr(struct sbitmap_queue *bt,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 79c01b1f885c..927189a55575 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2484,7 +2484,7 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
 		.hctx	= hctx,
 	};
 
-	blk_mq_all_tag_iter_atomic(tags, blk_mq_has_request, &data);
+	blk_mq_all_tag_iter(tags, blk_mq_has_request, &data);
 	return data.has_rq;
 }
 
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f8863aa88642..697c09ef259b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -573,8 +573,8 @@ int scsi_host_busy(struct Scsi_Host *shost)
 {
 	int cnt = 0;
 
-	blk_mq_tagset_busy_iter_atomic(&shost->tag_set,
-				       scsi_host_check_in_flight, &cnt);
+	blk_mq_tagset_busy_iter(&shost->tag_set,
+				scsi_host_check_in_flight, &cnt);
 	return cnt;
 }
 EXPORT_SYMBOL(scsi_host_busy);
@@ -672,8 +672,8 @@ static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
  */
 void scsi_host_complete_all_commands(struct Scsi_Host *shost, int status)
 {
-	blk_mq_tagset_busy_iter_atomic(&shost->tag_set, complete_all_cmds_iter,
-				       &status);
+	blk_mq_tagset_busy_iter(&shost->tag_set, complete_all_cmds_iter,
+				&status);
 }
 EXPORT_SYMBOL_GPL(scsi_host_complete_all_commands);
 
@@ -694,11 +694,11 @@ static bool __scsi_host_busy_iter_fn(struct request *req, void *priv,
 /**
  * scsi_host_busy_iter - Iterate over all busy commands
  * @shost:	Pointer to Scsi_Host.
- * @fn:		Function to call on each busy command. Must not sleep.
+ * @fn:		Function to call on each busy command
  * @priv:	Data pointer passed to @fn
  *
  * If locking against concurrent command completions is required
- * it has to be provided by the caller.
+ * ithas to be provided by the caller
  **/
 void scsi_host_busy_iter(struct Scsi_Host *shost,
 			 bool (*fn)(struct scsi_cmnd *, void *, bool),
@@ -709,7 +709,7 @@ void scsi_host_busy_iter(struct Scsi_Host *shost,
 		.priv = priv,
 	};
 
-	blk_mq_tagset_busy_iter_atomic(&shost->tag_set,
-				       __scsi_host_busy_iter_fn, &iter_data);
+	blk_mq_tagset_busy_iter(&shost->tag_set, __scsi_host_busy_iter_fn,
+				&iter_data);
 }
 EXPORT_SYMBOL_GPL(scsi_host_busy_iter);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6d2f8f18e2a3..c86760788c72 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1380,7 +1380,7 @@ static bool ufshcd_any_tag_in_use(struct ufs_hba *hba)
 	struct request_queue *q = hba->cmd_queue;
 	int busy = 0;
 
-	blk_mq_tagset_busy_iter_atomic(q->tag_set, ufshcd_is_busy, &busy);
+	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_is_busy, &busy);
 	return busy;
 }
 
@@ -6269,7 +6269,7 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 		.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL),
 	};
 
-	blk_mq_tagset_busy_iter_atomic(q->tag_set, ufshcd_compl_tm, &ci);
+	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
 	return ci.ncpl ? IRQ_HANDLED : IRQ_NONE;
 }
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index dfa0114a49fd..2c473c9b8990 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -526,8 +526,6 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_run_hw_queues(struct request_queue *q, unsigned long msecs);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
-void blk_mq_tagset_busy_iter_atomic(struct blk_mq_tag_set *tagset,
-		busy_tag_iter_fn *fn, void *priv);
 void blk_mq_tagset_wait_completed_request(struct blk_mq_tag_set *tagset);
 void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_unfreeze_queue(struct request_queue *q);
-- 
2.29.2

