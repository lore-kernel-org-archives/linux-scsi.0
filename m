Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E30B338939
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 17:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783359308; cv=none; b=hq0vpm5HbIj7PvCzz4b/9ZZ0zDnwUPvsUzSfSNL1tAoa2Z+FeaXR7h0WTdrQVJkgleqeMnHmN3lj6fTQoSewEYwyJJtUXfu3qTAtJuBHJZ3iG2ScrCh1osaGcFQkq/SQABh5ZDslgdrkHd9aDsjtbdhxjhLgFpUXhJ6+rRAN1wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783359308; c=relaxed/simple;
	bh=76hbu4KwsAZnDsGi2evSegGlHNCl/1Aww0TJyqjoGQU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PmDZO6lPVQQGVqGZIV/hqFzao6NOXrq6cFGqyuxo+hB4Zn54t7QhOqX1t3g1WG2ocy3zGOus9KNXqsGh0Vm0EeQoIyoludlxKfpitU6NkUp7COimMgiiakPc7mllFcWxKo45toFPnGxH8381bnGppgejrR1rpnxNImVQodjQ2No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=UdCST2s8; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="UdCST2s8"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666GjVgA2473025
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jul 2026 10:35:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=YG+ql68/FQcHBQPY55Ko3WXo3Pu3duhLFt+gmW13Q9I=; b=UdCST2s8aOdB
	M6RoD/fUnnSy2l7cPcwFZIOj2yY//6rx1UwHtM2CxUWoo4Cjb86LwJdah/BZe8LF
	PaXqspnP8ZOffGMsEPwExzXooRNcd0N8Wsy8kU9kjqguJ8urYZ3P6Gi6Id2Cnzm2
	ANdZyU83DPEIvD8CcjYClQjOs8bvMQo/a1Uf1SJ3SsnRdumqwZ/Cn+efXgzYf4sy
	Qi197HLoSOGINT1/mQzxa7joS3mWsw/m1tThUIBXFFr0QPcTRmPYuEQo2l62VpME
	RhWUvo6mdsfTzQeiTmTOBvIsThmD8z+Lm3tFcvTw0BBYX6jBLbyZCeL/6T21IVeX
	0K/nbC0mpg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4f7ktefmsv-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2026 10:35:05 -0700 (PDT)
Received: from twshared13926.03.snb2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 6 Jul 2026 17:35:02 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 2203B249DC6D6; Mon,  6 Jul 2026 10:34:55 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>
CC: <linux-scsi@vger.kernel.org>, <axboe@kernel.dk>, <hch@lst.de>,
        <bvanassche@acm.org>, <sumit.saxena@broadcom.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RFC PATCH 2/6] blk-mq: replace shared-tag fairness counter with allocation windows
Date: Mon, 6 Jul 2026 10:34:34 -0700
Message-ID: <20260706173438.3537347-3-kbusch@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260706173438.3537347-1-kbusch@meta.com>
References: <20260706173438.3537347-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=UdJhjqSN c=1 sm=1 tr=0 ts=6a4be749 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=N54-gffFAAAA:8 a=Q-fNiiVtAAAA:8
 a=PQCEMSzTs29JRXNAliYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfXxlpmB8QzFRtN
 GeGFhp7z6BG4WyiJ4QG9qRbMmc6O5nX9jd7gUxyUKOqwImjpGELjoPs9S2AaJPYvgQa7rjxGEsu
 FbyoKPcUZiHI1hGYygVoCteniefznZQkjOK3Mq0TZE8eOvMuq+/B9CVm5Ot+8WNe//qFvQrHXJ0
 tAYIlUOBFV4GMw0/Vv4kYQ1yFkichFBkPSBhbAWwuMJ6Yl9vj4bSzZYIBbcp4WI3J9vamwjmKLo
 O2Wn7XXmL0Ra3ST5ujI7u8XK+/tdTZnlt/AVoxrZSXroZmU4tOek7T8TSTtPytFR3FRnAqxAnPY
 Vmk6BA4Motgwd1P4BNPBv6S/i464xEMTc0Qhbh/as5/P9P+cAcHzK1oMcpsbN9zCUg5MDP0sjXO
 7jNi1lv1y75wMkN/XzdKO1Kfwpq0P32rCvDnGqTw7WKe/DVrRj3FlaIdlw2mn9aJ8To20ALT5tB
 2vz63a/0TtSFFNzrf8w==
