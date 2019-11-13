Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59992C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 13:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BAFE22467
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 13:40:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfKMNkp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 08:40:45 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:40722 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbfKMNka (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 08:40:30 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 13D7A91CD0A95D82E916;
        Wed, 13 Nov 2019 21:40:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 13 Nov 2019 21:40:15 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <hare@suse.com>, <bvanassche@acm.org>, <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC 3/5] blk-mq: Facilitate a shared tags per tagset
Date:   Wed, 13 Nov 2019 21:36:47 +0800
Message-ID: <1573652209-163505-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
References: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some SCSI HBAs (such as HPSA, megaraid, mpt3sas, hisi_sas_v3 ..) support
multiple reply queues with single hostwide tags.

In addition, these drivers want to use interrupt assignment in
pci_alloc_irq_vectors(PCI_IRQ_AFFINITY). However, as discussed in [0],
CPU hotplug may cause in-flight IO completion to not be serviced when an
interrupt is shutdown.

To solve that problem, Ming's patchset to drain hctx's should ensure no
IOs are missed in-flight [1].

However, to take advantage of that patchset, we need to map the HBA HW
queues to blk mq hctx's; to do that, we need to expose the HBA HW queues.

In making that transition, the per-SCSI command request tags are no
longer unique per Scsi host - they are just unique per hctx. As such, the
HBA LLDD would have to generate this tag internally, which has a certain
performance overhead.

