Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A2D3B3BF3
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 17:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783359308; cv=none; b=UvfvBI6fu1vhuAs71fTlgIMc9UHla/gVXOR8/tlNNcliPN2hmK16yWRtQN4ans8VZBqUheX+qUxpOU++tn6e6JPo7ma68xXVmVsMjXGA1I5kUSo0QZXN6K08/kbRXquuK9+C/tYmDQBraK0OQU8t5DGEUIVmDvuo7r3Ki0GyB/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783359308; c=relaxed/simple;
	bh=riZT0pxibl2wifz9miCBLagZkeIGXYTjckYsetgBCk4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CGIRbodF9/FqBDOb7bMEmb9sMrqqdFgQicdn0NE/ltw7Cm2wqkw8OQcUC8wDqppssqbFMvry9l7CXARYXFA1rp2iFlwhkgDiovQlUUYNnD5gBInHS4mbiK+jq4kxl/5CgZq3i0kQ9X9AiY8MPZgSj37M6wO2EXjsdZCojgiTLtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=oW70ATOZ; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="oW70ATOZ"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666GjsHT2473503
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jul 2026 10:35:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=5Bssw4UbM5/gUbCRbiU3eCYZ2yjBBrrQiq9FBNy7/nw=; b=oW70ATOZGSto
	EXwUUjea/Cd1U15vMuOgtNxydgow5kzgU3hKnBOL49YyogrjEOiEZP0XjeArq9ti
	mXqk1ZVmTSLjO2IjrlpE0Eiu0Ywxftqt/HFgoCX2b3LE0VrT38tbg4RmvA3j6YF4
	zX46yE7so816i3xdRV/4mzzWFY4rJtsSrKWU+7zDy8TNHo/uymY+z6IMl3VQJr6J
	jGrY/8oszjTjA/hidehoyPGTz4n9dAmxHtuqYsBAdo22Rb1pF7Y1XekpcdbJjMGo
	5WWKWV5utRHYL0j5GhGYFoyfBlywFiukHW4h6KyiZCnB5EBkhlTqFa+k6WsrOagW
	Kezn+iuxrA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4f7ktefmt0-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2026 10:35:05 -0700 (PDT)
Received: from twshared95846.15.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 6 Jul 2026 17:35:03 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 5BB47249DC706; Mon,  6 Jul 2026 10:34:56 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>
CC: <linux-scsi@vger.kernel.org>, <axboe@kernel.dk>, <hch@lst.de>,
        <bvanassche@acm.org>, <sumit.saxena@broadcom.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [RFC PATCH 5/6] blk-mq: cache shared-tag fairness windows
Date: Mon, 6 Jul 2026 10:34:37 -0700
Message-ID: <20260706173438.3537347-6-kbusch@meta.com>
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
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=_IKc1m3R84xa6E4BFBEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfX3aQBC9IGeLng
 vIFco7KQmg1mZuKZb6hqq2B7SPRuv6eTl0J5SB9KCP8CfFe2179wV8LZQWdZ/Z9eRa7NfwjmME0
 EZ0DEQonHirASyte5sx7vmQ2NlSqzoYZM8h+sPdkx7mhwhsx6X1HiJX3gRryXDAVHC6rybTfgnw
 4vQLDAoC8y0cRwvD4vDHnaptH9uBVq0KkoOhZWJT/9+XN0XUtNUVPhKDlwFr5tlDYUCxRkDga7/
 qWrPT3ESgDv0B6N7da7+s6JUN5uzgAnNBIH3buyNRSqXfnFgXV310GV2zdeycEa3+FyewLcxvPD
 4v0cl4x9j7waHHNZNXReq8jP55HjRrbrS7DqBaMoTavg5pEDCEsQpo4S5nA4kEIePDOJ0c9RySq
 3iOJGIqoLDqaqEGR1j8snoFxksWTFy81i5kKq9cx/YwH+154HQDr1EvmxKUcZtAAR6JtqsH9JwU
 EKYWM5h/wtX5yz+IsXQ==
