From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] block_abort_queue (blk_abort_request) racing with
 scsi_request_fn
Date: Wed, 10 Nov 2010 01:09:24 -0600
Message-ID: <4CDA4524.4010204@cs.wisc.edu>
References: <20100512052336.GB15240@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040005060404090904060907"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50822 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab0KJHCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 02:02:13 -0500
In-Reply-To: <20100512052336.GB15240@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040005060404090904060907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/12/2010 12:23 AM, Mike Anderson wrote:
> I was looking at a dump from a weekend run and I believe I am seeing a
> case where blk_abort_request through blk_abort_queue picked up a request
> for timeout that scsi_request_fn decided not to start. This test was under
> error injection.
>
> I assume the case in scsi_request_fn this is hitting is that a request has
> been put on the timeout_list with blk_start_request and then one of the
> not_ready checks is hit and the request is decided not to be started. I
> believe the drop
>
> It appears that my usage of walking the timeout_list in block_abort_queue
> and using blk_mark_rq_complete in block_abort_request will not work in
> this case.
>
> While it would be good to have way to ensure a command is started, it is
> unclear if even at a low timeout of 1 second that a user other than
> blk_abort_queue would hit this race.
>
> The dropping / acquiring of host_lock and queue_lock in scsi_request_fn
> and scsi_dispatch_cmd make it unclear to me if usage of
> blk_mark_rq_complete will cover all cases.
>
> I looked at checking serial_number in scsi_times_out along with a couple
> blk_mark_rq_complete additions, but unclear if this would be good and / or
> work in all cases.
>
> I looked at just accelerating deadline by some default value but unclear
> if that would be acceptable.
>
> I also looked at just using just the mark interface I previously posted
> and not calling blk_abort_request at all, but that would change current
> behavior that has been in use for a while.
>

Did you ever solve this? I am hitting this with the dm-multipath 
blk_abort_queue case (the email I sent you a couple weeks ago).

It seems we could fix this by just having blk_requeue_request do a check 
for if the request timedout similar to what scsi used to do. A hacky way 
might be to have 2 requeue functions.

blk_requeue_completed_request - This is the blk_requeue_request we have 
today. It unconditionally requeues the request. It should only be used 
if the command has been completed either from blk_complete_request or 
from block layer timeout handling 
(blk_rq_timed_out_timer->blk_rq_timed_out->rq_timed_out_fn).

blk_requeue_running_request - This checks if the timer is running before 
requeueing the request. If blk_rq_timed_out_timer/blk_rq_timed_out has 
taken over the request and is going to handle it then this function just 
returns and does not requeue. So for this we could just have it check if 
the queue has a rq_timed_out_fn and if rq->timeout_list is empty or not.

I think this might be confusing to use, so I tried something slightly 
different below.


I also tried a patch where we just add another req bit. We set it in 
blk_rq_timed_out_timer and clear it in a new function that clears it 
then calls blk_requeue_reqeust. The new function:

blk_requeue_timedout_request - used when request is to be requeued if a 
LLD q->rq_timed_out_fn returned BLK_EH_NOT_HANDLED and has resolved the 
problem and wants the request to be requeued. This function clears 
REQ_ATOM_TIMEDOUT and then calls blk_requeue_request.

blk_reqeuue_request would then check if REQ_ATOM_TIMEDOUT is set and if 
it was just drop the request assuming the rq_timed_out_fn was handling 
it. This still requires the caller to know how the command is supposed 
to be reqeueud. But I think it might be easier since the driver here has 
returned BLK_EH_NOT_HANDLED in the q timeout fn so they know that they 
are going to be handling the request in a special way.

I attached the last idea here. Made over Linus's tree. Only compile tested.

--------------040005060404090904060907
Content-Type: text/plain;
 name="blk-requeue-timedout-request.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="blk-requeue-timedout-request.patch"

diff --git a/block/blk-core.c b/block/blk-core.c
index f0834e2..92279d4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -981,6 +981,9 @@ EXPORT_SYMBOL(blk_make_request);
  */
 void blk_requeue_request(struct request_queue *q, struct request *rq)
 {
+	if (test_bit(REQ_ATOM_TIMEDOUT, &rq->atomic_flags))
+		return;
+
 	blk_delete_timer(rq);
 	blk_clear_rq_complete(rq);
 	trace_block_rq_requeue(q, rq);
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index ee9c216..e0a8d11 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -156,8 +156,10 @@ void blk_complete_request(struct request *req)
 {
 	if (unlikely(blk_should_fake_timeout(req->q)))
 		return;
-	if (!blk_mark_rq_complete(req))
+	if (!blk_mark_rq_complete(req)) {
+		blk_clear_rq_timedout(req);
 		__blk_complete_request(req);
+	}
 }
 EXPORT_SYMBOL(blk_complete_request);
 
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 4f0c06c..afc6e5f 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -97,6 +97,7 @@ static void blk_rq_timed_out(struct request *req)
 		 * and we can move more of the generic scsi eh code to
 		 * the blk layer.
 		 */
+		blk_mark_rq_timedout(req);
 		break;
 	default:
 		printk(KERN_ERR "block: bad eh return: %d\n", ret);
@@ -104,6 +105,25 @@ static void blk_rq_timed_out(struct request *req)
 	}
 }
 