X-Proofpoint-GUID: LZXrmUYiTzgGyltkZNIQ5Cvj2ywc-k65
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfX7ybp8EyNnI82
 h7DVoV4XANEPjjmxZDPxr3yyffG83BUuZ90ciSX3nNUPNOOzvKUKH3uxStnh+t8NM+ruc8Gy4kI
 kzkYIjWDGxRMghfvaarRs7RI7i4prHQ=
X-Proofpoint-ORIG-GUID: LZXrmUYiTzgGyltkZNIQ5Cvj2ywc-k65
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

The per-request atomic active counter that hctx_may_queue() checks on
every shared-tag allocation is costly under contention. Instead, confine
each active queue to a slice of the shared bitmap and allocate from
that, so one busy queue cannot starve the others. This removes per-IO
atomic on the hot path. Fairness becomes structural to the sbitmap
allocation range, so the counter and hctx_may_queue are removed.

Link: https://lore.kernel.org/linux-block/20240529213921.3166462-1-bvanas=
sche@acm.org/
Link: https://lore.kernel.org/linux-block/20260609121806.2121755-1-sumit.=
saxena@broadcom.com/
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-core.c       |   2 +-
 block/blk-mq-debugfs.c |   2 +-
 block/blk-mq-tag.c     | 113 +++++++++++++++++++++++++++++++++++++++--
 block/blk-mq.c         |  21 ++------
 block/blk-mq.h         | 102 +------------------------------------
 include/linux/blk-mq.h |  15 ++++--
 include/linux/blkdev.h |   6 ++-
 7 files changed, 135 insertions(+), 126 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 365641266c9e8..7e719b90d8a66 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -464,7 +464,7 @@ struct request_queue *blk_alloc_queue(struct queue_li=
mits *lim, int node_id)
=20
 	q->node =3D node_id;
=20
-	atomic_set(&q->nr_active_requests_shared_tags, 0);
+	q->tag_win_slot =3D -1;
=20
 	timer_setup(&q->timeout, blk_rq_timed_out_timer, 0);
 	INIT_WORK(&q->timeout_work, blk_timeout_work);
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 6754d8f9449c1..4b47a3322ff72 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -480,7 +480,7 @@ static int hctx_active_show(void *data, struct seq_fi=
le *m)
 {
 	struct blk_mq_hw_ctx *hctx =3D data;
=20
-	seq_printf(m, "%d\n", __blk_mq_active_requests(hctx));
+	seq_printf(m, "%u\n", blk_mq_hctx_active(hctx));
 	return 0;
 }
=20
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 35deee5bbc739..0dd497225c74a 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -33,6 +33,18 @@ static void blk_mq_update_wake_batch(struct blk_mq_tag=
s *tags,
 			users);
 }
