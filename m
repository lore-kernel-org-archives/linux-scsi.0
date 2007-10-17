From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 29/32] scsi_data_buffer - sd.c and sr.c
Date: Wed, 17 Oct 2007 20:25:12 +0200
Message-ID: <47165388.6010205@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:15017 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756162AbXJQS1d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 14:27:33 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


  - sd and sr would adjust IO size to align on device's block
    size so code needs to change once we move to scsi_data_buff
    implementation.
  - Convert code to use scsi_for_each_sg
  - Use data accessors where appropriate.
  - Remove dead code (req_data_dir() != READ && != WRITE)

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/sd.c |    7 ++-----
 drivers/scsi/sr.c |   28 +++++++++++++---------------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 69f542c..c241f7e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -448,9 +448,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	} else {
-		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
-		goto out;
 	}
 
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
@@ -510,7 +507,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[4] = (unsigned char) this_count;
 		SCpnt->cmnd[5] = 0;
 	}
-	SCpnt->request_bufflen = this_count * sdp->sector_size;
+	SCpnt->sdb.length = this_count * sdp->sector_size;
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
@@ -904,7 +901,7 @@ static struct block_device_operations sd_fops = {
 static int sd_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
- 	unsigned int xfer_size = SCpnt->request_bufflen;
+	unsigned int xfer_size = scsi_bufflen(SCpnt);
  	unsigned int good_bytes = result ? 0 : xfer_size;
  	u64 start_lba = SCpnt->request->sector;
  	u64 bad_lba;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index c619990..0375ad2 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -218,7 +218,7 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 static int sr_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
-	int this_count = SCpnt->request_bufflen;
+	int this_count = scsi_bufflen(SCpnt);
 	int good_bytes = (result == 0 ? this_count : 0);
 	int block_sectors = 0;
 	long error_sector;
@@ -360,23 +360,21 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_10;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	} else {
-		blk_dump_rq_flags(rq, "Unknown sr command");
-		goto out;
 	}
 
 	{
-		struct scatterlist *sg = SCpnt->request_buffer;
-		int i, size = 0;
-		for (i = 0; i < SCpnt->use_sg; i++)
-			size += sg[i].length;
+		struct scatterlist *sg;
+		int i, size = 0, sg_count = scsi_sg_count(SCpnt);
+
+		scsi_for_each_sg (SCpnt, sg, sg_count, i)
+			size += sg->length;
 
-		if (size != SCpnt->request_bufflen && SCpnt->use_sg) {
+		if (size != scsi_bufflen(SCpnt)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				"mismatch count %d, bytes %d\n",
-				size, SCpnt->request_bufflen);
-			if (SCpnt->request_bufflen > size)
-				SCpnt->request_bufflen = size;
+				size, scsi_bufflen(SCpnt));
+			if (scsi_bufflen(SCpnt) > size)
+				SCpnt->sdb.length = size;
 		}
 	}
 
@@ -384,12 +382,12 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	 * request doesn't start on hw block boundary, add scatter pads
 	 */
 	if (((unsigned int)rq->sector % (s_size >> 9)) ||
-	    (SCpnt->request_bufflen % s_size)) {
+	    (scsi_bufflen(SCpnt) % s_size)) {
 		scmd_printk(KERN_NOTICE, SCpnt, "unaligned transfer\n");
 		goto out;
 	}
 
-	this_count = (SCpnt->request_bufflen >> 9) / (s_size >> 9);
+	this_count = (scsi_bufflen(SCpnt) >> 9) / (s_size >> 9);
 
 
 	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n",
@@ -403,7 +401,7 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 
 	if (this_count > 0xffff) {
 		this_count = 0xffff;
-		SCpnt->request_bufflen = this_count * s_size;
+		SCpnt->sdb.length = this_count * s_size;
 	}
 
 	SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
-- 
1.5.3.1


