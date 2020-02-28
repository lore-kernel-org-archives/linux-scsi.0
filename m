Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EC3C3F2CD
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28462246AC
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:29:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f7DnE8g9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgB1X3o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:29:44 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22875 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726603AbgB1X3o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 18:29:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582932582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5PS2Kj4SN/yeDXN2hNmXYDUkTimvWRXiu7vxPGL1OcE=;
        b=f7DnE8g95H+yv0NogVJaKfiTpCD2+FqnrLS5g1aBKBldWo8h1Kz4taPjwEiCiWdw+271QG
        8daJiaq4iubo/AL3wjUaQE3YWRspYr5RKTJT70RxAKFHVgCQtdlx5jzz8Nm59+tY+fgSll
        TB7ffqfa4UGIQAakPu0O/XGBrStZrlk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-PHNWtnO8OsaOw6HsWwptPg-1; Fri, 28 Feb 2020 18:29:38 -0500
X-MC-Unique: PHNWtnO8OsaOw6HsWwptPg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EC28100550E;
        Fri, 28 Feb 2020 23:29:36 +0000 (UTC)
Received: from localhost (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF36860BF1;
        Fri, 28 Feb 2020 23:29:32 +0000 (UTC)
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
Subject: [PATCH V2 01/10] sbitmap: maintain allocation round_robin in sbitmap
Date:   Sat, 29 Feb 2020 07:29:11 +0800
Message-Id: <20200228232920.20960-2-ming.lei@redhat.com>
In-Reply-To: <20200228232920.20960-1-ming.lei@redhat.com>
References: <20200228232920.20960-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now allocation round_robin info is maintained by sbitmap_queue.

Actually, bit allocation belongs to sbitmap. Also the following
patch will move alloc_hint to sbitmap for users with high depth.

So move round_robin to sbitmap.

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
 block/blk-mq.c            |  2 +-
 block/kyber-iosched.c     |  3 ++-
 drivers/dma/idxd/device.c |  2 +-
 drivers/dma/idxd/submit.c |  2 +-
 include/linux/sbitmap.h   | 20 ++++++++++----------
 lib/sbitmap.c             | 28 ++++++++++++++--------------
 6 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a12b1763508d..116626b76b08 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2397,7 +2397,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct b=
lk_mq_tag_set *set,
 		goto free_cpumask;
=20
 	if (sbitmap_init_node(&hctx->ctx_map, nr_cpu_ids, ilog2(8),
-				gfp, node))
+				gfp, node, false))
 		goto free_ctxs;
 	hctx->nr_ctx =3D 0;
=20
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index 34dcea0ef637..21587cca1cb3 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -479,7 +479,8 @@ static int kyber_init_hctx(struct blk_mq_hw_ctx *hctx=
, unsigned int hctx_idx)
=20
 	for (i =3D 0; i < KYBER_NUM_DOMAINS; i++) {
 		if (sbitmap_init_node(&khd->kcq_map[i], hctx->nr_ctx,
-				      ilog2(8), GFP_KERNEL, hctx->numa_node)) {
+				      ilog2(8), GFP_KERNEL, hctx->numa_node,
+				      false)) {
 			while (--i >=3D 0)
 				sbitmap_free(&khd->kcq_map[i]);
 			goto err_kcqs;
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index ada69e722f84..5d59c868b2da 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -181,7 +181,7 @@ int idxd_wq_alloc_resources(struct idxd_wq *wq)
 		goto fail_alloc_descs;
=20
 	rc =3D sbitmap_init_node(&wq->sbmap, num_descs, -1, GFP_KERNEL,
-			       dev_to_node(dev));
+			       dev_to_node(dev), false);
 	if (rc < 0)
 		goto fail_sbitmap_init;
=20
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 45a0c5869a0a..842af85c7d43 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -45,7 +45,7 @@ struct idxd_desc *idxd_alloc_desc(struct idxd_wq *wq, e=
num idxd_op_type optype)
 		percpu_up_read(&wq->submit_lock);
 	}
