From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Tue, 01 Sep 2009 09:26:39 -0500
Message-ID: <1251815199.3864.62.camel@mulgrave.site>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <1251739735.16169.20.camel@ank32.eng.vmware.com>
	 <1251741624.18828.83.camel@mulgrave.site>
	 <1251755593.16169.51.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41868 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbZIAO0r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2009 10:26:47 -0400
In-Reply-To: <1251755593.16169.51.camel@ank32.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akataria@vmware.com
Cc: Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Torokhov <dtor@vmware.com>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>, Bhavesh Davda <bhavesh@vmware.com>

On Mon, 2009-08-31 at 14:53 -0700, Alok Kataria wrote:
> > > diff --git a/drivers/scsi/pvscsi.c b/drivers/scsi/pvscsi.c
> > > new file mode 100644
> > > index 0000000..fc85a3a
> > > --- /dev/null
> > > +++ b/drivers/scsi/pvscsi.c
> > [...]
> > > +static int __devinit pvscsi_allocate_sg(struct pvscsi_adapter *adapter)
> > > +{
> > > +	struct pvscsi_ctx *ctx;
> > > +	int i;
> > > +
> > > +	ctx = adapter->cmd_map;
> > > +	BUILD_BUG_ON(sizeof(struct pvscsi_sg_list) > PAGE_SIZE);
> > > +
> > > +	for (i = 0; i < adapter->req_depth; ++i, ++ctx) {
> > > +		ctx->sgl = pci_alloc_consistent(adapter->dev, PAGE_SIZE,
> > > +						&ctx->sglPA);
> > 
> > Why do you need coherent memory for the sg list?  Surely the use pattern
> > of an SG list is that it follows a predefined ownership model between
> > the driver and the virtual device, thus not really requiring coherent
> > memory?
> 
> The SG list needs to be accessed by the hypervisor too, and we need the
> physical address to access it from the hypervisor. We do that using the
> sglPA field right now, which the pci_.. interface returns.  Do you think
> something else should be used for that purpose ? 

The hypervisor is part of the OS coherency domain ... coherent memory is
designed to be a mailbox access between a device and driver, which I
believe the hypervisor doesn't need.

If all you're looking for is a way to map a page of memory to a physical
address, won't dma_map_single() do that for you?  Or, actually, in this
case virt_to_page() might be a better way.

James


