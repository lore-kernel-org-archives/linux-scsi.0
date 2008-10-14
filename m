From: Sam Creasey <sammy@sammy.net>
Subject: Re: [PATCH 2/2] drivers/scsi/sun3x_esp.c: Convert && to ||
Date: Tue, 14 Oct 2008 12:40:43 -0400
Message-ID: <20081014164043.GS10918@sammy.net>
References: <Pine.LNX.4.64.0810141759520.20451@pc-004.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from anhedonia.sammy.net ([72.46.127.32]:58530 "EHLO
	anhedonia.sammy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYJNQks (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2008 12:40:48 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810141759520.20451@pc-004.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Tue, Oct 14, 2008 at 06:00:19PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The pattern !E && !E->fld is nonsensical.  The patch below updates this
> according to the assumption that && should be ||.  But perhaps another
> solution was intended.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @disable and_comm@
> expression E;
> identifier fld;
> @@
> 
> - !E && !E->fld
> + !E || !E->fld
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-By: Sam Creasey <sammy@sammy.net>

I doubt this code would have been likely to execute, but you're
certainly right.  It's a bug, and this looks like the fix.

-- Sam


> 
> ---
>  drivers/scsi/sun3x_esp.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -u -p a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
> --- a/drivers/scsi/sun3x_esp.c
> +++ b/drivers/scsi/sun3x_esp.c
> @@ -213,7 +213,7 @@ static int __devinit esp_sun3x_probe(str
>  	esp->ops = &sun3x_esp_ops;
>  
>  	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
> -	if (!res && !res->start)
> +	if (!res || !res->start)
>  		goto fail_unlink;
>  
>  	esp->regs = ioremap_nocache(res->start, 0x20);
> @@ -221,7 +221,7 @@ static int __devinit esp_sun3x_probe(str
>  		goto fail_unmap_regs;
>  
>  	res = platform_get_resource(dev, IORESOURCE_MEM, 1);
> -	if (!res && !res->start)
> +	if (!res || !res->start)
>  		goto fail_unmap_regs;
>  
>  	esp->dma_regs = ioremap_nocache(res->start, 0x10);
