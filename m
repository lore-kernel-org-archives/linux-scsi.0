From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Tue, 2 Dec 2003 02:01:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031202100125.GA31682@praka.local.home>
References: <B179AE41C1147041AA1121F44614F0B060ED86@AVEXCH02.qlogic.org> <20031202020203.GA174948@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls02.socal.rr.com ([66.75.160.17]:34221 "EHLO
	orngca-mls02.socal.rr.com") by vger.kernel.org with ESMTP
	id S261681AbTLBJDw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2003 04:03:52 -0500
Content-Disposition: inline
In-Reply-To: <20031202020203.GA174948@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@SGI.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@SGI.com, mdr@SGI.com

On Mon, 01 Dec 2003, Jeremy Higdon wrote:

> > On Wednesday, November 26, 2003 5:20 PM, Jeremy Higdon wrote:
> > 
> > > I've found a problem with the driver on our SN2 system.  There needs
> > > to be a register read after updating the Request Queue In index,
> > > prior to releasing the host spin lock.
> > > 
> > > The calls to sn_mmiob() will need to be replaced by reading an
> > > appropriate register on the chip.  sn_mmiob() is a lightweight way
> > > of doing the same thing without having to go to the chip, but only
> > > on SGI SN platforms. 
> > > 
> 
> Jesse pointed out that my patch was screwed up, by the way, having
> been done in reverse -- I don't know why I didn't see that.

Yes, your original explanation was sufficient.

> Is it okay to read back from the request queue in register?
> I'm planning to generate a new patch that includes the previous
> changes, and I may as well generate something without the sn_mmiob.
> 

I believe we'll need a readl() to flush the write.  Just curious, on
SGI ia64 machines, how many bridges must a PCI write transaction cross
before it reaches the target device?

> > I'm curious, what types of symptoms were exibited without the
> > sn_mmiob() call?  Did I/O stall?
> 
> No.  What happens is that writes from two different CPUs make
> it to the chip out of order.  So if CPU A writes a 4 to request
> queue in, and then releases the spinlock and CPU B acquires the
> spinlock and writes a 5, the two writes can make it to the
> chip out of order, causing the chip to think that a bunch of
> new commands have been issued.  The driver detects lots of
> invalid I/O completions after that (stale handles and such).
> 

Yep, definitely a posting problem.

> > BTW: The CACHE_FLUSH() call:
> > 
> > 	/* Set chip new ring index. */
> > 	reg_flushed = CACHE_FLUSH(ISP_REQ_Q_IN(reg));
> > 
> > preceeding the WRT_REG_WORD() has been removed from my working tree
> > (remnants of an ancient motherboard problem with an on-board ISP while
> > using PIO).
> 
> What about setting the consistent DMA mask to -1UL?
> 

Yes, and I hope a simple sysfs interface to the NVRAM (for the
GUI challenged).

Regards,
Andrew Vasquez
