From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 18/33] libata: convert to using sg helpers
Date: Mon, 16 Jul 2007 11:47:32 +0200
Message-ID: <1184579268910-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9305 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760556AbXGPJsi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:38 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, jgarzik@pobox.com, htejun@gmail.com

This converts libata to using the sg helpers for looking up sg
elements, instead of doing it manually.

Cc: jgarzik@pobox.com
Cc: htejun@gmail.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/ata/libata-core.c |   30 ++++++++++++++++--------------
 include/linux/libata.h    |   16 ++++++++++------
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 88e2dd0..788dc7b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1341,7 +1341,7 @@ static void ata_qc_complete_internal(struct ata_queued_cmd *qc)
  */
 unsigned ata_exec_internal_sg(struct ata_device *dev,
 			      struct ata_taskfile *tf, const u8 *cdb,
-			      int dma_dir, struct scatterlist *sg,
+			      int dma_dir, struct scatterlist *sgl,
 			      unsigned int n_elem)
 {
 	struct ata_port *ap = dev->ap;
@@ -1399,11 +1399,12 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	qc->dma_dir = dma_dir;
 	if (dma_dir != DMA_NONE) {
 		unsigned int i, buflen = 0;
+		struct scatterlist *sg;
 
-		for (i = 0; i < n_elem; i++)
-			buflen += sg[i].length;
+		for_each_sg(sgl, sg, n_elem, i)
+			buflen += sg->length;
 
-		ata_sg_init(qc, sg, n_elem);
+		ata_sg_init(qc, sgl, n_elem);
 		qc->nbytes = buflen;
 	}
 
@@ -4000,7 +4001,7 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
 		if (qc->n_elem)
 			dma_unmap_sg(ap->dev, sg, qc->n_elem, dir);
 		/* restore last sg */
-		sg[qc->orig_n_elem - 1].length += qc->pad_len;
+		sg_last(sg, qc->orig_n_elem)->length += qc->pad_len;
 		if (pad_buf) {
 			struct scatterlist *psg = &qc->pad_sgent;
 			void *addr = kmap_atomic(psg->page, KM_IRQ0);
@@ -4225,6 +4226,7 @@ void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf, unsigned int buflen)
 	qc->orig_n_elem = 1;
 	qc->buf_virt = buf;
 	qc->nbytes = buflen;
+	qc->cursg = qc->__sg;
 
 	sg_init_one(&qc->sgent, buf, buflen);
 }
@@ -4250,6 +4252,7 @@ void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
 	qc->__sg = sg;
 	qc->n_elem = n_elem;
 	qc->orig_n_elem = n_elem;
