From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH 4/9] block: Define zoned block device operations
Date: Tue, 20 Sep 2016 06:27:29 +0900
Message-ID: <1474320454-5264-5-git-send-email-damien.lemoal@hgst.com>
References: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de, shaun.tancheff@seagate.com, Damien Le Moal <damien.lemoal@hgst.com>
List-Id: linux-scsi@vger.kernel.org

From: Shaun Tancheff <shaun.tancheff@seagate.com>

Define REQ_OP_ZONE_REPORT, REQ_OP_ZONE_RESET, REQ_OP_ZONE_OPEN,
REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH for handling zones of
zoned block devices (host-managed and host-aware). With with these
new commands, the total number of operations defined reaches 11 and
requires increasing REQ_OP_BITS from 3 to 4.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>

Changelog (Damien):
All requests have no payload and may operate on all zones of the
device (when the BIO sector and size are 0) or on a single zone
(when the BIO sector and size are aigned on a zone).

REQ_OP_ZONE_REPORT is not sent directly to the device
and is processed in sd_zbc.c using the device zone work
in order to parse the report reply and manage changes to
the zone information cache of the device.

Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 block/blk-core.c          |  7 +++++++
 block/blk-merge.c         | 31 +++++++++++++++++++++++++++----
 include/linux/bio.h       | 36 +++++++++++++++++++++++++++---------
 include/linux/blk_types.h | 27 ++++++++++++++++++++++++++-
 4 files changed, 87 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 36c7ac3..4a7f7ba 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1941,6 +1941,13 @@ generic_make_request_checks(struct bio *bio)
 	case REQ_OP_WRITE_SAME:
 		if (!bdev_write_same(bio->bi_bdev))
 			goto not_supported;
+	case REQ_OP_ZONE_REPORT:
+	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
+		if (!bdev_zoned(bio->bi_bdev))
+			goto not_supported;
 		break;
 	default:
 		break;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2642e5f..f9299df 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -202,6 +202,21 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
 	case REQ_OP_WRITE_SAME:
 		split = blk_bio_write_same_split(q, *bio, bs, &nsegs);
 		break;
+	case REQ_OP_ZONE_REPORT:
+	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
+		/*
+		 * For these commands, bi_size is either 0 to specify
+		 * operation on the entire block device sector range,
+		 * or a zone size for operation on a single zone.
+		 * Since a zone size may be much bigger than the maximum
+		 * allowed BIO size, we cannot use blk_bio_segment_split.
+		 */
+		split = NULL;
+		nsegs = 0;
+		break;
 	default:
 		split = blk_bio_segment_split(q, *bio, q->bio_split, &nsegs);
 		break;
@@ -241,11 +256,19 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	 * This should probably be returning 0, but blk_add_request_payload()
 	 * (Christoph!!!!)
 	 */
-	if (bio_op(bio) == REQ_OP_DISCARD || bio_op(bio) == REQ_OP_SECURE_ERASE)
-		return 1;
-
-	if (bio_op(bio) == REQ_OP_WRITE_SAME)
+	switch(bio_op(bio)) {
+	case REQ_OP_DISCARD:
+	case REQ_OP_SECURE_ERASE:
+	case REQ_OP_WRITE_SAME:
+	case REQ_OP_ZONE_REPORT:
+	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
 		return 1;
+	default:
+		break;
+	}
 
 	fbio = bio;
 	cluster = blk_queue_cluster(q);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 23ddf4b..d9c2e21 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -69,20 +69,38 @@
  */
 static inline bool bio_has_data(struct bio *bio)
 {
-	if (bio &&
-	    bio->bi_iter.bi_size &&
-	    bio_op(bio) != REQ_OP_DISCARD &&
-	    bio_op(bio) != REQ_OP_SECURE_ERASE)
-		return true;
+	if (!bio || !bio->bi_iter.bi_size)
+		return false;
 
-	return false;
+	switch (bio_op(bio)) {
+	case REQ_OP_DISCARD:
+	case REQ_OP_SECURE_ERASE:
+	case REQ_OP_ZONE_REPORT:
+	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
+		return false;
+	default:
+		return true;
+	}
 }
 
 static inline bool bio_no_advance_iter(struct bio *bio)
 {
-	return bio_op(bio) == REQ_OP_DISCARD ||
-	       bio_op(bio) == REQ_OP_SECURE_ERASE ||
-	       bio_op(bio) == REQ_OP_WRITE_SAME;
+	switch (bio_op(bio)) {
+	case REQ_OP_DISCARD:
+	case REQ_OP_SECURE_ERASE:
+	case REQ_OP_WRITE_SAME:
+	case REQ_OP_ZONE_REPORT:
+	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
+		return true;
+	default:
+		return false;
+	}
 }
 
 static inline bool bio_is_rw(struct bio *bio)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 436f43f..70df996 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -229,6 +229,26 @@ enum rq_flag_bits {
 #define REQ_HASHED		(1ULL << __REQ_HASHED)
 #define REQ_MQ_INFLIGHT		(1ULL << __REQ_MQ_INFLIGHT)
 
+/*
+ * Note on zone operations:
+ * All REQ_OP_ZONE_* commands do not have a payload and share a common
+ * interface for specifying operation range:
+ * (1) bio->bi_iter.bi_sector and bio->bi_iter.bi_size set to 0:
+ *     the command is to operate on ALL zones of the device.
+ * (2) bio->bi_iter.bi_sector is set to a zone start sector and
+ *     bio->bi_iter.bi_size is set to the zone size in bytes:
+ *     the command is to operate on only the specified zone.
+ * Operation:
+ * REQ_OP_ZONE_REPORT: Request information for all zones or for a single zone.
+ * REQ_OP_ZONE_RESET: Reset the write pointer of all zones or of a single zone.
+ * REQ_OP_ZONE_OPEN: Explicitely open the maximum allowed number of zones or
+ *                   a single zone. For the former case, the zones that will
+ *                   actually be open are chosen by the disk.
+ * REQ_OP_ZONE_CLOSE: Close all implicitely or explicitely open zones or
+ *                    a single zone.
+ * REQ_OP_ZONE_FINISH: Transition one or all open and closed zones to the full
+ *                     condition.
+ */
 enum req_op {
 	REQ_OP_READ,
 	REQ_OP_WRITE,
@@ -236,9 +256,14 @@ enum req_op {
 	REQ_OP_SECURE_ERASE,	/* request to securely erase sectors */
 	REQ_OP_WRITE_SAME,	/* write same block many times */
 	REQ_OP_FLUSH,		/* request for cache flush */
+	REQ_OP_ZONE_REPORT,	/* Get zone information */
+	REQ_OP_ZONE_RESET,	/* Reset a zone write pointer */
+	REQ_OP_ZONE_OPEN,	/* Explicitely open a zone */
+	REQ_OP_ZONE_CLOSE,	/* Close an open zone */
+	REQ_OP_ZONE_FINISH,	/* Finish a zone */
 };
 
-#define REQ_OP_BITS 3
+#define REQ_OP_BITS 4
 
 typedef unsigned int blk_qc_t;
 #define BLK_QC_T_NONE	-1U
-- 
2.7.4