However another problem is that blk mq assumes the host may accept
(Scsi_host.can_queue * #hw queue) commands. In [2], we removed the Scsi
host busy counter, which would stop the LLDD being sent more than
.can_queue commands; however, we should still ensure that the block layer
does not issue more than .can_queue commands to the Scsi host.

To solve this problem, introduce a shared tags per blk_mq_tag_set, which
may be requested when allocating the tagset.

New flag BLK_MQ_F_TAG_HCTX_SHARED should be set when requesting the
tagset.

This is based on work originally from Ming Lei in [3].

[0] https://lore.kernel.org/linux-block/alpine.DEB.2.21.1904051331270.1802@nanos.tec.linutronix.de/
[1] https://lore.kernel.org/linux-block/20191014015043.25029-1-ming.lei@redhat.com/
[2] https://lore.kernel.org/linux-scsi/20191025065855.6309-1-ming.lei@redhat.com/
[3] https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@redhat.com/

Signed-off-by: John Garry <john.garry@huawei.com>
---
 block/blk-core.c       |  1 +
 block/blk-flush.c      |  2 +
 block/blk-mq-debugfs.c |  2 +-
 block/blk-mq-tag.c     | 85 ++++++++++++++++++++++++++++++++++++++++++
 block/blk-mq-tag.h     |  1 +
 block/blk-mq.c         | 61 +++++++++++++++++++++++++-----
 block/blk-mq.h         |  9 +++++
 include/linux/blk-mq.h |  3 ++
 include/linux/blkdev.h |  1 +
 9 files changed, 155 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d5e668ec751b..79eb8983ed45 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -116,6 +116,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->tag = -1;
+	rq->shared_tag = -1;
 	rq->internal_tag = -1;
 	rq->start_time_ns = ktime_get_ns();
 	rq->part = NULL;
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 1eec9cbe5a0a..b9ad9a5978f5 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -228,6 +228,7 @@ static void flush_end_io(struct request *flush_rq, blk_status_t error)
 	if (!q->elevator) {
 		blk_mq_tag_set_rq(hctx, flush_rq->tag, fq->orig_rq);
 		flush_rq->tag = -1;
+		flush_rq->shared_tag = -1;
 	} else {
 		blk_mq_put_driver_tag(flush_rq);
 		flush_rq->internal_tag = -1;
@@ -309,6 +310,7 @@ static void blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq,
 	if (!q->elevator) {
 		fq->orig_rq = first_rq;
 		flush_rq->tag = first_rq->tag;
+		flush_rq->shared_tag = first_rq->shared_tag;
 		blk_mq_tag_set_rq(flush_rq->mq_hctx, first_rq->tag, flush_rq);
 	} else {
 		flush_rq->internal_tag = first_rq->internal_tag;
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 33a40ae1d60f..dc90c42aeb9a 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -339,7 +339,7 @@ int __blk_mq_debugfs_rq_show(struct seq_file *m, struct request *rq)
 	blk_flags_show(m, (__force unsigned int)rq->rq_flags, rqf_name,
 		       ARRAY_SIZE(rqf_name));
 	seq_printf(m, ", .state=%s", blk_mq_rq_state_name(blk_mq_rq_state(rq)));
-	seq_printf(m, ", .tag=%d, .internal_tag=%d", rq->tag,
+	seq_printf(m, ", .tag=%d, .shared_tag=%d, .internal_tag=%d", rq->tag, rq->shared_tag,
 		   rq->internal_tag);
 	if (mq_ops->show_rq)
 		mq_ops->show_rq(m, rq);
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d7aa23c82dbf..0a6c8a6b05dd 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -191,6 +191,91 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data)
 	return tag + tag_offset;
 }

+ /* We could factor this out */
+unsigned int blk_mq_get_shared_tag(struct blk_mq_alloc_data *data)
+{
+	struct blk_mq_tags *tags = blk_mq_shared_tags_from_data(data);
+	struct sbitmap_queue *bt;
+	struct sbq_wait_state *ws;
+	DEFINE_SBQ_WAIT(wait);
+	unsigned int tag_offset;
+	int tag;
+
+	if (data->flags & BLK_MQ_REQ_RESERVED) {
+		if (unlikely(!tags->nr_reserved_tags)) {
+			WARN_ON_ONCE(1);
+			return BLK_MQ_TAG_FAIL;
+		}
+		bt = &tags->breserved_tags;
+		tag_offset = 0;
+	} else {
+		bt = &tags->bitmap_tags;
+		tag_offset = tags->nr_reserved_tags;
+	}
+
+	tag = __blk_mq_get_tag(data, bt);
+	if (tag != -1)
+		goto found_tag;
+
+	if (data->flags & BLK_MQ_REQ_NOWAIT)
+		return BLK_MQ_TAG_FAIL;
+
+	ws = bt_wait_ptr(bt, data->hctx);
+	do {
+		struct sbitmap_queue *bt_prev;
+
+		/*
+		 * We're out of tags on this hardware queue, kick any
+		 * pending IO submits before going to sleep waiting for
+		 * some to complete.
+		 */
+		blk_mq_run_hw_queues(data->q, false);
+
+		/*
+		 * Retry tag allocation after running the hardware queue,
+		 * as running the queue may also have found completions.
+		 */
+		tag = __blk_mq_get_tag(data, bt);
+		if (tag != -1)
+			break;
+
+		sbitmap_prepare_to_wait(bt, ws, &wait, TASK_UNINTERRUPTIBLE);
+
+		tag = __blk_mq_get_tag(data, bt);
+		if (tag != -1)
+			break;
+
+
+		bt_prev = bt;
+		io_schedule();
+
+		sbitmap_finish_wait(bt, ws, &wait);
+
+		data->ctx = blk_mq_get_ctx(data->q);
+		data->hctx = blk_mq_map_queue(data->q, data->cmd_flags,
+						data->ctx);
+		tags = blk_mq_tags_from_data(data);
+		if (data->flags & BLK_MQ_REQ_RESERVED)
+			bt = &tags->breserved_tags;
+		else
+			bt = &tags->bitmap_tags;
+
+		/*
+		 * If destination hw queue is changed, fake wake up on
+		 * previous queue for compensating the wake up miss, so
+		 * other allocations on previous queue won't be starved.
+		 */
+		if (bt != bt_prev)
+			sbitmap_queue_wake_up(bt_prev);
+
+		ws = bt_wait_ptr(bt, data->hctx);
+	} while (1);
+
+	sbitmap_finish_wait(bt, ws, &wait);
+
+found_tag:
+	return tag + tag_offset;
+}
+
 void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx,
 		    unsigned int tag)
 {
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 88b85daa4976..82ff8faa70f7 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -26,6 +26,7 @@ extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int r
 extern void blk_mq_free_tags(struct blk_mq_tags *tags);
 
 extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
+extern unsigned int blk_mq_get_shared_tag(struct blk_mq_alloc_data *data);
 extern void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *ctx, unsigned int tag);
 extern bool blk_mq_has_free_tags(struct blk_mq_tags *tags);
 extern int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6b39cf0efdcd..792eae37dc44 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -292,7 +292,7 @@ static inline bool blk_mq_need_time_stamp(struct request *rq)
 }
 
 static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
