From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/8] block: Consolidate command flag and queue limit
 checks for merges
Date: Tue, 18 Sep 2012 13:59:21 -0400
Message-ID: <20120918175921.GA8960@redhat.com>
References: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
 <1347985172-2495-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab2IRR71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2012 13:59:27 -0400
Content-Disposition: inline
In-Reply-To: <1347985172-2495-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk, shli@kernel.org

On Tue, Sep 18 2012 at 12:19pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> From: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
>  - blk_check_merge_flags() verifies that cmd_flags / bi_rw are
>    compatible. This function is called for both req-req and req-bio
>    merging.
> 
>  - blk_rq_get_max_sectors() and blk_queue_get_max_sectors() can be used
>    to query the maximum sector count for a given request or queue. The
>    calls will return the right value from the queue limits given the
>    type of command (RW, discard, write same, etc.)
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  block/blk-core.c       |    3 +--
>  block/blk-merge.c      |   30 ++++++++++++------------------
>  include/linux/blkdev.h |   31 +++++++++++++++++++++++++++++++
>  3 files changed, 44 insertions(+), 20 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 5cc2929..33eded0 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1866,8 +1866,7 @@ int blk_rq_check_limits(struct request_queue *q, struct request *rq)
>  	if (!rq_mergeable(rq))
>  		return 0;
>  
> -	if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
> -	    blk_rq_bytes(rq) > queue_max_hw_sectors(q) << 9) {
> +	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, rq->cmd_flags)) {
>  		printk(KERN_ERR "%s: over max size limit.\n", __func__);
>  		return -EIO;
>  	}
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 86710ca..642b862 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -275,14 +275,8 @@ no_merge:
>  int ll_back_merge_fn(struct request_queue *q, struct request *req,
>  		     struct bio *bio)
>  {
> -	unsigned short max_sectors;
> -
> -	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
> -		max_sectors = queue_max_hw_sectors(q);
> -	else
> -		max_sectors = queue_max_sectors(q);
> -
> -	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
> +	if (blk_rq_sectors(req) + bio_sectors(bio) >
> +	    blk_rq_get_max_sectors(req)) {
>  		req->cmd_flags |= REQ_NOMERGE;
>  		if (req == q->last_merge)
>  			q->last_merge = NULL;
> @@ -299,15 +293,8 @@ int ll_back_merge_fn(struct request_queue *q, struct request *req,
>  int ll_front_merge_fn(struct request_queue *q, struct request *req,
>  		      struct bio *bio)
>  {
> -	unsigned short max_sectors;
> -
> -	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
> -		max_sectors = queue_max_hw_sectors(q);
> -	else
> -		max_sectors = queue_max_sectors(q);
> -
> -
> -	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
> +	if (blk_rq_sectors(req) + bio_sectors(bio) >
> +	    blk_rq_get_max_sectors(req)) {
>  		req->cmd_flags |= REQ_NOMERGE;
>  		if (req == q->last_merge)
>  			q->last_merge = NULL;
> @@ -338,7 +325,8 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
>  	/*
>  	 * Will it become too large?
>  	 */
> -	if ((blk_rq_sectors(req) + blk_rq_sectors(next)) > queue_max_sectors(q))
> +	if ((blk_rq_sectors(req) + blk_rq_sectors(next)) >
> +	    blk_rq_get_max_sectors(req))
>  		return 0;
>  
>  	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
> @@ -417,6 +405,9 @@ static int attempt_merge(struct request_queue *q, struct request *req,
>  	if (!rq_mergeable(req) || !rq_mergeable(next))
>  		return 0;
>  
> +	if (!blk_check_merge_flags(req->cmd_flags, next->cmd_flags))
> +		return 0;
> +
>  	/*
>  	 * not contiguous
>  	 */
> @@ -512,6 +503,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
>  	if (!rq_mergeable(rq) || !bio_mergeable(bio))
>  		return false;
>  
> +	if (!blk_check_merge_flags(rq->cmd_flags, bio->bi_rw))
> +		return false;
> +
>  	/* different data direction or already started, don't merge */
>  	if (bio_data_dir(bio) != rq_data_dir(rq))
>  		return false;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 3a6fea7..90f7abe 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -605,6 +605,18 @@ static inline bool rq_mergeable(struct request *rq)
>  	return true;
>  }
>  
> +static inline bool blk_check_merge_flags(unsigned int flags1,
> +					 unsigned int flags2)
> +{
> +	if ((flags1 & REQ_DISCARD) != (flags2 & REQ_DISCARD))
> +		return false;
> +
> +	if ((flags1 & REQ_SECURE) != (flags2 & REQ_SECURE))
> +		return false;
> +
> +	return true;
> +}
> +
>  /*
>   * q->prep_rq_fn return values
>   */
> @@ -800,6 +812,25 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
>  	return blk_rq_cur_bytes(rq) >> 9;
>  }
>  
> +static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
> +						     unsigned int cmd_flags)
> +{
> +	if (unlikely(cmd_flags & REQ_DISCARD))
> +		return q->limits.max_discard_sectors;
> +
> +	return q->limits.max_sectors;

Any reason not to use queue_max_sectors() here?

> +}
> +
> +static inline unsigned int blk_rq_get_max_sectors(struct request *rq)
> +{
> +	struct request_queue *q = rq->q;
> +
> +	if (unlikely(rq->cmd_type == REQ_TYPE_BLOCK_PC))
> +		return q->limits.max_hw_sectors;

Or queue_max_hw_sectors() here?

> +	return blk_queue_get_max_sectors(q, rq->cmd_flags);
> +}
> +

But I don't feel that strongly on these nits.  So regardless:

Acked-by: Mike Snitzer <snitzer@redhat.com>

(thanks for getting this patchset together Martin)
