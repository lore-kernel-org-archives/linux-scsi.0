From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 19:58:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922025805.GA148414@sgi.com>
References: <200409211346.58267.jbarnes@engr.sgi.com> <1095789421.2467.414.camel@mulgrave> <200409211409.11095.jbarnes@engr.sgi.com> <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com> <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk> <20040921214302.GG146363@sgi.com> <20040922000211.GE16153@parcelfarce.linux.theplanet.co.uk> <20040922011652.GD147856@sgi.com> <20040922014428.GD20053@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:18140 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S267708AbUIVC6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 22:58:30 -0400
Content-Disposition: inline
In-Reply-To: <20040922014428.GD20053@colo.lackof.org>
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@engr.sgi.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 07:44:28PM -0600, Grant Grundler wrote:
> On Tue, Sep 21, 2004 at 06:16:52PM -0700, Jeremy Higdon wrote:
> > First let's make sure that we like it best.
> > 
> > The other alternative is an explicit I/O barrier.
> > 
> > 	writel(high-water, request-in)
> > 	mmiob()  /* memory-mapped I/O barrier */
> > 	spin_unlock(hostlock)
> 
> I strongly prefer a seperate function call.
> 
> I'm wondering if one for write posting and a different for write ordering
> would be called for. These are really distinct uses but I'm not sure
> it's a distinction that's clear to most folks and they will get misused.
> If not, then io_mwb() would be my preference.

I risk opening yet another can of worms, but here goes . . .

I think I'm convinced that we want separate solutions for
write ordering and (I'll call it) write flushing.

Both issues are derived from write posting.

I'd define write posting as: a store instruction completing
before the write is completed.  Write ordering is a problem
if posted writes from two CPUs can complete to the device
out of order.  Write flushing would be the process of
assuring that a posted write has indeed been completed.
A write flush takes care of write ordering.

I think the only way to perform a write flush is to issue
a register read to the card in question.  This makes it
very heavy weight when all you need is ordering, especially
since ordering is apparently not a problem for many (most?)
platforms that do write posting.

So I think we need one solution for write ordering, and
a separate heavier-weight solution for write flushing.  For
platforms in which write posting does not create ordering problems
the write ordering primitive would be a no-op.

The solution for write ordering on the two arches I know about
is processor/CPU chipset specific (SGI MIPS is a "sync" instruction,
Altix is a read of a SHub register).

Whether we call it io_mwb() or mmiob() is not important to me.
Does io_mwb stand for I/O Memory-mapped Write Barrier?

Sorry to be long-winded.

jeremy
