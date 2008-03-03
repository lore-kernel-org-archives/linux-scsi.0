From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 1/2] block: fix residual byte count handling
Date: Mon, 03 Mar 2008 15:08:02 +0900
Message-ID: <47CB95C2.40309@gmail.com>
References: <47C8F4FC.1040505@gmail.com>	<20080302235223X.tomof@acm.org>	<47CB6508.3040206@gmail.com> <20080303125940T.fujita.tomonori@lab.ntt.co.jp> <47CB79E9.8000505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47CB79E9.8000505@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

rq->raw_data_len introduced for block layer padding and draining
(commit 6b00769fe1502b4ad97bb327ef7ac971b208bfb5) broke residual byte
count handling.  Block drivers modify rq->data_len to notify residual
byte count to the block layer which blindly reported unmodified
rq->raw_data_len to userland.

To keep block drivers dealing only with rq->data_len, this should be
handled inside block layer.  However, how much extra buffer was
appened is lost after rq->data_len is modified.

This patch replaces rq->raw_data_len with rq->extra_len and add
blk_rq_raw_data_len() helper to calculate raw data size from
rq->data_len and rq->extra_len.  The helper returns correct raw
residual byte count when called on a rq whose data_len is modified to
carry residual byte count.

This problem was reported and diagnosed by Mike Galbraith.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
---
Comments updated compared to the previous version.

 block/blk-core.c          |    3 +--
 block/blk-map.c           |    2 +-
 block/blk-merge.c         |    1 +
 block/blk-settings.c      |    4 ++++
 block/bsg.c               |    8 ++++----
 block/scsi_ioctl.c        |    4 ++--
 drivers/ata/libata-scsi.c |    3 ++-
 include/linux/blkdev.h    |    8 +++++++-
 8 files changed, 22 insertions(+), 11 deletions(-)

Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -127,7 +127,7 @@ void rq_init(struct request_queue *q, st
 	rq->nr_hw_segments = 0;
 	rq->ioprio = 0;
 	rq->special = NULL;
-	rq->raw_data_len = 0;
+	rq->extra_len = 0;
 	rq->buffer = NULL;
 	rq->tag = -1;
 	rq->errors = 0;
@@ -2016,7 +2016,6 @@ void blk_rq_bio_prep(struct request_queu
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->buffer = bio_data(bio);
-	rq->raw_data_len = bio->bi_size;
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
Index: work/block/blk-map.c
===================================================================
--- work.orig/block/blk-map.c
+++ work/block/blk-map.c
@@ -19,7 +19,6 @@ int blk_rq_append_bio(struct request_que
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
-		rq->raw_data_len += bio->bi_size;
 		rq->data_len += bio->bi_size;
 	}
 	return 0;
@@ -156,6 +155,7 @@ int blk_rq_map_user(struct request_queue
 		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
 		bio->bi_size += pad_len;
 		rq->data_len += pad_len;
+		rq->extra_len += pad_len;
 	}
 
 	rq->buffer = rq->data = NULL;
Index: work/block/blk-merge.c
===================================================================
--- work.orig/block/blk-merge.c
+++ work/block/blk-merge.c
@@ -232,6 +232,7 @@ new_segment:
 			    (PAGE_SIZE - 1));
 		nsegs++;
 		rq->data_len += q->dma_drain_size;
+		rq->extra_len += q->dma_drain_size;
 	}
 
 	if (sg)
Index: work/block/bsg.c
===================================================================
--- work.orig/block/bsg.c
+++ work/block/bsg.c
@@ -437,14 +437,14 @@ static int blk_complete_sgv4_hdr_rq(stru
 	}
 
 	if (rq->next_rq) {
-		hdr->dout_resid = rq->raw_data_len;
-		hdr->din_resid = rq->next_rq->raw_data_len;
+		hdr->dout_resid = blk_rq_raw_data_len(rq);
+		hdr->din_resid = blk_rq_raw_data_len(rq->next_rq);
 		blk_rq_unmap_user(bidi_bio);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
-		hdr->din_resid = rq->raw_data_len;
+		hdr->din_resid = blk_rq_raw_data_len(rq);
 	else
-		hdr->dout_resid = rq->raw_data_len;
+		hdr->dout_resid = blk_rq_raw_data_len(rq);
 
 	/*
 	 * If the request generated a negative error number, return it
Index: work/block/scsi_ioctl.c
===================================================================
--- work.orig/block/scsi_ioctl.c
+++ work/block/scsi_ioctl.c
@@ -266,7 +266,7 @@ static int blk_complete_sghdr_rq(struct 
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->resid = rq->raw_data_len;
+	hdr->resid = blk_rq_raw_data_len(rq);
 	hdr->sb_len_wr = 0;
 
 	if (rq->sense_len && hdr->sbp) {
@@ -528,8 +528,8 @@ static int __blk_send_generic(struct req
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->data = NULL;
-	rq->raw_data_len = 0;
 	rq->data_len = 0;
+	rq->extra_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->cmd[0] = cmd;
Index: work/drivers/ata/libata-scsi.c
===================================================================
--- work.orig/drivers/ata/libata-scsi.c
+++ work/drivers/ata/libata-scsi.c
@@ -2549,7 +2549,8 @@ static unsigned int atapi_xlat(struct at
 	 * want to set it properly, and for DMA where it is
 	 * effectively meaningless.
 	 */
-	nbytes = min(scmd->request->raw_data_len, (unsigned int)63 * 1024);
+	nbytes = min(blk_rq_raw_data_len(scmd->request),
+		     (unsigned int)63 * 1024);
 
 	/* Most ATAPI devices which honor transfer chunk size don't
 	 * behave according to the spec when odd chunk size which
Index: work/include/linux/blkdev.h
===================================================================
--- work.orig/include/linux/blkdev.h
+++ work/include/linux/blkdev.h
@@ -216,8 +216,8 @@ struct request {
 	unsigned int cmd_len;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	unsigned int raw_data_len;
 	unsigned int data_len;
+	unsigned int extra_len;	/* length of padding and draining buffers */
 	unsigned int sense_len;
 	void *data;
 	void *sense;
@@ -477,6 +477,12 @@ enum {
 
 #define rq_data_dir(rq)		((rq)->cmd_flags & 1)
 
+/* data_len of the request sans extra stuff for padding and draining */
+static inline unsigned int blk_rq_raw_data_len(struct request *rq)
+{
+	return rq->data_len - min(rq->extra_len, rq->data_len);
+}
+
 /*
  * We regard a request as sync, if it's a READ or a SYNC write.
  */
Index: work/block/blk-settings.c
===================================================================
--- work.orig/block/blk-settings.c
+++ work/block/blk-settings.c
@@ -309,6 +309,10 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
  * does is adjust the queue so that the buf is always appended
  * silently to the scatterlist.
  *
+ * Appending draining buffer to a request modifies ->data_len such
+ * that it includes the drain buffer.  The original requested data
+ * length can be obtained using blk_rq_raw_data_len().
+ *
  * Note: This routine adjusts max_hw_segments to make room for
  * appending the drain buffer.  If you call
  * blk_queue_max_hw_segments() or blk_queue_max_phys_segments() after
