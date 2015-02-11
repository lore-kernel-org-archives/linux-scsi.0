From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] bsg: fix unkillable I/O wait deadlock with scsi-mq
Date: Wed, 11 Feb 2015 11:31:49 -0500
Message-ID: <54DB83F5.50104@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cybernetics.com ([173.71.130.66]:44062 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbbBKQbu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2015 11:31:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-kernel@vger.kernel.org

When using the write()/read() interface for submitting commands, the bsg
driver does not call blk_put_request() on a completed SCSI command until
userspace calls read() to get the command completion.  Since scsi-mq
uses a fixed number of preallocated requests, this makes it possible for
userspace to exhaust the entire preallocated supply of requests, leading
to deadlock with the user process stuck in a permanent unkillable I/O
wait in bsg_write() -> ... -> blk_get_request() -> ... -> bt_get(). 
Note that this deadlock can happen only if scsi-mq is enabled.  Prevent
the deadlock by calling blk_put_request() as soon as the SCSI command
completes instead of waiting for userspace to call read().

Cc: <stable@vger.kernel.org> # 3.17+
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

For inclusion in kernel 3.20.

Note: I did a number of tests with this patch, but I do not have any
programs to test commands with bidirectional data transfer.  I would
appreciate if someone could test that.

description of changes:
*) For ioctl(SG_IO), allocate a struct bsg_command on the stack instead
of allocating all the component fields on the stack.  This helps
simplify the code.
*) Split blk_complete_sgv4_hdr_rq() into two functions:
bsg_complete_command_rq() and bsg_complete_command_usercontext().
*) Call bsg_complete_command_rq() from the asynchronous bsg_rq_end_io()
or after a synchronous call to blk_execute_rq().
*) The important change to fix the deadlock is that bsg_rq_end_io() now
calls __blk_put_request().
*) Replace calls to blk_complete_sgv4_hdr_rq() with calls to
bsg_complete_command_usercontext().
*) Use bc->err to pass around negative error values.
*) If rq->errors < 0, do not use it to set
device_status/transport_status/driver_status.
*) Check the return value of blk_rq_unmap_user().
*) Remove bc->rq as it is no longer needed.

I will send a separate patch to fix the same problem in the sg driver.

