From: Jeremy Higdon <jeremy@SGI.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Mon, 1 Dec 2003 18:02:03 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031202020203.GA174948@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060ED86@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:13275 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S264272AbTLBCD1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2003 21:03:27 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED86@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@SGI.com, mdr@SGI.com

On Mon, Dec 01, 2003 at 03:21:44PM -0800, Andrew Vasquez wrote:
> On Wednesday, November 26, 2003 5:20 PM, Jeremy Higdon wrote:
> 
> > I've found a problem with the driver on our SN2 system.  There needs
> > to be a register read after updating the Request Queue In index,
> > prior to releasing the host spin lock.
> > 
> > The calls to sn_mmiob() will need to be replaced by reading an
> > appropriate register on the chip.  sn_mmiob() is a lightweight way
> > of doing the same thing without having to go to the chip, but only
> > on SGI SN platforms. 
> > 

Jesse pointed out that my patch was screwed up, by the way, having
been done in reverse -- I don't know why I didn't see that.
Is it okay to read back from the request queue in register?
I'm planning to generate a new patch that includes the previous
changes, and I may as well generate something without the sn_mmiob.

> I'm curious, what types of symptoms were exibited without the
> sn_mmiob() call?  Did I/O stall?

No.  What happens is that writes from two different CPUs make
it to the chip out of order.  So if CPU A writes a 4 to request
queue in, and then releases the spinlock and CPU B acquires the
spinlock and writes a 5, the two writes can make it to the
chip out of order, causing the chip to think that a bunch of
new commands have been issued.  The driver detects lots of
invalid I/O completions after that (stale handles and such).

> BTW: The CACHE_FLUSH() call:
> 
> 	/* Set chip new ring index. */
> 	reg_flushed = CACHE_FLUSH(ISP_REQ_Q_IN(reg));
> 
> preceeding the WRT_REG_WORD() has been removed from my working tree
> (remnants of an ancient motherboard problem with an on-board ISP while
> using PIO).

What about setting the consistent DMA mask to -1UL?


thanks

jeremy