X-Proofpoint-GUID: 6gO2BiyNRRZjZKHyqgEtyg9yoeavVxiz
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE3NyBTYWx0ZWRfXwxeY459nCXCJ
 hZZBA7cOL0Ik3o3RwksnDm2U1/WmRBql2UWzjEkd6QTvgc70WUVwI1FUDCovxhmsMGczo3Mid2w
 klagneIeLwGZ0RgtWOrsWlCIx3eIzhI=
X-Proofpoint-ORIG-GUID: 6gO2BiyNRRZjZKHyqgEtyg9yoeavVxiz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

The windowed allocation path recomputed each queue's window on every tag
allocation, which includes costly division and bitmap weight operations.
Compute the window only when the active set changes and cache it per
queue/hctx, packed into a single u64 so the allocation fast path reads
it with one READ_ONCE and no arithmetic. A lock-free rebalance
recomputes the windows at each busy/idle transition for all contexts
using that tagset, assigning positions in tag_list order. This also
drops the need for the per-queue/hctx slot bitmap.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-core.c       |   2 +-
 block/blk-mq-tag.c     | 180 ++++++++++++++++++-----------------------
 block/blk-mq.c         |   2 +-
 include/linux/blk-mq.h |  16 +---
 include/linux/blkdev.h |  19 ++++-
 5 files changed, 102 insertions(+), 117 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7e719b90d8a66..85f7ad22f6461 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -464,7 +464,7 @@ struct request_queue *blk_alloc_queue(struct queue_li=
mits *lim, int node_id)
=20
 	q->node =3D node_id;
=20
-	q->tag_win_slot =3D -1;
+	q->tag_win =3D (struct blk_mq_tag_win){ .shared_max =3D U16_MAX };
=20
 	timer_setup(&q->timeout, blk_rq_timed_out_timer, 0);
 	INIT_WORK(&q->timeout_work, blk_timeout_work);
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index aa7dbceb60dcd..d92496378a834 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -34,15 +34,77 @@ static void blk_mq_update_wake_batch(struct blk_mq_ta=
gs *tags,
 }
=20
 /*
- * Where this queue's fairness allocation-window slot is stored. HCTX_SH=
ARED
- * tag sets divide one global bitmap among request_queues (slot per queu=
e);
- * QUEUE_SHARED tag sets divide each per-hw-queue bitmap among the hctxs
- * sharing it (slot per hctx).
+ * Where this queue's cached fairness window lives. HCTX_SHARED tag sets=
 divide
+ * one global bitmap among request_queues (window per queue); QUEUE_SHAR=
ED tag
+ * sets divide each per-hw-queue bitmap among the hctxs sharing it (wind=
ow per
+ * hctx). The window packs into a u64 only because every bound fits in a=
 u16.
  */
