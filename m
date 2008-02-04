From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
 padding in favour of that provided by the block layer
Date: Mon, 04 Feb 2008 18:25:06 +0900
Message-ID: <47A6D9F2.5060102@gmail.com>
References: <1199138168.3110.12.camel@localhost.localdomain>	 <1200698057.3111.68.camel@localhost.localdomain>	 <1201894847.3134.59.camel@localhost.localdomain>	 <47A37AF3.3030503@garzik.org>	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>	 <1202013174.3187.69.camel@localhost.localdomain>	 <47A56F2B.4040904@gmail.com>	 <1202049511.3318.13.camel@localhost.localdomain>	 <47A5DA5F.3070209@gmail.com> <1202055156.3318.58.camel@localhost.localdomain> <47A66A39.7090800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:8398 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbYBDJZP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 04:25:15 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1429668rvb.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Feb 2008 01:25:13 -0800 (PST)
In-Reply-To: <47A66A39.7090800@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Tejun Heo wrote:
> Some ATA controllers including SFF BMDMA and libata PIO HSM need the
> number of bytes mapped in the sg table.  Yeah, it can be calculated with
> a simple macro but it also is a fundamentally confusing dual-sizing
> which should be made as clear as possible.  Plus, it can be difficult to
> find out when somebody used the wrong thing, so what I'm saying is that
> we need to make it easy.  Anyways, please lemme work on it a bit.  I'll
> get back to you guys soon.

Okay, here's first draft combined patch.  Only compile tested (expect
it to be broken) but it should be functionally equivalent to
ata_sg_setup_extra() based implementation albeit with shorter drain
buffer size.  Several things to note...

* fsl last sg check isn't included here.  Will split it out and post
  it separately.

* rq->raw_data_len added.  Rationales...

  - All these padding and draining are to prevent controllers from
    crapping themselves when data buffer is shorter than it likes it
    to be.  Any controller which talks MMC (or SPC for that matter)
    should be ready for transfers shorter than buffer so feeding
    enlarged buffer size is inherently safter than feeding the length,
    so the primary data length field, rq->data_len, contains the
    adjusted length.

  - raw_data_len can't be easily deduced from data_len.  The other way
    is possible but with both aligning and draining and command
    filtering, calculating it later is messy.

* Draining configuration is done in sr as it's the driver for MMC.  It
  can move both ways - either into SCSI midlayer as SPC and other
  commands do variable length responses too or into libata if all
  non-ATA controllers are happy without such workarounds.  If you ask
  me, I'm inclined to move it into SCSI midlayer as the added overhead
  is insignificant (especially with drain_needed added) and it won't
  break anything (well, theoretically, at least).

* Padding via alinging seems a bit too hacky to me.  It doesn't even
  cover all sg cases.  I think we'll need improvements there, well,
  but for the time being, this should do.

I'll test and report in a few hours.

Thanks.

