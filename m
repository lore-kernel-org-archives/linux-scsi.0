Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18292C198;
	Fri,  5 Apr 2024 04:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292144; cv=none; b=pm33iY/xR4VIqMVOij/3y5/lLjcoCXPGhtr4p+XVJfvMfu3OW5ulm3qyhRNRqfRfoTF9/tBsdImsOOC+NE2n6MlXAsHRG88K74e0NhzaQG6ziLVhN9Ax3MgkuslTgOzqA3rkE72omPi+xhdTmOaWYod7iQAweer7Iu4dORTebic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292144; c=relaxed/simple;
	bh=dSSv2zgeaCZbKjEiKOh4pzUsXRGPAAbdvpnki+zQ0Ik=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luIJwYUGRBMnM5l8OuaZnnXaf3Od0KqU9NRHYyENNL6Zuf4lf+KAhlE2XyS9EAXzeM2kKD/PMDamnzjfe/AHifuXAZ6zu8UCpHPc2lL9L8VXPARgYMTvpCxV1W6AhrJ1Ic6hcnTvM6dcwGRpkyqn63DZ2qRjVL1SF5mAGh8C9K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTR/LagG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTR/LagG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A64C43394;
	Fri,  5 Apr 2024 04:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292144;
	bh=dSSv2zgeaCZbKjEiKOh4pzUsXRGPAAbdvpnki+zQ0Ik=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WTR/LagGFFGzLGbreMXxbC+MQKsQiik6lBm7hp+QxVgL8YLEdQCVYciwm9Sfcm4xf
	 neFpY7K1rjOO143weiKrdIezIrtuJTaS4gvtMVrl9bthLnKMxbXCTJZuD2Hu47BNpe
	 SdC+jQ6OFFbxWqso8cZm6qAdW+t2LW67b2rKfEXWojrjOZl+vuGffxwya1XRnaQBwU
	 l2xMa8ocU2an+0FEtnb29KxToCgf0ulNX/HE1vicH6VX4BZyvL99pIqv12qtcQjheL
	 9q0WSMVL1hQtzZYRNO/FdeoizGjOdqewTtqruasNlK8kLe1/XzkYd6RqDO/TYR0N6v
	 lm0Mk1ZULNqYQ==
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
Subject: [PATCH v6 10/28] block: Implement zone append emulation
Date: Fri,  5 Apr 2024 13:41:49 +0900
Message-ID: <20240405044207.1123462-11-dlemoal@kernel.org>
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

Given that zone write plugging manages all writes to zones of a zoned
block device and tracks the write pointer position of all zones that are
not full nor empty, emulating zone append operations using regular
writes can be implemented generically, without relying on the underlying
device driver to implement such emulation. This is needed for devices
that do not natively support the zone append command (e.g. SMR
hard-disks).

A device may request zone append emulation by setting its
max_zone_append_sectors queue limit to 0. For such device, the function
blk_zone_wplug_prepare_bio() changes zone append BIOs into
non-mergeable regular write BIOs. Modified zone append BIOs are flagged
with the new BIO flag BIO_EMULATES_ZONE_APPEND. This flag is checked
on completion of the BIO in blk_zone_write_plug_bio_endio() to restore
the original REQ_OP_ZONE_APPEND operation code of the BIO.

The block layer internal inline helper function bio_is_zone_append() is
added to test if a BIO is either a native zone append operation
(REQ_OP_ZONE_APPEND operation code) or if it is flagged with
BIO_EMULATES_ZONE_APPEND. Given that both native and emulated zone
append BIO completion handling should be similar, The functions
blk_update_request() and blk_zone_complete_request_bio() are modified to
use bio_is_zone_append() to execute blk_zone_update_request_bio() for
both native and emulated zone append operations.

This commit contains contributions from Christoph Hellwig <hch@lst.de>.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 block/blk-mq.c            |  3 +-
 block/blk-zoned.c         | 64 ++++++++++++++++++++++++++++++++-------
 block/blk.h               | 14 +++++++--
 include/linux/blk_types.h |  1 +
 4 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 48eb7dd049d1..6f9cc1c4d4fb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -906,8 +906,7 @@ bool blk_update_request(struct request *req, blk_status_t error,
 
 		if (bio_bytes == bio->bi_iter.bi_size) {
 			req->bio = bio->bi_next;
-		} else if (req_op(req) == REQ_OP_ZONE_APPEND &&
-			   error == BLK_STS_OK) {
+		} else if (bio_is_zone_append(bio) && error == BLK_STS_OK) {
 			/*
 			 * Partial zone append completions cannot be supported
 			 * as the BIO fragments may end up not being written
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index fcc1284b7c19..a60ac5b3e637 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -689,7 +689,8 @@ static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
 
 	while ((bio = bio_list_pop(&zwplug->bio_list))) {
 		if (wp_offset >= zone_capacity ||
-		     bio_offset_from_zone_start(bio) != wp_offset) {
+		    (bio_op(bio) != REQ_OP_ZONE_APPEND &&
+		     bio_offset_from_zone_start(bio) != wp_offset)) {
 			blk_zone_wplug_bio_io_error(bio);
 			disk_put_zone_wplug(zwplug);
 			continue;
@@ -951,7 +952,8 @@ static inline void disk_zone_wplug_set_error(struct gendisk *disk,
 
 /*
  * Check and prepare a BIO for submission by incrementing the write pointer
- * offset of its zone write plug.
+ * offset of its zone write plug and changing zone append operations into
+ * regular write when zone append emulation is needed.
  */
 static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
 				       struct bio *bio)
@@ -966,13 +968,30 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
 	if (zwplug->wp_offset >= disk->zone_capacity)
 		goto err;
 
-	/*
-	 * Check for non-sequential writes early because we avoid a
-	 * whole lot of error handling trouble if we don't send it off
-	 * to the driver.
-	 */
-	if (bio_offset_from_zone_start(bio) != zwplug->wp_offset)
-		goto err;
+	if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
+		/*
+		 * Use a regular write starting at the current write pointer.
+		 * Similarly to native zone append operations, do not allow
+		 * merging.
+		 */
+		bio->bi_opf &= ~REQ_OP_MASK;
+		bio->bi_opf |= REQ_OP_WRITE | REQ_NOMERGE;
+		bio->bi_iter.bi_sector += zwplug->wp_offset;
+
+		/*
+		 * Remember that this BIO is in fact a zone append operation
+		 * so that we can restore its operation code on completion.
+		 */
+		bio_set_flag(bio, BIO_EMULATES_ZONE_APPEND);
+	} else {
+		/*
+		 * Check for non-sequential writes early because we avoid a
+		 * whole lot of error handling trouble if we don't send it off
+		 * to the driver.
+		 */
+		if (bio_offset_from_zone_start(bio) != zwplug->wp_offset)
+			goto err;
+	}
 
 	/* Advance the zone write pointer offset. */
 	zwplug->wp_offset += bio_sectors(bio);
