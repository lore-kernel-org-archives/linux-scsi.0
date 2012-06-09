From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
Date: Sat, 09 Jun 2012 12:47:24 +0000
Message-ID: <4FD345DC.6020405@acm.org>
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/09/12 00:10, Muthu Kumar wrote:

> Since the queue->lock case is taken care of in the following patch:
> 
> (http://www.spinics.net/lists/linux-scsi/msg59845.html [PATCH 1/4]
> block: Fix race on request_queue.end_io invocations)
> 
> Updated the patch with just the end_io assignment before dead queue check.
> 
> 
> -------------
> blk-exec.c: In blk_execute_rq_nowait(), if the queue is dead, call to
> done() routine is not made. That will result in blk_execute_rq() stuck
> in wait_for_completion(). Avoid this by initializing rq->end_io to
> done() routine before we check for dead queue.
> 
> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: James Bottomley <James.Bottomley@hansenpartnership.com>
> 
> -------------
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index fb2cbd5..f8b00c7 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -53,6 +53,9 @@ void blk_execute_rq_nowait(struct request_queue *q,
> struct gendisk *bd_disk,
>         WARN_ON(irqs_disabled());
>         spin_lock_irq(q->queue_lock);
> 
> +       rq->rq_disk = bd_disk;
> +       rq->end_io = done;
> +
>         if (unlikely(blk_queue_dead(q))) {
>                 spin_unlock_irq(q->queue_lock);
>                 rq->errors = -ENXIO;
> @@ -61,8 +64,6 @@ void blk_execute_rq_nowait(struct request_queue *q,
> struct gendisk *bd_disk,
>                 return;
>         }


This patch does not apply since it's line-wrapped and a part is missing
in the second hunk. However, if I had overlooked your original patch
then I want to apologize.

If you can resend your original patch including the locking changes then
I'll test it further.

Bart.
