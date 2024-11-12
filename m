Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6E9206E65;
	Tue, 12 Nov 2024 17:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731430861; cv=none; b=sSFuGairJ/LDzrUWT6/Qknu14O3mCHADCa/9ogOIL3b+dt2O26xw3w7Z8ywhx8DgRpKFlsqdEcHlEVHHXJXKgJxgx57yR0BoUHfchU9SVn0i9OLkmFbS8urUDAj/Yo+yaZkjPdYN4mDrVpiH/2lxsFw7FXApAiSTmD4OosQ1xMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731430861; c=relaxed/simple;
	bh=gFyBJD6zVIZmB5mbfjF7qFm5YmP9hBxzTLByiGMxIbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2cvAv5XPNrNVgISy2p/tiPqtT08nFg3/PjlqPZvgogKCpAbyOY+UZ9gTA0GGjfi7EQJ5lwe84l361phSkEEBw3Tb/0wYg9ED3LKMxUt5goPISZJxr6ZoE30408Jc4gwgRbVSHhR5xperM8ZN72Mt1pGYbY2lIIwbGHwugBxi4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eb94nNNx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eb94nNNx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Q/i/wyOuBvlJixQME5kIxyUbgfDaERJIyJ3i1ZIExBw=; b=eb94nNNx/jXWq+0HTN4sPhMrFl
	HqHI+gc76WCdgSHihMcKkZSur+Kt4iP8W8pZ8SnDvNs13vul2dxiDNtJ81L/G5XKETN97p5dncPjT
	R12jLgRGKC4NFPvG3mmWSilqlLiPkvHUaMR2ZmaGXgLYieH7ifmsg3o6olgNWKNLS3DoWPeQM0Wky
	J4RKjTiN7Lnfkq7W7WPKGyyYponNjhxxkTx/pnqt7KC5Ke0k3SdP29yPgQAsJWOUYJHJwMkPQfVPg
	KZMgNLaKUeIXfwkDUW9jVoSUN8RndSaJevXKBiT+gkp+EsRWNU4fAzCuVtMcECOxnB7BwD7Ki79YA
	5VtR3KfQ==;
Received: from 2a02-8389-2341-5b80-9a3d-4734-1162-bba0.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9a3d:4734:1162:bba0] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tAuG9-00000004GYp-1oIC;
	Tue, 12 Nov 2024 17:00:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] block: remove the write_hint field from struct request
Date: Tue, 12 Nov 2024 18:00:38 +0100
Message-ID: <20241112170050.1612998-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241112170050.1612998-1-hch@lst.de>
References: <20241112170050.1612998-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The write_hint is only used for read/write requests, which must have a
bio attached to them.  Just use the bio field instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c      | 16 ++++++++++------
 block/blk-mq.c         |  2 --
 drivers/scsi/sd.c      |  6 +++---
 include/linux/blk-mq.h |  1 -
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 7b0af8317c1c..2306014c108d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -867,9 +867,11 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (rq_data_dir(req) != rq_data_dir(next))
 		return NULL;
 
-	/* Don't merge requests with different write hints. */
-	if (req->write_hint != next->write_hint)
-		return NULL;
+	if (req->bio && next->bio) {
+		/* Don't merge requests with different write hints. */
+		if (req->bio->bi_write_hint != next->bio->bi_write_hint)
+			return NULL;
+	}
 
 	if (req->ioprio != next->ioprio)
 		return NULL;
@@ -1001,9 +1003,11 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (!bio_crypt_rq_ctx_compatible(rq, bio))
 		return false;
 
-	/* Don't merge requests with different write hints. */
-	if (rq->write_hint != bio->bi_write_hint)
-		return false;
+	if (rq->bio) {
+		/* Don't merge requests with different write hints. */
+		if (rq->bio->bi_write_hint != bio->bi_write_hint)
+			return false;
+	}
 
 	if (rq->ioprio != bio_prio(bio))
 		return false;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5e240a4b6be0..65e6b86d341c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2660,7 +2660,6 @@ static void blk_mq_bio_to_request(struct request *rq, struct bio *bio,
 		rq->cmd_flags |= REQ_FAILFAST_MASK;
 
 	rq->__sector = bio->bi_iter.bi_sector;
-	rq->write_hint = bio->bi_write_hint;
 	blk_rq_bio_prep(rq, bio, nr_segs);
 	if (bio_integrity(bio))
 		rq->nr_integrity_segments = blk_rq_count_integrity_sg(rq->q,
@@ -3308,7 +3307,6 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	}
 	rq->nr_phys_segments = rq_src->nr_phys_segments;
 	rq->ioprio = rq_src->ioprio;
-	rq->write_hint = rq_src->write_hint;
 
 	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
 		goto free_and_out;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ca4bc0ac76ad..8947dab132d7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1190,8 +1190,8 @@ static u8 sd_group_number(struct scsi_cmnd *cmd)
 	if (!sdkp->rscs)
 		return 0;
 
-	return min3((u32)rq->write_hint, (u32)sdkp->permanent_stream_count,
-		    0x3fu);
+	return min3((u32)rq->bio->bi_write_hint,
+		    (u32)sdkp->permanent_stream_count, 0x3fu);
 }
 
 static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
@@ -1389,7 +1389,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
 	} else if ((nr_blocks > 0xff) || (lba > 0x1fffff) ||
-		   sdp->use_10_for_rw || protect || rq->write_hint) {
+		   sdp->use_10_for_rw || protect || rq->bio->bi_write_hint) {
 		ret = sd_setup_rw10_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua);
 	} else {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2035fad3131f..2804fe181d9d 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -156,7 +156,6 @@ struct request {
 	struct blk_crypto_keyslot *crypt_keyslot;
 #endif
 
-	enum rw_hint write_hint;
 	unsigned short ioprio;
 
 	enum mq_rq_state state;
-- 
2.45.2

