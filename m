Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE05C43141
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A074B20731
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 05:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfKOFaL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 00:30:11 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36320 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbfKOFaK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 00:30:10 -0500
Received: by mail-pg1-f194.google.com with SMTP id k13so5275044pgh.3;
        Thu, 14 Nov 2019 21:30:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3PwQNFgZYE7Xh0BKs+9unAnIULPVCb51GWIcfMGfUVw=;
        b=EmiYC+YHfhMxvhS0SV9aQx4ypRHpoalPpof0rJRC96svN1/uwoAbtQIyTeh+YqAhVB
         t/5pvpfuv9vTWe1BhMWgONKKLSM9DbK7NSjB9KZqJISQc1gkpUQV8oW1Tfk4F72y7QoL
         h8NhfLOpN2mJZ325tZgOX3isOvTlSwXExo7xQRDZnotTgrX+HuLIcKdHd1a0aPPN9MmY
         K2MIAZN5hs+prmzKYREMIrhLAo8aiKW4kqSSZRYTo5V5mVZiCkdOHsDiWfxoJ1VJlLtx
         LYy7O2eJIc6SJGiXwzS1qeC3L9MUL24l4+q2s4DtPSeYS0JurEw8424qVaDTkdPDksiu
         MHNA==
X-Gm-Message-State: APjAAAU3hnX+1gpsf2/4Ai+WjFwjpL+ZflGfZEyukJ4WP9a9ujd8XWo6
        UyTRsm3hgE0D4KR2mYXJJ34=
X-Google-Smtp-Source: APXvYqxtL5V4TLoYcoAL0wT929R8hvEYKQ+9iZTuu2DtvglDu6/I6cztOO16UjnN8LNp7iCCqBkbvw==
X-Received: by 2002:a17:90b:300c:: with SMTP id hg12mr17526965pjb.75.1573795807930;
        Thu, 14 Nov 2019 21:30:07 -0800 (PST)
Received: from ?IPv6:2601:647:4000:a8:5ff4:69e:fa0f:e8ac? ([2601:647:4000:a8:5ff4:69e:fa0f:e8ac])
        by smtp.gmail.com with ESMTPSA id z7sm10240645pfr.165.2019.11.14.21.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 21:30:06 -0800 (PST)
Subject: Re: [PATCH RFC 3/5] blk-mq: Facilitate a shared tags per tagset
To:     John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "hare@suse.com" <hare@suse.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
 <1573652209-163505-4-git-send-email-john.garry@huawei.com>
 <32880159-86e8-5c48-1532-181fdea0df96@suse.de>
 <2cbf591c-8284-8499-7804-e7078cf274d2@huawei.com>
 <02056612-a958-7b05-3c54-bb2fa69bc493@suse.de>
 <ace95bc5-7b89-9ed3-be89-8139f977984b@huawei.com>
 <42b0bcd9-f147-76eb-dfce-270f77bca818@suse.de>
 <89cd1985-39c7-2965-d25b-2ee2c183d057@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c34c0ce2-40a8-e4fc-3366-1f7b906da5a3@acm.org>
Date:   Thu, 14 Nov 2019 21:30:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <89cd1985-39c7-2965-d25b-2ee2c183d057@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/14/19 1:41 AM, John Garry wrote:
> On 13/11/2019 18:38, Hannes Reinecke wrote:
>>> Hi Hannes,
>>>
>>>> Oh, my. Indeed, that's correct.
>>>
>>> The tags could be kept in sync like this:
>>>
>>> shared_tag = blk_mq_get_tag(shared_tagset);
>>> if (shared_tag != -1)
>>>      sbitmap_set(hctx->tags, shared_tag);
>>>
>>> But that's obviously not ideal.
>>>
>> Actually, I _do_ prefer keeping both in sync.
>> We might want to check if the 'normal' tag is set (typically it would not, but then, who knows ...)
>> The beauty here is that both 'shared' and 'normal' tag are in sync, so if a driver would be wanting to use the tag as index into a command array it can do so without any surprises.
>>
>> Why do you think it's not ideal?
> 
> A few points:
> - Getting a bit from one tagset and then setting it in another tagset is a bit clunky.
> - There may be an atomicity of the getting the shared tag bit and setting the hctx tag bit - I don't think that there is.
> - Consider that sometimes we may want to check if there is space on a hw queue - checking the hctx tags is not really proper any longer, as typically there would always be space on hctx, but not always the shared tags. We did delete blk_mq_can_queue() yesterday, which
> would be an example of that. Need to check if there are others.
> 
> Having said all that, the obvious advantage is performance gain, can still use request.tag and so maybe less intrusive changes.
> 
> I'll have a look at the implementation. The devil is mostly in the detail...

