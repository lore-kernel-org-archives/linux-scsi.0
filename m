From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: remove artifical max_hw_sectors cap
Date: Wed, 1 Oct 2014 06:08:22 -0700
Message-ID: <20141001130822.GA5362@infradead.org>
References: <1410044885-14893-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410044885-14893-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
List-Id: linux-scsi@vger.kernel.org

As we still haven't made any progress on this let me explain why
the limit does not make sense:  It only applies to _FS request,
which basically have three use cases:

 - metadata I/O.  Generally small enough that the limit does not
   matter at all.
 - buffered reads/writes.  We already have a self-tuning algorithm
   that limits writeback size, and a readahead size tunable that
   caps read sizes.  Imposing another confusing limit that does
   not interact with the visible tunables here is not helpful
 - direct I/O.  Users should get something resembling their request
   as closely as possible on the write, and this is where our
   stupid limitation causes the most problems.

On Sat, Sep 06, 2014 at 04:08:05PM -0700, Christoph Hellwig wrote:
> Set max_sectors to the value the drivers provides as hardware limit by
> default.  Linux had proper I/O throttling for a long time and doesn't
> rely on a artifically small maximum I/O size anymore.  By not limiting
> the I/O size by default we remove an annoying tuning step required for
> most Linux installation.
> 
> Note that both the user, and if absolutely required the driver can still
> impose a limit for FS requests below max_hw_sectors_kb.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-settings.c       | 4 +---
>  drivers/block/aoe/aoeblk.c | 2 +-
>  include/linux/blkdev.h     | 1 -
>  3 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index f1a1795..f52c223 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -257,9 +257,7 @@ void blk_limits_max_hw_sectors(struct queue_limits *limits, unsigned int max_hw_
>  		       __func__, max_hw_sectors);
>  	}
>  
> -	limits->max_hw_sectors = max_hw_sectors;
> -	limits->max_sectors = min_t(unsigned int, max_hw_sectors,
> -				    BLK_DEF_MAX_SECTORS);
> +	limits->max_sectors = limits->max_hw_sectors = max_hw_sectors;
>  }
>  EXPORT_SYMBOL(blk_limits_max_hw_sectors);
>  
> diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
> index dd73e1f..46c282f 100644
> --- a/drivers/block/aoe/aoeblk.c
> +++ b/drivers/block/aoe/aoeblk.c
> @@ -395,7 +395,7 @@ aoeblk_gdalloc(void *vp)
>  	WARN_ON(d->flags & DEVFL_TKILL);
>  	WARN_ON(d->gd);
>  	WARN_ON(d->flags & DEVFL_UP);
> -	blk_queue_max_hw_sectors(q, BLK_DEF_MAX_SECTORS);
> +	blk_queue_max_hw_sectors(q, 1024);
>  	q->backing_dev_info.name = "aoe";
>  	q->backing_dev_info.ra_pages = READ_AHEAD / PAGE_CACHE_SIZE;
>  	d->bufpool = mp;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 518b465..7e3c172 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1192,7 +1192,6 @@ extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
>  enum blk_default_limits {
>  	BLK_MAX_SEGMENTS	= 128,
>  	BLK_SAFE_MAX_SECTORS	= 255,
> -	BLK_DEF_MAX_SECTORS	= 1024,
>  	BLK_MAX_SEGMENT_SIZE	= 65536,
>  	BLK_SEG_BOUNDARY_MASK	= 0xFFFFFFFFUL,
>  };
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
