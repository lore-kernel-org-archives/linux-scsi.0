From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 8/9] block: allow to allocate req with REQF_PREEMPT when
 queue is frozen
Date: Sat, 2 Sep 2017 00:56:42 +0800
Message-ID: <20170901165641.GC20709@ming.t460p>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <20170831172728.15817-9-ming.lei@redhat.com>
 <1504219824.31872.74.camel@wdc.com>
 <20170901035537.GI16525@ming.t460p>
 <1504280618.14386.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752093AbdIAQ45 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Sep 2017 12:56:57 -0400
Content-Disposition: inline
In-Reply-To: <1504280618.14386.16.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>

On Fri, Sep 01, 2017 at 03:43:39PM +0000, Bart Van Assche wrote:
> On Fri, 2017-09-01 at 11:55 +0800, Ming Lei wrote:
> > On Thu, Aug 31, 2017 at 10:50:25PM +0000, Bart Van Assche wrote:
> > > On Fri, 2017-09-01 at 01:27 +0800, Ming Lei wrote:
> > > > @@ -1413,9 +1414,17 @@ static struct request *blk_old_get_request(struct request_queue *q,
> > > >  	/* create ioc upfront */
> > > >  	create_io_context(gfp_mask, q->node);
> > > >  
> > > > -	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM));
> > > > +	/*
> > > > +	 * When queue is frozen, we still need to allocate req for
> > > > +	 * REQF_PREEMPT.
> > > > +	 */
> > > > +	if ((flags & BLK_MQ_REQ_PREEMPT) && blk_queue_is_frozen(q))
> > > > +		blk_queue_enter_live(q);
> > > > +	else
> > > > +		ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM));
> > > 
> > > Sorry but I doubt that calling blk_queue_enter_live() from inside
> > > blk_old_get_request() is safe. Calling blk_queue_enter_live() is only safe
> > > before a request queue has been marked dead. What prevents a kernel thread
> > > that holds a reference on a request queue and that is running concurrently
> > > with blk_cleanup_queue() to call blk_old_get_request() after a queue has
> > > been marked dead?
> > 
> > I have sent one delta patch in list, which will only call
> > blk_queue_enter_live() iff SCSI device is in QUIESCE.
> 
> That wouldn't make this hack less ugly.
> 
> It is possible to trigger the running -> quiesce state transition through
> /sys/class/scsi_device/*/device/state and the quiesce -> removed transition
> through /sys/class/scsi_device/*/device/delete. An example:
> 
> modprobe scsi_debug delay=0 dev_size_mb=16
> lsscsi | grep scsi_debug
> cd /sys/class/scsi_device/8:0:0:0/device
> echo quiesce > state
> echo 1 > delete
> 
> So the code from your patch 8/9 can race against device removal.
> 
> I think we need a better approach than the REQ_PREEMPT hack. How about
> implementing resume as a callback by adding an additional function pointer
> to struct request_queue / struct blk_mq_ops instead of implementing it as
> a request? For SCSI devices races of resume against removal can e.g. be
> handled by checking the scsi_device_set_state() return value. That function
> namely does not allow the removing/removed to running state transition.

If there is race between resume vs. removal, that is nothing to do
this patchset.

We definitely need to prevent new requests from being allocated after
SCSI device is put into quiesce. I don't see another better way
than freezing queue, because it is the only available way to 
prevent new req allocation.

Actually there is race between normal freezing and the preempt freezing
in this patchset, and it will be fixed in V2.


-- 
Ming
