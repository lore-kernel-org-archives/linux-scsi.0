From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 7/8] block: allow to allocate req with REQF_PREEMPT
 when queue is preempt frozen
Date: Tue, 5 Sep 2017 00:08:19 +0800
Message-ID: <20170904160813.GA21757@ming.t460p>
References: <20170902130840.24609-1-ming.lei@redhat.com>
 <20170902130840.24609-8-ming.lei@redhat.com>
 <20170902131208.GA10940@ming.t460p>
 <1504498405.10804.10.camel@wdc.com>
 <20170904071653.GD7959@ming.t460p>
 <1504539634.3189.15.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753764AbdIDQIi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Sep 2017 12:08:38 -0400
Content-Disposition: inline
In-Reply-To: <1504539634.3189.15.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "tj@kernel.org" <tj@kernel.org>

On Mon, Sep 04, 2017 at 03:40:35PM +0000, Bart Van Assche wrote:
> On Mon, 2017-09-04 at 15:16 +0800, Ming Lei wrote:
> > On Mon, Sep 04, 2017 at 04:13:26AM +0000, Bart Van Assche wrote:
> > > Allowing blk_get_request() to succeed after the DYING flag has been set is
> > > completely wrong because that could result in a request being queued after
> > > the DEAD flag has been set, resulting in either a hanging request or a kernel
> > > crash. This is why it's completely wrong to add a blk_queue_enter_live() call
> > > in blk_old_get_request() or blk_mq_alloc_request(). Hence my NAK for any
> > > patch that adds a blk_queue_enter_live() call to any function called from
> > > blk_get_request(). That includes the patch at the start of this e-mail thread.
> >
> > See above, this patch changes nothing about this fact, please look at
> > the patch carefully next time just before posting your long comment.
> 
> Are you really sure that your patch does not allow blk_get_request() to
> succeed after the DYING flag has been set? blk_mq_alloc_request() calls both

Yeah, I am pretty sure.

Firstly blk_queue_freeze_preempt() is exclusive, that means it will wait
for completion of all pending freezing(both normal and preempt), and other
freezing can't be started too if there is in-progress preempt
freezing, actually it is a typical read/write lock use case, but
we need to support nested normal freezing, so we can't use rwsem.

Also DYNING flag is checked first before starting preempt freezing, the
API will return and preempt_freezing flag isn't set if DYNING is set.

Secondly after preempt freezing is started:

	- for block legacy path, dying is always tested in the entry of
	__get_request(), so no new request is allocated after queue is dying.

	- for blk-mq, it is normal for the DYNING flag to be set just
	between blk_queue_enter() and allocating the request, because
	we depend on lld to handle the case. Even we can enhance the point
	by checking dying flag in blk_queue_enter(), but that is just
	a improvement, not mean V3 isn't correct. 

> blk_queue_is_preempt_frozen() and blk_queue_enter_live() without holding
> any lock. A thread that is running concurrently with blk_mq_get_request()
> can unfreeze the queue after blk_queue_is_preempt_frozen() returned and
> before blk_queue_enter_live() is called. This means that with your patch

preempt freezing is exclusive, so no other freezing can be started at all,
then no such issue you worried about.

> series applied blk_get_request() can succeed after the DYING flag has been
> set, which is something we don't want. Additionally, I don't think we want
> to introduce any kind of locking in blk_mq_get_request() because that would
> be a serialization point.

That needn't to be worried about, as you saw, we can check
percpu_ref_is_dying() first, then acquire the lock to check
flag if queue is freezing.

> 
> Have you considered to use the blk-mq "reserved request" mechanism to avoid
> starvation of power management requests instead of making the block layer
> even more complicated than it already is?

reserved request is really a bad idea, that means the reserved request
can't be used for normal I/O, we all know the request/tag space is
precious, and some device has a quite small tag space, such as sata.
This way will affect performance definitely.

Also I don't think the approach is complicated, and actually the idea
is simple, and the implementation isn't complicated too.

> 
> Note: extending blk_mq_freeze/unfreeze_queue() to the legacy block layer
> could be useful to make scsi_wait_for_queuecommand() more elegant. However,
> I don't think we should spend our time on legacy block layer / SCSI core
> changes. The code I'm referring to is the following:

That can be side-product of this approach, but this patchset is just
focus on fixing I/O hang.

-- 
Ming
