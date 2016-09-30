From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH v5 4/7] block: Define zoned block device operations
Date: Fri, 30 Sep 2016 13:11:36 +0900
Message-ID: <1475208699-27310-5-git-send-email-damien.lemoal@hgst.com>
References: <1475208699-27310-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1475208699-27310-1-git-send-email-damien.lemoal@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, Damien Le Moal <damien.lemoal@hgst.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

From: Shaun Tancheff <shaun.tancheff@seagate.com>

Define REQ_OP_ZONE_REPORT and REQ_OP_ZONE_RESET for handling zones of
host-managed and host-aware zoned block devices. With with these two
new operations, the total number of operations defined reaches 8 and
still fits with the 3 bits definition of REQ_OP_BITS.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

---
 block/blk-core.c          | 4 ++++
 include/linux/blk_types.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 14d7c07..e4eda5d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1941,6 +1941,10 @@ generic_make_request_checks(struct bio *bio)
 	case REQ_OP_WRITE_SAME:
 		if (!bdev_write_same(bio->bi_bdev))
 			goto not_supported;
+	case REQ_OP_ZONE_REPORT:
+	case REQ_OP_ZONE_RESET:
+		if (!bdev_is_zoned(bio->bi_bdev))
+			goto not_supported;
 		break;
 	default:
 		break;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index cd395ec..dd50dce 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -243,6 +243,8 @@ enum req_op {
 	REQ_OP_SECURE_ERASE,	/* request to securely erase sectors */
 	REQ_OP_WRITE_SAME,	/* write same block many times */
 	REQ_OP_FLUSH,		/* request for cache flush */
+	REQ_OP_ZONE_REPORT,	/* Get zone information */
+	REQ_OP_ZONE_RESET,	/* Reset a zone write pointer */
 };
 
 #define REQ_OP_BITS 3
-- 
2.7.4

