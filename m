Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1C71C3221;
	Mon, 25 Mar 2024 04:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341898; cv=none; b=sYepaGZMeNWUGoYB6V5M9eQmmXaRXhdtGVVMDyaaHgzx3/qaZQtjEAYkogqduPqR5RJ5pnoeb/wcv/1Iko3696OpgnkpoRkXUBKLoIxmhiGIUPHQ0qR56S9q54WI6SEIoZSqx03BHT6gb2RFXPJgr1Kt+3odf/OtpT0kfqCcCaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341898; c=relaxed/simple;
	bh=RnoX5upttHVgQnc+jhMKbIaEKnjun/Mtv8asXEtshE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnPZYfZeYp0oYkmAwxX4mKdbgSMTRGa2ApOFCR8j1Hy7TRYWOHNpNltnpMl2hUTG1fnWW+c9Dwk4bAEEW0KTyqzPW29bZFA6EuEF81NFaxyJ8DUJj7GQzHErz2Upql3NFwsJ4BGbIGRB+RC1sQOmxBj1ZgptVUp2UI77j+c6/WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iq+2N+qQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iq+2N+qQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCC3C433C7;
	Mon, 25 Mar 2024 04:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341898;
	bh=RnoX5upttHVgQnc+jhMKbIaEKnjun/Mtv8asXEtshE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iq+2N+qQgbRYSHMbd+3TdiQWyhuY6UPh4ytDDvY4kMzR+fpGP42ltA3/TyKtYbceL
	 oB4tppuwSturj3auh3/Nsg9QK/bos5o9wk0Yh3cRDRXEiGUemjSSfWCJ4cIBKC9zwN
	 O4QmLCsFdXIjWRW6QY78iJd94hUh084CZuKYUdAbSyfzsJNrhNEP6hViDtGCu9CuR3
	 kNFPOTU9jBThPpaHED/lkCw9NUxe/bV5HbQmpLV0aUG082a8FQXZPsUCXZTg7+tr0a
	 USuwX8Cp0Ngy8QO+F9amNPTTOCjNasotpodt/JMJkUcJtlf7OmlbizLyT1czDMHQHg
	 cqrkFRxux1B7Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 02/28] block: Remove req_bio_endio()
Date: Mon, 25 Mar 2024 13:44:26 +0900
Message-ID: <20240325044452.3125418-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325044452.3125418-1-dlemoal@kernel.org>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Moving req_bio_endio() code into its only caller, blk_update_request(),
allows reducing accesses to and tests of bio and request fields. Also,
given that partial completions of zone append operations is not
possible and that zone append operations cannot be merged, the update
of the BIO sector using the request sector for these operations can be
moved directly before the call to bio_endio().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-mq.c | 66 ++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 35 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 555ada922cf0..8aeb8e96f1a7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -761,36 +761,6 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 }
 EXPORT_SYMBOL(blk_dump_rq_flags);
 
-static void req_bio_endio(struct request *rq, struct bio *bio,
-			  unsigned int nbytes, blk_status_t error)
-{
-	if (unlikely(error)) {
-		bio->bi_status = error;
-	} else if (req_op(rq) == REQ_OP_ZONE_APPEND) {
-		/*
-		 * Partial zone append completions cannot be supported as the
-		 * BIO fragments may end up not being written sequentially.
-		 * For such case, force the completed nbytes to be equal to
-		 * the BIO size so that bio_advance() sets the BIO remaining
-		 * size to 0 and we end up calling bio_endio() before returning.
-		 */
-		if (bio->bi_iter.bi_size != nbytes) {
-			bio->bi_status = BLK_STS_IOERR;
-			nbytes = bio->bi_iter.bi_size;
-		} else {
-			bio->bi_iter.bi_sector = rq->__sector;
-		}
-	}
-
-	bio_advance(bio, nbytes);
-
-	if (unlikely(rq->rq_flags & RQF_QUIET))
-		bio_set_flag(bio, BIO_QUIET);
-	/* don't actually finish bio if it's part of flush sequence */
-	if (bio->bi_iter.bi_size == 0 && !(rq->rq_flags & RQF_FLUSH_SEQ))
-		bio_endio(bio);
-}
-
 static void blk_account_io_completion(struct request *req, unsigned int bytes)
 {
 	if (req->part && blk_do_io_stat(req)) {
@@ -894,6 +864,8 @@ static void blk_complete_request(struct request *req)
 bool blk_update_request(struct request *req, blk_status_t error,
 		unsigned int nr_bytes)
 {
+	bool is_flush = req->rq_flags & RQF_FLUSH_SEQ;
+	bool quiet = req->rq_flags & RQF_QUIET;
 	int total_bytes;
 
 	trace_block_rq_complete(req, error, nr_bytes);
@@ -914,9 +886,8 @@ bool blk_update_request(struct request *req, blk_status_t error,
 	if (blk_crypto_rq_has_keyslot(req) && nr_bytes >= blk_rq_bytes(req))
 		__blk_crypto_rq_put_keyslot(req);
 
-	if (unlikely(error && !blk_rq_is_passthrough(req) &&
-		     !(req->rq_flags & RQF_QUIET)) &&
-		     !test_bit(GD_DEAD, &req->q->disk->state)) {
+	if (unlikely(error && !blk_rq_is_passthrough(req) && !quiet) &&
+	    !test_bit(GD_DEAD, &req->q->disk->state)) {
 		blk_print_req_error(req, error);
 		trace_block_rq_error(req, error, nr_bytes);
 	}
@@ -928,12 +899,37 @@ bool blk_update_request(struct request *req, blk_status_t error,
 		struct bio *bio = req->bio;
 		unsigned bio_bytes = min(bio->bi_iter.bi_size, nr_bytes);
 
-		if (bio_bytes == bio->bi_iter.bi_size)
+		if (unlikely(error))
+			bio->bi_status = error;
+
+		if (bio_bytes == bio->bi_iter.bi_size) {
 			req->bio = bio->bi_next;
+		} else if (req_op(req) == REQ_OP_ZONE_APPEND) {
+			/*
+			 * Partial zone append completions cannot be supported
+			 * as the BIO fragments may end up not being written
+			 * sequentially. For such case, force the completed
+			 * nbytes to be equal to the BIO size so that
+			 * bio_advance() sets the BIO remaining size to 0 and
+			 * we end up calling bio_endio() before returning.
+			 */
+			bio->bi_status = BLK_STS_IOERR;
+			bio_bytes = bio->bi_iter.bi_size;
+		}
 
 		/* Completion has already been traced */
 		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
-		req_bio_endio(req, bio, bio_bytes, error);
+		if (unlikely(quiet))
+			bio_set_flag(bio, BIO_QUIET);
+
+		bio_advance(bio, bio_bytes);
+
+		/* Don't actually finish bio if it's part of flush sequence */
+		if (!bio->bi_iter.bi_size && !is_flush) {
+			if (req_op(req) == REQ_OP_ZONE_APPEND)
+				bio->bi_iter.bi_sector = req->__sector;
+			bio_endio(bio);
+		}
 
 		total_bytes += bio_bytes;
 		nr_bytes -= bio_bytes;
-- 
2.44.0

