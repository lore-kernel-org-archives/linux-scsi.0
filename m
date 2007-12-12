From: Greg KH <greg@kroah.com>
Subject: Re: [stable] broken dpt_i2o in 2.6.23 (was: ext2 check page: bad
	entry in directory) (fwd)
Date: Wed, 12 Dec 2007 14:16:27 -0800
Message-ID: <20071212221627.GA16474@kroah.com>
References: <20071212105841.GN6770@1und1.de> <20071212033808.6fb92139.akpm@linux-foundation.org> <1197464879.20796.15.camel@n2o.xs4all.nl> <20071212134342.GR6770@1und1.de> <20071212111629.9a4f7f73.akpm@linux-foundation.org> <1197489294.4203.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52604 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXLLWaO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Dec 2007 17:30:14 -0500
Content-Disposition: inline
In-Reply-To: <1197489294.4203.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Miquel van Smoorenburg <miquels@cistron.nl>, linux-scsi@vger.kernel.org, matthew@wil.cx, linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Anders Henke <anders.henke@1und1.de>, stable@kernel.org

On Wed, Dec 12, 2007 at 02:54:54PM -0500, James Bottomley wrote:
> 
> On Wed, 2007-12-12 at 11:16 -0800, Andrew Morton wrote:
> > On Wed, 12 Dec 2007 14:43:42 +0100 Anders Henke <anders.henke@1und1.de> wrote:
> > 
> > > Am 12.12.2007 schrieb Miquel van Smoorenburg:
> > > > On Wed, 2007-12-12 at 03:38 -0800, Andrew Morton wrote:
> > > > > On Wed, 12 Dec 2007 11:58:41 +0100 Anders Henke <anders.henke@1und1.de> wrote:
> > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > I'd like to let you now that my boxes are running a 32-bit kernel, so
> > > > > > the 64-bit-uncleanliness shouldn't apply to my boxes; however,
> > > > > > 
> > > > > > http://www.miquels.cistron.nl/linux/dpt_i2o-64bit-2.6.23.patch
> > > > > > 
> > > > > > fixed the issue on my testbox.
> > > > > > 
> > > > > > I took a clean 2.6.23, applied patch, recompiled the kernel, reboot: works.
> > > > > 
> > > > > What a huge patch :(
> > > > > 
> > > > > We already reverted the offening patch so I assume that 2.6.24-rc5 is
> > > > > working for you?
> > > > > 
> > > > > I guess we need to look at restoring "dpt_i2o: convert to SCSI hotplug
> > > > > model" and then absorbing what Miquel has done there.
> > > > 
> > > > This was just a patch I had lying around, if it worked it would confirm
> > > > my suspicion, which it has.
> > > > 
> > > > The minimal patch which is suitable for 2.6.23-stable and 2.6.24 would
> > > > be the attached one-liner. The "dpt_i2o: convert to SCSI hotplug model"
> > > > patch could be restored then.
> > > > 
> > > > (if the list eats the attachment, it's also available here:
> > > > http://www.miquels.cistron.nl/linux/linux-2.6.23+24-dpt_i2o-dma64.patch 
> > > > )
> > > > 
> > > > Anders, does this one-liner patch work for you ?
> > > 
> > > Got it - and it works!
> > > 
> > > I took a clean 2.6.23, applied the patch, recompiled the kernel and
> > > rebooted my testbox: came up with the fresh-compiled kernel 
> > > (verified by "uname -a").
> > > 
> > 
> > That looks appropriate for 2.6.23.x:
> > 
> > --- linux-2.6.23.9.orig/drivers/scsi/dpt_i2o.c	2007-11-26 18:51:43.000000000 +0100
> > +++ linux-2.6.23.9/drivers/scsi/dpt_i2o.c	2007-12-12 13:21:05.000000000 +0100
> > @@ -905,8 +905,7 @@
> >  	}
> >  
> >  	pci_set_master(pDev);
> > -	if (pci_set_dma_mask(pDev, DMA_64BIT_MASK) &&
> > -	    pci_set_dma_mask(pDev, DMA_32BIT_MASK))
> > +	if (pci_set_dma_mask(pDev, DMA_32BIT_MASK))
> >  		return -EINVAL;
> 
> Yes, this has to be in ... the mptr filling the scatterlist on the
> current driver is only a u32 and so will silently truncate.
> 
> >  	base_addr0_phys = pci_resource_start(pDev,0);
> > 
> > 
> > However it is a bit mystifying that
> > 55d9fcf57ba5ec427544fca7abc335cf3da78160 would cause a dma mask problem
> > (isn't it?)
> > 
> > The scsi people might want to restore
> > 55d9fcf57ba5ec427544fca7abc335cf3da78160 and then apply Miquel's patch on
> > top for 2.6.24, or do it for 2.6.25?
> 
> I think it's a bit late in the game for 2.6.24, so I'm happy to leave
> the hotplug reverted.  We'll try adding back hotplug plus this for
> 2.6.25 I think.

So, what should be added to 2.6.23-stable then?  And, can I get a real
changelog entry for it?

thanks,

greg k-h
