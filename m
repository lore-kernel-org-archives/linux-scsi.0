Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCD0C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 08:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA9A0613AB
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 08:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhDYI6x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 04:58:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229485AbhDYI6x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Apr 2021 04:58:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619341093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M74/hsQnSAa0X2C+IMiyjVk4wyeWitrFumK7BMvk4gA=;
        b=EOui41o3lv5BJn3wYSYDTR43CIO1GQFcs/1IRUBPdMgPVkTy5js1bVCgndtw2uK5iG1bWu
        QrH2l/spW+13EbjUePDN+o0wqky4Uh5jYHvg/mavBv+Y0ERxa34PULT6ODkZ2Rrl7SX8bi
        PJ8YVPjQgPTTZVlz9S/Gb854d8R0/NE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-V0FQV5NMMvm2rR2RedqVZA-1; Sun, 25 Apr 2021 04:58:11 -0400
X-MC-Unique: V0FQV5NMMvm2rR2RedqVZA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA5718030CF;
        Sun, 25 Apr 2021 08:58:09 +0000 (UTC)
Received: from localhost (ovpn-13-143.pek2.redhat.com [10.72.13.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1691A10016F8;
        Sun, 25 Apr 2021 08:58:02 +0000 (UTC)
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
Subject: [PATCH 1/8] Revert "blk-mq: Fix races between blk_mq_update_nr_hw_queues() and iterating over tags"
Date:   Sun, 25 Apr 2021 16:57:46 +0800
Message-Id: <20210425085753.2617424-2-ming.lei@redhat.com>
In-Reply-To: <20210425085753.2617424-1-ming.lei@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This reverts commit ac81d1ffd022b432d24fe79adf2d31f81a4acdc3.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-tag.c | 39 ---------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index b0e0f074a864..39d5c9190a6b 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -376,31 +376,6 @@ void blk_mq_all_tag_iter_atomic(struct blk_mq_tags *tags, busy_tag_iter_fn *fn,
 	__blk_mq_all_tag_iter(tags, fn, priv, BT_TAG_ITER_STATIC_RQS);
 }
 
-/*
- * Iterate over all request queues in a tag set, find the first queue with a
- * non-zero usage count, increment its usage count and return the pointer to
- * that request queue. This prevents that blk_mq_update_nr_hw_queues() will
- * modify @set->nr_hw_queues while iterating over tags since
- * blk_mq_update_nr_hw_queues() only modifies @set->nr_hw_queues while the
- * usage count of all queues associated with a tag set is zero.
- */
-static struct request_queue *
-blk_mq_get_any_tagset_queue(struct blk_mq_tag_set *set)
-{
-	struct request_queue *q;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(q, &set->tag_list, tag_set_list) {
-		if (percpu_ref_tryget(&q->q_usage_counter)) {
-			rcu_read_unlock();
-			return q;
-		}
-	}
-	rcu_read_unlock();
-
-	return NULL;
-}
-
 /**
  * blk_mq_tagset_busy_iter - iterate over all started requests in a tag set
  * @tagset:	Tag set to iterate over.
@@ -416,22 +391,15 @@ blk_mq_get_any_tagset_queue(struct blk_mq_tag_set *set)
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv)
 {
-	struct request_queue *q;
 	int i;
 
 	might_sleep();
 
-	q = blk_mq_get_any_tagset_queue(tagset);
-	if (!q)
-		return;
-
 	for (i = 0; i < tagset->nr_hw_queues; i++) {
 		if (tagset->tags && tagset->tags[i])
 			__blk_mq_all_tag_iter(tagset->tags[i], fn, priv,
 				BT_TAG_ITER_STARTED | BT_TAG_ITER_MAY_SLEEP);
 	}
-
-	blk_queue_exit(q);
 }
 EXPORT_SYMBOL(blk_mq_tagset_busy_iter);
 
@@ -450,20 +418,13 @@ EXPORT_SYMBOL(blk_mq_tagset_busy_iter);
 void blk_mq_tagset_busy_iter_atomic(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv)
 {
-	struct request_queue *q;
 	int i;
 
-	q = blk_mq_get_any_tagset_queue(tagset);
-	if (!q)
-		return;
-
 	for (i = 0; i < tagset->nr_hw_queues; i++) {
 		if (tagset->tags && tagset->tags[i])
 			__blk_mq_all_tag_iter(tagset->tags[i], fn, priv,
 					      BT_TAG_ITER_STARTED);
 	}
-
-	blk_queue_exit(q);
 }
 EXPORT_SYMBOL(blk_mq_tagset_busy_iter_atomic);
 
-- 
2.29.2

