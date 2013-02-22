From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] block: Avoid invoking blk_run_queue() recursively
Date: Fri, 22 Feb 2013 20:01:29 +0100
Message-ID: <20130222190129.GD25064@kernel.dk>
References: <51274C2F.6070500@acm.org>
 <51274C76.8080007@acm.org>
 <20130222181416.GO3570@htj.dyndns.org>
 <5127BF8E.9080604@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35454 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab3BVTDM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2013 14:03:12 -0500
Content-Disposition: inline
In-Reply-To: <5127BF8E.9080604@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, James Bottomley <JBottomley@parallels.com>

On Fri, Feb 22 2013, Bart Van Assche wrote:
> On 02/22/13 19:14, Tejun Heo wrote:
> > Hello, Bart.
> > 
> > On Fri, Feb 22, 2013 at 11:46:14AM +0100, Bart Van Assche wrote:
> >> Some block drivers, e.g. dm and SCSI, need to trigger a queue
> >> run from inside functions that may be invoked by their request_fn()
> >> implementation. Make sure that invoking blk_run_queue() instead
> >> of blk_run_queue_async() from such functions does not trigger
> >> recursion. Making blk_run_queue() skip queue processing when
> >> invoked recursively is safe because the only two affected
> >> request_fn() implementations (dm and SCSI) guarantee that the
> >> request queue will be reexamined sooner or later before returning
> >> from their request_fn() implementation.
> >>
> >> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> >> Cc: Jens Axboe <axboe@kernel.dk>
> >> Cc: Tejun Heo <tj@kernel.org>
> >> Cc: James Bottomley <JBottomley@parallels.com>
> >> Cc: Alasdair G Kergon <agk@redhat.com>
> >> Cc: Mike Snitzer <snitzer@redhat.com>
> >> Cc: <stable@vger.kernel.org>
> >> ---
> >>   block/blk-core.c |   21 +++++++++++++--------
> >>   1 file changed, 13 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/block/blk-core.c b/block/blk-core.c
> >> index c973249..cf26e3a 100644
> >> --- a/block/blk-core.c
> >> +++ b/block/blk-core.c
> >> @@ -304,19 +304,24 @@ EXPORT_SYMBOL(blk_sync_queue);
> >>    *    This variant runs the queue whether or not the queue has been
> >>    *    stopped. Must be called with the queue lock held and interrupts
> >>    *    disabled. See also @blk_run_queue.
> >> + *
> >> + * Note:
> >> + *    Request handling functions are allowed to invoke __blk_run_queue() or
> >> + *    blk_run_queue() directly or indirectly. This will not result in a
> >> + *    recursive call of the request handler. However, such request handling
> >> + *    functions must, before they return, either reexamine the request queue
> >> + *    or invoke blk_delay_queue() to avoid that queue processing stops.
> >> + *
> >> + *    Some request handler implementations, e.g. scsi_request_fn() and
> >> + *    dm_request_fn(), unlock the queue lock internally. Returning immediately
> >> + *    if q->request_fn_active > 0 avoids that for the same queue multiple
> >> + *    threads execute the request handling function concurrently.
> >>    */
> >>   inline void __blk_run_queue_uncond(struct request_queue *q)
> >>   {
> >> -	if (unlikely(blk_queue_dead(q)))
> >> +	if (unlikely(blk_queue_dead(q) || q->request_fn_active))
> >>   		return;
> > 
> > Hmmm... I can't say I like this.  Silently ignoring explicit
> > blk_run_queue() call like this is likely to introduce nasty queue hang
> > bugs later on even if it's okay for the current users and there isn't
> > even debugging aid to detect what's going on.  If somebody invokes
> > blk_run_queue(), block layer better guarantee that the queue will be
> > run at least once afterwards no matter what, so please don't it this
> > way.
> 
> How about returning to an approach similar to the one introduced in commit
> a538cd03 (April 2009) ? This is how the last part of __blk_run_queue()
> looked like after that commit:
> 
>         /*
>          * Only recurse once to avoid overrunning the stack, let the unplug
>          * handling reinvoke the handler shortly if we already got there.
>          */
>         if (!queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
>                 q->request_fn(q);
>                 queue_flag_clear(QUEUE_FLAG_REENTER, q);
>         } else {
>                 queue_flag_set(QUEUE_FLAG_PLUGGED, q);
>                 kblockd_schedule_work(q, &q->unplug_work);
>         }

That'd be fine. I agree with Tejun that just returning is error prone
and could cause hard-to-debug hangs or stalls. So something ala

        if (blk_queue(dead))
                return;
        else if (q->request_fn_active) {
                blk_delay_queue(q, 0);
                return;
        }

would work. Alternatively, you could mark the queue as needing a re-run,
so any existing runner of it would notice and clear this flag and re-run
the queue. But that's somewhat more fragile, and since it isn't a
hot/performance path, I suspect the simple "just re-run me soon" is good
enough.

-- 
Jens Axboe

