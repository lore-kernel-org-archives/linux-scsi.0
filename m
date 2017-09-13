From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V4 08/10] block: allow to allocate req with RQF_PREEMPT
 when queue is preempt frozen
Date: Thu, 14 Sep 2017 00:48:09 +0800
Message-ID: <20170913164803.GB10407@ming.t460p>
References: <20170911111021.25810-1-ming.lei@redhat.com>
 <20170911111021.25810-9-ming.lei@redhat.com>
 <1505145834.2802.17.camel@wdc.com>
 <20170912034057.GC31533@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170912034057.GC31533@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "cavery@redhat.com" <cavery@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 12, 2017 at 11:40:57AM +0800, Ming Lei wrote:
> On Mon, Sep 11, 2017 at 04:03:55PM +0000, Bart Van Assche wrote:
> > On Mon, 2017-09-11 at 19:10 +0800, Ming Lei wrote:
> > > @@ -787,6 +787,35 @@ int blk_queue_enter(struct request_queue *q, unsigned flags)
> > >  		if (percpu_ref_tryget_live(&q->q_usage_counter))
> > >  			return 0;
> > >  
> > > +		/*
> > > +		 * If queue is preempt frozen and caller need to allocate
> > > +		 * request for RQF_PREEMPT, we grab the .q_usage_counter
> > > +		 * unconditionally and return successfully.
> > > +		 *
> > > +		 * There isn't race with queue cleanup because:
> > > +		 *
> > > +		 * 1) it is guaranteed that preempt freeze can't be
> > > +		 * started after queue is set as dying
> > > +		 *
> > > +		 * 2) normal freeze runs exclusively with preempt
> > > +		 * freeze, so even after queue is set as dying
> > > +		 * afterwards, blk_queue_cleanup() won't move on
> > > +		 * until preempt freeze is done
> > > +		 *
> > > +		 * 3) blk_queue_dying() needn't to be checked here
> > > +		 * 	- for legacy path, it will be checked in
> > > +		 * 	__get_request()
> > 
> > For the legacy block layer core, what do you think will happen if the
> > "dying" state is set by another thread after __get_request() has passed the
> > blk_queue_dying() check?
> 
> Without this patchset, block core still need to handle the above
> situation, so your question isn't related with this patchset.
> 
> Also q->queue_lock is required in both setting dying and checking
> dying in__get_request(). But the lock can be released in
> __get_request(), so it is possible to allocate one request after
> queue is set as dying, and the request can be dispatched to a
> dying queue too for legacy.
> 
> > 
> > > +		 * 	- blk-mq depends on driver to handle dying well
> > > +		 * 	because it is normal for queue to be set as dying
> > > +		 * 	just between blk_queue_enter() and allocating new
> > > +		 * 	request.
> > 
> > The above comment is not correct. The block layer core handles the "dying"
> > state. Block drivers other than dm-mpath should not have to query this state
> > directly.
> 
> If blk-mq doesn't query dying state, how does it know queue is dying
> and handle the state? Also blk-mq isn't different with legacy wrt.
> depending on driver to handle dying.
> 
> > 
> > > +		 */
> > > +		if ((flags & BLK_REQ_PREEMPT) &&
> > > +				blk_queue_is_preempt_frozen(q)) {
> > > +			blk_queue_enter_live(q);
> > > +			return 0;
> > > +		}
> > > +
> > 
> > Sorry but to me it looks like the above code introduces a race condition
> > between blk_queue_cleanup() and blk_get_request() for at least blk-mq.
> > Consider e.g. the following scenario:
> > * A first thread preempt-freezes a request queue.
> > * A second thread calls blk_get_request() with BLK_REQ_PREEMPT set. That
> >   results in a call of blk_queue_is_preempt_frozen().
> > * A context switch occurs to the first thread.
> > * The first thread preempt-unfreezes the same request queue and calls
> >   blk_queue_cleanup(). That last function changes the request queue state
> >   into DYING and waits until all pending requests have finished.
> > * The second thread continues and calls blk_queue_enter_live(), allocates
> >   a request and submits it.
> 
> OK, looks a race I don't think of, but it can be fixed easily by calling
> blk_queue_enter_live() with holding q->freeze_lock, and it won't
> cause performance issue too since it is in slow path.
> 
> For example, we can introduce the following code in blk_queue_enter():
> 
> 		if ((flags & BLK_REQ_PREEMPT) &&
> 				blk_queue_enter_preempt_freeze(q))
> 			return 0;
> 
> static inline bool blk_queue_enter_preempt_freeze(struct request_queue *q)
> {
> 	bool preempt_frozen;
> 
> 	spin_lock(&q->freeze_lock);
> 	preempt_frozen = q->preempt_freezing && !q->preempt_unfreezing;
> 	if (preempt_froze)
> 		blk_queue_enter_live(q);
> 	spin_unlock(&q->freeze_lock);
> 
> 	return preempt_frozen;
> }
> 
> > 
> > In other words, a request gets submitted against a dying queue. This must
> > not happen. See also my explanation of queue shutdown from a few days ago
> 
> That is not correct, think about why queue dead is checked in
> __blk_run_queue_uncond() instead of queue dying. We still need to
> submit requests to driver when queue is dying, and driver knows
> how to handle that.
> 
> > (https://marc.info/?l=linux-block&m=150449845831789).
> 
> > from (https://marc.info/?l=linux-block&m=150449845831789).
> >> Do you understand how request queue cleanup works? The algorithm used for
> >> request queue cleanup is as follows:
> >> * Set the DYING flag. This flag makes all later blk_get_request() calls
> >>   fail.
> 
> Your description isn't true for both legacy and blk-mq:
> 
> For legacy, as you see q->queue_lock can be released in
> __get_request(), at that time, the queue can be setting as dying.
> but the request can be allocated successfully, and be submitted
> to driver. This way has been there for long time.
> 
> For blk-mq, follows the way for allocating blk-mq request:
> 
>         ret = blk_queue_enter(q, ...);
>         if (ret)
>                 return ERR_PTR(ret);
>         rq = blk_mq_get_request(q, ...);
> 
> The setting queue dying can just happen between blk_queue_enter()
> and blk_mq_get_request(), so it is usual to see requests sent
> to driver after queue is dying.
> 
> We shouldn't worry about that, because either cleanup queue or setting
> dying is triggered by driver, and driver knows that queue is dying
> at that time, and they can handle the request well under this
> situation.
> 
> >> * Wait until all pending requests have finished.
> >> * Set the DEAD flag. For the traditional block layer, this flag causes
> >>   blk_run_queue() not to call .request_fn() anymore. For blk-mq it is
> >>   guaranteed in another way that .queue_rq() won't be called anymore after
> >>   this flag has been set.
> 
> That is true, but still not related with this patch.

Hi Bart,

Could you please let me know if your concern about race between
preempt freeze and blk_cleanup_queue() is addressed in my last
reply?


-- 
Ming