+/**
+ * blk_requeue_timedout_request - put a request that timedout back on queue
+ * @q:		request queue where request should be inserted
+ * @rq:		request to be inserted
+ *
+ * Description:
+ *	If a module has returned BLK_EH_NOT_HANDLED from its
+ *	rq_timed_out_fn and needs to requeue the request this
+ *	function should be used instead of blk_requeue_request.
+ *
+ *	queue_lock must be held.
+ */
+void blk_requeue_timedout_request(struct request_queue *q, struct request *req)
+{
+	blk_clear_rq_timedout(req);
+	blk_requeue_request(q, req);
+}
+EXPORT_SYMBOL_GPL(blk_requeue_timedout_request);
+
 void blk_rq_timed_out_timer(unsigned long data)
 {
 	struct request_queue *q = (struct request_queue *) data;
diff --git a/block/blk.h b/block/blk.h
index 2db8f32..ad93258 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -30,6 +30,7 @@ void __generic_unplug_device(struct request_queue *);
  */
 enum rq_atomic_flags {
 	REQ_ATOM_COMPLETE = 0,
+	REQ_ATOM_TIMEDOUT = 1,
 };
 
 /*
@@ -46,7 +47,15 @@ static inline void blk_clear_rq_complete(struct request *rq)
 	clear_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
 }
 
-/*
+static inline int blk_mark_rq_timedout(struct request *rq)
+{
+	return test_and_set_bit(REQ_ATOM_TIMEDOUT, &rq->atomic_flags);
+}
+
+static inline void blk_clear_rq_timedout(struct request *rq)
+{
+	clear_bit(REQ_ATOM_TIMEDOUT, &rq->atomic_flags);
+}/*
  * Internal elevator interface
  */
 #define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1de30eb..06df25a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1680,7 +1680,11 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 							  " retry cmd: %p\n",
 							  current->comm,
 							  scmd));
-				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+				printk(KERN_ERR "scmd %p %p %p\n", scmd,
+					scmd->eh_entry.next, scmd->eh_entry.prev);
+
+				scsi_queue_insert(scmd,
+						SCSI_MLQUEUE_EH_TIMEDOUT_RETRY);
 		} else {
 			/*
 			 * If just we got sense for the device (called
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index eafeeda..cef49b2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -158,7 +158,10 @@ static int __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	 * and plugs the queue appropriately.
          */
 	spin_lock_irqsave(q->queue_lock, flags);
-	blk_requeue_request(q, cmd->request);
+	if (reason == SCSI_MLQUEUE_EH_TIMEDOUT_RETRY)
+		blk_requeue_timedout_request(q, cmd->request);
+	else
+		blk_requeue_request(q, cmd->request);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	scsi_run_queue(q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5027a59..e56f28e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -205,7 +205,10 @@ typedef int (dma_drain_needed_fn)(struct request *);
 typedef int (lld_busy_fn) (struct request_queue *q);
 
 enum blk_eh_timer_return {
-	BLK_EH_NOT_HANDLED,
+	BLK_EH_NOT_HANDLED,	/* If this is returned the module must
+				 * call blk_requeue_timedout_request to
+				 * requeue it
+				 */
 	BLK_EH_HANDLED,
 	BLK_EH_RESET_TIMER,
 };
@@ -653,6 +656,8 @@ extern struct request *blk_get_request(struct request_queue *, int, gfp_t);
 extern struct request *blk_make_request(struct request_queue *, struct bio *,
 					gfp_t);
 extern void blk_insert_request(struct request_queue *, struct request *, int, void *);
+extern void blk_requeue_timedout_request(struct request_queue *,
+					 struct request *);
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern void blk_add_request_payload(struct request *rq, struct page *page,
 		unsigned int len);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 216af85..5bde952 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -442,6 +442,7 @@ static inline int scsi_is_wlun(unsigned int lun)
 #define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
 #define SCSI_MLQUEUE_EH_RETRY    0x1057
 #define SCSI_MLQUEUE_TARGET_BUSY 0x1058
+#define SCSI_MLQUEUE_EH_TIMEDOUT_RETRY	0x1059
 
 /*
  *  Use these to separate status msg and our bytes

--------------040005060404090904060907--
