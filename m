From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH 2/2] streamline block SG_IO error processing
Date: Sat, 15 Jan 2005 13:36:21 +1000
Message-ID: <41E88FB5.7070001@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030400040702030705040101"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:26309 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262206AbVAODgP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2005 22:36:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------030400040702030705040101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Changelog:
   - sd_init_command(): use retry count of 1 for block
     SG_IO; minor cleanup
   - sd_rw_init(): bypass sd level error processing for
     block SG_IO

Signed-off-by: Douglas Gilbert <dougg@torque.net>

--------------030400040702030705040101
Content-Type: text/x-patch;
 name="sd2611rc1bk1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd2611rc1bk1.diff"

--- linux/drivers/scsi/sd.c	2005-01-14 12:08:37.000000000 +1000
+++ linux/drivers/scsi/sd.c2611rc1bk1med	2005-01-14 19:50:15.000000000 +1000
@@ -87,6 +87,7 @@
  * Number of allowed retries
  */
 #define SD_MAX_RETRIES		5
+#define SD_PASSTHROUGH_RETRIES	1
 
 static void scsi_disk_release(struct kref *kref);
 
@@ -217,15 +218,14 @@
 	struct gendisk *disk;
 	sector_t block;
 	struct scsi_device *sdp = SCpnt->device;
+	struct request *rq = SCpnt->request;
 
 	timeout = sdp->timeout;
 
 	/*
-	 * these are already setup, just copy cdb basically
+	 * SG_IO from block layer already setup, just copy cdb basically
 	 */
-	if (SCpnt->request->flags & REQ_BLOCK_PC) {
-		struct request *rq = SCpnt->request;
-
+	if (blk_pc_request(rq)) {
 		if (sizeof(rq->cmd) > sizeof(SCpnt->cmnd))
 			return 0;
 
@@ -242,26 +242,28 @@
 			timeout = rq->timeout;
 
 		SCpnt->transfersize = rq->data_len;
+		SCpnt->allowed = SD_PASSTHROUGH_RETRIES;
 		goto queue;
 	}
 
 	/*
 	 * we only do REQ_CMD and REQ_BLOCK_PC
 	 */
-	if (!(SCpnt->request->flags & REQ_CMD))
+	if (! blk_fs_request(rq))
 		return 0;
 
-	disk = SCpnt->request->rq_disk;
-	block = SCpnt->request->sector;
+	disk = rq->rq_disk;
+	block = rq->sector;
 	this_count = SCpnt->request_bufflen >> 9;
 
 	SCSI_LOG_HLQUEUE(1, printk("sd_init_command: disk=%s, block=%llu, "
-			    "count=%d\n", disk->disk_name, (unsigned long long)block, this_count));
+			    "count=%d\n", disk->disk_name,
+			 (unsigned long long)block, this_count));
 
 	if (!sdp || !scsi_device_online(sdp) ||
- 	    block + SCpnt->request->nr_sectors > get_capacity(disk)) {
+ 	    block + rq->nr_sectors > get_capacity(disk)) {
 		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n", 
-				 SCpnt->request->nr_sectors));
+				 rq->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
 		return 0;
 	}
@@ -289,7 +291,7 @@
 	 * for this.
 	 */
 	if (sdp->sector_size == 1024) {
-		if ((block & 1) || (SCpnt->request->nr_sectors & 1)) {
+		if ((block & 1) || (rq->nr_sectors & 1)) {
 			printk(KERN_ERR "sd: Bad block number requested");
 			return 0;
 		} else {
@@ -298,7 +300,7 @@
 		}
 	}
 	if (sdp->sector_size == 2048) {
-		if ((block & 3) || (SCpnt->request->nr_sectors & 3)) {
+		if ((block & 3) || (rq->nr_sectors & 3)) {
 			printk(KERN_ERR "sd: Bad block number requested");
 			return 0;
 		} else {
@@ -307,7 +309,7 @@
 		}
 	}
 	if (sdp->sector_size == 4096) {
-		if ((block & 7) || (SCpnt->request->nr_sectors & 7)) {
+		if ((block & 7) || (rq->nr_sectors & 7)) {
 			printk(KERN_ERR "sd: Bad block number requested");
 			return 0;
 		} else {
@@ -315,25 +317,24 @@
 			this_count = this_count >> 3;
 		}
 	}
-	if (rq_data_dir(SCpnt->request) == WRITE) {
+	if (rq_data_dir(rq) == WRITE) {
 		if (!sdp->writeable) {
 			return 0;
 		}
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
-	} else if (rq_data_dir(SCpnt->request) == READ) {
+	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
-		printk(KERN_ERR "sd: Unknown command %lx\n", 
-		       SCpnt->request->flags);
-/* overkill 	panic("Unknown sd command %lx\n", SCpnt->request->flags); */
+		printk(KERN_ERR "sd: Unknown command %lx\n", rq->flags);
+/* overkill 	panic("Unknown sd command %lx\n", rq->flags); */
 		return 0;
 	}
 
 	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n", 
-		disk->disk_name, (rq_data_dir(SCpnt->request) == WRITE) ? 
-		"writing" : "reading", this_count, SCpnt->request->nr_sectors));
+		disk->disk_name, (rq_data_dir(rq) == WRITE) ? 
+		"writing" : "reading", this_count, rq->nr_sectors));
 
 	SCpnt->cmnd[1] = 0;
 	
@@ -385,9 +386,9 @@
 	 */
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
+	SCpnt->allowed = SD_MAX_RETRIES;
 
 queue:
-	SCpnt->allowed = SD_MAX_RETRIES;
 	SCpnt->timeout_per_command = timeout;
 
 	/*
@@ -777,9 +778,15 @@
 	   unnecessary additional work such as memcpy's that could be avoided.
 	 */
 
-	/* An error occurred */
-	if (driver_byte(result) != 0 && 	/* An error occurred */
-	    (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */
+	/* 
+	 * If SG_IO from block layer then set good_bytes to stop retries;
+	 * else if errors, check them, and if necessary prepare for
+	 * (partial) retries.
+	 */
+	if (blk_pc_request(SCpnt->request))
+		good_bytes = this_count;
+	else if (driver_byte(result) != 0 &&
+	    (SCpnt->sense_buffer[0] & 0x7f) == 0x70) {
 		switch (SCpnt->sense_buffer[2]) {
 		case MEDIUM_ERROR:
 			if (!(SCpnt->sense_buffer[0] & 0x80))

--------------030400040702030705040101--
