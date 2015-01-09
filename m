From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: ->queue_rq can't sleep
Date: Fri, 9 Jan 2015 03:51:17 -0800
Message-ID: <20150109115117.GA26918@infradead.org>
References: <1420640453-3493-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58022 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbbAILvU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2015 06:51:20 -0500
Content-Disposition: inline
In-Reply-To: <1420640453-3493-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>

Any chance to get a review / ack for this one?

On Wed, Jan 07, 2015 at 03:20:53PM +0100, Christoph Hellwig wrote:
> The blk-mq ->queue_rq method is always called from process context,
> but might have preemption disabled.  This means we still always
> have to use GFP_ATOMIC for memory allocations, and thus need to
> revert part of commit 3c356bde1 ("scsi: stop passing a gfp_mask
> argument down the command setup path").
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/scsi/scsi_lib.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9ea95dd..6d5c0b8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -591,7 +591,6 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb, bool mq)
>  static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
>  {
>  	struct scatterlist *first_chunk = NULL;
> -	gfp_t gfp_mask = mq ? GFP_NOIO : GFP_ATOMIC;
>  	int ret;
>  
>  	BUG_ON(!nents);
> @@ -606,7 +605,7 @@ static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
>  	}
>  
>  	ret = __sg_alloc_table(&sdb->table, nents, SCSI_MAX_SG_SEGMENTS,
> -			       first_chunk, gfp_mask, scsi_sg_alloc);
> +			       first_chunk, GFP_ATOMIC, scsi_sg_alloc);
>  	if (unlikely(ret))
>  		scsi_free_sgtable(sdb, mq);
>  	return ret;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
