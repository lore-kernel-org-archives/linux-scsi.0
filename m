From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] block: integrate blk_end_bidi_request into blk_end_request
Date: Sun, 30 Nov 2008 13:10:31 +0200
Message-ID: <493274A7.5050404@panasas.com>
References: <20081128145221I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:3362 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751162AbYK3LKf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 06:10:35 -0500
In-Reply-To: <20081128145221I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

FUJITA Tomonori wrote:
> Hi Jens,
> 
> FC people have been working on FC pass thru feature using bsg bidi
> support. Seems that the bidi API confuse them:
> 
> http://marc.info/?l=linux-scsi&m=122704347209856&w=2
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> [PATCH] block: integrate blk_end_bidi_request with blk_end_request
> 
> This integrates blk_end_bidi_request into blk_end_request. IOW, it
> changes blk_end_request to handle both bidi and non-bidi requests and
> removes blk_end_bidi_request.
> 
> Currently, we have two functions to complete a request,
> blk_end_bidi_request and blk_end_request. The former is for bidi
> requests and the latter is for non-bidi. This seems to confuse
> developers. Questions like "can blk_end_bidi_request be used with
> non-bidi requests?", "what should be passed as the bidi_bytes argument
> in blk_end_bidi_request" are often asked.
> 
> The callers don't care about whether a request is bidi or not. All
> they want to do is to complete a request. I think that a single
> function that can complete any request would be easy to understand.
> 
> We always must complete all bytes on both sides with bidi. So
> blk_end_request easily can do it for the callers and handle both both
> bidi and non-bidi requests.
> 
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

NACK by Boaz Harrosh.

> ---
>  block/blk-core.c        |   35 +++++++++++++----------------------
>  drivers/scsi/scsi_lib.c |    3 +--
>  include/linux/blkdev.h  |    2 --
>  3 files changed, 14 insertions(+), 26 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 10e8a64..634f918 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1943,7 +1943,19 @@ static int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
>   **/
>  int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
>  {
> -	return blk_end_io(rq, error, nr_bytes, 0, NULL);
> + 	unsigned int bidi_bytes	= 0;
> +
> +	if (blk_bidi_rq(rq)) {
> +		struct bio *bio;
> +		/*
> +		 * We can't use rq->next_rq->data_len here because the
> +		 * callers might set it to a residual length.
> +		 */
> +		__rq_for_each_bio(bio, rq->next_rq)
> +			bidi_bytes += bio->bi_size;

No. I do not want a loop to calculate the size here. This is ugly.
I have this information, and I just lost it do to BAD API.

Since we do not want to change all users of blk_end_request. (We should,
but we are too lazy. I'm). Then please just let blk_end_bidi_request()
be. Confused users will be corrected.

Perhaps we can put a comment above blk_end_bidi_request() that it can
be used for both bidi or uni commands, so users will confuse less.

> +	}
> +
> +	return blk_end_io(rq, error, nr_bytes, bidi_bytes, NULL);
>  }
>  EXPORT_SYMBOL_GPL(blk_end_request);
>  
> @@ -1974,27 +1986,6 @@ int __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
>  EXPORT_SYMBOL_GPL(__blk_end_request);
>  
>  /**
> - * blk_end_bidi_request - Helper function for drivers to complete bidi request.
> - * @rq:         the bidi request being processed
> - * @error:      %0 for success, < %0 for error
> - * @nr_bytes:   number of bytes to complete @rq
> - * @bidi_bytes: number of bytes to complete @rq->next_rq
> - *
> - * Description:
> - *     Ends I/O on a number of bytes attached to @rq and @rq->next_rq.
> - *
> - * Return:
> - *     %0 - we are done with this request
> - *     %1 - still buffers pending for this request
> - **/
> -int blk_end_bidi_request(struct request *rq, int error, unsigned int nr_bytes,
> -			 unsigned int bidi_bytes)
> -{
> -	return blk_end_io(rq, error, nr_bytes, bidi_bytes, NULL);
> -}
> -EXPORT_SYMBOL_GPL(blk_end_bidi_request);
> -
> -/**
>   * blk_update_request - Special helper function for request stacking drivers
>   * @rq:           the request being processed
>   * @error:        %0 for success, < %0 for error
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f5d3b96..e550e3b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -842,13 +842,12 @@ static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
>  {
>  	struct request *req = cmd->request;
>  	unsigned int dlen = req->data_len;
> -	unsigned int next_dlen = req->next_rq->data_len;
>  
>  	req->data_len = scsi_out(cmd)->resid;
>  	req->next_rq->data_len = scsi_in(cmd)->resid;
>  
>  	/* The req and req->next_rq have not been completed */
> -	BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));
> +	BUG_ON(blk_end_request(req, 0, dlen));
>  
>  	scsi_release_buffers(cmd);
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index a135256..2a22755 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -799,8 +799,6 @@ extern int blk_end_request(struct request *rq, int error,
>  				unsigned int nr_bytes);
>  extern int __blk_end_request(struct request *rq, int error,
>  				unsigned int nr_bytes);
> -extern int blk_end_bidi_request(struct request *rq, int error,
> -				unsigned int nr_bytes, unsigned int bidi_bytes);
>  extern void end_request(struct request *, int);
>  extern int blk_end_request_callback(struct request *rq, int error,
>  				unsigned int nr_bytes,

Boaz