Index: work/block/blk-core.c
===================================================================
--- work.orig/block/blk-core.c
+++ work/block/blk-core.c
@@ -116,6 +116,7 @@ void rq_init(struct request_queue *q, st
 	rq->ref_count = 1;
 	rq->q = q;
 	rq->special = NULL;
+	rq->raw_data_len = 0;
 	rq->data_len = 0;
 	rq->data = NULL;
 	rq->nr_phys_segments = 0;
@@ -1982,6 +1983,7 @@ void blk_rq_bio_prep(struct request_queu
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->buffer = bio_data(bio);
+	rq->raw_data_len = bio->bi_size;
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
Index: work/block/blk-map.c
===================================================================
--- work.orig/block/blk-map.c
+++ work/block/blk-map.c
@@ -19,6 +19,7 @@ int blk_rq_append_bio(struct request_que
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
+		rq->raw_data_len += bio->bi_size;
 		rq->data_len += bio->bi_size;
 	}
 	return 0;
@@ -56,8 +57,10 @@ static int __blk_rq_map_user(struct requ
 	if (!(uaddr & queue_dma_alignment(q)) &&
 	    !(len & queue_dma_alignment(q)))
 		bio = bio_map_user(q, NULL, uaddr, len, reading);
-	else
+	else {
 		bio = bio_copy_user(q, uaddr, len, reading);
+		rq->data_len = roundup(len, queue_dma_alignment(q));
+	}
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
Index: work/include/linux/blkdev.h
===================================================================
--- work.orig/include/linux/blkdev.h
+++ work/include/linux/blkdev.h
@@ -214,6 +214,7 @@ struct request {
 	unsigned int cmd_len;
 	unsigned char cmd[BLK_MAX_CDB];
 
+	unsigned int raw_data_len;
 	unsigned int data_len;
 	unsigned int sense_len;
 	void *data;
@@ -256,6 +257,7 @@ struct bio_vec;
 typedef int (merge_bvec_fn) (struct request_queue *, struct bio *, struct bio_vec *);
 typedef void (prepare_flush_fn) (struct request_queue *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
+typedef int (dma_drain_needed_fn)(struct request *);
 
 enum blk_queue_state {
 	Queue_down,
@@ -292,6 +294,7 @@ struct request_queue
 	merge_bvec_fn		*merge_bvec_fn;
 	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
+	dma_drain_needed_fn	*dma_drain_needed;
 
 	/*
 	 * Dispatch queue sorting
@@ -696,8 +699,9 @@ extern void blk_queue_max_hw_segments(st
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
-extern int blk_queue_dma_drain(struct request_queue *q, void *buf,
-			       unsigned int size);
+extern int blk_queue_dma_drain(struct request_queue *q,
+			       dma_drain_needed_fn *dma_drain_needed,
+			       void *buf, unsigned int size);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
Index: work/block/blk-merge.c
===================================================================
--- work.orig/block/blk-merge.c
+++ work/block/blk-merge.c
@@ -220,7 +220,7 @@ new_segment:
 		bvprv = bvec;
 	} /* segments in rq */
 
-	if (q->dma_drain_size) {
+	if (q->dma_drain_size && q->dma_drain_needed(rq)) {
 		sg->page_link &= ~0x02;
 		sg = sg_next(sg);
 		sg_set_page(sg, virt_to_page(q->dma_drain_buffer),
@@ -228,6 +228,7 @@ new_segment:
 			    ((unsigned long)q->dma_drain_buffer) &
 			    (PAGE_SIZE - 1));
 		nsegs++;
+		rq->data_len += q->dma_drain_size;
 	}
 
 	if (sg)
Index: work/block/bsg.c
===================================================================
--- work.orig/block/bsg.c
+++ work/block/bsg.c
@@ -437,14 +437,14 @@ static int blk_complete_sgv4_hdr_rq(stru
 	}
 
 	if (rq->next_rq) {
-		hdr->dout_resid = rq->data_len;
-		hdr->din_resid = rq->next_rq->data_len;
+		hdr->dout_resid = rq->raw_data_len;
+		hdr->din_resid = rq->next_rq->raw_data_len;
 		blk_rq_unmap_user(bidi_bio);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
-		hdr->din_resid = rq->data_len;
+		hdr->din_resid = rq->raw_data_len;
 	else
-		hdr->dout_resid = rq->data_len;
+		hdr->dout_resid = rq->raw_data_len;
 
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
-	hdr->resid = rq->data_len;
+	hdr->resid = rq->raw_data_len;
 	hdr->sb_len_wr = 0;
 
 	if (rq->sense_len && hdr->sbp) {
@@ -528,6 +528,7 @@ static int __blk_send_generic(struct req
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->data = NULL;
+	rq->raw_data_len = 0;
 	rq->data_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	memset(rq->cmd, 0, sizeof(rq->cmd));
Index: work/block/blk-settings.c
===================================================================
--- work.orig/block/blk-settings.c
+++ work/block/blk-settings.c
@@ -296,6 +296,7 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
  * blk_queue_dma_drain - Set up a drain buffer for excess dma.
  *
  * @q:  the request queue for the device
+ * @drain_needed: fn which returns non-zero if drain is needed for the request
  * @buf:	physically contiguous buffer
  * @size:	size of the buffer in bytes
  *
@@ -315,14 +316,16 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
  * device can support otherwise there won't be room for the drain
  * buffer.
  */
-int blk_queue_dma_drain(struct request_queue *q, void *buf,
-				unsigned int size)
+extern int blk_queue_dma_drain(struct request_queue *q,
+			       dma_drain_needed_fn *dma_drain_needed,
+			       void *buf, unsigned int size)
 {
 	if (q->max_hw_segments < 2 || q->max_phys_segments < 2)
 		return -EINVAL;
 	/* make room for appending the drain */
 	--q->max_hw_segments;
 	--q->max_phys_segments;
+	q->dma_drain_needed = dma_drain_needed;
 	q->dma_drain_buffer = buf;
 	q->dma_drain_size = size;
 
Index: work/drivers/scsi/sr.c
===================================================================
--- work.orig/drivers/scsi/sr.c
+++ work/drivers/scsi/sr.c
@@ -557,11 +557,30 @@ static void sr_release(struct cdrom_devi
 
 }
 
+static int sr_drain_needed(struct request *rq)
+{
+	if (likely(!blk_pc_request(rq)))
+		return 0;
+
+	switch (rq->cmd[0]) {
+	case GPCMD_READ_10:
+	case GPCMD_READ_12:
+	case GPCMD_WRITE_10:
+	case GPCMD_WRITE_12:
+	case GPCMD_WRITE_AND_VERIFY_10:
+		return 0;
+	}
+
+	return 1;
+}
+
 static int sr_probe(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
+	struct request_queue *queue = sdev->request_queue;
 	struct gendisk *disk;
-	struct scsi_cd *cd;
+	struct scsi_cd *cd = NULL;
+	void *drain_buf = NULL;
 	int minor, error;
 
 	error = -ENODEV;
@@ -573,11 +592,15 @@ static int sr_probe(struct device *dev)
 	if (!cd)
 		goto fail;
 
+	drain_buf = kmalloc(SR_DRAIN_SIZE, queue->bounce_gfp | GFP_KERNEL);
+	if (!drain_buf)
+		goto fail;
+
 	kref_init(&cd->kref);
 
 	disk = alloc_disk(1);
 	if (!disk)
-		goto fail_free;
+		goto fail;
 
 	spin_lock(&sr_index_lock);
 	minor = find_first_zero_bit(sr_index_bits, SR_DISKS);
@@ -615,13 +638,14 @@ static int sr_probe(struct device *dev)
 
 	/* FIXME: need to handle a get_capabilities failure properly ?? */
 	get_capabilities(cd);
-	blk_queue_prep_rq(sdev->request_queue, sr_prep_fn);
+	blk_queue_prep_rq(queue, sr_prep_fn);
+	blk_queue_dma_drain(queue, sr_drain_needed, drain_buf, SR_DRAIN_SIZE);
 	sr_vendor_init(cd);
 
 	disk->driverfs_dev = &sdev->sdev_gendev;
 	set_capacity(disk, cd->capacity);
 	disk->private_data = &cd->driver;
-	disk->queue = sdev->request_queue;
+	disk->queue = queue;
 	cd->cdi.disk = disk;
 
 	if (register_cdrom(&cd->cdi))
@@ -637,9 +661,9 @@ static int sr_probe(struct device *dev)
 
 fail_put:
 	put_disk(disk);
-fail_free:
-	kfree(cd);
 fail:
+	kfree(cd);
+	kfree(drain_buf);
 	return error;
 }
 
@@ -894,6 +918,12 @@ static void sr_kref_release(struct kref 
 static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct request_queue *queue = sdev->request_queue;
+
+	kfree(queue->dma_drain_buffer);
+	queue->dma_drain_buffer = NULL;
+	queue->dma_drain_size = 0;
 
 	del_gendisk(cd->disk);
 
Index: work/drivers/scsi/sr.h
===================================================================
--- work.orig/drivers/scsi/sr.h
+++ work/drivers/scsi/sr.h
@@ -22,6 +22,7 @@
 
 #define MAX_RETRIES	3
 #define SR_TIMEOUT	(30 * HZ)
+#define SR_DRAIN_SIZE	PAGE_SIZE
 
 struct scsi_device;
 
Index: work/drivers/ata/libata-core.c
===================================================================
--- work.orig/drivers/ata/libata-core.c
+++ work/drivers/ata/libata-core.c
@@ -4476,30 +4476,13 @@ void ata_sg_clean(struct ata_queued_cmd 
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg = qc->sg;
 	int dir = qc->dma_dir;
-	void *pad_buf = NULL;
 
 	WARN_ON(sg == NULL);
 
-	VPRINTK("unmapping %u sg elements\n", qc->mapped_n_elem);
+	VPRINTK("unmapping %u sg elements\n", qc->n_elem);
 
-	/* if we padded the buffer out to 32-bit bound, and data
-	 * xfer direction is from-device, we must copy from the
-	 * pad buffer back into the supplied buffer
-	 */
-	if (qc->pad_len && !(qc->tf.flags & ATA_TFLAG_WRITE))
-		pad_buf = ap->pad + (qc->tag * ATA_DMA_PAD_SZ);
-
-	if (qc->mapped_n_elem)
-		dma_unmap_sg(ap->dev, sg, qc->mapped_n_elem, dir);
-	/* restore last sg */
-	if (qc->last_sg)
-		*qc->last_sg = qc->saved_last_sg;
-	if (pad_buf) {
-		struct scatterlist *psg = &qc->extra_sg[1];
-		void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
-		memcpy(addr + psg->offset, pad_buf, qc->pad_len);
-		kunmap_atomic(addr, KM_IRQ0);
-	}
+	if (qc->n_elem)
+		dma_unmap_sg(ap->dev, sg, qc->n_elem, dir);
 
 	qc->flags &= ~ATA_QCFLAG_DMAMAP;
 	qc->sg = NULL;
@@ -4765,97 +4748,6 @@ void ata_sg_init(struct ata_queued_cmd *
 	qc->cursg = qc->sg;
 }
 
-static unsigned int ata_sg_setup_extra(struct ata_queued_cmd *qc,
-				       unsigned int *n_elem_extra,
-				       unsigned int *nbytes_extra)
-{
-	struct ata_port *ap = qc->ap;
-	unsigned int n_elem = qc->n_elem;
-	struct scatterlist *lsg, *copy_lsg = NULL, *tsg = NULL, *esg = NULL;
-
-	*n_elem_extra = 0;
-	*nbytes_extra = 0;
-
-	/* needs padding? */
-	qc->pad_len = qc->nbytes & 3;
-
-	if (likely(!qc->pad_len))
-		return n_elem;
-
-	/* locate last sg and save it */
-	lsg = sg_last(qc->sg, n_elem);
-	qc->last_sg = lsg;
-	qc->saved_last_sg = *lsg;
-
-	sg_init_table(qc->extra_sg, ARRAY_SIZE(qc->extra_sg));
-
-	if (qc->pad_len) {
-		struct scatterlist *psg = &qc->extra_sg[1];
-		void *pad_buf = ap->pad + (qc->tag * ATA_DMA_PAD_SZ);
-		unsigned int offset;
-
-		WARN_ON(qc->dev->class != ATA_DEV_ATAPI);
-
-		memset(pad_buf, 0, ATA_DMA_PAD_SZ);
-
-		/* psg->page/offset are used to copy to-be-written
-		 * data in this function or read data in ata_sg_clean.
-		 */
-		offset = lsg->offset + lsg->length - qc->pad_len;
-		sg_set_page(psg, nth_page(sg_page(lsg), offset >> PAGE_SHIFT),
-			    qc->pad_len, offset_in_page(offset));
-
-		if (qc->tf.flags & ATA_TFLAG_WRITE) {
-			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
-			memcpy(pad_buf, addr + psg->offset, qc->pad_len);
-			kunmap_atomic(addr, KM_IRQ0);
-		}
-
-		sg_dma_address(psg) = ap->pad_dma + (qc->tag * ATA_DMA_PAD_SZ);
-		sg_dma_len(psg) = ATA_DMA_PAD_SZ;
-
-		/* Trim the last sg entry and chain the original and
-		 * padding sg lists.
-		 *
-		 * Because chaining consumes one sg entry, one extra
-		 * sg entry is allocated and the last sg entry is
-		 * copied to it if the length isn't zero after padded
-		 * amount is removed.
-		 *
-		 * If the last sg entry is completely replaced by
-		 * padding sg entry, the first sg entry is skipped
-		 * while chaining.
-		 */
-		lsg->length -= qc->pad_len;
-		if (lsg->length) {
-			copy_lsg = &qc->extra_sg[0];
-			tsg = &qc->extra_sg[0];
-		} else {
-			n_elem--;
-			tsg = &qc->extra_sg[1];
-		}
-
-		esg = &qc->extra_sg[1];
-
-		(*n_elem_extra)++;
-		(*nbytes_extra) += 4 - qc->pad_len;
-	}
-
-	if (copy_lsg)
-		sg_set_page(copy_lsg, sg_page(lsg), lsg->length, lsg->offset);
-
-	sg_chain(lsg, 1, tsg);
-	sg_mark_end(esg);
-
-	/* sglist can't start with chaining sg entry, fast forward */
-	if (qc->sg == lsg) {
-		qc->sg = tsg;
-		qc->cursg = tsg;
-	}
-
-	return n_elem;
-}
-
 /**
  *	ata_sg_setup - DMA-map the scatter-gather table associated with a command.
  *	@qc: Command with scatter-gather table to be mapped.
@@ -4872,26 +4764,15 @@ static unsigned int ata_sg_setup_extra(s
 static int ata_sg_setup(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	unsigned int n_elem, n_elem_extra, nbytes_extra;
 
 	VPRINTK("ENTER, ata%u\n", ap->print_id);
 
-	n_elem = ata_sg_setup_extra(qc, &n_elem_extra, &nbytes_extra);
+	qc->n_elem = dma_map_sg(ap->dev, qc->sg, qc->n_elem, qc->dma_dir);
+	if (qc->n_elem < 1)
+		return -1;
 
-	if (n_elem) {
-		n_elem = dma_map_sg(ap->dev, qc->sg, n_elem, qc->dma_dir);
-		if (n_elem < 1) {
-			/* restore last sg */
-			if (qc->last_sg)
-				*qc->last_sg = qc->saved_last_sg;
-			return -1;
-		}
-		DPRINTK("%d sg elements mapped\n", n_elem);
-	}
+	DPRINTK("%d sg elements mapped\n", n_elem);
 
-	qc->n_elem = qc->mapped_n_elem = n_elem;
-	qc->n_elem += n_elem_extra;
-	qc->nbytes += nbytes_extra;
 	qc->flags |= ATA_QCFLAG_DMAMAP;
 
 	return 0;
@@ -6566,19 +6447,12 @@ void ata_host_resume(struct ata_host *ho
 int ata_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->dev;
-	int rc;
 
 	ap->prd = dmam_alloc_coherent(dev, ATA_PRD_TBL_SZ, &ap->prd_dma,
 				      GFP_KERNEL);
 	if (!ap->prd)
 		return -ENOMEM;
 
-	rc = ata_pad_alloc(ap, dev);
-	if (rc)
-		return rc;
-
-	DPRINTK("prd alloc, virt %p, dma %llx\n", ap->prd,
-		(unsigned long long)ap->prd_dma);
 	return 0;
 }
 
Index: work/drivers/ata/libata-scsi.c
===================================================================
--- work.orig/drivers/ata/libata-scsi.c
+++ work/drivers/ata/libata-scsi.c
@@ -832,18 +832,11 @@ static void ata_scsi_dev_config(struct s
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
-	/* SATA DMA transfers must be multiples of 4 byte, so
-	 * we need to pad ATAPI transfers using an extra sg.
-	 * Decrement max hw segments accordingly.
-	 */
-	if (dev->class == ATA_DEV_ATAPI) {
-		struct request_queue *q = sdev->request_queue;
-		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
-
+	if (dev->class == ATA_DEV_ATAPI)
 		/* set the min alignment */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_DMA_PAD_SZ - 1);
-	} else
+	else
 		/* ATA devices must be sector aligned */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_SECT_SIZE - 1);
@@ -2500,7 +2493,7 @@ static unsigned int atapi_xlat(struct at
 	 * want to set it properly, and for DMA where it is
 	 * effectively meaningless.
 	 */
-	nbytes = min(qc->nbytes, (unsigned int)63 * 1024);
+	nbytes = min(scmd->request->raw_data_len, (unsigned int)63 * 1024);
 
 	/* Most ATAPI devices which honor transfer chunk size don't
 	 * behave according to the spec when odd chunk size which
@@ -3564,7 +3557,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
  */
 int ata_sas_port_start(struct ata_port *ap)
 {
-	return ata_pad_alloc(ap, ap->dev);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_start);
 
@@ -3582,7 +3575,6 @@ EXPORT_SYMBOL_GPL(ata_sas_port_start);
 
 void ata_sas_port_stop(struct ata_port *ap)
 {
-	ata_pad_free(ap, ap->dev);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_stop);
 
Index: work/drivers/ata/sata_fsl.c
===================================================================
--- work.orig/drivers/ata/sata_fsl.c
+++ work/drivers/ata/sata_fsl.c
@@ -601,21 +601,9 @@ static int sata_fsl_port_start(struct at
 	if (!pp)
 		return -ENOMEM;
 
-	/*
-	 * allocate per command dma alignment pad buffer, which is used
-	 * internally by libATA to ensure that all transfers ending on
-	 * unaligned boundaries are padded, to align on Dword boundaries
-	 */
-	retval = ata_pad_alloc(ap, dev);
-	if (retval) {
-		kfree(pp);
-		return retval;
-	}
-
 	mem = dma_alloc_coherent(dev, SATA_FSL_PORT_PRIV_DMA_SZ, &mem_dma,
 				 GFP_KERNEL);
 	if (!mem) {
-		ata_pad_free(ap, dev);
 		kfree(pp);
 		return -ENOMEM;
 	}
@@ -694,7 +682,6 @@ static void sata_fsl_port_stop(struct at
 	dma_free_coherent(dev, SATA_FSL_PORT_PRIV_DMA_SZ,
 			  pp->cmdslot, pp->cmdslot_paddr);
 
-	ata_pad_free(ap, dev);
 	kfree(pp);
 }
 
Index: work/drivers/ata/sata_mv.c
===================================================================
--- work.orig/drivers/ata/sata_mv.c
+++ work/drivers/ata/sata_mv.c
@@ -1157,17 +1157,13 @@ static int mv_port_start(struct ata_port
 	struct mv_port_priv *pp;
 	void __iomem *port_mmio = mv_ap_base(ap);
 	unsigned long flags;
-	int tag, rc;
+	int tag;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
 		return -ENOMEM;
 	ap->private_data = pp;
 
-	rc = ata_pad_alloc(ap, dev);
-	if (rc)
-		return rc;
-
 	pp->crqb = dma_pool_alloc(hpriv->crqb_pool, GFP_KERNEL, &pp->crqb_dma);
 	if (!pp->crqb)
 		return -ENOMEM;
Index: work/drivers/ata/sata_sil24.c
===================================================================
--- work.orig/drivers/ata/sata_sil24.c
+++ work/drivers/ata/sata_sil24.c
@@ -1234,7 +1234,6 @@ static int sil24_port_start(struct ata_p
 	union sil24_cmd_block *cb;
 	size_t cb_size = sizeof(*cb) * SIL24_MAX_CMDS;
 	dma_addr_t cb_dma;
-	int rc;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
@@ -1247,10 +1246,6 @@ static int sil24_port_start(struct ata_p
 		return -ENOMEM;
 	memset(cb, 0, cb_size);
 
-	rc = ata_pad_alloc(ap, dev);
-	if (rc)
-		return rc;
-
 	pp->cmd_block = cb;
 	pp->cmd_block_dma = cb_dma;
 
Index: work/include/linux/libata.h
===================================================================
--- work.orig/include/linux/libata.h
+++ work/include/linux/libata.h
@@ -278,7 +278,6 @@ enum {
 
 	/* size of buffer to pad xfers ending on unaligned boundaries */
 	ATA_DMA_PAD_SZ		= 4,
-	ATA_DMA_PAD_BUF_SZ	= ATA_DMA_PAD_SZ * ATA_MAX_QUEUE,
 
 	/* ering size */
 	ATA_ERING_SIZE		= 32,
@@ -458,11 +457,9 @@ struct ata_queued_cmd {
 	unsigned int		tag;
 	unsigned int		n_elem;
 	unsigned int		n_iter;
-	unsigned int		mapped_n_elem;
 
 	int			dma_dir;
 
-	unsigned int		pad_len;
 	unsigned int		sect_size;
 
 	unsigned int		nbytes;
@@ -473,9 +470,7 @@ struct ata_queued_cmd {
 	unsigned int		cursg_ofs;
 
 	struct scatterlist	*last_sg;
-	struct scatterlist	saved_last_sg;
 	struct scatterlist	sgent;
-	struct scatterlist	extra_sg[2];
 
 	struct scatterlist	*sg;
 
@@ -620,9 +615,6 @@ struct ata_port {
 	struct ata_prd		*prd;	 /* our SG list */
 	dma_addr_t		prd_dma; /* and its DMA mapping */
 
-	void			*pad;	/* array of DMA pad buffers */
-	dma_addr_t		pad_dma;
-
 	struct ata_ioports	ioaddr;	/* ATA cmd/ctl/dma register blocks */
 
 	u8			ctl;	/* cache of ATA control register */
@@ -1366,10 +1358,8 @@ static inline void ata_qc_reinit(struct 
 	qc->cursg_ofs = 0;
 	qc->nbytes = qc->raw_nbytes = qc->curbytes = 0;
 	qc->n_elem = 0;
-	qc->mapped_n_elem = 0;
 	qc->n_iter = 0;
 	qc->err_mask = 0;
-	qc->pad_len = 0;
 	qc->last_sg = NULL;
 	qc->sect_size = ATA_SECT_SIZE;
 
@@ -1425,19 +1415,6 @@ static inline unsigned int __ac_err_mask
 	return mask;
 }
 
-static inline int ata_pad_alloc(struct ata_port *ap, struct device *dev)
-{
-	ap->pad_dma = 0;
-	ap->pad = dmam_alloc_coherent(dev, ATA_DMA_PAD_BUF_SZ,
-				      &ap->pad_dma, GFP_KERNEL);
-	return (ap->pad == NULL) ? -ENOMEM : 0;
-}
-
-static inline void ata_pad_free(struct ata_port *ap, struct device *dev)
-{
-	dmam_free_coherent(dev, ATA_DMA_PAD_BUF_SZ, ap->pad, ap->pad_dma);
-}
-
 static inline struct ata_port *ata_shost_to_port(struct Scsi_Host *host)
 {
 	return *(struct ata_port **)&host->hostdata[0];
Index: work/drivers/scsi/libsas/sas_ata.c
===================================================================
--- work.orig/drivers/scsi/libsas/sas_ata.c
+++ work/drivers/scsi/libsas/sas_ata.c
@@ -178,8 +178,8 @@ static unsigned int sas_ata_qc_issue(str
 	task->uldd_task = qc;
 	if (ata_is_atapi(qc->tf.protocol)) {
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
-		task->total_xfer_len = qc->nbytes + qc->pad_len;
-		task->num_scatter = qc->pad_len ? qc->n_elem + 1 : qc->n_elem;
+		task->total_xfer_len = qc->nbytes;
+		task->num_scatter = qc->n_elem;
 	} else {
 		for_each_sg(qc->sg, sg, qc->n_elem, si)
 			xfer += sg->length;
Index: work/drivers/scsi/ipr.c
===================================================================
--- work.orig/drivers/scsi/ipr.c
+++ work/drivers/scsi/ipr.c
@@ -5140,7 +5140,7 @@ static void ipr_build_ata_ioadl(struct i
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
 	struct ipr_ioadl_desc *last_ioadl = NULL;
-	int len = qc->nbytes + qc->pad_len;
+	int len = qc->nbytes;
 	struct scatterlist *sg;
 	unsigned int si;
 
@@ -5206,7 +5206,7 @@ static unsigned int ipr_qc_issue(struct 
 	ioarcb->cmd_pkt.request_type = IPR_RQTYPE_ATA_PASSTHRU;
 	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
 	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
-	ipr_cmd->dma_use_sg = qc->pad_len ? qc->n_elem + 1 : qc->n_elem;
+	ipr_cmd->dma_use_sg = qc->n_elem;
 
 	ipr_build_ata_ioadl(ipr_cmd, qc);
 	regs->flags |= IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION;
Index: work/drivers/ata/ahci.c
===================================================================
--- work.orig/drivers/ata/ahci.c
+++ work/drivers/ata/ahci.c
@@ -1979,16 +1979,11 @@ static int ahci_port_start(struct ata_po
 	struct ahci_port_priv *pp;
 	void *mem;
 	dma_addr_t mem_dma;
-	int rc;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
 		return -ENOMEM;
 
-	rc = ata_pad_alloc(ap, dev);
-	if (rc)
-		return rc;
-
 	mem = dmam_alloc_coherent(dev, AHCI_PORT_PRIV_DMA_SZ, &mem_dma,
 				  GFP_KERNEL);
 	if (!mem)
Index: work/drivers/ata/pata_icside.c
===================================================================
--- work.orig/drivers/ata/pata_icside.c
+++ work/drivers/ata/pata_icside.c
@@ -304,12 +304,6 @@ static int icside_dma_init(struct pata_i
 }
 
 
-static int pata_icside_port_start(struct ata_port *ap)
-{
-	/* No PRD to alloc */
-	return ata_pad_alloc(ap, ap->dev);
-}
-
 static struct scsi_host_template pata_icside_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -389,8 +383,6 @@ static struct ata_port_operations pata_i
 	.irq_clear		= ata_dummy_noret,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= pata_icside_port_start,
-
 	.bmdma_stop		= pata_icside_bmdma_stop,
 	.bmdma_status		= pata_icside_bmdma_status,
 };
