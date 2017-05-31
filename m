From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2 3/8] blk-mq: use the introduced
 blk_mq_unquiesce_queue()
Date: Wed, 31 May 2017 10:29:50 +0800
Message-ID: <20170531022949.GB12220@ming.t460p>
References: <20170527142126.26079-1-ming.lei@redhat.com>
 <20170527142126.26079-4-ming.lei@redhat.com>
 <1496157160.2627.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496157160.2627.7.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 30, 2017 at 03:12:41PM +0000, Bart Van Assche wrote:
> On Sat, 2017-05-27 at 22:21 +0800, Ming Lei wrote:
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -3030,7 +3030,10 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
> >  		return -EINVAL;
> >  
> >  	if (q->mq_ops) {
> > -		blk_mq_start_stopped_hw_queues(q, false);
> > +		if (blk_queue_quiesced(q))
> > +			blk_mq_unquiesce_queue(q);
> > +		else
> > +			blk_mq_start_stopped_hw_queues(q, false);
> >  	} else {
> >  		spin_lock_irqsave(q->queue_lock, flags);
> >  		blk_start_queue(q);
> 
> Hello Ming,
> 
> Sorry but that change looks wrong to me. All what's needed here is a call
> to blk_mq_unquiesce_queue().

I think blk_mq_unquiesce_queue() should be called for case of queue
quiesced.

Thanks,
Ming
