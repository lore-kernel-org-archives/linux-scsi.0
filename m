From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V7 5/6] block: support PREEMPT_ONLY
Date: Tue, 3 Oct 2017 16:13:33 +0800
Message-ID: <20171003081333.GA23564@ming.t460p>
References: <20170930061214.10622-1-ming.lei@redhat.com>
 <20170930061214.10622-6-ming.lei@redhat.com>
 <1506961678.3368.29.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751102AbdJCINo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Oct 2017 04:13:44 -0400
Content-Disposition: inline
In-Reply-To: <1506961678.3368.29.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "martin@lichtvoll.de" <martin@lichtvoll.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "cavery@redhat.com" <cavery@redhat.com>

On Mon, Oct 02, 2017 at 04:27:59PM +0000, Bart Van Assche wrote:
> On Sat, 2017-09-30 at 14:12 +0800, Ming Lei wrote:
> > +void blk_set_preempt_only(struct request_queue *q, bool preempt_only)
> > +{
> > +	blk_mq_freeze_queue(q);
> > +	if (preempt_only)
> > +		queue_flag_set_unlocked(QUEUE_FLAG_PREEMPT_ONLY, q);
> > +	else
> > +		queue_flag_clear_unlocked(QUEUE_FLAG_PREEMPT_ONLY, q);
> > +	blk_mq_unfreeze_queue(q);
> > +}
> > +EXPORT_SYMBOL(blk_set_preempt_only);
> > +
> >  /**
> >   * __blk_run_queue_uncond - run a queue whether or not it has been stopped
> >   * @q:	The queue to run
> > @@ -771,9 +782,18 @@ int blk_queue_enter(struct request_queue *q, unsigned flags)
> >  	while (true) {
> >  		int ret;
> >  
> > +		/*
> > +		 * preempt_only flag has to be set after queue is frozen,
> > +		 * so it can be checked here lockless and safely
> > +		 */
> > +		if (blk_queue_preempt_only(q)) {
> > +			if (!(flags & BLK_REQ_PREEMPT))
> > +				goto slow_path;
> > +		}
> > +
> >  		if (percpu_ref_tryget_live(&q->q_usage_counter))
> >  			return 0;
> 
> Sorry but I don't think that it is possible with these changes to prevent
> that a non-preempt request gets allocated after a (SCSI) queue has been
> quiesced. If the CPU that calls blk_queue_enter() observes the set of the
> PREEMPT_ONLY flag after the queue has been unfrozen and after the SCSI
> device state has been changed into QUIESCED then blk_queue_enter() can
> succeed for a non-preempt request. I think this is exactly the scenario

OK, looks one issue, will address it in next version.


-- 
Ming
