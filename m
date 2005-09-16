From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 5/5] kill scsi_wait_req
Date: Thu, 15 Sep 2005 23:40:02 -0500
Message-ID: <1126845602.9276.46.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39114 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751232AbVIPEkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 00:40:07 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8G4e6jT029352
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2005 23:40:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

cpqfc is the last user of scsi_wait_req. It is too broken to even
test patches to convert it to other functions though.
This patch just kills scsi_wait_req and adds to the list
of things that are broken on cpqfc. I was not sure what
the proper thing to do in this case when the driver
is so broken.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/cpqfcTSinit.c b/drivers/scsi/cpqfcTSinit.c
--- a/drivers/scsi/cpqfcTSinit.c
+++ b/drivers/scsi/cpqfcTSinit.c
@@ -663,6 +663,10 @@ int cpqfcTS_ioctl( struct scsi_device *S
 	privatedata->pdrive = vendor_cmd->pdrive;
 	
         // eventually gets us to our own _quecommand routine
+
+	/*
+	 * convert to scsi_execute_async if this driver ever works again
+	 */
 	scsi_wait_req(ScsiPassThruReq, 
 		&vendor_cmd->cdb[0], buf, vendor_cmd->len, 
 		10*HZ,  // timeout
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -228,55 +228,6 @@ void scsi_do_req(struct scsi_request *sr
 }
 EXPORT_SYMBOL(scsi_do_req);
 
-/* This is the end routine we get to if a command was never attached
- * to the request.  Simply complete the request without changing
- * rq_status; this will cause a DRIVER_ERROR. */
-static void scsi_wait_req_end_io(struct request *req)
-{
-	BUG_ON(!req->waiting);
-
-	complete(req->waiting);
-}
-
-void scsi_wait_req(struct scsi_request *sreq, const void *cmnd, void *buffer,
-		   unsigned bufflen, int timeout, int retries)
-{
-	DECLARE_COMPLETION(wait);
-	int write = (sreq->sr_data_direction == DMA_TO_DEVICE);
-	struct request *req;
-
-	req = blk_get_request(sreq->sr_device->request_queue, write,
-			      __GFP_WAIT);
-	if (bufflen && blk_rq_map_kern(sreq->sr_device->request_queue, req,
-				       buffer, bufflen, __GFP_WAIT)) {
-		sreq->sr_result = DRIVER_ERROR << 24;
-		blk_put_request(req);
-		return;
-	}
-
-	req->flags |= REQ_NOMERGE;
-	req->waiting = &wait;
-	req->end_io = scsi_wait_req_end_io;
-	req->cmd_len = COMMAND_SIZE(((u8 *)cmnd)[0]);
-	req->sense = sreq->sr_sense_buffer;
-	req->sense_len = 0;
-	memcpy(req->cmd, cmnd, req->cmd_len);
-	req->timeout = timeout;
-	req->flags |= REQ_BLOCK_PC;
-	req->rq_disk = NULL;
-	blk_insert_request(sreq->sr_device->request_queue, req,
-			   sreq->sr_data_direction == DMA_TO_DEVICE, NULL);
-	wait_for_completion(&wait);
-	sreq->sr_request->waiting = NULL;
-	sreq->sr_result = req->errors;
-	if (req->errors)
-		sreq->sr_result |= (DRIVER_ERROR << 24);
-
-	blk_put_request(req);
-}
-
-EXPORT_SYMBOL(scsi_wait_req);
-
 /**
  * scsi_execute - insert request and wait for the result
  * @sdev:	scsi device
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -47,9 +47,6 @@ struct scsi_request {
 
 extern struct scsi_request *scsi_allocate_request(struct scsi_device *, int);
 extern void scsi_release_request(struct scsi_request *);
-extern void scsi_wait_req(struct scsi_request *, const void *cmnd,
-			  void *buffer, unsigned bufflen,
-			  int timeout, int retries);
 extern void scsi_do_req(struct scsi_request *, const void *cmnd,
 			void *buffer, unsigned bufflen,
 			void (*done) (struct scsi_cmnd *),


