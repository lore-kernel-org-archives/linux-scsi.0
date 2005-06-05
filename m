From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc requests
	and simplify hw handlers
Date: Sun, 05 Jun 2005 14:11:05 -0500
Message-ID: <1117998665.4990.17.camel@mulgrave>
References: <1117847972.23638.62.camel@mina>
	 <1117901234.5005.9.camel@mulgrave>  <1117955727.4961.8.camel@mina>
	 <1117982408.4990.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:1233 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261600AbVFETLY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Jun 2005 15:11:24 -0400
In-Reply-To: <1117982408.4990.12.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Sun, 2005-06-05 at 09:40 -0500, James Bottomley wrote:
> Finally, there's coming up with a replacement API for scsi_do_req that
> returns via the end_io callback ... since that doesn't do a wait/wake,
> perhaps this should be the core API upon which the others are built?

OK, well, the API is easy ... it's attached.  Converting sg and st to
use it is quite another matter.  sg in particular is a nasty tangle when
it comes to doing its own sg mapping, which the block layer will now do
for it.

James
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -177,6 +177,23 @@ int scsi_queue_insert(struct scsi_cmnd *
 	return 0;
 }
 
+struct scsi_do_req_cb {
+	void (*done)(void *, int);
+	void *data;
+};
+
+static void scsi_do_req_end_io(struct request *req)
+{
+	int result = req->errors;
+	struct scsi_do_req_cb *cb = req->end_io_data;
+	
+	BUG_ON(cb == NULL);
+	if (result)
+		result |= DRIVER_ERROR << 24;
+	blk_put_request(req);
+	cb->done(cb->data, result);
+	kfree(cb);
+}
 /*
  * Function:    scsi_do_req
  *
@@ -203,38 +220,49 @@ int scsi_queue_insert(struct scsi_cmnd *
  *		now inject requests on the *head* of the device queue
  *		rather than the tail.
  */
-void scsi_do_req(struct scsi_request *sreq, const void *cmnd,
-		 void *buffer, unsigned bufflen,
-		 void (*done)(struct scsi_cmnd *),
-		 int timeout, int retries)
+void scsi_do_command(struct scsi_device *sdev, const void *cmnd, int cmd_len,
+		     void *buffer, unsigned bufflen, void *data,
+		     void (*done)(void *, int),
+		     char *sense_buffer, int timeout, int retries,
+		     enum dma_data_direction dir)
 {
-	/*
-	 * If the upper level driver is reusing these things, then
-	 * we should release the low-level block now.  Another one will
-	 * be allocated later when this request is getting queued.
-	 */
-	__scsi_release_request(sreq);
+	struct scsi_do_req_cb *cb = kmalloc(sizeof(struct scsi_do_req_cb),
+						   GFP_KERNEL);
+	struct request *req;
 
-	/*
-	 * Our own function scsi_done (which marks the host as not busy,
-	 * disables the timeout counter, etc) will be called by us or by the
-	 * scsi_hosts[host].queuecommand() function needs to also call
-	 * the completion function for the high level driver.
-	 */
-	memcpy(sreq->sr_cmnd, cmnd, sizeof(sreq->sr_cmnd));
-	sreq->sr_bufflen = bufflen;
-	sreq->sr_buffer = buffer;
-	sreq->sr_allowed = retries;
-	sreq->sr_done = done;
-	sreq->sr_timeout_per_command = timeout;
+	if (!cb)
+		goto error_out;
+	if (bufflen) {
+		req = blk_rq_map_kern(sdev->request_queue,
+				      dir == DMA_TO_DEVICE,
+				      buffer, bufflen, __GFP_WAIT);
+		if (IS_ERR(req))
+			goto error_out;
+		blk_queue_bounce(sdev->request_queue, &req->bio);
+	} else
+		req = blk_get_request(sdev->request_queue, READ, __GFP_WAIT);
 
-	if (sreq->sr_cmd_len == 0)
-		sreq->sr_cmd_len = COMMAND_SIZE(sreq->sr_cmnd[0]);
+	req->waiting = NULL;
+	req->end_io = scsi_do_req_end_io;
+	if (cmd_len == 0)
+		req->cmd_len = COMMAND_SIZE(((u8 *)cmnd)[0]);
+	else
+		req->cmd_len = cmd_len;
+	req->sense = sense_buffer;
+	req->sense_len = 0;
+	memcpy(req->cmd, cmnd, req->cmd_len);
+	req->timeout = timeout;
+	req->flags |= REQ_BLOCK_PC;
+	/* If we have no rq_disk, the ULD won't get to prepare the command */
+	req->rq_disk = NULL;
+	blk_insert_request(sdev->request_queue, req,
+			   1, NULL);
+	return;
 
-	/*
-	 * head injection *required* here otherwise quiesce won't work
-	 */
-	scsi_insert_special_req(sreq, 1);
+ error_out:
+	kfree(cb);
+	done(data, DRIVER_ERROR << 24);
+	return;
 }
 EXPORT_SYMBOL(scsi_do_req);
 