-static int *blk_mq_tag_win_slot(struct blk_mq_hw_ctx *hctx)
+static_assert(BLK_MQ_MAX_DEPTH <=3D U16_MAX);
+
+static struct blk_mq_tag_win *blk_mq_tag_win_ptr(struct blk_mq_hw_ctx *h=
ctx)
 {
 	return blk_mq_is_shared_tags(hctx->flags) ?
-		&hctx->queue->tag_win_slot : &hctx->tag_win_slot;
+		&hctx->queue->tag_win : &hctx->tag_win;
+}
+
+static void __blk_mq_rebalance(struct blk_mq_tag_set *set,
+			       struct blk_mq_tags *tags, bool shared,
+			       unsigned int idx)
+{
+	unsigned int depth =3D tags->bitmap_tags.sb.depth;
+	unsigned int users, priv, smin, pos;
+	struct request_queue *q;
+
+	users =3D READ_ONCE(tags->active_queues);
+	priv =3D smin =3D pos =3D 0;
+	if (users > 1 && depth > 1) {
+		unsigned int fair =3D depth / users;
+		unsigned int pct =3D 100 - min(set->shared_pct, 100u);
+
+		priv =3D fair * pct / 100;
+		smin =3D min(users * priv, depth);
+	}
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(q, &set->tag_list, tag_set_list) {
+		struct blk_mq_tag_win *w, new_w;
+		bool active;
+
+		if (shared) {
+			w =3D &q->tag_win;
+			active =3D test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags);
+		} else {
+			struct blk_mq_hw_ctx *hctx =3D queue_hctx(q, idx);
+
+			if (!hctx)
+				continue;
+			w =3D &hctx->tag_win;
+			active =3D test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state);
+		}
+
+		if (!priv || !active) {
+			new_w =3D (struct blk_mq_tag_win) {
+				.shared_max =3D U16_MAX
+			};
+		} else {
+			new_w =3D (struct blk_mq_tag_win) {
+				.priv_min =3D min(pos * priv, depth),
+				.priv_max =3D min(pos * priv + priv, depth),
+				.shared_min =3D smin,
+				.shared_max =3D depth,
+			};
+			pos++;
+		}
+		WRITE_ONCE(w->v, new_w.v);
+	}
+	rcu_read_unlock();
+}
+
+/* Rebalance the pool @hctx draws from after its active set changed. */
+static void blk_mq_rebalance(struct blk_mq_hw_ctx *hctx)
+{
+	__blk_mq_rebalance(hctx->queue->tag_set, hctx->tags,
+			   blk_mq_is_shared_tags(hctx->flags), hctx->queue_num);
 }
