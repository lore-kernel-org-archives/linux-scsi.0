From: Oskar Andero <oskar.andero@sonymobile.com>
Subject: Re: [PATCH] scsi: fix null pointer dereference in sd_revalidate_disk
Date: Mon, 8 Apr 2013 13:42:58 +0200
Message-ID: <20130408114251.GK2481@caracas.corpusers.net>
References: <1362663400-9517-1-git-send-email-oskar.andero@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19443 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761649Ab3DHLnC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Apr 2013 07:43:02 -0400
Content-Disposition: inline
In-Reply-To: <1362663400-9517-1-git-send-email-oskar.andero@sonymobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>, "Itou, Syunsuke X" <Syunsuke.X.Itou@sonymobile.com>

On 14:36 Thu 07 Mar     , oskar.andero@sonymobile.com wrote:
> From: "syunsuke.x.itou" <syunsuke.x.itou@sonymobile.com>
> 
> By repeatadly connecting/disconnecting a USB masstorage device
> a null pointer dereference can be provoked. This is caused by
> sd_revalidate_disk() assuming sdkp to be a valid pointer. This
> patch adds a null pointer check.
> 
> Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> Signed-off-by: syunsuke.x.itou <syunsuke.x.itou@sonymobile.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>  drivers/scsi/sd.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 7992635..49849ce 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1,6 +1,7 @@
>  /*
>   *      sd.c Copyright (C) 1992 Drew Eckhardt
>   *           Copyright (C) 1993, 1994, 1995, 1999 Eric Youngdale
> + *           Copyright (C) 2013 Sony Mobile Communications AB.
>   *
>   *      Linux scsi disk driver
>   *              Initial versions: Drew Eckhardt
> @@ -2653,10 +2654,14 @@ static int sd_try_extended_inquiry(struct scsi_device *sdp)
>  static int sd_revalidate_disk(struct gendisk *disk)
>  {
>  	struct scsi_disk *sdkp = scsi_disk(disk);
> -	struct scsi_device *sdp = sdkp->device;
> +	struct scsi_device *sdp;
>  	unsigned char *buffer;
>  	unsigned flush = 0;
>  
> +	if (!sdkp)
> +		return -ENODEV;
> +	sdp = sdkp->device;
> +
>  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
>  				      "sd_revalidate_disk\n"));
>  
> -- 
> 1.7.8.6
> 

Ping. Any input on the patch above?

Thanks,

-Oskar
