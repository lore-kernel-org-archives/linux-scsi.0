From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: linux-next: Tree for December 29 (fcoe/libfc)
Date: Tue, 30 Dec 2008 23:10:27 +0530
Message-ID: <20081230174027.GC18636@linux.vnet.ibm.com>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au> <20081229195358.6a239657.randy.dunlap@oracle.com> <1230651870.3296.2.camel@localhost.localdomain> <495A5259.2080208@oracle.com> <1230657124.3296.20.camel@localhost.localdomain>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1230657124.3296.20.camel@localhost.localdomain>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Robert Love <robert.w.love@intel.com>
List-Id: linux-scsi@vger.kernel.org

* James Bottomley <James.Bottomley@HansenPartnership.com> [2008-12-30 17:12:04]:

> On Tue, 2008-12-30 at 08:54 -0800, Randy Dunlap wrote:
> > James Bottomley wrote:
> > > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > > index 0e5e084..9f4cc8e 100644
> > > --- a/drivers/scsi/Kconfig
> > > +++ b/drivers/scsi/Kconfig
> > > @@ -607,13 +607,12 @@ config SCSI_FLASHPOINT
> > >  
> > >  config LIBFC
> > >  	tristate "LibFC module"
> > > -	depends on SCSI && SCSI_FC_ATTRS
> > > +	select SCSI_FC_ATTRS
> > >  	---help---
> > >  	  Fibre Channel library module
> > >  
> > >  config FCOE
> > >  	tristate "FCoE module"
> > > -	depends on SCSI
> > >  	select LIBFC
> > >  	---help---
> > >  	  Fibre Channel over Ethernet module
> > > 
> > > 
> > 
> > This still has a build error when CONFIG_PCI=n:
> > 
> > 
> > linux-next-20081229/drivers/scsi/fcoe/fc_transport_fcoe.c: In function 'fcoe_load_transport_driver':
> > linux-next-20081229/drivers/scsi/fcoe/fc_transport_fcoe.c:324: error: 'pci_bus_type' undeclared (first use in this function)
> > make[4]: *** [drivers/scsi/fcoe/fc_transport_fcoe.o] Error 1
> 
> OK, so take two would make FCOE depend on SCSI, like this.
> 
> James
> 


Hi James,

	Thanks, the patch fixes same build failure, with !CONFIG_PCI, which I reported some
time back today.


> ---
> 
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Subject: [SCSI] fcoe: fix configuration problems
> 
> fcoe selects libfc and requires SCSI and PCI (the SCSI requirement is
> implicitly covered by an enclosing if).  Fix them both up so they
> cannot be configured in an invalid state: make LIBFC select
> SCSI_FC_ATTRS and make FCOE depend on PCI and select LIBFC.
> 
  Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 0e5e084..152d4aa 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -607,13 +607,13 @@ config SCSI_FLASHPOINT
> 
>  config LIBFC
>  	tristate "LibFC module"
> -	depends on SCSI && SCSI_FC_ATTRS
> +	select SCSI_FC_ATTRS
>  	---help---
>  	  Fibre Channel library module
> 
>  config FCOE
>  	tristate "FCoE module"
> -	depends on SCSI
> +	depends on PCI
>  	select LIBFC
>  	---help---
>  	  Fibre Channel over Ethernet module
> -- 
> 1.5.6.6
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
