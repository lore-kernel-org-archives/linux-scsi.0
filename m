From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] [SCSI] a3000: use module_platform_driver_probe()
Date: Tue, 05 Mar 2013 09:08:42 +0000
Message-ID: <1362474522.22821.8.camel@dabdike.int.hansenpartnership.com>
References: <005601ce1953$5b83b020$128b1060$%han@samsung.com>
	 <005701ce1953$77188a40$65499ec0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55938 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851Ab3CEJIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Mar 2013 04:08:47 -0500
In-Reply-To: <005701ce1953$77188a40$65499ec0$%han@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-scsi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On Tue, 2013-03-05 at 12:42 +0900, Jingoo Han wrote:
> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.

These drivers are in deep maintenance mode.  Unless you can find someone
to actually test the changes, we err on the side of not touching the
code except for serious bugs.

I've cc'd Geert because he may actually have one of these things.

James


> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/scsi/a3000.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
> index e29fe0e..519832d 100644
> --- a/drivers/scsi/a3000.c
> +++ b/drivers/scsi/a3000.c
> @@ -279,18 +279,7 @@ static struct platform_driver
> amiga_a3000_scsi_driver = {
>         },
>  };
>  
> -static int __init amiga_a3000_scsi_init(void)
> -{
> -       return platform_driver_probe(&amiga_a3000_scsi_driver,
> -                                    amiga_a3000_scsi_probe);
> -}
> -module_init(amiga_a3000_scsi_init);
> -
> -static void __exit amiga_a3000_scsi_exit(void)
> -{
> -       platform_driver_unregister(&amiga_a3000_scsi_driver);
> -}
> -module_exit(amiga_a3000_scsi_exit);
> +module_platform_driver_probe(amiga_a3000_scsi_driver,
> amiga_a3000_scsi_probe);
>  
>  MODULE_DESCRIPTION("Amiga 3000 built-in SCSI");
>  MODULE_LICENSE("GPL");
> -- 
> 1.7.2.5

