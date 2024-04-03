Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26106D1A3;
	Wed,  3 Apr 2024 08:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133775; cv=none; b=uY6+1j2lRj82MdRYdrdmetgcYG9x+mPILzeyKly+/JbXupQpJf78/y9IwQZFNTGjWeIe+z4Shmcn/cmivaY7c6lAqDPIHUfvE/cSmZ5DAVqcGlE5iPp6LE3Vy5WvGms1vLS1+FPhoWoX6OT3endehBUjPP2bXC93gd9SMD9Ppgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133775; c=relaxed/simple;
	bh=SWcDmYUAOAy6ZmoLjJbiaC3tg+KjYcY2XdCTfbTFYxE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbEFXpLJpYLZsltjvdVBT/0DjKz0+q788BITUFTBKz3FsazH9OJ0DyFyiwXtb9gr3wcJTsvPl8XcCAuRL3DUDR25GPbXiSIfg7YlYmu/ebTIzcMe649VhwHAOFDfIaHO6nHYpAfopJ0/YRavW6txqtBVasHzZlEp2dhsvP5NrBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sBJlH4ut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sBJlH4ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F66C43394;
	Wed,  3 Apr 2024 08:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133774;
	bh=SWcDmYUAOAy6ZmoLjJbiaC3tg+KjYcY2XdCTfbTFYxE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sBJlH4utc2Hf6JYDUtYZiRjMPBcF9BzbNWmky5wCcC7DfGiNWlbC5XYKsbtfT+nWj
	 lNC4knKnGeelMHJz94UCuECx1HOrmKdiyNfQTzrpWw1rjPeCvWrrKV7P3s55wW0nLs
	 1wj7fAQdRl+steRLXb1XAjqVUZwoSJNHDbrtXVQ+GturWE+BcYmuLyKINqjVoelwMa
	 MXHeGt6iqrzMN8PO27og28KzpSOoUzB/BefMJeb/ogsZDIQRUsNXLeMjOj1KIYY47k
	 kgd5NVHOiXvHwChgT/i4/XSyxzJwSvwODwvI9EY/3F0wf/8qp66vR56pnSOPJD7lKN
	 ZkQut9j5STmqQ==
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
Subject: [PATCH v5 03/28] block: Introduce blk_zone_update_request_bio()
Date: Wed,  3 Apr 2024 17:42:22 +0900
Message-ID: <20240403084247.856481-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403084247.856481-1-dlemoal@kernel.org>
References: <20240403084247.856481-1-dlemoal@kernel.org>
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

