From: Matthew Wilcox <matthew@wil.cx>
Subject: I/O write ordering
Date: Wed, 22 Sep 2004 15:32:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922143208.GL16153@parcelfarce.linux.theplanet.co.uk>
References: <1095789421.2467.414.camel@mulgrave> <200409211409.11095.jbarnes@engr.sgi.com> <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com> <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk> <20040921214302.GG146363@sgi.com> <20040922000211.GE16153@parcelfarce.linux.theplanet.co.uk> <20040922011652.GD147856@sgi.com> <20040922014428.GD20053@colo.lackof.org> <20040922025805.GA148414@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:23686 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265900AbUIVOcN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 10:32:13 -0400
Content-Disposition: inline
In-Reply-To: <20040922025805.GA148414@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@engr.sgi.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Richard Henderson <rth@twiddle.net>, Paul Mackerras <paulus@samba.org>

On Tue, Sep 21, 2004 at 07:58:05PM -0700, Jeremy Higdon wrote:
> I think I'm convinced that we want separate solutions for
> write ordering and (I'll call it) write flushing.

Yes, I think we have consensus on that.

> I'd define write posting as: a store instruction completing
> before the write is completed.  Write ordering is a problem
> if posted writes from two CPUs can complete to the device
> out of order.  Write flushing would be the process of
> assuring that a posted write has indeed been completed.
> A write flush takes care of write ordering.

Clear, succinct, understandable and correct.

> I think the only way to perform a write flush is to issue
> a register read to the card in question.  This makes it
> very heavy weight when all you need is ordering, especially
> since ordering is apparently not a problem for many (most?)
> platforms that do write posting.

Yes, the PCI specs make it clear that bridges can hang on to the
posted write until a read request goes through the bridge, not
just to the bridge.

> So I think we need one solution for write ordering, and
> a separate heavier-weight solution for write flushing.  For
> platforms in which write posting does not create ordering problems
> the write ordering primitive would be a no-op.

Yes.

> The solution for write ordering on the two arches I know about
> is processor/CPU chipset specific (SGI MIPS is a "sync" instruction,
> Altix is a read of a SHub register).
> 
> Whether we call it io_mwb() or mmiob() is not important to me.
> Does io_mwb stand for I/O Memory-mapped Write Barrier?

I think the only disagreement is whether we have it implicit or explicit.
I see three potential solutions:

1. iomb() [we have mb(), rmb(), wmb() already.  Does mb() imply iomb()?
   Vice versa?]
2. io_spin_unlock() which is an io barrier as well as a memory barrier.
3. Make spin_unlock an io barrier.  Expensive.

I'd quite like to hear opinions from the PPC and Alpha people, they seem to
be the most out-of-order architectures.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
