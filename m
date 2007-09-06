From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 9/9] libata-scsi: convert to use the data buffer accessors
Date: Fri, 7 Sep 2007 06:50:38 +0900
Message-ID: <20070906184107E.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43067 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369AbXIFVww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 17:52:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jeff@garzik.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp

From: Boaz Harrosh <bharrosh@panasas.com>

This is a minimal patch needed if we want to use the new
scsi_data_buffer implementation, by useing of the new data
accessors. But it is not a complete clean up of the !use_sg path.
Libata-core still has the qc->flags & ATA_QCFLAG_SG and !qc->n_elem
code paths. Perhaps an ata maintainer would have a go at it.

- use of new data accessors.
- clean some of the more obvious !use_sg path
- TODO: farther cleanup of qc->flags & ATA_QCFLAG_SG
  and !qc->n_elem code paths in libata-core
- TODO: Use of new scsi_dma_{map,unmap} if applicable.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/ata/libata-scsi.c |   39 +++++++++++++--------------------------
 1 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5194f3d..01a0197 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -450,13 +450,8 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 		qc->scsicmd = cmd;
 		qc->scsidone = done;
 
-		if (cmd->use_sg) {
-			qc->__sg = (struct scatterlist *) cmd->request_buffer;
-			qc->n_elem = cmd->use_sg;
-		} else if (cmd->request_bufflen) {
-			qc->__sg = &qc->sgent;
-			qc->n_elem = 1;
-		}
+		qc->__sg = scsi_sglist(cmd);
+		qc->n_elem = scsi_sg_count(cmd);
 	} else {
 		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
 		done(cmd);
@@ -1496,17 +1491,13 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	/* data is present; dma-map it */
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE ||
 	    cmd->sc_data_direction == DMA_TO_DEVICE) {
-		if (unlikely(cmd->request_bufflen < 1)) {
+		if (unlikely(scsi_bufflen(cmd) < 1)) {
 			ata_dev_printk(dev, KERN_WARNING,
 				       "WARNING: zero len r/w req\n");
 			goto err_did;
 		}
 
-		if (cmd->use_sg)
-			ata_sg_init(qc, cmd->request_buffer, cmd->use_sg);
-		else
-			ata_sg_init_one(qc, cmd->request_buffer,
-					cmd->request_bufflen);
+		ata_sg_init(qc, scsi_sglist(cmd), scsi_sg_count(cmd));
 
 		qc->dma_dir = cmd->sc_data_direction;
 	}
@@ -1560,15 +1551,14 @@ static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
 	u8 *buf;
 	unsigned int buflen;
 
-	if (cmd->use_sg) {
-		struct scatterlist *sg;
+	struct scatterlist *sg = scsi_sglist(cmd);
 
-		sg = (struct scatterlist *) cmd->request_buffer;
+	if (sg) {
 		buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
 		buflen = sg->length;
 	} else {
-		buf = cmd->request_buffer;
-		buflen = cmd->request_bufflen;
+		buf = NULL;
+		buflen = 0;
 	}
 
 	*buf_out = buf;
@@ -1588,12 +1578,9 @@ static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
 
 static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, u8 *buf)
 {
-	if (cmd->use_sg) {
-		struct scatterlist *sg;
-
-		sg = (struct scatterlist *) cmd->request_buffer;
+	struct scatterlist *sg = scsi_sglist(cmd);
+	if (sg)
 		kunmap_atomic(buf - sg->offset, KM_IRQ0);
-	}
 }
 
 /**
@@ -2394,7 +2381,7 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	}
 
 	qc->tf.command = ATA_CMD_PACKET;
-	qc->nbytes = scmd->request_bufflen;
+	qc->nbytes = scsi_bufflen(scmd);
 
 	/* check whether ATAPI DMA is safe */
 	if (!using_pio && ata_check_atapi_dma(qc))
@@ -2629,7 +2616,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	case ATA_CMD_WRITE_LONG_ONCE:
 		if (tf->protocol != ATA_PROT_PIO || tf->nsect != 1)
 			goto invalid_fld;
-		qc->sect_size = scmd->request_bufflen;
+		qc->sect_size = scsi_bufflen(scmd);
 	}
 
 	/*
@@ -2659,7 +2646,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	 * TODO: find out if we need to do more here to
 	 *       cover scatter/gather case.
 	 */
-	qc->nbytes = scmd->request_bufflen;
+	qc->nbytes = scsi_bufflen(scmd);
 
 	/* request result TF */
 	qc->flags |= ATA_QCFLAG_RESULT_TF;
-- 
1.5.2.4

