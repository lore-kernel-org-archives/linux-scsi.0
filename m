From: "Vorobiev Dmitri" <dmitri.vorobiev@movial.fi>
Subject: Re: [PATCH] SCSI: fix the return type of the remove() method in
     sgiwd93.c
Date: Wed, 3 Dec 2008 18:24:54 +0200 (EET)
Message-ID: <46353.88.114.226.209.1228321494.squirrel@webmail.movial.fi>
References: <1227140357-29921-1-git-send-email-dmitri.vorobiev@movial.fi>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.movial.fi ([62.236.91.34]:55910 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbYLCQY4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2008 11:24:56 -0500
In-Reply-To: <1227140357-29921-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, linux-mips@linux-mips.org, Dmitri Vorobiev <dmitri.vorobiev@movial.fi>

> This patch fixes the following compilation warning:
>
>   CC [M]  drivers/scsi/sgiwd93.o
> drivers/scsi/sgiwd93.c:314: warning: initialization from incompatible
> pointer type
>

Hello James,

Any news about this one? I think this patch should go via linux-scsi,
unless you would be insisting on pushing it via linux-mips, in which case
I'll politely bug Ralf about it. :)

Thanks,
Dmitri

> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
> ---
>  drivers/scsi/sgiwd93.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
> index 31fe605..672a521 100644
> --- a/drivers/scsi/sgiwd93.c
> +++ b/drivers/scsi/sgiwd93.c
> @@ -297,7 +297,7 @@ out:
>  	return err;
>  }
>
> -static void __exit sgiwd93_remove(struct platform_device *pdev)
> +static int __exit sgiwd93_remove(struct platform_device *pdev)
>  {
>  	struct Scsi_Host *host = platform_get_drvdata(pdev);
>  	struct ip22_hostdata *hdata = (struct ip22_hostdata *) host->hostdata;
> @@ -307,6 +307,8 @@ static void __exit sgiwd93_remove(struct
> platform_device *pdev)
>  	free_irq(pd->irq, host);
>  	dma_free_noncoherent(&pdev->dev, HPC_DMA_SIZE, hdata->cpu, hdata->dma);
>  	scsi_host_put(host);
> +
> +	return 0;
>  }
>
>  static struct platform_driver sgiwd93_driver = {
> --
> 1.5.4.3
>
>
>