=20
 /*
@@ -77,16 +139,9 @@ void __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 	users =3D tags->active_queues + 1;
 	WRITE_ONCE(tags->active_queues, users);
 	blk_mq_update_wake_batch(tags, users);
-	if (tags->active_slots) {
-		unsigned int nbits =3D tags->bitmap_tags.sb.depth;
-		unsigned int slot =3D find_first_zero_bit(tags->active_slots, nbits);
-
-		if (slot < nbits) {
-			set_bit(slot, tags->active_slots);
-			WRITE_ONCE(*blk_mq_tag_win_slot(hctx), slot);
-		}
-	}
 	spin_unlock_irqrestore(&tags->lock, flags);
+
+	blk_mq_rebalance(hctx);
 }
=20
 /*
@@ -123,17 +178,9 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
 	users =3D tags->active_queues - 1;
 	WRITE_ONCE(tags->active_queues, users);
 	blk_mq_update_wake_batch(tags, users);
-	if (tags->active_slots) {
-		int *slotp =3D blk_mq_tag_win_slot(hctx);
-		int slot =3D READ_ONCE(*slotp);
-
-		if (slot >=3D 0) {
-			clear_bit(slot, tags->active_slots);
-			WRITE_ONCE(*slotp, -1);
-		}
-	}
 	spin_unlock_irq(&tags->lock);
=20
+	blk_mq_rebalance(hctx);
 	blk_mq_tag_wakeup_all(tags, false);
 }
=20
@@ -144,81 +191,22 @@ static inline bool blk_mq_tag_is_windowed(struct bl=
k_mq_alloc_data *data)
 	       (data->hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED);
 }
=20
-struct blk_mq_tag_win {
-	unsigned int priv_min;
-	unsigned int priv_max;
-	unsigned int shared_min;
-	unsigned int shared_max;
-};
-
-static bool blk_mq_tag_active_window(struct blk_mq_hw_ctx *hctx,
-				     unsigned int depth,
-				     struct blk_mq_tag_win *w)
-{
-	unsigned int users =3D READ_ONCE(hctx->tags->active_queues);
-	int slot =3D READ_ONCE(*blk_mq_tag_win_slot(hctx));
-	unsigned int fair, priv, pct, pos;
-
-	if (users <=3D 1 || depth <=3D 1)
-		return false;
-
-	fair =3D depth / users;
-	if (!fair)
-		return false;
-
-	pct =3D 100 - min(hctx->queue->tag_set->shared_pct, 100u);
-	priv =3D fair * pct / 100;
-	if (!priv)
-		return false;
-
-	/*
-	 * Slots are allocated from a bitmap and freed out of order, so a slot
-	 * index can exceed the active-user count once lower slots are freed.
-	 * Convert it to a position based on how many active slots precede it.
-	 * If a slot could not be assigned, the window is confined to the
-	 * shared range.
-	 */
-	pos =3D slot >=3D 0 ? bitmap_weight(hctx->tags->active_slots, slot) : u=
sers;
-	if (pos < users) {
-		w->priv_min =3D pos * priv;
-		w->priv_max =3D w->priv_min + priv;
-	} else {
-		w->priv_min =3D w->priv_max =3D 0;
-	}
-
-	w->shared_min =3D min(users * priv, depth);
-	w->shared_max =3D depth;
-
-	if (w->priv_min =3D=3D w->priv_max && w->shared_min =3D=3D w->shared_ma=
x)
-		return false;
-	return true;
-}
-
-static int __blk_mq_get_tag_window(struct sbitmap_queue *bt,
-				   struct blk_mq_tag_win *w)
+int blk_mq_get_tag_window(struct blk_mq_hw_ctx *hctx, struct sbitmap_que=
ue *bt)
 {
-	if (w->priv_max > w->priv_min) {
-		int tag =3D sbitmap_queue_get_range(bt, w->priv_min, w->priv_max);
+	struct blk_mq_tag_win w =3D { .v =3D READ_ONCE(blk_mq_tag_win_ptr(hctx)=
->v) };
+	int tag;
=20
+	if (w.priv_max > w.priv_min) {
+		tag =3D sbitmap_queue_get_range(bt, w.priv_min, w.priv_max);
 		if (tag >=3D 0)
 			return tag;
 	}
=20
-	if (w->shared_max > w->shared_min)
-		return sbitmap_queue_get_range(bt, w->shared_min, w->shared_max);
-
+	if (w.shared_max > w.shared_min)
+		return sbitmap_queue_get_range(bt, w.shared_min, w.shared_max);
 	return BLK_MQ_NO_TAG;
 }
=20
-int blk_mq_get_tag_window(struct blk_mq_hw_ctx *hctx, struct sbitmap_que=
ue *bt)
-{
-	struct blk_mq_tag_win w;
-
-	if (blk_mq_tag_active_window(hctx, bt->sb.depth, &w))
-		return __blk_mq_get_tag_window(bt, &w);
-	return __sbitmap_queue_get(bt);
-}
-
 static int __blk_mq_get_tag(struct blk_mq_alloc_data *data,
 			    struct sbitmap_queue *bt)
 {
@@ -726,14 +714,8 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int to=
tal_tags,
 	spin_lock_init(&tags->lock);
 	INIT_LIST_HEAD(&tags->page_list);
=20
-	if (depth) {
-		tags->active_slots =3D bitmap_zalloc(depth, GFP_KERNEL);
-		if (!tags->active_slots)
-			goto out_free_tags;
-	}
-
 	if (bt_alloc(&tags->bitmap_tags, depth, round_robin, node))
-		goto out_free_slots;
+		goto out_free_tags;
 	if (bt_alloc(&tags->breserved_tags, reserved_tags, round_robin, node))
 		goto out_free_bitmap_tags;
=20
@@ -741,8 +723,6 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int tot=
al_tags,
=20
 out_free_bitmap_tags:
 	sbitmap_queue_free(&tags->bitmap_tags);
-out_free_slots:
-	bitmap_free(tags->active_slots);
 out_free_tags:
 	kfree(tags);
 	return NULL;
@@ -771,7 +751,6 @@ void blk_mq_free_tags(struct blk_mq_tag_set *set, str=
uct blk_mq_tags *tags)
 {
 	sbitmap_queue_free(&tags->bitmap_tags);
 	sbitmap_queue_free(&tags->breserved_tags);
-	bitmap_free(tags->active_slots);
=20
 	/* if tags pages is not allocated yet, free tags directly */
 	if (list_empty(&tags->page_list)) {
@@ -786,6 +765,7 @@ void blk_mq_tag_resize_shared_tags(struct blk_mq_tag_=
set *set, unsigned int size
 {
 	struct blk_mq_tags *tags =3D set->shared_tags;
=20
+	__blk_mq_rebalance(set, tags, true, 0);
 	sbitmap_queue_resize(&tags->bitmap_tags, size - set->reserved_tags);
 }
=20
diff --git a/block/blk-mq.c b/block/blk-mq.c
index cc56baee74fe8..ef8699735aa95 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4017,7 +4017,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct b=
lk_mq_tag_set *set,
 	if (!zalloc_cpumask_var_node(&hctx->cpumask, gfp, node))
 		goto free_hctx;
=20
-	hctx->tag_win_slot =3D -1;
+	hctx->tag_win =3D (struct blk_mq_tag_win){ .shared_max =3D U16_MAX };
 	if (node =3D=3D NUMA_NO_NODE)
 		node =3D set->numa_node;
 	hctx->numa_node =3D node;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 59847ac7d319c..0b1e1697e1736 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -433,12 +433,11 @@ struct blk_mq_hw_ctx {
 	unsigned int		queue_num;
=20
 	/**
-	 * @tag_win_slot: Assigned fairness allocation-window slot within this
-	 * hctx's tags, or -1 if none. Used for non-HCTX_SHARED shared tag sets
-	 * (the per-hctx analogue of request_queue.tag_win_slot). Protected by
-	 * the tags->lock.
+	 * @tag_win: Cached fairness allocation window for non-HCTX_SHARED shar=
ed
+	 * tag sets (each per-hw-queue bitmap divided among its hctxs). Written=
 by
+	 * the rebalance walk, read locklessly on the allocation path.
 	 */
-	int			tag_win_slot;
+	struct blk_mq_tag_win	tag_win;
=20
 	/** @cpuhp_online: List to store request if CPU is going to die */
 	struct hlist_node	cpuhp_online;
@@ -783,13 +782,6 @@ struct blk_mq_tags {
 	unsigned int nr_reserved_tags;
 	unsigned int active_queues;
=20
-	/*
-	 * Bitmap of assigned per-queue fairness window slots, @nr_tags -
-	 * @nr_reserved_tags bits wide (windowing is moot once active users
-	 * exceed that). Protected by @lock.
-	 */
-	unsigned long *active_slots;
-
 	struct sbitmap_queue bitmap_tags;
 	struct sbitmap_queue breserved_tags;
=20
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 86b16bd8b9c17..7b55ce6a3fd2b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -487,6 +487,18 @@ struct blk_independent_access_ranges {
 	struct blk_independent_access_range	ia_range[];
 };
=20
+struct blk_mq_tag_win {
+	union {
+		struct {
+			u16	priv_min;
+			u16	priv_max;
+			u16	shared_min;
+			u16	shared_max;
+		};
+		u64	v;
+	};
+};
+
 struct request_queue {
 	/*
 	 * The queue owner gets to use this for whatever they like.
@@ -574,10 +586,11 @@ struct request_queue {
 	struct work_struct	timeout_work;
=20
 	/*
-	 * Assigned allocation-window slot for shared (HCTX_SHARED) tag-set
-	 * fairness, or -1 if none. Protected by the shared tags->lock.
+	 * Cached fairness allocation window for HCTX_SHARED tag sets (the one
+	 * global bitmap divided among request_queues). Written by the rebalanc=
e
+	 * walk, read locklessly on the allocation path.
 	 */
-	int			tag_win_slot;
+	struct blk_mq_tag_win	tag_win;
=20
 	struct blk_mq_tags	*sched_shared_tags;
=20
--=20
2.52.0

