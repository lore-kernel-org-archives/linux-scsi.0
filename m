Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9FE84A43;
	Tue,  2 Apr 2024 12:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061564; cv=none; b=p+8ij1SvSvrookpy/Kopf7UCox1Frf2wGKr0td9tlUWDLdjcW0/pygUifA43xDULRdk4Rzw1xzpQI0uizy0zaezAVc6pNwR1adPDvP7gXkg+vje3ZQhMz26NOUvmwuWMjjfmPOPIvIlrK6yhjVG+EFwy6ziuiZ5v5oP/5Xth+uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061564; c=relaxed/simple;
	bh=ijfr4oFeWLkG2a4i7/8+H0TssTdkuSm/CuJDbfGYjaw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jb/zS0DYwQ0kTBszKp3Yi6rlFZqH1spGl7wVfbHjla4HKvaEss/9y+Q0x8O6w3Q5Kqv7ZiHUzV4EPMWa7LksR6ijDShVQ3Y4JzirwqwJnImYAUuHk89+yS88h1NvPBFw8GW5TFQhMOtfazs8kpyM0NccAs9G66QNMEJ6Smfok30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMfihjDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMfihjDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CE7C433F1;
	Tue,  2 Apr 2024 12:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061564;
	bh=ijfr4oFeWLkG2a4i7/8+H0TssTdkuSm/CuJDbfGYjaw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vMfihjDu+X97+YPcbXDQjNsoU0wOsyOXv5q9Pg7sWC1oe4pRAg9Q+nJyXoqK1bhHh
	 qnsdxtfTTzbwWLlxwgaztSQviFHs6PrV3bwfcjc7Z5LO6e03QqjvbF4sVX+ddxv+ZK
	 f6cP91L3hHfN/ACSd5FdJYxdonp9sTyjxOyrxcvtr72Oq23ajMJczzojjDT01F5/F9
	 e4Z2sLP2nCyKAxpWr3QOGi7LUmkbTRSKY1pfUiTJlB5ovt3TyJjRzl2EDQ28AdkhcS
	 0QUv7tl9dytmgQ4FHlL1kgKacPoWIyKx1BtYYQptiaE346DQu2c84mORr32IwQjWo/
	 1TRi6jfmThAsw==
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
Subject: [PATCH v4 10/28] block: Implement zone append emulation
Date: Tue,  2 Apr 2024 21:38:49 +0900
Message-ID: <20240402123907.512027-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240402123907.512027-1-dlemoal@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
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
---
 block/blk-mq.c            |  3 +-
 block/blk-zoned.c         | 69 +++++++++++++++++++++++++++++++--------
 block/blk.h               | 14 ++++++--
 include/linux/blk_types.h |  1 +
 4 files changed, 69 insertions(+), 18 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 73f2ca7c738d..e09c23760bea 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -907,8 +907,7 @@ bool blk_update_request(struct request *req, blk_status_t error,
 
 		if (bio_bytes == bio->bi_iter.bi_size) {
 			req->bio = bio->bi_next;
-		} else if (req_op(req) == REQ_OP_ZONE_APPEND &&
-			   error == BLK_STS_OK) {
+		} else if (bio_is_zone_append(bio) && error == BLK_STS_OK) {
 			/*
 			 * Partial zone append completions cannot be supported
 			 * as the BIO fragments may end up not being written
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 10c713aa9507..71d692d9d851 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -730,7 +730,8 @@ static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
 
 	while ((bio = bio_list_pop(&zwplug->bio_list))) {
 		if (wp_offset >= zone_capacity ||
-		     bio_offset_from_zone_start(bio) != wp_offset) {
+		    (bio_op(bio) != REQ_OP_ZONE_APPEND &&
+		     bio_offset_from_zone_start(bio) != wp_offset)) {
 			blk_zone_wplug_bio_io_error(bio);
 			disk_put_zone_wplug(zwplug);
 			continue;
@@ -986,7 +987,8 @@ static inline void disk_zone_wplug_set_error(struct gendisk *disk,
 
 /*
  * Check and prepare a BIO for submission by incrementing the write pointer
- * offset of its zone write plug.
+ * offset of its zone write plug and changing zone append operations into
+ * regular write when zone append emulation is needed.
  */
 static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
 				       struct bio *bio)
@@ -1001,13 +1003,30 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
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
@@ -1040,8 +1059,14 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
 	}
 
 	/* Conventional zones do not need write plugging. */
-	if (bio_zone_is_conv(bio))
+	if (bio_zone_is_conv(bio)) {
+		/* Zone append to conventional zones is not allowed. */
+		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
+			bio_io_error(bio);
+			return true;
+		}
 		return false;
+	}
 
 	zwplug = bio_get_and_lock_zone_wplug(bio, &flags);
 	if (!zwplug) {
@@ -1086,10 +1111,10 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
  * @bio: The BIO being submitted
  * @nr_segs: The number of physical segments of @bio
  *
- * Handle write and write zeroes operations using zone write plugging.
- * Return true whenever @bio execution needs to be delayed through the zone
- * write plug. Otherwise, return false to let the submission path process
- * @bio normally.
+ * Handle write, write zeroes and zone append operations requiring emulation
+ * using zone write plugging. Return true whenever @bio execution needs to be
+ * delayed through the zone write plug. Otherwise, return false to let the
+ * submission path process @bio normally.
  */
 bool blk_zone_write_plug_bio(struct bio *bio, unsigned int nr_segs)
 {
@@ -1124,6 +1149,9 @@ bool blk_zone_write_plug_bio(struct bio *bio, unsigned int nr_segs)
 	 * machinery operates at the request level, below the plug, and
 	 * completion of the flush sequence will go through the regular BIO
 	 * completion, which will handle zone write plugging.
+	 * Zone append operations for devices that requested emulation must
+	 * also be plugged so that these BIOs can be changed into regular
+	 * write BIOs.
 	 * Zone reset, reset all and finish commands need special treatment
 	 * to correctly track the write pointer offset of zones. These commands
 	 * are not plugged as we do not need serialization with write
@@ -1131,6 +1159,10 @@ bool blk_zone_write_plug_bio(struct bio *bio, unsigned int nr_segs)
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
@@ -1194,6 +1226,15 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
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
index 833ba8a74be9..119c3f2593d9 100644
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
@@ -453,6 +459,10 @@ static inline bool bio_zone_write_plugging(struct bio *bio)
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

