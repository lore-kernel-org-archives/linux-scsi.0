From: Matthew Wilcox <willy@debian.org>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Sat, 18 Sep 2004 02:25:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040918012517.GA642@parcelfarce.linux.theplanet.co.uk>
References: <B179AE41C1147041AA1121F44614F0B0DD04CA@AVEXCH02.qlogic.org> <1095465337.1944.3.camel@mulgrave> <20040918011510.GA31628@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63400 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269083AbUIRBZT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 21:25:19 -0400
Content-Disposition: inline
In-Reply-To: <20040918011510.GA31628@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@sgi.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Paul Jackson <pj@sgi.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Fri, Sep 17, 2004 at 06:15:10PM -0700, Andrew Vasquez wrote:
> On Fri, 17 Sep 2004, James Bottomley wrote:
> > Just to confirm if we absolutely have to do this...the offending reads
> > to issue the posting flush were to the register you just wrote to to get
> > the chip to reset.  However, any MMIO read to any region of that card
> > would also trigger a posted write flush.  Does the chip drop entirely
> > off the PCI bus during the execution of reset, or could we perhaps issue
> > an innocuous read to somewhere in PCI configuration space for the card?
> 
> I had asked the hardware guy a similar question -- for the soft-reset
> operation, we'll _not_ be able to issue additional readw()s until '16
> PCI clocks elapse.'  So, it seems we'll have to settle with the
> udelay() in this particular instance.

But the write that starts the reset can be delayed arbitrarily, so we need
to do *some* kind of read from the device to be know that it got there.
Can we access config space instead of mmio space?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
