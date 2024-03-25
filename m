Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F121D1C321F;
	Mon, 25 Mar 2024 04:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341900; cv=none; b=NkS50Am0+BflvoaagsBuMNvW+5w+2nn65N7uj9qMADs686xcAEkutlMBv9BU2/fVfsch+c7N9gBC+/5kl28NdC8ptDE/jjfC9dcJSxQdGFyHNp2DqFYXMHcLKUNFDhIEDgTy70k12mikPHWLEAB1eMfEvnX1Ggyo4aSddilvXhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341900; c=relaxed/simple;
	bh=wVV0K4pgInzHyMFWF+DaOk+dVArB5rNZHyyPh1Y8kjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qg3/3GKO2qLwaC/rojdG3o8JJ87aIg0Xg5bi/CQ7MRHJ+k948CFlQLRmTB4hUtGDNj5SB0GRyEg7yhRGCpXNIWQHhnofLu3Q4mbE4zel0WnhdjfBqCKKAPMOLLOldSeIchajHWjO4gSATY5w0h7mCXmS9E9aj287wvTAjETbHgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1hqJ6XC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1hqJ6XC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46FFC43394;
	Mon, 25 Mar 2024 04:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341899;
	bh=wVV0K4pgInzHyMFWF+DaOk+dVArB5rNZHyyPh1Y8kjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1hqJ6XCEgLcjch9XsKvOATmUsH9/Mp5zx7PYaP2BBzkXRaOfpCjLlpq2qls4CWSq
	 j8mNTNg7drh35BdsdN5Fyl7KdXLdKStoX+lbKUUNeNGINLQ3is/erc29zBAaoeUjaG
	 xox+0kGFT5BLgQV2DXjUpLeS7fh/zPzxzWK108IC3jvolTIQnqEgFmTLxgEs1mL4MN
	 KT1DOEX2mrnGGJUBnIYUMPyJcnWQRbcFvKtQ+M5mhL33ZihdUm6I6H0ycC+gMhKgZG
	 tRNFiqZJKeXRgFV6Kgeegz50t+fSge03qcn1cbnZv5Suj5Yw0K8m5EpdG0QihAzsx9
	 rwq/uoPAC6/Kg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 03/28] block: Introduce blk_zone_update_request_bio()
Date: Mon, 25 Mar 2024 13:44:27 +0900
Message-ID: <20240325044452.3125418-4-dlemoal@kernel.org>
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

On completion of a zone append request, the request sector indicates the
location of the written data. This value must be returned to the user
through the BIO iter sector. This is done in 2 places: in
blk_complete_request() and in blk_update_request(). Introduce the inline
helper function blk_zone_update_request_bio() to avoid duplicating
this BIO update for zone append requests, and to compile out this
helper call when CONFIG_BLK_DEV_ZONED is not enabled.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-mq.c | 11 +++++------
 block/blk.h    | 19 ++++++++++++++++++-
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8aeb8e96f1a7..9e6e2a9a147c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -820,11 +820,11 @@ static void blk_complete_request(struct request *req)
 		/* Completion has already been traced */
 		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
 
-		if (req_op(req) == REQ_OP_ZONE_APPEND)
-			bio->bi_iter.bi_sector = req->__sector;
-
-		if (!is_flush)
+		if (!is_flush) {
+			blk_zone_update_request_bio(req, bio);
 			bio_endio(bio);
+		}
+
 		bio = next;
 	} while (bio);
 
@@ -926,8 +926,7 @@ bool blk_update_request(struct request *req, blk_status_t error,
 
 		/* Don't actually finish bio if it's part of flush sequence */
 		if (!bio->bi_iter.bi_size && !is_flush) {
-			if (req_op(req) == REQ_OP_ZONE_APPEND)
-				bio->bi_iter.bi_sector = req->__sector;
+			blk_zone_update_request_bio(req, bio);
 			bio_endio(bio);
 		}
 
diff --git a/block/blk.h b/block/blk.h
index 5cac4e29ae17..a12cde1d45de 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -409,12 +409,29 @@ static inline struct bio *blk_queue_bounce(struct bio *bio,
 
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

