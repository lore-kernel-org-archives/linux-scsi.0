From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Fri, 17 Sep 2004 19:36:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040918023624.GD119218@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0DD04CA@AVEXCH02.qlogic.org> <1095465337.1944.3.camel@mulgrave> <20040918011510.GA31628@praka.san.rr.com> <20040918012517.GA642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:23186 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S264991AbUIRChI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 22:37:08 -0400
Content-Disposition: inline
In-Reply-To: <20040918012517.GA642@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Paul Jackson <pj@sgi.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Sat, Sep 18, 2004 at 02:25:17AM +0100, Matthew Wilcox wrote:
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


This is where some sort of generic primitive for flushing posted writes
would be handy.  For any PCI implementation, there will be registers
unrelated to the chip in question that one should be able to read and
which flush the posted write.

On Altix, we have the sn_mmiob()  :-)

A pci_config_read_word() is not quite the same as a readw(), I don't
think, so maybe that would be okay?

jeremy