=20
+/*
+ * Where this queue's fairness allocation-window slot is stored. HCTX_SH=
ARED
+ * tag sets divide one global bitmap among request_queues (slot per queu=
e);
+ * QUEUE_SHARED tag sets divide each per-hw-queue bitmap among the hctxs
+ * sharing it (slot per hctx).
+ */
+static int *blk_mq_tag_win_slot(struct blk_mq_hw_ctx *hctx)
+{
+	return blk_mq_is_shared_tags(hctx->flags) ?
+		&hctx->queue->tag_win_slot : &hctx->tag_win_slot;
+}
+
 /*
  * If a previously inactive queue goes active, bump the active user coun=
t.
  * We need to do this before try to allocate driver tag, then even if fa=
il
@@ -65,6 +77,15 @@ void __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 	users =3D tags->active_queues + 1;
 	WRITE_ONCE(tags->active_queues, users);
 	blk_mq_update_wake_batch(tags, users);
+	if (tags->active_slots) {
+		unsigned int nbits =3D tags->bitmap_tags.sb.depth;
+		unsigned int slot =3D find_first_zero_bit(tags->active_slots, nbits);
+
+		if (slot < nbits) {
+			set_bit(slot, tags->active_slots);
+			WRITE_ONCE(*blk_mq_tag_win_slot(hctx), slot);
+		}
+	}
 	spin_unlock_irqrestore(&tags->lock, flags);
 }
=20
@@ -102,17 +123,82 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 	users =3D tags->active_queues - 1;
 	WRITE_ONCE(tags->active_queues, users);
 	blk_mq_update_wake_batch(tags, users);
+	if (tags->active_slots) {
+		int *slotp =3D blk_mq_tag_win_slot(hctx);
+		int slot =3D READ_ONCE(*slotp);
+
+		if (slot >=3D 0) {
+			clear_bit(slot, tags->active_slots);
+			WRITE_ONCE(*slotp, -1);
+		}
+	}
 	spin_unlock_irq(&tags->lock);
=20
 	blk_mq_tag_wakeup_all(tags, false);
 }
=20
+static inline bool blk_mq_tag_is_windowed(struct blk_mq_alloc_data *data=
)
+{
+	return !data->q->elevator &&
+	       !(data->flags & BLK_MQ_REQ_RESERVED) &&
+	       (data->hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED);
+}
+
+static bool blk_mq_tag_active_window(struct blk_mq_hw_ctx *hctx,
+				     unsigned int depth, unsigned int *min,
+				     unsigned int *max)
+{
+	unsigned int users =3D READ_ONCE(hctx->tags->active_queues);
+	int slot =3D READ_ONCE(*blk_mq_tag_win_slot(hctx));
+	unsigned int p, rem, pos;
+
+	if (users <=3D 1 || slot < 0 || depth <=3D 1)
+		return false;
+
+	p =3D depth / users;
+	if (!p)
+		return false;
+
+	/*
+	 * Slots are allocated from a bitmap and freed out of order, so a slot
+	 * index can exceed the active-user count once lower slots are freed.
+	 * Convert it to a position based on how many active slots precede it.
+	 */
+	pos =3D bitmap_weight(hctx->tags->active_slots, slot);
+	rem =3D depth - p * users;
+	*min =3D pos * p;
+	*max =3D pos * p + p + rem;
+	if (*max > depth)
+		*max =3D depth;
+
+	return true;
+}
+
+int blk_mq_get_tag_window(struct blk_mq_hw_ctx *hctx, struct sbitmap_que=
ue *bt)
+{
+	unsigned int min, max;
+
+	if (blk_mq_tag_active_window(hctx, bt->sb.depth, &min, &max))
+		return sbitmap_queue_get_range(bt, min, max);
+	return __sbitmap_queue_get(bt);
+
+}
+
+unsigned int blk_mq_hctx_active(struct blk_mq_hw_ctx *hctx)
+{
+	struct sbitmap *sb =3D &hctx->tags->bitmap_tags.sb;
+	unsigned int min, max;
+
+	if (!blk_mq_tag_active_window(hctx, sb->depth, &min, &max))
+		return sbitmap_weight(sb);
+	return sbitmap_weight_range(sb, min, max - min);
+}
+
 static int __blk_mq_get_tag(struct blk_mq_alloc_data *data,
 			    struct sbitmap_queue *bt)
 {
-	if (!data->q->elevator && !(data->flags & BLK_MQ_REQ_RESERVED) &&
-			!hctx_may_queue(data->hctx, bt))
-		return BLK_MQ_NO_TAG;
+	if (blk_mq_tag_is_windowed(data))
+		return blk_mq_get_tag_window(data->hctx, bt);
=20
 	if (data->shallow_depth)
 		return sbitmap_queue_get_shallow(bt, data->shallow_depth);
@@ -142,6 +228,7 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data =
*data)
 	struct sbq_wait_state *ws;
 	DEFINE_SBQ_WAIT(wait);
 	unsigned int tag_offset;
+	bool slept =3D false;
 	int tag;
=20
 	if (data->flags & BLK_MQ_REQ_RESERVED) {
@@ -193,8 +280,17 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data=
 *data)
 		if (tag !=3D BLK_MQ_NO_TAG)
 			break;
