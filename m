From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 2/5] blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
Date: Mon, 5 Feb 2018 18:35:03 +0800
Message-ID: <20180205103502.GC32558@ming.t460p>
References: <20180203042112.15239-1-ming.lei@redhat.com>
 <20180203042112.15239-3-ming.lei@redhat.com>
 <2dafa42d-b4cf-d693-517f-5423fb006fcc@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751705AbeBEKf2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 05:35:28 -0500
Content-Disposition: inline
In-Reply-To: <2dafa42d-b4cf-d693-517f-5423fb006fcc@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

On Mon, Feb 05, 2018 at 07:54:29AM +0100, Hannes Reinecke wrote:
> On 02/03/2018 05:21 AM, Ming Lei wrote:
> > Quite a few HBAs(such as HPSA, megaraid, mpt3sas, ..) support multiple
> > reply queues, but tags is often HBA wide.
> > 
> > These HBAs have switched to use pci_alloc_irq_vectors(PCI_IRQ_AFFINITY)
> > for automatic affinity assignment.
> > 
> > Now 84676c1f21e8ff5(genirq/affinity: assign vectors to all possible CPUs)
> > has been merged to V4.16-rc, and it is easy to allocate all offline CPUs
> > for some irq vectors, this can't be avoided even though the allocation
> > is improved.
> > 
> > So all these drivers have to avoid to ask HBA to complete request in
> > reply queue which hasn't online CPUs assigned, and HPSA has been broken
> > with v4.15+:
> > 
> > 	https://marc.info/?l=linux-kernel&m=151748144730409&w=2
> > 
> > This issue can be solved generically and easily via blk_mq(scsi_mq) multiple
> > hw queue by mapping each reply queue into hctx, but one tricky thing is
> > the HBA wide(instead of hw queue wide) tags.
> > 
> > This patch is based on the following Hannes's patch:
> > 
> > 	https://marc.info/?l=linux-block&m=149132580511346&w=2
> > 
> > One big difference with Hannes's is that this patch only makes the tags sbitmap
> > and active_queues data structure HBA wide, and others are kept as NUMA locality,
> > such as request, hctx, tags, ...
> > 
> > The following patch will support global tags on null_blk, also the performance
> > data is provided, no obvious performance loss is observed when the whole
> > hw queue depth is same.
> > 
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Arun Easi <arun.easi@cavium.com>
> > Cc: Omar Sandoval <osandov@fb.com>,
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> > Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> > Cc: Christoph Hellwig <hch@lst.de>,
> > Cc: Don Brace <don.brace@microsemi.com>
> > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > Cc: Peter Rivera <peter.rivera@broadcom.com>
> > Cc: Laurence Oberman <loberman@redhat.com>
> > Cc: Mike Snitzer <snitzer@redhat.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  block/blk-mq-debugfs.c |  1 +
> >  block/blk-mq-sched.c   |  2 +-
> >  block/blk-mq-tag.c     | 23 ++++++++++++++++++-----
> >  block/blk-mq-tag.h     |  5 ++++-
> >  block/blk-mq.c         | 29 ++++++++++++++++++++++++-----
> >  block/blk-mq.h         |  3 ++-
> >  include/linux/blk-mq.h |  2 ++
> >  7 files changed, 52 insertions(+), 13 deletions(-)
> > 
> > diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> > index 0dfafa4b655a..0f0fafe03f5d 100644
> > --- a/block/blk-mq-debugfs.c
> > +++ b/block/blk-mq-debugfs.c
> > @@ -206,6 +206,7 @@ static const char *const hctx_flag_name[] = {
> >  	HCTX_FLAG_NAME(SHOULD_MERGE),
> >  	HCTX_FLAG_NAME(TAG_SHARED),
> >  	HCTX_FLAG_NAME(SG_MERGE),
> > +	HCTX_FLAG_NAME(GLOBAL_TAGS),
> >  	HCTX_FLAG_NAME(BLOCKING),
> >  	HCTX_FLAG_NAME(NO_SCHED),
> >  };
> > diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> > index 55c0a745b427..191d4bc95f0e 100644
> > --- a/block/blk-mq-sched.c
> > +++ b/block/blk-mq-sched.c
> > @@ -495,7 +495,7 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
> >  	int ret;
> >  
> >  	hctx->sched_tags = blk_mq_alloc_rq_map(set, hctx_idx, q->nr_requests,
> > -					       set->reserved_tags);
> > +					       set->reserved_tags, false);
> >  	if (!hctx->sched_tags)
> >  		return -ENOMEM;
> >  
> > diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> > index 571797dc36cb..66377d09eaeb 100644
> > --- a/block/blk-mq-tag.c
> > +++ b/block/blk-mq-tag.c
> > @@ -379,9 +379,11 @@ static struct blk_mq_tags *blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
> >  	return NULL;
> >  }
> >  
> > -struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
> > +struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set,
> > +				     unsigned int total_tags,
> >  				     unsigned int reserved_tags,
> > -				     int node, int alloc_policy)
> > +				     int node, int alloc_policy,
> > +				     bool global_tag)
> >  {
> >  	struct blk_mq_tags *tags;
> >  
> > @@ -397,6 +399,14 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
> >  	tags->nr_tags = total_tags;
> >  	tags->nr_reserved_tags = reserved_tags;
> >  
> > +	WARN_ON(global_tag && !set->global_tags);
> > +	if (global_tag && set->global_tags) {
> > +		tags->bitmap_tags = set->global_tags->bitmap_tags;
> > +		tags->breserved_tags = set->global_tags->breserved_tags;
> > +		tags->active_queues = set->global_tags->active_queues;
> > +		tags->global_tags = true;
> > +		return tags;
> > +	}
> >  	tags->bitmap_tags = &tags->__bitmap_tags;
> >  	tags->breserved_tags = &tags->__breserved_tags;
> >  	tags->active_queues = &tags->__active_queues;
> Do we really need the 'global_tag' flag here?
> Can't we just rely on the ->global_tags pointer to be set?

The same code is used for creating scheduler tags too, so the parameter
of 'global_tag' has to be introduced.

Thanks,
Ming
