From: Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH 4/5] [SCSI] Do not use platform_bus as a parent
Date: Fri, 01 Aug 2014 18:25:24 +0100
Message-ID: <1406913924.22529.51.camel@hornet>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
	 <1406298233-27876-4-git-send-email-pawel.moll@arm.com>
	 <1406299616.1789.13.camel@jarvis.lan> <20140726201150.GA21870@kroah.com>
	 <1406433177.11069.3.camel@jarvis> <20140727150720.GC1723@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140727150720.GC1723@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "paul@pwsan.com" <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>, Peter De Schrijver <pdeschrijver@nvidia.com>, "arm@kernel.org" <arm@kernel.org>, "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2014-07-27 at 16:07 +0100, Greg Kroah-Hartman wrote:
> Ah, ok, it's a scsi core thing, not a driver core thing, that's less
> confusing now.  For a "fallback" of a platform device, if you switch the
> lines around you should be fine, something like this patch perhaps:
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 3cbb57a8b846..d8d3b294f5bc 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -218,16 +218,16 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>  		goto fail;
>  
>  	if (!shost->shost_gendev.parent)
> -		shost->shost_gendev.parent = dev ? dev : &platform_bus;
> -	if (!dma_dev)
> -		dma_dev = shost->shost_gendev.parent;
> -
> -	shost->dma_dev = dma_dev;
> +		shost->shost_gendev.parent = dev;
>  
>  	error = device_add(&shost->shost_gendev);
>  	if (error)
>  		goto out;
>  
> +	if (!dma_dev)
> +		dma_dev = shost->shost_gendev.parent;
> +	shost->dma_dev = dma_dev;
> +
>  	pm_runtime_set_active(&shost->shost_gendev);
>  	pm_runtime_enable(&shost->shost_gendev);
>  	device_enable_async_suspend(&shost->shost_gendev);

But this will still make shost->dma_dev == NULL in the cases James
quoted:

On Fri, 2014-07-25 at 15:46 +0100, James Bottomley wrote:
> Yes, for DMA purposes, the parent cannot now be NULL; we'll get a panic
> in the DMA transfers if it is.  A lot of the legacy ISA device on x86
> and I thought some ARM SOC devices don't pass in the parent device, so
> we hang them off a known parent.
> 
> You can grep for it; these are the devices that will begin to panic if
> you apply this patch:
> 
> arch/ia64/hp/sim/simscsi.c:     error = scsi_add_host(host, NULL);
> drivers/scsi/a2091.c:   error = scsi_add_host(instance, NULL);
> drivers/scsi/a3000.c:   error = scsi_add_host(instance, NULL);
> drivers/scsi/aha152x.c: if( scsi_add_host(shpnt, NULL) ) {
> drivers/scsi/gdth.c:    error = scsi_add_host(shp, NULL);
> drivers/scsi/gdth.c:    error = scsi_add_host(shp, NULL);
> drivers/scsi/gvp11.c:   error = scsi_add_host(instance, NULL);
> drivers/scsi/imm.c:     err = scsi_add_host(host, NULL);
> drivers/scsi/pcmcia/fdomain_stub.c:    if (scsi_add_host(host, NULL))
> drivers/scsi/pcmcia/nsp_cs.c:   ret = scsi_add_host (host, NULL);
> drivers/scsi/pcmcia/qlogic_stub.c:      if (scsi_add_host(shost, NULL))
> drivers/scsi/pcmcia/sym53c500_cs.c:     if (scsi_add_host(host, NULL))
> drivers/scsi/ppa.c:     err = scsi_add_host(host, NULL);
> drivers/scsi/qlogicfas.c:       if (scsi_add_host(hreg, NULL))
> drivers/scsi/scsi_module.c:             error = scsi_add_host(shost, NULL);
> drivers/scsi/sgiwd93.c: err = scsi_add_host(host, NULL);

Maybe the DMA API should be coping with NULL device? It seems to handle
it in a half of the methods and fails in the other half...

Pawel
