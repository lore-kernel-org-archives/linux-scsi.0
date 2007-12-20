From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] SG: Convert SCSI to use scatterlist helpers for sg
 chaining
Date: Thu, 20 Dec 2007 16:26:57 +0200
Message-ID: <476A7BB1.9040200@panasas.com>
References: <200712201645.19035.rusty@rustcorp.com.au> <20071220160741K.fujita.tomonori@lab.ntt.co.jp> <200712201853.48643.rusty@rustcorp.com.au> <20071220075814.GH13958@kernel.dk> <476A743D.2080506@panasas.com> <476A7617.4010307@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:44218 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935036AbXLTO2N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 09:28:13 -0500
In-Reply-To: <476A7617.4010307@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dougg@torque.net

On Thu, Dec 20 2007 at 16:03 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/scsi/libsrp.c        |    2 +-
>  drivers/scsi/scsi_error.c    |    4 +-
>  drivers/scsi/scsi_lib.c      |  150 +++++-------------------------------------
>  drivers/usb/storage/isd200.c |    4 +-
>  include/scsi/scsi_cmnd.h     |    9 +--
>  5 files changed, 24 insertions(+), 145 deletions(-)
> 
> diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
> index 8a8562a..b81350d 100644
> --- a/drivers/scsi/libsrp.c
> +++ b/drivers/scsi/libsrp.c
> @@ -427,7 +427,7 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
>  	sc->SCp.ptr = info;
>  	memcpy(sc->cmnd, cmd->cdb, MAX_COMMAND_SIZE);
>  	sc->sdb.length = len;
> -	sc->sdb.sglist = (void *) (unsigned long) addr;
> +	sc->sdb.sgt.sgl = (void *) (unsigned long) addr;
>  	sc->tag = tag;
>  	err = scsi_tgt_queue_command(sc, itn_id, (struct scsi_lun *)&cmd->lun,
>  				     cmd->tag);
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 5c8ba6a..1fd2a8c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -629,9 +629,9 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
>  		                       sizeof(scmd->sense_buffer), sense_bytes);
>  		sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
>  							      scmd->sdb.length);
> -		scmd->sdb.sglist = &ses->sense_sgl;
> +		scmd->sdb.sgt.sgl = &ses->sense_sgl;
>  		scmd->sc_data_direction = DMA_FROM_DEVICE;
> -		scmd->sdb.sg_count = 1;
> +		scmd->sdb.sgt.nents = 1;
>  		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
>  		scmd->cmnd[0] = REQUEST_SENSE;
>  		scmd->cmnd[4] = scmd->sdb.length;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a6aae56..c7107f1 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -750,136 +750,15 @@ static inline unsigned int scsi_sgtable_index(unsigned short nents)
>  	return index;
>  }
>  
> -static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb,
> -					unsigned short sg_count, gfp_t gfp_mask)
> +static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
>  {
> -	struct scsi_host_sg_pool *sgp;
> -	struct scatterlist *sgl, *prev, *ret;
> -	unsigned int index;
> -	int this, left;
> -
> -	left = sg_count;
> -	ret = prev = NULL;
> -	do {
> -		this = left;
> -		if (this > SCSI_MAX_SG_SEGMENTS) {
> -			this = SCSI_MAX_SG_SEGMENTS - 1;
> -			index = SG_MEMPOOL_NR - 1;
> -		} else
> -			index = scsi_sgtable_index(this);
> -
> -		left -= this;
> -
> -		sgp = scsi_sg_pools + index;
> -
> -		sgl = mempool_alloc(sgp->pool, gfp_mask);
> -		if (unlikely(!sgl))
> -			goto enomem;
> -
> -		sg_init_table(sgl, sgp->size);
> -
> -		/*
> -		 * first loop through, set initial index and return value
> -		 */
> -		if (!ret)
> -			ret = sgl;
> -
> -		/*
> -		 * chain previous sglist, if any. we know the previous
> -		 * sglist must be the biggest one, or we would not have
> -		 * ended up doing another loop.
> -		 */
> -		if (prev)
> -			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
> -
> -		/*
> -		 * if we have nothing left, mark the last segment as
> -		 * end-of-list
> -		 */
> -		if (!left)
> -			sg_mark_end(&sgl[this - 1]);
> -
> -		/*
> -		 * don't allow subsequent mempool allocs to sleep, it would
> -		 * violate the mempool principle.
> -		 */
> -		gfp_mask &= ~__GFP_WAIT;
> -		gfp_mask |= __GFP_HIGH;
> -		prev = sgl;
> -	} while (left);
> -
> -	/*
> -	 * ->use_sg may get modified after dma mapping has potentially
> -	 * shrunk the number of segments, so keep a copy of it for free.
> -	 */
> -	sdb->alloc_sg_count = sdb->sg_count = sg_count;
> -	sdb->sglist = ret;
> -	return 0;
> -enomem:
> -	if (ret) {
> -		/*
> -		 * Free entries chained off ret. Since we were trying to
> -		 * allocate another sglist, we know that all entries are of
> -		 * the max size.
> -		 */
> -		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
> -		prev = ret;
> -		ret = &ret[SCSI_MAX_SG_SEGMENTS - 1];
> -
> -		while ((sgl = sg_chain_ptr(ret)) != NULL) {
> -			ret = &sgl[SCSI_MAX_SG_SEGMENTS - 1];
> -			mempool_free(sgl, sgp->pool);
> -		}
> -
> -		mempool_free(prev, sgp->pool);
> -	}
> -	return -ENOMEM;
> +	return mempool_alloc(scsi_sg_pools[scsi_sgtable_index(nents)].pool,
> +								    gfp_mask);
>  }
>  
> -static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
> +static void scsi_sg_free(struct scatterlist *sgl, unsigned int nents)
>  {
> -	struct scatterlist *sgl = sdb->sglist;
> -	struct scsi_host_sg_pool *sgp;
> -
> -	/*
> -	 * if this is the biggest size sglist, check if we have
> -	 * chained parts we need to free
> -	 */
> -	if (sdb->alloc_sg_count > SCSI_MAX_SG_SEGMENTS) {
> -		unsigned short this, left;
> -		struct scatterlist *next;
> -		unsigned int index;
> -
> -		left = sdb->alloc_sg_count - (SCSI_MAX_SG_SEGMENTS - 1);
> -		next = sg_chain_ptr(&sgl[SCSI_MAX_SG_SEGMENTS - 1]);
> -		while (left && next) {
> -			sgl = next;
> -			this = left;
> -			if (this > SCSI_MAX_SG_SEGMENTS) {
> -				this = SCSI_MAX_SG_SEGMENTS - 1;
> -				index = SG_MEMPOOL_NR - 1;
> -			} else
> -				index = scsi_sgtable_index(this);
> -
> -			left -= this;
> -
> -			sgp = scsi_sg_pools + index;
> -
> -			if (left)
> -				next = sg_chain_ptr(&sgl[sgp->size - 1]);
> -
> -			mempool_free(sgl, sgp->pool);
> -		}
> -
> -		/*
> -		 * Restore original, will be freed below
> -		 */
> -		sgl = sdb->sglist;
> -		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
> -	} else
> -		sgp = scsi_sg_pools + scsi_sgtable_index(sdb->alloc_sg_count);
> -
> -	mempool_free(sgl, sgp->pool);
> +	mempool_free(sgl, scsi_sg_pools[scsi_sgtable_index(nents)].pool);
>  }
>  
>  /*
> @@ -901,15 +780,15 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
>   */
>  void scsi_release_buffers(struct scsi_cmnd *cmd)
>  {
> -	if (cmd->sdb.sglist)
> -		scsi_free_sgtable(&cmd->sdb);
> +	if (cmd->sdb.sgt.sgl)
> +		__sg_free_table(&cmd->sdb.sgt, scsi_sg_free);
>  
>  	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
>  
>  	if (scsi_bidi_cmnd(cmd)) {
>  		struct scsi_data_buffer *bidi_sdb =
>  			cmd->request->next_rq->special;
> -		scsi_free_sgtable(bidi_sdb);
> +		__sg_free_table(&bidi_sdb->sgt, scsi_sg_free);
>  		kmem_cache_free(scsi_bidi_sdb_cache, bidi_sdb);
>  		cmd->request->next_rq->special = NULL;
>  	}
> @@ -1135,9 +1014,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
>  								 gfp_t gfp_mask)
>  {
> -	int count;
> +	int count, ret;
>  
> -	if (scsi_alloc_sgtable(sdb, req->nr_phys_segments, gfp_mask)) {
> +	ret = __sg_alloc_table(&sdb->sgt, req->nr_phys_segments, gfp_mask,
> +								 scsi_sg_alloc);
> +	if (unlikely(ret)) {
> +		__sg_free_table(&sdb->sgt, scsi_sg_free);
>  		return BLKPREP_DEFER;
>  	}
>  
> @@ -1151,9 +1033,9 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
>  	 * Next, walk the list, and fill in the addresses and sizes of
>  	 * each segment.
>  	 */
> -	count = blk_rq_map_sg(req->q, req, sdb->sglist);
> -	BUG_ON(count > sdb->sg_count);
> -	sdb->sg_count = count;
> +	count = blk_rq_map_sg(req->q, req, sdb->sgt.sgl);
> +	BUG_ON(count > sdb->sgt.nents);
> +	sdb->sgt.nents = count;
>  	return BLKPREP_OK;
>  }
>  
> diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
> index 2d9a32b..0214ddb 100644
> --- a/drivers/usb/storage/isd200.c
> +++ b/drivers/usb/storage/isd200.c
> @@ -415,9 +415,9 @@ static void isd200_set_srb(struct isd200_info *info,
>  		sg_init_one(&info->sg, buff, bufflen);
>  
>  	srb->sc_data_direction = dir;
> -	srb->sdb.sglist = buff ? &info->sg : NULL;
> +	srb->sdb.sgt.sgl = buff ? &info->sg : NULL;
>  	srb->sdb.length = bufflen;
> -	srb->sdb.sg_count = buff ? 1 : 0;
> +	srb->sdb.sgt.nents = buff ? 1 : 0;
>  }
>  
>  static void isd200_srb_set_bufflen(struct scsi_cmnd *srb, unsigned bufflen)
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index cd2851a..9933bbe 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -8,16 +8,13 @@
>  #include <linux/timer.h>
>  #include <linux/scatterlist.h>
>  
> -struct scatterlist;
>  struct Scsi_Host;
>  struct scsi_device;
>  
>  struct scsi_data_buffer {
> -	struct scatterlist *sglist;
> +	struct sg_table sgt;
>  	unsigned length;
>  	int resid;
> -	unsigned short sg_count;
> -	unsigned short alloc_sg_count; /* private to scsi_lib */
>  };
>  
>  /* embedded in scsi_cmnd */
> @@ -136,12 +133,12 @@ extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
>  
>  static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
>  {
> -	return cmd->sdb.sg_count;
> +	return cmd->sdb.sgt.nents;
>  }
>  
>  static inline struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd)
>  {
> -	return cmd->sdb.sglist;
> +	return cmd->sdb.sgt.sgl;
>  }
>  
>  static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)

The cmd->sdb.sgt.sgl thingy is a bit ugly, I would say. There is
not much we can do, unless Jens is willing to add the "length" and
"resid" members into his struct sg_table. I guess other drivers might
have use for them other than scsi. Jens could you do this for us?

Boaz


