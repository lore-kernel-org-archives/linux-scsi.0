From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] block: Ensure physical block size is unsigned int
Date: Mon, 27 Sep 2010 12:41:03 -0400
Message-ID: <1285605664-27027-2-git-send-email-martin.petersen@oracle.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:61851 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801Ab0I0Qlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2010 12:41:42 -0400
In-Reply-To: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Physical block size was declared unsigned int to accomodate the maximum
size reported by READ CAPACITY(16).  Make sure we use the right type in
the related functions.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-settings.c   |    2 +-
 include/linux/blkdev.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a234f4b..450577d 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -343,7 +343,7 @@ EXPORT_SYMBOL(blk_queue_logical_block_size);
  *   hardware can operate on without reverting to read-modify-write
  *   operations.
  */
-void blk_queue_physical_block_size(struct request_queue *q, unsigned short size)
+void blk_queue_physical_block_size(struct request_queue *q, unsigned int size)
 {
 	q->limits.physical_block_size = size;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2c54906..9e443b9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -851,7 +851,7 @@ extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
-extern void blk_queue_physical_block_size(struct request_queue *, unsigned short);
+extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
 extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
@@ -1004,7 +1004,7 @@ static inline unsigned int queue_physical_block_size(struct request_queue *q)
 	return q->limits.physical_block_size;
 }
 
-static inline int bdev_physical_block_size(struct block_device *bdev)
+static inline unsigned int bdev_physical_block_size(struct block_device *bdev)
 {
 	return queue_physical_block_size(bdev_get_queue(bdev));
 }
-- 
1.7.2.2