=20
+		/*
+		 * We were previously woken but still cannot allocate within our
+		 * window: the freed bit belonged to another queue's window.
+		 * Relay the wakeup so a waiter that can use it gets to run.
+		 */
+		if (slept && blk_mq_tag_is_windowed(data))
+			sbitmap_queue_wake_up_relay(bt, ws);
+
 		bt_prev =3D bt;
 		io_schedule();
+		slept =3D true;
=20
 		sbitmap_finish_wait(bt, ws, &wait);
=20
@@ -574,8 +670,14 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int to=
tal_tags,
 	spin_lock_init(&tags->lock);
 	INIT_LIST_HEAD(&tags->page_list);
=20
+	if (depth) {
+		tags->active_slots =3D bitmap_zalloc(depth, GFP_KERNEL);
+		if (!tags->active_slots)
+			goto out_free_tags;
+	}
+
 	if (bt_alloc(&tags->bitmap_tags, depth, round_robin, node))
-		goto out_free_tags;
+		goto out_free_slots;
 	if (bt_alloc(&tags->breserved_tags, reserved_tags, round_robin, node))
 		goto out_free_bitmap_tags;
=20
@@ -583,6 +685,8 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int tot=
al_tags,
=20
 out_free_bitmap_tags:
 	sbitmap_queue_free(&tags->bitmap_tags);
+out_free_slots:
+	bitmap_free(tags->active_slots);
 out_free_tags:
 	kfree(tags);
 	return NULL;
@@ -611,6 +715,7 @@ void blk_mq_free_tags(struct blk_mq_tag_set *set, str=
uct blk_mq_tags *tags)
 {
 	sbitmap_queue_free(&tags->bitmap_tags);
 	sbitmap_queue_free(&tags->breserved_tags);
+	bitmap_free(tags->active_slots);
=20
 	/* if tags pages is not allocated yet, free tags directly */
 	if (list_empty(&tags->page_list)) {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2c850330a32bc..56ab6ac5ec696 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -489,8 +489,6 @@ __blk_mq_alloc_requests_batch(struct blk_mq_alloc_dat=
a *data)
 		}
 	} while (data->nr_tags > nr);
=20
-	if (!(data->rq_flags & RQF_SCHED_TAGS))
-		blk_mq_add_active_requests(data->hctx, nr);
 	/* caller already holds a reference, add for remainder */
 	percpu_ref_get_many(&data->q->q_usage_counter, nr - 1);
 	data->nr_tags -=3D nr;
@@ -587,8 +585,6 @@ static struct request *__blk_mq_alloc_requests(struct=
 blk_mq_alloc_data *data)
 		goto retry;
 	}
=20
-	if (!(data->rq_flags & RQF_SCHED_TAGS))
-		blk_mq_inc_active_requests(data->hctx);
 	rq =3D blk_mq_rq_ctx_init(data, blk_mq_tags_from_data(data), tag);
 	blk_mq_rq_time_init(rq, alloc_time_ns);
 	return rq;
