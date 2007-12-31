From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] libata: eliminate the home grown dma padding in favour of
	that provided by the block layer
Date: Mon, 31 Dec 2007 15:56:08 -0600
Message-ID: <1199138168.3110.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41917 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbXLaV4S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Dec 2007 16:56:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
Cc: Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>

ATA requires that all DMA transfers begin and end on word boundaries.
Because of this, a large amount of machinery grew up in ide to adjust
scatterlists on this basis.  However, as of 2.5, the block layer has a
dma_alignment variable which ensures both the beginning and length of a
DMA transfer are aligned on the dma_alignment boundary.  Although the
block layer does adjust the beginning of the transfer to ensure this
happens, it doesn't actually adjust the length, it merely makes sure
that space is allocated for transfers beyond the declared length.  The
upshot of this is that scatterlists may be padded to any size between
the actual length and the length adjusted to the dma_alignment safely
knowing that memory is allocated in this region.

Right at the moment, SCSI takes the default dma_aligment which is on a
512 byte boundary.  Note that this aligment only applies to transfers
coming in from user space.  However, since all kernel allocations are
automatically aligned on a minimum of 32 byte boundaries, it is safe to
adjust them in this manner as well.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

This also fixes a current panic in libsas with SATAPI devices.  I was
trying to trace a bad interaction between the libata padding and the new
sglist code which was the root cause, and ended up concluding that the
whole libata padding thing was redundant.

In a future improvement, I think we can relax SCSI dma_alignemnt (it's
causing almost every user space command to be copied instead of directly
passed through) and allow devices and transports to build up their own
requirements instead.

James

 drivers/ata/ahci.c            |    5 -
 drivers/ata/libata-core.c     |  126 +++---------------------------------------
 drivers/ata/libata-scsi.c     |   18 +-----
 drivers/ata/pata_icside.c     |    8 --
 drivers/ata/sata_fsl.c        |   17 -----
 drivers/ata/sata_mv.c         |    5 -
 drivers/ata/sata_nv.c         |    2 
 drivers/ata/sata_promise.c    |    2 
 drivers/ata/sata_qstor.c      |    2 
 drivers/ata/sata_sil24.c      |    5 -
 drivers/scsi/ipr.c            |    4 -
 drivers/scsi/libsas/sas_ata.c |    4 -
 include/linux/libata.h        |   35 -----------
 13 files changed, 25 insertions(+), 208 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 54f38c2..4dd318d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1965,16 +1965,11 @@ static int ahci_port_start(struct ata_port *ap)
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
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4753a18..97db82f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -60,6 +60,8 @@
 #include <linux/io.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <asm/semaphore.h>
@@ -4464,7 +4466,6 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg = qc->__sg;
 	int dir = qc->dma_dir;
-	void *pad_buf = NULL;
 
 	WARN_ON(!(qc->flags & ATA_QCFLAG_DMAMAP));
 	WARN_ON(sg == NULL);
@@ -4474,34 +4475,14 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
 
 	VPRINTK("unmapping %u sg elements\n", qc->n_elem);
 
-	/* if we padded the buffer out to 32-bit bound, and data
-	 * xfer direction is from-device, we must copy from the
-	 * pad buffer back into the supplied buffer
-	 */
-	if (qc->pad_len && !(qc->tf.flags & ATA_TFLAG_WRITE))
-		pad_buf = ap->pad + (qc->tag * ATA_DMA_PAD_SZ);
-
 	if (qc->flags & ATA_QCFLAG_SG) {
 		if (qc->n_elem)
 			dma_unmap_sg(ap->dev, sg, qc->n_elem, dir);
-		/* restore last sg */
-		sg_last(sg, qc->orig_n_elem)->length += qc->pad_len;
-		if (pad_buf) {
-			struct scatterlist *psg = &qc->pad_sgent;
-			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
-			memcpy(addr + psg->offset, pad_buf, qc->pad_len);
-			kunmap_atomic(addr, KM_IRQ0);
-		}
 	} else {
 		if (qc->n_elem)
 			dma_unmap_single(ap->dev,
 				sg_dma_address(&sg[0]), sg_dma_len(&sg[0]),
 				dir);
-		/* restore sg */
-		sg->length += qc->pad_len;
-		if (pad_buf)
-			memcpy(qc->buf_virt + sg->length - qc->pad_len,
-			       pad_buf, qc->pad_len);
 	}
 
 	qc->flags &= ~ATA_QCFLAG_DMAMAP;
