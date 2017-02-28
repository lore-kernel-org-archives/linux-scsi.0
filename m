From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/3] block: Introduce blk_rq_accesses_medium()
Date: Tue, 28 Feb 2017 19:25:33 +0900
Message-ID: <20170228102535.15966-2-damien.lemoal@wdc.com>
References: <20170228102535.15966-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170228102535.15966-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bart.vanassche@sandisk.com>

A medium access request is defined as an internal regular request that
operates on a whole number of logical blocks of the storage medium.
These include REQ_OP_READ, REQ_OP_WRITE, REQ_OP_FLUSH, REQ_OP_DISCARD,
REQ_OP_SECURE_ERASE, REQ_OP_WRITE_SAME and REQ_OP_WRITE_ZEROES.

Zoned block device requests (REQ_OP_ZONE_REPORT and REQ_OP_ZONE_RESET)
as well as SCSI passthrough and driver private commands are not
considered medium access request.

Reshuffle enum req_opf definitions grouping medium access request up
to REQ_OP_MEDIUM_LAST and introduce the helper function
blk_rq_accesses_medium() to test a request.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 include/linux/blk_types.h | 17 ++++++++++-------
 include/linux/blkdev.h    | 12 ++++++++++++
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d703acb..6420057 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -151,16 +151,19 @@ enum req_opf {
 	REQ_OP_FLUSH		= 2,
 	/* discard sectors */
 	REQ_OP_DISCARD		= 3,
-	/* get zone information */
-	REQ_OP_ZONE_REPORT	= 4,
 	/* securely erase sectors */
-	REQ_OP_SECURE_ERASE	= 5,
-	/* seset a zone write pointer */
-	REQ_OP_ZONE_RESET	= 6,
+	REQ_OP_SECURE_ERASE	= 4,
 	/* write the same sector many times */
-	REQ_OP_WRITE_SAME	= 7,
+	REQ_OP_WRITE_SAME	= 5,
 	/* write the zero filled sector many times */
-	REQ_OP_WRITE_ZEROES	= 8,
+	REQ_OP_WRITE_ZEROES	= 6,
+
+	REQ_OP_MEDIUM_LAST = REQ_OP_WRITE_ZEROES,
+
+	/* get zone information */
+	REQ_OP_ZONE_REPORT	= 16,
+	/* reset a zone write pointer */
+	REQ_OP_ZONE_RESET	= 17,
 
 	/* SCSI passthrough using struct scsi_request */
 	REQ_OP_SCSI_IN		= 32,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aecca0e..7d1ce2d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -248,6 +248,18 @@ static inline bool blk_rq_is_passthrough(struct request *rq)
 	return blk_rq_is_scsi(rq) || blk_rq_is_private(rq);
 }
 
+/**
+ * blk_rq_accesses_medium - test if a request is a medium access request
+ * @rq: A block layer request.
+ *
+ * A medium access request is a regular internal request that operates on
+ * a whole number of logical blocks of the storage medium.
+ */
+static inline bool blk_rq_accesses_medium(const struct request *rq)
+{
+	return req_op(rq) <= REQ_OP_MEDIUM_LAST;
+}
+
 static inline unsigned short req_get_ioprio(struct request *req)
 {
 	return req->ioprio;
-- 
2.9.3
