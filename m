From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 05/14] blk-mq-sched: don't dequeue request until all in
 ->dispatch are flushed
Date: Wed, 2 Aug 2017 11:01:34 +0800
Message-ID: <20170802030128.GA7267@ming.t460p>
References: <20170731165111.11536-1-ming.lei@redhat.com>
 <20170731165111.11536-7-ming.lei@redhat.com>
 <1501544540.2466.31.camel@wdc.com>
 <20170801104433.GC31452@ming.t460p>
 <1501604045.2475.8.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501604045.2475.8.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 01, 2017 at 04:14:07PM +0000, Bart Van Assche wrote:
> On Tue, 2017-08-01 at 18:44 +0800, Ming Lei wrote:
> > On Mon, Jul 31, 2017 at 11:42:21PM +0000, Bart Van Assche wrote:
> > > Since setting, clearing and testing of BLK_MQ_S_BUSY can happen concurrently
> > > and since clearing and testing happens without any locks held I'm afraid this
> > > patch introduces the following race conditions:
> > > [ ... ]
> > > * Checking BLK_MQ_S_BUSY after requests have been removed from the dispatch list
> > >   but before that bit is cleared, resulting in test_bit(BLK_MQ_S_BUSY, &hctx->state)
> > >   reporting that the BLK_MQ_S_BUSY
> > > has been set although there are no requests
> > >   on the dispatch list.
> > 
> > That won't be a problem, because dispatch will be started in the
> > context in which dispatch list is flushed, since the BUSY bit
> > is cleared after blk_mq_dispatch_rq_list() returns. So no I/O
> > hang.
> 
> Hello Ming,
> 
> Please consider changing the name of the BLK_MQ_S_BUSY constant. That bit
> is used to serialize dispatching requests from the hctx dispatch list but
> that's not clear from the name of that constant.

Actually what we want to do is to stop taking request from sw/scheduler
queue when ->dispatch aren't flushed completely, I think BUSY isn't
a bad name for this case, or how about DISPATCH_BUSY? or
FLUSHING_DISPATCH?

After thinking about the handling further, we can set the
BUSY bit just when adding requests to ->dispatch, and clear the
bit after returning from blk_mq_dispatch_rq_list() when the
current local list(from ->dispatch) is flushed completely and
->dispatch is empty. This way can minimize the race window, and
still safe, because we always move on to dispatch either new
request is added to ->dispatch or ->dispatch is flushed completely.

But anyway comment should be added for clarifying the fact.

-- 
Ming
