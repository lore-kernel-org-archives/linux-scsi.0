From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>
Subject: [PATCH 2/4] null_blk: add zone open, close, and finish support
Date: Fri, 21 Jun 2019 15:07:09 +0200
Message-ID: <20190621130711.21986-3-mb@lightnvm.io>
References: <20190621130711.21986-1-mb@lightnvm.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621130711.21986-1-mb@lightnvm.io>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com, hch@lst.de, damien.lemoal@wdc.com, chaitanya.kulkarni@wdc.com, dmitry.fomichev@wdc.com, ajay.joshi@wdc.com, aravind.ramesh@wdc.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, agk@redhat.com, snitzer@redhat.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, =?UTF-8?q?Matias=20Bj=C3=B8rling?= <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

From: Ajay Joshi <ajay.joshi@wdc.com>

Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH
support to allow explicit control of zone states.

Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
Signed-off-by: Matias Bjørling <matias.bjorling@wdc.com>
---
 drivers/block/null_blk.h       |  4 ++--
 drivers/block/null_blk_main.c  | 13 ++++++++++---
 drivers/block/null_blk_zoned.c | 33 ++++++++++++++++++++++++++++++---
 3 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h
index 34b22d6523ba..62ef65cb0f3e 100644
--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -93,7 +93,7 @@ int null_zone_report(struct gendisk *disk, sector_t sector,
 		     gfp_t gfp_mask);
 void null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 			unsigned int nr_sectors);
-void null_zone_reset(struct nullb_cmd *cmd, sector_t sector);
+void null_zone_mgmt_op(struct nullb_cmd *cmd, sector_t sector);
 #else
 static inline int null_zone_init(struct nullb_device *dev)
 {
@@ -111,6 +111,6 @@ static inline void null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 				   unsigned int nr_sectors)
 {
 }
-static inline void null_zone_reset(struct nullb_cmd *cmd, sector_t sector) {}
+static inline void null_zone_mgmt_op(struct nullb_cmd *cmd, sector_t sector) {}
 #endif /* CONFIG_BLK_DEV_ZONED */
 #endif /* __NULL_BLK_H */
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 447d635c79a2..5058fb980c9c 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1209,10 +1209,17 @@ static blk_status_t null_handle_cmd(struct nullb_cmd *cmd)
 			nr_sectors = blk_rq_sectors(cmd->rq);
 		}
 
-		if (op == REQ_OP_WRITE)
+		switch (op) {
+		case REQ_OP_WRITE:
 			null_zone_write(cmd, sector, nr_sectors);
-		else if (op == REQ_OP_ZONE_RESET)
-			null_zone_reset(cmd, sector);
+			break;
+		case REQ_OP_ZONE_RESET:
+		case REQ_OP_ZONE_OPEN:
+		case REQ_OP_ZONE_CLOSE:
+		case REQ_OP_ZONE_FINISH:
+			null_zone_mgmt_op(cmd, sector);
+			break;
+		}
 	}
 out:
 	/* Complete IO by inline, softirq or timer */
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index fca0c97ff1aa..47d956b2e148 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -121,17 +121,44 @@ void null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 	}
 }
 
-void null_zone_reset(struct nullb_cmd *cmd, sector_t sector)
+void null_zone_mgmt_op(struct nullb_cmd *cmd, sector_t sector)
 {
 	struct nullb_device *dev = cmd->nq->dev;
 	unsigned int zno = null_zone_no(dev, sector);
 	struct blk_zone *zone = &dev->zones[zno];
+	enum req_opf op = req_op(cmd->rq);
 
 	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL) {
 		cmd->error = BLK_STS_IOERR;
 		return;
 	}
 
-	zone->cond = BLK_ZONE_COND_EMPTY;
-	zone->wp = zone->start;
+	switch (op) {
+	case REQ_OP_ZONE_RESET:
+		zone->cond = BLK_ZONE_COND_EMPTY;
+		zone->wp = zone->start;
+		return;
+	case REQ_OP_ZONE_OPEN:
+		if (zone->cond == BLK_ZONE_COND_FULL) {
+			cmd->error = BLK_STS_IOERR;
+			return;
+		}
+		zone->cond = BLK_ZONE_COND_EXP_OPEN;
+		return;
+	case REQ_OP_ZONE_CLOSE:
+		if (zone->cond == BLK_ZONE_COND_FULL) {
+			cmd->error = BLK_STS_IOERR;
+			return;
+		}
+		zone->cond = BLK_ZONE_COND_CLOSED;
+		return;
+	case REQ_OP_ZONE_FINISH:
+		zone->cond = BLK_ZONE_COND_FULL;
+		zone->wp = zone->start + zone->len;
+		return;
+	default:
+		/* Invalid zone condition */
+		cmd->error = BLK_STS_IOERR;
+		return;
+	}
 }
-- 
2.19.1
