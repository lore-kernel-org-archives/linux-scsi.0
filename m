From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] return all status bytes for sg io.
Date: Wed, 02 Jun 2004 05:25:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40BDC726.7070004@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030606040002070601040907"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:65291 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262065AbUFBMZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2004 08:25:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

This is a multi-part message in MIME format.
--------------030606040002070601040907
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jens,

For block/scsi_ioctl.c only the status_byte is returned. However, when sg io is 
performed through a sg device the host, msg and driver bytes are passed back. I 
was not sure if this is a bug on the block layers part (becuase as you see in 
the patch, after the msg, host and driver bytes are zerod out they are tested), 
or is the bug in the app and it should be modifed to access sg devices instead 
of block devs. The attached patch was built against 2.6.7-rc2.

Thanks,

Mike

--------------030606040002070601040907
Content-Type: text/plain;
 name="blk_sg_io_err.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="blk_sg_io_err.patch"

diff -arup linux-2.6.7-rc2/drivers/block/scsi_ioctl.c linux-2.6.7-rc2-work/drivers/block/scsi_ioctl.c
--- linux-2.6.7-rc2/drivers/block/scsi_ioctl.c	2004-05-29 23:26:48.000000000 -0700
+++ linux-2.6.7-rc2-work/drivers/block/scsi_ioctl.c	2004-06-02 04:32:27.000000000 -0700
@@ -185,11 +185,11 @@ static int sg_io(request_queue_t *q, str
 	blk_execute_rq(q, bd_disk, rq);
 
 	/* write to all output members */
-	hdr->status = rq->errors;	
-	hdr->masked_status = (hdr->status >> 1) & 0x1f;
-	hdr->msg_status = 0;
-	hdr->host_status = 0;
-	hdr->driver_status = 0;
+	hdr->status = 0xff & rq->errors;
+	hdr->masked_status = status_byte(rq->errors);
+	hdr->msg_status = msg_byte(rq->errors);
+	hdr->host_status = host_byte(rq->errors);
+	hdr->driver_status = driver_byte(rq->errors);
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
diff -arup linux-2.6.7-rc2/drivers/scsi/scsi_lib.c linux-2.6.7-rc2-work/drivers/scsi/scsi_lib.c
--- linux-2.6.7-rc2/drivers/scsi/scsi_lib.c	2004-05-29 23:26:10.000000000 -0700
+++ linux-2.6.7-rc2-work/drivers/scsi/scsi_lib.c	2004-06-02 02:51:16.000000000 -0700
@@ -708,8 +708,7 @@ void scsi_io_completion(struct scsi_cmnd
 	}
 
 	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
-		req->errors = (driver_byte(result) & DRIVER_SENSE) ?
-			      (CHECK_CONDITION << 1) : (result & 0xff);
+		req->errors = result; 
 		if (result) {
 			clear_errors = 0;
 			if (cmd->sense_buffer[0] & 0x70) {

--------------030606040002070601040907--

