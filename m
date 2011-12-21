From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] block: fix blk_queue_end_tag()
Date: Wed, 21 Dec 2011 14:33:40 +0800
Message-ID: <4EF17DC4.5010008@tao.ma>
References: <20111220233117.17757.71139.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:37158 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751214Ab1LUGdo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2011 01:33:44 -0500
In-Reply-To: <20111220233117.17757.71139.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, Tao Ma <boyu.mt@taobao.com>, Meelis Roos <mroos@ut.ee>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ed Nadolski <edmund.nadolski@intel.com>

On 12/21/2011 07:33 AM, Dan Williams wrote:
> Commit 5e081591 "block: warn if tag is greater than real_max_depth"
> cleaned up blk_queue_end_tag() to warn when the tag is truly invalid
> (greater than real_max_depth).  However, it changed behavior in the tag
> < max_depth case to not end the request.  Leading to triggering of
> BUG_ON(blk_queued_rq(rq)) in the request completion path:
> 
>   http://marc.info/?l=linux-kernel&m=132204370518629&w=2
> 
> In order to allow blk_queue_resize_tags() to shrink the tag space
> blk_queue_end_tag() must always complete tags with a value less than
> real_max_depth regardless of the current max_depth.
> 
> Cc: Tao Ma <boyu.mt@taobao.com>
> Reported-by: Meelis Roos <mroos@ut.ee>
> Reported-by: Ed Nadolski <edmund.nadolski@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Functionally the same as Tao Ma's fix [1], but just moves the warn into the
> if() directly.
> 
> [1]: http://marc.info/?l=linux-scsi&m=132439698602441&w=2
> 
> --
> Dan
> 
>  block/blk-tag.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-tag.c b/block/blk-tag.c
> index e74d6d1..6e61262 100644
> --- a/block/blk-tag.c
> +++ b/block/blk-tag.c
> @@ -286,12 +286,13 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
>  
>  	BUG_ON(tag == -1);
>  
> -	if (unlikely(tag >= bqt->max_depth)) {
> +	if (WARN_ONCE(tag >= bqt->real_max_depth,
> +		      "%s: tag %d greater than tag map size: %d\n",
> +		      __func__, tag, bqt->real_max_depth)) {
>  		/*
>  		 * This can happen after tag depth has been reduced.
Please also change the comments here since it should never happen in the
right workload.

Thanks
Tao
>  		 * But tag shouldn't be larger than real_max_depth.
>  		 */
> -		WARN_ON(tag >= bqt->real_max_depth);
>  		return;
>  	}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

