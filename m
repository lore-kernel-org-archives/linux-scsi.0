Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F9DC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 00:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A71E2245C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 00:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbhARAvg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Jan 2021 19:51:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729935AbhARAvX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Jan 2021 19:51:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610930996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=azHYO0mytFPQLy8q87xgVEjCeCgG0NufQdoQdbXUKnM=;
        b=GSmtGhod9AIhnupSjaod4p1QdfzVTr6lGoLXwp3eGLp4m6DFB4mNnFh1nqzV+wtHQrc/lH
        vJkq197ZBqr1k7zHNnDMnN5KgKPbwFsWmL2uqbAGpttfmH8d6JDttOwTyiDIXFzYLAFiuh
        QBm2zJ+HhjMrEZvZrZ4D8Q2zw3oK5So=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-9MDabeKsNNW86MQOOME7bg-1; Sun, 17 Jan 2021 19:49:52 -0500
X-MC-Unique: 9MDabeKsNNW86MQOOME7bg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B78F180A098;
        Mon, 18 Jan 2021 00:49:51 +0000 (UTC)
Received: from localhost (ovpn-12-73.pek2.redhat.com [10.72.12.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C04D0620D7;
        Mon, 18 Jan 2021 00:49:46 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V6 04/13] sbitmap: move allocation hint into sbitmap
Date:   Mon, 18 Jan 2021 08:49:12 +0800
Message-Id: <20210118004921.202545-5-ming.lei@redhat.com>
In-Reply-To: <20210118004921.202545-1-ming.lei@redhat.com>
References: <20210118004921.202545-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allocation hint should have belonged to sbitmap, also when sbitmap's
depth is high and no need to use mulitple wakeup queues, user can
benefit from percpu allocation hint too.

So move allocation hint into sbitmap, then scsi device queue can benefit
from allocation hint when converting to plain sbitmap in the following
patches.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c          |   2 +-
 block/kyber-iosched.c   |   2 +-
 include/linux/sbitmap.h |  41 +++++++++------
 lib/sbitmap.c           | 112 +++++++++++++++++++++++-----------------
 4 files changed, 94 insertions(+), 63 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c5eead257568..ef1a9f2003a0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2676,7 +2676,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct blk_mq_tag_set *set,
 		goto free_cpumask;
 
 	if (sbitmap_init_node(&hctx->ctx_map, nr_cpu_ids, ilog2(8),
-				gfp, node, false))
+				gfp, node, false, false))
 		goto free_ctxs;
 	hctx->nr_ctx = 0;
 
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index cc8bcfe1d587..3949d68ac4c1 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -480,7 +480,7 @@ static int kyber_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
 	for (i = 0; i < KYBER_NUM_DOMAINS; i++) {
 		if (sbitmap_init_node(&khd->kcq_map[i], hctx->nr_ctx,
 				      ilog2(8), GFP_KERNEL, hctx->numa_node,
-				      false)) {
+				      false, false)) {
 			while (--i >= 0)
 				sbitmap_free(&khd->kcq_map[i]);
 			goto err_kcqs;
diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index 734ee6214cd6..a27a83146d30 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -65,6 +65,14 @@ struct sbitmap {
 	 * @map: Allocated bitmap.
 	 */
 	struct sbitmap_word *map;
+
+	/*
+	 * @alloc_hint: Cache of last successfully allocated or freed bit.
+	 *
+	 * This is per-cpu, which allows multiple users to stick to different
+	 * cachelines until the map is exhausted.
+	 */
+	unsigned int __percpu *alloc_hint;
 };
 
 #define SBQ_WAIT_QUEUES 8
@@ -100,14 +108,6 @@ struct sbitmap_queue {
 	 */
 	struct sbitmap sb;
 
-	/*
-	 * @alloc_hint: Cache of last successfully allocated or freed bit.
-	 *
-	 * This is per-cpu, which allows multiple users to stick to different
-	 * cachelines until the map is exhausted.
-	 */
-	unsigned int __percpu *alloc_hint;
-
 	/**
 	 * @wake_batch: Number of bits which must be freed before we wake up any
 	 * waiters.
@@ -147,11 +147,13 @@ struct sbitmap_queue {
  * @round_robin: If true, be stricter about allocation order; always allocate
  *               starting from the last allocated bit. This is less efficient
  *               than the default behavior (false).
+ * @alloc_hint: If true, apply percpu hint for where to start searching for
+ * 		a free bit.
  *
  * Return: Zero on success or negative errno on failure.
  */
 int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
-		      gfp_t flags, int node, bool round_robin);
+		      gfp_t flags, int node, bool round_robin, bool alloc_hint);
 
 /**
  * sbitmap_free() - Free memory used by a &struct sbitmap.
@@ -159,6 +161,7 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
  */
 static inline void sbitmap_free(struct sbitmap *sb)
 {
+	free_percpu(sb->alloc_hint);
 	kfree(sb->map);
 	sb->map = NULL;
 }