@@ -763,8 +759,6 @@ struct request *blk_mq_alloc_request_hctx(struct requ=
est_queue *q,
 	tag =3D blk_mq_get_tag(&data);
 	if (tag =3D=3D BLK_MQ_NO_TAG)
 		goto out_queue_exit;
-	if (!(data.rq_flags & RQF_SCHED_TAGS))
-		blk_mq_inc_active_requests(data.hctx);
 	rq =3D blk_mq_rq_ctx_init(&data, blk_mq_tags_from_data(&data), tag);
 	blk_mq_rq_time_init(rq, alloc_time_ns);
 	rq->__data_len =3D 0;
@@ -807,10 +801,8 @@ static void __blk_mq_free_request(struct request *rq=
)
 	blk_pm_mark_last_busy(rq);
 	rq->mq_hctx =3D NULL;
=20
-	if (rq->tag !=3D BLK_MQ_NO_TAG) {
-		blk_mq_dec_active_requests(hctx);
+	if (rq->tag !=3D BLK_MQ_NO_TAG)
 		blk_mq_put_tag(hctx->tags, ctx, rq->tag);
-	}
 	if (sched_tag !=3D BLK_MQ_NO_TAG)
 		blk_mq_put_tag(hctx->sched_tags, ctx, sched_tag);
 	blk_mq_sched_restart(hctx);
@@ -1157,8 +1149,6 @@ static inline void blk_mq_flush_tag_batch(struct bl=
k_mq_hw_ctx *hctx,
 {
 	struct request_queue *q =3D hctx->queue;
=20
-	blk_mq_sub_active_requests(hctx, nr_tags);
-
 	blk_mq_put_tags(hctx->tags, tag_array, nr_tags);
 	percpu_ref_put_many(&q->q_usage_counter, nr_tags);
 }
@@ -1844,17 +1834,16 @@ bool __blk_mq_alloc_driver_tag(struct request *rq=
)
 	if (blk_mq_tag_is_reserved(rq->mq_hctx->sched_tags, rq->internal_tag)) =
{
 		bt =3D &rq->mq_hctx->tags->breserved_tags;
 		tag_offset =3D 0;
+		tag =3D __sbitmap_queue_get(bt);
 	} else {
-		if (!hctx_may_queue(rq->mq_hctx, bt))
-			return false;
+		/* Fairness on the shared driver tags via the allocation window. */
+		tag =3D blk_mq_get_tag_window(rq->mq_hctx, bt);
 	}
=20
-	tag =3D __sbitmap_queue_get(bt);
 	if (tag =3D=3D BLK_MQ_NO_TAG)
 		return false;
=20
 	rq->tag =3D tag + tag_offset;
-	blk_mq_inc_active_requests(rq->mq_hctx);
 	return true;
 }
=20
@@ -4028,7 +4017,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct b=
lk_mq_tag_set *set,
 	if (!zalloc_cpumask_var_node(&hctx->cpumask, gfp, node))
 		goto free_hctx;
=20
-	atomic_set(&hctx->nr_active, 0);
+	hctx->tag_win_slot =3D -1;
 	if (node =3D=3D NUMA_NO_NODE)
 		node =3D set->numa_node;
 	hctx->numa_node =3D node;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index aa15d31aaae9b..920bef5e7ce6e 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -205,6 +205,8 @@ static inline struct sbq_wait_state *bt_wait_ptr(stru=
ct sbitmap_queue *bt,
=20
 void __blk_mq_tag_busy(struct blk_mq_hw_ctx *);
 void __blk_mq_tag_idle(struct blk_mq_hw_ctx *);
+unsigned int blk_mq_hctx_active(struct blk_mq_hw_ctx *hctx);
+int blk_mq_get_tag_window(struct blk_mq_hw_ctx *hctx, struct sbitmap_que=
ue *bt);
=20
 static inline void blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 {
@@ -291,70 +293,9 @@ static inline int blk_mq_get_rq_budget_token(struct =
request *rq)
 	return -1;
 }
=20
-static inline void __blk_mq_add_active_requests(struct blk_mq_hw_ctx *hc=
tx,
-						int val)
-{
-	if (blk_mq_is_shared_tags(hctx->flags))
-		atomic_add(val, &hctx->queue->nr_active_requests_shared_tags);
-	else
-		atomic_add(val, &hctx->nr_active);
-}
-
-static inline void __blk_mq_inc_active_requests(struct blk_mq_hw_ctx *hc=
tx)
-{
-	__blk_mq_add_active_requests(hctx, 1);
-}
-
-static inline void __blk_mq_sub_active_requests(struct blk_mq_hw_ctx *hc=
tx,
-		int val)
-{
-	if (blk_mq_is_shared_tags(hctx->flags))
-		atomic_sub(val, &hctx->queue->nr_active_requests_shared_tags);
-	else
-		atomic_sub(val, &hctx->nr_active);
-}
-
-static inline void __blk_mq_dec_active_requests(struct blk_mq_hw_ctx *hc=
tx)
-{
-	__blk_mq_sub_active_requests(hctx, 1);
-}
-
-static inline void blk_mq_add_active_requests(struct blk_mq_hw_ctx *hctx=
,
-					      int val)
-{
-	if (hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
-		__blk_mq_add_active_requests(hctx, val);
-}
-
-static inline void blk_mq_inc_active_requests(struct blk_mq_hw_ctx *hctx=
)
-{
-	if (hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
-		__blk_mq_inc_active_requests(hctx);
-}
-
-static inline void blk_mq_sub_active_requests(struct blk_mq_hw_ctx *hctx=
,
-					      int val)
-{
-	if (hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
-		__blk_mq_sub_active_requests(hctx, val);
-}
-
-static inline void blk_mq_dec_active_requests(struct blk_mq_hw_ctx *hctx=
)
-{
-	if (hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
-		__blk_mq_dec_active_requests(hctx);
-}
-
-static inline int __blk_mq_active_requests(struct blk_mq_hw_ctx *hctx)
-{
-	if (blk_mq_is_shared_tags(hctx->flags))
-		return atomic_read(&hctx->queue->nr_active_requests_shared_tags);
-	return atomic_read(&hctx->nr_active);
-}
 static inline void __blk_mq_put_driver_tag(struct blk_mq_hw_ctx *hctx,
 					   struct request *rq)
 {
-	blk_mq_dec_active_requests(hctx);
 	blk_mq_put_tag(hctx->tags, rq->mq_ctx, rq->tag);
 	rq->tag =3D BLK_MQ_NO_TAG;
 }
@@ -396,45 +337,6 @@ static inline void blk_mq_free_requests(struct list_=
head *list)
 	}
 }
=20
-/*
- * For shared tag users, we track the number of currently active users
- * and attempt to provide a fair share of the tag depth for each of them=
.
- */
-static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
-				  struct sbitmap_queue *bt)
-{
-	unsigned int depth, users;
-
-	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
-		return true;
-
-	/*
-	 * Don't try dividing an ant
-	 */
-	if (bt->sb.depth =3D=3D 1)
-		return true;
-
-	if (blk_mq_is_shared_tags(hctx->flags)) {
-		struct request_queue *q =3D hctx->queue;
-
-		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
-			return true;
-	} else {
-		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
-			return true;
-	}
-
-	users =3D READ_ONCE(hctx->tags->active_queues);
-	if (!users)
-		return true;
-
-	/*
-	 * Allow at least some tags
-	 */
-	depth =3D max((bt->sb.depth + users - 1) / users, 4U);
-	return __blk_mq_active_requests(hctx) < depth;
-}
-
 /* run the code block in @dispatch_ops with rcu/srcu read lock held */
 #define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops)	\
 do {								\
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index af878597afb8c..22cc09d5ef320 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -433,10 +433,12 @@ struct blk_mq_hw_ctx {
 	unsigned int		queue_num;
=20
 	/**
-	 * @nr_active: Number of active requests. Only used when a tag set is
-	 * shared across request queues.
+	 * @tag_win_slot: Assigned fairness allocation-window slot within this
+	 * hctx's tags, or -1 if none. Used for non-HCTX_SHARED shared tag sets
+	 * (the per-hctx analogue of request_queue.tag_win_slot). Protected by
+	 * the tags->lock.
 	 */
-	atomic_t		nr_active;
+	int			tag_win_slot;
=20
 	/** @cpuhp_online: List to store request if CPU is going to die */
 	struct hlist_node	cpuhp_online;
@@ -776,6 +778,13 @@ struct blk_mq_tags {
 	unsigned int nr_reserved_tags;
 	unsigned int active_queues;
=20
+	/*
+	 * Bitmap of assigned per-queue fairness window slots, @nr_tags -
+	 * @nr_reserved_tags bits wide (windowing is moot once active users
+	 * exceed that). Protected by @lock.
+	 */
+	unsigned long *active_slots;
+
 	struct sbitmap_queue bitmap_tags;
 	struct sbitmap_queue breserved_tags;
=20
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9213a5716f95a..86b16bd8b9c17 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -573,7 +573,11 @@ struct request_queue {
 	struct timer_list	timeout;
 	struct work_struct	timeout_work;
=20
-	atomic_t		nr_active_requests_shared_tags;
+	/*
+	 * Assigned allocation-window slot for shared (HCTX_SHARED) tag-set
+	 * fairness, or -1 if none. Protected by the shared tags->lock.
+	 */
+	int			tag_win_slot;
=20
 	struct blk_mq_tags	*sched_shared_tags;
=20
--=20
2.52.0