-		unsigned int tag, unsigned int op, u64 alloc_time_ns)
+		unsigned int tag, unsigned int shared_tag, unsigned int op, u64 alloc_time_ns)
 {
 	struct blk_mq_tags *tags = blk_mq_tags_from_data(data);
 	struct request *rq = tags->static_rqs[tag];
@@ -300,6 +300,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 
 	if (data->flags & BLK_MQ_REQ_INTERNAL) {
 		rq->tag = -1;
+		rq->shared_tag = -1;
 		rq->internal_tag = tag;
 	} else {
 		if (data->hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) {
@@ -307,6 +308,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 			atomic_inc(&data->hctx->nr_active);
 		}
 		rq->tag = tag;
+		rq->shared_tag = shared_tag;
 		rq->internal_tag = -1;
 		data->hctx->tags->rqs[rq->tag] = rq;
 	}
@@ -359,7 +361,7 @@ static struct request *blk_mq_get_request(struct request_queue *q,
 {
 	struct elevator_queue *e = q->elevator;
 	struct request *rq;
-	unsigned int tag;
+	unsigned int tag, shared_tag = BLK_MQ_TAG_FAIL;
 	bool clear_ctx_on_error = false;
 	u64 alloc_time_ns = 0;
 
@@ -396,15 +398,17 @@ static struct request *blk_mq_get_request(struct request_queue *q,
 		blk_mq_tag_busy(data->hctx);
 	}
 
-	tag = blk_mq_get_tag(data);
-	if (tag == BLK_MQ_TAG_FAIL) {
-		if (clear_ctx_on_error)
-			data->ctx = NULL;
-		blk_queue_exit(q);
-		return NULL;
+	if (data->hctx->shared_tags) {
+		shared_tag = blk_mq_get_shared_tag(data);
+		if (shared_tag == BLK_MQ_TAG_FAIL)
+			goto err_shared_tag;
 	}
 
-	rq = blk_mq_rq_ctx_init(data, tag, data->cmd_flags, alloc_time_ns);
+	tag = blk_mq_get_tag(data);
+	if (tag == BLK_MQ_TAG_FAIL)
+		goto err_tag;
+
+	rq = blk_mq_rq_ctx_init(data, tag, shared_tag, data->cmd_flags, alloc_time_ns);
 	if (!op_is_flush(data->cmd_flags)) {
 		rq->elv.icq = NULL;
 		if (e && e->type->ops.prepare_request) {
@@ -417,6 +421,15 @@ static struct request *blk_mq_get_request(struct request_queue *q,
 	}
 	data->hctx->queued++;
 	return rq;
+
+err_tag:
+	if (shared_tag != BLK_MQ_TAG_FAIL)
+		blk_mq_put_tag(data->hctx->shared_tags, data->ctx, shared_tag);
+err_shared_tag:
+	if (clear_ctx_on_error)
+		data->ctx = NULL;
+	blk_queue_exit(q);
+	return NULL;
 }
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
@@ -498,6 +511,8 @@ static void __blk_mq_free_request(struct request *rq)
 
 	blk_pm_mark_last_busy(rq);
 	rq->mq_hctx = NULL;
+	if (rq->shared_tag != -1)
+		blk_mq_put_tag(hctx->shared_tags, ctx, rq->shared_tag);
 	if (rq->tag != -1)
 		blk_mq_put_tag(hctx->tags, ctx, rq->tag);
 	if (sched_tag != -1)
@@ -1070,6 +1085,14 @@ bool blk_mq_get_driver_tag(struct request *rq)
 		data.flags |= BLK_MQ_REQ_RESERVED;
 
 	shared = blk_mq_tag_busy(data.hctx);
+	if (rq && rq->mq_hctx && rq->mq_hctx->shared_tags) {
+		rq->shared_tag = blk_mq_get_shared_tag(&data);
+		if (rq->shared_tag == BLK_MQ_TAG_FAIL) {
+			blk_mq_put_tag(rq->mq_hctx->tags, rq->mq_ctx, rq->tag);
+			rq->tag = -1;
+			goto done;
+		}
+	}
 	rq->tag = blk_mq_get_tag(&data);
 	if (rq->tag >= 0) {
 		if (shared) {
@@ -1077,6 +1100,9 @@ bool blk_mq_get_driver_tag(struct request *rq)
 			atomic_inc(&data.hctx->nr_active);
 		}
 		data.hctx->tags->rqs[rq->tag] = rq;
+	} else if (rq->shared_tag >= 0) {
+		blk_mq_put_tag(rq->mq_hctx->tags, rq->mq_ctx, rq->tag);
+		rq->shared_tag = -1;
 	}
 
 done:
@@ -2317,6 +2343,7 @@ static int blk_mq_init_hctx(struct request_queue *q,
 	cpuhp_state_add_instance_nocalls(CPUHP_BLK_MQ_DEAD, &hctx->cpuhp_dead);
 
 	hctx->tags = set->tags[hctx_idx];
+	hctx->shared_tags = set->shared_tags;
 
 	if (set->ops->init_hctx &&
 	    set->ops->init_hctx(hctx, set->driver_data, hctx_idx))
@@ -3100,6 +3127,22 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (ret)
 		goto out_free_mq_map;
 
+	if (set->flags & BLK_MQ_F_TAG_HCTX_SHARED) {
+		int node = blk_mq_hw_queue_to_node(&set->map[HCTX_TYPE_DEFAULT], 0);
+		int alloc_policy = BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags);
+
+		if (node == NUMA_NO_NODE)
+			node = set->numa_node;
+
+		set->shared_tags = blk_mq_init_tags(set->queue_depth,
+						    set->reserved_tags,
+						    node, alloc_policy);
+		if (!set->shared_tags) {
+			ret = -ENOMEM;
+			goto out_free_mq_map;
+		}
+	}
+
 	mutex_init(&set->tag_list_lock);
 	INIT_LIST_HEAD(&set->tag_list);
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 78d38b5f2793..c328d335de7d 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -174,6 +174,14 @@ static inline struct blk_mq_tags *blk_mq_tags_from_data(struct blk_mq_alloc_data
 	return data->hctx->tags;
 }
 
+static inline struct blk_mq_tags *blk_mq_shared_tags_from_data(struct blk_mq_alloc_data *data)
+{
+	if (data->flags & BLK_MQ_REQ_INTERNAL)
+		return data->hctx->sched_tags;
+
+	return data->hctx->shared_tags;
+}
+
 static inline bool blk_mq_hctx_stopped(struct blk_mq_hw_ctx *hctx)
 {
 	return test_bit(BLK_MQ_S_STOPPED, &hctx->state);
@@ -210,6 +218,7 @@ static inline void __blk_mq_put_driver_tag(struct blk_mq_hw_ctx *hctx,
 {
 	blk_mq_put_tag(hctx->tags, rq->mq_ctx, rq->tag);
 	rq->tag = -1;
+	rq->shared_tag = -1;
 
 	if (rq->rq_flags & RQF_MQ_INFLIGHT) {
 		rq->rq_flags &= ~RQF_MQ_INFLIGHT;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 147185394a25..d3b402bd01a9 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -46,6 +46,7 @@ struct blk_mq_hw_ctx {
 	atomic_t		wait_index;
 
 	struct blk_mq_tags	*tags;
+	struct blk_mq_tags	*shared_tags;
 	struct blk_mq_tags	*sched_tags;
 
 	unsigned long		queued;
@@ -109,6 +110,7 @@ struct blk_mq_tag_set {
 	unsigned int		flags;		/* BLK_MQ_F_* */
 	void			*driver_data;
 
+	struct blk_mq_tags	*shared_tags;
 	struct blk_mq_tags	**tags;
 
 	struct mutex		tag_list_lock;
@@ -226,6 +228,7 @@ struct blk_mq_ops {
 enum {
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
 	BLK_MQ_F_TAG_QUEUE_SHARED	= 1 << 1,
+	BLK_MQ_F_TAG_HCTX_SHARED	= 1 << 2,
 	BLK_MQ_F_BLOCKING	= 1 << 5,
 	BLK_MQ_F_NO_SCHED	= 1 << 6,
 	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f3ea78b0c91c..a4caa6407b3a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -138,6 +138,7 @@ struct request {
 	req_flags_t rq_flags;
 
 	int tag;
+	int shared_tag;
 	int internal_tag;
 
 	/* the following two fields are internal, NEVER access directly */
-- 
2.17.1

