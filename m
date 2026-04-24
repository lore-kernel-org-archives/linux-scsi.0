Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115B33E3C62;
	Fri, 24 Apr 2026 22:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777070555; cv=none; b=UKE2ASbRf4MLC74KW9pdRtN0cc51Oly+MOJFgOoPBx95KgWlEk6hLMLVlrOb8O7gu2iHEnEktUDahDcEx/DY0Nh5FatFmjqUCtf/NmsfWUZokE6XzcLfCZ8cAzoiSgJHSb2UY0cyyMzQzXKivIQIgSHwq14xcj6wg4cMHsDpb/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777070555; c=relaxed/simple;
	bh=ShLyGhZc93e3c5O4gCYr+IJHUeQxHxvKnK0JJDy9SWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihXo8P8UxLdYJHDOO7OdJ7DS7UnEdnT194zE6vf6rTeqxQcvKTEEhr2WzKdnaIUOZMJsp1G7b81oiEVrgUbNA8Si4heQQvWJlB4BLBT1hG+JcGVuHLGRU1CbPg4sZPE3VqJK4NlO6y1QmOgzDohJbET7J+gfVjSpOKj4oFq6EGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1sdiUv8u; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1sdiUv8u"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2Sdf2YNFz1XQmtj;
	Fri, 24 Apr 2026 22:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777070537; x=1779662538; bh=qecV2
	9wak0vdbbBbNe0fOzV5ToOHv99juCDkYCC5whw=; b=1sdiUv8u8b6JMQ7L4yFNU
	3ebui9BxA22GoYczZo4WoxKyeTdErydGIQ6oBHaQ5zmA9VXW397G3vdt6iYylVVm
	pxNOHdBRvuwGBYRslKeKj2G45YfdGDfCoWVm/isuN28tLwFlqMLNY91bBsEC8mIn
	mZeJA8w7dT+ROO3OB3Zolr0eFr5VW7i4emUcnmWIIhXOxt4FSY7vYJ292V0GtunA
	bP2D8KNWSI/i9DTTbVji0ZI8TtEDSX0h6c3ug71Xlw7PEkllGJ6KA0Y8uaGa4hyi
	mOWrcVsIVrtPfq63J9nNiObHPcFDbivO8+QKESxqxYcNIEYOB3ylUYJfQsR3nRmb
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i_2n6Wj-Q-oM; Fri, 24 Apr 2026 22:42:17 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2SdM1bqKz1XLHZH;
	Fri, 24 Apr 2026 22:42:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 02/12] block: Add the REQ_OP_COPY_{SRC,DST} operations
Date: Fri, 24 Apr 2026 15:41:51 -0700
Message-ID: <20260424224201.1949243-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
In-Reply-To: <20260424224201.1949243-1-bvanassche@acm.org>
References: <20260424224201.1949243-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Nitesh Shetty <nj.shetty@samsung.com>

Introduce the REQ_OP_COPY_SRC and REQ_OP_COPY_DST operations. The source
and destination LBA range information is in separate bios because any
other approach would require a rewrite of the device mapper. These bios
are associated with each other via the new bi_copy_ctx pointer. A new
pointer has been introduced because the copy offloading context
information must be preserved when cloning a bio and the bi_private bio
member must not be copied when cloning a bio.

This patch supports the following approach for copy offloading:
1. Allocate a struct bio_copy_offload_ctx instance and set phase to
   BLKDEV_TRANSLATE_LBAS.
2. Allocate REQ_OP_COPY_SRC and REQ_OP_COPY_DST bios. Set the
   bi_copy_ctx member of these bios.
3. Set the bio_count member of struct bio_copy_offload_ctx.
4. Submit all REQ_OP_COPY_* bios.
5. In submit_bio(), do the following for REQ_OP_COPY_* bios:
   - If bio->bi_bdev is a stacking device, submit the bio. This will
     send the bio to the device mapper. The device mapper will clone the
     bio, translate the LBAs and will submit the cloned bio. That will
     result in a recursive submit_bio() call.
   - If bio->bi_bdev is not a stacking device, add the bio to the
     copy_ctx->bios list and decrement copy_ctx->bio_count.
6. Once copy_ctx->bio_count =3D=3D 0, call copy_ctx->translation_complete=
().
7. In the implementation of copy_ctx->translation_complete(), change
   copy_ctx->phase from BLKDEV_TRANSLATE_LBAS into BLKDEV_COPY.
8. Submit the first REQ_OP_COPY_* bio of the copy_ctx->bios list.
9. Once this bio reaches the block driver associated with the bio,
   retrieve the other bios involved in the copy operation from the copy
   context data structure and convert all these bios into a copy offload
   operation.
10. Once this bio completes, also complete all the other bios involved
    in the copy offload operation.

This patch increases the size of struct bio from 104 to 112 bytes on 64-b=
it
systems.

