From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Fri, 17 Sep 2004 18:24:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095470691.31747.1.camel@praka>
References: <B179AE41C1147041AA1121F44614F0B0DD04CA@AVEXCH02.qlogic.org>
	 <1095465337.1944.3.camel@mulgrave>
	 <20040918011510.GA31628@praka.san.rr.com>
	 <20040918012517.GA642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:43138 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S269088AbUIRB2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 21:28:48 -0400
In-Reply-To: <20040918012517.GA642@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@sgi.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Paul Jackson <pj@sgi.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Fri, 2004-09-17 at 18:25, Matthew Wilcox wrote:
> On Fri, Sep 17, 2004 at 06:15:10PM -0700, Andrew Vasquez wrote:
> > On Fri, 17 Sep 2004, James Bottomley wrote:
> > > Just to confirm if we absolutely have to do this...the offending reads
> > > to issue the posting flush were to the register you just wrote to to get
> > > the chip to reset.  However, any MMIO read to any region of that card
> > > would also trigger a posted write flush.  Does the chip drop entirely
> > > off the PCI bus during the execution of reset, or could we perhaps issue
> > > an innocuous read to somewhere in PCI configuration space for the card?
> > 
> > I had asked the hardware guy a similar question -- for the soft-reset
> > operation, we'll _not_ be able to issue additional readw()s until '16
> > PCI clocks elapse.'  So, it seems we'll have to settle with the
> > udelay() in this particular instance.
> 
> But the write that starts the reset can be delayed arbitrarily, so we need
> to do *some* kind of read from the device to be know that it got there.
> Can we access config space instead of mmio space?

I'll have an answer to that question on Monday -- most, if not everyone
here has left for the weekend.

--
andrew

