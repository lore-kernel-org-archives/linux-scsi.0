From: mchristi@redhat.com
Subject: [PATCH 28/32] block/fs/drivers: use bio/rq_data_dir
	helpers
Date: Wed,  4 Nov 2015 16:08:25 -0600
Message-ID: <1446674909-5371-29-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This has the the block layer, drivers and fs code use
the bio and rq data_dir helpers instead of accessing the
bi_rw/cmd_flags and checking for REQ_WRITE.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-merge.c                | 2 +-
 drivers/ata/libata-scsi.c        | 2 +-
 drivers/block/loop.c             | 6 +++---
 drivers/block/rbd.c              | 2 +-
 drivers/block/umem.c             | 2 +-
 drivers/ide/ide-floppy.c         | 2 +-
 drivers/md/bcache/io.c           | 2 +-
 drivers/md/bcache/request.c      | 6 +++---
 drivers/scsi/osd/osd_initiator.c | 4 ++--
 fs/btrfs/disk-io.c               | 2 +-
 fs/btrfs/extent_io.c             | 2 +-
 fs/btrfs/inode.c                 | 2 +-
 include/linux/blkdev.h           | 2 +-
 include/linux/fs.h               | 2 +-
 14 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index c4e9c37..fe00d94 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -378,7 +378,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	}
 
 	if (q->dma_drain_size && q->dma_drain_needed(rq)) {
-		if (rq->cmd_flags & REQ_WRITE)
+		if (rq_data_dir(rq) == WRITE)
 			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
 
 		sg_unmark_end(sg);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0d7f0da..68c2b34 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1125,7 +1125,7 @@ static int atapi_drain_needed(struct request *rq)
 	if (likely(rq->cmd_type != REQ_TYPE_BLOCK_PC))
 		return 0;
 
-	if (!blk_rq_bytes(rq) || (rq->cmd_flags & REQ_WRITE))
+	if (!blk_rq_bytes(rq) || rq_data_dir(rq) == WRITE)
 		return 0;
 
 	return atapi_cmd_type(rq->cmd[0]) == ATAPI_MISC;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 674f800..e214936 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -396,7 +396,7 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 
 	pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
 
-	if (rq->cmd_flags & REQ_WRITE) {
+	if (rq_data_dir(rq) == WRITE) {
 		if (rq->cmd_flags & REQ_FLUSH)
 			ret = lo_req_flush(lo, rq);
 		else if (rq->cmd_flags & REQ_DISCARD)
@@ -1461,7 +1461,7 @@ static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (lo->lo_state != Lo_bound)
 		return -EIO;
 
-	if (cmd->rq->cmd_flags & REQ_WRITE) {
+	if (rq_data_dir(cmd->rq) == WRITE) {
 		struct loop_device *lo = cmd->rq->q->queuedata;
 		bool need_sched = true;
 
@@ -1484,7 +1484,7 @@ static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 static void loop_handle_cmd(struct loop_cmd *cmd)
 {
-	const bool write = cmd->rq->cmd_flags & REQ_WRITE;
+	const bool write = rq_data_dir(cmd->rq);
 	struct loop_device *lo = cmd->rq->q->queuedata;
 	int ret = 0;
 
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 6f26cf3..39104ca 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3377,7 +3377,7 @@ static void rbd_queue_workfn(struct work_struct *work)
 
 	if (rq->cmd_flags & REQ_DISCARD)
 		op_type = OBJ_OP_DISCARD;
-	else if (rq->cmd_flags & REQ_WRITE)
+	else if (rq_data_dir(rq) == WRITE)
 		op_type = OBJ_OP_WRITE;
 	else
 		op_type = OBJ_OP_READ;
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 04d6579..2355754 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -462,7 +462,7 @@ static void process_page(unsigned long data)
 				le32_to_cpu(desc->local_addr)>>9,
 				le32_to_cpu(desc->transfer_size));
 			dump_dmastat(card, control);
-		} else if ((bio->bi_rw & REQ_WRITE) &&
+		} else if (bio_data_dir(bio) == WRITE &&
 			   le32_to_cpu(desc->local_addr) >> 9 ==
 				card->init_size) {
 			card->init_size += le32_to_cpu(desc->transfer_size) >> 9;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 2fb5350..f079d8d 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -206,7 +206,7 @@ static void idefloppy_create_rw_cmd(ide_drive_t *drive,
 	memcpy(rq->cmd, pc->c, 12);
 
 	pc->rq = rq;
-	if (rq->cmd_flags & REQ_WRITE)
+	if (cmd == WRITE)
 		pc->flags |= PC_FLAG_WRITING;
 
 	pc->flags |= PC_FLAG_DMA_OK;
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 86a0bb8..fbc8974 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -111,7 +111,7 @@ void bch_bbio_count_io_errors(struct cache_set *c, struct bio *bio,
 	struct bbio *b = container_of(bio, struct bbio, bio);
 	struct cache *ca = PTR_CACHE(c, &b->key, 0);
 
-	unsigned threshold = bio->bi_rw & REQ_WRITE
+	unsigned threshold = bio_data_dir(bio) == WRITE
 		? c->congested_write_threshold_us
 		: c->congested_read_threshold_us;
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 7a84f3b..11f6b5c 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -384,7 +384,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 
 	if (mode == CACHE_MODE_NONE ||
 	    (mode == CACHE_MODE_WRITEAROUND &&
-	     (bio->bi_rw & REQ_WRITE)))
+	     bio_data_dir(bio) == WRITE))
 		goto skip;
 
 	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
@@ -405,7 +405,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 
 	if (!congested &&
 	    mode == CACHE_MODE_WRITEBACK &&
-	    (bio->bi_rw & REQ_WRITE) &&
+	    bio_data_dir(bio) == WRITE &&
 	    (bio->bi_rw & REQ_SYNC))
 		goto rescale;
 
@@ -658,7 +658,7 @@ static inline struct search *search_alloc(struct bio *bio,
 	s->cache_miss		= NULL;
 	s->d			= d;
 	s->recoverable		= 1;
-	s->write		= (bio->bi_rw & REQ_WRITE) != 0;
+	s->write		= bio_data_dir(bio) == WRITE;
 	s->read_dirty_data	= 0;
 	s->start_time		= jiffies;
 
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index ca7b4b6..650ba1c 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -828,7 +828,7 @@ void osd_req_write(struct osd_request *or,
 {
 	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, len);
 	WARN_ON(or->out.bio || or->out.total_bytes);
-	WARN_ON(0 == (bio->bi_rw & REQ_WRITE));
+	WARN_ON(bio_data_dir(bio) == READ);
 	or->out.bio = bio;
 	or->out.total_bytes = len;
 }
@@ -880,7 +880,7 @@ void osd_req_read(struct osd_request *or,
 {
 	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, len);
 	WARN_ON(or->in.bio || or->in.total_bytes);
-	WARN_ON(bio->bi_rw & REQ_WRITE);
+	WARN_ON(bio_data_dir(bio) == WRITE);
 	or->in.bio = bio;
 	or->in.total_bytes = len;
 }
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f1262e6..8771f31 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -714,7 +714,7 @@ static void end_workqueue_bio(struct bio *bio)
 	fs_info = end_io_wq->info;
 	end_io_wq->error = bio->bi_error;
 
-	if (bio->bi_rw & REQ_WRITE) {
+	if (bio_data_dir(bio) == WRITE) {
 		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_METADATA) {
 			wq = fs_info->endio_meta_write_workers;
 			func = btrfs_endio_meta_write_helper;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0dc9ec6..1075b05 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2410,7 +2410,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	int read_mode_flags = READ_SYNC;
 	int ret;
 
-	BUG_ON(failed_bio->bi_rw & REQ_WRITE);
+	BUG_ON(bio_data_dir(failed_bio) == WRITE);
 
 	ret = btrfs_get_io_failure_record(inode, start, end, &failrec);
 	if (ret)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dd0b769..3ffb969 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7675,7 +7675,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	int read_mode;
 	int ret;
 
-	BUG_ON(failed_bio->bi_rw & REQ_WRITE);
+	BUG_ON(bio_data_dir(failed_bio) == WRITE);
 
 	ret = btrfs_get_io_failure_record(inode, start, end, &failrec);
 	if (ret)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9c5bee9..4376ec6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -599,7 +599,7 @@ static inline int op_to_data_dir(int op)
 		return WRITE;
 }
 
-#define rq_data_dir(rq)		((int)((rq)->cmd_flags & 1))
+#define rq_data_dir(rq)		(rq->op == REQ_OP_READ ? READ : WRITE)
 
 /*
  * Driver can handle struct request, if it either has an old style
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ac1fd9b..66dd4b91 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2397,7 +2397,7 @@ extern int is_bad_inode(struct inode *);
 /*
  * return data direction, READ or WRITE
  */
-#define bio_data_dir(bio)	((bio)->bi_rw & 1)
+#define bio_data_dir(bio)	((bio)->bi_op == REQ_OP_READ ? READ : WRITE)
 
 extern void check_disk_size_change(struct gendisk *disk,
 				   struct block_device *bdev);
-- 
1.8.3.1