@@ -1008,8 +1027,14 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
 	}
 
 	/* Conventional zones do not need write plugging. */
-	if (disk_zone_is_conv(disk, sector))
+	if (disk_zone_is_conv(disk, sector)) {
+		/* Zone append to conventional zones is not allowed. */
+		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
+			bio_io_error(bio);
+			return true;
+		}
 		return false;
+	}
 
 	if (bio->bi_opf & REQ_NOWAIT)
 		gfp_mask = GFP_NOWAIT;
@@ -1057,7 +1082,8 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
  * @bio: The BIO being submitted
  * @nr_segs: The number of physical segments of @bio
  *
- * Handle write and write zeroes operations using zone write plugging.
+ * Handle write, write zeroes and zone append operations requiring emulation
+ * using zone write plugging.
  *
  * Return true whenever @bio execution needs to be delayed through the zone
  * write plug. Otherwise, return false to let the submission path process
@@ -1096,6 +1122,9 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
 	 * machinery operates at the request level, below the plug, and
 	 * completion of the flush sequence will go through the regular BIO
 	 * completion, which will handle zone write plugging.
+	 * Zone append operations for devices that requested emulation must
+	 * also be plugged so that these BIOs can be changed into regular
+	 * write BIOs.
 	 * Zone reset, reset all and finish commands need special treatment
 	 * to correctly track the write pointer offset of zones. These commands
 	 * are not plugged as we do not need serialization with write
@@ -1103,6 +1132,10 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
 	 * and finish commands when write operations are in flight.
 	 */
 	switch (bio_op(bio)) {
+	case REQ_OP_ZONE_APPEND:
+		if (!bdev_emulates_zone_append(bdev))
+			return false;
+		fallthrough;
 	case REQ_OP_WRITE:
 	case REQ_OP_WRITE_ZEROES:
 		return blk_zone_wplug_handle_write(bio, nr_segs);
@@ -1171,6 +1204,15 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 	/* Make sure we do not see this BIO again by clearing the plug flag. */
 	bio_clear_flag(bio, BIO_ZONE_WRITE_PLUGGING);
 
+	/*
+	 * If this is a regular write emulating a zone append operation,
+	 * restore the original operation code.
+	 */
+	if (bio_flagged(bio, BIO_EMULATES_ZONE_APPEND)) {
+		bio->bi_opf &= ~REQ_OP_MASK;
+		bio->bi_opf |= REQ_OP_ZONE_APPEND;
+	}
+
 	/*
 	 * If the BIO failed, mark the plug as having an error to trigger
 	 * recovery.
diff --git a/block/blk.h b/block/blk.h
index 4df969f8fa28..1140c4a0be03 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -421,6 +421,11 @@ static inline bool bio_zone_write_plugging(struct bio *bio)
 {
 	return bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING);
 }
+static inline bool bio_is_zone_append(struct bio *bio)
+{
+	return bio_op(bio) == REQ_OP_ZONE_APPEND ||
+		bio_flagged(bio, BIO_EMULATES_ZONE_APPEND);
+}
 void blk_zone_write_plug_bio_merged(struct bio *bio);
 void blk_zone_write_plug_attempt_merge(struct request *rq);
 static inline void blk_zone_update_request_bio(struct request *rq,
@@ -430,8 +435,9 @@ static inline void blk_zone_update_request_bio(struct request *rq,
 	 * For zone append requests, the request sector indicates the location
 	 * at which the BIO data was written. Return this value to the BIO
 	 * issuer through the BIO iter sector.
-	 * For plugged zone writes, we need the original BIO sector so
-	 * that blk_zone_write_plug_bio_endio() can lookup the zone write plug.
+	 * For plugged zone writes, which include emulated zone append, we need
+	 * the original BIO sector so that blk_zone_write_plug_bio_endio() can
+	 * lookup the zone write plug.
 	 */
 	if (req_op(rq) == REQ_OP_ZONE_APPEND || bio_zone_write_plugging(bio))
 		bio->bi_iter.bi_sector = rq->__sector;
@@ -468,6 +474,10 @@ static inline bool bio_zone_write_plugging(struct bio *bio)
 {
 	return false;
 }
+static inline bool bio_is_zone_append(struct bio *bio)
+{
+	return false;
+}
 static inline void blk_zone_write_plug_bio_merged(struct bio *bio)
 {
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ed45de07d2ef..29b3170431e7 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -311,6 +311,7 @@ enum {
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
+	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
 	BIO_FLAG_LAST
 };
 
-- 
2.44.0

