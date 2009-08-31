From: Alok Kataria <akataria@vmware.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Mon, 31 Aug 2009 14:54:16 -0700
Message-ID: <1251755656.16169.52.camel@ank32.eng.vmware.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <200908280803.52025.eike-kernel@sf-tec.de>
	 <1251739571.16169.17.camel@ank32.eng.vmware.com>
	 <200908312051.26264.eike-kernel@sf-tec.de>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:59500 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbZHaVyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Aug 2009 17:54:14 -0400
In-Reply-To: <200908312051.26264.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>, Maxime Austruy <maustruy@vmware.com>


On Mon, 2009-08-31 at 11:51 -0700, Rolf Eike Beer wrote:
> Alok Kataria wrote:
> > Hi Eike,
> 
> > > > +static int __devinit pvscsi_probe(struct pci_dev *pdev,
> > > > +				  const struct pci_device_id *id)
> > > > +{
> > > > +	struct pvscsi_adapter *adapter;
> > > > +	struct Scsi_Host *host;
> > > > +	unsigned long base, i;
> > > > +	int error;
> > > > +
> > > > +	error = -ENODEV;
> > > > +
> > > > +	if (pci_enable_device(pdev))
> > > > +		return error;
> > >
> > > As always I suggest having a look on devres (see Documentation/driver-
> > > model/devres.txt) which could simplify your error handling here and your
> > > release function a lot. You only need to make sure it doesn't hurt if all
> > > the PCI resources are freed after the scsi ones as you would end up
> > > cleaning the scsi ones by hand and afterwards devres would throw all it
> > > handles (which will probably be most of your PCI stuff) away itself.
> >
> > I took a quick look, but would prefer not to change this right now. Will
> > do this as a incremental change later. Hope that is fine.
> 
> Just a suggestion ;)
> 
> > > > +	adapter->dev  = pdev;
> > > > +	adapter->host = host;
> > > > +
> > > > +	spin_lock_init(&adapter->hw_lock);
> > > > +
> > > > +	host->max_channel = 0;
> > > > +	host->max_id      = 16;
> > > > +	host->max_lun     = 1;
> > > > +
> > > > +	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &adapter->rev);
> > >
> > > That's in pdev->revision anyway, isn't it?
> >
> > Yep, though, its needed in pvscsi_info, so will keep this in adapter
> > too.
> 
> Yes, but you don't need to do pci_read_config_byte() but simply copying that 
> over from pdev->revision.

Oh..yes, will take care of that in the next revision.  

Thanks,
Alok
> 
> Eike

