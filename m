From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] fix aic79xx module_init return value when no hardware
 present
Date: Wed, 08 Sep 2004 08:59:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413F023D.5030803@adaptec.com>
References: <20040906185337.GA25764@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:16013 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267514AbUIHM7s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2004 08:59:48 -0400
In-Reply-To: <20040906185337.GA25764@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Thanks Christoph for this patch.  If this works for the people,
please James go ahead and apply it, this seems like a good interim
solution to prevent oopses as Christoph has pointed out.  The newer
version of the drivers absolves this patch, as it already checkes the
return value.

		Luben


Christoph Hellwig wrote:
> So much rearranging to just propagate the pci_module_init return value..
> 
> 
> --- 1.56/drivers/scsi/aic7xxx/aic79xx_osm.c     2004-08-25 01:09:04 +02:00
> +++ edited/drivers/scsi/aic7xxx/aic79xx_osm.c   2004-09-06 20:46:53 +02:00
> @@ -851,6 +851,7 @@
>  {
>         struct  ahd_softc *ahd;
>         int     found;
> +       int     error = 0;
>  
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
>         /*
> @@ -902,7 +903,9 @@
>         ahd_list_lockinit();
>  
>  #ifdef CONFIG_PCI
> -       ahd_linux_pci_init();
> +       error = ahd_linux_pci_init();
> +       if (error)
> +               return error;
>  #endif
>  
>         /*
> @@ -919,7 +922,7 @@
>         spin_lock_irq(&io_request_lock);
>  #endif
>         aic79xx_detect_complete++;
> -       return (found);
> +       return 0;
>  }
>  
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
> @@ -5073,7 +5076,7 @@
>  ahd_linux_init(void)
>  {
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
> -       return (ahd_linux_detect(&aic79xx_driver_template) ? 0 : -ENODEV);
> +       return ahd_linux_detect(&aic79xx_driver_template);
>  #else
>         scsi_register_module(MODULE_SCSI_HA, &aic79xx_driver_template);
>         if (aic79xx_driver_template.present == 0) {
> 

