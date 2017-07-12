From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 2/6] SCSI: use blk_mq_run_hw_queues() in scsi_kick_queue()
Date: Wed, 12 Jul 2017 11:15:04 +0800
Message-ID: <20170712031503.GG13036@ming.t460p>
References: <20170711182103.11461-1-ming.lei@redhat.com>
 <20170711182103.11461-3-ming.lei@redhat.com>
 <1499803071.2586.29.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499803071.2586.29.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "sagi@grimberg.me" <sagi@grimberg.me>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 11, 2017 at 07:57:53PM +0000, Bart Van Assche wrote:
> On Wed, 2017-07-12 at 02:20 +0800, Ming Lei wrote:
> > Now SCSI won't stop queue, and not necessary to use
> > blk_mq_start_hw_queues(), so switch to blk_mq_run_hw_queues()
> > instead.
> > 
> > Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > Cc: linux-scsi@vger.kernel.org
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/scsi/scsi_lib.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index f6097b89d5d3..91d890356b78 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -333,7 +333,7 @@ void scsi_device_unbusy(struct scsi_device *sdev)
> >  static void scsi_kick_queue(struct request_queue *q)
> >  {
> >  	if (q->mq_ops)
> > -		blk_mq_start_hw_queues(q);
> > +		blk_mq_run_hw_queues(q, false);
> >  	else
> >  		blk_run_queue(q);
> >  }
> 
> Hello Ming,
> 
> Now that we have separate flags to represent the "stopped" and "quiesced"
> states, wouldn't it be better not to modify scsi_kick_queue() but instead to
> stop a SCSI hardware queue again if scsi_queue_rq() returns BLK_STS_RESOURCE?
> See also commits 36e3cf273977 ("scsi: Avoid that SCSI queues get stuck") and
> commit 52d7f1b5c2f3 ("blk-mq: Avoid that requeueing starts stopped queues").

As you can see in the following patches, all stop/start queue APIs will
be removed, and the 'stopped' state will become a internal state.

It doesn't make sense to clear 'stopped' for scsi anymore, since the
queue won't be stopped actually. So we need this change.

-- 
Ming