To be discussed further: whether adding a new member in struct bio is
acceptable or whether the new pointer perhaps should be stored in front o=
f
the bio. bioset_init() supports front padding.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
[ bvanassche: changed the approach of this patch from combining the
  COPY_SRC and COPY_DST operations immediately to translating the LBA
  information first. ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/bio.c               |  1 +
 block/blk-core.c          | 38 ++++++++++++++++++++++++++++++++
 block/blk-merge.c         | 13 +++++++++++
 block/blk.h               |  5 +++++
 include/linux/blk-copy.h  | 46 +++++++++++++++++++++++++++++++++++++++
 include/linux/blk_types.h | 17 +++++++++++++++
 6 files changed, 120 insertions(+)
 create mode 100644 include/linux/blk-copy.h

diff --git a/block/bio.c b/block/bio.c
index b8972dba68a0..51480c9be27b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -852,6 +852,7 @@ static int __bio_clone(struct bio *bio, struct bio *b=
io_src, gfp_t gfp)
 	bio->bi_write_hint =3D bio_src->bi_write_hint;
 	bio->bi_write_stream =3D bio_src->bi_write_stream;
 	bio->bi_iter =3D bio_src->bi_iter;
+	bio->bi_copy_ctx =3D bio_src->bi_copy_ctx;
=20
 	if (bio->bi_bdev) {
 		if (bio->bi_bdev =3D=3D bio_src->bi_bdev &&
diff --git a/block/blk-core.c b/block/blk-core.c
index 17450058ea6d..37c01e717202 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/blk-copy.h>
 #include <linux/blk-pm.h>
 #include <linux/blk-integrity.h>
 #include <linux/highmem.h>
@@ -108,6 +109,8 @@ static const char *const blk_op_name[] =3D {
 	REQ_OP_NAME(ZONE_FINISH),
 	REQ_OP_NAME(ZONE_APPEND),
 	REQ_OP_NAME(WRITE_ZEROES),
+	REQ_OP_NAME(COPY_SRC),
+	REQ_OP_NAME(COPY_DST),
 	REQ_OP_NAME(DRV_IN),
 	REQ_OP_NAME(DRV_OUT),
 };
@@ -782,6 +785,8 @@ void submit_bio_noacct(struct bio *bio)
 	struct block_device *bdev =3D bio->bi_bdev;
 	struct request_queue *q =3D bdev_get_queue(bdev);
 	blk_status_t status =3D BLK_STS_IOERR;
+	struct bio_copy_offload_ctx *copy_ctx;
+	u32 bio_count;
=20
 	might_sleep();
=20
@@ -875,6 +880,39 @@ void submit_bio_noacct(struct bio *bio)
 		 * requests.
 		 */
 		fallthrough;
+	case REQ_OP_COPY_SRC:
+	case REQ_OP_COPY_DST:
+		copy_ctx =3D bio->bi_copy_ctx;
+		WARN_ON_ONCE(copy_ctx->phase =3D=3D BLKDEV_COPY_DONE);
+		if (copy_ctx->phase =3D=3D BLKDEV_COPY)
+			break;
+		/* If copy offloading is not supported, fail the bio. */
+		if (!q->limits.max_copy_sectors) {
+			scoped_guard(spinlock_irqsave, &copy_ctx->lock)
+				copy_ctx->bio_count--;
+			goto not_supported;
+		}
+		/*
+		 * If the block driver is a stacking driver that supports copy
+		 * offloading, submit the bio.
+		 */
+		if (q->limits.features & BLK_FEAT_STACKING_COPY_OFFL)
+			break;
+		/*
+		 * Append the bio at the end of the bio->bi_copy_ctx->bios list.
+		 */
+		scoped_guard(spinlock_irqsave, &copy_ctx->lock) {
+			if (copy_ctx->biotail)
+				copy_ctx->biotail->bi_next =3D bio;
+			else
+				copy_ctx->bios =3D bio;
+			copy_ctx->biotail =3D bio;
+			bio_count =3D --copy_ctx->bio_count;
+		}
+		WARN_ON_ONCE(bio_count < 0);
+		if (bio_count =3D=3D 0)
+			copy_ctx->translation_complete(copy_ctx);
+		return;
 	default:
 		goto not_supported;
 	}
diff --git a/block/blk-merge.c b/block/blk-merge.c
index fcf09325b22e..4678131650d2 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -207,6 +207,19 @@ struct bio *bio_split_discard(struct bio *bio, const=
 struct queue_limits *lim,
 	return __bio_split_discard(bio, lim, nsegs, max_sectors);
 }
=20
+struct bio *bio_split_copy(struct bio *bio, const struct queue_limits *l=
im,
+			   unsigned int *nsegs)
+{
+	*nsegs =3D 1;
+	if (bio_sectors(bio) <=3D lim->max_copy_sectors)
+		return bio;
+
+	/* Splitting a REQ_OP_COPY_* bio is not supported. */
+	bio->bi_status =3D BLK_STS_NOTSUPP;
+	bio_endio(bio);
+	return NULL;
+}
+
 static inline unsigned int blk_boundary_sectors(const struct queue_limit=
s *lim,
 						bool is_atomic)
 {
diff --git a/block/blk.h b/block/blk.h
index b998a7761faf..274c226e87ee 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -379,6 +379,8 @@ struct bio *bio_split_rw(struct bio *bio, const struc=
t queue_limits *lim,
 		unsigned *nr_segs);
 struct bio *bio_split_zone_append(struct bio *bio,
 		const struct queue_limits *lim, unsigned *nr_segs);
+struct bio *bio_split_copy(struct bio *bio, const struct queue_limits *l=
im,
+			   unsigned int *nsegs);
=20
 /*
  * All drivers must accept single-segments bios that are smaller than PA=
GE_SIZE.
@@ -435,6 +437,9 @@ static inline struct bio *__bio_split_to_limits(struc=
t bio *bio,
 		return bio_split_discard(bio, lim, nr_segs);
 	case REQ_OP_WRITE_ZEROES:
 		return bio_split_write_zeroes(bio, lim, nr_segs);
+	case REQ_OP_COPY_SRC:
+	case REQ_OP_COPY_DST:
+		return bio_split_copy(bio, lim, nr_segs);
 	default:
 		/* other operations can't be split */
 		*nr_segs =3D 0;
diff --git a/include/linux/blk-copy.h b/include/linux/blk-copy.h
new file mode 100644
index 000000000000..5e38cfc14a71
--- /dev/null
+++ b/include/linux/blk-copy.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __LINUX_BLK_COPY_H
+#define __LINUX_BLK_COPY_H
+
+#include <linux/blk_types.h>
+#include <linux/completion.h>
+#include <linux/list.h>
+#include <linux/spinlock_types.h>
+#include <linux/workqueue_types.h>
+
+struct blk_copy_params;
+struct request;
+
+enum blkdev_copy_phase {
+	BLKDEV_TRANSLATE_LBAS,
+	BLKDEV_COPY,
+	BLKDEV_COPY_DONE,
+};
+
+/*
+ * struct bio_copy_offload_ctx - context information for blkdev_copy_off=
load()
+ * @params: Input parameters passed to blkdev_copy_offload().
+ * @len: Number of bytes associated with this copy context.
+ * @phase: Copy offload phase: either translating LBAs or copying data.
+ * @lock: Protects @bios, @biotail and @bio_count.
+ * @bios: List with REQ_OP_COPY_* bios for which LBA translation complet=
ed.
+ * @biotail: Last element in the @bios list.
+ * @bio_count: Number bios for which LBA translation has not yet complet=
ed.
+ * @status: bio completion status.
+ * @translation_complete: Called after LBA translation has completed.
+ *	LBA translation has completed once bio_count drops to zero.
+ */
+struct bio_copy_offload_ctx {
+	struct blk_copy_params *params;
+	loff_t len;
+	enum blkdev_copy_phase phase;
+	spinlock_t lock;
+	struct bio *bios __guarded_by(&lock);
+	struct bio *biotail __guarded_by(&lock);
+	u32 bio_count __guarded_by(&lock);
+	blk_status_t status __guarded_by(&lock);
+	void (*translation_complete)(struct bio_copy_offload_ctx *ctx);
+};
+
+#endif /* __LINUX_BLK_COPY_H */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..4e448e810b87 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -284,6 +284,8 @@ struct bio {
 	atomic_t		__bi_cnt;	/* pin count */
=20
 	struct bio_set		*bi_pool;
+
+	void			*bi_copy_ctx;
 };
=20
 #define BIO_RESET_BYTES		offsetof(struct bio, bi_max_vecs)
@@ -370,6 +372,10 @@ enum req_op {
 	/** @REQ_OP_ZONE_RESET_ALL: reset all the zone present on the device */
 	REQ_OP_ZONE_RESET_ALL	=3D (__force blk_opf_t)19,
=20
+	/* copy offload source and destination operations */
+	REQ_OP_COPY_SRC		=3D (__force blk_opf_t)20,
+	REQ_OP_COPY_DST		=3D (__force blk_opf_t)21,
+
 	/* Driver private requests */
 	/* private: */
 	REQ_OP_DRV_IN		=3D (__force blk_opf_t)34,
@@ -461,6 +467,17 @@ static inline bool op_is_write(blk_opf_t op)
 	return !!(op & (__force blk_opf_t)1);
 }
=20
+static inline bool op_is_copy(blk_opf_t op)
+{
+	switch (op & REQ_OP_MASK) {
+	case REQ_OP_COPY_DST:
+	case REQ_OP_COPY_SRC:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * Check if the bio or request is one that needs special treatment in th=
e
  * flush state machine.
