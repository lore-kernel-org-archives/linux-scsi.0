Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B7C224CC;
	Fri,  5 Apr 2024 04:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292133; cv=none; b=eeGFje9/MDGhmnwEAemM7lriOQcBfEsPu+UE0lwSinXtHuY4xPtJ+DoglS1cXWiSh8WcYolpgYFNgM4PoU94n5YAXqFAnySpXZMDvPfcLs6hwTLbiAPF4xfpyCjZlh1lAl9otshIPIPuzWOpj2+7s7fLpk7/GTZSyIKHFOkruIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292133; c=relaxed/simple;
	bh=CdmylnpKWrXAGZzcENcMnSOFl45wLma7IJdIjVP9Y6w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdJkTC1UeSWWU+Jir6SjZqcImQtKY2rJkJbkpL352FZptecaBzp+k6Y1nHMf+X0d4bZoPPJiv17fMWGxT50O6ZCLl3vIL8qh7xaCzfmvC1mU3Ie1zfgOtyn2lP16ffO3sp3avjiK27ndLZ66ydTA8ib7f5CEYZ9EulThUYoXno4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeJ+l0Cw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeJ+l0Cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E6EC433B1;
	Fri,  5 Apr 2024 04:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292132;
	bh=CdmylnpKWrXAGZzcENcMnSOFl45wLma7IJdIjVP9Y6w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eeJ+l0Cw1jZsFML0BRUJgtHMGJGmyqmmAP7JTRjGmQ6NsaBxp5dYGUOL/d5YsLcYm
	 iLOVQzZoWVaLZ0KgpDqnWxH0/coTO3DnSWPQBI/EpFDM3+myXcqZBcs3MsKUe7cNk7
	 seBUieHIKoIFRoxtf4083d77N4dX+2jLb3VzJJmn3HSqh/yA8/LYZj02zFIOOqokwQ
	 2djg/xvKIikb0FbTySRCyc+NGFh9n21YnT5CxIsPwhg+gRRo4OvG7XcvuUNWYO7hYq
	 gpBRwi/SyIcbMrIR3LFTfRmzmczvB3Jp4SNCAdwpfQW+KxpPMXWWLg1v0jlbe4yBTz
	 hP+/23BhPzEHA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 02/28] block: Remove req_bio_endio()
Date: Fri,  5 Apr 2024 13:41:41 +0900
Message-ID: <20240405044207.1123462-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 block/blk-mq.c | 58 ++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b8dbfed8b28b..fcbf0953a179 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -762,31 +762,6 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
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
-		 */
-		if (bio->bi_iter.bi_size != nbytes)
-			bio->bi_status = BLK_STS_IOERR;
-		else
-			bio->bi_iter.bi_sector = rq->__sector;
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
@@ -890,6 +865,8 @@ static void blk_complete_request(struct request *req)
 bool blk_update_request(struct request *req, blk_status_t error,
 		unsigned int nr_bytes)
 {
+	bool is_flush = req->rq_flags & RQF_FLUSH_SEQ;
+	bool quiet = req->rq_flags & RQF_QUIET;
 	int total_bytes;
 
 	trace_block_rq_complete(req, error, nr_bytes);
@@ -910,9 +887,8 @@ bool blk_update_request(struct request *req, blk_status_t error,
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
@@ -924,12 +900,34 @@ bool blk_update_request(struct request *req, blk_status_t error,
 		struct bio *bio = req->bio;
 		unsigned bio_bytes = min(bio->bi_iter.bi_size, nr_bytes);
 
-		if (bio_bytes == bio->bi_iter.bi_size)
+		if (unlikely(error))
+			bio->bi_status = error;
+
+		if (bio_bytes == bio->bi_iter.bi_size) {
 			req->bio = bio->bi_next;
+		} else if (req_op(req) == REQ_OP_ZONE_APPEND &&
+			   error == BLK_STS_OK) {
+			/*
+			 * Partial zone append completions cannot be supported
+			 * as the BIO fragments may end up not being written
+			 * sequentially.
+			 */
+			bio->bi_status = BLK_STS_IOERR;
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

