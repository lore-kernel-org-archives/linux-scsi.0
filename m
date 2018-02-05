From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
Date: Mon, 5 Feb 2018 07:54:29 +0100
Message-ID: <2dafa42d-b4cf-d693-517f-5423fb006fcc@suse.de>
References: <20180203042112.15239-1-ming.lei@redhat.com>
 <20180203042112.15239-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57942 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751991AbeBEGye (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 01:54:34 -0500
In-Reply-To: <20180203042112.15239-3-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

On 02/03/2018 05:21 AM, Ming Lei wrote:
> Quite a few HBAs(such as HPSA, megaraid, mpt3sas, ..) support multiple
> reply queues, but tags is often HBA wide.
> 
> These HBAs have switched to use pci_alloc_irq_vectors(PCI_IRQ_AFFINITY)
> for automatic affinity assignment.
> 
> Now 84676c1f21e8ff5(genirq/affinity: assign vectors to all possible CPUs)
> has been merged to V4.16-rc, and it is easy to allocate all offline CPUs
> for some irq vectors, this can't be avoided even though the allocation
> is improved.
> 
> So all these drivers have to avoid to ask HBA to complete request in
> reply queue which hasn't online CPUs assigned, and HPSA has been broken
> with v4.15+:
> 
> 	https://marc.info/?l=linux-kernel&m=151748144730409&w=2
> 
> This issue can be solved generically and easily via blk_mq(scsi_mq) multiple
> hw queue by mapping each reply queue into hctx, but one tricky thing is
> the HBA wide(instead of hw queue wide) tags.
> 
> This patch is based on the following Hannes's patch:
> 
> 	https://marc.info/?l=linux-block&m=149132580511346&w=2
> 
> One big difference with Hannes's is that this patch only makes the tags sbitmap
> and active_queues data structure HBA wide, and others are kept as NUMA locality,
> such as request, hctx, tags, ...
> 
> The following patch will support global tags on null_blk, also the performance
> data is provided, no obvious performance loss is observed when the whole
> hw queue depth is same.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Arun Easi <arun.easi@cavium.com>
> Cc: Omar Sandoval <osandov@fb.com>,
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> Cc: Christoph Hellwig <hch@lst.de>,
> Cc: Don Brace <don.brace@microsemi.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Peter Rivera <peter.rivera@broadcom.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-mq-debugfs.c |  1 +
>  block/blk-mq-sched.c   |  2 +-
>  block/blk-mq-tag.c     | 23 ++++++++++++++++++-----
>  block/blk-mq-tag.h     |  5 ++++-
>  block/blk-mq.c         | 29 ++++++++++++++++++++++++-----
>  block/blk-mq.h         |  3 ++-
>  include/linux/blk-mq.h |  2 ++
>  7 files changed, 52 insertions(+), 13 deletions(-)
> 
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index 0dfafa4b655a..0f0fafe03f5d 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -206,6 +206,7 @@ static const char *const hctx_flag_name[] = {
>  	HCTX_FLAG_NAME(SHOULD_MERGE),
>  	HCTX_FLAG_NAME(TAG_SHARED),
>  	HCTX_FLAG_NAME(SG_MERGE),
> +	HCTX_FLAG_NAME(GLOBAL_TAGS),
>  	HCTX_FLAG_NAME(BLOCKING),
>  	HCTX_FLAG_NAME(NO_SCHED),
>  };
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 55c0a745b427..191d4bc95f0e 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -495,7 +495,7 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
>  	int ret;
>  
>  	hctx->sched_tags = blk_mq_alloc_rq_map(set, hctx_idx, q->nr_requests,
> -					       set->reserved_tags);
> +					       set->reserved_tags, false);
>  	if (!hctx->sched_tags)
>  		return -ENOMEM;
>  
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 571797dc36cb..66377d09eaeb 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -379,9 +379,11 @@ static struct blk_mq_tags *blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>  	return NULL;
>  }
>  
> -struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
> +struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set,
> +				     unsigned int total_tags,
>  				     unsigned int reserved_tags,
> -				     int node, int alloc_policy)
> +				     int node, int alloc_policy,
> +				     bool global_tag)
>  {
>  	struct blk_mq_tags *tags;
>  
> @@ -397,6 +399,14 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
>  	tags->nr_tags = total_tags;
>  	tags->nr_reserved_tags = reserved_tags;
>  
> +	WARN_ON(global_tag && !set->global_tags);
> +	if (global_tag && set->global_tags) {
> +		tags->bitmap_tags = set->global_tags->bitmap_tags;
> +		tags->breserved_tags = set->global_tags->breserved_tags;
> +		tags->active_queues = set->global_tags->active_queues;
> +		tags->global_tags = true;
> +		return tags;
> +	}
>  	tags->bitmap_tags = &tags->__bitmap_tags;
>  	tags->breserved_tags = &tags->__breserved_tags;
>  	tags->active_queues = &tags->__active_queues;
Do we really need the 'global_tag' flag here?
Can't we just rely on the ->global_tags pointer to be set?

> @@ -406,8 +416,10 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
>  
>  void blk_mq_free_tags(struct blk_mq_tags *tags)
>  {
> -	sbitmap_queue_free(tags->bitmap_tags);
> -	sbitmap_queue_free(tags->breserved_tags);
> +	if (!tags->global_tags) {
> +		sbitmap_queue_free(tags->bitmap_tags);
> +		sbitmap_queue_free(tags->breserved_tags);
> +	}
>  	kfree(tags);
>  }
>  
> @@ -441,7 +453,8 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
>  		if (tdepth > 16 * BLKDEV_MAX_RQ)
>  			return -EINVAL;
>  
> -		new = blk_mq_alloc_rq_map(set, hctx->queue_num, tdepth, 0);
> +		new = blk_mq_alloc_rq_map(set, hctx->queue_num, tdepth, 0,
> +				(*tagsptr)->global_tags);
>  		if (!new)
>  			return -ENOMEM;
>  		ret = blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth);
> diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
> index a68323fa0c02..a87b5cfa5726 100644
> --- a/block/blk-mq-tag.h
> +++ b/block/blk-mq-tag.h
> @@ -20,13 +20,16 @@ struct blk_mq_tags {
>  	struct sbitmap_queue __bitmap_tags;
>  	struct sbitmap_queue __breserved_tags;
>  
> +	bool	global_tags;
>  	struct request **rqs;
>  	struct request **static_rqs;
>  	struct list_head page_list;
>  };
>  
>  
> -extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int reserved_tags, int node, int alloc_policy);
> +extern struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set,
> +		unsigned int nr_tags, unsigned int reserved_tags, int node,
> +		int alloc_policy, bool global_tag);
>  extern void blk_mq_free_tags(struct blk_mq_tags *tags);
>  
>  extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 69d4534870af..a98466dc71b5 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2023,7 +2023,8 @@ void blk_mq_free_rq_map(struct blk_mq_tags *tags)
>  struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>  					unsigned int hctx_idx,
>  					unsigned int nr_tags,
> -					unsigned int reserved_tags)
> +					unsigned int reserved_tags,
> +					bool global_tags)
>  {
>  	struct blk_mq_tags *tags;
>  	int node;
> @@ -2032,8 +2033,9 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>  	if (node == NUMA_NO_NODE)
>  		node = set->numa_node;
>  
> -	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
> -				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
> +	tags = blk_mq_init_tags(set, nr_tags, reserved_tags, node,
> +				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags),
> +				global_tags);
>  	if (!tags)
>  		return NULL;
>  > @@ -2336,7 +2338,8 @@ static bool __blk_mq_alloc_rq_map(struct
blk_mq_tag_set *set, int hctx_idx)
>  	int ret = 0;
>  
>  	set->tags[hctx_idx] = blk_mq_alloc_rq_map(set, hctx_idx,
> -					set->queue_depth, set->reserved_tags);
> +					set->queue_depth, set->reserved_tags,
> +					!!(set->flags & BLK_MQ_F_GLOBAL_TAGS));
>  	if (!set->tags[hctx_idx])
>  		return false;
>  
> @@ -2891,15 +2894,28 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
>  	if (ret)
>  		goto out_free_mq_map;
>  
> +	if (set->flags & BLK_MQ_F_GLOBAL_TAGS) {
> +		ret = -ENOMEM;
> +		set->global_tags = blk_mq_init_tags(set, set->queue_depth,
> +				set->reserved_tags, set->numa_node,
> +				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags),
> +				false);
> +		if (!set->global_tags)
> +			goto out_free_mq_map;
> +	}
> +
>  	ret = blk_mq_alloc_rq_maps(set);
>  	if (ret)
> -		goto out_free_mq_map;
> +		goto out_free_global_tags;
>  
>  	mutex_init(&set->tag_list_lock);
>  	INIT_LIST_HEAD(&set->tag_list);
>  
>  	return 0;
>  
> +out_free_global_tags:
> +	if (set->global_tags)
> +		blk_mq_free_tags(set->global_tags);
>  out_free_mq_map:
>  	kfree(set->mq_map);
>  	set->mq_map = NULL;
> @@ -2914,6 +2930,9 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
>  {
>  	int i;
>  
> +	if (set->global_tags)
> +		blk_mq_free_tags(set->global_tags);
> +
>  	for (i = 0; i < nr_cpu_ids; i++)
>  		blk_mq_free_map_and_requests(set, i);
>  
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index 88c558f71819..d1d9a0a8e1fa 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -61,7 +61,8 @@ void blk_mq_free_rq_map(struct blk_mq_tags *tags);
>  struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>  					unsigned int hctx_idx,
>  					unsigned int nr_tags,
> -					unsigned int reserved_tags);
> +					unsigned int reserved_tags,
> +					bool global_tags);
>  int blk_mq_alloc_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>  		     unsigned int hctx_idx, unsigned int depth);
>  
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 8efcf49796a3..8548c72d6b4a 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -82,6 +82,7 @@ struct blk_mq_tag_set {
>  	void			*driver_data;
>  
>  	struct blk_mq_tags	**tags;
> +	struct blk_mq_tags	*global_tags;	/* for BLK_MQ_F_GLOBAL_TAGS */
>  
>  	struct mutex		tag_list_lock;
>  	struct list_head	tag_list;
> @@ -175,6 +176,7 @@ enum {
>  	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
>  	BLK_MQ_F_TAG_SHARED	= 1 << 1,
>  	BLK_MQ_F_SG_MERGE	= 1 << 2,
> +	BLK_MQ_F_GLOBAL_TAGS	= 1 << 3,
>  	BLK_MQ_F_BLOCKING	= 1 << 5,
>  	BLK_MQ_F_NO_SCHED	= 1 << 6,
>  	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
> 
Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
