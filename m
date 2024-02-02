Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7411802B;
	Fri,  2 Feb 2024 07:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859073; cv=none; b=ILB65XwcnPx9dtOPfNUAIl8oGnCy5WK360nGh1Fk6cBH1oDXvRBqbvee6rcHdMTPX7TohMKopLXn3ky4iioiJwxCm4moF9TxpdHfqEQVt3REOxscH+ThJCN7vQDTkNh3JwIFzsZwIMvoKkav7gCMSlMjDxvSyqDahOn8sTRzvMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859073; c=relaxed/simple;
	bh=YLN9fCoumXhnCWGV8N31+XIyEseTe3zEoh2R1Z5UBkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDaBE7GLV6duuvM3mqylBfthizzrdwzWM+ijH3PEXAnLVMQHKay35nBm0wiA6uGXeI9bgJNnH3xxc3OhZ3JOTf+mLKNW8RuSZ+bpf5BW4k6RPG6/odzVX2/SmleOrKN1Cn1DawzJjid2ENEQs9ED3Zwy1uqeCF/A94LpKvkmFT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDsQ1pwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDsQ1pwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08CEC43394;
	Fri,  2 Feb 2024 07:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859073;
	bh=YLN9fCoumXhnCWGV8N31+XIyEseTe3zEoh2R1Z5UBkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDsQ1pwfFl8y6jr3bcQYEljUr9d3tYKIdCaXpdY7A/rKZlPXUrWDzUDOsJaFsEhuV
	 Uo1M6arY1oU8rLmC9zcGQpdUeZtetxVLhFlwseG8Ge2/5OtwTRCTN5dZ/unZoKN076
	 3uMd5M+ukIxjIrbcmXr4ai35rLrzQtbo/bMbjJVwsvJGCIQypjjCw7H/OcTvAw3AVM
	 5TWCMgMKXT0k6JxhZmpYwHA0lOVMsNoSEX45RzLsqMxzZZKgcKmgS5S/lze39Bb2p5
	 Qa9LWsS8fy4ddozGeli3ZvxAYL3ksn2YacBd5xwODgdjOs06KxJCe1bgbUmEXrGVq9
	 no4nwwiiXn2wQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/26] block: Introduce blk_zone_complete_request_bio()
Date: Fri,  2 Feb 2024 16:30:42 +0900
Message-ID: <20240202073104.2418230-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
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
blk_complete_request() and in req_bio_endio(). Introduce the inline
helper function blk_zone_complete_request_bio() to avoid duplicating
this BIO update for zone append requests, and to compile out this
helper call when CONFIG_BLK_DEV_ZONED is not enabled.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-mq.c | 11 +++++------
 block/blk.h    | 19 ++++++++++++++++++-
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index bfebb8fcd248..f02e486a02ae 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -822,11 +822,11 @@ static void blk_complete_request(struct request *req)
 		/* Completion has already been traced */
 		bio_clear_flag(bio, BIO_TRACE_COMPLETION);
 
-		if (req_op(req) == REQ_OP_ZONE_APPEND)
-			bio->bi_iter.bi_sector = req->__sector;
-
-		if (!is_flush)
+		if (!is_flush) {
+			blk_zone_complete_request_bio(req, bio);
 			bio_endio(bio);
+		}
+
 		bio = next;
 	} while (bio);
 
@@ -928,8 +928,7 @@ bool blk_update_request(struct request *req, blk_status_t error,
 
 		/* Don't actually finish bio if it's part of flush sequence */
 		if (!bio->bi_iter.bi_size && !is_flush) {
-			if (req_op(req) == REQ_OP_ZONE_APPEND)
-				bio->bi_iter.bi_sector = req->__sector;
+			blk_zone_complete_request_bio(req, bio);
 			bio_endio(bio);
 		}
 
diff --git a/block/blk.h b/block/blk.h
index 913c93838a01..23f76b452e70 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -396,12 +396,29 @@ static inline struct bio *blk_queue_bounce(struct bio *bio,
 
 #ifdef CONFIG_BLK_DEV_ZONED
 void disk_free_zone_bitmaps(struct gendisk *disk);
+static inline void blk_zone_complete_request_bio(struct request *rq,
+						 struct bio *bio)
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
+static inline void blk_zone_complete_request_bio(struct request *rq,
+						 struct bio *bio)
+{
+}
 static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
 		unsigned int cmd, unsigned long arg)
 {
-- 
2.43.0

