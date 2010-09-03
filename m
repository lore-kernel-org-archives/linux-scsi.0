From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 40/41] block: remove the BLKDEV_IFL_BARRIER flag
Date: Fri,  3 Sep 2010 12:29:55 +0200
Message-ID: <1283509796-1510-41-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Remove support for barriers on discards, which is unused now.  Also
remove the DISCARD_NOBARRIER I/O type in favour of just setting the
rw flags up locally in blkdev_issue_discard.

tj: Also remove DISCARD_SECURE and use REQ_SECURE directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-lib.c        |   18 ++----------------
 include/linux/blkdev.h |    2 --
 include/linux/fs.h     |    8 --------
 3 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index c392029..fe2e6ed 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -39,8 +39,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
-	int type = flags & BLKDEV_IFL_BARRIER ?
-		DISCARD_BARRIER : DISCARD_NOBARRIER;
+	int type = REQ_WRITE | REQ_DISCARD;
 	unsigned int max_discard_sectors;
 	struct bio *bio;
 	int ret = 0;
@@ -65,7 +64,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (flags & BLKDEV_IFL_SECURE) {
 		if (!blk_queue_secdiscard(q))
 			return -EOPNOTSUPP;
-		type |= DISCARD_SECURE;
+		type |= REQ_SECURE;
 	}
 
 	while (nr_sects && !ret) {
@@ -162,12 +161,6 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	bb.wait = &wait;
 	bb.end_io = NULL;
 
-	if (flags & BLKDEV_IFL_BARRIER) {
-		/* issue async barrier before the data */
-		ret = blkdev_issue_flush(bdev, gfp_mask, NULL, 0);
-		if (ret)
-			return ret;
-	}
 submit:
 	ret = 0;
 	while (nr_sects != 0) {
@@ -199,13 +192,6 @@ submit:
 		issued++;
 		submit_bio(WRITE, bio);
 	}
-	/*
-	 * When all data bios are in flight. Send final barrier if requeted.
-	 */
-	if (nr_sects == 0 && flags & BLKDEV_IFL_BARRIER)
-		ret = blkdev_issue_flush(bdev, gfp_mask, NULL,
-					flags & BLKDEV_IFL_WAIT);
-
 
 	if (flags & BLKDEV_IFL_WAIT)
 		/* Wait for bios in-flight */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6b305eb..cfcb3a6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -869,11 +869,9 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 }
 enum{
 	BLKDEV_WAIT,	/* wait for completion */
-	BLKDEV_BARRIER,	/* issue request with barrier */
 	BLKDEV_SECURE,	/* secure discard */
 };
 #define BLKDEV_IFL_WAIT		(1 << BLKDEV_WAIT)
-#define BLKDEV_IFL_BARRIER	(1 << BLKDEV_BARRIER)
 #define BLKDEV_IFL_SECURE	(1 << BLKDEV_SECURE)
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *,
 			unsigned long);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d6add69..6b0f6e9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -163,14 +163,6 @@ struct inodes_stat_t {
 #define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
 				 REQ_FLUSH | REQ_FUA)
 
-/*
- * These aren't really reads or writes, they pass down information about
- * parts of device that are now unused by the file system.
- */
-#define DISCARD_NOBARRIER	(WRITE | REQ_DISCARD)
-#define DISCARD_BARRIER		(WRITE | REQ_DISCARD | REQ_HARDBARRIER)
-#define DISCARD_SECURE		(DISCARD_NOBARRIER | REQ_SECURE)
-
 #define SEL_IN		1
 #define SEL_OUT		2
 #define SEL_EX		4
-- 
1.7.1
