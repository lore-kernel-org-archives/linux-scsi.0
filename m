From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove scsi_wait_req
Date: Sat, 29 Oct 2005 01:09:12 +0200
Message-ID: <20051028230912.GA13193@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:28599 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1750749AbVJ1XJP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 19:09:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This function has been superceeded by the block request based interfaces
and is unused (except for the uncompilable cpqfc driver).


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c	2005-10-28 19:49:55.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_lib.c	2005-10-29 01:06:41.000000000 +0200
@@ -254,55 +254,6 @@
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
Index: linux-2.6/include/scsi/scsi_request.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_request.h	2005-10-28 19:49:56.000000000 +0200
+++ linux-2.6/include/scsi/scsi_request.h	2005-10-29 01:06:11.000000000 +0200
@@ -47,9 +47,6 @@
 
 extern struct scsi_request *scsi_allocate_request(struct scsi_device *, gfp_t);
 extern void scsi_release_request(struct scsi_request *);
-extern void scsi_wait_req(struct scsi_request *, const void *cmnd,
-			  void *buffer, unsigned bufflen,
-			  int timeout, int retries);
 extern void scsi_do_req(struct scsi_request *, const void *cmnd,
 			void *buffer, unsigned bufflen,
 			void (*done) (struct scsi_cmnd *),
