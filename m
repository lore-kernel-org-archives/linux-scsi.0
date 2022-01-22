Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30F4C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbiAVLMa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:12:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25181 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234254AbiAVLM0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:12:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iWDZhCx4WfOjbjkCKSgQjjsWcEnBKzFq0pmqP92OyGQ=;
        b=CQ02tPt6eUA/8QlQf33tT/t5jeLgqsIPAkLGRNVxaSfOZR/JnpyTSG/pkwphdYKp4n9ywD
        kqVLBmJUA9vdhXD9VKPCwRTR1VefdQWgRoBatoSGC+u3T3fLy2amGBgMao/b0vGp6FCq/F
        qGBiTIc3Vau7TiC3l5nTRqn6JXCbklk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-0Qe6dymAMrSf663s74Rv1A-1; Sat, 22 Jan 2022 06:12:22 -0500
X-MC-Unique: 0Qe6dymAMrSf663s74Rv1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71A0D1006AA3;
        Sat, 22 Jan 2022 11:12:21 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC90770D3D;
        Sat, 22 Jan 2022 11:12:17 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 08/13] block: export __blk_mq_unfreeze_queue
Date:   Sat, 22 Jan 2022 19:10:49 +0800
Message-Id: <20220122111054.1126146-9-ming.lei@redhat.com>
In-Reply-To: <20220122111054.1126146-1-ming.lei@redhat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_mq_unfreeze_queue() is used by scsi when releasing disk, so not
necessary to unfreeze into percpu mode, then the following
blk_cleanup_queue doesn't need to freeze queue from percpu mode, and
the implied RCU grace period may be avoided.

Meantime move clearing QUEUE_FLAG_INIT_DONE into this API, so that
when one disk is added, ->q_usage_counter can be switched to percpu
mode again.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c         | 10 +++++++++-
 block/blk.h            |  1 -
 block/genhd.c          |  1 -
 include/linux/blk-mq.h |  1 +
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 66cc701921c1..d51b0aa2e4e4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -215,11 +215,18 @@ void blk_mq_freeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue);
 
+/*
+ * When 'force_atomic' is passed as true, this API is supposed to be
+ * called only in case that disk is removed or released.
+ */
 void __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic)
 {
 	mutex_lock(&q->mq_freeze_lock);
-	if (force_atomic)
+	if (force_atomic) {
+		/* When new disk is added, switch to percpu mode */
+		blk_queue_flag_clear(QUEUE_FLAG_INIT_DONE, q);
 		q->q_usage_counter.data->force_atomic = true;
+	}
 	q->mq_freeze_depth--;
 	WARN_ON_ONCE(q->mq_freeze_depth < 0);
 	if (!q->mq_freeze_depth) {
@@ -228,6 +235,7 @@ void __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic)
 	}
 	mutex_unlock(&q->mq_freeze_lock);
 }
+EXPORT_SYMBOL_GPL(__blk_mq_unfreeze_queue);
 
 void blk_mq_unfreeze_queue(struct request_queue *q)
 {
diff --git a/block/blk.h b/block/blk.h
index 7b0f12260ae6..a038e25d8637 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -43,7 +43,6 @@ struct blk_flush_queue *blk_alloc_flush_queue(int node, int cmd_size,
 void blk_free_flush_queue(struct blk_flush_queue *q);
 
 void blk_freeze_queue(struct request_queue *q);
-void __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic);
 void blk_queue_start_drain(struct request_queue *q);
 int __bio_queue_enter(struct request_queue *q, struct bio *bio);
 bool submit_bio_checks(struct bio *bio);
diff --git a/block/genhd.c b/block/genhd.c
index b9b0db168ce1..5bd7bcd6246e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -628,7 +628,6 @@ void del_gendisk(struct gendisk *disk)
 	/*
 	 * Allow using passthrough request again after the queue is torn down.
 	 */
-	blk_queue_flag_clear(QUEUE_FLAG_INIT_DONE, q);
 	__blk_mq_unfreeze_queue(q, true);
 
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d2ad2ed11723..1645159d10f3 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -869,6 +869,7 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 void blk_mq_tagset_wait_completed_request(struct blk_mq_tag_set *tagset);
 void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_unfreeze_queue(struct request_queue *q);
+void __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic);
 void blk_freeze_queue_start(struct request_queue *q);
 void blk_mq_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
-- 
2.31.1