@@ -176,19 +179,17 @@ void sbitmap_resize(struct sbitmap *sb, unsigned int depth);
 /**
  * sbitmap_get() - Try to allocate a free bit from a &struct sbitmap.
  * @sb: Bitmap to allocate from.
- * @alloc_hint: Hint for where to start searching for a free bit.
  *
  * This operation provides acquire barrier semantics if it succeeds.
  *
  * Return: Non-negative allocated bit number if successful, -1 otherwise.
  */
-int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint);
+int sbitmap_get(struct sbitmap *sb);
 
 /**
  * sbitmap_get_shallow() - Try to allocate a free bit from a &struct sbitmap,
  * limiting the depth used from each word.
  * @sb: Bitmap to allocate from.
- * @alloc_hint: Hint for where to start searching for a free bit.
  * @shallow_depth: The maximum number of bits to allocate from a single word.
  *
  * This rather specific operation allows for having multiple users with
@@ -200,8 +201,7 @@ int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint);
  *
  * Return: Non-negative allocated bit number if successful, -1 otherwise.
  */
-int sbitmap_get_shallow(struct sbitmap *sb, unsigned int alloc_hint,
-			unsigned long shallow_depth);
+int sbitmap_get_shallow(struct sbitmap *sb, unsigned long shallow_depth);
 
 /**
  * sbitmap_any_bit_set() - Check for a set bit in a &struct sbitmap.
@@ -315,6 +315,18 @@ static inline void sbitmap_deferred_clear_bit(struct sbitmap *sb, unsigned int b
 	set_bit(SB_NR_TO_BIT(sb, bitnr), addr);
 }
 
+/*
+ * Pair of sbitmap_get, and this one applies both cleared bit and
+ * allocation hint.
+ */
+static inline void sbitmap_put(struct sbitmap *sb, unsigned int bitnr)
+{
+	sbitmap_deferred_clear_bit(sb, bitnr);
+
+	if (likely(sb->alloc_hint && !sb->round_robin && bitnr < sb->depth))
+                *this_cpu_ptr(sb->alloc_hint) = bitnr;
+}
+
 static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitnr)
 {
 	return test_bit(SB_NR_TO_BIT(sb, bitnr), __sbitmap_word(sb, bitnr));
@@ -363,7 +375,6 @@ int sbitmap_queue_init_node(struct sbitmap_queue *sbq, unsigned int depth,
 static inline void sbitmap_queue_free(struct sbitmap_queue *sbq)
 {
 	kfree(sbq->ws);
-	free_percpu(sbq->alloc_hint);
 	sbitmap_free(&sbq->sb);
 }
 
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 2b43a6aefec3..e395435654aa 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -9,52 +9,51 @@
 #include <linux/sbitmap.h>
 #include <linux/seq_file.h>
 
-static int init_alloc_hint(struct sbitmap_queue *sbq, gfp_t flags)
+static int init_alloc_hint(struct sbitmap *sb, gfp_t flags)
 {
-	unsigned depth = sbq->sb.depth;
+	unsigned depth = sb->depth;
 
-	sbq->alloc_hint = alloc_percpu_gfp(unsigned int, flags);
-	if (!sbq->alloc_hint)
+	sb->alloc_hint = alloc_percpu_gfp(unsigned int, flags);
+	if (!sb->alloc_hint)
 		return -ENOMEM;
 
-	if (depth && !sbq->sb.round_robin) {
+	if (depth && !sb->round_robin) {
 		int i;
 
 		for_each_possible_cpu(i)
-			*per_cpu_ptr(sbq->alloc_hint, i) = prandom_u32() % depth;
+			*per_cpu_ptr(sb->alloc_hint, i) = prandom_u32() % depth;
 	}
-
 	return 0;
 }
 
-static inline unsigned update_alloc_hint_before_get(struct sbitmap_queue *sbq,
+static inline unsigned update_alloc_hint_before_get(struct sbitmap *sb,
 						    unsigned int depth)
 {
 	unsigned hint;
 
-	hint = this_cpu_read(*sbq->alloc_hint);
+	hint = this_cpu_read(*sb->alloc_hint);
 	if (unlikely(hint >= depth)) {
 		hint = depth ? prandom_u32() % depth : 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
+		this_cpu_write(*sb->alloc_hint, hint);
 	}
 
 	return hint;
 }
 
-static inline void update_alloc_hint_after_get(struct sbitmap_queue *sbq,
+static inline void update_alloc_hint_after_get(struct sbitmap *sb,
 					       unsigned int depth,
 					       unsigned int hint,
 					       unsigned int nr)
 {
 	if (nr == -1) {
 		/* If the map is full, a hint won't do us much good. */
-		this_cpu_write(*sbq->alloc_hint, 0);
-	} else if (nr == hint || unlikely(sbq->sb.round_robin)) {
+		this_cpu_write(*sb->alloc_hint, 0);
+	} else if (nr == hint || unlikely(sb->round_robin)) {
 		/* Only update the hint if we used it. */
 		hint = nr + 1;
 		if (hint >= depth - 1)
 			hint = 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
+		this_cpu_write(*sb->alloc_hint, hint);
 	}
 }
 
@@ -82,7 +81,8 @@ static inline bool sbitmap_deferred_clear(struct sbitmap_word *map)
 }
 
 int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
-		      gfp_t flags, int node, bool round_robin)
+		      gfp_t flags, int node, bool round_robin,
+		      bool alloc_hint)
 {
 	unsigned int bits_per_word;
 	unsigned int i;
@@ -114,9 +114,18 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
 		return 0;
 	}
 
+	if (alloc_hint) {
+		if (init_alloc_hint(sb, flags))
+			return -ENOMEM;
+	} else {
+		sb->alloc_hint = NULL;
+	}
+
 	sb->map = kcalloc_node(sb->map_nr, sizeof(*sb->map), flags, node);
-	if (!sb->map)
+	if (!sb->map) {
+		free_percpu(sb->alloc_hint);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < sb->map_nr; i++) {
 		sb->map[i].depth = min(depth, bits_per_word);
@@ -196,7 +205,7 @@ static int sbitmap_find_bit_in_index(struct sbitmap *sb, int index,
 	return nr;
 }
 
-int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint)
+static int __sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint)
 {
 	unsigned int i, index;
 	int nr = -1;
@@ -228,10 +237,27 @@ int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint)
 
 	return nr;
 }
