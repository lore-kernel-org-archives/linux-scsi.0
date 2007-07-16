From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 26/33] aha1542: convert to use the data buffer accessors
Date: Mon, 16 Jul 2007 11:47:40 +0200
Message-ID: <11845792682312-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9307 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760818AbXGPJsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:39 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/aha1542.c |   32 +++++++++++++++-----------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index cbbfbc9..961a188 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -61,15 +61,15 @@ static void BAD_DMA(void *address, unsigned int length)
 }
 
 static void BAD_SG_DMA(Scsi_Cmnd * SCpnt,
-		       struct scatterlist *sgpnt,
+		       struct scatterlist *sgp,
 		       int nseg,
 		       int badseg)
 {
 	printk(KERN_CRIT "sgpnt[%d:%d] page %p/0x%llx length %u\n",
 	       badseg, nseg,
-	       page_address(sgpnt[badseg].page) + sgpnt[badseg].offset,
-	       (unsigned long long)SCSI_SG_PA(&sgpnt[badseg]),
-	       sgpnt[badseg].length);
+	       page_address(sgp->page) + sgp->offset,
+	       (unsigned long long)SCSI_SG_PA(sgp),
+	       sgp->length);
 
 	/*
 	 * Not safe to continue.
@@ -691,7 +691,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	memcpy(ccb[mbo].cdb, cmd, ccb[mbo].cdblen);
 
 	if (SCpnt->use_sg) {
-		struct scatterlist *sgpnt;
+		struct scatterlist *sg;
 		struct chain *cptr;
 #ifdef DEBUG
 		unsigned char *ptr;
@@ -699,23 +699,21 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 		int i;
 		ccb[mbo].op = 2;	/* SCSI Initiator Command  w/scatter-gather */
 		SCpnt->host_scribble = kmalloc(512, GFP_KERNEL | GFP_DMA);
-		sgpnt = (struct scatterlist *) SCpnt->request_buffer;
 		cptr = (struct chain *) SCpnt->host_scribble;
 		if (cptr == NULL) {
 			/* free the claimed mailbox slot */
 			HOSTDATA(SCpnt->device->host)->SCint[mbo] = NULL;
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
-		for (i = 0; i < SCpnt->use_sg; i++) {
-			if (sgpnt[i].length == 0 || SCpnt->use_sg > 16 ||
-			    (((int) sgpnt[i].offset) & 1) || (sgpnt[i].length & 1)) {
+		scsi_for_each_sg(SCpnt, sg, SCpnt->use_sg, i) {
+			if (sg->length == 0 || SCpnt->use_sg > 16 ||
+			    (((int) sg->offset) & 1) || (sg->length & 1)) {
 				unsigned char *ptr;
 				printk(KERN_CRIT "Bad segment list supplied to aha1542.c (%d, %d)\n", SCpnt->use_sg, i);
-				for (i = 0; i < SCpnt->use_sg; i++) {
+				scsi_for_each_sg(SCpnt, sg, SCpnt->use_sg, i) {
 					printk(KERN_CRIT "%d: %p %d\n", i,
-					       (page_address(sgpnt[i].page) +
-						sgpnt[i].offset),
-					       sgpnt[i].length);
+					       (page_address(sg->page) +
+						sg->offset), sg->length);
 				};
 				printk(KERN_CRIT "cptr %x: ", (unsigned int) cptr);
 				ptr = (unsigned char *) &cptr[i];
@@ -723,10 +721,10 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 					printk("%02x ", ptr[i]);
 				panic("Foooooooood fight!");
 			};
-			any2scsi(cptr[i].dataptr, SCSI_SG_PA(&sgpnt[i]));
-			if (SCSI_SG_PA(&sgpnt[i]) + sgpnt[i].length - 1 > ISA_DMA_THRESHOLD)
-				BAD_SG_DMA(SCpnt, sgpnt, SCpnt->use_sg, i);
-			any2scsi(cptr[i].datalen, sgpnt[i].length);
+			any2scsi(cptr[i].dataptr, SCSI_SG_PA(sg));
+			if (SCSI_SG_PA(sg) + sg->length - 1 > ISA_DMA_THRESHOLD)
+				BAD_SG_DMA(SCpnt, sg, SCpnt->use_sg, i);
+			any2scsi(cptr[i].datalen, sg->length);
 		};
 		any2scsi(ccb[mbo].datalen, SCpnt->use_sg * sizeof(struct chain));
 		any2scsi(ccb[mbo].dataptr, SCSI_BUF_PA(cptr));
-- 
1.5.3.rc0.90.gbaa79

