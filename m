From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH v1 1/1] scsi_debug: check for bigger value first
Date: Mon, 30 Nov 2015 08:55:03 -0500
Message-ID: <1448891703.4067.79.camel@localhost.localdomain>
References: <1448562170-122075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbbK3NzF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Nov 2015 08:55:05 -0500
In-Reply-To: <1448562170-122075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Andy Shevchenko <andy.shevchenko@gmail.com>

On Thu, 2015-11-26 at 20:22 +0200, Andy Shevchenko wrote:
> From: Andy Shevchenko <andy.shevchenko@gmail.com>
> 
> Even for signed types we have to check for bigger positive value first.
> Otherwise it will be never happened.
> 
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> ---
>  drivers/scsi/scsi_debug.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index dfcc45b..f773b34 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4846,10 +4846,10 @@ static int __init scsi_debug_init(void)
>  	/* play around with geometry, don't waste too much on track 0 */
>  	sdebug_heads = 8;
>  	sdebug_sectors_per = 32;
> -	if (scsi_debug_dev_size_mb >= 16)
> -		sdebug_heads = 32;
> -	else if (scsi_debug_dev_size_mb >= 256)
> +	if (scsi_debug_dev_size_mb >= 256)
>  		sdebug_heads = 64;
> +	else if (scsi_debug_dev_size_mb >= 16)
> +		sdebug_heads = 32;
>  	sdebug_cylinders_per = (unsigned long)sdebug_capacity /
>  			       (sdebug_sectors_per * sdebug_heads);
>  	if (sdebug_cylinders_per >= 1024) {

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


