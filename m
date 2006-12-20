From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/6] bsg: add sg_io_v4 structure
Date: Wed, 20 Dec 2006 11:13:14 +0100
Message-ID: <20061220101314.GL5010@kernel.dk>
References: <20061220144309O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:5642 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbWLTKL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Dec 2006 05:11:28 -0500
Content-Disposition: inline
In-Reply-To: <20061220144309O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

On Wed, Dec 20 2006, FUJITA Tomonori wrote:
> This patch adds sg_io_v4 structure that Doug proposed last month.
> 
> There's one major change from the RFC. I dropped iovec, which needs
> compat stuff. The bsg code simply calls blk_rq_map_user against
> dout_xferp/din_xferp. So if possible, the page frames are directly
> mapped. If not possible, the block layer allocates new page frames and
> does memory copies.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  include/linux/bsg.h |   43 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/bsg.h b/include/linux/bsg.h
> index dc0d728..0d212cc 100644
> --- a/include/linux/bsg.h
> +++ b/include/linux/bsg.h
> @@ -1,6 +1,47 @@
>  #ifndef BSG_H
>  #define BSG_H
>  
> +struct sg_io_v4 {
> +	int32_t guard;		/* [i] 'Q' to differentiate from v3 */
> +	uint32_t protocol;	/* [i] 0 -> SCSI , .... */

I prefer using the u32 types and so on for explicitly sized variables.
I'll make that change.

-- 
Jens Axboe

