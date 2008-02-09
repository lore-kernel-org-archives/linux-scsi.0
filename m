From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 1/7] libata: update ATAPI overflow draining
Date: Sat,  9 Feb 2008 10:40:20 +0900
Message-ID: <12025212273000-git-send-email-htejun@gmail.com>
References: <12025212262892-git-send-email-htejun@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.184]:56720 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbYBIBkf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 20:40:35 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2705686rvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Feb 2008 17:40:34 -0800 (PST)
In-Reply-To: <12025212262892-git-send-email-htejun@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: Tejun Heo <htejun@gmail.com>

For misc ATAPI commands which transfer variable length data to the
host, overflow can occur due to application or hardware bug.  Such
overflows can be ignored safely as long as overflow data is properly
drained.  libata HSM implementation has this implemented in
__atapi_pio_bytes() and recently updated for 2.6.24-rc but it requires
further improvements.  Improve drain logic such that...

* Report overflow errors using ehi desc mechanism instead of printing
  directly.

* Properly calculate the number of bytes to be drained considering
  actual number of consumed bytes for partial draining.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Albert Lee <albertcc@tw.ibm.com>
---
 drivers/ata/libata-core.c |   76 +++++++++++++++++++-------------------------
 1 files changed, 33 insertions(+), 43 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3011919..ecb8275 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4656,24 +4656,9 @@ int ata_check_atapi_dma(struct ata_queued_cmd *qc)
  */
 static int atapi_qc_may_overflow(struct ata_queued_cmd *qc)
 {
-	if (qc->tf.protocol != ATAPI_PROT_PIO &&
-	    qc->tf.protocol != ATAPI_PROT_DMA)
-		return 0;
-
-	if (qc->tf.flags & ATA_TFLAG_WRITE)
-		return 0;
-
-	switch (qc->cdb[0]) {
-	case READ_10:
-	case READ_12:
-	case WRITE_10:
-	case WRITE_12:
-	case GPCMD_READ_CD:
-	case GPCMD_READ_CD_MSF:
-		return 0;
-	}
-
-	return 1;
+	return ata_is_atapi(qc->tf.protocol) && ata_is_data(qc->tf.protocol) &&
+		atapi_cmd_type(qc->cdb[0]) == ATAPI_MISC &&
+		!(qc->tf.flags & ATA_TFLAG_WRITE);
 }
 
 /**
@@ -5127,13 +5112,14 @@ static void atapi_send_cdb(struct ata_port *ap, struct ata_queued_cmd *qc)
  */
 static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 {
-	int do_write = (qc->tf.flags & ATA_TFLAG_WRITE);
+	int rw = (qc->tf.flags & ATA_TFLAG_WRITE) ? WRITE : READ;
 	struct ata_port *ap = qc->ap;
-	struct ata_eh_info *ehi = &qc->dev->link->eh_info;
+	struct ata_device *dev = qc->dev;
+	struct ata_eh_info *ehi = &dev->link->eh_info;
 	struct scatterlist *sg;
 	struct page *page;
 	unsigned char *buf;
-	unsigned int offset, count;
+	unsigned int offset, count, consumed;
 
 next_sg:
 	sg = qc->cursg;
@@ -5146,26 +5132,27 @@ next_sg:
 		 *    - for write case, padding zero data to the device
 		 */
 		u16 pad_buf[1] = { 0 };
-		unsigned int i;
 
-		if (bytes > qc->curbytes - qc->nbytes + ATAPI_MAX_DRAIN) {
+		if (qc->curbytes + bytes > qc->nbytes + ATAPI_MAX_DRAIN) {
 			ata_ehi_push_desc(ehi, "too much trailing data "
 					  "buf=%u cur=%u bytes=%u",
 					  qc->nbytes, qc->curbytes, bytes);
 			return -1;
 		}
 
-		 /* overflow is exptected for misc ATAPI commands */
-		if (bytes && !atapi_qc_may_overflow(qc))
-			ata_dev_printk(qc->dev, KERN_WARNING, "ATAPI %u bytes "
-				       "trailing data (cdb=%02x nbytes=%u)\n",
-				       bytes, qc->cdb[0], qc->nbytes);
+		/* allow overflow only for misc ATAPI commands */
+		if (!atapi_qc_may_overflow(qc)) {
+			ata_ehi_push_desc(ehi, "unexpected trailing data "
+					  "%u bytes", bytes);
+			return -1;
+		}
 
-		for (i = 0; i < (bytes + 1) / 2; i++)
-			ap->ops->data_xfer(qc->dev, (unsigned char *)pad_buf, 2, do_write);
+		consumed = 0;
+		while (consumed < bytes)
+			consumed += ap->ops->data_xfer(dev,
+					(unsigned char *)pad_buf, 2, rw);
 
 		qc->curbytes += bytes;
-
 		return 0;
 	}
 
@@ -5192,18 +5179,16 @@ next_sg:
 		buf = kmap_atomic(page, KM_IRQ0);
 
 		/* do the actual data transfer */
-		ap->ops->data_xfer(qc->dev,  buf + offset, count, do_write);
+		consumed = ap->ops->data_xfer(dev,  buf + offset, count, rw);
 
 		kunmap_atomic(buf, KM_IRQ0);
 		local_irq_restore(flags);
 	} else {
 		buf = page_address(page);
-		ap->ops->data_xfer(qc->dev,  buf + offset, count, do_write);
+		consumed = ap->ops->data_xfer(dev,  buf + offset, count, rw);
 	}
 
-	bytes -= count;
-	if ((count & 1) && bytes)
-		bytes--;
+	bytes -= min(bytes, consumed);
 	qc->curbytes += count;
 	qc->cursg_ofs += count;
 
@@ -5212,9 +5197,11 @@ next_sg:
 		qc->cursg_ofs = 0;
 	}
 
+	/* consumed can be larger than count only for the last transfer */
+	WARN_ON(qc->cursg && count != consumed);
+
 	if (bytes)
 		goto next_sg;
-
 	return 0;
 }
 
@@ -5232,6 +5219,7 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct ata_device *dev = qc->dev;
+	struct ata_eh_info *ehi = &dev->link->eh_info;
 	unsigned int ireason, bc_lo, bc_hi, bytes;
 	int i_write, do_write = (qc->tf.flags & ATA_TFLAG_WRITE) ? 1 : 0;
 
@@ -5249,26 +5237,28 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 
 	/* shall be cleared to zero, indicating xfer of data */
 	if (unlikely(ireason & (1 << 0)))
-		goto err_out;
+		goto atapi_check;
 
 	/* make sure transfer direction matches expected */
 	i_write = ((ireason & (1 << 1)) == 0) ? 1 : 0;
 	if (unlikely(do_write != i_write))
-		goto err_out;
+		goto atapi_check;
 
 	if (unlikely(!bytes))
-		goto err_out;
+		goto atapi_check;
 
 	VPRINTK("ata%u: xfering %d bytes\n", ap->print_id, bytes);
 
-	if (__atapi_pio_bytes(qc, bytes))
+	if (unlikely(__atapi_pio_bytes(qc, bytes)))
 		goto err_out;
 	ata_altstatus(ap); /* flush */
 
 	return;
 
-err_out:
-	ata_dev_printk(dev, KERN_INFO, "ATAPI check failed\n");
+ atapi_check:
+	ata_ehi_push_desc(ehi, "ATAPI check failed (ireason=0x%x bytes=%u)",
+			  ireason, bytes);
+ err_out:
 	qc->err_mask |= AC_ERR_HSM;
 	ap->hsm_task_state = HSM_ST_ERR;
 }
-- 
1.5.2.4

