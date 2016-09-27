From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 3/3] g_NCR5380: Stop using scsi_module.c
Date: Tue, 27 Sep 2016 14:55:17 +0200
Message-ID: <201609271455.17930.linux@rainbow-software.org>
References: <1474743545-4731-1-git-send-email-linux@rainbow-software.org> <1474743545-4731-4-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1609261132001.4881@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:56732 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751088AbcI0MzZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2016 08:55:25 -0400
In-Reply-To: <alpine.LNX.2.00.1609261132001.4881@nippy.intranet>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Monday 26 September 2016, Finn Thain wrote:

[...]

> Instead of this:
> > +	if (scsi_add_host(instance, pdev)) {
> > +		free_irq(irq, instance);
> > +		goto out_unregister;
> > +	}
> > +	scsi_scan_host(instance);
> > +	return instance;
>
> please use the following (note the missing NCR5380_exit() call):
>
> +	if (scsi_add_host(instance, pdev))
> +		goto out_free_irq;
> +	scsi_scan_host(instance);
> +	return(instance);
> +
> +out_free_irq:
> +	if (instance->irq != NO_IRQ)
> +		free_irq(instance->irq, instance);
> +	NCR5380_exit(instance);
>
> >  out_unregister:
> > -	scsi_unregister(instance);
> > +	scsi_host_put(instance);
> >  out_release:
> >  #ifndef SCSI_G_NCR5380_MEM
> > -	release_region(card.NCR5380_map_name, region_size);
> > +	release_region(base, region_size);
> >  #else
> >  	iounmap(iomem);
> >  	release_mem_region(base, iomem_size);
> >  #endif
> > -	return 0;
> > +	return NULL;
> >  }
> >
> > -/**
> > - *	generic_NCR5380_release_resources	-	free resources
> > - *	@instance: host adapter to clean up
> > - *
> > - *	Free the generic interface resources from this adapter.
> > - *
> > - *	Locks: none
> > - */
> > -
> > -static int generic_NCR5380_release_resources(struct Scsi_Host *instance)
> > +static void generic_NCR5380_release_resources(struct Scsi_Host
> > *instance) {
> > +	scsi_remove_host(instance);
> >  	if (instance->irq != NO_IRQ)
> >  		free_irq(instance->irq, instance);
> >  	NCR5380_exit(instance);
> > @@ -364,7 +304,7 @@ static int generic_NCR5380_release_resources(struct
> > Scsi_Host *instance) release_mem_region(instance->base,
> > hostdata->iomem_size);
> >  	}
> >  #endif
> > -	return 0;
> > +	scsi_host_put(instance);
>
> The sequence of operations here should be the same as the error path
> above.

I put scsi_host_put() call at the end because the release_mem_region code (in 
the MMIO case) dereferences the hostdata pointer. I don't think it's safe to 
do after scsi_host_put().

[...]

> > +static int pnp_registered;
> > +#endif /* !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP) */
> > +
> > +static int __init generic_NCR5380_init(void)
> > +{
> > +	int ret = 0;
> > +
> > +#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> > +	ret = pnp_register_driver(&generic_NCR5380_pnp_driver);
> > +	if (!ret)
> > +		pnp_registered = 1;
> >  #endif
> > +	ret = isa_register_driver(&generic_NCR5380_isa_driver, MAX_CARDS);
> > +	if (!ret)
> > +		isa_registered = 1;
> > +
> > +#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> > +	if (pnp_registered)
> > +		ret = 0;
> > +#endif
> > +	if (isa_registered)
> > +		ret = 0;
> > +
> > +	return ret;
> > +}
> > +
> > +static void __exit generic_NCR5380_exit(void)
> > +{
> > +#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> > +	if (pnp_registered)
> > +		pnp_unregister_driver(&generic_NCR5380_pnp_driver);
> > +#endif
> > +	if (isa_registered)
> > +		isa_unregister_driver(&generic_NCR5380_isa_driver);
> > +}
> > +
>
> I find that hard to follow. This should be equivalent and simpler:
>
> static int __init generic_NCR5380_init(void)
> {
> 	isa_ret = isa_register_driver(&generic_NCR5380_isa_driver, MAX_CARDS);
> #if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> 	pnp_ret = pnp_register_driver(&generic_NCR5380_pnp_driver);
> 	return pnp_ret ? isa_ret : 0;
> #endif
> 	return isa_ret;
> }
>
> static void __exit generic_NCR5380_exit(void)
> {
> 	if (!isa_ret)
> 		isa_unregister_driver(&generic_NCR5380_isa_driver);
> #if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> 	if (!pnp_ret)
> 		pnp_unregister_driver(&generic_NCR5380_pnp_driver);
> #endif
> }

Doesn't make it any better, IMHO. Good that it's shorter but not cleaner - 
especially this:
> 	return pnp_ret ? isa_ret : 0;

Also looking at the _exit function, meaning of isa_ret and pnp_ret is not 
obvious there.

Maybe we should have a module_isa_pnp_driver() macro.

-- 
Ondrej Zary
