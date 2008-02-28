From: Tejun Heo <htejun@gmail.com>
Subject: Re: regression: CD burning (k3b) went broke
Date: Thu, 28 Feb 2008 16:43:26 +0900
Message-ID: <47C6661E.9010504@gmail.com>
References: <1203583379.6244.27.camel@homer.simson.net>	 <20080222073228.GZ23197@kernel.dk>	 <1203752563.5225.4.camel@homer.simson.net>	 <1203839683.17463.9.camel@homer.simson.net>	 <1204019283.8731.11.camel@homer.simson.net>	 <1204033003.11828.22.camel@homer.simson.net>	 <20080226150845.2196bc1a.akpm@linux-foundation.org>	 <1204079075.26640.8.camel@homer.simson.net>	 <1204092010.9934.31.camel@homer.simson.net> <1204096025.1623.9.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080501060802020501010609"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1204096025.1623.9.camel@homer.simson.net>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080501060802020501010609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello, all.

Sorry about the delay.  Was buried under other stuff.  Mike, thanks a
lot for reporting and analyzing the problem; however, the patch is
slightly incorrect.  rq->data_len is rq->data_len + extra stuff for
alignment and padding, so the correct thing to do is...

  req->raw_data_len -= req->data_len - scsi_get_resid(cmd);
  req->data_len = scsi_get_resid(cmd);

which is ugly and error-prone.  In addition, this isn't the only place
where resid is set.  Other block drivers do this too.  This definitely
should be done in block layer.

With rq->data_len and rq->raw_data_len, it's impossible to translate
resid of rq->data_len to resid of rq->raw_data_len as block layer
doesn't know how much was extra data after rq->data_len is modified.
The attached patch substitutes rq->raw_data_len w/ rq->extra_len and
adds blk_rq_raw_data_len().  Things look cleaner this way and the resid
problem should be solved with this.

Can you please verify the attached patch fixes the problem?

Thanks.

-- 
tejun

--------------080501060802020501010609
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/block/blk-core.c b/block/blk-core.c
index 775c851..929ab61 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -127,7 +127,7 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->nr_hw_segments = 0;
 	rq->ioprio = 0;
 	rq->special = NULL;
-	rq->raw_data_len = 0;
+	rq->extra_len = 0;
 	rq->buffer = NULL;
 	rq->tag = -1;
 	rq->errors = 0;
@@ -2016,7 +2016,6 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->buffer = bio_data(bio);
-	rq->raw_data_len = bio->bi_size;
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
diff --git a/block/blk-map.c b/block/blk-map.c
index 09f7fd0..c67a75f 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -19,7 +19,6 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
-		rq->raw_data_len += bio->bi_size;
 		rq->data_len += bio->bi_size;
 	}
 	return 0;
@@ -156,6 +155,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
 		bio->bi_size += pad_len;
 		rq->data_len += pad_len;
+		rq->extra_len += pad_len;
 	}
 
 	rq->buffer = rq->data = NULL;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 7506c4f..efb5b4d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -232,6 +232,7 @@ new_segment:
 			    (PAGE_SIZE - 1));
 		nsegs++;
 		rq->data_len += q->dma_drain_size;
+		rq->extra_len += q->dma_drain_size;
 	}
 
 	if (sg)
diff --git a/block/bsg.c b/block/bsg.c
index 7f3c095..81b2133 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -437,14 +437,14 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
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
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index e993cac..32424b3 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -266,7 +266,7 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->resid = rq->raw_data_len;
+	hdr->resid = blk_rq_raw_data_len(rq);
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
index 0562b0a..5cab84c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2539,7 +2539,8 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	 * want to set it properly, and for DMA where it is
 	 * effectively meaningless.
 	 */
-	nbytes = min(scmd->request->raw_data_len, (unsigned int)63 * 1024);
+	nbytes = min(blk_rq_raw_data_len(scmd->request),
+		     (unsigned int)63 * 1024);
 
 	/* Most ATAPI devices which honor transfer chunk size don't
 	 * behave according to the spec when odd chunk size which
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6fe67d1..57e2a9e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -216,8 +216,8 @@ struct request {
 	unsigned int cmd_len;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	unsigned int raw_data_len;
 	unsigned int data_len;
+	unsigned int extra_len;
 	unsigned int sense_len;
 	void *data;
 	void *sense;
@@ -477,6 +477,11 @@ enum {
 
 #define rq_data_dir(rq)		((rq)->cmd_flags & 1)
 
+static inline unsigned int blk_rq_raw_data_len(struct request *rq)
+{
+	return rq->data_len - min(rq->extra_len, rq->data_len);
+}
+
 /*
  * We regard a request as sync, if it's a READ or a SYNC write.
  */

--------------080501060802020501010609--
