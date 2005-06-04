From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Sat, 04 Jun 2005 11:07:14 -0500
Message-ID: <1117901234.5005.9.camel@mulgrave>
References: <1117847972.23638.62.camel@mina>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1117847972.23638.62.camel@mina>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-06-03 at 18:19 -0700, Mike Christie wrote:
> The goal is next convert the scsi 'special' requests to use these
> functions, so scsi will be able to use block layer functions for scatter
> lists setup for all requests. And then hopefully one day we will not
> need those stinking "if (sc->use_sg)" paths all over our scsi drivers.

Here's the proof of concept for this one.  It converts scsi_wait_req to
do correct REQ_BLOCK_PC submission (and works nicely in my setup).

The final goal should be to eliminate struct scsi_request, but that
can't be done until the character submission paths of sg and st are also
modified.

There's some loss of functionality to this: retries are no longer
controllable (except by setting REQ_FASTFAIL) and the wait_req API needs
to be altered, but it looks very nice.

Thanks,

James

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -238,23 +238,6 @@ void scsi_do_req(struct scsi_request *sr
 }
 EXPORT_SYMBOL(scsi_do_req);
 
-static void scsi_wait_done(struct scsi_cmnd *cmd)
-{
-	struct request *req = cmd->request;
-	struct request_queue *q = cmd->device->request_queue;
-	unsigned long flags;
-
-	req->rq_status = RQ_SCSI_DONE;	/* Busy, but indicate request done */
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (blk_rq_tagged(req))
-		blk_queue_end_tag(q, req);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	if (req->waiting)
-		complete(req->waiting);
-}
-
 /* This is the end routine we get to if a command was never attached
  * to the request.  Simply complete the request without changing
  * rq_status; this will cause a DRIVER_ERROR. */
@@ -269,19 +252,36 @@ void scsi_wait_req(struct scsi_request *
 		   unsigned bufflen, int timeout, int retries)
 {
 	DECLARE_COMPLETION(wait);
-	
-	sreq->sr_request->waiting = &wait;
-	sreq->sr_request->rq_status = RQ_SCSI_BUSY;
-	sreq->sr_request->end_io = scsi_wait_req_end_io;
-	scsi_do_req(sreq, cmnd, buffer, bufflen, scsi_wait_done,
-			timeout, retries);
+	struct request *req;
+
+	if (bufflen)
+		req = blk_rq_map_kern(sreq->sr_device->request_queue,
+				      sreq->sr_data_direction == DMA_TO_DEVICE,
+				      buffer, bufflen, __GFP_WAIT);
+	else
+		req = blk_get_request(sreq->sr_device->request_queue, READ,
+				      __GFP_WAIT);
+	req->flags |= REQ_NOMERGE;
+	req->waiting = &wait;
+	req->end_io = scsi_wait_req_end_io;
+	req->cmd_len = COMMAND_SIZE(((u8 *)cmnd)[0]);
+	req->sense = sreq->sr_sense_buffer;
+	req->sense_len = 0;
+	memcpy(req->cmd, cmnd, req->cmd_len);
+	req->timeout = timeout;
+	req->flags |= REQ_BLOCK_PC;
+	req->rq_disk = NULL;
+	blk_insert_request(sreq->sr_device->request_queue, req,
+			   sreq->sr_data_direction == DMA_TO_DEVICE, NULL);
 	wait_for_completion(&wait);
 	sreq->sr_request->waiting = NULL;
-	if (sreq->sr_request->rq_status != RQ_SCSI_DONE)
+	sreq->sr_result = req->errors;
+	if (req->errors)
 		sreq->sr_result |= (DRIVER_ERROR << 24);
 
-	__scsi_release_request(sreq);
+	blk_put_request(req);
 }
+
 EXPORT_SYMBOL(scsi_wait_req);
 
 /*
@@ -889,11 +889,12 @@ void scsi_io_completion(struct scsi_cmnd
 		return;
 	}
 	if (result) {
-		printk(KERN_INFO "SCSI error : <%d %d %d %d> return code "
-		       "= 0x%x\n", cmd->device->host->host_no,
-		       cmd->device->channel,
-		       cmd->device->id,
-		       cmd->device->lun, result);
+		if (!(req->flags & REQ_SPECIAL))
+			printk(KERN_INFO "SCSI error : <%d %d %d %d> return code "
+			       "= 0x%x\n", cmd->device->host->host_no,
+			       cmd->device->channel,
+			       cmd->device->id,
+			       cmd->device->lun, result);
 
 		if (driver_byte(result) & DRIVER_SENSE)
 			scsi_print_sense("", cmd);
@@ -1026,6 +1027,12 @@ static int scsi_issue_flush_fn(request_q
 	return -EOPNOTSUPP;
 }
 
+static void scsi_generic_done(struct scsi_cmnd *cmd)
+{
+	BUG_ON(!blk_pc_request(cmd->request));
+	scsi_io_completion(cmd, cmd->result == 0 ? cmd->bufflen : 0, 0);
+}
+
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct scsi_device *sdev = q->queuedata;
@@ -1067,7 +1074,7 @@ static int scsi_prep_fn(struct request_q
 	 * these two cases differently.  We differentiate by looking
 	 * at request->cmd, as this tells us the real story.
 	 */
-	if (req->flags & REQ_SPECIAL) {
+	if (req->flags & REQ_SPECIAL && req->special) {
 		struct scsi_request *sreq = req->special;
 
 		if (sreq->sr_magic == SCSI_REQ_MAGIC) {
@@ -1079,7 +1086,7 @@ static int scsi_prep_fn(struct request_q
 			cmd = req->special;
 	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
 
-		if(unlikely(specials_only)) {
+		if(unlikely(specials_only) && !(req->flags & REQ_SPECIAL)) {
 			if(specials_only == SDEV_QUIESCE ||
 					specials_only == SDEV_BLOCK)
 				return BLKPREP_DEFER;
@@ -1148,11 +1155,26 @@ static int scsi_prep_fn(struct request_q
 		/*
 		 * Initialize the actual SCSI command for this request.
 		 */
-		drv = *(struct scsi_driver **)req->rq_disk->private_data;
-		if (unlikely(!drv->init_command(cmd))) {
-			scsi_release_buffers(cmd);
-			scsi_put_command(cmd);
-			return BLKPREP_KILL;
+		if (req->rq_disk) {
+			drv = *(struct scsi_driver **)req->rq_disk->private_data;
+			if (unlikely(!drv->init_command(cmd))) {
+				scsi_release_buffers(cmd);
+				scsi_put_command(cmd);
+				return BLKPREP_KILL;
+			}
+		} else {
+			memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
+			if (rq_data_dir(req) == WRITE)
+				cmd->sc_data_direction = DMA_TO_DEVICE;
+			else if (req->data_len)
+				cmd->sc_data_direction = DMA_FROM_DEVICE;
+			else
+				cmd->sc_data_direction = DMA_NONE;
+			
+			cmd->transfersize = req->data_len;
+			cmd->allowed = 3;
+			cmd->timeout_per_command = req->timeout;
+			cmd->done = scsi_generic_done;
 		}
 	}
 
