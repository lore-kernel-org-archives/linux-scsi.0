From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 14/29] drivers/scsi/ufs/ufshcd-pltfrm.c: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 15:22:34 +0530
Message-ID: <CALMYJDvQdFcvoQVVVJL7cGa_zSv_m_vT=aeiNDji0fX7pFhcMQ@mail.gmail.com>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr> <1376471493-22215-15-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376471493-22215-15-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 14, 2013 at 2:41 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
>
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.
>
> A debugging statement in the error-handling code is removed as well, as it
> doesn't seem to give any more information than devm_ioremap_resource
> already gives.
>
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression pdev,res,n,e,e1;
> expression ret != 0;
> identifier l;
> @@
>
> - res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>   ... when != res
> - if (res == NULL) { ... \(goto l;\|return ret;\) }
>   ... when != res
> + res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>   e = devm_ioremap_resource(e1, res);
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c |    7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index c42db40..ea699b9 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -102,15 +102,8 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
>         struct device *dev = &pdev->dev;
>
>         mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!mem_res) {
> -               dev_err(dev, "Memory resource not available\n");
> -               err = -ENODEV;
> -               goto out;
> -       }
> -
>         mmio_base = devm_ioremap_resource(dev, mem_res);
>         if (IS_ERR(mmio_base)) {
> -               dev_err(dev, "memory map failed\n");
>                 err = PTR_ERR(mmio_base);
>                 goto out;
>         }
>

Redundant error message and error handling have been removed in the
patches submitted by 'Wei Yongjun' and 'Wolfram Sang'.

1. http://www.spinics.net/lists/linux-scsi/msg67557.html
2. http://www.spinics.net/lists/linux-scsi/msg67558.html

thanks anyway... :-)

-- 
~Santosh
