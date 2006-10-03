From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [RFC] [PATCH] helper function for retrieving scsi_cmd given host based block layer tag
Date: Tue, 3 Oct 2006 11:06:07 -0700
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC074A3F84@AVEXCH1.qlogic.org>
References: <1158962434.4040.35.camel@dcslnxpc.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:31418 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S964787AbWJCSGJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Oct 2006 14:06:09 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1158962434.4040.35.camel@dcslnxpc.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, David Wagner <david.wagner@qlogic.com>

> From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of David C
> Somayajulu
> Sent: Friday, September 22, 2006 3:01 PM
> To: Jens Axboe
> Cc: James Bottomley; linux-scsi@vger.kernel.org; Mike Christie; Doug
Maxey; David Wagner
> > I wonder if you are using the 'block' branch, not just the master
> > branch? It seems to apply perfectly there, but that is just the same
as
> > Linus' tree. So when you have cloned the block git repo, there are a
> > number of branches you can work against. The main branch with
current
> > changes is the 'block' branch, that is what you want to be making
> > patches against.
> >
> > I'll be away for the entire next week, so no rush on my end.
> >
> I think I got it right this time. Here it is.
> Thanks
> David Somayajulu
Jens,
I would appreciate if you can let me know if the last post of the above
patch was acceptable.
Thanks
David Somayajulu
> ---
> 
> diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> index 4475fa4..a4a72bd 100644
> --- a/block/ll_rw_blk.c
> +++ b/block/ll_rw_blk.c
> @@ -840,12 +840,7 @@ EXPORT_SYMBOL(blk_queue_dma_alignment);
>   **/
>  struct request *blk_queue_find_tag(request_queue_t *q, int tag)
>  {
> -	struct blk_queue_tag *bqt = q->queue_tags;
> -
> -	if (unlikely(bqt == NULL || tag >= bqt->real_max_depth))
> -		return NULL;
> -
> -	return bqt->tag_index[tag];
> +	return blk_map_queue_find_tag(q->queue_tags, tag);
>  }
> 
>  EXPORT_SYMBOL(blk_queue_find_tag);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c55d470..10fd39d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -766,6 +766,14 @@ extern int blk_queue_resize_tags(request
>  extern void blk_queue_invalidate_tags(request_queue_t *);
>  extern long blk_congestion_wait(int rw, long timeout);
> 
> +static inline struct request *blk_map_queue_find_tag(struct
blk_queue_tag *bqt,
> +						int tag)
> +{
> +	if (unlikely(bqt == NULL || tag >= bqt->real_max_depth))
> +		return NULL;
> +	return bqt->tag_index[tag];
> +}
> +
>  extern void blk_rq_bio_prep(request_queue_t *, struct request *,
struct bio *);
>  extern int blkdev_issue_flush(struct block_device *, sector_t *);
> 
> diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
> index d1d9b10..01b7481 100644
> --- a/include/scsi/scsi_tcq.h
> +++ b/include/scsi/scsi_tcq.h
> @@ -131,5 +131,25 @@ static inline struct scsi_cmnd *scsi_fin
>  	return sdev->current_cmnd;
>  }
> 
> +/**
> + * scsi_host_find_tag - find the tagged command by host
> + * @shost:	pointer to scsi_host
> + * @tag:	tag of the scsi_cmnd
> + *
> + * Notes:
> + *	Only works with tags allocated by the generic blk layer.
> + **/
> +static inline struct scsi_cmnd *scsi_host_find_tag(struct Scsi_Host
*shost,
> +						int tag)
> +{
> +	struct request *req;
> +
> +	if (tag != SCSI_NO_TAG) {
> +		req = blk_map_queue_find_tag(shost->bqt, tag);
> +		return req ? (struct scsi_cmnd *)req->special : NULL;
> +	}
> +	return NULL;
> +}
> +
>  #endif /* CONFIG_BLOCK */
>  #endif /* _SCSI_SCSI_TCQ_H */
> 