--- linux-3.19.0/block/bsg.c.orig	2015-02-08 21:54:22.000000000 -0500
+++ linux-3.19.0/block/bsg.c	2015-02-11 11:00:57.000000000 -0500
@@ -80,7 +80,6 @@ static struct kmem_cache *bsg_cmd_cachep
 struct bsg_command {
 	struct bsg_device *bd;
 	struct list_head list;
-	struct request *rq;
 	struct bio *bio;
 	struct bio *bidi_bio;
 	int err;
@@ -88,6 +87,10 @@ struct bsg_command {
 	char sense[SCSI_SENSE_BUFFERSIZE];
 };
 
+static void bsg_complete_command_rq(struct bsg_command *bc,
+				    struct request *rq,
+				    bool holding_queue_lock);
+
 static void bsg_free_command(struct bsg_command *bc)
 {
 	struct bsg_device *bd = bc->bd;
@@ -346,6 +349,8 @@ static void bsg_rq_end_io(struct request
 
 	bc->hdr.duration = jiffies_to_msecs(jiffies - bc->hdr.duration);
 
+	bsg_complete_command_rq(bc, rq, true);
+
 	spin_lock_irqsave(&bd->lock, flags);
 	list_move_tail(&bc->list, &bd->done_list);
 	bd->done_cmds++;
@@ -366,7 +371,6 @@ static void bsg_add_command(struct bsg_d
 	/*
 	 * add bc command to busy queue and submit rq for io
 	 */
-	bc->rq = rq;
 	bc->bio = rq->bio;
 	if (rq->next_rq)
 		bc->bidi_bio = rq->next_rq->bio;
@@ -426,60 +430,100 @@ static struct bsg_command *bsg_get_done_
 	return bc;
 }
 
-static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
-				    struct bio *bio, struct bio *bidi_bio)
+/*
+ * Post-process a completed request.  This should be called immediately after
+ * the request completes so that its resources can be reused for other
+ * commands.
+ */
+static void bsg_complete_command_rq(struct bsg_command *bc,
+				    struct request *rq,
+				    bool holding_queue_lock)
 {
-	int ret = 0;
-
-	dprintk("rq %p bio %p 0x%x\n", rq, bio, rq->errors);
+	dprintk("rq %p 0x%x\n", rq, rq->errors);
 	/*
 	 * fill in all the output members
+	 *
+	 * If the request generated a negative error number, return it from
+	 * the system call (e.g. read() or ioctl()); if it's just a protocol
+	 * response (i.e. non negative), include it in the response hdr.
 	 */
-	hdr->device_status = rq->errors & 0xff;
-	hdr->transport_status = host_byte(rq->errors);
-	hdr->driver_status = driver_byte(rq->errors);
-	hdr->info = 0;
-	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
-		hdr->info |= SG_INFO_CHECK;
-	hdr->response_len = 0;
-
-	if (rq->sense_len && hdr->response) {
-		int len = min_t(unsigned int, hdr->max_response_len,
-					rq->sense_len);
-
-		ret = copy_to_user((void __user *)(unsigned long)hdr->response,
-				   rq->sense, len);
-		if (!ret)
-			hdr->response_len = len;
-		else
-			ret = -EFAULT;
-	}
+	if (unlikely(rq->errors < 0)) {
+		bc->err                  = rq->errors;
+		bc->hdr.device_status    = 0;
+		bc->hdr.transport_status = DID_ERROR;
+		bc->hdr.driver_status    = DRIVER_ERROR;
+	} else {
+		bc->hdr.device_status    = rq->errors & 0xff;
+		bc->hdr.transport_status = host_byte(rq->errors);
+		bc->hdr.driver_status    = driver_byte(rq->errors);
+	}
+	bc->hdr.info = 0;
+	if (bc->hdr.device_status || bc->hdr.transport_status ||
+	    bc->hdr.driver_status)
+		bc->hdr.info |= SG_INFO_CHECK;
+
+	bc->hdr.response_len =
+		(!bc->hdr.response) ? 0 : min_t(unsigned int,
+						bc->hdr.max_response_len,
+						rq->sense_len);
 
 	if (rq->next_rq) {
-		hdr->dout_resid = rq->resid_len;
-		hdr->din_resid = rq->next_rq->resid_len;
-		blk_rq_unmap_user(bidi_bio);
-		blk_put_request(rq->next_rq);
+		bc->hdr.dout_resid = rq->resid_len;
+		bc->hdr.din_resid  = rq->next_rq->resid_len;
+		if (holding_queue_lock)
+			__blk_put_request(rq->q, rq->next_rq);
+		else
+			blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
-		hdr->din_resid = rq->resid_len;
+		bc->hdr.din_resid = rq->resid_len;
 	else
-		hdr->dout_resid = rq->resid_len;
+		bc->hdr.dout_resid = rq->resid_len;
 
 	/*
-	 * If the request generated a negative error number, return it
-	 * (providing we aren't already returning an error); if it's
-	 * just a protocol response (i.e. non negative), that gets
-	 * processed above.
+	 * Free the request as soon as it is complete so that its resources
+	 * can be reused without waiting for userspace to read() the
+	 * result.  But keep the associated bios (if any) around until
+	 * bsg_complete_command_usercontext() can be called from user context.
 	 */
-	if (!ret && rq->errors < 0)
-		ret = rq->errors;
-
-	blk_rq_unmap_user(bio);
 	if (rq->cmd != rq->__cmd)
 		kfree(rq->cmd);
-	blk_put_request(rq);
+	if (holding_queue_lock)
+		__blk_put_request(rq->q, rq);
+	else
+		blk_put_request(rq);
+}
 
-	return ret;
+/*
+ * Post-process a completed request from user context.
+ */
+static int bsg_complete_command_usercontext(struct bsg_command *bc)
+{
+	int ret;
+
+	dprintk("bio %p\n", bc->bio);
+
+	if (bc->hdr.response_len) {
+		ret = copy_to_user(
+			(void __user *)(unsigned long)bc->hdr.response,
+			bc->sense, bc->hdr.response_len);
+		if (unlikely(ret)) {
+			bc->hdr.response_len = 0;
+			bc->err = -EFAULT;
+		}
+	}
+
+	if (bc->bidi_bio) {
+		ret = blk_rq_unmap_user(bc->bidi_bio);
+		if (unlikely(ret))
+			bc->err = ret;
+	}
+	if (bc->bio) {
+		ret = blk_rq_unmap_user(bc->bio);
+		if (unlikely(ret))
+			bc->err = ret;
+	}
+
+	return bc->err;
 }
 
 static int bsg_complete_all_commands(struct bsg_device *bd)
@@ -520,8 +564,7 @@ static int bsg_complete_all_commands(str
 		if (IS_ERR(bc))
 			break;
 
-		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
-						bc->bidi_bio);
+		tret = bsg_complete_command_usercontext(bc);
 		if (!ret)
 			ret = tret;
 
@@ -555,8 +598,7 @@ __bsg_read(char __user *buf, size_t coun
 		 * after completing the request. so do that here,
 		 * bsg_complete_work() cannot do that for us
 		 */
-		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
-					       bc->bidi_bio);
+		ret = bsg_complete_command_usercontext(bc);
 
 		if (copy_to_user(buf, &bc->hdr, sizeof(bc->hdr)))
 			ret = -EFAULT;
@@ -926,28 +968,29 @@ static long bsg_ioctl(struct file *file,
 		return scsi_cmd_ioctl(bd->queue, NULL, file->f_mode, cmd, uarg);
 	}
 	case SG_IO: {
+		struct bsg_command bc;
 		struct request *rq;
-		struct bio *bio, *bidi_bio = NULL;
-		struct sg_io_v4 hdr;
 		int at_head;
-		u8 sense[SCSI_SENSE_BUFFERSIZE];
 
-		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
+		if (copy_from_user(&bc.hdr, uarg, sizeof(bc.hdr)))
 			return -EFAULT;
 
-		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE, sense);
+		rq = bsg_map_hdr(bd, &bc.hdr, file->f_mode & FMODE_WRITE,
+				 bc.sense);
 		if (IS_ERR(rq))
 			return PTR_ERR(rq);
 
-		bio = rq->bio;
-		if (rq->next_rq)
-			bidi_bio = rq->next_rq->bio;
+		bc.bd       = bd;
+		bc.bio      = rq->bio;
+		bc.bidi_bio = (rq->next_rq) ? rq->next_rq->bio : NULL;
+		bc.err      = 0;
 
-		at_head = (0 == (hdr.flags & BSG_FLAG_Q_AT_TAIL));
+		at_head = (0 == (bc.hdr.flags & BSG_FLAG_Q_AT_TAIL));
 		blk_execute_rq(bd->queue, NULL, rq, at_head);
-		ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
+		bsg_complete_command_rq(&bc, rq, false);
+		ret = bsg_complete_command_usercontext(&bc);
 
-		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
+		if (copy_to_user(uarg, &bc.hdr, sizeof(bc.hdr)))
 			return -EFAULT;
 
 		return ret;

