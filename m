Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2F1C3F2D2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 910B12469C
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ShMK6WYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgB1X37 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:29:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35272 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725957AbgB1X37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 18:29:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582932597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HkzQ9ZaOjR48dtlJ3KQXI2dZp2DSkC8Scra19N5z5qs=;
        b=ShMK6WYvKtOVpxF5Wq5Bs6uQzJgi1AcuxtLiYMa7E75A7gzVtV21kRWK1vHt6/H1mRhqNI
        GHYvOikKxAFEJUOEk1Z5w/0RA5kHFeI6+E/SFIew+ijEtomCcLX1PJQ70scuM3psbJxqcn
        yX16RO8mE2tR9a1LxHFYGeX3cak2M6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-o63HwD7YPE-nzxmA5ZAzgQ-1; Fri, 28 Feb 2020 18:29:53 -0500
X-MC-Unique: o63HwD7YPE-nzxmA5ZAzgQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A296D10509A0;
        Fri, 28 Feb 2020 23:29:51 +0000 (UTC)
Received: from localhost (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 512198C096;
        Fri, 28 Feb 2020 23:29:49 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH V2 04/10] sbitmap: move allocation hint into sbitmap
Date:   Sat, 29 Feb 2020 07:29:14 +0800
Message-Id: <20200228232920.20960-5-ming.lei@redhat.com>
In-Reply-To: <20200228232920.20960-1-ming.lei@redhat.com>
References: <20200228232920.20960-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allocation hint should have belonged to sbitmap, also when sbitmap's
depth is high and no need to use mulitple wakeup queues, user can
benefit from percpu allocation hint too.

So move allocation hint into sbitmap.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c            |   2 +-
 block/kyber-iosched.c     |   2 +-
 drivers/dma/idxd/device.c |   2 +-
 drivers/dma/idxd/submit.c |   2 +-
 include/linux/sbitmap.h   |  41 +++++++++-----
 lib/sbitmap.c             | 115 +++++++++++++++++++++++---------------
 6 files changed, 99 insertions(+), 65 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 116626b76b08..76a5e919c336 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2397,7 +2397,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct b=
lk_mq_tag_set *set,
 		goto free_cpumask;
=20
 	if (sbitmap_init_node(&hctx->ctx_map, nr_cpu_ids, ilog2(8),
-				gfp, node, false))
+				gfp, node, false, false))
 		goto free_ctxs;
 	hctx->nr_ctx =3D 0;
=20
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index 21587cca1cb3..8ecb96bb4fd5 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -480,7 +480,7 @@ static int kyber_init_hctx(struct blk_mq_hw_ctx *hctx=
, unsigned int hctx_idx)
 	for (i =3D 0; i < KYBER_NUM_DOMAINS; i++) {
 		if (sbitmap_init_node(&khd->kcq_map[i], hctx->nr_ctx,
 				      ilog2(8), GFP_KERNEL, hctx->numa_node,
-				      false)) {
+				      false, false)) {
 			while (--i >=3D 0)
 				sbitmap_free(&khd->kcq_map[i]);
 			goto err_kcqs;
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 5d59c868b2da..ed9f877a32de 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -181,7 +181,7 @@ int idxd_wq_alloc_resources(struct idxd_wq *wq)
 		goto fail_alloc_descs;
=20
 	rc =3D sbitmap_init_node(&wq->sbmap, num_descs, -1, GFP_KERNEL,
-			       dev_to_node(dev), false);
+			       dev_to_node(dev), false, false);
 	if (rc < 0)
 		goto fail_sbitmap_init;
=20
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 842af85c7d43..17f7607ebfa1 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -45,7 +45,7 @@ struct idxd_desc *idxd_alloc_desc(struct idxd_wq *wq, e=
num idxd_op_type optype)
 		percpu_up_read(&wq->submit_lock);
 	}
=20
-	idx =3D sbitmap_get(&wq->sbmap, 0);
+	idx =3D sbitmap_get(&wq->sbmap);
 	if (idx < 0) {
 		atomic_dec(&wq->dq_count);
 		return ERR_PTR(-EAGAIN);
diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index 68097b052ec3..103b41c03311 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -70,6 +70,14 @@ struct sbitmap {
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
=20
 #define SBQ_WAIT_QUEUES 8
@@ -105,14 +113,6 @@ struct sbitmap_queue {
 	 */
 	struct sbitmap sb;
=20
-	/*
-	 * @alloc_hint: Cache of last successfully allocated or freed bit.
-	 *
-	 * This is per-cpu, which allows multiple users to stick to different
-	 * cachelines until the map is exhausted.
-	 */
-	unsigned int __percpu *alloc_hint;
-
 	/**
 	 * @wake_batch: Number of bits which must be freed before we wake up an=
y
 	 * waiters.
@@ -152,11 +152,13 @@ struct sbitmap_queue {
  * @round_robin: If true, be stricter about allocation order; always all=
ocate
  *               starting from the last allocated bit. This is less effi=
cient
  *               than the default behavior (false).
+ * @alloc_hint: If true, apply percpu hint for where to start searching =
for
+ * 		a free bit.
  *
  * Return: Zero on success or negative errno on failure.
  */
 int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
-		      gfp_t flags, int node, bool round_robin);
+		      gfp_t flags, int node, bool round_robin, bool alloc_hint);
=20
 /**
  * sbitmap_free() - Free memory used by a &struct sbitmap.
@@ -164,6 +166,7 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned in=
t depth, int shift,
  */
 static inline void sbitmap_free(struct sbitmap *sb)
 {
+	free_percpu(sb->alloc_hint);
 	kfree(sb->map);
 	sb->map =3D NULL;
 }
@@ -181,19 +184,17 @@ void sbitmap_resize(struct sbitmap *sb, unsigned in=
t depth);
 /**
  * sbitmap_get() - Try to allocate a free bit from a &struct sbitmap.
  * @sb: Bitmap to allocate from.
- * @alloc_hint: Hint for where to start searching for a free bit.
  *
  * This operation provides acquire barrier semantics if it succeeds.
  *
  * Return: Non-negative allocated bit number if successful, -1 otherwise=
.
  */
-int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint);
+int sbitmap_get(struct sbitmap *sb);
=20
 /**
  * sbitmap_get_shallow() - Try to allocate a free bit from a &struct sbi=
tmap,
  * limiting the depth used from each word.
  * @sb: Bitmap to allocate from.
- * @alloc_hint: Hint for where to start searching for a free bit.
  * @shallow_depth: The maximum number of bits to allocate from a single =
word.
  *
  * This rather specific operation allows for having multiple users with
@@ -205,8 +206,7 @@ int sbitmap_get(struct sbitmap *sb, unsigned int allo=
c_hint);
  *
  * Return: Non-negative allocated bit number if successful, -1 otherwise=
.
  */
