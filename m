From: Matthew Wilcox <willy@debian.org>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 17:01:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921160119.GB642@parcelfarce.linux.theplanet.co.uk>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211113.20998.jbarnes@engr.sgi.com> <1095781309.2467.88.camel@mulgrave> <200409211158.25122.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:54202 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267774AbUIUQB0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 12:01:26 -0400
Content-Disposition: inline
In-Reply-To: <200409211158.25122.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 11:58:24AM -0400, Jesse Barnes wrote:
> On Tuesday, September 21, 2004 11:41 am, James Bottomley wrote:
> > Just to get back to the actual qla2xxx problem.
> >
> > Do we agree that there are two possible solutions:
> >
> > 1) Find a safe mmio read to trigger the flush of the posted reset write.
> >
> > 2) Use a pio write to trigger the reset because we know the reset is
> > active as soon as the write returns.
> >
> > and if so, which one are we going to implement?
> 
> or
>  3) use a regular write() with an associated pioflush()
> 
> For now, (1) is a good option if the driver can do it (I still haven't heard 
> if qla2xxx supports this).  I suspect that neither (1) nor (2) is available 
> to some device, leaving only udelay() or (3), which I'm working on.

How can we do pioflush()?  My understanding of PCI ordering rules is that
we need to go all the way down to the device to prevent some intermediate
bridge from delaying the write arbitrarily.  So we'd actually need the
pci_dev and read its device ID back from config space, or something.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
