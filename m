Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0A95244;
	Mon,  8 Apr 2024 01:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540497; cv=none; b=RL0kPHyJ46zy+gMrH7JvvyllxoUl+lYhCyopd4iPrGL+eDXgZpMdx1+ZoqAbYIJ/LXGR+K92n5Bo5yM5tMD/WUDcyBYDXiPAmpS5EzVijRAKY9WwoYkXQSdLKf2x+f8PBcUvroUv2dX5Lb9jJwy+jQQrc6UMgyLn+PJmnumhO0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540497; c=relaxed/simple;
	bh=XQ/FNxqBFsNDlzV6H2tAFcwOhY/mOWu7k7PYStCXqLo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+3DdWis1hes6VnSY4XhbQs2hNMReGJl+4GQRmFCoDsx/0pzGj3a9rqBLRYHfXO4sFXN5dbOZ2sj/4zK1rKlLLci5iHeFPQ3+dB/EAg45BbWqnyNq0DkMaqQtKUFjGlLOmECSTna6wsfO2a9LBdof9/gT+MNUsjqy1aTVFfqABQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHJHrTLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHJHrTLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23955C433C7;
	Mon,  8 Apr 2024 01:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540496;
	bh=XQ/FNxqBFsNDlzV6H2tAFcwOhY/mOWu7k7PYStCXqLo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UHJHrTLCbfLA/GmpvVLdUTRbDEjnwt2qA3rgk3U/Px6Q/SvVwaUmw4FyiNKOuV3Pe
	 PBD8/G2VwKZmxpXW6IL6d6QmOwQ41flmIS/mQzn3ajQoJs6+XxVolcACr7ArISDx3K
	 Ou+gq4qQM9D8JYfdzk34gfu4k055sNm2KVuNL8XKNQiDdx5boWRljB4ruLqD2EPX+S
	 R8VtOQsMDMUQRsGdQlaK4FqSB1Bs602qX/k2EnWR1dXsgkH1Rsf3ccBjL7jnf62w5J
	 KTDOv0lLMrWRe5KwJqCO1d0X1hTXIAlCusj67MEExbxvzJZp68hP0xIMwvc2gBK84P
	 BO2XtFjz1wojg==
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
Subject: [PATCH v7 03/28] block: Introduce blk_zone_update_request_bio()
Date: Mon,  8 Apr 2024 10:41:03 +0900
Message-ID: <20240408014128.205141-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408014128.205141-1-dlemoal@kernel.org>
References: <20240408014128.205141-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On completion of a zone append request, the request sector indicates the
location of the written data. This value must be returned to the user
through the BIO iter sector. This is done in 2 places: in
blk_complete_request() and in blk_update_request(). Introduce the inline
helper function blk_zone_update_request_bio() to avoid duplicating
this BIO update for zone append requests, and to compile out this
helper call when CONFIG_BLK_DEV_ZONED is not enabled.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-mq.c | 11 +++++------
 block/blk.h    | 19 ++++++++++++++++++-
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index fcbf0953a179..88b541e8873f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -821,8 +821,7 @@ static void blk_complete_request(struct request *req)
 		/* Completion has already been traced */
 		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
 
-		if (req_op(req) == REQ_OP_ZONE_APPEND)
-			bio->bi_iter.bi_sector = req->__sector;
+		blk_zone_update_request_bio(req, bio);
 
 		if (!is_flush)
 			bio_endio(bio);
@@ -923,10 +922,10 @@ bool blk_update_request(struct request *req, blk_status_t error,
 		bio_advance(bio, bio_bytes);
 
 		/* Don't actually finish bio if it's part of flush sequence */
-		if (!bio->bi_iter.bi_size && !is_flush) {
-			if (req_op(req) == REQ_OP_ZONE_APPEND)
-				bio->bi_iter.bi_sector = req->__sector;
-			bio_endio(bio);
+		if (!bio->bi_iter.bi_size) {
+			blk_zone_update_request_bio(req, bio);
+			if (!is_flush)
+				bio_endio(bio);
 		}
 
 		total_bytes += bio_bytes;
diff --git a/block/blk.h b/block/blk.h
index d9f584984bc4..17786052f32d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -408,12 +408,29 @@ static inline struct bio *blk_queue_bounce(struct bio *bio,
 
 #ifdef CONFIG_BLK_DEV_ZONED
 void disk_free_zone_bitmaps(struct gendisk *disk);
+static inline void blk_zone_update_request_bio(struct request *rq,
+					       struct bio *bio)
+{
+	/*
+	 * For zone append requests, the request sector indicates the location
+	 * at which the BIO data was written. Return this value to the BIO
+	 * issuer through the BIO iter sector.
+	 */
+	if (req_op(rq) == REQ_OP_ZONE_APPEND)
+		bio->bi_iter.bi_sector = rq->__sector;
+}
 int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
 		unsigned long arg);
 int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg);
 #else /* CONFIG_BLK_DEV_ZONED */
-static inline void disk_free_zone_bitmaps(struct gendisk *disk) {}
+static inline void disk_free_zone_bitmaps(struct gendisk *disk)
+{
+}
+static inline void blk_zone_update_request_bio(struct request *rq,
+					       struct bio *bio)
+{
+}
 static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
 		unsigned int cmd, unsigned long arg)
 {
-- 
2.44.0

