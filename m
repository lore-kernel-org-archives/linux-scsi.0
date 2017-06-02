From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v3 3/9] blk-mq: use the introduced
 blk_mq_unquiesce_queue()
Date: Fri, 2 Jun 2017 10:00:42 +0800
Message-ID: <20170602020041.GE30505@ming.t460p>
References: <20170531123706.20885-1-ming.lei@redhat.com>
 <20170531123706.20885-4-ming.lei@redhat.com>
 <1496244100.2608.3.camel@sandisk.com>
 <20170601005423.GA23563@ming.t460p>
 <1496358538.3075.12.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496358538.3075.12.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "axboe@fb.com" <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 01, 2017 at 11:09:00PM +0000, Bart Van Assche wrote:
> On Thu, 2017-06-01 at 08:54 +0800, Ming Lei wrote:
> > On Wed, May 31, 2017 at 03:21:41PM +0000, Bart Van Assche wrote:
> > > On Wed, 2017-05-31 at 20:37 +0800, Ming Lei wrote:
> > > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > > index 99e16ac479e3..ffcf05765e2b 100644
> > > > --- a/drivers/scsi/scsi_lib.c
> > > > +++ b/drivers/scsi/scsi_lib.c
> > > > @@ -3031,7 +3031,10 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
> > > >  		return -EINVAL;
> > > >  
> > > >  	if (q->mq_ops) {
> > > > -		blk_mq_start_stopped_hw_queues(q, false);
> > > > +		if (blk_queue_quiesced(q))
> > > > +			blk_mq_unquiesce_queue(q);
> > > > +		else
> > > > +			blk_mq_start_stopped_hw_queues(q, false);
> > > >  	} else {
> > > >  		spin_lock_irqsave(q->queue_lock, flags);
> > > >  		blk_start_queue(q);
> > > 
> > > As I commented on v2, this change is really wrong. All what's needed here is
> > > a call to blk_mq_unquiesce_queue() and nothing else. Adding a call to
> > > blk_mq_start_stopped_hw_queues() is wrong because it makes it impossible to
> > > use the STOPPED flag in the SCSI core to make the block layer core stop calling
> > > .queue_rq() if a SCSI LLD returns "busy".
> > 
> > I am not sure if I understand your idea, could you explain a bit why it is wrong?
> > 
> > Let's see the function of scsi_internal_device_block():
> > 
> > 	if (q->mq_ops) {
> >                 if (wait)
> >                         blk_mq_quiesce_queue(q);
> >                 else
> >                         blk_mq_stop_hw_queues(q);
> > 	}
> > 
> > So the queue may be put into quiesced if 'wait' is true, or it is
> > stopped if 'wait' is false.
> > 
> > And this patch just makes the two SCSI APIs symmetrical.
> > 
> > Since we will not stop queue in blk_mq_quiesce_queue() later,
> > I have to unquiese one queue only if it is quiesced.
> > 
> > So suppose the queue is put into stopped in scsi_internal_device_block(),
> > do we expect not to restart it in scsi_internal_device_unblock() via
> > blk_mq_unquiesce_queue()?
> 
> Hello Ming,
> 
> My opinion is that scsi_internal_device_block() and scsi_internal_device_unblock()
> should be changed as follows for the scsi-mq code path:
> * scsi_internal_device_block() should call blk_mq_quiesce_queue(q) if the "wait"
>   argument is true and should set the QUEUE_FLAG_QUIESCED flag if the "wait"
>   argument is false.
> * scsi_internal_device_unblock() should call blk_mq_unquiesce_queue().
> 
> I am aware it sounds weird to set the QUEUE_FLAG_QUIESCED flag without waiting
> until ongoing .queue_rq() calls have finished. The only driver that triggers

This way may break the contract of blk_mq_quiesce_queue() and is really weird.
And the above change shouldn't be related with this patchset, so better
to do whatever you want once this patch is merged.

This patchset won't break current SCSI uses of blk_mq_quiesce_queue() and
won't cause regression, and I setup one iSCSI target yesterday and it works
just fine, how about just keeping this patch as it is?

Once it is merged, you can figure out one perfect solution, but
the contract of blk_mq_quiesce_queue() still shouldn't be broken.

Thanks,
Ming
