From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
	padding in favour of that provided by the block layer
Date: Mon, 04 Feb 2008 10:23:42 -0600
Message-ID: <1202142222.3096.26.camel@localhost.localdomain>
References: <1199138168.3110.12.camel@localhost.localdomain>
	 <1200698057.3111.68.camel@localhost.localdomain>
	 <1201894847.3134.59.camel@localhost.localdomain>
	 <47A37AF3.3030503@garzik.org>
	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>
	 <1202013174.3187.69.camel@localhost.localdomain>
	 <47A56F2B.4040904@gmail.com>
	 <1202049511.3318.13.camel@localhost.localdomain>
	 <47A5DA5F.3070209@gmail.com>
	 <1202055156.3318.58.camel@localhost.localdomain>
	 <47A66A39.7090800@gmail.com> <47A6D9F2.5060102@gmail.com>
	 <47A72475.5040106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47A72475.5040106@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-02-04 at 23:43 +0900, Tejun Heo wrote:
> And, here's working version.  I'll splite and post them tomorrow.
> 
> Thanks.
> 
> Index: work/block/blk-core.c
> ===================================================================
> --- work.orig/block/blk-core.c
> +++ work/block/blk-core.c
> @@ -116,6 +116,7 @@ void rq_init(struct request_queue *q, st
>  	rq->ref_count = 1;
>  	rq->q = q;
>  	rq->special = NULL;
> +	rq->raw_data_len = 0;
>  	rq->data_len = 0;
>  	rq->data = NULL;
>  	rq->nr_phys_segments = 0;
> @@ -1982,6 +1983,7 @@ void blk_rq_bio_prep(struct request_queu
>  	rq->hard_cur_sectors = rq->current_nr_sectors;
>  	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
>  	rq->buffer = bio_data(bio);
> +	rq->raw_data_len = bio->bi_size;
>  	rq->data_len = bio->bi_size;
>  
>  	rq->bio = rq->biotail = bio;
> Index: work/block/blk-map.c
> ===================================================================
> --- work.orig/block/blk-map.c
> +++ work/block/blk-map.c
> @@ -19,6 +19,7 @@ int blk_rq_append_bio(struct request_que
>  		rq->biotail->bi_next = bio;
>  		rq->biotail = bio;
>  
> +		rq->raw_data_len += bio->bi_size;
>  		rq->data_len += bio->bi_size;
>  	}
>  	return 0;
> @@ -139,6 +140,25 @@ int blk_rq_map_user(struct request_queue
>  		ubuf += ret;
>  	}
>  
> +	/*
> +	 * __blk_rq_map_user() copies the buffers if starting address
> +	 * or length aren't aligned.  As the copied buffer is always
> +	 * page aligned, we know for a fact that there's enough room
> +	 * for padding.  Extend the last bio and update rq->data_len
> +	 * accordingly.
> +	 *
> +	 * On unmap, bio_uncopy_user() will use unmodified
> +	 * bio_map_data pointed to by bio->bi_private.
> +	 */
> +	if (len & queue_dma_alignment(q)) {
> +		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
> +		struct bio *bio = rq->biotail;
> +
> +		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
> +		bio->bi_size += pad_len;
> +		rq->data_len += pad_len;
> +	}
> +
>  	rq->buffer = rq->data = NULL;
>  	return 0;
>  unmap_rq:
> Index: work/include/linux/blkdev.h
> ===================================================================
> --- work.orig/include/linux/blkdev.h
> +++ work/include/linux/blkdev.h
> @@ -214,6 +214,7 @@ struct request {
>  	unsigned int cmd_len;
>  	unsigned char cmd[BLK_MAX_CDB];
>  
> +	unsigned int raw_data_len;
>  	unsigned int data_len;
>  	unsigned int sense_len;
>  	void *data;

Please, no ... none of this is necessary.  You're wasting four bytes in
every request from a quantity we already know in the queue.

The point of the original code is that the drain is always waiting for
you silently in the sg list, but never shown in the length.  That means
it's entirely up to you whether you use it or ignore it.  It also means
that there's no need for the discriminating function in block, you
either do or don't use the drain element.

> @@ -256,6 +257,7 @@ struct bio_vec;
>  typedef int (merge_bvec_fn) (struct request_queue *, struct bio *, struct bio_vec *);
>  typedef void (prepare_flush_fn) (struct request_queue *, struct request *);
>  typedef void (softirq_done_fn)(struct request *);
> +typedef int (dma_drain_needed_fn)(struct request *);
>  
>  enum blk_queue_state {
>  	Queue_down,
> @@ -292,6 +294,7 @@ struct request_queue
>  	merge_bvec_fn		*merge_bvec_fn;
>  	prepare_flush_fn	*prepare_flush_fn;
>  	softirq_done_fn		*softirq_done_fn;
> +	dma_drain_needed_fn	*dma_drain_needed;

Like I said, not necessary because the MMC devices are all single
command queues, so for them, you simply apply the drain buffer the whole
time in block and decide whether to use it in the issue layer

>  	/*
>  	 * Dispatch queue sorting
> @@ -696,8 +699,9 @@ extern void blk_queue_max_hw_segments(st
>  extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
>  extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
>  extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
> -extern int blk_queue_dma_drain(struct request_queue *q, void *buf,
> -			       unsigned int size);
> +extern int blk_queue_dma_drain(struct request_queue *q,
> +			       dma_drain_needed_fn *dma_drain_needed,
> +			       void *buf, unsigned int size);
>  extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
>  extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
>  extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
> Index: work/block/blk-merge.c
> ===================================================================
> --- work.orig/block/blk-merge.c
> +++ work/block/blk-merge.c
> @@ -220,7 +220,7 @@ new_segment:
>  		bvprv = bvec;
>  	} /* segments in rq */
>  
> -	if (q->dma_drain_size) {
> +	if (q->dma_drain_size && q->dma_drain_needed(rq)) {
>  		sg->page_link &= ~0x02;
>  		sg = sg_next(sg);
>  		sg_set_page(sg, virt_to_page(q->dma_drain_buffer),
> @@ -228,6 +228,7 @@ new_segment:
>  			    ((unsigned long)q->dma_drain_buffer) &
>  			    (PAGE_SIZE - 1));
>  		nsegs++;
> +		rq->data_len += q->dma_drain_size;
>  	}
>  
>  	if (sg)
> Index: work/block/bsg.c
> ===================================================================
> --- work.orig/block/bsg.c
> +++ work/block/bsg.c
> @@ -437,14 +437,14 @@ static int blk_complete_sgv4_hdr_rq(stru
>  	}
>  
>  	if (rq->next_rq) {
> -		hdr->dout_resid = rq->data_len;
> -		hdr->din_resid = rq->next_rq->data_len;
> +		hdr->dout_resid = rq->raw_data_len;
> +		hdr->din_resid = rq->next_rq->raw_data_len;
>  		blk_rq_unmap_user(bidi_bio);
>  		blk_put_request(rq->next_rq);
>  	} else if (rq_data_dir(rq) == READ)
> -		hdr->din_resid = rq->data_len;
> +		hdr->din_resid = rq->raw_data_len;
>  	else
> -		hdr->dout_resid = rq->data_len;
> +		hdr->dout_resid = rq->raw_data_len;
>  
>  	/*
>  	 * If the request generated a negative error number, return it
> Index: work/block/scsi_ioctl.c
> ===================================================================
> --- work.orig/block/scsi_ioctl.c
> +++ work/block/scsi_ioctl.c
> @@ -266,7 +266,7 @@ static int blk_complete_sghdr_rq(struct 
>  	hdr->info = 0;
>  	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
>  		hdr->info |= SG_INFO_CHECK;
> -	hdr->resid = rq->data_len;
> +	hdr->resid = rq->raw_data_len;
>  	hdr->sb_len_wr = 0;
>  
>  	if (rq->sense_len && hdr->sbp) {
> @@ -528,6 +528,7 @@ static int __blk_send_generic(struct req
>  	rq = blk_get_request(q, WRITE, __GFP_WAIT);
>  	rq->cmd_type = REQ_TYPE_BLOCK_PC;
>  	rq->data = NULL;
> +	rq->raw_data_len = 0;
>  	rq->data_len = 0;
>  	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
>  	memset(rq->cmd, 0, sizeof(rq->cmd));
> Index: work/drivers/scsi/scsi_lib.c
> ===================================================================
> --- work.orig/drivers/scsi/scsi_lib.c
> +++ work/drivers/scsi/scsi_lib.c
> @@ -1015,10 +1015,6 @@ static int scsi_init_sgtable(struct requ
>  	}
>  
>  	req->buffer = NULL;
> -	if (blk_pc_request(req))
> -		sdb->length = req->data_len;
> -	else
> -		sdb->length = req->nr_sectors << 9;
>  
>  	/* 
>  	 * Next, walk the list, and fill in the addresses and sizes of
> @@ -1027,6 +1023,10 @@ static int scsi_init_sgtable(struct requ
>  	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
>  	BUG_ON(count > sdb->table.nents);
>  	sdb->table.nents = count;
> +	if (blk_pc_request(req))
> +		sdb->length = req->data_len;
> +	else
> +		sdb->length = req->nr_sectors << 9;
>  	return BLKPREP_OK;
>  }
>  
> Index: work/block/blk-settings.c
> ===================================================================
> --- work.orig/block/blk-settings.c
> +++ work/block/blk-settings.c
> @@ -296,6 +296,7 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
>   * blk_queue_dma_drain - Set up a drain buffer for excess dma.
>   *
>   * @q:  the request queue for the device
> + * @dma_drain_needed: fn which returns non-zero if drain is necessary
>   * @buf:	physically contiguous buffer
>   * @size:	size of the buffer in bytes
>   *
> @@ -315,14 +316,16 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
>   * device can support otherwise there won't be room for the drain
>   * buffer.
>   */
> -int blk_queue_dma_drain(struct request_queue *q, void *buf,
> -				unsigned int size)
> +extern int blk_queue_dma_drain(struct request_queue *q,
> +			       dma_drain_needed_fn *dma_drain_needed,
> +			       void *buf, unsigned int size)
>  {
>  	if (q->max_hw_segments < 2 || q->max_phys_segments < 2)
>  		return -EINVAL;
>  	/* make room for appending the drain */
>  	--q->max_hw_segments;
>  	--q->max_phys_segments;
> +	q->dma_drain_needed = dma_drain_needed;
>  	q->dma_drain_buffer = buf;
>  	q->dma_drain_size = size;

All of these block changes go away if you simply use the drain where
it's needed

> Index: work/drivers/scsi/sr.c
> ===================================================================
> --- work.orig/drivers/scsi/sr.c
> +++ work/drivers/scsi/sr.c
> @@ -557,11 +557,30 @@ static void sr_release(struct cdrom_devi
>  
>  }
>  
> +static int sr_drain_needed(struct request *rq)
> +{
> +	if (likely(!blk_pc_request(rq)))
> +		return 0;
> +
> +	switch (rq->cmd[0]) {
> +	case GPCMD_READ_10:
> +	case GPCMD_READ_12:
> +	case GPCMD_WRITE_10:
> +	case GPCMD_WRITE_12:
> +	case GPCMD_WRITE_AND_VERIFY_10:
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
>  static int sr_probe(struct device *dev)
>  {
>  	struct scsi_device *sdev = to_scsi_device(dev);
> +	struct request_queue *queue = sdev->request_queue;
>  	struct gendisk *disk;
> -	struct scsi_cd *cd;
> +	struct scsi_cd *cd = NULL;
> +	void *drain_buf = NULL;
>  	int minor, error;
>  
>  	error = -ENODEV;
> @@ -573,11 +592,15 @@ static int sr_probe(struct device *dev)
>  	if (!cd)
>  		goto fail;
>  
> +	drain_buf = kmalloc(SR_DRAIN_SIZE, queue->bounce_gfp | GFP_KERNEL);
> +	if (!drain_buf)
> +		goto fail;
> +
>  	kref_init(&cd->kref);
>  
>  	disk = alloc_disk(1);
>  	if (!disk)
> -		goto fail_free;
> +		goto fail;
>  
>  	spin_lock(&sr_index_lock);
>  	minor = find_first_zero_bit(sr_index_bits, SR_DISKS);
> @@ -615,13 +638,14 @@ static int sr_probe(struct device *dev)
>  
>  	/* FIXME: need to handle a get_capabilities failure properly ?? */
>  	get_capabilities(cd);
> -	blk_queue_prep_rq(sdev->request_queue, sr_prep_fn);
> +	blk_queue_prep_rq(queue, sr_prep_fn);
> +	blk_queue_dma_drain(queue, sr_drain_needed, drain_buf, SR_DRAIN_SIZE);
>  	sr_vendor_init(cd);
>  
>  	disk->driverfs_dev = &sdev->sdev_gendev;
>  	set_capacity(disk, cd->capacity);
>  	disk->private_data = &cd->driver;
> -	disk->queue = sdev->request_queue;
> +	disk->queue = queue;
>  	cd->cdi.disk = disk;
>  
>  	if (register_cdrom(&cd->cdi))
> @@ -637,9 +661,9 @@ static int sr_probe(struct device *dev)
>  
>  fail_put:
>  	put_disk(disk);
> -fail_free:
> -	kfree(cd);
>  fail:
> +	kfree(cd);
> +	kfree(drain_buf);
>  	return error;
>  }
>  
> @@ -894,6 +918,12 @@ static void sr_kref_release(struct kref 
>  static int sr_remove(struct device *dev)
>  {
>  	struct scsi_cd *cd = dev_get_drvdata(dev);
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	struct request_queue *queue = sdev->request_queue;
> +
> +	kfree(queue->dma_drain_buffer);
> +	queue->dma_drain_buffer = NULL;
> +	queue->dma_drain_size = 0;
>  
>  	del_gendisk(cd->disk);

This is basically all setup.  There's no actual changes for use.  Since
the only consumer of this is libata, all of this needs to be gated by
whether it's a libata device ... which really suggests it needs to be
done in libata.

Plus, tape devices are also ATAPI and since the problem seems to be
handling of ATAPI pio commands, they need all of this too.  It really
is, I think, better just to do the setup in the libata slave configure
if the device is atapi.

For all the rest, I think code demonstrates better ... well, except the
sata_fsl.c update ... you leave in qc->n_iter, but it's only ever set to
zero ... doesn't that cause this driver to break?

I analysed all the places you use the expanded data length.  To keep the
true length in the request and add the drain if necessary, I think
requires this update over my published libata drain patch.  I've also
added the request accessor to the drain buffer.  Could you verify this
actually works?  If it does, it's better than all the additions to block
and sr.  It would probably help to resend the series rebased against git
current.

James

---

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a28351c..acf6a8b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2496,6 +2496,8 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 
 	qc->tf.command = ATA_CMD_PACKET;
 	qc->nbytes = scsi_bufflen(scmd);
+	if (blk_pc_request(scmd->request))
+		qc->nbytes += blk_rq_drain_size(scmd->request);
 
 	/* check whether ATAPI DMA is safe */
 	if (!using_pio && ata_check_atapi_dma(qc))
@@ -2832,6 +2834,8 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	 *       cover scatter/gather case.
 	 */
 	qc->nbytes = scsi_bufflen(scmd);
+	if (ata_is_atapi(qc->tf.protocol))
+		qc->nbytes += blk_rq_drain_size(scmd->request);
 
 	/* request result TF and be quiet about device error */
 	qc->flags |= ATA_QCFLAG_RESULT_TF | ATA_QCFLAG_QUIET;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 90392a9..a526066 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -676,6 +676,11 @@ extern void blk_complete_request(struct request *);
 extern unsigned int blk_rq_bytes(struct request *rq);
 extern unsigned int blk_rq_cur_bytes(struct request *rq);
 
+static inline int blk_rq_drain_size(struct request *rq)
+{
+	return rq->q->dma_drain_size;
+}
+
 static inline void blkdev_dequeue_request(struct request *req)
 {
 	elv_dequeue_request(req->q, req);



