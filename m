From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 3/3] g_NCR5380: Stop using scsi_module.c
Date: Wed, 28 Sep 2016 10:06:03 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609280954090.358@nippy.intranet>
References: <1474743545-4731-1-git-send-email-linux@rainbow-software.org> <1474743545-4731-4-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1609261132001.4881@nippy.intranet> <201609271455.17930.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:35126 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932342AbcI1AFs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2016 20:05:48 -0400
In-Reply-To: <201609271455.17930.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Tue, 27 Sep 2016, Ondrej Zary wrote:

> On Monday 26 September 2016, Finn Thain wrote:
> 
> [...]
> 
> > > @@ -364,7 +304,7 @@ static int generic_NCR5380_release_resources(struct
> > > Scsi_Host *instance) release_mem_region(instance->base,
> > > hostdata->iomem_size);
> > >  	}
> > >  #endif
> > > -	return 0;
> > > +	scsi_host_put(instance);
> >
> > The sequence of operations here should be the same as the error path
> > above.
> 
> I put scsi_host_put() call at the end because the release_mem_region 
> code (in the MMIO case) dereferences the hostdata pointer. I don't think 
> it's safe to do after scsi_host_put().

It's funny you say that, I already fixed a few of those use-after-free 
bugs in the other 5380 drivers. To avoid the bug, you'd need to use a 
temporary variable, like the fixes I did elsewhere.

Don't worry about changing it, this part of the driver gets revisited in 
my existing patch queue anyway.

> 
> [...]
> 
> > > +static int pnp_registered;
> > > +#endif /* !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP) */
> > > +
> > > +static int __init generic_NCR5380_init(void)
> > > +{
> > > +	int ret = 0;
> > > +
> > > +#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> > > +	ret = pnp_register_driver(&generic_NCR5380_pnp_driver);
> > > +	if (!ret)
> > > +		pnp_registered = 1;
> > >  #endif
> > > +	ret = isa_register_driver(&generic_NCR5380_isa_driver, MAX_CARDS);
> > > +	if (!ret)
> > > +		isa_registered = 1;
> > > +
> > > +#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> > > +	if (pnp_registered)
> > > +		ret = 0;
> > > +#endif
> > > +	if (isa_registered)
> > > +		ret = 0;
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static void __exit generic_NCR5380_exit(void)
> > > +{
> > > +#if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> > > +	if (pnp_registered)
> > > +		pnp_unregister_driver(&generic_NCR5380_pnp_driver);
> > > +#endif
> > > +	if (isa_registered)
> > > +		isa_unregister_driver(&generic_NCR5380_isa_driver);
> > > +}
> > > +
> >
> > I find that hard to follow. This should be equivalent and simpler:
> >
> > static int __init generic_NCR5380_init(void)
> > {
> > 	isa_ret = isa_register_driver(&generic_NCR5380_isa_driver, MAX_CARDS);
> > #if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> > 	pnp_ret = pnp_register_driver(&generic_NCR5380_pnp_driver);
> > 	return pnp_ret ? isa_ret : 0;
> > #endif
> > 	return isa_ret;
> > }
> >
> > static void __exit generic_NCR5380_exit(void)
> > {
> > 	if (!isa_ret)
> > 		isa_unregister_driver(&generic_NCR5380_isa_driver);
> > #if !defined(SCSI_G_NCR5380_MEM) && defined(CONFIG_PNP)
> > 	if (!pnp_ret)
> > 		pnp_unregister_driver(&generic_NCR5380_pnp_driver);
> > #endif
> > }
> 
> Doesn't make it any better, IMHO. Good that it's shorter but not cleaner - 
> especially this:
> > 	return pnp_ret ? isa_ret : 0;

The problem with that line is that pnp_ret is always discarded, same as in 
your version. I think my version makes that clear, which is what matters 
to me.

> 
> Also looking at the _exit function, meaning of isa_ret and pnp_ret is not 
> obvious there.
> 
> Maybe we should have a module_isa_pnp_driver() macro.
> 
> 

FWIW I would hope that the hypothetical definition of this 
`module_isa_pnp_driver' macro would have the same properties as my 
version: shorter, uses no temporaries and uses one less #ifdef, and is 
generally easier for me to read.

-- 
