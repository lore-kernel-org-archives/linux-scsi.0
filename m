From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 7/8] block: allow to allocate req with REQF_PREEMPT
 when queue is preempt frozen
Date: Tue, 5 Sep 2017 00:28:25 +0800
Message-ID: <20170904162824.GC21757@ming.t460p>
References: <20170902130840.24609-1-ming.lei@redhat.com>
 <20170902130840.24609-8-ming.lei@redhat.com>
 <20170902131208.GA10940@ming.t460p>
 <1504498405.10804.10.camel@wdc.com>
 <20170904071653.GD7959@ming.t460p>
 <1504539634.3189.15.camel@wdc.com>
 <20170904160813.GA21757@ming.t460p>
 <1504541911.3189.18.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50748 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753847AbdIDQ2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Sep 2017 12:28:45 -0400
Content-Disposition: inline
In-Reply-To: <1504541911.3189.18.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>

On Mon, Sep 04, 2017 at 04:18:32PM +0000, Bart Van Assche wrote:
> On Tue, 2017-09-05 at 00:08 +0800, Ming Lei wrote:
> > On Mon, Sep 04, 2017 at 03:40:35PM +0000, Bart Van Assche wrote:
> > > On Mon, 2017-09-04 at 15:16 +0800, Ming Lei wrote:
> > > > On Mon, Sep 04, 2017 at 04:13:26AM +0000, Bart Van Assche wrote:
> > > > > Allowing blk_get_request() to succeed after the DYING flag has been set is
> > > > > completely wrong because that could result in a request being queued after
> > > > > the DEAD flag has been set, resulting in either a hanging request or a kernel
> > > > > crash. This is why it's completely wrong to add a blk_queue_enter_live() call
> > > > > in blk_old_get_request() or blk_mq_alloc_request(). Hence my NAK for any
> > > > > patch that adds a blk_queue_enter_live() call to any function called from
> > > > > blk_get_request(). That includes the patch at the start of this e-mail thread.
> > > > 
> > > > See above, this patch changes nothing about this fact, please look at
> > > > the patch carefully next time just before posting your long comment.
> > > 
> > > Are you really sure that your patch does not allow blk_get_request() to
> > > succeed after the DYING flag has been set? blk_mq_alloc_request() calls both
> > > blk_queue_is_preempt_frozen() and blk_queue_enter_live() without holding
> > > any lock. A thread that is running concurrently with blk_mq_get_request()
> > > can unfreeze the queue after blk_queue_is_preempt_frozen() returned and
> > > before blk_queue_enter_live() is called. This means that with your patch
> > > series applied blk_get_request() can succeed after the DYING flag has been
> > > set, which is something we don't want. Additionally, I don't think we want
> > > to introduce any kind of locking in blk_mq_get_request() because that would
> > > be a serialization point.
> >
> > Yeah, I am pretty sure.
> > 
> > Firstly blk_queue_freeze_preempt() is exclusive, that means it will wait
> > for completion of all pending freezing(both normal and preempt), and other
> > freezing can't be started too if there is in-progress preempt
> > freezing, actually it is a typical read/write lock use case, but
> > we need to support nested normal freezing, so we can't use rwsem. 
> 
> You seem to overlook that blk_get_request() can be called from another thread
> than the thread that is performing the freezing and unfreezing.

The freezing state of queue can be observed in all context, so this
issue isn't related with context, please see blk_queue_is_preempt_frozen()
which is called from blk_get_request():

        if (!percpu_ref_is_dying(&q->q_usage_counter))
                return false;

        spin_lock(&q->freeze_lock);
        preempt_frozen = q->preempt_freezing;
        preempt_unfreezing = q->preempt_unfreezing;
        spin_unlock(&q->freeze_lock);

        return preempt_frozen && !preempt_unfreezing;


If the queue is in preempt freezing, blk_queue_enter_live() is called
before allocating request, otherwise blk_queue_enter() is called.

BTW, we can add the check of queue dying in this helper as one
improvement.

-- 
Ming
