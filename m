From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH ver2 1/2] libata-scsi: Remove !use_sg code paths
Date: Tue, 18 Sep 2007 17:46:12 +0200
Message-ID: <46EFF2C4.8050204@panasas.com>
References: <46E6F92D.2090409@panasas.com> <46E72B8D.1080508@panasas.com> <46E72E4F.9020508@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa3.bezeqint.net ([192.115.104.17]:39817 "EHLO sa3.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759043AbXIRPqX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2007 11:46:23 -0400
In-Reply-To: <46E72E4F.9020508@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>


     This is a minimal patch needed to remove use of !use_sg
     but it is not a complete clean up of the !use_sg paths.
     Libata-core still has the qc->flags & ATA_QCFLAG_SG
     and !qc->n_elem code paths. Perhaps an ata maintainer
     would have a go at it.

     - TODO: further cleanup of qc->flags & ATA_QCFLAG_SG
       and !qc->n_elem code paths in libata-core
     - TODO: Use scsi_dma_{map,unmap} where applicable.
---
 drivers/ata/libata-scsi.c |   31 +++++++++----------------------
 1 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e836476..6145a64 100644
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
+		qc->__sg = (struct scatterlist *) cmd->request_buffer;
+		qc->n_elem = cmd->use_sg;
 	} else {
 		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
 		done(cmd);
@@ -1504,11 +1499,7 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			goto err_did;
 		}
 
-		if (cmd->use_sg)
-			ata_sg_init(qc, cmd->request_buffer, cmd->use_sg);
-		else
-			ata_sg_init_one(qc, cmd->request_buffer,
-					cmd->request_bufflen);
+		ata_sg_init(qc, cmd->request_buffer, cmd->use_sg);
 
 		qc->dma_dir = cmd->sc_data_direction;
 	}
@@ -1562,15 +1553,14 @@ static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
 	u8 *buf;
 	unsigned int buflen;
 
-	if (cmd->use_sg) {
-		struct scatterlist *sg;
+	struct scatterlist *sg = (struct scatterlist *) cmd->request_buffer;
 
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
+	struct scatterlist *sg = (struct scatterlist *) cmd->request_buffer;
+	if (sg)
 		kunmap_atomic(buf - sg->offset, KM_IRQ0);
-	}
 }
 
 /**
-- 
1.5.3.1


