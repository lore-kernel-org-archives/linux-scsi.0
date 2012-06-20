From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
Date: Wed, 20 Jun 2012 18:53:09 +0000
Message-ID: <4FE21C15.6040409@acm.org>
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com> <4FD345DC.6020405@acm.org> <CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com> <4FD4DC26.5080902@acm.org> <CAFR8uecF0LwbV8FvYob5m34sVbKqafrNoYOrcRUQCEOymGnYRA@mail.gmail.com> <CAFR8uefK+nByiJ8tw5_KF1qEJs4du2mDdU36gg1_2nRNZXN5Fw@mail.gmail.com> <20120618224253.GH32733@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120618224253.GH32733@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Muthu Kumar <muthu.lkml@gmail.com>, Jens Axboe <axboe@kernel.dk>, Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/18/12 22:42, Tejun Heo wrote:

> On Mon, Jun 11, 2012 at 02:23:23PM -0700, Muthu Kumar wrote:
>> On Mon, Jun 11, 2012 at 10:33 AM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
>>> On Sun, Jun 10, 2012 at 10:40 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>>>> On 06/09/12 23:57, Muthu Kumar wrote:
>>>>
>>>>> Locking change is the one you posted already (the link above). Anyway,
>>>>> I have the attached patch *including* the locking change. Original
>>>>> mail has attachment without locking change. Please use whatever you
>>>>> need.
>>>>
>>>> While we are at it ... the rq->rq_disk and rq->end_io assignments can be
>>>> performed safely before the spinlock is taken, isn't it ?
>>>
>>> Yes.. that spinlock is to protect the q.
>>
>> Attached patch with assignment performed before taking the spinlock.
> 
> This looks correct to me.  Bart, can you please include this patch in
> your series and repost the series?


I'll start testing the patch below:

[PATCH] block: Fix blk_execute_rq_nowait() dead queue handling

Make sure that blk_execute_rq_nowait() invokes the proper end_io
function if the queue is dead and also that this call is performed
with the queue lock held. Found this through source code review.

Notes:
- Since blk_execute_rq_nowait() must not be invoked from interrupt
  context it is safe to invoke end_io directly from this function.
- blk_finish_request() already invokes request.end_io with the
  queue lock held.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reported-by: Muthukumar Ratty <muthur@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
---
 block/blk-exec.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index fb2cbd5..c0fd83a 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -42,7 +42,8 @@ static void blk_end_sync_rq(struct request *rq, int error)
  *
  * Description:
  *    Insert a fully prepared request at the back of the I/O scheduler queue
- *    for execution.  Don't wait for completion.
+ *    for execution.  Don't wait for completion.  This function may invoke
+ *    rq->end_io directly.
  */
 void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 			   struct request *rq, int at_head,
@@ -51,18 +52,20 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
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
