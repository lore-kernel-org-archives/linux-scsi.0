From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] blk SCSI_IOCTL_SEND_COMMAND
Date: Tue, 29 Apr 2003 22:01:22 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EAE6992.9090605@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070608010005010002030708"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:60421 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261710AbTD2Lqy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2003 07:46:54 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, axboe@suse.de

This is a multi-part message in MIME format.
--------------070608010005010002030708
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

While playing with RH9.0 and 2.5.68 I found that
scsi_unique_id (called from devlabel) oopsed on
a regular basis during bootup.

This patch addresses flakiness in sense buffer
handling (in the failure case a disk didn't support
VPD page 0x83).

Note that this patch modifies drivers/block/scsi_ioctl.c

Doug Gilbert

--------------070608010005010002030708
Content-Type: text/plain;
 name="scsi_ioctl_blk2568.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_ioctl_blk2568.diff"

--- linux/drivers/block/scsi_ioctl.c	2003-04-08 10:50:03.000000000 +1000
+++ linux/drivers/block/scsi_ioctl.c2568dpg	2003-04-29 21:41:31.082437736 +1000
@@ -324,13 +324,14 @@
 #define MOVE_MEDIUM_TIMEOUT		(5 * 60 * HZ)
 #define READ_ELEMENT_STATUS_TIMEOUT	(5 * 60 * HZ)
 #define READ_DEFECT_DATA_TIMEOUT	(60 * HZ )
+#define OMAX_SB_LEN 16          /* For backward compatibility */
 
 static int sg_scsi_ioctl(request_queue_t *q, struct block_device *bdev,
 			 Scsi_Ioctl_Command *sic)
 {
 	struct request *rq;
 	int err, in_len, out_len, bytes, opcode, cmdlen;
-	char *buffer = NULL, sense[24];
+	char *buffer = NULL, sense[SCSI_SENSE_BUFFERSIZE];
 
 	/*
 	 * get in an out lengths, verify they don't exceed a page worth of data
@@ -403,9 +404,12 @@
 	blk_do_rq(q, bdev, rq);
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
-		if (rq->sense_len)
-			if (copy_to_user(sic->data, rq->sense, rq->sense_len))
+		if (rq->sense_len && rq->sense) {
+			bytes = (OMAX_SB_LEN > rq->sense_len) ?
+				rq->sense_len : OMAX_SB_LEN;
+			if (copy_to_user(sic->data, rq->sense, bytes))
 				err = -EFAULT;
+		}
 	} else {
 		if (copy_to_user(sic->data, buffer, out_len))
 			err = -EFAULT;

--------------070608010005010002030708--

