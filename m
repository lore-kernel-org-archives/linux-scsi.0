From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] SG_IO ioctl for block devices
Date: Wed, 04 Dec 2002 23:22:46 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DEDF396.1040600@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090700080301060808080303"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-89.triode.net.au [202.147.125.89])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gB4CL9U02428
	for <linux-scsi@vger.kernel.org>; Wed, 4 Dec 2002 23:21:10 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090700080301060808080303
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I have been playing around with the SG_IO ioctl() that
recently appeared in drivers/block/scsi_ioctl.c .

First a warning: using sg's write()/read() interface is
a dangerous thing to do to anything other than an sg device
(especially a disk). The utilities in sg3_utils (and sg_utils)
took the precaution of sending a "sg" ioctl and assumed if
it worked then the file descriptor referred to a sg device.
Now _all_ block devices respond to the ioctl()s I chose :-(

IMO sg's write()/read() interface is still useful for
queuing and high speed applications. However for the
great majority of cases the SG_IO ioctl is sufficient.
It turns out that sg3_utils version 1.01 doesn't scribble
on disks (as outlined above), more by luck than good
management. Several things fail (e.g. sg_logs) that can
easily be fixed while sg_inq and sg_dd work. [sg_dd
works because it treats /dev/sda as a normal file
rather than a sg device.] I will release sg3_utils
version 1.02 shortly.

The error processing of the SG_IO ioctl() is broken as
far as I can determine. My attached patch drives output
values to 0 (their inert values) and rescues the scsi
status value from the scsi_request structure. Notice
the hack in drivers/scsi/scsi_lib.c to stop the
gratuitous clearing of req->errors. The sense buffer
is not conveyed into struct request and there seems to
be no code in scsi_lib.c to do that.

To keep the block SG_IO consistent with sg's version,
I removed the EIO errno conditions. CHECK CONDITION
does not (necessarily) indicate an error. Witness the
code fix around lk 2.4.18 to correctly handle
RECOVERED_ERROR. So a return value of zero implies
that a consistent set of values has been written
back into the sg_io_hdr instance (and the application
best check them).

The patch is against lk 2.5.50bk3

Doug Gilbert

--------------090700080301060808080303
Content-Type: text/plain;
 name="2550bk3_blk_sgio.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2550bk3_blk_sgio.diff"

--- linux/drivers/block/scsi_ioctl.c	2002-11-29 09:27:35.000000000 +1100
+++ linux/drivers/block/scsi_ioctl.c2550sgio1	2002-12-04 21:14:53.000000000 +1100
@@ -126,7 +126,7 @@
 		 struct sg_io_hdr *uptr)
 {
 	unsigned long uaddr, start_time;
-	int err, reading, writing, nr_sectors;
+	int reading, writing, nr_sectors;
 	struct sg_io_hdr hdr;
 	struct request *rq;
 	struct bio *bio;
@@ -265,26 +265,36 @@
 
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
@@ -297,8 +307,9 @@
 
 		kfree(buffer);
 	}
-
-	return err;
+	/* may not have succeeded, but output values written to control
+	 * structure (struct sg_io_hdr).  */
+	return 0;
 }
 
 #define FORMAT_UNIT_TIMEOUT		(2 * 60 * 60 * HZ)
--- linux/drivers/scsi/scsi_lib.c	2002-12-04 10:21:16.000000000 +1100
+++ linux/drivers/scsi/scsi_lib.c2550bk3sgio1	2002-12-04 21:14:20.000000000 +1100
@@ -441,6 +441,7 @@
 	int this_count = SCpnt->bufflen >> 9;
 	request_queue_t *q = &SCpnt->device->request_queue;
 	struct request *req = SCpnt->request;
+	int clear_errors = 1;
 
 	/*
 	 * We must do one of several things here:
@@ -481,9 +482,12 @@
 	}
 
 	if (blk_pc_request(req)) {
-		req->errors = result & 0xff;
+		req->errors = (driver_byte(result) & DRIVER_SENSE) ?
+				(CHECK_CONDITION << 1) : (result & 0xff);
 		if (!result)
 			req->data_len -= SCpnt->bufflen;
+		else
+			clear_errors = 0;  
 	}
 
 	/*
@@ -504,7 +508,8 @@
 					      req->nr_sectors, good_sectors));
 		SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n ", SCpnt->use_sg));
 
-		req->errors = 0;
+		if (clear_errors)
+			req->errors = 0;
 		/*
 		 * If multiple sectors are requested in one buffer, then
 		 * they will have been finished off by the first command.

--------------090700080301060808080303--

