From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch] scsi/osd: checking NULL instead of ERR_PTR()
Date: Sun, 14 Nov 2010 15:39:53 +0200
Message-ID: <4CDFE6A9.10704@panasas.com>
References: <20101112043146.GC3533@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:32178 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755532Ab0KNNzL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Nov 2010 08:55:11 -0500
In-Reply-To: <20101112043146.GC3533@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Benny Halevy <bhalevy@panasas.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 11/12/2010 06:31 AM, Dan Carpenter wrote:
> bio_map_kern() returns ERR_PTRs on failure and never returns NULL.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Acked-by: Boaz Harrosh <bharrosh@panasas.com>

> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 0433ea6..b798919 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -951,8 +951,8 @@ static int _osd_req_finalize_cdb_cont(struct osd_request *or, const u8 *cap_key)
>  	/* create a bio for continuation segment */
>  	bio = bio_map_kern(req_q, or->cdb_cont.buff, or->cdb_cont.total_bytes,
>  			   GFP_KERNEL);
> -	if (unlikely(!bio))
> -		return -ENOMEM;
> +	if (unlikely(IS_ERR(bio)))
> +		return PTR_ERR(bio);
>  
>  	bio->bi_rw |= REQ_WRITE;
>  

Wahoo, good catch, thanks! This is new code in 2.6.37-rc1. It should be pushed
for current Kernel.

James: please apply to scsi-rc-fixes for the next round of fixes?

Thanks
Boaz
