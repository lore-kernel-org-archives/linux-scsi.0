From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] SG_IO ioctl in block layer against lk 2.5.55
Date: Fri, 10 Jan 2003 22:37:49 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E1EB08D.5060105@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070405040703090908060002"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@suse.de

This is a multi-part message in MIME format.
--------------070405040703090908060002
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The attachment modifies the SG_IO ioctl that is in
the block layer to:
   - convey the SCSI status value back via the sg_io_hdr
     structure
   - in the event of CHECK CONDITION, convey the sense
     buffer back via the sg_io_hdr structure
   - set "output" fields in sg_io_hdr structure to sane
     values
   - modify the errno behaviour to be more like the
     SCSI generic driver's SG_IO ioctl

This patch was presented around lk 2.5.51 but fell between
the cracks. The only modification is to take account of
the changes to scsi/scsi_lib.c since then.

Doug Gilbert

--------------070405040703090908060002
Content-Type: text/plain;
 name="blk_sgio_2555.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="blk_sgio_2555.diff"

--- linux/drivers/block/scsi_ioctl.c	2002-11-29 09:27:35.000000000 +1100
+++ linux/drivers/block/scsi_ioctl.c2551sgio2	2002-12-14 23:18:46.000000000 +1100
@@ -40,6 +40,11 @@
 
 #define BLK_DEFAULT_TIMEOUT	(60 * HZ)
 
+/* defined in ../scsi/scsi.h  ... should it be included? */
+#ifndef SCSI_SENSE_BUFFERSIZE
+#define SCSI_SENSE_BUFFERSIZE 64
+#endif
+
 int blk_do_rq(request_queue_t *q, struct block_device *bdev, struct request *rq)
 {
 	DECLARE_COMPLETION(wait);
@@ -126,11 +131,11 @@
 		 struct sg_io_hdr *uptr)
 {
 	unsigned long uaddr, start_time;
-	int err, reading, writing, nr_sectors;
+	int reading, writing, nr_sectors;
 	struct sg_io_hdr hdr;
 	struct request *rq;
 	struct bio *bio;
-	char sense[24];
+	char sense[SCSI_SENSE_BUFFERSIZE];
 	void *buffer;
 
 	if (!access_ok(VERIFY_WRITE, uptr, sizeof(*uptr)))
@@ -265,26 +270,36 @@
 
 	start_time = jiffies;
 
-	/*
-	 * return -EIO if we didn't transfer all data, caller can look at
-	 * residual count to find out how much did succeed
+	/* ignore return value. All information is passed back to caller
+	 * (if he doesn't check that is his problem).
+	 * N.B. a non-zero SCSI status is _not_ necessarily an error.
 	 */
-	err = blk_do_rq(q, bdev, rq);
-	if (rq->data_len > 0)
-		err = -EIO;
+	blk_do_rq(q, bdev, rq);
 	
 	if (bio) {
 		bio_unmap_user(bio, reading);
 		bio_put(bio);
 	}
 
-	hdr.status = rq->errors;
+	/* write to all output members */
+	hdr.status = rq->errors;	
+	hdr.masked_status = (hdr.status >> 1) & 0x1f;
+	hdr.msg_status = 0;
+	hdr.host_status = 0;
+	hdr.driver_status = 0;
+	hdr.info = 0;
+	if (hdr.masked_status || hdr.host_status || hdr.driver_status)
+		hdr.info |= SG_INFO_CHECK;
 	hdr.resid = rq->data_len;
 	hdr.duration = (jiffies - start_time) * (1000 / HZ);
+	hdr.sb_len_wr = 0;
 
 	if (rq->sense_len && hdr.sbp) {
-		if (!copy_to_user(hdr.sbp,rq->sense, rq->sense_len))
-			hdr.sb_len_wr = rq->sense_len;
+		int len = (hdr.mx_sb_len < rq->sense_len) ? 
+				hdr.mx_sb_len : rq->sense_len;
+
+		if (!copy_to_user(hdr.sbp, rq->sense, len))
+			hdr.sb_len_wr = len;
 	}
 
 	blk_put_request(rq);
@@ -297,8 +312,9 @@
 
 		kfree(buffer);
 	}
-
-	return err;
+	/* may not have succeeded, but output values written to control
+	 * structure (struct sg_io_hdr).  */
+	return 0;
 }
 
 #define FORMAT_UNIT_TIMEOUT		(2 * 60 * 60 * HZ)
--- linux/drivers/scsi/scsi_lib.c	2002-12-10 17:38:29.000000000 +1100
+++ linux/drivers/scsi/scsi_lib.c2551sgio	2002-12-14 23:08:25.000000000 +1100
@@ -495,6 +495,7 @@
 	int this_count = SCpnt->bufflen >> 9;
 	request_queue_t *q = SCpnt->device->request_queue;
 	struct request *req = SCpnt->request;
+	int clear_errors = 1;
 
 	/*
 	 * We must do one of several things here:
@@ -528,10 +529,22 @@
 		kfree(SCpnt->buffer);
 	}
 
-	if (blk_pc_request(req)) {
-		req->errors = result & 0xff;
-		if (!result)
+	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
+		req->errors = (driver_byte(result) & DRIVER_SENSE) ?
+			      (CHECK_CONDITION << 1) : (result & 0xff);
+		if (!result) 
 			req->data_len -= SCpnt->bufflen;
+		else {
+			clear_errors = 0;
+			if (SCpnt->sense_buffer[0] & 0x70) {
+				int len = 8 + SCpnt->sense_buffer[7];
+
+				if (len > SCSI_SENSE_BUFFERSIZE)
+					len = SCSI_SENSE_BUFFERSIZE;
+				memcpy(req->sense, SCpnt->sense_buffer,  len);
+				req->sense_len = len;
+			}
+		}
 	}
 
 	/*
@@ -552,7 +565,8 @@
 					      req->nr_sectors, good_sectors));
 		SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n ", SCpnt->use_sg));
 
-		req->errors = 0;
+		if (clear_errors)
+			req->errors = 0;
 		/*
 		 * If multiple sectors are requested in one buffer, then
 		 * they will have been finished off by the first command.

--------------070405040703090908060002--

