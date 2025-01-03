Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27E81CB31D;
	Fri,  3 Jan 2025 07:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735889669; cv=none; b=qxyD5ftieeD2D1UgdqqLFclaP9Hf5aFa3JH/U/ibUTjpgTG63T+1AS1BPQV3hfOP3LklnMQUgRhCIdsrW8tCORGsk3P7n+3wBKDUCuXT4Eyna+5JjjWL0mr+99ry/rFMyEBYgkkSS6riZJeLwEzga/E3dd9L77bZVKgTTdXw3RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735889669; c=relaxed/simple;
	bh=IkRq42nXdOlZ7JPQm3Aqu4kaEOVPwpPwHw130MI6QTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VefCBoQ2uBZtHMFSkf247TuvTJrE5GAFkRB9g1ljRmwy0i7EGKOPB7XCi8iwNmyinKAX8GISFGf9fo+RhrkOIGQhVR7Bj6s2+mbVUeFGCiYQtiaYmb+LytUyrI+m6agRfs3FL+QCIvsDrS5k6mvxygEDwy91vG9/pqV9ENef210=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bsSDtf8O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bsSDtf8O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nfOzmNYg5Jb7eOtrEGMFecQW7RyfBHtxFoVVtj4oml4=; b=bsSDtf8Oj3lkPmgFWom5zGPFn6
	UhcTUasaPHE6bcD5Rt4UKMBp2UgYZlF1sPc1ZrUoaIKgFHOaJb5QeJ+mjS1unlThVLUv5Nj8OiXzE
	6xiW/LUFc9iAOMlA1/w3t9g1zWN3tFeb18BfIdQ3NGKCGQOw2GQNovdDm5LlEy7O/bzegEhdzCqgT
	R0mp82Ts7+kcti3mp3RkdkYNOgc8lHwvLfwqp8/u34YSCFQ7nxrlcEWuwIQlPZDeWjmmcoLhVvBKi
	9UBFr5xkOUor9DKCbqS0uqRApls9KW/NT3NeTXJJXPZSRSpsnBp770GweJ2ayJr/rlmp9/qTfCrPa
	q5P2w/qA==;
Received: from [2001:4bb8:2dc:484c:63c3:48c7:ceee:8370] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tTcCQ-0000000CM5k-29rT;
	Fri, 03 Jan 2025 07:34:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH 2/2] block: remove blk_rq_bio_prep
Date: Fri,  3 Jan 2025 08:33:58 +0100
Message-ID: <20250103073417.459715-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250103073417.459715-1-hch@lst.de>
References: <20250103073417.459715-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is not real point in a helper just to assign three values to four
fields, especially when the surrounding code is working on the
neighbor fields directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-map.c        | 10 ++++++----
 block/blk-mq.c         |  4 +++-
 include/linux/blk-mq.h |  8 --------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 67a2da3b7ed9..d2f22744b3d1 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -490,17 +490,19 @@ int blk_rq_append_bio(struct request *rq, struct bio *bio)
 		return ret;
 	}
 
-	if (!rq->bio) {
-		blk_rq_bio_prep(rq, bio, nr_segs);
-	} else {
+	if (rq->bio) {
 		if (!ll_back_merge_fn(rq, bio, nr_segs))
 			return -EINVAL;
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
-		rq->__data_len += (bio)->bi_iter.bi_size;
+		rq->__data_len += bio->bi_iter.bi_size;
 		bio_crypt_free_ctx(bio);
+		return 0;
 	}
 
+	rq->nr_phys_segments = nr_segs;
+	rq->bio = rq->biotail = bio;
+	rq->__data_len = bio->bi_iter.bi_size;
 	return 0;
 }
 EXPORT_SYMBOL(blk_rq_append_bio);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 16feec6c11ab..2e6132f778fd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2658,8 +2658,10 @@ static void blk_mq_bio_to_request(struct request *rq, struct bio *bio,
 	if (bio->bi_opf & REQ_RAHEAD)
 		rq->cmd_flags |= REQ_FAILFAST_MASK;
 
+	rq->bio = rq->biotail = bio;
 	rq->__sector = bio->bi_iter.bi_sector;
-	blk_rq_bio_prep(rq, bio, nr_segs);
+	rq->__data_len = bio->bi_iter.bi_size;
+	rq->nr_phys_segments = nr_segs;
 	if (bio_integrity(bio))
 		rq->nr_integrity_segments = blk_rq_count_integrity_sg(rq->q,
 								      bio);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2322b54a86ed..a0a9007cc1e3 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -968,14 +968,6 @@ static inline void blk_mq_cleanup_rq(struct request *rq)
 		rq->q->mq_ops->cleanup_rq(rq);
 }
 
-static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
-		unsigned int nr_segs)
-{
-	rq->nr_phys_segments = nr_segs;
-	rq->__data_len = bio->bi_iter.bi_size;
-	rq->bio = rq->biotail = bio;
-}
-
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
 		struct lock_class_key *key);
 
-- 
2.45.2

