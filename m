From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/11] fs, block: propagate REQ_FLUSH/FUA interface to
 upper layers
Date: Thu, 12 Aug 2010 23:24:04 +0200
Message-ID: <20100812212404.GB3665@quack.suse.cz>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
 <1281616891-5691-11-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab0HLVYo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2010 17:24:44 -0400
Content-Disposition: inline
In-Reply-To: <1281616891-5691-11-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, Christoph Hellwig <hch@infradead.org>

On Thu 12-08-10 14:41:30, Tejun Heo wrote:
> Propagate deprecation of REQ_HARDBARRIER and new REQ_FLUSH/FUA
> interface to upper layers.
> 
> * WRITE_BARRIER is marked deprecated and WRITE_FLUSH, WRITE_FUA and
>   WRITE_FLUSH_FUA are added.
> 
> * REQ_COMMON_MASK now includes REQ_FLUSH | REQ_FUA so that they are
>   copied from bio to request.
> 
> * BH_Ordered is marked deprecated and BH_Flush and BH_FUA are added.
  Deprecating BH_Ordered is fine but I wouldn't introduce new BH flags for
this. BH flags should be used for buffer state, not for encoding how the
buffer should be written (there were actually bugs in the past because of
this). Being able to set proper flags when calling submit_bh() in the rw
parameter is enough.

								Honza

> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>  fs/buffer.c                 |   27 ++++++++++++++++-----------
>  include/linux/blk_types.h   |    2 +-
>  include/linux/buffer_head.h |    8 ++++++--
>  include/linux/fs.h          |   20 +++++++++++++-------
>  4 files changed, 36 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index d54812b..ec32fbb 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3019,18 +3019,23 @@ int submit_bh(int rw, struct buffer_head * bh)
>  	BUG_ON(buffer_delay(bh));
>  	BUG_ON(buffer_unwritten(bh));
>  
> -	/*
> -	 * Mask in barrier bit for a write (could be either a WRITE or a
> -	 * WRITE_SYNC
> -	 */
> -	if (buffer_ordered(bh) && (rw & WRITE))
> -		rw |= WRITE_BARRIER;
> +	if (rw & WRITE) {
> +		/* ordered is deprecated, will be removed */
> +		if (buffer_ordered(bh))
> +			rw |= WRITE_BARRIER;
>  
> -	/*
> -	 * Only clear out a write error when rewriting
> -	 */
> -	if (test_set_buffer_req(bh) && (rw & WRITE))
> -		clear_buffer_write_io_error(bh);
> +		if (buffer_flush(bh))
> +			rw |= WRITE_FLUSH;
> +
> +		if (buffer_fua(bh))
> +			rw |= WRITE_FUA;
> +
> +		/*
> +		 * Only clear out a write error when rewriting
> +		 */
> +		if (test_set_buffer_req(bh))
> +			clear_buffer_write_io_error(bh);
> +	}
>  
>  	/*
>  	 * from here on down, it's all bio -- do the initial mapping,
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 8e9887d..6609fc0 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -164,7 +164,7 @@ enum rq_flag_bits {
>  	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
>  #define REQ_COMMON_MASK \
>  	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_HARDBARRIER | REQ_SYNC | \
> -	 REQ_META| REQ_DISCARD | REQ_NOIDLE)
> +	 REQ_META | REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
>  
>  #define REQ_UNPLUG		(1 << __REQ_UNPLUG)
>  #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 1b9ba19..498bd8b 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -32,8 +32,10 @@ enum bh_state_bits {
>  	BH_Delay,	/* Buffer is not yet allocated on disk */
>  	BH_Boundary,	/* Block is followed by a discontiguity */
>  	BH_Write_EIO,	/* I/O error on write */
> -	BH_Ordered,	/* ordered write */
> -	BH_Eopnotsupp,	/* operation not supported (barrier) */
> +	BH_Ordered,	/* DEPRECATED: ordered write */
> +	BH_Eopnotsupp,	/* DEPRECATED: operation not supported (barrier) */
> +	BH_Flush,	/* Flush device cache before executing IO */
> +	BH_FUA,		/* Data should be on non-volatile media on completion */
>  	BH_Unwritten,	/* Buffer is allocated on disk but not written */
>  	BH_Quiet,	/* Buffer Error Prinks to be quiet */
>  
> @@ -126,6 +128,8 @@ BUFFER_FNS(Delay, delay)
>  BUFFER_FNS(Boundary, boundary)
>  BUFFER_FNS(Write_EIO, write_io_error)
>  BUFFER_FNS(Ordered, ordered)
> +BUFFER_FNS(Flush, flush)
> +BUFFER_FNS(FUA, fua)
>  BUFFER_FNS(Eopnotsupp, eopnotsupp)
>  BUFFER_FNS(Unwritten, unwritten)
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 4ebd8eb..6e30b0b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -138,13 +138,13 @@ struct inodes_stat_t {
>   * SWRITE_SYNC
>   * SWRITE_SYNC_PLUG	Like WRITE_SYNC/WRITE_SYNC_PLUG, but locks the buffer.
>   *			See SWRITE.
> - * WRITE_BARRIER	Like WRITE_SYNC, but tells the block layer that all
> - *			previously submitted writes must be safely on storage
> - *			before this one is started. Also guarantees that when
> - *			this write is complete, it itself is also safely on
> - *			storage. Prevents reordering of writes on both sides
> - *			of this IO.
> - *
> + * WRITE_BARRIER	DEPRECATED. Always fails. Use FLUSH/FUA instead.
> + * WRITE_FLUSH		Like WRITE_SYNC but with preceding cache flush.
> + * WRITE_FUA		Like WRITE_SYNC but data is guaranteed to be on
> + *			non-volatile media on completion.
> + * WRITE_FLUSH_FUA	Combination of WRITE_FLUSH and FUA.  The IO is preceded
> + *			by a cache flush and data is guaranteed to be on
> + *			non-volatile media on completion.
>   */
>  #define RW_MASK			REQ_WRITE
>  #define RWA_MASK		REQ_RAHEAD
> @@ -162,6 +162,12 @@ struct inodes_stat_t {
>  #define WRITE_META		(WRITE | REQ_META)
>  #define WRITE_BARRIER		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
>  				 REQ_HARDBARRIER)
> +#define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
> +				 REQ_FLUSH)
> +#define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
> +				 REQ_FUA)
> +#define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
> +				 REQ_FLUSH | REQ_FUA)
>  #define SWRITE_SYNC_PLUG	(SWRITE | REQ_SYNC | REQ_NOIDLE)
>  #define SWRITE_SYNC		(SWRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG)
>  
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
