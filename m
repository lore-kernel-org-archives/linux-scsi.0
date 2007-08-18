From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] libata sg chaining support fix
Date: Sat, 18 Aug 2007 18:47:57 +0900
Message-ID: <200708180947.l7I9lw82005487@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:50167 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbXHRJsM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Aug 2007 05:48:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

This fixes 'trailing data' bug in the sglist libata patch in Jens'
block git tree.

Aug 18 16:03:03 tulip kernel: ata1.00: 36 bytes trailing data
Aug 18 16:03:03 tulip kernel: scsi scan: INQUIRY result too short (5), using 36


With the patch, sglist could be sent to -mm (I guess that Andrew hit
this bug). But I'm still not sure about the sglist libata patch
(especially about the padding path). It would be better to drop the
sglist libata patch with my use_sg_chaining option patch and send
sglist to -mm, I think.

http://marc.info/?l=linux-scsi&m=118728307617958&w=2

I guess that it would be better to leave sglist libata conversion in
the maintainers' hands.

---
>From 86d7a796417bde84fc3cbe6ac6ebaaa524266092 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Sat, 18 Aug 2007 18:27:36 +0900
Subject: [PATCH] libata sg chaining support fix

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/ata/libata-core.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f37eecc..52f75c3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4648,16 +4648,18 @@ static void __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 {
 	int do_write = (qc->tf.flags & ATA_TFLAG_WRITE);
 	struct scatterlist *sg = qc->__sg;
+	struct scatterlist *lsg = sg_last(qc->__sg, qc->n_elem);
 	struct ata_port *ap = qc->ap;
 	struct page *page;
 	unsigned char *buf;
 	unsigned int offset, count;
+	int no_more_sg = 0;
 
 	if (qc->curbytes + bytes >= qc->nbytes)
 		ap->hsm_task_state = HSM_ST_LAST;
 
 next_sg:
-	if (unlikely(qc->cursg == sg_last(qc->__sg, qc->n_elem))) {
+	if (unlikely(no_more_sg)) {
 		/*
 		 * The end of qc->sg is reached and the device expects
 		 * more data to transfer. In order not to overrun qc->sg
@@ -4719,6 +4721,9 @@ next_sg:
 	qc->cursg_ofs += count;
 
 	if (qc->cursg_ofs == sg->length) {
+		if (qc->cursg == lsg)
+			no_more_sg = 1;
+
 		qc->cursg = sg_next(qc->cursg);
 		qc->cursg_ofs = 0;
 	}
-- 
1.5.2.4

