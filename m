From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/6] block: rename and export rq_init()
Date: Sun, 27 Apr 2008 14:41:09 +0300
Message-ID: <48146655.2050806@panasas.com>
References: <1209140607-28654-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1209140607-28654-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1209140607-28654-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1209140607-28654-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1209140607-28654-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, bzolnier@gmail.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 25 2008 at 19:23 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> This rename rq_init() blk_rq_init() and export it. Any path that hands
> the request to the block layer needs to call it to initialize the
> request.
> 
> This is a preparation for large command support, which needs to
> initialize the request in a proper way (that is, just doing a memset()
> will not work).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jens Axboe <jens.axboe@oracle.com>

Please, if not to late, add:
Cc: Boaz Harrosh <bharrosh@panasas.com>

> ---
>  block/blk-barrier.c    |    4 ++--
>  block/blk-core.c       |    5 +++--
>  block/blk.h            |    1 -
>  include/linux/blkdev.h |    1 +
>  4 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-barrier.c b/block/blk-barrier.c
> index 722140a..5e2cfe9 100644
> --- a/block/blk-barrier.c
> +++ b/block/blk-barrier.c
> @@ -143,7 +143,7 @@ static void queue_flush(struct request_queue *q, unsigned which)
>  		end_io = post_flush_end_io;
>  	}
>  
> -	rq_init(q, rq);
> +	blk_rq_init(q, rq);
>  	rq->cmd_flags = REQ_HARDBARRIER;
>  	rq->rq_disk = q->bar_rq.rq_disk;
>  	rq->end_io = end_io;
> @@ -165,7 +165,7 @@ static inline struct request *start_ordered(struct request_queue *q,
>  	blkdev_dequeue_request(rq);
>  	q->orig_bar_rq = rq;
>  	rq = &q->bar_rq;
> -	rq_init(q, rq);
> +	blk_rq_init(q, rq);
>  	if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
>  		rq->cmd_flags |= REQ_RW;
>  	if (q->ordered & QUEUE_ORDERED_FUA)
> diff --git a/block/blk-core.c b/block/blk-core.c
> index e7cdabc..a89adcc 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -107,7 +107,7 @@ struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev)
>  }
>  EXPORT_SYMBOL(blk_get_backing_dev_info);
>  
> -void rq_init(struct request_queue *q, struct request *rq)
> +void blk_rq_init(struct request_queue *q, struct request *rq)
>  {
>  	memset(rq, 0, sizeof(*rq));
>  
> @@ -120,6 +120,7 @@ void rq_init(struct request_queue *q, struct request *rq)
>  	rq->tag = -1;
>  	rq->ref_count = 1;
>  }
> +EXPORT_SYMBOL(blk_rq_init);
>  
>  static void req_bio_endio(struct request *rq, struct bio *bio,
>  			  unsigned int nbytes, int error)
> @@ -601,7 +602,7 @@ blk_alloc_request(struct request_queue *q, int rw, int priv, gfp_t gfp_mask)
>  	if (!rq)
>  		return NULL;
>  
> -	rq_init(q, rq);
> +	blk_rq_init(q, rq);
>  
>  	/*
>  	 * first three bits are identical in rq->cmd_flags and bio->bi_rw,
> diff --git a/block/blk.h b/block/blk.h
> index ec9120f..59776ab 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -10,7 +10,6 @@
>  extern struct kmem_cache *blk_requestq_cachep;
>  extern struct kobj_type blk_queue_ktype;
>  
> -void rq_init(struct request_queue *q, struct request *rq);
>  void init_request_from_bio(struct request *req, struct bio *bio);
>  void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
>  			struct bio *bio);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 8ca481c..d17032c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -607,6 +607,7 @@ extern int blk_register_queue(struct gendisk *disk);
>  extern void blk_unregister_queue(struct gendisk *disk);
>  extern void register_disk(struct gendisk *dev);
>  extern void generic_make_request(struct bio *bio);
> +extern void blk_rq_init(struct request_queue *q, struct request *rq);
>  extern void blk_put_request(struct request *);
>  extern void __blk_put_request(struct request_queue *, struct request *);
>  extern void blk_end_sync_rq(struct request *rq, int error);