-int sbitmap_get_shallow(struct sbitmap *sb, unsigned int alloc_hint,
-			unsigned long shallow_depth);
+int sbitmap_get_shallow(struct sbitmap *sb, unsigned long shallow_depth)=
;
=20
 /**
  * sbitmap_any_bit_set() - Check for a set bit in a &struct sbitmap.
@@ -320,6 +320,18 @@ static inline void sbitmap_deferred_clear_bit(struct=
 sbitmap *sb, unsigned int b
 	set_bit(SB_NR_TO_BIT(sb, bitnr), addr);
 }
=20
+/*
+ * Pair of sbitmap_get, and this one applies both cleared bit and
+ * allocation hint.
+ */
+static inline void sbitmap_put(struct sbitmap *sb, unsigned int bitnr)
+{
+	sbitmap_deferred_clear_bit(sb, bitnr);
+
+	if (likely(sb->alloc_hint && !sb->round_robin && bitnr < sb->depth))
+                *this_cpu_ptr(sb->alloc_hint) =3D bitnr;
+}
+
 static inline int sbitmap_test_bit(struct sbitmap *sb, unsigned int bitn=
r)
 {
 	return test_bit(SB_NR_TO_BIT(sb, bitnr), __sbitmap_word(sb, bitnr));
@@ -368,7 +380,6 @@ int sbitmap_queue_init_node(struct sbitmap_queue *sbq=
, unsigned int depth,
 static inline void sbitmap_queue_free(struct sbitmap_queue *sbq)
 {
 	kfree(sbq->ws);
-	free_percpu(sbq->alloc_hint);
 	sbitmap_free(&sbq->sb);
 }
=20
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 683343e02c3b..ca1a446574aa 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -9,52 +9,51 @@
 #include <linux/sbitmap.h>
 #include <linux/seq_file.h>
=20
-static int init_alloc_hint(struct sbitmap_queue *sbq, gfp_t flags)
+static int init_alloc_hint(struct sbitmap *sb, gfp_t flags)
 {
-	unsigned depth =3D sbq->sb.depth;
+	unsigned depth =3D sb->depth;
=20
-	sbq->alloc_hint =3D alloc_percpu_gfp(unsigned int, flags);
-	if (!sbq->alloc_hint)
+	sb->alloc_hint =3D alloc_percpu_gfp(unsigned int, flags);
+	if (!sb->alloc_hint)
 		return -ENOMEM;
=20
-	if (depth && !sbq->sb.round_robin) {
+	if (depth && !sb->round_robin) {
 		int i;
=20
 		for_each_possible_cpu(i)
-			*per_cpu_ptr(sbq->alloc_hint, i) =3D prandom_u32() % depth;
+			*per_cpu_ptr(sb->alloc_hint, i) =3D prandom_u32() % depth;
 	}
-
 	return 0;
 }
=20
-static inline unsigned update_alloc_hint_before_get(struct sbitmap_queue=
 *sbq,
+static inline unsigned update_alloc_hint_before_get(struct sbitmap *sb,
 						    unsigned int depth)
 {
 	unsigned hint;
=20
-	hint =3D this_cpu_read(*sbq->alloc_hint);
+	hint =3D this_cpu_read(*sb->alloc_hint);
 	if (unlikely(hint >=3D depth)) {
 		hint =3D depth ? prandom_u32() % depth : 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
+		this_cpu_write(*sb->alloc_hint, hint);
 	}
=20
 	return hint;
 }
=20
-static inline void update_alloc_hint_after_get(struct sbitmap_queue *sbq=
,
+static inline void update_alloc_hint_after_get(struct sbitmap *sb,
 					       unsigned int depth,
 					       unsigned int hint,
 					       unsigned int nr)
 {
 	if (nr =3D=3D -1) {
 		/* If the map is full, a hint won't do us much good. */
-		this_cpu_write(*sbq->alloc_hint, 0);
-	} else if (nr =3D=3D hint || unlikely(sbq->sb.round_robin)) {
+		this_cpu_write(*sb->alloc_hint, 0);
+	} else if (nr =3D=3D hint || unlikely(sb->round_robin)) {
 		/* Only update the hint if we used it. */
 		hint =3D nr + 1;
 		if (hint >=3D depth - 1)
 			hint =3D 0;
-		this_cpu_write(*sbq->alloc_hint, hint);
+		this_cpu_write(*sb->alloc_hint, hint);
 	}
 }
=20
@@ -91,7 +90,8 @@ static inline bool sbitmap_deferred_clear(struct sbitma=
p *sb, int index)
 }
=20
 int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
-		      gfp_t flags, int node, bool round_robin)
+		      gfp_t flags, int node, bool round_robin,
+		      bool alloc_hint)
 {
 	unsigned int bits_per_word;
 	unsigned int i;
@@ -123,9 +123,18 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned i=
nt depth, int shift,
 		return 0;
 	}
=20
+	if (alloc_hint) {
+		if (init_alloc_hint(sb, flags))
+			return -ENOMEM;
+	} else {
+		sb->alloc_hint =3D NULL;
+	}
+
 	sb->map =3D kcalloc_node(sb->map_nr, sizeof(*sb->map), flags, node);
-	if (!sb->map)
+	if (!sb->map) {
+		free_percpu(sb->alloc_hint);
 		return -ENOMEM;
+	}
=20
 	for (i =3D 0; i < sb->map_nr; i++) {
 		sb->map[i].depth =3D min(depth, bits_per_word);
@@ -204,7 +213,7 @@ static int sbitmap_find_bit_in_index(struct sbitmap *=
sb, int index,
 	return nr;
 }
=20
-int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint)
+static int __sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint)
 {
 	unsigned int i, index;
 	int nr =3D -1;
@@ -236,10 +245,29 @@ int sbitmap_get(struct sbitmap *sb, unsigned int al=
loc_hint)
=20
 	return nr;
 }
+
+int sbitmap_get(struct sbitmap *sb)
+{
+	int nr;
+
+	if (likely(sb->alloc_hint)) {
+		unsigned int hint, depth;
+
+		depth =3D READ_ONCE(sb->depth);
+		hint =3D update_alloc_hint_before_get(sb, depth);
+		nr =3D __sbitmap_get(sb, hint);
+		update_alloc_hint_after_get(sb, depth, hint, nr);
+	} else {
+		nr =3D __sbitmap_get(sb, 0);
+	}
+
+	return nr;
+}
 EXPORT_SYMBOL_GPL(sbitmap_get);
=20
-int sbitmap_get_shallow(struct sbitmap *sb, unsigned int alloc_hint,
-			unsigned long shallow_depth)
+static int __sbitmap_get_shallow(struct sbitmap *sb,
+				 unsigned int alloc_hint,
+				 unsigned long shallow_depth)
 {
 	unsigned int i, index;
 	int nr =3D -1;
@@ -271,6 +299,23 @@ int sbitmap_get_shallow(struct sbitmap *sb, unsigned=
 int alloc_hint,
=20
 	return nr;
 }
+
+int sbitmap_get_shallow(struct sbitmap *sb, unsigned long shallow_depth)
+{
+	int nr;
+
+	if (likely(sb->alloc_hint)) {
+		unsigned int hint, depth;
+
+		depth =3D READ_ONCE(sb->depth);
+		hint =3D update_alloc_hint_before_get(sb, depth);
+		nr =3D __sbitmap_get_shallow(sb, hint, shallow_depth);
+		update_alloc_hint_after_get(sb, depth, hint, nr);
+	} else {
+		nr =3D __sbitmap_get_shallow(sb, 0, shallow_depth);
+	}
+	return nr;
+}
 EXPORT_SYMBOL_GPL(sbitmap_get_shallow);
=20
 bool sbitmap_any_bit_set(const struct sbitmap *sb)
@@ -405,15 +450,10 @@ int sbitmap_queue_init_node(struct sbitmap_queue *s=
bq, unsigned int depth,
 	int i;
=20
 	ret =3D sbitmap_init_node(&sbq->sb, depth, shift, flags, node,
-				round_robin);
+				round_robin, true);
 	if (ret)
 		return ret;
=20
-	if (init_alloc_hint(sbq, flags) !=3D 0) {
-		sbitmap_free(&sbq->sb);
-		return -ENOMEM;
-	}
-
 	sbq->min_shallow_depth =3D UINT_MAX;
 	sbq->wake_batch =3D sbq_calc_wake_batch(sbq, depth);
 	atomic_set(&sbq->wake_index, 0);
@@ -421,7 +461,6 @@ int sbitmap_queue_init_node(struct sbitmap_queue *sbq=
, unsigned int depth,
=20
 	sbq->ws =3D kzalloc_node(SBQ_WAIT_QUEUES * sizeof(*sbq->ws), flags, nod=
e);
 	if (!sbq->ws) {
-		free_percpu(sbq->alloc_hint);
 		sbitmap_free(&sbq->sb);
 		return -ENOMEM;
 	}
@@ -463,32 +502,16 @@ EXPORT_SYMBOL_GPL(sbitmap_queue_resize);
=20
 int __sbitmap_queue_get(struct sbitmap_queue *sbq)
 {
-	unsigned int hint, depth;
-	int nr;
-
-	depth =3D READ_ONCE(sbq->sb.depth);
-	hint =3D update_alloc_hint_before_get(sbq, depth);
-	nr =3D sbitmap_get(&sbq->sb, hint);
-	update_alloc_hint_after_get(sbq, depth, hint, nr);
-
-	return nr;
+	return sbitmap_get(&sbq->sb);
 }
 EXPORT_SYMBOL_GPL(__sbitmap_queue_get);
=20
 int __sbitmap_queue_get_shallow(struct sbitmap_queue *sbq,
 				unsigned int shallow_depth)
 {
-	unsigned int hint, depth;
-	int nr;
-
 	WARN_ON_ONCE(shallow_depth < sbq->min_shallow_depth);
=20
-	depth =3D READ_ONCE(sbq->sb.depth);
-	hint =3D update_alloc_hint_before_get(sbq, depth);
-	nr =3D sbitmap_get_shallow(&sbq->sb, hint, shallow_depth);
-	update_alloc_hint_after_get(sbq, depth, hint, nr);
-
-	return nr;
+	return sbitmap_get_shallow(&sbq->sb, shallow_depth);
 }
 EXPORT_SYMBOL_GPL(__sbitmap_queue_get_shallow);
=20
@@ -597,7 +620,7 @@ void sbitmap_queue_clear(struct sbitmap_queue *sbq, u=
nsigned int nr,
 	sbitmap_queue_wake_up(sbq);
=20
 	if (likely(!sbq->sb.round_robin && nr < sbq->sb.depth))
-		*per_cpu_ptr(sbq->alloc_hint, cpu) =3D nr;
+		*per_cpu_ptr(sbq->sb.alloc_hint, cpu) =3D nr;
 }
 EXPORT_SYMBOL_GPL(sbitmap_queue_clear);
=20
@@ -635,7 +658,7 @@ void sbitmap_queue_show(struct sbitmap_queue *sbq, st=
ruct seq_file *m)
 		if (!first)
 			seq_puts(m, ", ");
 		first =3D false;
-		seq_printf(m, "%u", *per_cpu_ptr(sbq->alloc_hint, i));
+		seq_printf(m, "%u", *per_cpu_ptr(sbq->sb.alloc_hint, i));
 	}
 	seq_puts(m, "}\n");
=20
--=20
2.20.1

