From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Mon, 03 Mar 2008 12:59:40 +0900
Message-ID: <20080303125940T.fujita.tomonori@lab.ntt.co.jp>
References: <47C8F4FC.1040505@gmail.com>
	<20080302235223X.tomof@acm.org>
	<47CB6508.3040206@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47CB6508.3040206@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: htejun@gmail.com
Cc: tomof@acm.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Mon, 03 Mar 2008 11:40:08 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> > sum(sg) == rq->data_len is already broken; sg sends such requests
> > (though it would be nice if it doesn't).
> > 
> > I've not followed the earlier discussion (because I thought the drain
> > buffer stuff affected only libata but seems it doesn't ...). Why did
> > we need to change the meaning of rq->data_len?
> 
> At this point, it's not clear what the original meaning of rq->data_len
> is because before moving alignment and padding to block layer,
> rq->data_len equaled both the requested data length and the length of sg
> list.  AFAIK, it's SCSI midlayer which makes sg list and data length
> mismatch not block layer.
> 
> From the POV of the block layer, as now it might extend the sg list, it
> has to decide what rq->data_len means in this case - the requested
> transfer length from userland or the length of mapped sg list.

Yeah. It meant the requested transfer length from userland in the past
and I think that chaning to the length of mapped sg list doesn't make
anything simpler.


> I think that currently the biggest problem is that drivers which don't
> require request size adjustment are getting it because alignment setting
> doesn't distinguish between start address alignment and size alignment.
> For drivers which don't require data size adjustment from block layer,
> data_len or raw_data_len doesn't matter.  They're equal anyway.  I'm
> prepping a patch for this now.
> 
> For drivers which do require request size adjustments, I think it's
> better to keep rq->data_len in line with the size of mapped sg list.
> The rationales are...
> 
> - Those are dumb controllers which want to see requests which meet
> certain size requirements and they're likely to care more about actual
> data buffer size than user requested buffer size.  IOW, they wanna see
> sizes which meet certain requirements, so give them those values.

The drivers care about the actual data buffer size.

The dumb controllers drivers can get what they want to use
rq->extra_len or walk through the sg list.


> - I think bugs caused by using raw_data_len instead of data_len are more
> subtle than the other way around.  Using data_len instead of
> raw_data_len usually affects the application layer while using
> raw_data_len instead of data_len affects the DMA engine and transport layer.

If we add extra_len, we can get what raw_data_len and data_len
provide.


I can't see what changing the meaning of rq->data_len (and
investigating all the block drivers) gives us.


> > rq->data_len meant the true data length and the patch to change it
> > doesn't look to make anything simple. Can we revert the meaning of
> > rq->data_len? I'm not sure that we need to add rq->extra_len but it's
> > fine as long as it's only for drivers that want to use it.
> > 
> > This is only compile tested.
> 
> If we're gonna go this way, we'll need blk_rq_total_data_len() and use
> it for drivers which requires request size adjustments.

No problem. It would be much better to add blk_rq_total_data_len
rather than chainging the meaning of rq->data_len and all the block
drivers.

Here's an updated patch (I forgot to remove the bi_size adjustment in
blk_rq_map_user in the previous patch). Can we agree on it if we add
blk_rq_total_data_len()?


diff --git a/block/blk-core.c b/block/blk-core.c
index 775c851..bfec406 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -127,7 +127,6 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->nr_hw_segments = 0;
 	rq->ioprio = 0;
 	rq->special = NULL;
-	rq->raw_data_len = 0;
 	rq->buffer = NULL;
 	rq->tag = -1;
 	rq->errors = 0;
@@ -135,6 +134,7 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->cmd_len = 0;
 	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->data_len = 0;
+	rq->extra_len = 0;
 	rq->sense_len = 0;
 	rq->data = NULL;
 	rq->sense = NULL;
@@ -2016,7 +2016,6 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->buffer = bio_data(bio);
-	rq->raw_data_len = bio->bi_size;
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
diff --git a/block/blk-map.c b/block/blk-map.c
index 09f7fd0..f559832 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -19,7 +19,6 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
-		rq->raw_data_len += bio->bi_size;
 		rq->data_len += bio->bi_size;
 	}
 	return 0;
@@ -151,11 +150,8 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 	 */
 	if (len & queue_dma_alignment(q)) {
 		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
-		struct bio *bio = rq->biotail;
 
-		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
-		bio->bi_size += pad_len;
-		rq->data_len += pad_len;
+		rq->extra_len += pad_len;
 	}
 
 	rq->buffer = rq->data = NULL;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 7506c4f..0f58616 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -231,7 +231,7 @@ new_segment:
 			    ((unsigned long)q->dma_drain_buffer) &
 			    (PAGE_SIZE - 1));
 		nsegs++;
-		rq->data_len += q->dma_drain_size;
+		rq->extra_len += q->dma_drain_size;
 	}
 
 	if (sg)
diff --git a/block/bsg.c b/block/bsg.c
index 7f3c095..8917c51 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -437,14 +437,14 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	}
 
 	if (rq->next_rq) {
-		hdr->dout_resid = rq->raw_data_len;
-		hdr->din_resid = rq->next_rq->raw_data_len;
+		hdr->dout_resid = rq->data_len;
+		hdr->din_resid = rq->next_rq->data_len;
 		blk_rq_unmap_user(bidi_bio);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
-		hdr->din_resid = rq->raw_data_len;
+		hdr->din_resid = rq->data_len;
 	else
-		hdr->dout_resid = rq->raw_data_len;
+		hdr->dout_resid = rq->data_len;
 
 	/*
 	 * If the request generated a negative error number, return it
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index e993cac..a2c3a93 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -266,7 +266,7 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->resid = rq->raw_data_len;
+	hdr->resid = rq->data_len;
 	hdr->sb_len_wr = 0;
 
 	if (rq->sense_len && hdr->sbp) {
@@ -528,8 +528,8 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->data = NULL;
-	rq->raw_data_len = 0;
 	rq->data_len = 0;
+	rq->extra_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->cmd[0] = cmd;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7b1f1ee..fe47922 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2538,7 +2538,7 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	}
 
 	qc->tf.command = ATA_CMD_PACKET;
-	qc->nbytes = scsi_bufflen(scmd);
+	qc->nbytes = scsi_bufflen(scmd) + scmd->request->extra_len;
 
 	/* check whether ATAPI DMA is safe */
 	if (!using_pio && ata_check_atapi_dma(qc))
@@ -2549,7 +2549,7 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	 * want to set it properly, and for DMA where it is
 	 * effectively meaningless.
 	 */
-	nbytes = min(scmd->request->raw_data_len, (unsigned int)63 * 1024);
+	nbytes = min(scmd->request->data_len, (unsigned int)63 * 1024);
 
 	/* Most ATAPI devices which honor transfer chunk size don't
 	 * behave according to the spec when odd chunk size which
@@ -2875,7 +2875,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	 * TODO: find out if we need to do more here to
 	 *       cover scatter/gather case.
 	 */
-	qc->nbytes = scsi_bufflen(scmd);
+	qc->nbytes = scsi_bufflen(scmd) + scmd->request->extra_len;
 
 	/* request result TF and be quiet about device error */
 	qc->flags |= ATA_QCFLAG_RESULT_TF | ATA_QCFLAG_QUIET;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6fe67d1..b72526c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -216,8 +216,8 @@ struct request {
 	unsigned int cmd_len;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	unsigned int raw_data_len;
 	unsigned int data_len;
+	unsigned int extra_len;	/* length of alignment and padding */
 	unsigned int sense_len;
 	void *data;
 	void *sense;
