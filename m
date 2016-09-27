From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 4/9] block: Move blk_freeze_queue() and
 blk_unfreeze_queue() code
Date: Tue, 27 Sep 2016 09:52:13 +0200
Message-ID: <20160927075213.rkpulkbrbndm2wwr@linux-x5ow.site>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
 <f990694e-76ea-f6b1-10a4-c23b9a738b39@sandisk.com>
 <ffad7b3c-e7f5-56d7-0a75-574e65ac5b31@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ffad7b3c-e7f5-56d7-0a75-574e65ac5b31-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 27, 2016 at 08:26:19AM +0200, Hannes Reinecke wrote:
> On 09/26/2016 08:27 PM, Bart Van Assche wrote:
> > Move the blk_freeze_queue() and blk_unfreeze_queue() implementations
> > from block/blk-mq.c to block/blk-core.c. Drop "_mq" from the name of
> > the functions that have been moved.
> > 
> > Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > ---
> >  block/blk-core.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
> >  block/blk-mq.c   | 41 +++--------------------------------------
> >  block/blk.h      |  3 +++
> >  3 files changed, 51 insertions(+), 38 deletions(-)
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index b75d688..8cc8006 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -682,6 +682,51 @@ static void blk_queue_usage_counter_release(struct percpu_ref *ref)
> >  	wake_up_all(&q->mq_freeze_wq);
> >  }
> >  
> > +void blk_freeze_queue_start(struct request_queue *q)
> > +{
> > +	int freeze_depth;
> > +
> > +	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
> > +	if (freeze_depth == 1) {
> > +		percpu_ref_kill(&q->q_usage_counter);
> > +		blk_mq_run_hw_queues(q, false);
> > +	}
> > +}
> > +
> As you dropped the 'mq_' prefix, maybe you should rename the counter to
> 'freeze_depth', to?

See PATCH 6/9

-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
