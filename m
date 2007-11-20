From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Tue, 20 Nov 2007 08:36:02 -0600
Message-ID: <1195569362.3131.3.camel@localhost.localdomain>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119.003802.100741794.davem@davemloft.net>
	 <1195501874.6539.5.camel@pasglop>  <20071120082927.GA8856@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:40784 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101AbXKTOgM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 09:36:12 -0500
In-Reply-To: <20071120082927.GA8856@alpha.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk


On Tue, 2007-11-20 at 09:29 +0100, Thomas Bogendoerfer wrote:
> On Tue, Nov 20, 2007 at 06:51:14AM +1100, Benjamin Herrenschmidt wrote:
> > 
> > On Mon, 2007-11-19 at 00:38 -0800, David Miller wrote:
> > > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > Date: Mon, 19 Nov 2007 16:35:23 +1100
> > > 
> > > > I'm not sure what is the best way to fix that. Internally, I've done
> > > > some test whacking some ____cacheline_aligned in the scsi_cmnd data
> > > > structure to verify I no longer get random SLAB corruption when using my
> > > > USB but that significantly bloats the size of the structure on archs
> > > > such as ppc64 that don't need it and have a large cache line size.
> > > > 
> > > > Unfortunately, I don't think there's any existing Kconfig symbol or arch
> > > > provided #define to tell us that we are on a non-coherent arch afaik
> > > > that could be used to make that conditional.
> > > > 
> > > > Another option would be to kmalloc the buffer (wasn't it the case before
> > > > btw ?) but I suppose some people will scream at the idea due to how the
> > > > command pools are done...
> > > 
> > > You could make a ____dma_cacheline_aligned and use that.
> > > It seems pretty reasonable.
> > 
> > I was thinking about that. What archs would need it ? arm, mips, what
> > else ?
> 
> older parisc

Actually, we already established on IRC that the lasi700 driver doesn't
need this, principally because the parisc architecture doesn't do an
invalidate for DMA_FROM_DEVICE but a flush and invalidate
(architecturally, if you read our manuals, even pdc is entitled to write
back dirty lines, so it's not clear there's actually an invalidate
instruction we can use).   This is also one possible temporary fix for
the other architectures if we can't get a different method to work
nicely.

James


James


