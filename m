From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 09:07:04 +0800
Message-ID: <20180130010701.GC17176@ming.t460p>
References: <20180123161613.14214-1-ming.lei@redhat.com>
 <1516724659.3339.7.camel@sandisk.com>
 <20180123163717.GE13277@ming.t460p>
 <1516726653.3339.20.camel@wdc.com>
 <20180124033109.GA15945@ming.t460p>
 <20180127190920.GA24759@redhat.com>
 <1517091161.3055.7.camel@wdc.com>
 <20180127234151.GA21710@ming.t460p>
 <1517244510.2687.10.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517244510.2687.10.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 29, 2018 at 04:48:31PM +0000, Bart Van Assche wrote:
> On Sun, 2018-01-28 at 07:41 +0800, Ming Lei wrote:
> > Not mention, the request isn't added to dispatch list yet in .queue_rq(),
> > strictly speaking, it is not correct to call blk_mq_delay_run_hw_queue() in
> > .queue_rq(), so the current block layer API can't handle it well enough.
> 
> I disagree that it is not correct to call blk_mq_delay_run_hw_queue() from
> inside .queue_rq(). Additionally, I have already explained to you in
> previous e-mails why it's fine to call that function from inside .queue_rq():
> - Nobody has ever observed the race you described because the time after

'Nobody observed it' does not mean there isn't the race, since I can explain
it clearly.

>   which a queue is rerun by blk_mq_delay_run_hw_queue() is much larger than
>   the time during which that race exists.

Again it is fragile to depend on the delay(10ms, 3ms, or what ever) to make
everything correct, why can't we make the way robust like the approach I took?

You can not guarantee that the request handled in .queue_rq() is added to
hctx->dispatch when you call blk_mq_delay_run_hw_queue(), because the
operation of adding request to hctx->dispatch happens after returning
from .queue_rq() to blk_mq_dispatch_rq_list(), which is done in the future
against calling blk_mq_delay_run_hw_queue(). Right? 

Especially now kblockd_mod_delayed_work_on() is changed to use mod_delayed_work_on(),
which may run the queue before the timer is expired from another context, then
IO hang still can be triggered since the run queue may miss the request
to be added to hctx->dispatch.

> - It is easy to fix this race inside the block layer, namely by using
>   call_rcu() inside the blk_mq_delay_run_hw_queue() implementation to
>   postpone the queue rerunning until after the request has been added back to
>   the dispatch list.

It is just easy to say, can you cook a patch and fix all drivers first?

Then let's compare which patch is simpler and better.

> 
> > > - The patch at the start of this thread introduces a regression in the
> > >   SCSI core, namely a queue stall if a request completion occurs concurrently
> > >   with the newly added BLK_MQ_S_SCHED_RESTART test in the blk-mq core.

> > 
> > This patch only moves the blk_mq_delay_run_hw_queue() from scsi_queue_rq()
> > to blk-mq, again, please explain it in detail how this patch V3 introduces this
> > regression on SCSI.
> 
> Please reread the following message: https://marc.info/?l=dm-devel&m=151672480107560.

OK, the following message is copied from the above link:

> My opinion about this patch is as follows:
> * Changing a blk_mq_delay_run_hw_queue() call followed by return
>   BLK_STS_DEV_RESOURCE into return BLK_STS_RESOURCE is wrong because it changes
>   a guaranteed queue rerun into a queue rerun that may or may not happen
>   depending on whether or not multiple queue runs happen simultaneously.
> * This change makes block drivers less readable because anyone who encounters
>   BLK_STS_DEV_RESOURCE will have to look up its definition to figure out what
>   it's meaning is.
> * We don't need the new status code BLK_STS_DEV_RESOURCE because a delayed
>   queue run can be implemented easily with the existing block layer API.

Later, you admitted you understood the patch wrong, so follows your
reply again from https://marc.info/?l=dm-devel&m=151672694508389&w=2

> On Wed, 2018-01-24 at 00:37 +0800, Ming Lei wrote:
> > On Tue, Jan 23, 2018 at 04:24:20PM +0000, Bart Van Assche wrote:
> > > My opinion about this patch is as follows:
> > > * Changing a blk_mq_delay_run_hw_queue() call followed by return
> > >   BLK_STS_DEV_RESOURCE into return BLK_STS_RESOURCE is wrong because it changes
> > >   a guaranteed queue rerun into a queue rerun that may or may not happen
> > >   depending on whether or not multiple queue runs happen simultaneously.
> > 
> > You may not understand the two:
> > 
> > 1) it is always safe to return BLK_STS_RESOURCE, which will make sure to
> > avoid IO hang by blk_mq_delay_run_hw_queue() or blk_mq_run_hw_queue(),
> > and using which one depends on SCHED_RESTART.
> > 
> > 2) if driver can make sure the queue will be rerun after some resource
> > is available, either by itself or by blk-mq, it will return BLK_STS_DEV_RESOURCE
> > 
> > So what is wrong with this way?
> 
> Sorry, I swapped BLK_STS_DEV_RESOURCE and BLK_STS_RESOURCE accidentally in my
> reply. What I meant is that changing a blk_mq_delay_run_hw_queue() call followed
> by return BLK_STS_RESOURCE into BLK_STS_DEV_RESOURCE is wrong and introduces a
> race condition in code where there was no race condition.

You still doesn't explain the race condition here, right?

I can explain it again, but I am losing patience on you if you continue
to refuse answer my question, just like you refused to provide debugfs
log before when you reported issue.

When turning BLK_STS_RESOURCE into BLK_STS_DEV_RESOURCE, it is driver's
responsibility to make sure that the queue will be run after resource is available.
That point is documented clearly.

Especially on scsi_queue_rq():

-       if (atomic_read(&sdev->device_busy) == 0 &&
-           !scsi_device_blocked(sdev))
-           blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
+       if (atomic_read(&sdev->device_busy) ||
+           scsi_device_blocked(sdev))
+           ret = BLK_STS_DEV_RESOURCE;

When either of two conditions become true, scsi knows that the queue will
be restarted in future, and this patch just moves the
blk_mq_delay_run_hw_queue() out of .queue_rq() into blk_mq_dispatch_rq_list()
for avoiding the race mentioned above.

I know there is race in scsi_queue_rq(), such as all in-flight request may be
completed after atomic_read(&sdev->device_busy) in the following code is checked,
but this race exists before and after my patch V3, and my patch V3 changes nothing
about this race, so I don't know how/why you concluded that race conditions is
introduced by my patch V3.

-       if (atomic_read(&sdev->device_busy) == 0 &&
-           !scsi_device_blocked(sdev))
-           blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);

-- 
Ming
