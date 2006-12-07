From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/5] PCI : Move pci_fixup_device and is_enabled
Date: Wed, 6 Dec 2006 17:16:14 -0800
Message-ID: <20061207011614.GA32650@kroah.com>
References: <456404EF.3090902@jp.fujitsu.com> <20061122180901.GD378@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:43544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937907AbWLGBQ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Dec 2006 20:16:28 -0500
Content-Disposition: inline
In-Reply-To: <20061122180901.GD378@colo.lackof.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz, Andrew Morton <akpm@osdl.org>, e1000-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

On Wed, Nov 22, 2006 at 11:09:01AM -0700, Grant Grundler wrote:
> On Wed, Nov 22, 2006 at 05:06:07PM +0900, Hidetoshi Seto wrote:
> > --- linux-2.6.19-rc6.orig/drivers/pci/pci.c
> > +++ linux-2.6.19-rc6/drivers/pci/pci.c
> > @@ -558,12 +558,18 @@
> >  {
> >  	int err;
> > 
> > +	if (dev->is_enabled)
> > +		return 0;
> 
> This is unfortunately going to collide with the previous
> patch posted by inaky@linux.intel.com:
> 
>     Subject: [patch 0/2] pci: make pci_{enable,disable}_device() be nested

Grant, you were right.  This has changed the logic around this area, and
the pci_enable_device() stuff conflicts with this.

Hidetoshi, I tried to merge things together, but I think I got it wrong,
as the logic is different now.  Can you please respin this patch and
resend all of them?

Sorry for the delay,

thanks,

greg k-h