=20
-	idx =3D sbitmap_get(&wq->sbmap, 0, false);
+	idx =3D sbitmap_get(&wq->sbmap, 0);
 	if (idx < 0) {
 		atomic_dec(&wq->dq_count);
 		return ERR_PTR(-EAGAIN);
diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index e40d019c3d9d..559c37e27d30 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -61,6 +61,11 @@ struct sbitmap {
 	 */
 	unsigned int map_nr;
=20
+	/**
+	 * @round_robin: Allocate bits in strict round-robin order.
+	 */
+	bool round_robin;
+
 	/**
 	 * @map: Allocated bitmap.
 	 */
@@ -129,11 +134,6 @@ struct sbitmap_queue {
 	 */
 	atomic_t ws_active;
=20
-	/**
-	 * @round_robin: Allocate bits in strict round-robin order.
-	 */
-	bool round_robin;
-
 	/**
 	 * @min_shallow_depth: The minimum shallow depth which may be passed to
 	 * sbitmap_queue_get_shallow() or __sbitmap_queue_get_shallow().
@@ -149,11 +149,14 @@ struct sbitmap_queue {
  *         given, a good default is chosen.
  * @flags: Allocation flags.
  * @node: Memory node to allocate on.
+ * @round_robin: If true, be stricter about allocation order; always all=
ocate
+ *               starting from the last allocated bit. This is less effi=
cient
+ *               than the default behavior (false).
  *
  * Return: Zero on success or negative errno on failure.
  */
 int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
-		      gfp_t flags, int node);
+		      gfp_t flags, int node, bool round_robin);
=20
 /**
  * sbitmap_free() - Free memory used by a &struct sbitmap.
@@ -179,15 +182,12 @@ void sbitmap_resize(struct sbitmap *sb, unsigned in=
t depth);
  * sbitmap_get() - Try to allocate a free bit from a &struct sbitmap.
  * @sb: Bitmap to allocate from.
  * @alloc_hint: Hint for where to start searching for a free bit.
- * @round_robin: If true, be stricter about allocation order; always all=
ocate
- *               starting from the last allocated bit. This is less effi=
cient
- *               than the default behavior (false).
  *
  * This operation provides acquire barrier semantics if it succeeds.
  *
  * Return: Non-negative allocated bit number if successful, -1 otherwise=
.
  */
-int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint, bool round_=
robin);
+int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint);
=20
 /**
  * sbitmap_get_shallow() - Try to allocate a free bit from a &struct sbi=
tmap,
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index af88d1346dd7..86018a6fccae 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -42,7 +42,7 @@ static inline bool sbitmap_deferred_clear(struct sbitma=
p *sb, int index)
 }
=20
 int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
-		      gfp_t flags, int node)
+		      gfp_t flags, int node, bool round_robin)
 {
 	unsigned int bits_per_word;
 	unsigned int i;
@@ -67,6 +67,7 @@ int sbitmap_init_node(struct sbitmap *sb, unsigned int =
depth, int shift,
 	sb->shift =3D shift;
 	sb->depth =3D depth;
 	sb->map_nr =3D DIV_ROUND_UP(sb->depth, bits_per_word);
+	sb->round_robin =3D round_robin;
=20
 	if (depth =3D=3D 0) {
 		sb->map =3D NULL;
@@ -137,14 +138,14 @@ static int __sbitmap_get_word(unsigned long *word, =
unsigned long depth,
 }
=20
 static int sbitmap_find_bit_in_index(struct sbitmap *sb, int index,
-				     unsigned int alloc_hint, bool round_robin)
+				     unsigned int alloc_hint)
 {
 	int nr;
=20
 	do {
 		nr =3D __sbitmap_get_word(&sb->map[index].word,
 					sb->map[index].depth, alloc_hint,
-					!round_robin);
+					!sb->round_robin);
 		if (nr !=3D -1)
 			break;
 		if (!sbitmap_deferred_clear(sb, index))
@@ -154,7 +155,7 @@ static int sbitmap_find_bit_in_index(struct sbitmap *=
sb, int index,
 	return nr;
 }
=20
-int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint, bool round_=
robin)
+int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint)
 {
 	unsigned int i, index;
 	int nr =3D -1;
@@ -166,14 +167,13 @@ int sbitmap_get(struct sbitmap *sb, unsigned int al=
loc_hint, bool round_robin)
 	 * alloc_hint to find the right word index. No point in looping
 	 * twice in find_next_zero_bit() for that case.
 	 */
