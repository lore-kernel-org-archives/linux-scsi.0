From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 18:16:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040922011652.GD147856@sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211346.58267.jbarnes@engr.sgi.com> <1095789421.2467.414.camel@mulgrave> <200409211409.11095.jbarnes@engr.sgi.com> <20040921190625.GB11708@colo.lackof.org> <20040921210341.GC146363@sgi.com> <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk> <20040921214302.GG146363@sgi.com> <20040922000211.GE16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:17035 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S266233AbUIVBRR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 21:17:17 -0400
Content-Disposition: inline
In-Reply-To: <20040922000211.GE16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>, Jesse Barnes <jbarnes@engr.sgi.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Wed, Sep 22, 2004 at 01:02:11AM +0100, Matthew Wilcox wrote:
> On Tue, Sep 21, 2004 at 02:43:02PM -0700, Jeremy Higdon wrote:
> > That could be very painful.
> > On Irix, we actually had a separate spinunlock (io_spin_unlock) that
> > added the MIPS equivalent.  I'm assuming we don't want to entertain
> > that here :-)  (Though tell me if I'm wrong)
> 
> That seems like a reasonable solution to me.  Want to float it to Linus
> and see how he takes it?


First let's make sure that we like it best.

The other alternative is an explicit I/O barrier.

	writel(high-water, request-in)
	mmiob()  /* memory-mapped I/O barrier */
	spin_unlock(hostlock)

versus

	writel(high-water, request-in)
	spin_unlock_iob(hostlock)

I think I like the former better (even though we had the latter in Irix).
But I don't have a strong preference.

One of us will offer a patch.

jeremy