Wouldn't that approach trigger a deadlock if it is attempted to allocate the last
tag from two different hardware queues? How about sharing tag sets across hardware
queues, e.g. like in the (totally untested) patch below?

Thanks,

Bart.

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index b3f2ba483992..3678e95ec947 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -211,8 +211,6 @@ static const struct blk_mq_debugfs_attr blk_mq_debugfs_queue_attrs[] = {
 #define HCTX_STATE_NAME(name) [BLK_MQ_S_##name] = #name
 static const char *const hctx_state_name[] = {
 	HCTX_STATE_NAME(STOPPED),
-	HCTX_STATE_NAME(TAG_ACTIVE),
-	HCTX_STATE_NAME(SCHED_RESTART),
 };
 #undef HCTX_STATE_NAME

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index ca22afd47b3d..6262584dca09 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -64,18 +64,18 @@ void blk_mq_sched_assign_ioc(struct request *rq)
  */
 void blk_mq_sched_mark_restart_hctx(struct blk_mq_hw_ctx *hctx)
 {
-	if (test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
+	if (test_bit(BLK_MQ_T_SCHED_RESTART, &hctx->tags->state))
 		return;

-	set_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
+	set_bit(BLK_MQ_T_SCHED_RESTART, &hctx->tags->state);
 }
 EXPORT_SYMBOL_GPL(blk_mq_sched_mark_restart_hctx);

 void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
 {
-	if (!test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
+	if (!test_bit(BLK_MQ_T_SCHED_RESTART, &hctx->tags->state))
 		return;
-	clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
+	clear_bit(BLK_MQ_T_SCHED_RESTART, &hctx->tags->state);

 	blk_mq_run_hw_queue(hctx, true);
 }
@@ -479,12 +479,15 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
 /* called in queue's release handler, tagset has gone away */
 static void blk_mq_sched_tags_teardown(struct request_queue *q)
 {
+	struct blk_mq_tags *sched_tags = NULL;
 	struct blk_mq_hw_ctx *hctx;
 	int i;

 	queue_for_each_hw_ctx(q, hctx, i) {
-		if (hctx->sched_tags) {
+		if (hctx->sched_tags != sched_tags) {
 			blk_mq_free_rq_map(hctx->sched_tags);
+			if (!sched_tags)
+				sched_tags = hctx->sched_tags;
 			hctx->sched_tags = NULL;
 		}
 	}
@@ -512,6 +515,10 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 				   BLKDEV_MAX_RQ);

 	queue_for_each_hw_ctx(q, hctx, i) {
+		if (i > 0 && q->tag_set->share_tags) {
+			hctx->sched_tags = q->queue_hw_ctx[0]->sched_tags;
+			continue;
+		}
 		ret = blk_mq_sched_alloc_tags(q, hctx, i);
 		if (ret)
 			goto err;
@@ -556,8 +563,11 @@ void blk_mq_sched_free_requests(struct request_queue *q)
 	int i;

 	queue_for_each_hw_ctx(q, hctx, i) {
-		if (hctx->sched_tags)
+		if (hctx->sched_tags) {
 			blk_mq_free_rqs(q->tag_set, hctx->sched_tags, i);
+			if (q->tag_set->share_tags)
+				break;
+		}
 	}
 }

diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 126021fc3a11..15174a646468 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -82,7 +82,7 @@ static inline bool blk_mq_sched_has_work(struct blk_mq_hw_ctx *hctx)

 static inline bool blk_mq_sched_needs_restart(struct blk_mq_hw_ctx *hctx)
 {
-	return test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
+	return test_bit(BLK_MQ_T_SCHED_RESTART, &hctx->tags->state);
 }

 #endif
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 586c9d6e904a..770fe2324230 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -23,8 +23,8 @@
  */
 bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 {
-	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
-	    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
+	if (!test_bit(BLK_MQ_T_ACTIVE, &hctx->tags->state) &&
+	    !test_and_set_bit(BLK_MQ_T_ACTIVE, &hctx->tags->state))
 		atomic_inc(&hctx->tags->active_queues);

 	return true;
@@ -48,7 +48,7 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 {
 	struct blk_mq_tags *tags = hctx->tags;

-	if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
+	if (!test_and_clear_bit(BLK_MQ_T_ACTIVE, &hctx->tags->state))
 		return;

 	atomic_dec(&tags->active_queues);
@@ -67,7 +67,7 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,

 	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_SHARED))
 		return true;
-	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
+	if (!test_bit(BLK_MQ_T_ACTIVE, &hctx->tags->state))
 		return true;

 	/*
@@ -220,7 +220,7 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
 	 * We can hit rq == NULL here, because the tagging functions
 	 * test and set the bit before assigning ->rqs[].
 	 */
-	if (rq && rq->q == hctx->queue)
+	if (rq && rq->q == hctx->queue && rq->mq_hctx == hctx)
 		return iter_data->fn(hctx, rq, iter_data->data, reserved);
 	return true;
 }
@@ -341,8 +341,11 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 	int i;

 	for (i = 0; i < tagset->nr_hw_queues; i++) {
-		if (tagset->tags && tagset->tags[i])
+		if (tagset->tags && tagset->tags[i]) {
 			blk_mq_all_tag_busy_iter(tagset->tags[i], fn, priv);
+			if (tagset->share_tags)
+				break;
+		}
 	}
 }
 EXPORT_SYMBOL(blk_mq_tagset_busy_iter);
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index d0c10d043891..f75fa936b090 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -4,6 +4,11 @@

 #include "blk-mq.h"

+enum {
+	BLK_MQ_T_ACTIVE		= 1,
+	BLK_MQ_T_SCHED_RESTART	= 2,
+};
+
 /*
  * Tag address space map.
  */
@@ -11,6 +16,11 @@ struct blk_mq_tags {
 	unsigned int nr_tags;
 	unsigned int nr_reserved_tags;

+	/**
+	 * @state: BLK_MQ_T_* flags. Defines the state of the hw
+	 * queue (active, scheduled to restart).
+	 */
+	unsigned long	state;
 	atomic_t active_queues;

 	struct sbitmap_queue bitmap_tags;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index fec4b82ff91c..81d4d6a96098 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2404,6 +2404,12 @@ static bool __blk_mq_alloc_rq_map(struct blk_mq_tag_set *set, int hctx_idx)
 {
 	int ret = 0;

+	if (hctx_idx > 0 && set->share_tags) {
+		WARN_ON_ONCE(!set->tags[0]);
+		set->tags[hctx_idx] = set->tags[0];
+		return 0;
+	}
+
 	set->tags[hctx_idx] = blk_mq_alloc_rq_map(set, hctx_idx,
 					set->queue_depth, set->reserved_tags);
 	if (!set->tags[hctx_idx])
@@ -2423,8 +2429,10 @@ static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
 					 unsigned int hctx_idx)
 {
 	if (set->tags && set->tags[hctx_idx]) {
-		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
-		blk_mq_free_rq_map(set->tags[hctx_idx]);
+		if (hctx_idx == 0 || !set->share_tags) {
+			blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
+			blk_mq_free_rq_map(set->tags[hctx_idx]);
+		}
 		set->tags[hctx_idx] = NULL;
 	}
 }
@@ -2568,7 +2576,7 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)

 	mutex_lock(&set->tag_list_lock);
 	list_del_rcu(&q->tag_set_list);
-	if (list_is_singular(&set->tag_list)) {
+	if (list_is_singular(&set->tag_list) && !set->share_tags) {
 		/* just transitioned to unshared */
 		set->flags &= ~BLK_MQ_F_TAG_SHARED;
 		/* update existing queue */
@@ -2586,7 +2594,7 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 	/*
 	 * Check to see if we're transitioning to shared (from 1 to 2 queues).
 	 */
-	if (!list_empty(&set->tag_list) &&
+	if ((!list_empty(&set->tag_list) || set->share_tags) &&
 	    !(set->flags & BLK_MQ_F_TAG_SHARED)) {
 		set->flags |= BLK_MQ_F_TAG_SHARED;
 		/* update existing queue */
@@ -2911,15 +2919,21 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 {
 	int i;

-	for (i = 0; i < set->nr_hw_queues; i++)
-		if (!__blk_mq_alloc_rq_map(set, i))
+	for (i = 0; i < set->nr_hw_queues; i++) {
+		if (i > 0 && set->share_tags) {
+			set->tags[i] = set->tags[0];
+		} else if (!__blk_mq_alloc_rq_map(set, i))
 			goto out_unwind;
+	}

 	return 0;

 out_unwind:
-	while (--i >= 0)
+	while (--i >= 0) {
+		if (i > 0 && set->share_tags)
+			continue;
 		blk_mq_free_rq_map(set->tags[i]);
+	}

 	return -ENOMEM;
 }
@@ -3016,6 +3030,10 @@ static int blk_mq_realloc_tag_set_tags(struct blk_mq_tag_set *set,
  * May fail with EINVAL for various error conditions. May adjust the
  * requested depth down, if it's too large. In that case, the set
  * value will be stored in set->queue_depth.
+ *
+ * @set: tag set for which to allocate tags.
+ * @share_tags: If true, allocate a single set of tags and share it across
+ *	hardware queues.
  */
 int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 {
@@ -3137,6 +3155,12 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (!hctx->tags)
 			continue;
+		if (i > 0 && set->share_tags) {
+			hctx->tags[i] = hctx->tags[0];
+			if (hctx->sched_tags)
+				hctx->sched_tags[i] = hctx->sched_tags[0];
+			continue;
+		}
 		/*
 		 * If we're using an MQ scheduler, just update the scheduler
 		 * queue depth. This is similar to what the old code would do.
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 11cfd6470b1a..dd5517476314 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -224,10 +224,13 @@ enum hctx_type {
  * @numa_node:	   NUMA node the storage adapter has been connected to.
  * @timeout:	   Request processing timeout in jiffies.
  * @flags:	   Zero or more BLK_MQ_F_* flags.
+ * @share_tags:	   Whether or not to share one tag set across hardware queues.
  * @driver_data:   Pointer to data owned by the block driver that created this
  *		   tag set.
- * @tags:	   Tag sets. One tag set per hardware queue. Has @nr_hw_queues
- *		   elements.
+ * @tags:	   Array of tag set pointers. Has @nr_hw_queues elements. If
+ *		   share_tags has not been set, all tag set pointers are
+ *		   different. If share_tags has been set, all tag_set pointers
+ *		   are identical.
  * @tag_list_lock: Serializes tag_list accesses.
  * @tag_list:	   List of the request queues that use this tag set. See also
  *		   request_queue.tag_set_list.
@@ -243,6 +246,7 @@ struct blk_mq_tag_set {
 	int			numa_node;
 	unsigned int		timeout;
 	unsigned int		flags;
+	bool			share_tags;
 	void			*driver_data;

 	struct blk_mq_tags	**tags;
@@ -394,8 +398,6 @@ enum {
 	BLK_MQ_F_ALLOC_POLICY_BITS = 1,

 	BLK_MQ_S_STOPPED	= 0,
-	BLK_MQ_S_TAG_ACTIVE	= 1,
-	BLK_MQ_S_SCHED_RESTART	= 2,

 	BLK_MQ_MAX_DEPTH	= 10240,


