From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
Date: Sun, 27 May 2007 14:46:39 -0500
Message-ID: <1180295199.3711.24.camel@mulgrave.il.steeleye.com>
References: <20070521151525.GA581@suse.de>
	 <Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
	 <6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
	 <1179933494.3700.16.camel@mulgrave.il.steeleye.com>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF019E1BDA@otce2k301.adaptec.com>
	 <20070523203846.41ac5011@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43870 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751280AbXE0Tqm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 May 2007 15:46:42 -0400
In-Reply-To: <20070523203846.41ac5011@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Aubrey Li <aubreylee@gmail.com>, Christoph Lameter <clameter@sgi.com>, Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 20:38 +0100, Alan Cox wrote:
> On Wed, 23 May 2007 15:17:08 -0400
> "Salyzyn, Mark" <mark_salyzyn@adaptec.com> wrote:
> 
> > The 31 bit limit for some of these cards is a problem, we currently only
> > do __GFP_DMA for bounce buffer sg elements allocated for user supplied
> > references in ioctls.
> > 
> > I figure we should be using pci_alloc_consistent calls for these
> > allocations to more accurately acquire memory within the 31 bit limit if
> > necessary, we could switch to these to remove the need for the __GFP_DMA
> > flag in the aacraid driver?
> 
> That didn't used to work right on the AMD boards when I tried it last as
> we ended up with a buffer that was mapped by the IOMMU for some reason
> and that was not below 2GB.

Is that a bug in the x86_64 subsystem ... or just a bug in the HW?

I'm assuming what happened is that the GART aperture was placed above
the 2GB limit making the GART unable to act as an IOMMU for any devices
with a dma_mask < 32bit?

This does show up a problem in our dma_ functions: namely that if the
system says it has an IOMMU then we assume it's fully functional (i.e.
able to reach all addresses).  There was a move afoot a while ago to
replace the single PCI_DMA_BUS_IS_PHYS macro which is used to tell the
system globally if we have an IOMMU with something like
dma_dev_uses_iommu(struct device *) which would do the same thing but on
a per-device basis.  Does this need to be resurrected?

James