@@ -4526,7 +4507,7 @@ static void ata_fill_sg(struct ata_queued_cmd *qc)
 	unsigned int idx;
 
 	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	WARN_ON(qc->n_elem == 0);
 
 	idx = 0;
 	ata_for_each_sg(sg, qc) {
@@ -4580,7 +4561,7 @@ static void ata_fill_sg_dumb(struct ata_queued_cmd *qc)
 	unsigned int idx;
 
 	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	WARN_ON(qc->n_elem == 0);
 
 	idx = 0;
 	ata_for_each_sg(sg, qc) {
@@ -4774,7 +4755,6 @@ void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf, unsigned int buflen)
 
 	qc->__sg = &qc->sgent;
 	qc->n_elem = 1;
-	qc->orig_n_elem = 1;
 	qc->buf_virt = buf;
 	qc->nbytes = buflen;
 	qc->cursg = qc->__sg;
@@ -4802,7 +4782,6 @@ void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
 	qc->flags |= ATA_QCFLAG_SG;
 	qc->__sg = sg;
 	qc->n_elem = n_elem;
-	qc->orig_n_elem = n_elem;
 	qc->cursg = qc->__sg;
 }
 
@@ -4825,50 +4804,18 @@ static int ata_sg_setup_one(struct ata_queued_cmd *qc)
 	int dir = qc->dma_dir;
 	struct scatterlist *sg = qc->__sg;
 	dma_addr_t dma_address;
-	int trim_sg = 0;
 
 	/* we must lengthen transfers to end on a 32-bit boundary */
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
+	sg->length += ATA_DMA_PAD_MASK -
+		((ATA_DMA_PAD_MASK + sg->length) & ATA_DMA_PAD_MASK);
 	dma_address = dma_map_single(ap->dev, qc->buf_virt,
 				     sg->length, dir);
-	if (dma_mapping_error(dma_address)) {
-		/* restore sg */
-		sg->length += qc->pad_len;
+	if (dma_mapping_error(dma_address))
 		return -1;
-	}
 
 	sg_dma_address(sg) = dma_address;
 	sg_dma_len(sg) = sg->length;
 
