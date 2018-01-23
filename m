From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Wed, 24 Jan 2018 00:37:18 +0800
Message-ID: <20180123163717.GE13277@ming.t460p>
References: <20180123161613.14214-1-ming.lei@redhat.com>
 <1516724659.3339.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516724659.3339.7.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 23, 2018 at 04:24:20PM +0000, Bart Van Assche wrote:
> On Wed, 2018-01-24 at 00:16 +0800, Ming Lei wrote:
> > @@ -1280,10 +1282,18 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
> >  		 * - Some but not all block drivers stop a queue before
> >  		 *   returning BLK_STS_RESOURCE. Two exceptions are scsi-mq
> >  		 *   and dm-rq.
> > +		 *
> > +		 * If drivers return BLK_STS_RESOURCE and S_SCHED_RESTART
> > +		 * bit is set, run queue after 10ms for avoiding IO hang
> > +		 * because the queue may be idle and the RESTART mechanism
> > +		 * can't work any more.
> >  		 */
> > -		if (!blk_mq_sched_needs_restart(hctx) ||
> > +		needs_restart = blk_mq_sched_needs_restart(hctx);
> > +		if (!needs_restart ||
> >  		    (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
> >  			blk_mq_run_hw_queue(hctx, true);
> > +		else if (needs_restart && (ret == BLK_STS_RESOURCE))
> > +			blk_mq_delay_run_hw_queue(hctx, 10);
> >  	}
> 
> My opinion about this patch is as follows:
> * Changing a blk_mq_delay_run_hw_queue() call followed by return
>   BLK_STS_DEV_RESOURCE into return BLK_STS_RESOURCE is wrong because it changes
>   a guaranteed queue rerun into a queue rerun that may or may not happen
>   depending on whether or not multiple queue runs happen simultaneously.

You may not understand the two:

1) it is always safe to return BLK_STS_RESOURCE, which will make sure to
avoid IO hang by blk_mq_delay_run_hw_queue() or blk_mq_run_hw_queue(),
and using which one depends on SCHED_RESTART.

2) if driver can make sure the queue will be rerun after some resource
is available, either by itself or by blk-mq, it will return BLK_STS_DEV_RESOURCE

So what is wrong with this way?

> * This change makes block drivers less readable because anyone who encounters
>   BLK_STS_DEV_RESOURCE will have to look up its definition to figure out what
>   it's meaning is.

It has been well-documented. BLK_STS_DEV_RESOURCE can be used very less,
so it shouldn't be an issue.

> * We don't need the new status code BLK_STS_DEV_RESOURCE because a delayed
>   queue run can be implemented easily with the existing block layer API.

You mean to convert every STS_RESOURCE to call the API there, that way
need lots of change, and with race in theory, since when the delay run
queue is called in driver, the request isn't added to dispatch list.

-- 
Ming
