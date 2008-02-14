From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: bidi bio map failure fix
Date: Thu, 14 Feb 2008 20:57:21 +0900
Message-ID: <20080214205721V.fujita.tomonori@lab.ntt.co.jp>
References: <20080212204024.GA13643@osc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:51047 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbYBNL5s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 06:57:48 -0500
In-Reply-To: <20080212204024.GA13643@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pw@osc.edu, James.Bottomley@HansenPartnership.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

On Tue, 12 Feb 2008 15:40:24 -0500
Pete Wyckoff <pw@osc.edu> wrote:

> If blk_rq_map_user requires more than one bio, and fails mapping
> somewhere after the first bio, it will return with rq->bio set to
> non-NULL, but it will have already unmapped the partial bio.  The
> "out:" error exit section will see the non-null bio and try to unmap
> it again, triggering a mapcount bug via bad_page().
> 
> Signed-off-by: Pete Wyckoff <pw@osc.edu>
> ---
>  block/bsg.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 3337125..bba7154 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -295,8 +295,10 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
>  
>  		dxferp = (void*)(unsigned long)hdr->din_xferp;
>  		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
> -		if (ret)
> +		if (ret) {
> +			next_rq->bio = NULL;  /* do not unmap twice */
>  			goto out;
> +		}
>  	}
>  
>  	if (hdr->dout_xfer_len) {

Thanks!

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

James, please put this to the scsi-fixes tree.
