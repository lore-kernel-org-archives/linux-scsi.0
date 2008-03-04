From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 18:06:48 +0900
Message-ID: <20080304180648W.fujita.tomonori@lab.ntt.co.jp>
References: <47CCB4D8.8090600@gmail.com>
	<20080304175302T.fujita.tomonori@lab.ntt.co.jp>
	<20080304085944.GG6704@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:44608 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbYCDKZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 05:25:05 -0500
In-Reply-To: <20080304085944.GG6704@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, htejun@gmail.com, tomof@acm.org, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Tue, 4 Mar 2008 09:59:46 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Mar 04 2008, FUJITA Tomonori wrote:
> > On Tue, 04 Mar 2008 11:32:56 +0900
> > Tejun Heo <htejun@gmail.com> wrote:
> > 
> > > FUJITA Tomonori wrote:
> > > >> Yeah, libata did its own padding and needed to add draining.  Private
> > > >> implementation was complex as hell and James suggested moving them to
> > > >> block layer.  Are you suggesting moving them back to drivers?
> > > > 
> > > > No, I'm not. I've been working on the IOMMUs to remove such
> > > > workarounds in LLDs.
> > > > 
> > > > What drivers need to do on this is just adding a padding length, that
> > > > is, drivers don't need to change the structure of the sg list (like
> > > > splitting a sg entry), right? And it doesn't break the SAS drivers
> > > > that support SATAPI, does it?
> > > > 
> > > > But I agree that drivers want to get a complete sglist so I'm fine
> > > > with adjusting sglist entries in the block layer with your secode
> > > > patch (separate out padding from alignment). As we discussed, I'm fine
> > > > with breaking sum(sg) == rq->data_len as long as rq->data_len means
> > > > the true data length.
> > > 
> > > As long as the second patch is in, what value rq->data_len indicates
> > > doesn't matter to drivers which don't use explicit padding or draining,
> > > so the situation is much more controlled.  I don't care which value
> > > rq->data_len would indicate.  I'd prefer it equal sum(sg) as that value
> > > is what IDE and libata which will be the major users of padding and/or
> > > draining expect in rq->data_len but fixing up that shouldn't be too
> > > difficult.  I guess this can be determined by Jens.  If Jens likes
> > > rq->data_len to contain requested transfer size, I'll post updated patches.
> > 
> > OK, I prefer rq->data_len means the true data length though you prefer
> > rq->data_len means the allocated buffer length (the true data length
> > plus padding and drain). We agree on other things. We can live with
> > either way.
> > 
> > Jens, what's your preference?
> 
> I completely agree with you, ->data_len meaning true data length is way
> cleaner imho. Only the driver should care for the padded length, all
> other parts of the kernel only need to know what they actually got.

OK, now we can fix the whole SG_IO (and bsg handler) mess.

Here's my patch with a proper description. which several people have
already tested (thanks!). Then we need an updated version of Tejun's
separate out padding from alignment patch.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: restore the meaning of rq->data_len to the true data length

The meaning of rq->data_len was changed to the length of an allocated
buffer from the true data length. It breaks SG_IO friends and
bsg. This patch restores the meaning of rq->data_len to the true data
length and adds rq->extra_len to store an extended length (due to
drain buffer and padding).

This patch also removes the code to update bio in blk_rq_map_user
introduced by the commit 40b01b9bbdf51ae543a04744283bf2d56c4a6afa.
The commit adjusts bio according to memory alignment
(queue_dma_alignment). However, memory alignment is NOT padding
alignment. This adjustment also breaks SG_IO friends and bsg. Padding
alignment needs to be fixed in a proper way (by a separate patch).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-core.c          |    3 +--
 block/blk-map.c           |    6 +-----
 block/blk-merge.c         |    2 +-
 block/bsg.c               |    8 ++++----
 block/scsi_ioctl.c        |    4 ++--
 drivers/ata/libata-scsi.c |    6 +++---
 include/linux/blkdev.h    |    2 +-
 7 files changed, 13 insertions(+), 18 deletions(-)

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
-- 
1.5.3.6


