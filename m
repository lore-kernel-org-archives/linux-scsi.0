From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Fri, 17 Sep 2004 18:15:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040918011510.GA31628@praka.san.rr.com>
References: <B179AE41C1147041AA1121F44614F0B0DD04CA@AVEXCH02.qlogic.org> <1095465337.1944.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:31977 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S269082AbUIRBTW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 21:19:22 -0400
Content-Disposition: inline
In-Reply-To: <1095465337.1944.3.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Jeremy Higdon <jeremy@sgi.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Paul Jackson <pj@sgi.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Fri, 17 Sep 2004, James Bottomley wrote:

> On Fri, 2004-09-17 at 18:55, Andrew Vasquez wrote:
> > The reads are there to ensure ordering of the writes at each stage of
> > the reset (in qla_init.c) and fw dumps (qla_dbg.c).  After speaking
> > with the hardware and firmware folks, the readw() after the
> > soft-reset in qla_init.c was probably what triggered the MCA.  Seems
> > we will have to settle for some sort of udelay() as what was done in
> > reset_chip().
> 
> Just to confirm if we absolutely have to do this...the offending reads
> to issue the posting flush were to the register you just wrote to to get
> the chip to reset.  However, any MMIO read to any region of that card
> would also trigger a posted write flush.  Does the chip drop entirely
> off the PCI bus during the execution of reset, or could we perhaps issue
> an innocuous read to somewhere in PCI configuration space for the card?
> 

I had asked the hardware guy a similar question -- for the soft-reset
operation, we'll _not_ be able to issue additional readw()s until '16
PCI clocks elapse.'  So, it seems we'll have to settle with the
udelay() in this particular instance.

--
Andrew