+	qc->cursg = qc->__sg;
 }
 
 /**
@@ -4339,7 +4342,7 @@ static int ata_sg_setup(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg = qc->__sg;
-	struct scatterlist *lsg = &sg[qc->n_elem - 1];
+	struct scatterlist *lsg = sg_last(qc->__sg, qc->n_elem);
 	int n_elem, pre_n_elem, dir, trim_sg = 0;
 
 	VPRINTK("ENTER, ata%u\n", ap->print_id);
@@ -4503,7 +4506,6 @@ void ata_data_xfer_noirq(struct ata_device *adev, unsigned char *buf,
 static void ata_pio_sector(struct ata_queued_cmd *qc)
 {
 	int do_write = (qc->tf.flags & ATA_TFLAG_WRITE);
-	struct scatterlist *sg = qc->__sg;
 	struct ata_port *ap = qc->ap;
 	struct page *page;
 	unsigned int offset;
@@ -4512,8 +4514,8 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	if (qc->curbytes == qc->nbytes - qc->sect_size)
 		ap->hsm_task_state = HSM_ST_LAST;
 
-	page = sg[qc->cursg].page;
-	offset = sg[qc->cursg].offset + qc->cursg_ofs;
+	page = qc->cursg->page;
+	offset = qc->cursg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
 	page = nth_page(page, (offset >> PAGE_SHIFT));
@@ -4541,8 +4543,8 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	qc->curbytes += qc->sect_size;
 	qc->cursg_ofs += qc->sect_size;
 
-	if (qc->cursg_ofs == (&sg[qc->cursg])->length) {
-		qc->cursg++;
+	if (qc->cursg_ofs == qc->cursg->length) {
+		qc->cursg = sg_next(qc->cursg);
 		qc->cursg_ofs = 0;
 	}
 }
@@ -4635,7 +4637,7 @@ static void __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 		ap->hsm_task_state = HSM_ST_LAST;
 
 next_sg:
-	if (unlikely(qc->cursg >= qc->n_elem)) {
+	if (unlikely(qc->cursg == sg_last(qc->__sg, qc->n_elem))) {
 		/*
 		 * The end of qc->sg is reached and the device expects
 		 * more data to transfer. In order not to overrun qc->sg
@@ -4658,7 +4660,7 @@ next_sg:
 		return;
 	}
 
-	sg = &qc->__sg[qc->cursg];
+	sg = qc->cursg;
 
 	page = sg->page;
 	offset = sg->offset + qc->cursg_ofs;
@@ -4697,7 +4699,7 @@ next_sg:
 	qc->cursg_ofs += count;
 
 	if (qc->cursg_ofs == sg->length) {
-		qc->cursg++;
+		qc->cursg = sg_next(qc->cursg);
 		qc->cursg_ofs = 0;
 	}
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 47cd2a1..005b159 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -30,7 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/io.h>
 #include <linux/ata.h>
 #include <linux/workqueue.h>
@@ -386,6 +386,7 @@ struct ata_queued_cmd {
 	unsigned long		flags;		/* ATA_QCFLAG_xxx */
 	unsigned int		tag;
 	unsigned int		n_elem;
+	unsigned int		n_iter;
 	unsigned int		orig_n_elem;
 
 	int			dma_dir;
@@ -396,7 +397,7 @@ struct ata_queued_cmd {
 	unsigned int		nbytes;
 	unsigned int		curbytes;
 
-	unsigned int		cursg;
+	struct scatterlist	*cursg;
 	unsigned int		cursg_ofs;
 
 	struct scatterlist	sgent;
@@ -943,7 +944,7 @@ ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
 		return 1;
 	if (qc->pad_len)
 		return 0;
-	if (((sg - qc->__sg) + 1) == qc->n_elem)
+	if (qc->n_iter == qc->n_elem)
 		return 1;
 	return 0;
 }
@@ -951,6 +952,7 @@ ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
 static inline struct scatterlist *
 ata_qc_first_sg(struct ata_queued_cmd *qc)
 {
+	qc->n_iter = 0;
 	if (qc->n_elem)
 		return qc->__sg;
 	if (qc->pad_len)
@@ -963,8 +965,8 @@ ata_qc_next_sg(struct scatterlist *sg, struct ata_queued_cmd *qc)
 {
 	if (sg == &qc->pad_sgent)
 		return NULL;
-	if (++sg - qc->__sg < qc->n_elem)
-		return sg;
+	if (++qc->n_iter < qc->n_elem)
+		return sg_next(sg);
 	if (qc->pad_len)
 		return &qc->pad_sgent;
 	return NULL;
@@ -1158,9 +1160,11 @@ static inline void ata_qc_reinit(struct ata_queued_cmd *qc)
 	qc->dma_dir = DMA_NONE;
 	qc->__sg = NULL;
 	qc->flags = 0;
-	qc->cursg = qc->cursg_ofs = 0;
+	qc->cursg = NULL;
+	qc->cursg_ofs = 0;
 	qc->nbytes = qc->curbytes = 0;
 	qc->n_elem = 0;
+	qc->n_iter = 0;
 	qc->err_mask = 0;
 	qc->pad_len = 0;
 	qc->sect_size = ATA_SECT_SIZE;
-- 
1.5.3.rc0.90.gbaa79

