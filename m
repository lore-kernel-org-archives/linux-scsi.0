From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] gdth: fix Error: Driver 'gdth' is already
	registered, aborting...
Date: Mon, 05 May 2008 09:17:29 -0500
Message-ID: <1209997049.3163.4.camel@localhost.localdomain>
References: <1209958558.16283.42.camel@localhost.localdomain>
	 <200805051124.11940.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57254 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756923AbYEEORc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2008 10:17:32 -0400
In-Reply-To: <200805051124.11940.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2008-05-05 at 11:24 +0200, Rolf Eike Beer wrote:
> James Bottomley wrote:
> > This message appears on modprobe/rmmod/modprobe of the driver.  It's
> > caused because if the driver has no instances, it returns an error
> > from gdth_init, which causes the module to fail to load.
> > Unfortunately, the module's pci driver is still registered at this
> > point.
> >
> > Fix this by making gdth behave like a modern driver and insert even if
> > it doesn't find any instances (in case of hot plug or software driven
> > binding).
> >
> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  drivers/scsi/gdth.c |   13 ++++++++-----
> >  1 files changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> > index 16785a2..46771d4 100644
> > --- a/drivers/scsi/gdth.c
> > +++ b/drivers/scsi/gdth.c
> > @@ -550,7 +550,6 @@ static int __init gdth_search_isa(ulong32 bios_adr)
> >  #endif /* CONFIG_ISA */
> >
> >  #ifdef CONFIG_PCI
> > -static bool gdth_pci_registered;
> >
> >  static bool gdth_search_vortex(ushort device)
> >  {
> > @@ -5157,8 +5156,13 @@ static int __init gdth_init(void)
> >
> >  #ifdef CONFIG_PCI
> >  	/* scanning for PCI controllers */
> > -	if (pci_register_driver(&gdth_pci_driver) == 0)
> > -		gdth_pci_registered = true;
> > +	if (pci_register_driver(&gdth_pci_driver)) {
> > +		gdth_ha_str *ha;
> > +
> > +		list_for_each_entry(ha, &gdth_instances, list)
> > +			gdth_remove_one(ha);
> > +		return -ENODEV;
> > +	}
> >  #endif /* CONFIG_PCI */
> >
> >  	TRACE2(("gdth_detect() %d controller detected\n", gdth_ctr_count));
> 
> Wouldn't it be better to return the error code that pci_register_driver() sent 
> back?

Not really it's just a redo of the original behaviour.

James


