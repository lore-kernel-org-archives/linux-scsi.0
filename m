From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: check for bigger value first
Date: Mon, 23 Feb 2015 13:02:03 -0500
Message-ID: <54EB6B1B.2050604@interlog.com>
References: <1420578198-24241-1-git-send-email-andy.shevchenko@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51731 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbbBWSCV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2015 13:02:21 -0500
In-Reply-To: <1420578198-24241-1-git-send-email-andy.shevchenko@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>, "Ewan D . Milne" <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 15-01-06 04:03 PM, Andy Shevchenko wrote:
> Even for signed types we have to check for bigger positive value first.
> Otherwise it will be never happened.
>
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 8bcf6ad..a34df1d 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4850,10 +4850,10 @@ static int __init scsi_debug_init(void)
>   	/* play around with geometry, don't waste too much on track 0 */
>   	sdebug_heads = 8;
>   	sdebug_sectors_per = 32;
> -	if (scsi_debug_dev_size_mb >= 16)
> -		sdebug_heads = 32;
> -	else if (scsi_debug_dev_size_mb >= 256)
> +	if (scsi_debug_dev_size_mb >= 256)
>   		sdebug_heads = 64;
> +	else if (scsi_debug_dev_size_mb >= 16)
> +		sdebug_heads = 32;
>   	sdebug_cylinders_per = (unsigned long)sdebug_capacity /
>   			       (sdebug_sectors_per * sdebug_heads);
>   	if (sdebug_cylinders_per >= 1024) {
>

