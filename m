From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] further sim710 updates
Date: Mon, 10 Feb 2003 16:32:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030210163228.A14769@lst.de>
References: <20030210085920.A11560@lst.de> <1044890849.2008.71.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1044890849.2008.71.camel@mulgrave>; from James.Bottomley@steeleye.com on Mon, Feb 10, 2003 at 09:27:27AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Feb 10, 2003 at 09:27:27AM -0600, James Bottomley wrote:
> On Mon, 2003-02-10 at 01:59, Christoph Hellwig wrote:
> > and I think there's more that should be done, but this would change
> > user-visiable attributes:
> > 
> >   - remove the ugly single module option code and the command line
> >     parsing in favour of Rusty's new module_param stuff
> >   - split the driver into two drivers: 53c700_eisa and 53c700_mca.
> >     There's no logic shared between those two busses, just a little
> >     bit of helper in the setup/remove code
> 
> Sounds good if you want to do a patch.

This will be in the next patch revision.

> >   - mca_register_driver/mca_unregister_driver should check for
> >     the precense of an MCA bus by themselves instead of leaving
> >     it to the caller
> 
> The if(MCA_bus) is unnecessary.  If there's no MCA bus, no IDs will be
> stored, so nothing will get attached.

Ok.

> >   - mca_register_driver/mca_unregister_driver should be named
> >     mca_driver_register/mca_driver_unregister to be more similar
> >     to the other *driver_(un)registers.
> 
> Which others?  I modelled the interface on PCI, which has
> pci_register_driver() etc.  I agree on standardisation, but the way I
> did it was standard when the MCA bus code was written...

eisa and the plain, non-prefix versions.  Okay, maybe MCA is okay, but
at least it's inconsistant..

> > @@ -32,51 +32,18 @@
> >  #include <linux/blk.h>
> >  #include <linux/device.h>
> >  #include <linux/init.h>
> > -#ifdef CONFIG_MCA
> >  #include <linux/mca.h>
> > -#endif
> 
> This can't be done otherwise the driver won't compile on non x86 archs
> (yes, I know, I'll fix the MCA header file...)

If I split the EISA/MCA parts into separate driver we won't have that
problem anymore.

