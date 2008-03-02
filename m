From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Sun, 2 Mar 2008 23:52:09 +0900
Message-ID: <20080302235223X.tomof@acm.org>
References: <1204303656.4003.19.camel@localhost.localdomain>
	<20080229201123.GK6704@kernel.dk>
	<47C8F4FC.1040505@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47C8F4FC.1040505@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: htejun@gmail.com
Cc: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Sat, 01 Mar 2008 15:17:32 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Hello, Jens, James.
> 
> Jens Axboe wrote:
> >> With the original patch, I have to run through the whole of libsas and
> >> scsi_transport_sas doing
> >>
> >> s/data_len/raw_data_len/
> >>
> >> With your update it looks like I have to run through them all doing
> >>
> >> s/data_len/data_len - extra_len/
> 
> blk_rq_raw_data_len() should do.
> 
> >> which is even worse.  Can't we put things back to a point where data_len
> >> means exactly that and extra_len means how much we have spare on the
> >> end, so you know you can DMA up to data_len + extra_len if need be?
> >>
> >> That way we don't have to sweep through every block driver altering the
> >> way it uses data_len.
> 
> If SMP is broken because it needs start address alignment but not
> padding to align the size, what should be done is to make that exact
> requirement visible to the block layer.  Say,
> blk_queue_dma_start_alignment() or maybe change
> blk_queue_dma_alignment() such that it only indicates start address
> alignment and add blk_queue_dma_size_alignment() for drivers which
> require size to be aligned too.  I think those are few.
> 
> I think the decision which value rq->data_len represents comes down to
> which size is used more in low level drivers because no matter which way
> we choose we'll have to update some of the drivers which expects the
> other thing from rq->data_len.
> 
> blk_rq_raw_data_len() is needed iff a driver needs dummy buffers
> attached at the end and still needs to know the original request size
> which isn't the common case.
> 
> > Fully agree. The reason why I think it's so ugly is that you have to
> > keep these two seperate variables in sync. The burning was just one bug,
> > there will be others...
> 
> The posted modification isn't too bad as the maintenance of the two
> variables is at places where the nasty things happen.  I think what
> rq->data_len should represent when seen from LLDs is more important and
> please note that if SMP is broken because it simply doesn't require
> 512byte size alignment, it's a different issue.
> 
> As long as both raw_data_len and data_len are accessible, I'm okay
> either way.  My biggest reluctance is against breaking sum(sg) ==
> rq->data_len.  I think this can lead to much more subtle problems such
> as programming the controller w/ wrong bytes count and wrapped-around
> resid calculation.

sum(sg) == rq->data_len is already broken; sg sends such requests
(though it would be nice if it doesn't).

I've not followed the earlier discussion (because I thought the drain
buffer stuff affected only libata but seems it doesn't ...). Why did
we need to change the meaning of rq->data_len?

rq->data_len meant the true data length and the patch to change it
doesn't look to make anything simple. Can we revert the meaning of
rq->data_len? I'm not sure that we need to add rq->extra_len but it's
fine as long as it's only for drivers that want to use it.

This is only compile tested.

=
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
index 09f7fd0..3287637 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -19,7 +19,6 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
-		rq->raw_data_len += bio->bi_size;
 		rq->data_len += bio->bi_size;
 	}
 	return 0;
@@ -155,7 +154,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 
 		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
 		bio->bi_size += pad_len;
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
