From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/6] block: Make max_discard_sectors sector_t
Date: Thu, 19 Aug 2010 11:48:58 -0400
Message-ID: <1282232941-9910-4-git-send-email-martin.petersen@oracle.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

With 4KB ATA TRIM payloads we can express ranges above the 32 bits
allowed by SCSI.  Convert max_discard_sectors to sector_t.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-lib.c        |    5 +++--
 block/blk-settings.c   |    2 +-
 include/linux/blkdev.h |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index d0216b9..dbed1e9 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -54,8 +54,9 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 
 	while (nr_sects && !ret) {
 		unsigned int sector_size = q->limits.logical_block_size;
-		unsigned int max_discard_sectors =
-			min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+		sector_t max_discard_sectors =
+			min(q->limits.max_discard_sectors,
+			    (sector_t)UINT_MAX >> 9);
 
 		bio = bio_alloc(gfp_mask, 1);
 		if (!bio)
diff --git a/block/blk-settings.c b/block/blk-settings.c
index f5ed5a1..a4a2f42 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -246,7 +246,7 @@ EXPORT_SYMBOL(blk_queue_max_hw_sectors);
  * @max_discard_sectors: maximum number of sectors to discard
  **/
 void blk_queue_max_discard_sectors(struct request_queue *q,
-		unsigned int max_discard_sectors)
+		sector_t max_discard_sectors)
 {
 	q->limits.max_discard_sectors = max_discard_sectors;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 09a8402..d083146 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -316,7 +316,7 @@ struct queue_limits {
 	unsigned int		alignment_offset;
 	unsigned int		io_min;
 	unsigned int		io_opt;
-	unsigned int		max_discard_sectors;
+	sector_t		max_discard_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 
@@ -934,7 +934,7 @@ extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_discard_sectors(struct request_queue *q,
-		unsigned int max_discard_sectors);
+		sector_t max_discard_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned short);
 extern void blk_queue_alignment_offset(struct request_queue *q,
-- 
1.7.2.1

