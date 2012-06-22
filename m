From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
Date: Fri, 22 Jun 2012 11:05:20 -0700
Message-ID: <CAFR8ueckaeN4WjehTn4yON0c5MkcdcXj-mXDOhD_ALdVpvMWOw@mail.gmail.com>
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com>
	<4FD345DC.6020405@acm.org>
	<CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com>
	<4FD4DC26.5080902@acm.org>
	<CAFR8uecF0LwbV8FvYob5m34sVbKqafrNoYOrcRUQCEOymGnYRA@mail.gmail.com>
	<CAFR8uefK+nByiJ8tw5_KF1qEJs4du2mDdU36gg1_2nRNZXN5Fw@mail.gmail.com>
	<20120618224253.GH32733@google.com>
	<4FE21C15.6040409@acm.org>
	<CAFR8ueeFcnMCqG=A1im09crBNckgfPixsCz9oceQCpPeJ3wiNw@mail.gmail.com>
	<4FE2B3D1.6070504@acm.org>
	<CAFR8uecUUVD3Ra4ajNxMi=37LKWd7T46_xLR6C2=47MWZ6K=9Q@mail.gmail.com>
	<4FE41CC6.4010406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FE41CC6.4010406@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 22, 2012 at 12:20 AM, Bart Van Assche <bvanassche@acm.org> =
wrote:
> On 06/21/12 21:40, Muthu Kumar wrote:
>
>> On Wed, Jun 20, 2012 at 10:40 PM, Bart Van Assche <bvanassche@acm.or=
g> wrote:
>>> On 06/21/12 00:53, Muthu Kumar wrote:
>>>> This part already went in, its here only for testing - So in the f=
inal
>>>> patch, before applying this should be removed.
>>>
>>> When did it go in ? As far as I can see that patch is not yet prese=
nt in
>>> Linus' tree nor in James' tree.
>>
>> My bad. I thought Jens/James took it already... may be not.
>
>
> Do you agree with combining both patches into one (see below) ?


Perfect. Thanks.

Regards,
Muthu.









>
> From: Muthukumar Ratty <muthur@gmail.com>
> Subject: [PATCH] block: Fix blk_execute_rq_nowait() dead queue handli=
ng
>
> If the queue is dead blk_execute_rq_nowait() doesn't invoke the done(=
)
> callback function. That will result in blk_execute_rq() being stuck
> in wait_for_completion(). Avoid this by initializing rq->end_io to th=
e
> done() callback before we check the queue state. Also, make sure the
> queue lock is held around the invocation of the done() callback. Foun=
d
> this through source code review.
>
> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> ---
> =A0block/blk-exec.c | =A0 11 ++++++++---
> =A01 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index fb2cbd5..8b6dc5b 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -43,6 +43,9 @@ static void blk_end_sync_rq(struct request *rq, int=
 error)
> =A0* Description:
> =A0* =A0 =A0Insert a fully prepared request at the back of the I/O sc=
heduler queue
> =A0* =A0 =A0for execution. =A0Don't wait for completion.
> + *
> + * Note:
> + * =A0 =A0This function will invoke @done directly if the queue is d=
ead.
> =A0*/
> =A0void blk_execute_rq_nowait(struct request_queue *q, struct gendisk=
 *bd_disk,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct request *r=
q, int at_head,
> @@ -51,18 +54,20 @@ void blk_execute_rq_nowait(struct request_queue *=
q, struct gendisk *bd_disk,
> =A0 =A0 =A0 =A0int where =3D at_head ? ELEVATOR_INSERT_FRONT : ELEVAT=
OR_INSERT_BACK;
>
> =A0 =A0 =A0 =A0WARN_ON(irqs_disabled());
> +
> + =A0 =A0 =A0 rq->rq_disk =3D bd_disk;
> + =A0 =A0 =A0 rq->end_io =3D done;
> +
> =A0 =A0 =A0 =A0spin_lock_irq(q->queue_lock);
>
> =A0 =A0 =A0 =A0if (unlikely(blk_queue_dead(q))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(q->queue_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rq->errors =3D -ENXIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rq->end_io)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rq->end_io(rq, rq->err=
ors);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(q->queue_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rq->rq_disk =3D bd_disk;
> - =A0 =A0 =A0 rq->end_io =3D done;
> =A0 =A0 =A0 =A0__elv_add_request(q, rq, where);
> =A0 =A0 =A0 =A0__blk_run_queue(q);
> =A0 =A0 =A0 =A0/* the queue is stopped so it won't be run */
> --
> 1.7.7
>
>
