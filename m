From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 5/9] block: introduce blk_drain_queue()
Date: Fri, 1 Sep 2017 11:52:38 +0800
Message-ID: <20170901035237.GG16525@ming.t460p>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <20170831172728.15817-6-ming.lei@redhat.com>
 <1504218887.31872.66.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1504218887.31872.66.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 31, 2017 at 10:34:49PM +0000, Bart Van Assche wrote:
> On Fri, 2017-09-01 at 01:27 +0800, Ming Lei wrote:
> > So that we can support legacy version of freezing queue,
> > which is required by safe SCSI quiescing.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  block/blk-core.c       | 16 ++++++++++++++++
> >  include/linux/blkdev.h |  1 +
> >  2 files changed, 17 insertions(+)
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index d579501f24ba..636452f151ea 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -530,6 +530,22 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
> >  }
> >  
> >  /**
> > + * blk_drain_queue - drain requests from request_queue
> > + * @q: queue to drain
> > + *
> > + * Drain requests from @q.  All pending requests are drained.
> > + * The caller is responsible for ensuring that no new requests
> > + * which need to be drained are queued.
> > + */
> > +void blk_drain_queue(struct request_queue *q)
> > +{
> > +	spin_lock_irq(q->queue_lock);
> > +	__blk_drain_queue(q, true);
> > +	spin_unlock_irq(q->queue_lock);
> > +}
> > +EXPORT_SYMBOL(blk_drain_queue);
> 
> Hello Ming,
> 
> Please drop this patch. As far as I can see this patch series introduces only
> one call to blk_drain_queue(), namely in blk_freeze_queue_wait() in patch 6.
> My proposal is to inline the body of blk_drain_queue() in blk_freeze_queue_wait()
> instead of reintroducing blk_drain_queue() (see also commit 807592a4fafb;
> "block: Let blk_drain_queue() caller obtain the queue lock").

Looks good, will do it in V2.

-- 
Ming
