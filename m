From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH 2/2] SG: Convert SCSI to use scatterlist helpers for sg
 chaining
Date: Wed, 14 Nov 2007 14:29:53 +0200
Message-ID: <473AEA41.8010304@panasas.com>
References: <20071114114620.GA5064@kernel.dk> <20071114114732.GC5064@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa2.bezeqint.net ([192.115.104.16]:50061 "EHLO sa2.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbXKNNGu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2007 08:06:50 -0500
In-Reply-To: <20071114114732.GC5064@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Nov. 14, 2007, 13:47 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
>>From 7b2421e1c075d3c262e28d0598608141add2e7da Mon Sep 17 00:00:00 2001
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Wed, 14 Nov 2007 12:36:47 +0100
> Subject: [PATCH] SG: Convert SCSI to use scatterlist helpers for sg chaining
> 
> Also change scsi_alloc_sgtable() to just return 0/failure, since it
> maps to the command passed in. ->request_buffer is now no longer needed,
> once drivers are adapted to use scsi_sglist() it can be killed.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/scsi/scsi_lib.c     |  137 ++++++-------------------------------------
>  drivers/scsi/scsi_tgt_lib.c |    3 +-
>  include/scsi/scsi_cmnd.h    |    7 +-
>  3 files changed, 23 insertions(+), 124 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0e81e4c..1fb3c2e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -737,138 +737,40 @@ static inline unsigned int scsi_sgtable_index(unsigned short nents)
>  	return index;
>  }
>  
> -struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
> +static void scsi_sg_free(struct scatterlist *sgl, unsigned int nents)
>  {
>  	struct scsi_host_sg_pool *sgp;
> -	struct scatterlist *sgl, *prev, *ret;
> -	unsigned int index;
> -	int this, left;
> -
> -	BUG_ON(!cmd->use_sg);
> -
> -	left = cmd->use_sg;
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
>  
> -		sgp = scsi_sg_pools + index;
> -
> -		sgl = mempool_alloc(sgp->pool, gfp_mask);
> -		if (unlikely(!sgl))
> -			goto enomem;
> +	sgp = scsi_sg_pools + scsi_sgtable_index(nents);
> +	mempool_free(sgl, sgp->pool);
> +}
>  
> -		sg_init_table(sgl, sgp->size);
> +static struct scatterlist *scsi_sg_alloc(unsigned int nents, gfp_t gfp_mask)
> +{
> +	struct scsi_host_sg_pool *sgp;
>  
> -		/*
> -		 * first loop through, set initial index and return value
> -		 */
> -		if (!ret)
> -			ret = sgl;
> +	sgp = scsi_sg_pools + scsi_sgtable_index(nents);
> +	return mempool_alloc(sgp->pool, gfp_mask);
> +}
>  
> -		/*
> -		 * chain previous sglist, if any. we know the previous
> -		 * sglist must be the biggest one, or we would not have
> -		 * ended up doing another loop.
> -		 */
> -		if (prev)
> -			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
> +int scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
> +{
> +	int ret;
>  
> -		/*
> -		 * if we have nothing left, mark the last segment as
> -		 * end-of-list
> -		 */
> -		if (!left)
> -			sg_mark_end(&sgl[this - 1]);
> +	BUG_ON(!cmd->use_sg);
>  
> -		/*
> -		 * don't allow subsequent mempool allocs to sleep, it would
> -		 * violate the mempool principle.
> -		 */
> -		gfp_mask &= ~__GFP_WAIT;
> -		gfp_mask |= __GFP_HIGH;
> -		prev = sgl;
> -	} while (left);
> +	ret = __sg_alloc_table(&cmd->sg_table, cmd->use_sg, gfp_mask,
> +					scsi_sg_alloc, scsi_sg_free);
>  
> -	/*
> -	 * ->use_sg may get modified after dma mapping has potentially
> -	 * shrunk the number of segments, so keep a copy of it for free.
> -	 */
> -	cmd->__use_sg = cmd->use_sg;
> +	cmd->request_buffer = cmd->sg_table.sgl;
>  	return ret;
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
> -	return NULL;
>  }
>  
>  EXPORT_SYMBOL(scsi_alloc_sgtable);

<snip>

> @@ -128,14 +127,14 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
>  				 size_t *offset, size_t *len);
>  extern void scsi_kunmap_atomic_sg(void *virt);
>  
> -extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
> +extern int scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);


This becomes even nicer on top of the last sdb patches that Boaz sent:
http://www.spinics.net/lists/linux-scsi/msg20947.html
and
http://www.spinics.net/lists/linux-scsi/msg20948.html

that unexport this scsi_alloc_sgtable and make it look like this:
+static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb,
+					unsigned short sg_count, gfp_t gfp_mask)
