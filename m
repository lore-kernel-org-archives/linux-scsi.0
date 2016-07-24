From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH] SCSI-aic94xx: Delete unnecessary checks before the
 function call "kmem_cache_destroy"
Date: Sun, 24 Jul 2016 13:51:56 +0200
Message-ID: <4962c98f-b21b-8a28-7c35-9df9cb28c857@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <564AD586.5040606@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <564AD586.5040606@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>, Jack Wang <jinpu.wang@profitbricks.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 17 Nov 2015 08:14:52 +0100
> 
> The kmem_cache_destroy() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the calls is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/scsi/aic94xx/aic94xx_init.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
> index 662b232..ab93049 100644
> --- a/drivers/scsi/aic94xx/aic94xx_init.c
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> @@ -660,12 +660,9 @@ Err:
>  
>  static void asd_destroy_global_caches(void)
>  {
> -	if (asd_dma_token_cache)
> -		kmem_cache_destroy(asd_dma_token_cache);
> +	kmem_cache_destroy(asd_dma_token_cache);
>  	asd_dma_token_cache = NULL;
> -
> -	if (asd_ascb_cache)
> -		kmem_cache_destroy(asd_ascb_cache);
> +	kmem_cache_destroy(asd_ascb_cache);
>  	asd_ascb_cache = NULL;
>  }
>  
> 

How do you think about to integrate this update suggestion
into another source code repository?

Regards,
Markus
