From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH 3/4] bsg: add SCSI transport-level request support
Date: Sat, 9 Jun 2007 08:59:36 -0400
Message-ID: <20070609125936.GB1714@osc.edu>
References: <20070608133042I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:53849 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473AbXFINWW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jun 2007 09:22:22 -0400
Content-Disposition: inline
In-Reply-To: <20070608133042I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

fujita.tomonori@lab.ntt.co.jp wrote on Sat, 09 Jun 2007 00:12 +0900:
> SCSI transport-level requests such as SAS management protocol (SMP)
> skip blk_verify_command().
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  block/bsg.c         |   27 +++++++++++++++++++++------
>  include/linux/bsg.h |    6 ++++++
>  2 files changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 13ecc95..f2a9979 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -208,7 +208,11 @@ static int blk_fill_sgv4_hdr_rq(request_
>  	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
>  			   hdr->request_len))
>  		return -EFAULT;
> -	if (blk_verify_command(rq->cmd, has_write_perm))
> +
> +	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
> +		if (blk_verify_command(rq->cmd, has_write_perm))
> +			return -EPERM;
> +	} else if (capable(CAP_SYS_RAWIO))
>  		return -EPERM;

Do you mean !capable here?

		-- Pete
