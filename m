From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 6/8] block: introduce preempt version of
 blk_[freeze|unfreeze]_queue
Date: Tue, 5 Sep 2017 00:20:24 +0800
Message-ID: <20170904162023.GB21757@ming.t460p>
References: <20170902130840.24609-1-ming.lei@redhat.com>
 <20170902130840.24609-7-ming.lei@redhat.com>
 <1504538467.3189.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1504538467.3189.2.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 04, 2017 at 03:21:08PM +0000, Bart Van Assche wrote:
> On Sat, 2017-09-02 at 21:08 +0800, Ming Lei wrote:
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -565,6 +565,10 @@ struct request_queue {
> >  
> >  	int			bypass_depth;
> >  	atomic_t		mq_freeze_depth;
> > +	spinlock_t		freeze_lock;
> > +	unsigned		normal_freezing:1;
> > +	unsigned		preempt_freezing:1;
> > +	unsigned		preempt_unfreezing:1;
> >  
> >  #if defined(CONFIG_BLK_DEV_BSG)
> >  	bsg_job_fn		*bsg_job_fn;
> 
> Requests queues already have to many states and you want to make request queues
> even more complicated by introducing several new state variables? Yikes!

The three flags are used in freeze/unfreeze path only, and I don't think
they are too complicated to maintain. Actually each state are simply
enough:

	- normal_freezing means the queue is in normal freezing, it is set
	before blk_queue_freeze() returns. In this state, no any request
	can be allocated from the queue, just like current blk queue
	freezing.

	- preempt_freezing means the queue is in preempt freezing, the flag
	is set before blk_queue_freeze_preempt() returns successfully. In
	this state, only RQF_PREEMPT is allowed to be allocated.

	- preempt_unfreezing means the queue is in preempt unfreezing, just
	set in the entry of blk_queue_unfreeze_preempt(). In this state,
	no any request can be allocated from the queue.

-- 
Ming
