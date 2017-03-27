From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] sd: Consider max_xfer_blocks if opt_xfer_blocks is
 unusable
Date: Mon, 27 Mar 2017 12:06:51 -0400 (EDT)
Message-ID: <1570359368.7021305.1490630811310.JavaMail.zimbra@redhat.com>
References: <20170327141831.20936-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751124AbdC0QH0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Mar 2017 12:07:26 -0400
In-Reply-To: <20170327141831.20936-1-famz@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>



----- Original Message -----
> From: "Fam Zheng" <famz@redhat.com>
> To: linux-kernel@vger.kernel.org
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, famz@redhat.com, linux-scsi@vger.kernel.org, "James E.J.
> Bottomley" <jejb@linux.vnet.ibm.com>
> Sent: Monday, March 27, 2017 10:18:31 AM
> Subject: [PATCH] sd: Consider max_xfer_blocks if opt_xfer_blocks is unusable
> 
> If device reports a small max_xfer_blocks and a zero opt_xfer_blocks, we
> end up using BLK_DEF_MAX_SECTORS, which is wrong and r/w of that size
> may get error.
> 
> Fixes: ca369d51b3e ("block/sd: Fix device-imposed transfer length limits")
> Signed-off-by: Fam Zheng <famz@redhat.com>
> ---
>  drivers/scsi/sd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index fcfeddc..e2e21ab 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2957,6 +2957,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
>  	} else
>  		rw_max = BLK_DEF_MAX_SECTORS;
> +	rw_max = min_not_zero(rw_max, dev_max);
>  
>  	/* Combine with controller limits */
>  	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
> --
> 2.9.3
> 
> 
Looks good to me and addresses the issue we faced.
FInal confirmation this change is OK to come from Martin or James.

Reviewed-by: Laurence Oberman <loberman@redhat.com>
