From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: 21 Sep 2004 11:41:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095781309.2467.88.camel@mulgrave>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk>
	<200409201709.45008.jbarnes@engr.sgi.com>
	<20040921054626.GF19511@colo.lackof.org>
	<200409211113.20998.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:51602 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267760AbUIUPmW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 11:42:22 -0400
In-Reply-To: <200409211113.20998.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, 2004-09-21 at 11:13, Jesse Barnes wrote:
> On Tuesday, September 21, 2004 1:46 am, Grant Grundler wrote:
> > No it doesn't. Only if it depends on *when* the write hits the device.
> > The classic example is:
> >  writel(x, CMD_RESET);
> >  udelay(10);
> >  readl(x+STATUS); /* parisc will crash if not ready */
> 
> Ok, hopefully I've covered this in this release (patch to deviceiobook will 
> come later).
> 
> The short of it is that we really need pioflush.  I'll resurrect my mmiob 
> patches, change the name and prototype, and resubmit.

Just to get back to the actual qla2xxx problem.

Do we agree that there are two possible solutions:

1) Find a safe mmio read to trigger the flush of the posted reset write.

2) Use a pio write to trigger the reset because we know the reset is
active as soon as the write returns.

and if so, which one are we going to implement?

James


