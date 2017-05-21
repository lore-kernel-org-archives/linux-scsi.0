From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/18] block: Introduce request_queue.initialize_rq_fn()
Date: Sun, 21 May 2017 08:34:43 +0200
Message-ID: <20170521063443.GF12287@lst.de>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com> <20170519183016.12646-8-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170519183016.12646-8-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 19, 2017 at 11:30:05AM -0700, Bart Van Assche wrote:
> Several block drivers need to initialize the driver-private data
> after having called blk_get_request() and before .prep_rq_fn() is
> called, e.g. when submitting a REQ_OP_SCSI_* request. Avoid that
> that initialization code has to be repeated after every
> blk_get_request() call by adding a new callback function to struct
> request_queue.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: linux-block@vger.kernel.org
> ---
>  block/blk-core.c       | 3 +++
>  block/blk-mq.c         | 3 +++
>  include/linux/blkdev.h | 4 ++++
>  3 files changed, 10 insertions(+)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a69d420b7ff0..f2540d164679 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -126,6 +126,9 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
>  	rq->start_time = jiffies;
>  	set_start_time_ns(rq);
>  	rq->part = NULL;
> +
> +	if (q->initialize_rq_fn)
> +		q->initialize_rq_fn(rq);

Can we keep this out of the fast path and only do it from the
blk_get_request / blk_mq_alloc_request path?  And while were at it
I think those two should be merged as far as the public interface
goes, that is we should also expose the flags argument for the
legacy path.
