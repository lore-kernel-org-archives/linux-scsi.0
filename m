From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] set error value when failing block pc commands
Date: Fri, 09 Sep 2005 14:27:50 -0500
Message-ID: <1126294070.2647.2.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:3759 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030305AbVIIT1x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 15:27:53 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j89JRq8Y010985
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 9 Sep 2005 14:27:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

If a block pc request is failed in the request_fn or prep_fn we are not
setting a error value. This is a problem for dm-multipath's path
testers and hw_handlers and everyone doing SG_IO since they
see the command as completing successfully.

Patch was made against scsi-misc.

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1047,6 +1047,10 @@ static int scsi_init_io(struct scsi_cmnd
 	/* release the command and kill it */
 	scsi_release_buffers(cmd);
 	scsi_put_command(cmd);
+
+	if (blk_pc_request(req))
+		req->errors = DID_NO_CONNECT << 16;
+	
 	return BLKPREP_KILL;
 }
 
@@ -1118,6 +1122,8 @@ static int scsi_prep_fn(struct request_q
 	if (unlikely(!scsi_device_online(sdev))) {
 		printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
 		       sdev->host->host_no, sdev->id, sdev->lun);
+		if (blk_pc_request(req))
+			req->errors = DID_NO_CONNECT << 16;
 		return BLKPREP_KILL;
 	}
 	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
@@ -1128,6 +1134,8 @@ static int scsi_prep_fn(struct request_q
 			 * at all allowed down */
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to dead device\n",
 			       sdev->host->host_no, sdev->id, sdev->lun);
+			if (blk_pc_request(req))
+				req->errors = DID_NO_CONNECT << 16;
 			return BLKPREP_KILL;
 		}
 		/* OK, we only allow special commands (i.e. not
@@ -1164,6 +1172,10 @@ static int scsi_prep_fn(struct request_q
 			
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to device being removed\n",
 			       sdev->host->host_no, sdev->id, sdev->lun);
+
+			if (blk_pc_request(req))
+				req->errors = DID_NO_CONNECT << 16;
+
 			return BLKPREP_KILL;
 		}
 			
@@ -1231,6 +1243,10 @@ static int scsi_prep_fn(struct request_q
 			if (unlikely(!drv->init_command(cmd))) {
 				scsi_release_buffers(cmd);
 				scsi_put_command(cmd);
+
+				if (blk_pc_request(req))
+					req->errors = DID_NO_CONNECT << 16;
+	
 				return BLKPREP_KILL;
 			}
 		} else {
@@ -1345,6 +1361,8 @@ static void scsi_kill_requests(request_q
 	while ((req = elv_next_request(q)) != NULL) {
 		blkdev_dequeue_request(req);
 		req->flags |= REQ_QUIET;
+		if (blk_pc_request(req))
+			req->errors = DID_NO_CONNECT << 16;
 		while (end_that_request_first(req, 0, req->nr_sectors))
 			;
 		end_that_request_last(req);
@@ -1400,6 +1418,8 @@ static void scsi_request_fn(struct reque
 			       sdev->host->host_no, sdev->id, sdev->lun);
 			blkdev_dequeue_request(req);
 			req->flags |= REQ_QUIET;
+			if (blk_pc_request(req))
+				req->errors = DID_NO_CONNECT << 16;
 			while (end_that_request_first(req, 0, req->nr_sectors))
 				;
 			end_that_request_last(req);


