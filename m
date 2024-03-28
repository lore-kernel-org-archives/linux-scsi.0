Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EA028DD8;
	Thu, 28 Mar 2024 00:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586660; cv=none; b=Z1oZZ+WLC6BF+xNO88iWPNXB59UBYhm6w9wBgrKK+jK6PCrJ46JKycsDl8aMmZsoxkoz3EdKWjb+fkSLRNCcXOmiA2HSywkQeLlLaGrWE0Wu9tdoyRkkzDZ2DXhqy0UVOvVtMyOB8wr7k4DwPxqZHpKLf5PxuZ6iuviReH/SeTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586660; c=relaxed/simple;
	bh=FB7w8ip95MkbH08bP0mgNxN6wWfRAQ2xFU0ZBK8h+3I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRuTAlhmKJvUcSMLSSzzqhP+HMffi5GETcV6vF6NaGVd4evo6RSg7HDptNgdqdMxWgozMWR2xLFmIvceMtO2HOlLYkQzIeQEtA/vKtenAFs5t7gj7DP4uKwpzE360cRJkE0yGqK7/+j5N1qB5QRCqyo4+Ic/sAeY67prbb8deFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BtO/9cmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BtO/9cmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B71C433F1;
	Thu, 28 Mar 2024 00:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586659;
	bh=FB7w8ip95MkbH08bP0mgNxN6wWfRAQ2xFU0ZBK8h+3I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BtO/9cmFimz3FCYrD2axBILc9HG3MplqmyMQ1E4bTfJ0cZ1AGezN2sa+wvqJ3nwhn
	 iYGjZXpfetlxp2bwcF8ygt5uB34PSNXh9cpuU1lv1sY5BNS/QNOcIZcXNOivqnR6zr
	 ABRkZCfGQ+shxX5gqO/tN9VATo0U1NFOdfZqjxl3ZUI1vWrQemDKSMD/UjRdsGuHld
	 jewCjrccqvT2m6F8x00deNHjN5nDp4OGKNZbj2Fmgvb+DWndNkFKhE1ZJP2mCZezmp
	 ZFFtCMA/SjLlRY/07YHBk/oZSv+ObpRBCGbtBjVLoJRy2x+2+qTsT4sP1hkRB0cnG3
	 YOaBYlwFiiyYw==
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
Subject: [PATCH v3 04/30] block: Introduce blk_zone_update_request_bio()
Date: Thu, 28 Mar 2024 09:43:43 +0900
Message-ID: <20240328004409.594888-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
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
---
 block/blk-mq.c | 11 +++++------
 block/blk.h    | 19 ++++++++++++++++++-
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e55af6058cbf..70dfb4af65cf 100644
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
 
@@ -923,8 +923,7 @@ bool blk_update_request(struct request *req, blk_status_t error,
 
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

