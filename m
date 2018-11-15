From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2] SCSI: fix queue cleanup race before queue
 initialization is done
Date: Thu, 15 Nov 2018 08:48:39 +0800
Message-ID: <20181115004838.GB32603@ming.t460p>
References: <20181114082551.12141-1-ming.lei@redhat.com>
 <1542207748.192870.14.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1542207748.192870.14.camel@acm.org>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Andrew Jones <drjones@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, stable <stable@vger.kernel.org>, "jianchao . wang" <jianchao.w.wang@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 14, 2018 at 07:02:28AM -0800, Bart Van Assche wrote:
> On Wed, 2018-11-14 at 16:25 +0800, Ming Lei wrote:
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -697,6 +697,12 @@ static bool scsi_end_request(struct request *req,
> > blk_status_t error,
> >  		 */
> >  		scsi_mq_uninit_cmd(cmd);
> >  
> > +		/*
> > +		 * queue is still alive, so grab the ref for preventing it
> > +		 * from being cleaned up during running queue.
> > +		 */
> > +		percpu_ref_get(&q->q_usage_counter);
> > +
> 
> I think the above comment is misleading. In the block layer a queue is called
> alive if the "dying" flag has not been set. When the above call to
> percpu_ref_get() occurs it is not guaranteed that that flag has not yet been
> set. But it is guaranteed that q->q_usage_counter is not zero. I would prefer
> if the comment would be modified.

I am fine with either way given we know the context, not mention the first thing
blk_cleanup_queue() does is to call blk_set_queue_dying().

> 
> What's not clear to me is why this patch only protects the blk-mq path but
> not the legacy path. Does the legacy path need similar protection? It also
> triggers a queue run after having finished a request.

The queue_lock is held for protecting everything, so such issue in
legacy path.


Thanks,
Ming
