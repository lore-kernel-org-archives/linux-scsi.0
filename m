From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/11] block: blk_rq_[cur_]_{sectors|bytes}() usage cleanup
Date: Mon,  4 May 2009 16:58:47 +0900
Message-ID: <1241423927-11871-12-git-send-email-tj@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241423927-11871-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

With the previous changes, the followings are now guaranteed for all
requests in any valid state.

* blk_rq_sectors() == blk_rq_bytes() >> 9
* blk_rq_cur_sectors() == blk_rq_cur_bytes() >> 9

Clean up accessor usages.  Notable changes are

* nbd,i2o_block: end_all used instead of explicit byte count
* scsi_lib: unnecessary conditional on request type removed

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Clements <paul.clements@steeleye.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/block/floppy.c              |    7 +++----
 drivers/block/nbd.c                 |    6 +++---
 drivers/block/ub.c                  |    2 +-
 drivers/block/z2ram.c               |    2 +-
 drivers/memstick/core/mspro_block.c |    4 ++--
 drivers/message/i2o/i2o_block.c     |   16 ++++------------
 drivers/mtd/mtd_blkdevs.c           |    2 +-
 drivers/sbus/char/jsflash.c         |    2 +-
 drivers/scsi/scsi_lib.c             |    7 ++-----
 9 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 4524862..1e27ed9 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2512,8 +2512,7 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 
 	remaining = current_count_sectors << 9;
 #ifdef FLOPPY_SANITY_CHECK
