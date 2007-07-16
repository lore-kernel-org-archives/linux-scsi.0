From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 03/33] block: convert to using sg helpers
Date: Mon, 16 Jul 2007 21:21:32 +0200
Message-ID: <200707162121.32936.bzolnier@gmail.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792672399-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:57192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769AbXGPTED (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 15:04:03 -0400
Received: by ug-out-1314.google.com with SMTP id j3so1043767ugf
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2007 12:04:02 -0700 (PDT)
In-Reply-To: <11845792672399-git-send-email-jens.axboe@oracle.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


Hi,

On Monday 16 July 2007, Jens Axboe wrote:
> Convert the main rq mapper (blk_rq_map_sg()) to the sg helper setup.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  block/ll_rw_blk.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> index ef42bb2..ab71087 100644
> --- a/block/ll_rw_blk.c
> +++ b/block/ll_rw_blk.c
> @@ -30,6 +30,7 @@
>  #include <linux/cpu.h>
>  #include <linux/blktrace_api.h>
>  #include <linux/fault-inject.h>
> +#include <linux/scatterlist.h>
>  
>  /*
>   * for max sense size
> @@ -1307,9 +1308,11 @@ static int blk_hw_contig_segment(request_queue_t *q, struct bio *bio,
>   * map a request to scatterlist, return number of sg entries setup. Caller
>   * must make sure sg can hold rq->nr_phys_segments entries
>   */
> -int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg)
> +int blk_rq_map_sg(request_queue_t *q, struct request *rq,
> +		  struct scatterlist *sglist)
>  {
>  	struct bio_vec *bvec, *bvprv;
> +	struct scatterlist *next_sg, *sg;
>  	struct bio *bio;
>  	int nsegs, i, cluster;
>  
> @@ -1320,6 +1323,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
>  	 * for each bio in rq
>  	 */
>  	bvprv = NULL;
> +	sg = next_sg = &sglist[0];
>  	rq_for_each_bio(bio, rq) {
>  		/*
>  		 * for each segment in bio
> @@ -1328,7 +1332,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
>  			int nbytes = bvec->bv_len;
>  
>  			if (bvprv && cluster) {
> -				if (sg[nsegs - 1].length + nbytes > q->max_segment_size)
> +				if (sg->length + nbytes > q->max_segment_size)
>  					goto new_segment;
>  
>  				if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
> @@ -1336,14 +1340,15 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
>  				if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
>  					goto new_segment;
>  
> -				sg[nsegs - 1].length += nbytes;
> +				sg->length += nbytes;
>  			} else {
>  new_segment:
> -				memset(&sg[nsegs],0,sizeof(struct scatterlist));

Is this intended?  If so why this is no longer needed?

> -				sg[nsegs].page = bvec->bv_page;
> -				sg[nsegs].length = nbytes;
> -				sg[nsegs].offset = bvec->bv_offset;
> +				sg = next_sg;
> +				next_sg = sg_next(sg);
>  
> +				sg->page = bvec->bv_page;
> +				sg->length = nbytes;
> +				sg->offset = bvec->bv_offset;
>  				nsegs++;
>  			}
>  			bvprv = bvec;
