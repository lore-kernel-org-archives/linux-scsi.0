Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56640C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 03:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B68861053
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 03:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhKCDqj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 23:46:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229506AbhKCDqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 23:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635911042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a/Iu+Awx4uD/ZmNVkIS8P/nfTnq6b7jgA3CD5E++qsk=;
        b=HIlU7/btKsIsscmPHVfQfvStjIIdDpcuV4QBa1gIqfL01yQ9JwI/zWahwaIdSeGpvCc+4r
        gxe8BoiYEL+sQWHKvTr9ZcV23st7uT219oXCtTkQlpQ+8GQzGiO0qGksNFBhghB074q311
        eura2sgVjHQDPQwlxCZEu7f+ZI1JNRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-DEHvRVNJOIunX7HtINWl7w-1; Tue, 02 Nov 2021 23:43:59 -0400
X-MC-Unique: DEHvRVNJOIunX7HtINWl7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C790871805;
        Wed,  3 Nov 2021 03:43:58 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 076445BAFB;
        Wed,  3 Nov 2021 03:43:42 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 1/4] blk-mq: add one API for waiting until quiesce is done
Date:   Wed,  3 Nov 2021 11:43:02 +0800
Message-Id: <20211103034305.3691555-2-ming.lei@redhat.com>
In-Reply-To: <20211103034305.3691555-1-ming.lei@redhat.com>
References: <20211103034305.3691555-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some drivers(NVMe, SCSI) need to call quiesce and unquiesce in pair, but it
is hard to switch to this style, so these drivers need one atomic flag for
helping to balance quiesce and unquiesce.

When quiesce is in-progress, the driver still needs to wait until
the quiesce is done, so add API of blk_mq_wait_quiesce_done() for
these drivers.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c         | 28 ++++++++++++++++++++--------
 include/linux/blk-mq.h |  1 +
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2a2c57c98bbd..9fe0677f03a2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -251,22 +251,18 @@ void blk_mq_quiesce_queue_nowait(struct request_queue *q)
 EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue_nowait);
 
 /**
- * blk_mq_quiesce_queue() - wait until all ongoing dispatches have finished
+ * blk_mq_wait_quiesce_done() - wait until in-progress quiesce is done
  * @q: request queue.
  *
- * Note: this function does not prevent that the struct request end_io()
- * callback function is invoked. Once this function is returned, we make
- * sure no dispatch can happen until the queue is unquiesced via
- * blk_mq_unquiesce_queue().
+ * Note: it is driver's responsibility for making sure that quiesce has
+ * been started.
  */
-void blk_mq_quiesce_queue(struct request_queue *q)
+void blk_mq_wait_quiesce_done(struct request_queue *q)
 {
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int i;
 	bool rcu = false;
 
-	blk_mq_quiesce_queue_nowait(q);
-
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (hctx->flags & BLK_MQ_F_BLOCKING)
 			synchronize_srcu(hctx->srcu);
@@ -276,6 +272,22 @@ void blk_mq_quiesce_queue(struct request_queue *q)
 	if (rcu)
 		synchronize_rcu();
 }
+EXPORT_SYMBOL_GPL(blk_mq_wait_quiesce_done);
+
+/**
+ * blk_mq_quiesce_queue() - wait until all ongoing dispatches have finished
+ * @q: request queue.
+ *
+ * Note: this function does not prevent that the struct request end_io()
+ * callback function is invoked. Once this function is returned, we make
+ * sure no dispatch can happen until the queue is unquiesced via
+ * blk_mq_unquiesce_queue().
+ */
+void blk_mq_quiesce_queue(struct request_queue *q)
+{
+	blk_mq_quiesce_queue_nowait(q);
+	blk_mq_wait_quiesce_done(q);
+}
 EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue);
 
 /*
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 8682663e7368..2949d9ac7484 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -798,6 +798,7 @@ void blk_mq_start_hw_queues(struct request_queue *q);
 void blk_mq_start_stopped_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
 void blk_mq_quiesce_queue(struct request_queue *q);
+void blk_mq_wait_quiesce_done(struct request_queue *q);
 void blk_mq_unquiesce_queue(struct request_queue *q);
 void blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
-- 
2.31.1

