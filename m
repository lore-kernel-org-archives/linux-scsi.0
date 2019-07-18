From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] blk-mq: add callback of .cleanup_rq
Date: Thu, 18 Jul 2019 10:52:01 -0400
Message-ID: <20190718145201.GA2305@redhat.com>
References: <20190718032519.28306-1-ming.lei@redhat.com>
 <20190718032519.28306-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190718032519.28306-2-ming.lei@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 17 2019 at 11:25pm -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> dm-rq needs to free request which has been dispatched and not completed
> by underlying queue. However, the underlying queue may have allocated
> private stuff for this request in .queue_rq(), so dm-rq will leak the
> request private part.

No, SCSI (and blk-mq) will leak.  DM doesn't know anything about the
internal memory SCSI uses.  That memory is a SCSI implementation detail.

Please fix header to properly reflect which layer is doing the leaking.

> Add one new callback of .cleanup_rq() to fix the memory leak issue.
> 
> Another use case is to free request when the hctx is dead during
> cpu hotplug context.
> 
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: <stable@vger.kernel.org>
> Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/dm-rq.c     |  1 +
>  include/linux/blk-mq.h | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index c9e44ac1f9a6..21d5c1784d0c 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -408,6 +408,7 @@ static int map_request(struct dm_rq_target_io *tio)
>  		ret = dm_dispatch_clone_request(clone, rq);
>  		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
>  			blk_rq_unprep_clone(clone);
> +			blk_mq_cleanup_rq(clone);
>  			tio->ti->type->release_clone_rq(clone, &tio->info);
>  			tio->clone = NULL;
>  			return DM_MAPIO_REQUEUE;

Requiring upper layer driver (dm-rq) to explicitly call blk_mq_cleanup_rq() 
seems wrong.  In this instance tio->ti->type->release_clone_rq()
(dm-mpath's multipath_release_clone) calls blk_put_request().  Why can't
blk_put_request(), or blk_mq_free_request(), call blk_mq_cleanup_rq()?

Not looked at the cpu hotplug case you mention, but my naive thought is
it'd be pretty weird to also sprinkle a call to blk_mq_cleanup_rq() from
that specific "dead hctx" code path.

Mike
