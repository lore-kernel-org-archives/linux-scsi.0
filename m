From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Correct some mistakes in drivers using the scsi
	hotplug model
Date: Tue, 31 Jul 2007 09:42:25 -0500
Message-ID: <1185892945.3468.9.camel@localhost.localdomain>
References: <20070731125510.GN21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34669 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752829AbXGaOm1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 10:42:27 -0400
In-Reply-To: <20070731125510.GN21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, 2007-07-31 at 06:55 -0600, Matthew Wilcox wrote:
> A few drivers are doing things like releasing IRQs before calling
> scsi_remove_host(), which can lead to some ugly error messages.
> Many more drivers are simply forgetting to call scsi_host_put() after
> they've finished tearing down their driver structures.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 
> diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
> index 3a80897..6c2d4bb 100644
> --- a/drivers/scsi/NCR_D700.c
> +++ b/drivers/scsi/NCR_D700.c
> @@ -357,6 +357,7 @@ NCR_D700_remove_one(struct Scsi_Host *host)
>  	kfree((struct NCR_700_Host_Parameters *)host->hostdata[0]);
>  	free_irq(host->irq, host);
>  	release_region(host->base, 64);
> +	scsi_host_put(host);
>  }

Rather than changing this in every 53c700 based driver, shouldn't it
just be added to NCR_700_release()?

>  static int __devexit
> diff --git a/drivers/scsi/NCR_Q720.c b/drivers/scsi/NCR_Q720.c
> index a8bbdc2..6f03574 100644
> --- a/drivers/scsi/NCR_Q720.c
> +++ b/drivers/scsi/NCR_Q720.c
> @@ -323,6 +323,7 @@ NCR_Q720_remove_one(struct Scsi_Host *host)
>  {
>  	scsi_remove_host(host);
>  	ncr53c8xx_release(host);
> +	scsi_host_put(host);
>  }

Ditto for this (since zalon also has the problem).

>  static int __exit
> diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
> index 0c758d1..8211225 100644
> --- a/drivers/scsi/a4000t.c
> +++ b/drivers/scsi/a4000t.c
> @@ -105,6 +105,7 @@ static __devexit int a4000t_device_remove(struct device *dev)
>  	kfree(hostdata);
>  	free_irq(host->irq, host);
>  	release_mem_region(A4000T_SCSI_ADDR, 0x1000);
> +	scsi_host_put(host);
>  
>  	return 0;
>  }
> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index 85f2394..27acef4 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
> @@ -907,6 +907,7 @@ void aha152x_release(struct Scsi_Host *shpnt)
>  	if(!shpnt)
>  		return;
>  
> +	scsi_remove_host(shpnt);
>  	if (shpnt->irq)
>  		free_irq(shpnt->irq, shpnt);

and this one needs to go via Boaz ... he's currently rewriting this
driver.

James


