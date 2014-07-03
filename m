From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 11/14] block: Don't merge requests if integrity flags
 differ
Date: Thu, 03 Jul 2014 13:06:11 +0300
Message-ID: <53B52B13.2030603@dev.mellanox.co.il>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com> <1401334128-15499-12-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61220 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030808AbaGCKGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 06:06:24 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so10339929wib.5
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 03:06:23 -0700 (PDT)
In-Reply-To: <1401334128-15499-12-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On 5/29/2014 6:28 AM, Martin K. Petersen wrote:
> We'd occasionally merge requests with conflicting integrity flags.
> Introduce a merge helper which checks that the requests have compatible
> integrity payloads.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   block/blk-integrity.c  | 36 ++++++++++++++++++++++++++----------
>   block/blk-merge.c      |  6 +++---
>   include/linux/blkdev.h | 20 ++++++++++----------
>   3 files changed, 39 insertions(+), 23 deletions(-)
>
> diff --git a/block/blk-integrity.c b/block/blk-integrity.c
> index 8cf87655152b..da608e73bdb1 100644
> --- a/block/blk-integrity.c
> +++ b/block/blk-integrity.c
> @@ -186,37 +186,53 @@ int blk_integrity_compare(struct gendisk *gd1, struct gendisk *gd2)
>   }
>   EXPORT_SYMBOL(blk_integrity_compare);
>   
> -int blk_integrity_merge_rq(struct request_queue *q, struct request *req,
> -			   struct request *next)
> +bool blk_integrity_merge_rq(struct request_queue *q, struct request *req,
> +			    struct request *next)
>   {
> -	if (blk_integrity_rq(req) != blk_integrity_rq(next))
> -		return -1;
> +	if (blk_integrity_rq(req) == 0 && blk_integrity_rq(next) == 0)
> +		return true;
> +
> +	if (blk_integrity_rq(req) == 0 || blk_integrity_rq(next) == 0)
> +		return false;
> +
> +	if (bio_integrity(req->bio)->bip_flags !=
> +	    bio_integrity(next->bio)->bip_flags)
> +		return false;
>   
>   	if (req->nr_integrity_segments + next->nr_integrity_segments >
>   	    q->limits.max_integrity_segments)
> -		return -1;
> +		return false;
>   
> -	return 0;
> +	return true;
>   }
>   EXPORT_SYMBOL(blk_integrity_merge_rq);
>   
> -int blk_integrity_merge_bio(struct request_queue *q, struct request *req,
> -			    struct bio *bio)
> +bool blk_integrity_merge_bio(struct request_queue *q, struct request *req,
> +			     struct bio *bio)
>   {
>   	int nr_integrity_segs;
>   	struct bio *next = bio->bi_next;
>   
> +	if (blk_integrity_rq(req) == 0 && bio_integrity(bio) == NULL)
> +		return true;
> +
> +	if (blk_integrity_rq(req) == 0 || bio_integrity(bio) == NULL)
> +		return false;
> +
> +	if (bio_integrity(req->bio)->bip_flags != bio_integrity(bio)->bip_flags)
> +		return false;
> +
>   	bio->bi_next = NULL;
>   	nr_integrity_segs = blk_rq_count_integrity_sg(q, bio);
>   	bio->bi_next = next;
>   
>   	if (req->nr_integrity_segments + nr_integrity_segs >
>   	    q->limits.max_integrity_segments)
> -		return -1;
> +		return false;
>   
>   	req->nr_integrity_segments += nr_integrity_segs;
>   
> -	return 0;
> +	return true;
>   }
>   EXPORT_SYMBOL(blk_integrity_merge_bio);
>   
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 6c583f9c5b65..21e38f407785 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -294,7 +294,7 @@ static inline int ll_new_hw_segment(struct request_queue *q,
>   	if (req->nr_phys_segments + nr_phys_segs > queue_max_segments(q))
>   		goto no_merge;
>   
> -	if (bio_integrity(bio) && blk_integrity_merge_bio(q, req, bio))
> +	if (blk_integrity_merge_bio(q, req, bio) == false)
>   		goto no_merge;
>   
>   	/*
> @@ -391,7 +391,7 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
>   	if (total_phys_segments > queue_max_segments(q))
>   		return 0;
>   
> -	if (blk_integrity_rq(req) && blk_integrity_merge_rq(q, req, next))
> +	if (blk_integrity_merge_rq(q, req, next) == false)
>   		return 0;
>   
>   	/* Merge is OK... */
> @@ -569,7 +569,7 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
>   		return false;
>   
>   	/* only merge integrity protected bio into ditto rq */
> -	if (bio_integrity(bio) != blk_integrity_rq(rq))
> +	if (blk_integrity_merge_bio(rq->q, rq, bio) == false)
>   		return false;
>   
>   	/* must be using the same buffer */
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 9bf6f761f1ac..45cd70cda4e8 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1467,10 +1467,10 @@ extern int blk_integrity_compare(struct gendisk *, struct gendisk *);
>   extern int blk_rq_map_integrity_sg(struct request_queue *, struct bio *,
>   				   struct scatterlist *);
>   extern int blk_rq_count_integrity_sg(struct request_queue *, struct bio *);
> -extern int blk_integrity_merge_rq(struct request_queue *, struct request *,
> -				  struct request *);
> -extern int blk_integrity_merge_bio(struct request_queue *, struct request *,
> -				   struct bio *);
> +extern bool blk_integrity_merge_rq(struct request_queue *, struct request *,
> +				   struct request *);
> +extern bool blk_integrity_merge_bio(struct request_queue *, struct request *,
> +				    struct bio *);
>   
>   static inline
>   struct blk_integrity *bdev_get_integrity(struct block_device *bdev)
> @@ -1550,15 +1550,15 @@ static inline unsigned short queue_max_integrity_segments(struct request_queue *
>   {
>   	return 0;
>   }
> -static inline int blk_integrity_merge_rq(struct request_queue *rq,
> -					 struct request *r1,
> -					 struct request *r2)
> +static inline bool blk_integrity_merge_rq(struct request_queue *rq,
> +					  struct request *r1,
> +					  struct request *r2)
>   {
>   	return 0;
>   }
> -static inline int blk_integrity_merge_bio(struct request_queue *rq,
> -					  struct request *r,
> -					  struct bio *b)
> +static inline bool blk_integrity_merge_bio(struct request_queue *rq,
> +					   struct request *r,
> +					   struct bio *b)
>   {
>   	return 0;
>   }

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
