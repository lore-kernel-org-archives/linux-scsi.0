From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] block scsi_ioctl.c lk 2.5.66
Date: Wed, 26 Mar 2003 20:02:12 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E817AA4.6020402@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070102030407080509020501"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (d-241-56.stlucia.uq.net.au [203.101.241.56])
	by bunyip.cc.uq.edu.au (8.12.8/8.12.8) with ESMTP id h2QA3X54001742
	for <linux-scsi@vger.kernel.org>; Wed, 26 Mar 2003 20:03:34 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070102030407080509020501
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Changelog:
   - extends block SCSI_IOCTL_SEND_COMMAND timeout on
     SEND DIAGNOSTIC to the same as FORMAT (i.e. 2 hours)
   - makes SCSI_IOCTL_SEND_COMMAND return SCSI status
     (rather than EIO) for compatibility
   - make do_blk_rq() a static function

Doug Gilbert

--------------070102030407080509020501
Content-Type: text/plain;
 name="blk_scsi_ioctl_2566.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="blk_scsi_ioctl_2566.diff"

--- linux/drivers/block/scsi_ioctl.c	2003-03-05 21:01:14.000000000 +1000
+++ linux/drivers/block/scsi_ioctl.c2566dpg	2003-03-26 19:44:50.000000000 +1000
@@ -45,7 +45,8 @@
 #define SCSI_SENSE_BUFFERSIZE 64
 #endif
 
-int blk_do_rq(request_queue_t *q, struct block_device *bdev, struct request *rq)
+static int blk_do_rq(request_queue_t *q, struct block_device *bdev, 
+		     struct request *rq)
 {
 	DECLARE_COMPLETION(wait);
 	int err = 0;
@@ -368,6 +369,7 @@
 		goto error;
 
 	switch (opcode) {
+		case SEND_DIAGNOSTIC:
 		case FORMAT_UNIT:
 			rq->timeout = FORMAT_UNIT_TIMEOUT;
 			break;
@@ -398,7 +400,8 @@
 	if (in_len)
 		rq->flags |= REQ_RW;
 
-	err = blk_do_rq(q, bdev, rq);
+	blk_do_rq(q, bdev, rq);
+	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len)
 			if (copy_to_user(sic->data, rq->sense, rq->sense_len))

--------------070102030407080509020501--


