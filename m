From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: call blk_rq_map_user only for commands with data  transfer
Date: Sat, 25 Nov 2006 09:54:29 +0100
Message-ID: <20061125085427.GH5400@kernel.dk>
References: <200611250122.kAP1MvHi021546@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:47957 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S934217AbWKYIy0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Nov 2006 03:54:26 -0500
Content-Disposition: inline
In-Reply-To: <200611250122.kAP1MvHi021546@r-dd.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Sat, Nov 25 2006, FUJITA Tomonori wrote:
> bsg_map_hdr always calls blk_rq_map_user so commands without data
> transfer fail.
> 
> This is against the bsg branch in the block tree.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  block/bsg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 5d23f97..65729fd 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -301,7 +301,7 @@ bsg_map_hdr(struct bsg_device *bd, int r
>  		return ERR_PTR(ret);
>  	}
>  
> -	if (!hdr->iovec_count) {
> +	if (!hdr->iovec_count && hdr->dxfer_len) {
>  		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len);
>  		if (ret)
>  			goto out;

Good point, thanks!

-- 
Jens Axboe

