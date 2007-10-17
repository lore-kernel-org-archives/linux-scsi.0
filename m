From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 13/32] aha1542.c: convert to accessors and !use_sg cleanup
Date: Wed, 17 Oct 2007 19:53:11 +0200
Message-ID: <47164C07.1070301@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6423 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936509AbXJQRyA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 13:54:00 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


 - convert to accessors and !use_sg cleanup

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/aha1542.c |   46 ++++++++++------------------------------------
 1 files changed, 10 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 961a188..3eab68f 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -51,15 +51,6 @@
 #define SCSI_BUF_PA(address)	isa_virt_to_bus(address)
 #define SCSI_SG_PA(sgent)	(isa_page_to_bus((sgent)->page) + (sgent)->offset)
 
-static void BAD_DMA(void *address, unsigned int length)
-{
-	printk(KERN_CRIT "buf vaddress %p paddress 0x%lx length %d\n",
-	       address,
-	       SCSI_BUF_PA(address),
-	       length);
-	panic("Buffer at physical address > 16Mb used for aha1542");
-}
-
 static void BAD_SG_DMA(Scsi_Cmnd * SCpnt,
 		       struct scatterlist *sgp,
 		       int nseg,
@@ -598,8 +589,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	unchar target = SCpnt->device->id;
 	unchar lun = SCpnt->device->lun;
 	unsigned long flags;
-	void *buff = SCpnt->request_buffer;
-	int bufflen = SCpnt->request_bufflen;
+	int bufflen = scsi_bufflen(SCpnt);
 	int mbo;
 	struct mailbox *mb;
 	struct ccb *ccb;
@@ -690,43 +680,29 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 
 	memcpy(ccb[mbo].cdb, cmd, ccb[mbo].cdblen);
 
-	if (SCpnt->use_sg) {
+	if (bufflen) {
 		struct scatterlist *sg;
 		struct chain *cptr;
 #ifdef DEBUG
 		unsigned char *ptr;
 #endif
-		int i;
+		int i, sg_count = scsi_sg_count(SCpnt);
 		ccb[mbo].op = 2;	/* SCSI Initiator Command  w/scatter-gather */
-		SCpnt->host_scribble = kmalloc(512, GFP_KERNEL | GFP_DMA);
+		SCpnt->host_scribble = kmalloc(sizeof(*cptr)*sg_count,
+		                                         GFP_KERNEL | GFP_DMA);
 		cptr = (struct chain *) SCpnt->host_scribble;
 		if (cptr == NULL) {
 			/* free the claimed mailbox slot */
 			HOSTDATA(SCpnt->device->host)->SCint[mbo] = NULL;
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
-		scsi_for_each_sg(SCpnt, sg, SCpnt->use_sg, i) {
-			if (sg->length == 0 || SCpnt->use_sg > 16 ||
-			    (((int) sg->offset) & 1) || (sg->length & 1)) {
-				unsigned char *ptr;
-				printk(KERN_CRIT "Bad segment list supplied to aha1542.c (%d, %d)\n", SCpnt->use_sg, i);
-				scsi_for_each_sg(SCpnt, sg, SCpnt->use_sg, i) {
-					printk(KERN_CRIT "%d: %p %d\n", i,
-					       (page_address(sg->page) +
-						sg->offset), sg->length);
-				};
-				printk(KERN_CRIT "cptr %x: ", (unsigned int) cptr);
-				ptr = (unsigned char *) &cptr[i];
-				for (i = 0; i < 18; i++)
-					printk("%02x ", ptr[i]);
-				panic("Foooooooood fight!");
-			};
+		scsi_for_each_sg(SCpnt, sg, sg_count, i) {
 			any2scsi(cptr[i].dataptr, SCSI_SG_PA(sg));
 			if (SCSI_SG_PA(sg) + sg->length - 1 > ISA_DMA_THRESHOLD)
-				BAD_SG_DMA(SCpnt, sg, SCpnt->use_sg, i);
+				BAD_SG_DMA(SCpnt, scsi_sglist(SCpnt), sg_count, i);
 			any2scsi(cptr[i].datalen, sg->length);
 		};
-		any2scsi(ccb[mbo].datalen, SCpnt->use_sg * sizeof(struct chain));
+		any2scsi(ccb[mbo].datalen, sg_count * sizeof(struct chain));
 		any2scsi(ccb[mbo].dataptr, SCSI_BUF_PA(cptr));
 #ifdef DEBUG
 		printk("cptr %x: ", cptr);
@@ -737,10 +713,8 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	} else {
 		ccb[mbo].op = 0;	/* SCSI Initiator Command */
 		SCpnt->host_scribble = NULL;
-		any2scsi(ccb[mbo].datalen, bufflen);
-		if (buff && SCSI_BUF_PA(buff + bufflen - 1) > ISA_DMA_THRESHOLD)
-			BAD_DMA(buff, bufflen);
-		any2scsi(ccb[mbo].dataptr, SCSI_BUF_PA(buff));
+		any2scsi(ccb[mbo].datalen, 0);
+		any2scsi(ccb[mbo].dataptr, 0);
 	};
 	ccb[mbo].idlun = (target & 7) << 5 | direction | (lun & 7);	/*SCSI Target Id */
 	ccb[mbo].rsalen = 16;
-- 
1.5.3.1


