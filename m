From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: I/O write ordering
Date: Thu, 23 Sep 2004 10:19:57 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095898796.6359.18.camel@gaston>
References: <1095789421.2467.414.camel@mulgrave>
	 <200409211409.11095.jbarnes@engr.sgi.com>
	 <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com>
	 <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk>
	 <20040921214302.GG146363@sgi.com>
	 <20040922000211.GE16153@parcelfarce.linux.theplanet.co.uk>
	 <20040922011652.GD147856@sgi.com> <20040922014428.GD20053@colo.lackof.org>
	 <20040922025805.GA148414@sgi.com>
	 <20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk>
	 <1095864485.2143.1.camel@mulgrave>  <1095864709.6297.5.camel@gaston>
	 <1095865892.1715.5.camel@mulgrave>  <1095865863.6340.7.camel@gaston>
	 <1095866530.2295.8.camel@mulgrave>  <1095866930.6340.11.camel@gaston>
	 <1095867824.2295.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:51670 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S265098AbUIWAYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 20:24:08 -0400
In-Reply-To: <1095867824.2295.13.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jeremy Higdon <jeremy@sgi.com>, Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>

On Thu, 2004-09-23 at 01:43, James Bottomley wrote:
> On Wed, 2004-09-22 at 11:28, Benjamin Herrenschmidt wrote:
> >  - consistent memory is either cacheable or non-cacheable depending on
> > the CPU type (some embedded CPUs who don't implement cache coherency
> > will map consistent memory as non-cacheable, most desktop CPUs and all
> > 64 bits CPU don't mind and will map it cacheable).
> 
> Yes, this was what I feared, since streaming memory has exact ownership
> and handoff paradigms for handling it.
> 
> Your problem case is consistent memory access vs readX/writeX then.
> 
> Could you not just make consistent memory always uncacheable ... then
> you'd look identical to everyone else...

Nope :) That would be a big waste, and it's not simple as that would
also prevent us from using large pages on the linear mapping unless
we start playing horrible tricks with where consistent memory is
allocated from etc... we have a fully coherent DMA architecture, we'd
rather use it !

And that wouldn't help vs. spinlocks which are in real RAM
(we have a similar issue with IO leaking potentially out of locks, 
if we don't use some heavy barriers there too).

> The alternative in I/O terms is to implement an ownership model for
> consistent PCI memory itself...which is sort of what I had to do in the
> dma_noncoherent_alloc() API, but to make that more general would be
> quite a bit of work.

The alternative is to have proper barrier abstractions to use between
MMIO read & consistent memory read, and between consistent memory write
& MMIO write ... or get the architecture designers at IBM change the
way our barriers operate in future chips ;) (which is less likely ? :)

Ben.
 