-	if (round_robin)
+	if (sb->round_robin)
 		alloc_hint =3D SB_NR_TO_BIT(sb, alloc_hint);
 	else
 		alloc_hint =3D 0;
=20
 	for (i =3D 0; i < sb->map_nr; i++) {
-		nr =3D sbitmap_find_bit_in_index(sb, index, alloc_hint,
-						round_robin);
+		nr =3D sbitmap_find_bit_in_index(sb, index, alloc_hint);
 		if (nr !=3D -1) {
 			nr +=3D index << sb->shift;
 			break;
@@ -355,7 +355,8 @@ int sbitmap_queue_init_node(struct sbitmap_queue *sbq=
, unsigned int depth,
 	int ret;
 	int i;
=20
-	ret =3D sbitmap_init_node(&sbq->sb, depth, shift, flags, node);
+	ret =3D sbitmap_init_node(&sbq->sb, depth, shift, flags, node,
+				round_robin);
 	if (ret)
 		return ret;
=20
@@ -387,7 +388,6 @@ int sbitmap_queue_init_node(struct sbitmap_queue *sbq=
, unsigned int depth,
 		atomic_set(&sbq->ws[i].wait_cnt, sbq->wake_batch);
 	}
=20
-	sbq->round_robin =3D round_robin;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sbitmap_queue_init_node);
@@ -429,12 +429,12 @@ int __sbitmap_queue_get(struct sbitmap_queue *sbq)
 		hint =3D depth ? prandom_u32() % depth : 0;
 		this_cpu_write(*sbq->alloc_hint, hint);
 	}
-	nr =3D sbitmap_get(&sbq->sb, hint, sbq->round_robin);
+	nr =3D sbitmap_get(&sbq->sb, hint);
=20
 	if (nr =3D=3D -1) {
 		/* If the map is full, a hint won't do us much good. */
 		this_cpu_write(*sbq->alloc_hint, 0);
-	} else if (nr =3D=3D hint || unlikely(sbq->round_robin)) {
+	} else if (nr =3D=3D hint || unlikely(sbq->sb.round_robin)) {
 		/* Only update the hint if we used it. */
 		hint =3D nr + 1;
 		if (hint >=3D depth - 1)
@@ -465,7 +465,7 @@ int __sbitmap_queue_get_shallow(struct sbitmap_queue =
*sbq,
 	if (nr =3D=3D -1) {
 		/* If the map is full, a hint won't do us much good. */
 		this_cpu_write(*sbq->alloc_hint, 0);
-	} else if (nr =3D=3D hint || unlikely(sbq->round_robin)) {
+	} else if (nr =3D=3D hint || unlikely(sbq->sb.round_robin)) {
 		/* Only update the hint if we used it. */
 		hint =3D nr + 1;
 		if (hint >=3D depth - 1)
@@ -581,7 +581,7 @@ void sbitmap_queue_clear(struct sbitmap_queue *sbq, u=
nsigned int nr,
 	smp_mb__after_atomic();
 	sbitmap_queue_wake_up(sbq);
=20
-	if (likely(!sbq->round_robin && nr < sbq->sb.depth))
+	if (likely(!sbq->sb.round_robin && nr < sbq->sb.depth))
 		*per_cpu_ptr(sbq->alloc_hint, cpu) =3D nr;
 }
 EXPORT_SYMBOL_GPL(sbitmap_queue_clear);
@@ -638,7 +638,7 @@ void sbitmap_queue_show(struct sbitmap_queue *sbq, st=
ruct seq_file *m)
 	}
 	seq_puts(m, "}\n");
=20
-	seq_printf(m, "round_robin=3D%d\n", sbq->round_robin);
+	seq_printf(m, "round_robin=3D%d\n", sbq->sb.round_robin);
 	seq_printf(m, "min_shallow_depth=3D%u\n", sbq->min_shallow_depth);
 }
 EXPORT_SYMBOL_GPL(sbitmap_queue_show);
--=20
2.20.1

