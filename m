From: Arun Easi <arun.easi@cavium.com>
Subject: Re: [PATCH 1/2] block: Implement global tagset
Date: Wed, 5 Apr 2017 23:27:35 -0700 (PDT)
Message-ID: <alpine.LRH.2.00.1704052257580.727@mvluser05.qlc.com>
References: <1491307665-47656-1-git-send-email-hare@suse.de> <1491307665-47656-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0054.outbound.protection.outlook.com ([104.47.37.54]:12034
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753908AbdDFG1p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Apr 2017 02:27:45 -0400
In-Reply-To: <1491307665-47656-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Hi Hannes,

Thanks for taking a crack at the issue. My comments below..

On Tue, 4 Apr 2017, 5:07am, Hannes Reinecke wrote:

> Most legacy HBAs have a tagset per HBA, not per queue. To map
> these devices onto block-mq this patch implements a new tagset
> flag BLK_MQ_F_GLOBAL_TAGS, which will cause the tag allocator
> to use just one tagset for all hardware queues.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  block/blk-mq-tag.c     | 12 ++++++++----
>  block/blk-mq.c         | 10 ++++++++--
>  include/linux/blk-mq.h |  1 +
>  3 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index e48bc2c..a14e76c 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -276,9 +276,11 @@ static void blk_mq_all_tag_busy_iter(struct blk_mq_tags *tags,
>  void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
>  		busy_tag_iter_fn *fn, void *priv)
>  {
> -	int i;
> +	int i, lim = tagset->nr_hw_queues;
>  
> -	for (i = 0; i < tagset->nr_hw_queues; i++) {
> +	if (tagset->flags & BLK_MQ_F_GLOBAL_TAGS)
> +		lim = 1;
> +	for (i = 0; i < lim; i++) {
>  		if (tagset->tags && tagset->tags[i])
>  			blk_mq_all_tag_busy_iter(tagset->tags[i], fn, priv);
>  	}
> @@ -287,12 +289,14 @@ void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
>  
>  int blk_mq_reinit_tagset(struct blk_mq_tag_set *set)
>  {
> -	int i, j, ret = 0;
> +	int i, j, ret = 0, lim = set->nr_hw_queues;
>  
>  	if (!set->ops->reinit_request)
>  		goto out;
>  
> -	for (i = 0; i < set->nr_hw_queues; i++) {
> +	if (set->flags & BLK_MQ_F_GLOBAL_TAGS)
> +		lim = 1;
> +	for (i = 0; i < lim; i++) {
>  		struct blk_mq_tags *tags = set->tags[i];
>  
>  		for (j = 0; j < tags->nr_tags; j++) {
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 159187a..db96ed0 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2061,6 +2061,10 @@ static bool __blk_mq_alloc_rq_map(struct blk_mq_tag_set *set, int hctx_idx)
>  {
>  	int ret = 0;
>  
> +	if ((set->flags & BLK_MQ_F_GLOBAL_TAGS) && hctx_idx != 0) {
> +		set->tags[hctx_idx] = set->tags[0];
> +		return true;
> +	}

So, this effectively make all request allocations to the same NUMA node 
locality of the hctx_idx 0, correct? Is the performance hit you were 
talking about in the cover letter?

Do you have any other alternatives in mind? Dynamic growing/shrinking 
tags/request-pool in hctx with a fixed base as start?

One alternative that comes to my mind is to move the divvy up logic to 
SCSI (instead of LLD doing it), IOW:

1. Have SCSI set tag_set.queue_depth to can_queue/nr_hw_queues
2. Have blk_mq_unique_tag() (or a new i/f) returning "hwq * nr_hw_queue + 
   rq->tag"

That would make the tags linear in the can_queue space, but could result 
in poor use of LLD resource if a given hctx has used up all it's tags.

On a related note, would not the current use of can_queue in SCSI lead to 
poor resource utilization in MQ cases? Like, block layer allocating 
nr_hw_queues * tags+request+driver_data.etc * can_queue, but SCSI limiting 
the number of requests to can_queue.

BTW, if you would like me to try out this patch on my setup, please let me 
know.

Regards,
-Arun

>  	set->tags[hctx_idx] = blk_mq_alloc_rq_map(set, hctx_idx,
>  					set->queue_depth, set->reserved_tags);
>  	if (!set->tags[hctx_idx])
> @@ -2080,8 +2084,10 @@ static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
>  					 unsigned int hctx_idx)
>  {
>  	if (set->tags[hctx_idx]) {
> -		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
> -		blk_mq_free_rq_map(set->tags[hctx_idx]);
> +		if (!(set->flags & BLK_MQ_F_GLOBAL_TAGS) || hctx_idx == 0) {
> +			blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
> +			blk_mq_free_rq_map(set->tags[hctx_idx]);
> +		}
>  		set->tags[hctx_idx] = NULL;
>  	}
>  }
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index b296a90..eee27b016 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -155,6 +155,7 @@ enum {
>  	BLK_MQ_F_DEFER_ISSUE	= 1 << 4,
>  	BLK_MQ_F_BLOCKING	= 1 << 5,
>  	BLK_MQ_F_NO_SCHED	= 1 << 6,
> +	BLK_MQ_F_GLOBAL_TAGS	= 1 << 7,
>  	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
>  	BLK_MQ_F_ALLOC_POLICY_BITS = 1,
>  
> 
