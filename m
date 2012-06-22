From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
Date: Fri, 22 Jun 2012 07:20:38 +0000
Message-ID: <4FE41CC6.4010406@acm.org>
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com> <4FD345DC.6020405@acm.org> <CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com> <4FD4DC26.5080902@acm.org> <CAFR8uecF0LwbV8FvYob5m34sVbKqafrNoYOrcRUQCEOymGnYRA@mail.gmail.com> <CAFR8uefK+nByiJ8tw5_KF1qEJs4du2mDdU36gg1_2nRNZXN5Fw@mail.gmail.com> <20120618224253.GH32733@google.com> <4FE21C15.6040409@acm.org> <CAFR8ueeFcnMCqG=A1im09crBNckgfPixsCz9oceQCpPeJ3wiNw@mail.gmail.com> <4FE2B3D1.6070504@acm.org> <CAFR8uecUUVD3Ra4ajNxMi=37LKWd7T46_xLR6C2=47MWZ6K=9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFR8uecUUVD3Ra4ajNxMi=37LKWd7T46_xLR6C2=47MWZ6K=9Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/21/12 21:40, Muthu Kumar wrote:

> On Wed, Jun 20, 2012 at 10:40 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>> On 06/21/12 00:53, Muthu Kumar wrote:
>>> This part already went in, its here only for testing - So in the final
>>> patch, before applying this should be removed.
>>
>> When did it go in ? As far as I can see that patch is not yet present in
>> Linus' tree nor in James' tree.
> 
> My bad. I thought Jens/James took it already... may be not.


Do you agree with combining both patches into one (see below) ?

From: Muthukumar Ratty <muthur@gmail.com>
Subject: [PATCH] block: Fix blk_execute_rq_nowait() dead queue handling

If the queue is dead blk_execute_rq_nowait() doesn't invoke the done()
callback function. That will result in blk_execute_rq() being stuck
in wait_for_completion(). Avoid this by initializing rq->end_io to the
done() callback before we check the queue state. Also, make sure the
queue lock is held around the invocation of the done() callback. Found
this through source code review.

Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
---
 block/blk-exec.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index fb2cbd5..8b6dc5b 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -43,6 +43,9 @@ static void blk_end_sync_rq(struct request *rq, int error)
  * Description:
  *    Insert a fully prepared request at the back of the I/O scheduler queue
  *    for execution.  Don't wait for completion.
+ *
+ * Note:
+ *    This function will invoke @done directly if the queue is dead.
  */
 void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 			   struct request *rq, int at_head,
@@ -51,18 +54,20 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 
 	WARN_ON(irqs_disabled());
+
+	rq->rq_disk = bd_disk;
+	rq->end_io = done;
+
 	spin_lock_irq(q->queue_lock);
 
 	if (unlikely(blk_queue_dead(q))) {
-		spin_unlock_irq(q->queue_lock);
 		rq->errors = -ENXIO;
 		if (rq->end_io)
 			rq->end_io(rq, rq->errors);
+		spin_unlock_irq(q->queue_lock);
 		return;
 	}
 
-	rq->rq_disk = bd_disk;
-	rq->end_io = done;
 	__elv_add_request(q, rq, where);
 	__blk_run_queue(q);
 	/* the queue is stopped so it won't be run */
-- 
1.7.7
