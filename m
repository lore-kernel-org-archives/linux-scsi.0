From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] REQ_BLOCK_PC only returns SCSI status byte
Date: Thu, 25 Sep 2003 11:18:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030925111848.A26884@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:43240 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261709AbTIYSTP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2003 14:19:15 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Jens/James -

Can you please apply or comment?

Only the low byte of the linux scsi result is being returned for
REQ_BLOCK_PC usage. This means driver errors such as DID_ERROR are not
returned to user space.

The ide-cd.c code looks like it should be OK with this patch, but I did
not test it. I tested using SG_IO to an sd, for the case of DID_ERROR
coming back from the qlogic adapter (with underflow set, it was returning
DID_ERROR).

diff -uprN -X /home/patman/dontdiff bl-25/drivers/block/scsi_ioctl.c bl-25-sg_io/drivers/block/scsi_ioctl.c
--- bl-25/drivers/block/scsi_ioctl.c	Mon Sep 22 13:08:35 2003
+++ bl-25-sg_io/drivers/block/scsi_ioctl.c	Wed Sep 24 16:50:07 2003
@@ -256,9 +256,9 @@ static int sg_io(request_queue_t *q, str
 	/* write to all output members */
 	hdr.status = rq->errors;	
 	hdr.masked_status = (hdr.status >> 1) & 0x1f;
-	hdr.msg_status = 0;
-	hdr.host_status = 0;
-	hdr.driver_status = 0;
+	hdr.msg_status = (rq->errors >> 8) & 0xff;
+	hdr.host_status = (rq->errors >> 16) & 0xff;
+	hdr.driver_status = (rq->errors >> 24) & 0xff;
 	hdr.info = 0;
 	if (hdr.masked_status || hdr.host_status || hdr.driver_status)
 		hdr.info |= SG_INFO_CHECK;
@@ -377,7 +377,7 @@ static int sg_scsi_ioctl(request_queue_t
 	rq->flags |= REQ_BLOCK_PC;
 
 	blk_do_rq(q, bdev, rq);
-	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
+	err = rq->errors;
 	if (err) {
 		if (rq->sense_len && rq->sense) {
 			bytes = (OMAX_SB_LEN > rq->sense_len) ?
diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_lib.c bl-25-sg_io/drivers/scsi/scsi_lib.c
--- bl-25/drivers/scsi/scsi_lib.c	Mon Sep 22 13:08:53 2003
+++ bl-25-sg_io/drivers/scsi/scsi_lib.c	Wed Sep 24 16:52:48 2003
@@ -675,7 +675,7 @@ void scsi_io_completion(struct scsi_cmnd
 
 	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
 		req->errors = (driver_byte(result) & DRIVER_SENSE) ?
-			      (CHECK_CONDITION << 1) : (result & 0xff);
+			      (CHECK_CONDITION << 1) : result;
 		if (result) {
 			clear_errors = 0;
 			if (cmd->sense_buffer[0] & 0x70) {

-- Patrick Mansfield
