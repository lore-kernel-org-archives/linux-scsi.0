From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 6/7] sg_ring: libata simplification
Date: Wed, 19 Dec 2007 18:37:04 +1100
Message-ID: <200712191837.04697.rusty@rustcorp.com.au>
References: <200712191731.26512.rusty@rustcorp.com.au> <200712191834.42457.rusty@rustcorp.com.au> <200712191836.06769.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200712191836.06769.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[This patch has been obsoleted: Tejun has a more complete one, but
it's not in mainline yet, so this serves to make the next patch
apply].

libata separates the single buffer case from the scatterlist case
internally.  It's not clear that this is necessary.

Remove the ATA_QCFLAG_SINGLE flag, and buf_virt pointer, and always
initialize qc->nbytes in ata_sg_init().

It's possible that the ATA_QCFLAG_SG and ATA_QCFLAG_DMAMAP flags could
be entirely removed, and we could use whether qc->__sg is NULL or not.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 8b1075c7ad47 drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c	Tue Nov 13 21:00:47 2007 +1100
+++ b/drivers/ata/libata-core.c	Wed Nov 14 15:31:07 2007 +1100
@@ -1648,16 +1648,8 @@ unsigned ata_exec_internal_sg(struct ata
 		memcpy(qc->cdb, cdb, ATAPI_CDB_LEN);
 	qc->flags |= ATA_QCFLAG_RESULT_TF;
 	qc->dma_dir = dma_dir;
-	if (dma_dir != DMA_NONE) {
-		unsigned int i, buflen = 0;
-		struct scatterlist *sg;
-
-		for_each_sg(sgl, sg, n_elem, i)
-			buflen += sg->length;
-
+	if (dma_dir != DMA_NONE)
 		ata_sg_init(qc, sgl, n_elem);
-		qc->nbytes = buflen;
-	}
 
 	qc->private_data = &wait;
 	qc->complete_fn = ata_qc_complete_internal;
@@ -4543,9 +4535,6 @@ void ata_sg_clean(struct ata_queued_cmd 
 	WARN_ON(!(qc->flags & ATA_QCFLAG_DMAMAP));
 	WARN_ON(sg == NULL);
 
-	if (qc->flags & ATA_QCFLAG_SINGLE)
-		WARN_ON(qc->n_elem > 1);
-
 	VPRINTK("unmapping %u sg elements\n", qc->n_elem);
 
 	/* if we padded the buffer out to 32-bit bound, and data
@@ -4566,16 +4555,6 @@ void ata_sg_clean(struct ata_queued_cmd 
 			memcpy(addr + psg->offset, pad_buf, qc->pad_len);
 			kunmap_atomic(addr, KM_IRQ0);
 		}
-	} else {
-		if (qc->n_elem)
-			dma_unmap_single(ap->dev,
-				sg_dma_address(&sg[0]), sg_dma_len(&sg[0]),
-				dir);
-		/* restore sg */
-		sg->length += qc->pad_len;
-		if (pad_buf)
-			memcpy(qc->buf_virt + sg->length - qc->pad_len,
-			       pad_buf, qc->pad_len);
 	}
 
 	qc->flags &= ~ATA_QCFLAG_DMAMAP;
@@ -4807,16 +4786,8 @@ void ata_noop_qc_prep(struct ata_queued_
 
 void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf, unsigned int buflen)
 {
-	qc->flags |= ATA_QCFLAG_SINGLE;
-
-	qc->__sg = &qc->sgent;
-	qc->n_elem = 1;
-	qc->orig_n_elem = 1;
-	qc->buf_virt = buf;
-	qc->nbytes = buflen;
-	qc->cursg = qc->__sg;
-
 	sg_init_one(&qc->sgent, buf, buflen);
+	ata_sg_init(qc, &qc->sgent, 1);
 }
 
 /**
@@ -4841,75 +4813,13 @@ void ata_sg_init(struct ata_queued_cmd *
 	qc->n_elem = n_elem;
 	qc->orig_n_elem = n_elem;
 	qc->cursg = qc->__sg;
-}
-
-/**
- *	ata_sg_setup_one - DMA-map the memory buffer associated with a command.
- *	@qc: Command with memory buffer to be mapped.
- *
- *	DMA-map the memory buffer associated with queued_cmd @qc.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- *
- *	RETURNS:
- *	Zero on success, negative on error.
- */
-
-static int ata_sg_setup_one(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	int dir = qc->dma_dir;
-	struct scatterlist *sg = qc->__sg;
-	dma_addr_t dma_address;
-	int trim_sg = 0;
-
-	/* we must lengthen transfers to end on a 32-bit boundary */
-	qc->pad_len = sg->length & 3;
-	if (qc->pad_len) {
-		void *pad_buf = ap->pad + (qc->tag * ATA_DMA_PAD_SZ);
-		struct scatterlist *psg = &qc->pad_sgent;
-
-		WARN_ON(qc->dev->class != ATA_DEV_ATAPI);
-
-		memset(pad_buf, 0, ATA_DMA_PAD_SZ);
-
-		if (qc->tf.flags & ATA_TFLAG_WRITE)
-			memcpy(pad_buf, qc->buf_virt + sg->length - qc->pad_len,
-			       qc->pad_len);
-
-		sg_dma_address(psg) = ap->pad_dma + (qc->tag * ATA_DMA_PAD_SZ);
-		sg_dma_len(psg) = ATA_DMA_PAD_SZ;
-		/* trim sg */
-		sg->length -= qc->pad_len;
-		if (sg->length == 0)
-			trim_sg = 1;
-
-		DPRINTK("padding done, sg->length=%u pad_len=%u\n",
-			sg->length, qc->pad_len);
-	}
-
-	if (trim_sg) {
-		qc->n_elem--;
-		goto skip_map;
-	}
-
-	dma_address = dma_map_single(ap->dev, qc->buf_virt,
-				     sg->length, dir);
-	if (dma_mapping_error(dma_address)) {
-		/* restore sg */
-		sg->length += qc->pad_len;
-		return -1;
-	}
-
-	sg_dma_address(sg) = dma_address;
-	sg_dma_len(sg) = sg->length;
-
-skip_map:
-	DPRINTK("mapped buffer of %d bytes for %s\n", sg_dma_len(sg),
-		qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
-
-	return 0;
+
+	qc->nbytes = 0;
+	while (n_elem) {
+		qc->nbytes += sg->length;
+		n_elem--;
+		sg = sg_next(sg);
+	}
 }
 
 /**
@@ -6028,9 +5938,6 @@ void ata_qc_issue(struct ata_queued_cmd 
 	if (ata_should_dma_map(qc)) {
 		if (qc->flags & ATA_QCFLAG_SG) {
 			if (ata_sg_setup(qc))
-				goto sg_err;
-		} else if (qc->flags & ATA_QCFLAG_SINGLE) {
-			if (ata_sg_setup_one(qc))
 				goto sg_err;
 		}
 	} else {
diff -r 8b1075c7ad47 include/linux/libata.h
--- a/include/linux/libata.h	Tue Nov 13 21:00:47 2007 +1100
+++ b/include/linux/libata.h	Wed Nov 14 15:31:07 2007 +1100
@@ -216,8 +216,7 @@ enum {
 	/* struct ata_queued_cmd flags */
 	ATA_QCFLAG_ACTIVE	= (1 << 0), /* cmd not yet ack'd to scsi lyer */
 	ATA_QCFLAG_SG		= (1 << 1), /* have s/g table? */
-	ATA_QCFLAG_SINGLE	= (1 << 2), /* no s/g, just a single buffer */
-	ATA_QCFLAG_DMAMAP	= ATA_QCFLAG_SG | ATA_QCFLAG_SINGLE,
+	ATA_QCFLAG_DMAMAP	= ATA_QCFLAG_SG,
 	ATA_QCFLAG_IO		= (1 << 3), /* standard IO command */
 	ATA_QCFLAG_RESULT_TF	= (1 << 4), /* result TF requested */
 	ATA_QCFLAG_CLEAR_EXCL	= (1 << 5), /* clear excl_link on completion */
@@ -459,7 +458,6 @@ struct ata_queued_cmd {
 
 	struct scatterlist	sgent;
 	struct scatterlist	pad_sgent;
-	void			*buf_virt;
 
 	/* DO NOT iterate over __sg manually, use ata_for_each_sg() */
 	struct scatterlist	*__sg;
