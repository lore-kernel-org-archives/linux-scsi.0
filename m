From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 1/2] [SCSI] ufshcd-pltfrm: remove unnecessary
 dma_set_coherent_mask() call
Date: Wed, 12 Jun 2013 12:35:28 +0530
Message-ID: <CALMYJDu+a_jqJ_m6mMKk_5MzYoRtOv2F+U1_TdcTmuMGA687xQ@mail.gmail.com>
References: <1370776799-12373-1-git-send-email-mita@fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:33631 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3FLHFu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jun 2013 03:05:50 -0400
Received: by mail-bk0-f49.google.com with SMTP id mz10so2223495bkb.22
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2013 00:05:48 -0700 (PDT)
In-Reply-To: <1370776799-12373-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <mita@fixstars.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Sun, Jun 9, 2013 at 4:49 PM, Akinobu Mita <mita@fixstars.com> wrote:
> Changing the device coherent dma mask to the value that currently set
> has no effect.
>
> Signed-off-by: Akinobu Mita <mita@fixstars.com>
> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: Santosh Y <santoshsy@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index 0014e28..969c9bc 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -100,7 +100,6 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
>         struct resource *irq_res;
>         resource_size_t mem_size;
>         int err;
> -       struct device *dev = &pdev->dev;
>
>         mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         if (!mem_res) {
> @@ -132,12 +131,6 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
>                 goto out_iounmap;
>         }
>
> -       err = dma_set_coherent_mask(dev, dev->coherent_dma_mask);
> -       if (err) {
> -               dev_err(&pdev->dev, "set dma mask failed\n");
> -               goto out_iounmap;
> -       }
> -
>         err = ufshcd_init(&pdev->dev, &hba, mmio_base, irq_res->start);
>         if (err) {
>                 dev_err(&pdev->dev, "Intialization failed\n");
> --
> 1.8.1.4
>

Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh
