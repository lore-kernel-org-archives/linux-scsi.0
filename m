From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 09/24] libata-scsi: convert to use the data buffer accessors
Date: Wed, 12 Sep 2007 02:58:05 +0300
Message-ID: <46E72B8D.1080508@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5713 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932097AbXIKX6j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 19:58:39 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


     This is a minimal patch needed to use the data accessors
     but it is not a complete clean up of the !use_sg path.
     Libata-core still has the qc->flags & ATA_QCFLAG_SG
     and !qc->n_elem code paths. Perhaps an ata maintainer
     would have a go at it.

     - TODO: further cleanup of qc->flags & ATA_QCFLAG_SG
       and !qc->n_elem code paths in libata-core
     - TODO: Use scsi_dma_{map,unmap} where applicable.
---
 drivers/ata/libata-scsi.c |   39 +++++++++++++--------------------------
 1 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e836476..d23a181 100644
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
@@ -1498,17 +1493,13 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
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
@@ -1562,15 +1553,14 @@ static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
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
@@ -1590,12 +1580,9 @@ static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
 
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
@@ -2396,7 +2383,7 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	}
 
 	qc->tf.command = ATA_CMD_PACKET;
-	qc->nbytes = scmd->request_bufflen;
+	qc->nbytes = scsi_bufflen(scmd);
 
 	/* check whether ATAPI DMA is safe */
 	if (!using_pio && ata_check_atapi_dma(qc))
@@ -2631,7 +2618,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	case ATA_CMD_WRITE_LONG_ONCE:
 		if (tf->protocol != ATA_PROT_PIO || tf->nsect != 1)
 			goto invalid_fld;
-		qc->sect_size = scmd->request_bufflen;
+		qc->sect_size = scsi_bufflen(scmd);
 	}
 
 	/*
@@ -2661,7 +2648,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	 * TODO: find out if we need to do more here to
 	 *       cover scatter/gather case.
 	 */
-	qc->nbytes = scmd->request_bufflen;
+	qc->nbytes = scsi_bufflen(scmd);
 
 	/* request result TF */
 	qc->flags |= ATA_QCFLAG_RESULT_TF;
-- 
1.5.3.1


