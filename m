From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH ver2 2/2] libata-scsi: convert to use the data buffer accessors
Date: Tue, 18 Sep 2007 17:48:50 +0200
Message-ID: <46EFF362.50308@panasas.com>
References: <46E6F92D.2090409@panasas.com> <46E72B8D.1080508@panasas.com> <46E72E4F.9020508@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa3.bezeqint.net ([192.115.104.17]:40446 "EHLO sa3.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478AbXIRPtA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2007 11:49:00 -0400
In-Reply-To: <46E72E4F.9020508@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>


  simple search-and-replace of direct scsi_cmnd access to
  use the data buffer accessors.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/ata/libata-scsi.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 6145a64..d23a181 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -450,8 +450,8 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 		qc->scsicmd = cmd;
 		qc->scsidone = done;
 
-		qc->__sg = (struct scatterlist *) cmd->request_buffer;
-		qc->n_elem = cmd->use_sg;
+		qc->__sg = scsi_sglist(cmd);
+		qc->n_elem = scsi_sg_count(cmd);
 	} else {
 		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
 		done(cmd);
@@ -1493,13 +1493,13 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	/* data is present; dma-map it */
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE ||
 	    cmd->sc_data_direction == DMA_TO_DEVICE) {
-		if (unlikely(cmd->request_bufflen < 1)) {
+		if (unlikely(scsi_bufflen(cmd) < 1)) {
 			ata_dev_printk(dev, KERN_WARNING,
 				       "WARNING: zero len r/w req\n");
 			goto err_did;
 		}
 
-		ata_sg_init(qc, cmd->request_buffer, cmd->use_sg);
+		ata_sg_init(qc, scsi_sglist(cmd), scsi_sg_count(cmd));
 
 		qc->dma_dir = cmd->sc_data_direction;
 	}
@@ -1553,7 +1553,7 @@ static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
 	u8 *buf;
 	unsigned int buflen;
 
-	struct scatterlist *sg = (struct scatterlist *) cmd->request_buffer;
+	struct scatterlist *sg = scsi_sglist(cmd);
 
 	if (sg) {
 		buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
@@ -1580,7 +1580,7 @@ static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
 
 static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, u8 *buf)
 {
-	struct scatterlist *sg = (struct scatterlist *) cmd->request_buffer;
+	struct scatterlist *sg = scsi_sglist(cmd);
 	if (sg)
 		kunmap_atomic(buf - sg->offset, KM_IRQ0);
 }
@@ -2383,7 +2383,7 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	}
 
 	qc->tf.command = ATA_CMD_PACKET;
-	qc->nbytes = scmd->request_bufflen;
+	qc->nbytes = scsi_bufflen(scmd);
 
 	/* check whether ATAPI DMA is safe */
 	if (!using_pio && ata_check_atapi_dma(qc))
@@ -2618,7 +2618,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	case ATA_CMD_WRITE_LONG_ONCE:
 		if (tf->protocol != ATA_PROT_PIO || tf->nsect != 1)
 			goto invalid_fld;
-		qc->sect_size = scmd->request_bufflen;
+		qc->sect_size = scsi_bufflen(scmd);
 	}
 
 	/*
@@ -2648,7 +2648,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	 * TODO: find out if we need to do more here to
 	 *       cover scatter/gather case.
 	 */
-	qc->nbytes = scmd->request_bufflen;
+	qc->nbytes = scsi_bufflen(scmd);
 
 	/* request result TF */
 	qc->flags |= ATA_QCFLAG_RESULT_TF;
-- 
1.5.3.1


