From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/3] libata: eliminate the home grown dma padding in favour
	of that provided by the block layer
Date: Mon, 04 Feb 2008 10:35:30 -0600
Message-ID: <1202142930.3096.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39816 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbYBDQfj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 11:35:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>

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
 drivers/ata/ahci.c            |    5 --
 drivers/ata/libata-core.c     |  146 +++++-----------------------------------
 drivers/ata/libata-scsi.c     |   23 +-----
 drivers/ata/pata_icside.c     |    8 --
 drivers/ata/sata_fsl.c        |   17 +----
 drivers/ata/sata_mv.c         |    6 +--
 drivers/ata/sata_sil24.c      |    5 --
 drivers/scsi/ipr.c            |    4 +-
 drivers/scsi/libsas/sas_ata.c |    4 +-
 include/linux/libata.h        |   28 +--------
 10 files changed, 31 insertions(+), 215 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 27c8d56..e75966b 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1979,16 +1979,11 @@ static int ahci_port_start(struct ata_port *ap)
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
index bdbd55a..679a404 100644
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
@@ -4476,30 +4478,13 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
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
@@ -4765,97 +4750,6 @@ void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
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
@@ -4872,26 +4766,29 @@ static unsigned int ata_sg_setup_extra(struct ata_queued_cmd *qc,
 static int ata_sg_setup(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	unsigned int n_elem, n_elem_extra, nbytes_extra;
+	unsigned int n_elem;
+	int pad = qc->nbytes & ATA_DMA_PAD_MASK;
 
 	VPRINTK("ENTER, ata%u\n", ap->print_id);
 
-	n_elem = ata_sg_setup_extra(qc, &n_elem_extra, &nbytes_extra);
+	n_elem = qc->n_elem;
+
+	/* needs padding? */
+	if (pad) {
+		struct scatterlist *sg = sg_last(qc->sg, n_elem);
+		qc->nbytes += ATA_DMA_PAD_SZ - pad;
+		sg->length +=  ATA_DMA_PAD_SZ - pad;
+	}
 
-	if (n_elem) {
+	if (qc->n_elem) {
 		n_elem = dma_map_sg(ap->dev, qc->sg, n_elem, qc->dma_dir);
-		if (n_elem < 1) {
-			/* restore last sg */
-			if (qc->last_sg)
-				*qc->last_sg = qc->saved_last_sg;
+		if (n_elem < 1)
 			return -1;
-		}
+
 		DPRINTK("%d sg elements mapped\n", n_elem);
 	}
 
-	qc->n_elem = qc->mapped_n_elem = n_elem;
-	qc->n_elem += n_elem_extra;
-	qc->nbytes += nbytes_extra;
+	qc->n_elem = n_elem;
 	qc->flags |= ATA_QCFLAG_DMAMAP;
 
 	return 0;
@@ -6566,17 +6463,12 @@ void ata_host_resume(struct ata_host *host)
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
index c02c490..8ffff44 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -832,24 +832,12 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
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
-		/* set the min alignment */
-		blk_queue_update_dma_alignment(sdev->request_queue,
-					       ATA_DMA_PAD_SZ - 1);
-	} else
+	if (dev->class == ATA_DEV_ATA) {
 		/* ATA devices must be sector aligned */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_SECT_SIZE - 1);
-
-	if (dev->class == ATA_DEV_ATA)
 		sdev->manage_start_stop = 1;
+	}
 
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
@@ -3555,7 +3543,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
  *	@ap: Port to initialize
  *
  *	Called just after data structures for each port are
- *	initialized.  Allocates DMA pad.
+ *	initialized.
  *
  *	May be used as the port_start() entry in ata_port_operations.
  *
@@ -3564,7 +3552,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
  */
 int ata_sas_port_start(struct ata_port *ap)
 {
-	return ata_pad_alloc(ap, ap->dev);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_start);
 
@@ -3572,8 +3560,6 @@ EXPORT_SYMBOL_GPL(ata_sas_port_start);
  *	ata_port_stop - Undo ata_sas_port_start()
  *	@ap: Port to shut down
  *
- *	Frees the DMA pad.
- *
  *	May be used as the port_stop() entry in ata_port_operations.
  *
  *	LOCKING:
@@ -3582,7 +3568,6 @@ EXPORT_SYMBOL_GPL(ata_sas_port_start);
 
 void ata_sas_port_stop(struct ata_port *ap)
 {
-	ata_pad_free(ap, ap->dev);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_stop);
 
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 5b8586d..f97068b 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -304,12 +304,6 @@ static int icside_dma_init(struct pata_icside_info *info)
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
@@ -389,8 +383,6 @@ static struct ata_port_operations pata_icside_port_ops = {
 	.irq_clear		= ata_dummy_noret,
 	.irq_on			= ata_irq_on,
 
-	.port_start		= pata_icside_port_start,
-
 	.bmdma_stop		= pata_icside_bmdma_stop,
 	.bmdma_status		= pata_icside_bmdma_status,
 };
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 922d7b2..9323dd0 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -355,8 +355,8 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 			ata_port_printk(qc->ap, KERN_ERR,
 					"s/g len unaligned : 0x%x\n", sg_len);
 
-		if ((num_prde == (SATA_FSL_MAX_PRD_DIRECT - 1)) &&
-		    (qc->n_iter + 1 != qc->n_elem)) {
+		if (num_prde == (SATA_FSL_MAX_PRD_DIRECT - 1) &&
+		    sg_next(sg) != NULL) {
 			VPRINTK("setting indirect prde\n");
 			prd_ptr_to_indirect_ext = prd;
 			prd->dba = cpu_to_le32(indirect_ext_segment_paddr);
@@ -601,21 +601,9 @@ static int sata_fsl_port_start(struct ata_port *ap)
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
@@ -694,7 +682,6 @@ static void sata_fsl_port_stop(struct ata_port *ap)
 	dma_free_coherent(dev, SATA_FSL_PORT_PRIV_DMA_SZ,
 			  pp->cmdslot, pp->cmdslot_paddr);
 
-	ata_pad_free(ap, dev);
 	kfree(pp);
 }
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 3c1b5c9..c34ce2f 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1116,17 +1116,13 @@ static int mv_port_start(struct ata_port *ap)
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
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index b4b1f91..df7988d 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1234,7 +1234,6 @@ static int sil24_port_start(struct ata_port *ap)
 	union sil24_cmd_block *cb;
 	size_t cb_size = sizeof(*cb) * SIL24_MAX_CMDS;
 	dma_addr_t cb_dma;
-	int rc;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
@@ -1247,10 +1246,6 @@ static int sil24_port_start(struct ata_port *ap)
 		return -ENOMEM;
 	memset(cb, 0, cb_size);
 
-	rc = ata_pad_alloc(ap, dev);
-	if (rc)
-		return rc;
-
 	pp->cmd_block = cb;
 	pp->cmd_block_dma = cb_dma;
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 73270ff..6762e89 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5140,7 +5140,7 @@ static void ipr_build_ata_ioadl(struct ipr_cmnd *ipr_cmd,
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
 	struct ipr_ioadl_desc *last_ioadl = NULL;
-	int len = qc->nbytes + qc->pad_len;
+	int len = qc->nbytes;
 	struct scatterlist *sg;
 	unsigned int si;
 
@@ -5206,7 +5206,7 @@ static unsigned int ipr_qc_issue(struct ata_queued_cmd *qc)
 	ioarcb->cmd_pkt.request_type = IPR_RQTYPE_ATA_PASSTHRU;
 	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
 	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
-	ipr_cmd->dma_use_sg = qc->pad_len ? qc->n_elem + 1 : qc->n_elem;
+	ipr_cmd->dma_use_sg = qc->n_elem;
 
 	ipr_build_ata_ioadl(ipr_cmd, qc);
 	regs->flags |= IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION;
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 0996f86..7cd05b5 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -178,8 +178,8 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
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
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 4374c42..be2ace3 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -278,7 +278,7 @@ enum {
 
 	/* size of buffer to pad xfers ending on unaligned boundaries */
 	ATA_DMA_PAD_SZ		= 4,
-	ATA_DMA_PAD_BUF_SZ	= ATA_DMA_PAD_SZ * ATA_MAX_QUEUE,
+	ATA_DMA_PAD_MASK	= ATA_DMA_PAD_SZ - 1,
 
 	/* ering size */
 	ATA_ERING_SIZE		= 32,
@@ -457,12 +457,9 @@ struct ata_queued_cmd {
 	unsigned long		flags;		/* ATA_QCFLAG_xxx */
 	unsigned int		tag;
 	unsigned int		n_elem;
-	unsigned int		n_iter;
-	unsigned int		mapped_n_elem;
 
 	int			dma_dir;
 
-	unsigned int		pad_len;
 	unsigned int		sect_size;
 
 	unsigned int		nbytes;
@@ -472,10 +469,7 @@ struct ata_queued_cmd {
 	struct scatterlist	*cursg;
 	unsigned int		cursg_ofs;
 
-	struct scatterlist	*last_sg;
-	struct scatterlist	saved_last_sg;
 	struct scatterlist	sgent;
-	struct scatterlist	extra_sg[2];
 
 	struct scatterlist	*sg;
 
@@ -620,9 +614,6 @@ struct ata_port {
 	struct ata_prd		*prd;	 /* our SG list */
 	dma_addr_t		prd_dma; /* and its DMA mapping */
 
-	void			*pad;	/* array of DMA pad buffers */
-	dma_addr_t		pad_dma;
-
 	struct ata_ioports	ioaddr;	/* ATA cmd/ctl/dma register blocks */
 
 	u8			ctl;	/* cache of ATA control register */
@@ -1366,11 +1357,7 @@ static inline void ata_qc_reinit(struct ata_queued_cmd *qc)
 	qc->cursg_ofs = 0;
 	qc->nbytes = qc->raw_nbytes = qc->curbytes = 0;
 	qc->n_elem = 0;
-	qc->mapped_n_elem = 0;
-	qc->n_iter = 0;
 	qc->err_mask = 0;
-	qc->pad_len = 0;
-	qc->last_sg = NULL;
 	qc->sect_size = ATA_SECT_SIZE;
 
 	ata_tf_init(qc->dev, &qc->tf);
@@ -1425,19 +1412,6 @@ static inline unsigned int __ac_err_mask(u8 status)
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
-- 
1.5.3.8