+
+int sbitmap_get(struct sbitmap *sb)
+{
+	int nr;
+	unsigned int hint, depth;
+
+	if (WARN_ON_ONCE(unlikely(!sb->alloc_hint)))
+		return -1;
+
+	depth = READ_ONCE(sb->depth);
+	hint = update_alloc_hint_before_get(sb, depth);
+	nr = __sbitmap_get(sb, hint);
+	update_alloc_hint_after_get(sb, depth, hint, nr);
+
+	return nr;
+}
 EXPORT_SYMBOL_GPL(sbitmap_get);
 
-int sbitmap_get_shallow(struct sbitmap *sb, unsigned int alloc_hint,
-			unsigned long shallow_depth)
+static int __sbitmap_get_shallow(struct sbitmap *sb,
+				 unsigned int alloc_hint,
+				 unsigned long shallow_depth)
 {
 	unsigned int i, index;
 	int nr = -1;
@@ -263,6 +289,22 @@ int sbitmap_get_shallow(struct sbitmap *sb, unsigned int alloc_hint,
 
 	return nr;
 }
+
+int sbitmap_get_shallow(struct sbitmap *sb, unsigned long shallow_depth)
+{
+	int nr;
+	unsigned int hint, depth;
+
+	if (WARN_ON_ONCE(unlikely(!sb->alloc_hint)))
+		return -1;
+
+	depth = READ_ONCE(sb->depth);
+	hint = update_alloc_hint_before_get(sb, depth);
+	nr = __sbitmap_get_shallow(sb, hint, shallow_depth);
+	update_alloc_hint_after_get(sb, depth, hint, nr);
+
+	return nr;
+}
 EXPORT_SYMBOL_GPL(sbitmap_get_shallow);
 
 bool sbitmap_any_bit_set(const struct sbitmap *sb)
@@ -400,15 +442,10 @@ int sbitmap_queue_init_node(struct sbitmap_queue *sbq, unsigned int depth,
 	int i;
 
 	ret = sbitmap_init_node(&sbq->sb, depth, shift, flags, node,
-				round_robin);
+				round_robin, true);
 	if (ret)
 		return ret;
 
-	if (init_alloc_hint(sbq, flags) != 0) {
-		sbitmap_free(&sbq->sb);
-		return -ENOMEM;
-	}
-
 	sbq->min_shallow_depth = UINT_MAX;
 	sbq->wake_batch = sbq_calc_wake_batch(sbq, depth);
 	atomic_set(&sbq->wake_index, 0);
@@ -416,7 +453,6 @@ int sbitmap_queue_init_node(struct sbitmap_queue *sbq, unsigned int depth,
 
 	sbq->ws = kzalloc_node(SBQ_WAIT_QUEUES * sizeof(*sbq->ws), flags, node);
 	if (!sbq->ws) {
-		free_percpu(sbq->alloc_hint);
 		sbitmap_free(&sbq->sb);
 		return -ENOMEM;
 	}
@@ -458,32 +494,16 @@ EXPORT_SYMBOL_GPL(sbitmap_queue_resize);
 
 int __sbitmap_queue_get(struct sbitmap_queue *sbq)
 {
-	unsigned int hint, depth;
-	int nr;
-
-	depth = READ_ONCE(sbq->sb.depth);
-	hint = update_alloc_hint_before_get(sbq, depth);
-	nr = sbitmap_get(&sbq->sb, hint);
-	update_alloc_hint_after_get(sbq, depth, hint, nr);
-
-	return nr;
+	return sbitmap_get(&sbq->sb);
 }
 EXPORT_SYMBOL_GPL(__sbitmap_queue_get);
 
 int __sbitmap_queue_get_shallow(struct sbitmap_queue *sbq,
 				unsigned int shallow_depth)
 {
-	unsigned int hint, depth;
-	int nr;
-
 	WARN_ON_ONCE(shallow_depth < sbq->min_shallow_depth);
 
-	depth = READ_ONCE(sbq->sb.depth);
-	hint = update_alloc_hint_before_get(sbq, depth);
-	nr = sbitmap_get_shallow(&sbq->sb, hint, shallow_depth);
-	update_alloc_hint_after_get(sbq, depth, hint, nr);
-
-	return nr;
+	return sbitmap_get_shallow(&sbq->sb, shallow_depth);
 }
 EXPORT_SYMBOL_GPL(__sbitmap_queue_get_shallow);
 
@@ -592,7 +612,7 @@ void sbitmap_queue_clear(struct sbitmap_queue *sbq, unsigned int nr,
 	sbitmap_queue_wake_up(sbq);
 
 	if (likely(!sbq->sb.round_robin && nr < sbq->sb.depth))
-		*per_cpu_ptr(sbq->alloc_hint, cpu) = nr;
+		*per_cpu_ptr(sbq->sb.alloc_hint, cpu) = nr;
 }
 EXPORT_SYMBOL_GPL(sbitmap_queue_clear);
 
@@ -630,7 +650,7 @@ void sbitmap_queue_show(struct sbitmap_queue *sbq, struct seq_file *m)
 		if (!first)
 			seq_puts(m, ", ");
 		first = false;
-		seq_printf(m, "%u", *per_cpu_ptr(sbq->alloc_hint, i));
+		seq_printf(m, "%u", *per_cpu_ptr(sbq->sb.alloc_hint, i));
 	}
 	seq_puts(m, "}\n");
 
-- 
2.28.0

