From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/2] sg: use ALIGN macro
Date: Sun, 15 Feb 2009 01:17:19 +0100
Message-ID: <49975F0F.3040702@interlog.com>
References: <1234374177-6192-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1234374177-6192-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49074 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbZBOARX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Feb 2009 19:17:23 -0500
In-Reply-To: <1234374177-6192-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

FUJITA Tomonori wrote:
> This changes sg_build_indirect() to use ALIGN macro instead of
> calculating by hand.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/sg.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index d17d89b..b459864 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -98,7 +98,6 @@ static int scatter_elem_sz = SG_SCATTER_SZ;
>  static int scatter_elem_sz_prev = SG_SCATTER_SZ;
>  
>  #define SG_SECTOR_SZ 512
> -#define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
>  
>  static int sg_add(struct device *, struct class_interface *);
>  static void sg_remove(struct device *, struct class_interface *);
> @@ -1723,8 +1722,8 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
>  		return -EFAULT;
>  	if (0 == blk_size)
>  		++blk_size;	/* don't know why */
> -/* round request up to next highest SG_SECTOR_SZ byte boundary */
> -	blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);
> +	/* round request up to next highest SG_SECTOR_SZ byte boundary */
> +	blk_size = ALIGN(blk_size, SG_SECTOR_SZ);
>  	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d, blk_size=%d\n",
>  				   buff_size, blk_size));
>  

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

