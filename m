From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 08:58:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0012AD90D@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:46911 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S267779AbUIUQC5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 12:02:57 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 8:42 AM, James Bottomley wrote:
> On Tue, 2004-09-21 at 11:13, Jesse Barnes wrote:
> > On Tuesday, September 21, 2004 1:46 am, Grant Grundler wrote:
> > > No it doesn't. Only if it depends on *when* the write hits the
> > >  device. The classic example is: writel(x, CMD_RESET);
> > >  udelay(10);
> > >  readl(x+STATUS); /* parisc will crash if not ready */
> > 
> > Ok, hopefully I've covered this in this release (patch to
> > deviceiobook will come later). 
> > 
> > The short of it is that we really need pioflush.  I'll resurrect my
> > mmiob patches, change the name and prototype, and resubmit.
> 
> Just to get back to the actual qla2xxx problem.
> 
> Do we agree that there are two possible solutions:
> 
> 1) Find a safe mmio read to trigger the flush of the posted
> reset write.
> 
> 2) Use a pio write to trigger the reset because we know the reset is
> active as soon as the write returns.
> 
> and if so, which one are we going to implement?
> 

>From what I can gather from the hw engineers, the config-read will not
guarantee a flush of posted writes.  And since there is 'no safe register'
accessible during the soft-reset, it seems that the pio-write issuance of 
the request to the RISC will be needed.  The issue of post-soft-reset delay
still persists -- so it would seem the udelay() are still needed.

BTW: Side comment, the 'failover-capable' driver which the 'vanilla-kernel'
driver is derived from has some special RD/WRT_REG_WORD macros defined which
perform explicit PIO operations:

	#define RD_REG_WORD_PIO(addr)		(inw((unsigned long)addr))
	#define WRT_REG_WORD_PIO(addr, data)	(outw(data,(unsigned long)addr))

that are used to access flash/gpio registers of an ISP2312v2 chip due to
some hardware problems.  I can post a patch for the soft-reset issue using 
these macros?  Which tree shall I use as a base, several patches have been
floating around which 'fix' the issue on SN2 paltforms, but also remove
what has been called 'excessive', or 'unnecessary' readw()s?

--
AV
