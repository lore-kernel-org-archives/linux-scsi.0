From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 11:13:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211113.20998.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409201709.45008.jbarnes@engr.sgi.com> <20040921054626.GF19511@colo.lackof.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QUEUBAYeDZTEGPI"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:12998 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267748AbUIUPTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 11:19:22 -0400
In-Reply-To: <20040921054626.GF19511@colo.lackof.org>
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

--Boundary-00=_QUEUBAYeDZTEGPI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday, September 21, 2004 1:46 am, Grant Grundler wrote:
> No it doesn't. Only if it depends on *when* the write hits the device.
> The classic example is:
>  writel(x, CMD_RESET);
>  udelay(10);
>  readl(x+STATUS); /* parisc will crash if not ready */

Ok, hopefully I've covered this in this release (patch to deviceiobook will 
come later).

The short of it is that we really need pioflush.  I'll resurrect my mmiob 
patches, change the name and prototype, and resubmit.

Thanks,
Jesse

--Boundary-00=_QUEUBAYeDZTEGPI
Content-Type: text/plain;
  charset="iso-8859-1";
  name="io_ordering.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="io_ordering.txt"

Dealing with posted writes
--------------------------

On some platforms platforms, driver writers are responsible for
ensuring that I/O writes to memory-mapped addresses on their device
arrive when expected and in the order intended.  This is typically
done by reading a 'safe' device or bridge register, causing the I/O
chipset to flush pending writes to the device before any reads are
posted.  A driver would usually use this technique immediately prior
to the exit of a critical section of code protected by spinlocks.
This would ensure that subsequent writes to I/O space arrived only
after all prior writes (much like a memory barrier op, mb(), only with
respect to I/O).

Some pseudocode to illustrate the problem of write posting:

...
spin_lock_irqsave(&dev_lock, flags)
...
writel(resetval, reset_reg); /* reset the card */
udelay(10); /* wait for reset (also needs pioflush) */
val = readl(ring_ptr); /* read initial value */
spin_unlock_irqrestore(&dev_lock, flags)
...

In this case, the card is reset by the first write.  The driver
attempts to wait for the completion of the reset using udelay.  But
since the write may be delayed and the udelay will probably start
executing right away, it may be that there's not enough time for the
write to actually arrive at the card and for the reset to occur before
the read is executed.  On some platforms, this can result in a machine
check.  Without a pioflush routine, the udelay must account for worst
case behavior.

And an example of reordering of writes between CPUs on a NUMA machine:

	...
CPU A:  spin_lock_irqsave(&dev_lock, flags)
CPU A:  ...
CPU A:  writel(newval, ring_ptr);
CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
        ...
CPU B:  spin_lock_irqsave(&dev_lock, flags)
CPU B:  ...
CPU B:  writel(newval2, ring_ptr);
CPU B:  (void)readl(safe_register); /* or read_relaxed() */

In the case above, the device may receive newval2 before it receives newval,
which could cause problems.  Fixing it is easy enough though:

        ...
CPU A:  spin_lock_irqsave(&dev_lock, flags)
CPU A:  ...
CPU A:  writel(newval, ring_ptr);
CPU A:  (void)readl(safe_register); /* maybe a config register? */
CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
        ...
CPU B:  spin_lock_irqsave(&dev_lock, flags)
CPU B:  ...
CPU B:  writel(newval2, ring_ptr);
CPU B:  (void)readl(safe_register); /* or read_relaxed() */
CPU B:  spin_unlock_irqrestore(&dev_lock, flags)

Here, the reads from safe_register will cause the I/O chipset to flush any
posted writes before actually sending the read to the chipset, preventing
possible data corruption.

inX and outX calls, on the other hand, are strongly ordered and
non-postable.  They do not need special handling. But this is
something to watch out for when converting drivers to use MMIO space
from IO Port space.

A new pioflush routine could address both of the above problems
(though drivers would still have to know how long to wait for card
resets).  It would ensure that pio writes had arrived at their
destination device before allowing executing in the current context to
continue.  Since some platforms would only be able to achieve this
through a read of a bridge config register, I think a prototype like:
  pioflush(struct device *dev, unsigned long addr);
would be necessary.  The dev argument would correspond to the device
in question, and the addr argument would be a safe register to read on
the device.  Either could be zero, but not both.


--Boundary-00=_QUEUBAYeDZTEGPI--
