From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: 21 Sep 2004 13:20:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095787216.2507.340.camel@mulgrave>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk>
	<200409211205.22575.jbarnes@engr.sgi.com>
	<1095783077.2467.145.camel@mulgrave>
	<200409211303.19110.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:14249 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267882AbUIURUl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 13:20:41 -0400
In-Reply-To: <200409211303.19110.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Matthew Wilcox <willy@debian.org>, Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, 2004-09-21 at 13:03, Jesse Barnes wrote:
> +Driver writers are responsible for ensuring that I/O writes to memory-mapped
> +addresses on their device arrive when expected and in the order intended.

Really, no.  You're making the document more confusing.  PCI devices
have *two* types of non DMA accesses (well, three, but lets forget
configuration space for the moment).

I/O Space accesses (what we call PIO) and memory accesses (what we call
MMIO)

> +This is typically done by reading a 'safe' device or bridge register, causing
> +the I/O chipset to flush pending writes to the device before any reads are

Not "bridge register" the specs say this must be an access to the
device's space.

> +sent to the target device.  A driver would usually use this technique
> +immediately prior to a read after a card reset or the exit of a critical
> +section of code protected by spinlocks.  This would ensure that subsequent I/O
> +space accesses arrived only after all prior writes.  There are really two
> +issues at play here, one is 'posting', i.e. memory-mapped I/O writes not sent
> +to the device immediately, and ordering, where on a large system writes from
> +different CPUs may arrive out of order.
>  
> -        ...
> +Some pseudocode to illustrate the problem of write posting:
> +
> +...
> +spin_lock_irqsave(&dev_lock, flags)
> +...
> +writel(resetval, reset_reg); /* reset the card */
> +udelay(10); /* wait for reset (also needs pioflush) */
> +val = readl(ring_ptr); /* read initial value */
> +spin_unlock_irqrestore(&dev_lock, flags)
> +...
> +
> +In this case, the card is reset by the first write.  The driver attempts to
> +wait for the completion of the reset using udelay.  But since the write may be
> +delayed and the udelay will probably start executing right away, it may be
> +that there's not enough time for the write to actually arrive at the card and
> +for the reset to occur before the read is executed.  On some platforms, this
> +can result in a machine check.  Unfortunately, there's no way to guarantee
> +that a write has arrived at a device short of a read from the same address

Not same address space, any address space (IO, memory or config) of the
device will do.

> +space, so in some cases, udelay() is the only option.  In any case, the driver
> +should issue an ioflush() call prior to the udelay(), passing in 0 for the

No; using udelay() to try to wait for the flush of posted writes to
occur is always a bug.

> +addr argument if no safe register exists.  This will allow the platform to
> +make an effort to get the write as close to the device as possible before
> +allowing the udelay to begin.

What ioflush() call?  There's no such thing in PCI; this is effectively
our problem.  If there were a nice flush instruction we wouldn't have to
worry about reading from somewhere on the device.  The problem is that
there's no a-priori way of knowing what read is safe to do, so there's
no generic way to extract a posting flush API.

James


