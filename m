From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 2/9] convert sd and sr to use scsi_data_buffer
Date: Fri, 7 Sep 2007 06:50:17 +0900
Message-ID: <20070906183453L.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43066 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbXIFVww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 17:52:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp

From: Boaz Harrosh <bharrosh@panasas.com>

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/sd.c |    6 +++---
 drivers/scsi/sr.c |   25 +++++++++++++------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c6116f..aba9e34 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -337,7 +337,7 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
 	struct request *rq = SCpnt->request;
 	struct gendisk *disk = rq->rq_disk;
 	sector_t block = rq->sector;
-	unsigned int this_count = SCpnt->request_bufflen >> 9;
+	unsigned int this_count = scsi_bufflen(SCpnt) >> 9;
 	unsigned int timeout = sdp->timeout;
 
 	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
@@ -479,7 +479,7 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
 		SCpnt->cmnd[4] = (unsigned char) this_count;
 		SCpnt->cmnd[5] = 0;
 	}
-	SCpnt->request_bufflen = this_count * sdp->sector_size;
+	SCpnt->sdb.length = this_count * sdp->sector_size;
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
@@ -898,7 +898,7 @@ static struct block_device_operations sd_fops = {
 static void sd_rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
- 	unsigned int xfer_size = SCpnt->request_bufflen;
+	unsigned int xfer_size = scsi_bufflen(SCpnt);
  	unsigned int good_bytes = result ? 0 : xfer_size;
  	u64 start_lba = SCpnt->request->sector;
  	u64 bad_lba;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 902eb11..67bb542 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -218,7 +218,7 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 static void rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
-	int this_count = SCpnt->request_bufflen;
+	int this_count = scsi_bufflen(SCpnt);
 	int good_bytes = (result == 0 ? this_count : 0);
 	int block_sectors = 0;
 	long error_sector;
@@ -351,17 +351,18 @@ static int sr_init_command(struct scsi_cmnd * SCpnt)
 	}
 
 	{
-		struct scatterlist *sg = SCpnt->request_buffer;
+		struct scatterlist *sg;
 		int i, size = 0;
-		for (i = 0; i < SCpnt->use_sg; i++)
-			size += sg[i].length;
 
-		if (size != SCpnt->request_bufflen && SCpnt->use_sg) {
+		scsi_for_each_sg(SCpnt, sg, scsi_sg_count(SCpnt), i)
+			size += sg->length;
+
+		if (size != scsi_bufflen(SCpnt)) {
 			scmd_printk(KERN_ERR, SCpnt,
-				"mismatch count %d, bytes %d\n",
-				size, SCpnt->request_bufflen);
-			if (SCpnt->request_bufflen > size)
-				SCpnt->request_bufflen = size;
+				    "mismatch count %d, bytes %d\n",
+				    size, scsi_bufflen(SCpnt));
+			if (scsi_bufflen(SCpnt) > size)
+				SCpnt->sdb.length = size;
 		}
 	}
 
@@ -369,12 +370,12 @@ static int sr_init_command(struct scsi_cmnd * SCpnt)
 	 * request doesn't start on hw block boundary, add scatter pads
 	 */
 	if (((unsigned int)SCpnt->request->sector % (s_size >> 9)) ||
-	    (SCpnt->request_bufflen % s_size)) {
+	    (scsi_bufflen(SCpnt) % s_size)) {
 		scmd_printk(KERN_NOTICE, SCpnt, "unaligned transfer\n");
 		return 0;
 	}
 
-	this_count = (SCpnt->request_bufflen >> 9) / (s_size >> 9);
+	this_count = (scsi_bufflen(SCpnt) >> 9) / (s_size >> 9);
 
 
 	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n",
@@ -388,7 +389,7 @@ static int sr_init_command(struct scsi_cmnd * SCpnt)
 
 	if (this_count > 0xffff) {
 		this_count = 0xffff;
-		SCpnt->request_bufflen = this_count * s_size;
+		SCpnt->sdb.length = this_count * s_size;
 	}
 
 	SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
-- 
1.5.2.4

