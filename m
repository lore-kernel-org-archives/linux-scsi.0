From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 7/7] sg_ring: convert core ATA code to sg_ring.
Date: Wed, 19 Dec 2007 18:38:26 +1100
Message-ID: <200712191838.27363.rusty@rustcorp.com.au>
References: <200712191731.26512.rusty@rustcorp.com.au> <200712191836.06769.rusty@rustcorp.com.au> <200712191837.04697.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200712191837.04697.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ATA relies so heavily on scsi that it needs to be converted at the
same time.

ATA adds padding to scatterlists in scsi commands, but because there was
no good way of appending to those scatterlists, it had to use boutique
iterators to make sure the padding is included.  With sg_ring, ATA can
simply append an sg_ring entry with the padding, and normal iterators
can be used.

I renamed qc->cursg to qc->cur_sg to catch all the users: they should
now be referring to 'qc->cur_sg[qc->cursg_i]' wherever they were using
'qc->cursg'.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r a867138da3e0 drivers/ata/ahci.c
--- a/drivers/ata/ahci.c	Wed Dec 19 16:48:15 2007 +1100
+++ b/drivers/ata/ahci.c	Wed Dec 19 17:27:09 2007 +1100
@@ -1479,9 +1479,9 @@ static void ahci_tf_read(struct ata_port
 
 static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
 {
-	struct scatterlist *sg;
 	struct ahci_sg *ahci_sg;
-	unsigned int n_sg = 0;
+	struct sg_ring *sg;
+	unsigned int i, n_sg = 0;
 
 	VPRINTK("ENTER\n");
 
@@ -1489,9 +1489,9 @@ static unsigned int ahci_fill_sg(struct 
 	 * Next, the S/G list.
 	 */
 	ahci_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
-	ata_for_each_sg(sg, qc) {
-		dma_addr_t addr = sg_dma_address(sg);
-		u32 sg_len = sg_dma_len(sg);
+	sg_ring_for_each(qc->sg, sg, i) {
+		dma_addr_t addr = sg_dma_address(&sg->sg[i]);
+		u32 sg_len = sg_dma_len(&sg->sg[i]);
 
 		ahci_sg->addr = cpu_to_le32(addr & 0xffffffff);
 		ahci_sg->addr_hi = cpu_to_le32((addr >> 16) >> 16);
diff -r a867138da3e0 drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c	Wed Dec 19 16:48:15 2007 +1100
+++ b/drivers/ata/libata-core.c	Wed Dec 19 17:27:09 2007 +1100
@@ -1596,8 +1596,8 @@ static void ata_qc_complete_internal(str
  */
 unsigned ata_exec_internal_sg(struct ata_device *dev,
 			      struct ata_taskfile *tf, const u8 *cdb,
-			      int dma_dir, struct scatterlist *sgl,
-			      unsigned int n_elem, unsigned long timeout)
+			      int dma_dir, struct sg_ring *sg,
+			      unsigned long timeout)
 {
 	struct ata_link *link = dev->link;
 	struct ata_port *ap = link->ap;
@@ -1657,7 +1657,7 @@ unsigned ata_exec_internal_sg(struct ata
 	qc->flags |= ATA_QCFLAG_RESULT_TF;
 	qc->dma_dir = dma_dir;
 	if (dma_dir != DMA_NONE)
-		ata_sg_init(qc, sgl, n_elem);
+		ata_sg_init(qc, sg);
 
 	qc->private_data = &wait;
 	qc->complete_fn = ata_qc_complete_internal;
@@ -1770,18 +1770,16 @@ unsigned ata_exec_internal(struct ata_de
 			   int dma_dir, void *buf, unsigned int buflen,
 			   unsigned long timeout)
 {
-	struct scatterlist *psg = NULL, sg;
-	unsigned int n_elem = 0;
+	struct sg_ring *psg = NULL;
+	DECLARE_SG_RING(sg, 1);
 
 	if (dma_dir != DMA_NONE) {
 		WARN_ON(!buf);
-		sg_init_one(&sg, buf, buflen);
-		psg = &sg;
-		n_elem++;
-	}
-
-	return ata_exec_internal_sg(dev, tf, cdb, dma_dir, psg, n_elem,
-				    timeout);
+		sg_ring_single(&sg.ring, buf, buflen);
+		psg = &sg.ring;
+	}
+
+	return ata_exec_internal_sg(dev, tf, cdb, dma_dir, psg, timeout);
 }
 
 /**
@@ -4438,6 +4436,36 @@ static unsigned int ata_dev_init_params(
 	return err_mask;
 }
 
+static struct sg_ring *sg_ring_prev(struct sg_ring *sg)
+{
+	return list_entry(sg->list.prev, struct sg_ring, list);
+}
+
+/* To be paranoid, we handle empty scatterlist ring entries here. */
+static struct sg_ring *sg_find_end(struct sg_ring *sg, unsigned int *num)
+{
+	struct sg_ring *i;
+
+	for (i = sg_ring_prev(sg); i->num == 0; i = sg_ring_prev(i)) {
+		/* sg_ring must not be entirely empty. */
+		BUG_ON(i == sg);
+	}
+	*num = i->num - 1;
+	return i;
+}
+
+static void add_padding_to_tail(struct sg_ring *sg, unsigned int padding)
+{
+	struct sg_ring *tail = sg_ring_prev(sg);
+
+	/* It's possible that the entire sg element got moved to padding. */
+	if (tail->num == 0) {
+		BUG_ON(tail->max == 0);
+		tail->num++;
+	}
+	tail->sg[tail->num - 1].length += padding;
+}
+
 /**
  *	ata_sg_clean - Unmap DMA memory associated with command
  *	@qc: Command containing DMA memory to be released
@@ -4450,37 +4478,39 @@ void ata_sg_clean(struct ata_queued_cmd 
 void ata_sg_clean(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg = qc->__sg;
 	int dir = qc->dma_dir;
-	void *pad_buf = NULL;
-
-	WARN_ON(!(qc->flags & ATA_QCFLAG_DMAMAP));
-	WARN_ON(sg == NULL);
-
-	VPRINTK("unmapping %u sg elements\n", qc->n_elem);
-
-	/* if we padded the buffer out to 32-bit bound, and data
-	 * xfer direction is from-device, we must copy from the
-	 * pad buffer back into the supplied buffer
-	 */
-	if (qc->pad_len && !(qc->tf.flags & ATA_TFLAG_WRITE))
-		pad_buf = ap->pad + (qc->tag * ATA_DMA_PAD_SZ);
-
-	if (qc->flags & ATA_QCFLAG_SG) {
-		if (qc->n_elem)
-			dma_unmap_sg(ap->dev, sg, qc->n_elem, dir);
-		/* restore last sg */
-		sg_last(sg, qc->orig_n_elem)->length += qc->pad_len;
-		if (pad_buf) {
-			struct scatterlist *psg = &qc->pad_sgent;
+
+	BUG_ON(!(qc->flags & ATA_QCFLAG_DMAMAP));
+
+	/* If we padded this entry, don't try to unmap padding */
+	if (qc->pad_len) {
+		BUG_ON(list_empty(&qc->pad_sgent.ring.list));
+		list_del(&qc->pad_sgent.ring.list);
+	}
+
+	dma_unmap_sg_ring(ap->dev, qc->sg, dir);
+
+	/* Restore any padding */
+	if (qc->pad_len) {
+		add_padding_to_tail(qc->sg, qc->pad_len);
+
+		/* if we padded the buffer out to 32-bit bound, and data
+		 * xfer direction is from-device, we must copy from the
+		 * pad buffer back into the supplied buffer
+		 */
+		if (!(qc->tf.flags & ATA_TFLAG_WRITE)) {
+			struct scatterlist *psg = qc->pad_sgent.sg;
 			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
-			memcpy(addr + psg->offset, pad_buf, qc->pad_len);
+
+			memcpy(addr + psg->offset,
+			       ap->pad + (qc->tag * ATA_DMA_PAD_SZ),
+			       qc->pad_len);
 			kunmap_atomic(addr, KM_IRQ0);
 		}
 	}
 
 	qc->flags &= ~ATA_QCFLAG_DMAMAP;
-	qc->__sg = NULL;
+	qc->sg = NULL;
 }
 
 /**
@@ -4497,14 +4527,11 @@ static void ata_fill_sg(struct ata_queue
 static void ata_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg;
-	unsigned int idx;
-
-	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	struct sg_ring *sg;
+	unsigned int i, idx;
 
 	idx = 0;
-	ata_for_each_sg(sg, qc) {
+	sg_ring_for_each(qc->sg, sg, i) {
 		u32 addr, offset;
 		u32 sg_len, len;
 
@@ -4512,8 +4539,8 @@ static void ata_fill_sg(struct ata_queue
 		 * Note h/w doesn't support 64-bit, so we unconditionally
 		 * truncate dma_addr_t to u32.
 		 */
-		addr = (u32) sg_dma_address(sg);
-		sg_len = sg_dma_len(sg);
+		addr = (u32) sg_dma_address(&sg->sg[i]);
+		sg_len = sg_dma_len(&sg->sg[i]);
 
 		while (sg_len) {
 			offset = addr & 0xffff;
@@ -4551,14 +4578,11 @@ static void ata_fill_sg_dumb(struct ata_
 static void ata_fill_sg_dumb(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg;
-	unsigned int idx;
-
-	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	struct sg_ring *sg;
+	unsigned int i, idx;
 
 	idx = 0;
-	ata_for_each_sg(sg, qc) {
+	sg_ring_for_each(qc->sg, sg, i) {
 		u32 addr, offset;
 		u32 sg_len, len, blen;
 
@@ -4566,8 +4590,8 @@ static void ata_fill_sg_dumb(struct ata_
 		 * Note h/w doesn't support 64-bit, so we unconditionally
 		 * truncate dma_addr_t to u32.
 		 */
-		addr = (u32) sg_dma_address(sg);
-		sg_len = sg_dma_len(sg);
+		addr = (u32) sg_dma_address(&sg->sg[i]);
+		sg_len = sg_dma_len(&sg->sg[i]);
 
 		while (sg_len) {
 			offset = addr & 0xffff;
@@ -4708,39 +4732,34 @@ void ata_noop_qc_prep(struct ata_queued_
 
 void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf, unsigned int buflen)
 {
-	sg_init_one(&qc->sgent, buf, buflen);
-	ata_sg_init(qc, &qc->sgent, 1);
+	sg_ring_single(&qc->sgent.ring, buf, buflen);
+	ata_sg_init(qc, &qc->sgent.ring);
 }
 
 /**
  *	ata_sg_init - Associate command with scatter-gather table.
  *	@qc: Command to be associated
- *	@sg: Scatter-gather table.
- *	@n_elem: Number of elements in s/g table.
+ *	@sg: Scatter-gather ring.
  *
  *	Initialize the data-related elements of queued_cmd @qc
- *	to point to a scatter-gather table @sg, containing @n_elem
- *	elements.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-
-void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
-		 unsigned int n_elem)
-{
+ *	to point to a scatter-gather ring @sg.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+
+void ata_sg_init(struct ata_queued_cmd *qc, struct sg_ring *sg)
+{
+	unsigned int i;
+
 	qc->flags |= ATA_QCFLAG_SG;
-	qc->__sg = sg;
-	qc->n_elem = n_elem;
-	qc->orig_n_elem = n_elem;
-	qc->cursg = qc->__sg;
+	qc->sg = sg;
+	qc->cur_sg = qc->sg;
+	qc->cursg_i = 0;
 
 	qc->nbytes = 0;
-	while (n_elem) {
-		qc->nbytes += sg->length;
-		n_elem--;
-		sg = sg_next(sg);
-	}
+	sg_ring_for_each(qc->sg, sg, i)
+		qc->nbytes += sg->sg[i].length;
 }
 
 /**
@@ -4760,18 +4779,20 @@ static int ata_sg_setup(struct ata_queue
 static int ata_sg_setup(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg = qc->__sg;
-	struct scatterlist *lsg = sg_last(qc->__sg, qc->n_elem);
-	int n_elem, pre_n_elem, dir, trim_sg = 0;
+	unsigned int lsg;
+	struct sg_ring *end = sg_find_end(qc->sg, &lsg);
 
 	VPRINTK("ENTER, ata%u\n", ap->print_id);
 	WARN_ON(!(qc->flags & ATA_QCFLAG_SG));
 
+	BUG_ON(qc->sg->num == 0);
+	BUG_ON(sg_virt(&qc->sg->sg[0]) == NULL);
+
 	/* we must lengthen transfers to end on a 32-bit boundary */
-	qc->pad_len = lsg->length & 3;
+	qc->pad_len = end->sg[lsg].length & 3;
 	if (qc->pad_len) {
 		void *pad_buf = ap->pad + (qc->tag * ATA_DMA_PAD_SZ);
-		struct scatterlist *psg = &qc->pad_sgent;
+		struct scatterlist *psg = &qc->pad_sgent.sg[0];
 		unsigned int offset;
 
 		WARN_ON(qc->dev->class != ATA_DEV_ATAPI);
@@ -4782,10 +4803,13 @@ static int ata_sg_setup(struct ata_queue
 		 * psg->page/offset are used to copy to-be-written
 		 * data in this function or read data in ata_sg_clean.
 		 */
-		offset = lsg->offset + lsg->length - qc->pad_len;
-		sg_init_table(psg, 1);
-		sg_set_page(psg, nth_page(sg_page(lsg), offset >> PAGE_SHIFT),
-				qc->pad_len, offset_in_page(offset));
+		offset = end->sg[lsg].offset + end->sg[lsg].length - qc->pad_len;
+
+		sg_ring_init(&qc->pad_sgent.ring, 1);
+
+		sg_set_page(psg, nth_page(sg_page(&end->sg[lsg]),
+					  offset >> PAGE_SHIFT),
+			    qc->pad_len, offset_in_page(offset));
 
 		if (qc->tf.flags & ATA_TFLAG_WRITE) {
 			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
@@ -4795,36 +4819,25 @@ static int ata_sg_setup(struct ata_queue
 
 		sg_dma_address(psg) = ap->pad_dma + (qc->tag * ATA_DMA_PAD_SZ);
 		sg_dma_len(psg) = ATA_DMA_PAD_SZ;
+
 		/* trim last sg */
-		lsg->length -= qc->pad_len;
-		if (lsg->length == 0)
-			trim_sg = 1;
+		end->sg[lsg].length -= qc->pad_len;
+		if (end->sg[lsg].length == 0)
+			end->num--;
 
 		DPRINTK("padding done, sg[%d].length=%u pad_len=%u\n",
-			qc->n_elem - 1, lsg->length, qc->pad_len);
-	}
-
-	pre_n_elem = qc->n_elem;
-	if (trim_sg && pre_n_elem)
-		pre_n_elem--;
-
-	if (!pre_n_elem) {
-		n_elem = 0;
-		goto skip_map;
-	}
-
-	dir = qc->dma_dir;
-	n_elem = dma_map_sg(ap->dev, sg, pre_n_elem, dir);
-	if (n_elem < 1) {
+			qc->n_elem - 1, end->sg[lsg].length, qc->pad_len);
+	}
+
+	if (dma_map_sg_ring(ap->dev, qc->sg, qc->dma_dir) != 0) {
 		/* restore last sg */
-		lsg->length += qc->pad_len;
+		add_padding_to_tail(qc->sg, qc->pad_len);
 		return -1;
 	}
 
-	DPRINTK("%d sg elements mapped\n", n_elem);
-
-skip_map:
-	qc->n_elem = n_elem;
+	/* We attach pad sg to end for iteration purposes. */
+	if (qc->pad_len)
+		list_add_tail(&qc->pad_sgent.ring.list, &qc->sg->list);
 
 	return 0;
 }
@@ -4934,8 +4947,8 @@ static void ata_pio_sector(struct ata_qu
 	if (qc->curbytes == qc->nbytes - qc->sect_size)
 		ap->hsm_task_state = HSM_ST_LAST;
 
-	page = sg_page(qc->cursg);
-	offset = qc->cursg->offset + qc->cursg_ofs;
+	page = sg_page(&qc->cur_sg->sg[qc->cursg_i]);
+	offset = qc->cur_sg->sg[qc->cursg_i].offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
 	page = nth_page(page, (offset >> PAGE_SHIFT));
@@ -4963,10 +4976,8 @@ static void ata_pio_sector(struct ata_qu
 	qc->curbytes += qc->sect_size;
 	qc->cursg_ofs += qc->sect_size;
 
-	if (qc->cursg_ofs == qc->cursg->length) {
-		qc->cursg = sg_next(qc->cursg);
-		qc->cursg_ofs = 0;
-	}
+	if (qc->cursg_ofs == qc->cur_sg->sg[qc->cursg_i].length)
+		qc->cur_sg = sg_ring_iter(qc->sg, qc->cur_sg, &qc->cursg_i);
 }
 
 /**
@@ -5049,19 +5060,16 @@ static void __atapi_pio_bytes(struct ata
 static void __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 {
 	int do_write = (qc->tf.flags & ATA_TFLAG_WRITE);
-	struct scatterlist *sg = qc->__sg;
-	struct scatterlist *lsg = sg_last(qc->__sg, qc->n_elem);
 	struct ata_port *ap = qc->ap;
 	struct page *page;
 	unsigned char *buf;
 	unsigned int offset, count;
-	int no_more_sg = 0;
 
 	if (qc->curbytes + bytes >= qc->nbytes)
 		ap->hsm_task_state = HSM_ST_LAST;
 
 next_sg:
-	if (unlikely(no_more_sg)) {
+	if (unlikely(!qc->cur_sg)) {
 		/*
 		 * The end of qc->sg is reached and the device expects
 		 * more data to transfer. In order not to overrun qc->sg
@@ -5084,17 +5092,15 @@ next_sg:
 		return;
 	}
 
-	sg = qc->cursg;
-
-	page = sg_page(sg);
-	offset = sg->offset + qc->cursg_ofs;
+	page = sg_page(&qc->cur_sg->sg[qc->cursg_i]);
+	offset = qc->cur_sg->sg[qc->cursg_i].offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
 	page = nth_page(page, (offset >> PAGE_SHIFT));
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
-	count = min(sg->length - qc->cursg_ofs, bytes);
+	count = min(qc->cur_sg->sg[qc->cursg_i].length - qc->cursg_ofs, bytes);
 
 	/* don't cross page boundaries */
 	count = min(count, (unsigned int)PAGE_SIZE - offset);
@@ -5122,13 +5128,8 @@ next_sg:
 	qc->curbytes += count;
 	qc->cursg_ofs += count;
 
-	if (qc->cursg_ofs == sg->length) {
-		if (qc->cursg == lsg)
-			no_more_sg = 1;
-
-		qc->cursg = sg_next(qc->cursg);
-		qc->cursg_ofs = 0;
-	}
+	if (qc->cursg_ofs == qc->cur_sg->sg[qc->cursg_i].length)
+		qc->cur_sg = sg_ring_iter(qc->sg, qc->cur_sg, &qc->cursg_i);
 
 	if (bytes)
 		goto next_sg;
diff -r a867138da3e0 drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c	Wed Dec 19 16:48:15 2007 +1100
+++ b/drivers/ata/libata-scsi.c	Wed Dec 19 17:27:09 2007 +1100
@@ -517,8 +517,7 @@ static struct ata_queued_cmd *ata_scsi_q
 		qc->scsicmd = cmd;
 		qc->scsidone = done;
 
-		qc->__sg = scsi_sglist(cmd);
-		qc->n_elem = scsi_sg_count(cmd);
+		qc->sg = scsi_sgring(cmd);
 	} else {
 		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
 		done(cmd);
@@ -1479,6 +1478,17 @@ static void ata_scsi_qc_complete(struct 
 	ata_qc_free(qc);
 }
 
+static unsigned int sg_ring_len(struct sg_ring *sg_start)
+{
+	struct sg_ring *sg;
+	unsigned int i, len = 0;
+
+	sg_ring_for_each(sg_start, sg, i)
+		len += sg->sg[i].length;
+
+	return len;
+}
+
 /**
  *	ata_scsi_translate - Translate then issue SCSI command to ATA device
  *	@dev: ATA device to which the command is addressed
@@ -1529,7 +1539,16 @@ static int ata_scsi_translate(struct ata
 			goto err_did;
 		}
 
-		ata_sg_init(qc, scsi_sglist(cmd), scsi_sg_count(cmd));
+		ata_sg_init(qc, scsi_sgring(cmd));
+		if (scsi_bufflen(cmd) != sg_ring_len(scsi_sgring(cmd))) {
+			printk("scsi_bufflen = %u, sg_ring num %u/%u len = %u, qc->nbytes = %u\n",
+			       scsi_bufflen(cmd),
+			       scsi_sgring(cmd)->num, scsi_sgring(cmd)->max,
+			       sg_ring_len(scsi_sgring(cmd)),
+			       qc->nbytes);
+		}
+		BUG_ON(scsi_bufflen(cmd) != sg_ring_len(scsi_sgring(cmd)));
+		BUG_ON(scsi_bufflen(cmd) != qc->nbytes);
 
 		qc->dma_dir = cmd->sc_data_direction;
 	}
@@ -1592,9 +1611,9 @@ static unsigned int ata_scsi_rbuf_get(st
 	u8 *buf;
 	unsigned int buflen;
 
-	struct scatterlist *sg = scsi_sglist(cmd);
-
-	if (sg) {
+	if (scsi_sgring(cmd)) {
+		struct scatterlist *sg = &scsi_sgring(cmd)->sg[0];
+		BUG_ON(scsi_sgring(cmd)->num != 1);
 		buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 		buflen = sg->length;
 	} else {
@@ -1619,9 +1638,8 @@ static unsigned int ata_scsi_rbuf_get(st
 
 static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, u8 *buf)
 {
-	struct scatterlist *sg = scsi_sglist(cmd);
-	if (sg)
-		kunmap_atomic(buf - sg->offset, KM_IRQ0);
+	if (scsi_sgring(cmd))
+		kunmap_atomic(buf - scsi_sgring(cmd)->sg[0].offset, KM_IRQ0);
 }
 
 /**
diff -r a867138da3e0 drivers/ata/libata.h
--- a/drivers/ata/libata.h	Wed Dec 19 16:48:15 2007 +1100
+++ b/drivers/ata/libata.h	Wed Dec 19 17:27:09 2007 +1100
@@ -73,8 +73,8 @@ extern unsigned ata_exec_internal(struct
 				  unsigned long timeout);
 extern unsigned ata_exec_internal_sg(struct ata_device *dev,
 				     struct ata_taskfile *tf, const u8 *cdb,
-				     int dma_dir, struct scatterlist *sg,
-				     unsigned int n_elem, unsigned long timeout);
+				     int dma_dir, struct sg_ring *sg,
+				     unsigned long timeout);
 extern unsigned int ata_do_simple_cmd(struct ata_device *dev, u8 cmd);
 extern int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 			   unsigned int flags, u16 *id);
diff -r a867138da3e0 drivers/ata/pdc_adma.c
--- a/drivers/ata/pdc_adma.c	Wed Dec 19 16:48:15 2007 +1100
+++ b/drivers/ata/pdc_adma.c	Wed Dec 19 17:27:09 2007 +1100
@@ -315,22 +315,22 @@ static void adma_error_handler(struct at
 
 static int adma_fill_sg(struct ata_queued_cmd *qc)
 {
-	struct scatterlist *sg;
+	struct sg_ring *sg;
 	struct ata_port *ap = qc->ap;
 	struct adma_port_priv *pp = ap->private_data;
 	u8  *buf = pp->pkt, *last_buf = NULL;
-	int i = (2 + buf[3]) * 8;
+	int idx, i = (2 + buf[3]) * 8;
 	u8 pFLAGS = pORD | ((qc->tf.flags & ATA_TFLAG_WRITE) ? pDIRO : 0);
 
-	ata_for_each_sg(sg, qc) {
+	sg_ring_for_each(qc->sg, sg, idx) {
 		u32 addr;
 		u32 len;
 
-		addr = (u32)sg_dma_address(sg);
+		addr = (u32)sg_dma_address(&sg->sg[idx]);
 		*(__le32 *)(buf + i) = cpu_to_le32(addr);
 		i += 4;
 
-		len = sg_dma_len(sg) >> 3;
+		len = sg_dma_len(&sg->sg[idx]) >> 3;
 		*(__le32 *)(buf + i) = cpu_to_le32(len);
 		i += 4;
 
diff -r a867138da3e0 drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c	Wed Dec 19 16:48:15 2007 +1100
+++ b/drivers/ata/sata_mv.c	Wed Dec 19 17:27:09 2007 +1100
@@ -1134,13 +1134,14 @@ static void mv_fill_sg(struct ata_queued
 static void mv_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct mv_port_priv *pp = qc->ap->private_data;
-	struct scatterlist *sg;
+	struct sg_ring *sg;
+	unsigned int i;
 	struct mv_sg *mv_sg, *last_sg = NULL;
 
 	mv_sg = pp->sg_tbl;
-	ata_for_each_sg(sg, qc) {
-		dma_addr_t addr = sg_dma_address(sg);
-		u32 sg_len = sg_dma_len(sg);
+	sg_ring_for_each(qc->sg, sg, i) {
+		dma_addr_t addr = sg_dma_address(&sg->sg[i]);
+		u32 sg_len = sg_dma_len(&sg->sg[i]);
 
 		while (sg_len) {
 			u32 offset = addr & 0xffff;
diff -r a867138da3e0 drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c	Wed Dec 19 16:48:15 2007 +1100
+++ b/drivers/ata/sata_nv.c	Wed Dec 19 17:27:09 2007 +1100
@@ -1315,20 +1315,20 @@ static int nv_adma_host_init(struct ata_
 }
 
 static void nv_adma_fill_aprd(struct ata_queued_cmd *qc,
-			      struct scatterlist *sg,
-			      int idx,
+			      struct sg_ring *sg,
+			      int i, int idx,
 			      struct nv_adma_prd *aprd)
 {
 	u8 flags = 0;
 	if (qc->tf.flags & ATA_TFLAG_WRITE)
 		flags |= NV_APRD_WRITE;
-	if (idx == qc->n_elem - 1)
+	if (!sg_ring_next(sg, qc->sg) && i == sg->num - 1)
 		flags |= NV_APRD_END;
 	else if (idx != 4)
 		flags |= NV_APRD_CONT;
 
-	aprd->addr  = cpu_to_le64(((u64)sg_dma_address(sg)));
-	aprd->len   = cpu_to_le32(((u32)sg_dma_len(sg))); /* len in bytes */
+	aprd->addr  = cpu_to_le64(((u64)sg_dma_address(&sg->sg[i])));
+	aprd->len   = cpu_to_le32(((u32)sg_dma_len(&sg->sg[i]))); /* len in bytes */
 	aprd->flags = flags;
 	aprd->packet_len = 0;
 }
@@ -1336,18 +1336,18 @@ static void nv_adma_fill_sg(struct ata_q
 static void nv_adma_fill_sg(struct ata_queued_cmd *qc, struct nv_adma_cpb *cpb)
 {
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
-	unsigned int idx;
+	unsigned int i, idx;
 	struct nv_adma_prd *aprd;
-	struct scatterlist *sg;
+	struct sg_ring *sg;
 
 	VPRINTK("ENTER\n");
 
 	idx = 0;
 
-	ata_for_each_sg(sg, qc) {
+	sg_ring_for_each(qc->sg, sg, i) {
 		aprd = (idx < 5) ? &cpb->aprd[idx] :
 			       &pp->aprd[NV_ADMA_SGTBL_LEN * qc->tag + (idx-5)];
-		nv_adma_fill_aprd(qc, sg, idx, aprd);
+		nv_adma_fill_aprd(qc, sg, i, idx, aprd);
 		idx++;
 	}
 	if (idx > 5)
@@ -1994,23 +1994,22 @@ static void nv_swncq_fill_sg(struct ata_
 static void nv_swncq_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg;
-	unsigned int idx;
+	struct sg_ring *sg;
+	unsigned int i, idx;
 	struct nv_swncq_port_priv *pp = ap->private_data;
 	struct ata_prd *prd;
 
-	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	WARN_ON(qc->sg == NULL);
 
 	prd = pp->prd + ATA_MAX_PRD * qc->tag;
 
 	idx = 0;
-	ata_for_each_sg(sg, qc) {
+	sg_ring_for_each(qc->sg, sg, i) {
 		u32 addr, offset;
 		u32 sg_len, len;
 
-		addr = (u32)sg_dma_address(sg);
-		sg_len = sg_dma_len(sg);
+		addr = (u32)sg_dma_address(&sg->sg[i]);
+		sg_len = sg_dma_len(&sg->sg[i]);
 
 		while (sg_len) {
 			offset = addr & 0xffff;
diff -r a867138da3e0 drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c	Wed Dec 19 16:48:15 2007 +1100
+++ b/drivers/ata/sata_promise.c	Wed Dec 19 17:27:09 2007 +1100
@@ -540,18 +540,17 @@ static void pdc_fill_sg(struct ata_queue
 static void pdc_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg;
-	unsigned int idx;
+	struct sg_ring *sg;
+	unsigned int i, idx;
 	const u32 SG_COUNT_ASIC_BUG = 41*4;
 
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
 		return;
 
-	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	WARN_ON(qc->sg == NULL);
 
 	idx = 0;
-	ata_for_each_sg(sg, qc) {
+	sg_ring_for_each(qc->sg, sg, i) {
 		u32 addr, offset;
 		u32 sg_len, len;
 
@@ -559,8 +558,8 @@ static void pdc_fill_sg(struct ata_queue
 		 * Note h/w doesn't support 64-bit, so we unconditionally
 		 * truncate dma_addr_t to u32.
 		 */
-		addr = (u32) sg_dma_address(sg);
-		sg_len = sg_dma_len(sg);
+		addr = (u32) sg_dma_address(&sg->sg[i]);
+		sg_len = sg_dma_len(&sg->sg[i]);
 
 		while (sg_len) {
 			offset = addr & 0xffff;
diff -r a867138da3e0 drivers/ata/sata_qstor.c
--- a/drivers/ata/sata_qstor.c	Wed Dec 19 16:48:15 2007 +1100
+++ b/drivers/ata/sata_qstor.c	Wed Dec 19 17:27:09 2007 +1100
@@ -284,25 +284,24 @@ static int qs_scr_write(struct ata_port 
 
 static unsigned int qs_fill_sg(struct ata_queued_cmd *qc)
 {
-	struct scatterlist *sg;
+	struct sg_ring *sg;
 	struct ata_port *ap = qc->ap;
 	struct qs_port_priv *pp = ap->private_data;
-	unsigned int nelem;
+	unsigned int i, nelem;
 	u8 *prd = pp->pkt + QS_CPB_BYTES;
 
-	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	WARN_ON(qc->sg == NULL);
 
 	nelem = 0;
-	ata_for_each_sg(sg, qc) {
+	sg_ring_for_each(qc->sg, sg, i) {
 		u64 addr;
 		u32 len;
 
-		addr = sg_dma_address(sg);
+		addr = sg_dma_address(&sg->sg[i]);
 		*(__le64 *)prd = cpu_to_le64(addr);
 		prd += sizeof(u64);
 
-		len = sg_dma_len(sg);
+		len = sg_dma_len(&sg->sg[i]);
 		*(__le32 *)prd = cpu_to_le32(len);
 		prd += sizeof(u64);
 
diff -r a867138da3e0 drivers/ata/sata_sil24.c
--- a/drivers/ata/sata_sil24.c	Wed Dec 19 16:48:15 2007 +1100
+++ b/drivers/ata/sata_sil24.c	Wed Dec 19 17:27:09 2007 +1100
@@ -811,12 +811,13 @@ static inline void sil24_fill_sg(struct 
 static inline void sil24_fill_sg(struct ata_queued_cmd *qc,
 				 struct sil24_sge *sge)
 {
-	struct scatterlist *sg;
+	struct sg_ring *sg;
+	unsigned int i;
 	struct sil24_sge *last_sge = NULL;
 
-	ata_for_each_sg(sg, qc) {
-		sge->addr = cpu_to_le64(sg_dma_address(sg));
-		sge->cnt = cpu_to_le32(sg_dma_len(sg));
+	sg_ring_for_each(qc->sg, sg, i) {
+		sge->addr = cpu_to_le64(sg_dma_address(&sg->sg[i]));
+		sge->cnt = cpu_to_le32(sg_dma_len(&sg->sg[i]));
 		sge->flags = 0;
 
 		last_sge = sge;
diff -r a867138da3e0 drivers/ata/sata_sx4.c
--- a/drivers/ata/sata_sx4.c	Wed Dec 19 16:48:15 2007 +1100
+++ b/drivers/ata/sata_sx4.c	Wed Dec 19 17:27:09 2007 +1100
@@ -467,7 +467,7 @@ static inline void pdc20621_host_pkt(str
 
 static void pdc20621_dma_prep(struct ata_queued_cmd *qc)
 {
-	struct scatterlist *sg;
+	struct sg_ring *sg;
 	struct ata_port *ap = qc->ap;
 	struct pdc_port_priv *pp = ap->private_data;
 	void __iomem *mmio = ap->host->iomap[PDC_MMIO_BAR];
@@ -487,10 +487,10 @@ static void pdc20621_dma_prep(struct ata
 	 * Build S/G table
 	 */
 	idx = 0;
-	ata_for_each_sg(sg, qc) {
-		buf[idx++] = cpu_to_le32(sg_dma_address(sg));
-		buf[idx++] = cpu_to_le32(sg_dma_len(sg));
-		total_len += sg_dma_len(sg);
+	sg_ring_for_each(qc->sg, sg, i) {
+		buf[idx++] = cpu_to_le32(sg_dma_address(&sg->sg[i]));
+		buf[idx++] = cpu_to_le32(sg_dma_len(&sg->sg[i]));
+		total_len += sg_dma_len(&sg->sg[i]);
 	}
 	buf[idx - 1] |= cpu_to_le32(ATA_PRD_EOT);
 	sgt_len = idx * 4;
diff -r a867138da3e0 include/linux/libata.h
--- a/include/linux/libata.h	Wed Dec 19 16:48:15 2007 +1100
+++ b/include/linux/libata.h	Wed Dec 19 17:27:09 2007 +1100
@@ -29,7 +29,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
-#include <linux/scatterlist.h>
+#include <linux/sg_ring.h>
 #include <linux/io.h>
 #include <linux/ata.h>
 #include <linux/workqueue.h>
@@ -442,9 +442,7 @@ struct ata_queued_cmd {
 
 	unsigned long		flags;		/* ATA_QCFLAG_xxx */
 	unsigned int		tag;
-	unsigned int		n_elem;
 	unsigned int		n_iter;
-	unsigned int		orig_n_elem;
 
 	int			dma_dir;
 
@@ -454,14 +452,14 @@ struct ata_queued_cmd {
 	unsigned int		nbytes;
 	unsigned int		curbytes;
 
-	struct scatterlist	*cursg;
+	struct sg_ring		*cur_sg;
+	unsigned int		cursg_i;
 	unsigned int		cursg_ofs;
 
-	struct scatterlist	sgent;
-	struct scatterlist	pad_sgent;
+	DECLARE_SG_RING(sgent, 1);
+	DECLARE_SG_RING(pad_sgent, 1);
 
-	/* DO NOT iterate over __sg manually, use ata_for_each_sg() */
-	struct scatterlist	*__sg;
+	struct sg_ring		*sg;
 
 	unsigned int		err_mask;
 	struct ata_taskfile	result_tf;
@@ -861,9 +859,8 @@ extern void ata_noop_qc_prep(struct ata_
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc);
 extern void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf,
-		unsigned int buflen);
-extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
-		 unsigned int n_elem);
+			    unsigned int buflen);
+extern void ata_sg_init(struct ata_queued_cmd *qc, struct sg_ring *sg);
 extern unsigned int ata_dev_classify(const struct ata_taskfile *tf);
 extern void ata_dev_disable(struct ata_device *adev);
 extern void ata_id_string(const u16 *id, unsigned char *s,
@@ -1059,35 +1056,6 @@ extern void ata_port_pbar_desc(struct at
 			       const char *name);
 #endif
 
-/*
- * qc helpers
- */
-static inline struct scatterlist *
-ata_qc_first_sg(struct ata_queued_cmd *qc)
-{
-	qc->n_iter = 0;
-	if (qc->n_elem)
-		return qc->__sg;
-	if (qc->pad_len)
-		return &qc->pad_sgent;
-	return NULL;
-}
-
-static inline struct scatterlist *
-ata_qc_next_sg(struct scatterlist *sg, struct ata_queued_cmd *qc)
-{
-	if (sg == &qc->pad_sgent)
-		return NULL;
-	if (++qc->n_iter < qc->n_elem)
-		return sg_next(sg);
-	if (qc->pad_len)
-		return &qc->pad_sgent;
-	return NULL;
-}
-
-#define ata_for_each_sg(sg, qc) \
-	for (sg = ata_qc_first_sg(qc); sg; sg = ata_qc_next_sg(sg, qc))
-
 static inline unsigned int ata_tag_valid(unsigned int tag)
 {
 	return (tag < ATA_MAX_QUEUE) ? 1 : 0;
@@ -1322,12 +1290,12 @@ static inline void ata_qc_reinit(struct 
 static inline void ata_qc_reinit(struct ata_queued_cmd *qc)
 {
 	qc->dma_dir = DMA_NONE;
-	qc->__sg = NULL;
+	qc->sg = NULL;
 	qc->flags = 0;
-	qc->cursg = NULL;
+	qc->cur_sg = NULL;
+	qc->cursg_i = 0;
 	qc->cursg_ofs = 0;
 	qc->nbytes = qc->curbytes = 0;
-	qc->n_elem = 0;
 	qc->n_iter = 0;
 	qc->err_mask = 0;
 	qc->pad_len = 0;