-skip_map:
 	DPRINTK("mapped buffer of %d bytes for %s\n", sg_dma_len(sg),
 		qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
 
@@ -4893,69 +4840,23 @@ static int ata_sg_setup(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg = qc->__sg;
-	struct scatterlist *lsg = sg_last(qc->__sg, qc->n_elem);
-	int n_elem, pre_n_elem, dir, trim_sg = 0;
+	int n_elem, pre_n_elem, dir;
 
 	VPRINTK("ENTER, ata%u\n", ap->print_id);
 	WARN_ON(!(qc->flags & ATA_QCFLAG_SG));
 
 	/* we must lengthen transfers to end on a 32-bit boundary */
-	qc->pad_len = lsg->length & 3;
-	if (qc->pad_len) {
-		void *pad_buf = ap->pad + (qc->tag * ATA_DMA_PAD_SZ);
-		struct scatterlist *psg = &qc->pad_sgent;
-		unsigned int offset;
-
-		WARN_ON(qc->dev->class != ATA_DEV_ATAPI);
-
-		memset(pad_buf, 0, ATA_DMA_PAD_SZ);
-
-		/*
-		 * psg->page/offset are used to copy to-be-written
-		 * data in this function or read data in ata_sg_clean.
-		 */
-		offset = lsg->offset + lsg->length - qc->pad_len;
-		sg_init_table(psg, 1);
-		sg_set_page(psg, nth_page(sg_page(lsg), offset >> PAGE_SHIFT),
-				qc->pad_len, offset_in_page(offset));
-
-		if (qc->tf.flags & ATA_TFLAG_WRITE) {
-			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
-			memcpy(pad_buf, addr + psg->offset, qc->pad_len);
-			kunmap_atomic(addr, KM_IRQ0);
-		}
-
-		sg_dma_address(psg) = ap->pad_dma + (qc->tag * ATA_DMA_PAD_SZ);
-		sg_dma_len(psg) = ATA_DMA_PAD_SZ;
-		/* trim last sg */
-		lsg->length -= qc->pad_len;
-		if (lsg->length == 0)
-			trim_sg = 1;
-
-		DPRINTK("padding done, sg[%d].length=%u pad_len=%u\n",
-			qc->n_elem - 1, lsg->length, qc->pad_len);
-	}
-
+	sg->length += ATA_DMA_PAD_MASK -
+		((ATA_DMA_PAD_MASK + sg->length) & ATA_DMA_PAD_MASK);
 	pre_n_elem = qc->n_elem;
-	if (trim_sg && pre_n_elem)
-		pre_n_elem--;
-
-	if (!pre_n_elem) {
-		n_elem = 0;
-		goto skip_map;
-	}
 
 	dir = qc->dma_dir;
 	n_elem = dma_map_sg(ap->dev, sg, pre_n_elem, dir);
-	if (n_elem < 1) {
-		/* restore last sg */
-		lsg->length += qc->pad_len;
+	if (n_elem < 1)
 		return -1;
-	}
 
 	DPRINTK("%d sg elements mapped\n", n_elem);
 
-skip_map:
 	qc->n_elem = n_elem;
 
 	return 0;
@@ -6617,17 +6518,12 @@ void ata_host_resume(struct ata_host *host)
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
 	DPRINTK("prd alloc, virt %p, dma %llx\n", ap->prd,
 		(unsigned long long)ap->prd_dma);
 	return 0;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a883bb0..571fba5 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -832,15 +832,6 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
-	/* SATA DMA transfers must be multiples of 4 byte, so
-	 * we need to pad ATAPI transfers using an extra sg.
-	 * Decrement max hw segments accordingly.
-	 */
-	if (dev->class == ATA_DEV_ATAPI) {
-		struct request_queue *q = sdev->request_queue;
-		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
-	}
-
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 
@@ -3527,7 +3518,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
  *	@ap: Port to initialize
  *
  *	Called just after data structures for each port are
- *	initialized.  Allocates DMA pad.
+ *	initialized.
  *
  *	May be used as the port_start() entry in ata_port_operations.
  *
@@ -3536,7 +3527,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
  */
 int ata_sas_port_start(struct ata_port *ap)
 {
-	return ata_pad_alloc(ap, ap->dev);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_start);
 
@@ -3544,8 +3535,6 @@ EXPORT_SYMBOL_GPL(ata_sas_port_start);
  *	ata_port_stop - Undo ata_sas_port_start()
  *	@ap: Port to shut down
  *
- *	Frees the DMA pad.
- *
  *	May be used as the port_stop() entry in ata_port_operations.
  *
  *	LOCKING:
@@ -3554,7 +3543,6 @@ EXPORT_SYMBOL_GPL(ata_sas_port_start);
 
 void ata_sas_port_stop(struct ata_port *ap)
 {
-	ata_pad_free(ap, ap->dev);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_stop);
 
@@ -3603,7 +3591,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
  *
  *	RETURNS:
  *	Zero.
- */
+< */
 
 int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
 {
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 842fe08..d53809c 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -303,12 +303,6 @@ static int icside_dma_init(struct pata_icside_info *info)
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
@@ -388,8 +382,6 @@ static struct ata_port_operations pata_icside_port_ops = {
 	.irq_clear		= ata_dummy_noret,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= pata_icside_port_start,
-
 	.bmdma_stop		= pata_icside_bmdma_stop,
 	.bmdma_status		= pata_icside_bmdma_status,
 };
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index d015b4a..7fdab46 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -354,8 +354,8 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 			ata_port_printk(qc->ap, KERN_ERR,
 					"s/g len unaligned : 0x%x\n", sg_len);
 
-		if ((num_prde == (SATA_FSL_MAX_PRD_DIRECT - 1)) &&
-		    (qc->n_iter + 1 != qc->n_elem)) {
+		if (num_prde == (SATA_FSL_MAX_PRD_DIRECT - 1) &&
+		    sg_next(sg) != NULL) {
 			VPRINTK("setting indirect prde\n");
 			prd_ptr_to_indirect_ext = prd;
 			prd->dba = cpu_to_le32(indirect_ext_segment_paddr);
@@ -600,21 +600,9 @@ static int sata_fsl_port_start(struct ata_port *ap)
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
@@ -693,7 +681,6 @@ static void sata_fsl_port_stop(struct ata_port *ap)
 	dma_free_coherent(dev, SATA_FSL_PORT_PRIV_DMA_SZ,
 			  pp->cmdslot, pp->cmdslot_paddr);
 
-	ata_pad_free(ap, dev);
 	kfree(pp);
 }
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 37b850a..94bf504 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1054,7 +1054,6 @@ static int mv_port_start(struct ata_port *ap)
 	void *mem;
 	dma_addr_t mem_dma;
 	unsigned long flags;
-	int rc;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
@@ -1066,10 +1065,6 @@ static int mv_port_start(struct ata_port *ap)
 		return -ENOMEM;
 	memset(mem, 0, MV_PORT_PRIV_DMA_SZ);
 
-	rc = ata_pad_alloc(ap, dev);
-	if (rc)
-		return rc;
-
 	/* First item in chunk of DMA memory:
 	 * 32-slot command request table (CRQB), 32 bytes each in size
 	 */
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index ed5dc7c..7eaacc7 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -2000,7 +2000,7 @@ static void nv_swncq_fill_sg(struct ata_queued_cmd *qc)
 	struct ata_prd *prd;
 
 	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	WARN_ON(qc->n_elem == 0);
 
 	prd = pp->prd + ATA_MAX_PRD * qc->tag;
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 7914def..242949c 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -548,7 +548,7 @@ static void pdc_fill_sg(struct ata_queued_cmd *qc)
 		return;
 
 	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	WARN_ON(qc->n_elem == 0);
 
 	idx = 0;
 	ata_for_each_sg(sg, qc) {
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 2f1de6e..258c482 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -291,7 +291,7 @@ static unsigned int qs_fill_sg(struct ata_queued_cmd *qc)
 	u8 *prd = pp->pkt + QS_CPB_BYTES;
 
 	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	WARN_ON(qc->n_elem == 0);
 
 	nelem = 0;
 	ata_for_each_sg(sg, qc) {
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 96fd526..228c36c 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1232,7 +1232,6 @@ static int sil24_port_start(struct ata_port *ap)
 	union sil24_cmd_block *cb;
 	size_t cb_size = sizeof(*cb) * SIL24_MAX_CMDS;
 	dma_addr_t cb_dma;
-	int rc;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
@@ -1245,10 +1244,6 @@ static int sil24_port_start(struct ata_port *ap)
 		return -ENOMEM;
 	memset(cb, 0, cb_size);
 
-	rc = ata_pad_alloc(ap, dev);
-	if (rc)
-		return rc;
-
 	pp->cmd_block = cb;
 	pp->cmd_block_dma = cb_dma;
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 9018ee8..987f44a 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5140,7 +5140,7 @@ static void ipr_build_ata_ioadl(struct ipr_cmnd *ipr_cmd,
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
 	struct ipr_ioadl_desc *last_ioadl = NULL;
-	int len = qc->nbytes + qc->pad_len;
+	int len = qc->nbytes;
 	struct scatterlist *sg;
 
 	if (len == 0)
@@ -5205,7 +5205,7 @@ static unsigned int ipr_qc_issue(struct ata_queued_cmd *qc)
 	ioarcb->cmd_pkt.request_type = IPR_RQTYPE_ATA_PASSTHRU;
 	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
 	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
-	ipr_cmd->dma_use_sg = qc->pad_len ? qc->n_elem + 1 : qc->n_elem;
+	ipr_cmd->dma_use_sg = qc->n_elem;
 
 	ipr_build_ata_ioadl(ipr_cmd, qc);
 	regs->flags |= IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION;
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 0829b55..78bd2f3 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -178,8 +178,8 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	task->uldd_task = qc;
 	if (is_atapi_taskfile(&qc->tf)) {
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
-		task->total_xfer_len = qc->nbytes + qc->pad_len;
-		task->num_scatter = qc->pad_len ? qc->n_elem + 1 : qc->n_elem;
+		task->total_xfer_len = qc->nbytes;
+		task->num_scatter = qc->n_elem;
 	} else {
 		ata_for_each_sg(sg, qc) {
 			num++;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 124033c..2f40d57 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -282,7 +282,7 @@ enum {
 
 	/* size of buffer to pad xfers ending on unaligned boundaries */
 	ATA_DMA_PAD_SZ		= 4,
-	ATA_DMA_PAD_BUF_SZ	= ATA_DMA_PAD_SZ * ATA_MAX_QUEUE,
+	ATA_DMA_PAD_MASK	= ATA_DMA_PAD_SZ - 1,
 
 	/* ering size */
 	ATA_ERING_SIZE		= 32,
@@ -446,12 +446,9 @@ struct ata_queued_cmd {
 	unsigned long		flags;		/* ATA_QCFLAG_xxx */
 	unsigned int		tag;
 	unsigned int		n_elem;
-	unsigned int		n_iter;
-	unsigned int		orig_n_elem;
 
 	int			dma_dir;
 
-	unsigned int		pad_len;
 	unsigned int		sect_size;
 
 	unsigned int		nbytes;
@@ -461,7 +458,6 @@ struct ata_queued_cmd {
 	unsigned int		cursg_ofs;
 
 	struct scatterlist	sgent;
-	struct scatterlist	pad_sgent;
 	void			*buf_virt;
 
 	/* DO NOT iterate over __sg manually, use ata_for_each_sg() */
@@ -606,9 +602,6 @@ struct ata_port {
 	struct ata_prd		*prd;	 /* our SG list */
 	dma_addr_t		prd_dma; /* and its DMA mapping */
 
-	void			*pad;	/* array of DMA pad buffers */
-	dma_addr_t		pad_dma;
-
 	struct ata_ioports	ioaddr;	/* ATA cmd/ctl/dma register blocks */
 
 	u8			ctl;	/* cache of ATA control register */
@@ -1080,24 +1073,15 @@ extern void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
 static inline struct scatterlist *
 ata_qc_first_sg(struct ata_queued_cmd *qc)
 {
-	qc->n_iter = 0;
 	if (qc->n_elem)
 		return qc->__sg;
-	if (qc->pad_len)
-		return &qc->pad_sgent;
 	return NULL;
 }
 
 static inline struct scatterlist *
 ata_qc_next_sg(struct scatterlist *sg, struct ata_queued_cmd *qc)
 {
-	if (sg == &qc->pad_sgent)
-		return NULL;
-	if (++qc->n_iter < qc->n_elem)
-		return sg_next(sg);
-	if (qc->pad_len)
-		return &qc->pad_sgent;
-	return NULL;
+	return sg_next(sg);
 }
 
 #define ata_for_each_sg(sg, qc) \
@@ -1343,9 +1327,7 @@ static inline void ata_qc_reinit(struct ata_queued_cmd *qc)
 	qc->cursg_ofs = 0;
 	qc->nbytes = qc->curbytes = 0;
 	qc->n_elem = 0;
-	qc->n_iter = 0;
 	qc->err_mask = 0;
-	qc->pad_len = 0;
 	qc->sect_size = ATA_SECT_SIZE;
 
 	ata_tf_init(qc->dev, &qc->tf);
@@ -1379,19 +1361,6 @@ static inline unsigned int __ac_err_mask(u8 status)
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



