From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 14:43:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921214302.GG146363@sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211346.58267.jbarnes@engr.sgi.com> <1095789421.2467.414.camel@mulgrave> <200409211409.11095.jbarnes@engr.sgi.com> <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com> <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:3049 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S268079AbUIUVnf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 17:43:35 -0400
Content-Disposition: inline
In-Reply-To: <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 10:11:08PM +0100, Matthew Wilcox wrote:
> On Tue, Sep 21, 2004 at 02:03:42PM -0700, Jeremy Higdon wrote:
> > On Altix, we do have the sn_mmiob() option.  I don't think that
> > we want to Linux API to require that
> > 
> > CPUA:	writel(value_X, common_register)
> > 	spin_unlock(common_lock)
> > 
> > CPUB:	spin_lock(common_lock)
> > 	writel(value_Y, common_register)
> > 
> > be strongly ordered, because it places a performance penalty
> > on all writes.
> 
> I disagree with you.  If this were memory, then you would expect
> common_register to be set to value_Y after this sequence.  Why should
> IO be different?

I/O is partially outside of the memory coherency domain.  So it is
different from memory, even though we might wish that it weren't.

> > On Altix, we have the "sn_mmiob()" function to do
> > that.  I.e.
> > 
> > CPUA:	writel(value_X, common_register)
> > 	sn_mmiob()
> > 	spin_unlock(common_lock)
> > 
> > CPUB:	spin_lock(common_lock)
> > 	writel(value_Y, common_register)
> > 
> > would strongly order the writes.
> 
> I think your _raw_spin_unlock() should include an sn_mmiob().

That could be very painful.
On Irix, we actually had a separate spinunlock (io_spin_unlock) that
added the MIPS equivalent.  I'm assuming we don't want to entertain
that here :-)  (Though tell me if I'm wrong)

jeremy