-	if ((remaining >> 9) > blk_rq_sectors(current_req) &&
-	    CT(COMMAND) == FD_WRITE) {
+	if (remaining > blk_rq_bytes(current_req) && CT(COMMAND) == FD_WRITE) {
 		DPRINT("in copy buffer\n");
 		printk("current_count_sectors=%ld\n", current_count_sectors);
 		printk("remaining=%d\n", remaining >> 9);
@@ -2530,7 +2529,7 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 
 	dma_buffer = floppy_track_buffer + ((fsector_t - buffer_min) << 9);
 
-	size = blk_rq_cur_sectors(current_req) << 9;
+	size = blk_rq_cur_bytes(current_req);
 
 	rq_for_each_segment(bv, current_req, iter) {
 		if (!remaining)
@@ -2879,7 +2878,7 @@ static int make_raw_rw_request(void)
 				printk("write\n");
 			return 0;
 		}
-	} else if (raw_cmd->length > blk_rq_sectors(current_req) << 9 ||
+	} else if (raw_cmd->length > blk_rq_bytes(current_req) ||
 		   current_count_sectors > blk_rq_sectors(current_req)) {
 		DPRINT("buffer overrun in direct transfer\n");
 		return 0;
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 977a573..fad167d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -110,7 +110,7 @@ static void nbd_end_request(struct request *req)
 			req, error ? "failed" : "done");
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	__blk_end_request(req, error, blk_rq_sectors(req) << 9);
+	__blk_end_request_all(req, error);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
@@ -231,7 +231,7 @@ static int nbd_send_req(struct nbd_device *lo, struct request *req)
 {
 	int result, flags;
 	struct nbd_request request;
-	unsigned long size = blk_rq_sectors(req) << 9;
+	unsigned long size = blk_rq_bytes(req);
 
 	request.magic = htonl(NBD_REQUEST_MAGIC);
 	request.type = htonl(nbd_cmd(req));
@@ -243,7 +243,7 @@ static int nbd_send_req(struct nbd_device *lo, struct request *req)
 			lo->disk->disk_name, req,
 			nbdcmd_to_ascii(nbd_cmd(req)),
 			(unsigned long long)blk_rq_pos(req) << 9,
-			blk_rq_sectors(req) << 9);
+			blk_rq_bytes(req));
 	result = sock_xmit(lo, 1, &request, sizeof(request),
 			(nbd_cmd(req) == NBD_CMD_WRITE) ? MSG_MORE : 0);
 	if (result <= 0) {
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 1591f61..40d03cf 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -739,7 +739,7 @@ static void ub_cmd_build_block(struct ub_dev *sc, struct ub_lun *lun,
 	cmd->cdb[8] = nblks;
 	cmd->cdb_len = 10;
 
-	cmd->len = blk_rq_sectors(rq) * 512;
+	cmd->len = blk_rq_bytes(rq);
 }
 
 static void ub_cmd_build_packet(struct ub_dev *sc, struct ub_lun *lun,
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index d4e6b71..6a13838 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -72,7 +72,7 @@ static void do_z2_request(struct request_queue *q)
 	struct request *req;
 	while ((req = elv_next_request(q)) != NULL) {
 		unsigned long start = blk_rq_pos(req) << 9;
-		unsigned long len  = blk_rq_cur_sectors(req) << 9;
+		unsigned long len  = blk_rq_cur_bytes(req);
 
 		if (start + len > z2ram_size) {
 			printk( KERN_ERR DEVICE_NAME ": bad access: block=%lu, count=%u\n",
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 9e600d2..93b2c61 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -680,7 +680,7 @@ try_again:
 		t_sec = blk_rq_pos(msb->block_req) << 9;
 		sector_div(t_sec, msb->page_size);
 
-		count = blk_rq_sectors(msb->block_req) << 9;
+		count = blk_rq_bytes(msb->block_req);
 		count /= msb->page_size;
 
 		param.system = msb->system;
@@ -745,7 +745,7 @@ static int mspro_block_complete_req(struct memstick_dev *card, int error)
 					t_len *= msb->page_size;
 			}
 		} else
-			t_len = blk_rq_sectors(msb->block_req) << 9;
+			t_len = blk_rq_bytes(msb->block_req);
 
 		dev_dbg(&card->dev, "transferred %x (%d)\n", t_len, error);
 
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 6b61d28..e153f5d 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -426,15 +426,9 @@ static void i2o_block_end_request(struct request *req, int error,
 	struct request_queue *q = req->q;
 	unsigned long flags;
 
-	if (blk_end_request(req, error, nr_bytes)) {
-		int leftover = (blk_rq_sectors(req) << KERNEL_SECTOR_SHIFT);
-
-		if (blk_pc_request(req))
-			leftover = blk_rq_bytes(req);
-
+	if (blk_end_request(req, error, nr_bytes))
 		if (error)
-			blk_end_request(req, -EIO, leftover);
-	}
+			blk_end_request_all(req, -EIO);
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
@@ -832,15 +826,13 @@ static int i2o_block_transfer(struct request *req)
 
 		memcpy(mptr, cmd, 10);
 		mptr += 4;
-		*mptr++ =
-		    cpu_to_le32(blk_rq_sectors(req) << KERNEL_SECTOR_SHIFT);
+		*mptr++ = cpu_to_le32(blk_rq_bytes(req));
 	} else
 #endif
 	{
 		msg->u.head[1] = cpu_to_le32(cmd | HOST_TID << 12 | tid);
 		*mptr++ = cpu_to_le32(ctl_flags);
-		*mptr++ =
-		    cpu_to_le32(blk_rq_sectors(req) << KERNEL_SECTOR_SHIFT);
+		*mptr++ = cpu_to_le32(blk_rq_bytes(req));
 		*mptr++ =
 		    cpu_to_le32((u32) (blk_rq_pos(req) << KERNEL_SECTOR_SHIFT));
 		*mptr++ =
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 4ea2e67..50c76a2 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -48,7 +48,7 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	char *buf;
 
 	block = blk_rq_pos(req) << 9 >> tr->blkshift;
-	nsect = blk_rq_cur_sectors(req) << 9 >> tr->blkshift;
+	nsect = blk_rq_cur_bytes(req) >> tr->blkshift;
 
 	buf = req->buffer;
 
diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index 2132c90..d56ddaa 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -189,7 +189,7 @@ static void jsfd_do_request(struct request_queue *q)
 	while ((req = elv_next_request(q)) != NULL) {
 		struct jsfd_part *jdp = req->rq_disk->private_data;
 		unsigned long offset = blk_rq_pos(req) << 9;
-		size_t len = blk_rq_cur_sectors(req) << 9;
+		size_t len = blk_rq_cur_bytes(req);
 
 		if ((offset + len) > jdp->dsize) {
 			__blk_end_request_cur(req, -EIO);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3d16c70..ee308f6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -546,7 +546,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 	 * to queue the remainder of them.
 	 */
 	if (blk_end_request(req, error, bytes)) {
-		int leftover = blk_rq_sectors(req) << 9;
+		int leftover = blk_rq_bytes(req);
 
 		if (blk_pc_request(req))
 			leftover = req->resid_len;
@@ -964,10 +964,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
 	BUG_ON(count > sdb->table.nents);
 	sdb->table.nents = count;
-	if (blk_pc_request(req))
-		sdb->length = blk_rq_bytes(req);
-	else
-		sdb->length = blk_rq_sectors(req) << 9;
+	sdb->length = blk_rq_bytes(req);
 	return BLKPREP_OK;
 }
 
-- 
1.6.0.2

