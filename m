From: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [patch 12/26] g_NCR5380: fix broken MMIO compilation
Date: Sat, 29 May 2010 18:57:54 -0400
Message-ID: <1275173874.2253.22.camel@localhost>
References: <201005241922.o4OJMSxG011317@imap1.linux-foundation.org>
	 <1274746615.4491.68.camel@localhost>
	 <201005252058.38589.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56588 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756668Ab0E2W5z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2010 18:57:55 -0400
In-Reply-To: <201005252058.38589.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: akpm@linux-foundation.org, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

On Tue, 2010-05-25 at 20:58 +0200, Ondrej Zary wrote:
> On Tuesday 25 May 2010 02:16:55 Andy Walls wrote:
> > On Mon, 2010-05-24 at 12:22 -0700, akpm@linux-foundation.org wrote:
> > > From: Ondrej Zary <linux@rainbow-software.org>
> > >
> > > The ifdefs are broken so the MMIO code is never compiled and so it's
> > > broken too.  Fix them all.  Untested as I don't have the hardware.
> > >
> > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > > Cc: Andy Walls <awalls@radix.net>
> > > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >
> > I remeber inspecting this before and thinking they were fine.
> >
> > Reviewed-by: Andy Walls <awalls@md.metrocast.net>
> > (my awalls@radix.net account is obsolete)
> >
> > If anyone in the US is interested in ancient ISA bus SCSI hardware for
> > NCR5380 driver development, I can send them:
> >
> > 1. a DTC3181E
> > 	NCR5380
> > 	ISA I/O ports
> > 	no IRQ
> > 	no Pseudo-DMA
> > 	DB-25 external connector
> > 	...definitely a piece of junk.
> >
> > 2. a SUMO SCSI AT
> > 	NCR5380
> > 	ISA I/O ports
> > 	IRQ is is enabled by a bit in a board specific reg at reg_base+8
> > 	Pseudo DMA is enabled by a a board specific reg at reg_base+8
> > 	No watchdog timer on the pseudo DMA, so a failed pseudo-DMA
> > 		can hang your whole machine :D
> > 	SCSI-1 external connector (Centronics-type with bail locks)
> > 	Internal SCSI connector
> > 	Removeable terminating resistors for the card.
> > 	Two BIOS firmware images on board, each having a divide by
> > 		0 bug in their fake C/H/S drive geometry computations :D
> > 	...in general, also a piece of junk.
> >
> > Neither of them will help with testing the MMIO mode of the driver.
> 
> I actually have a memory-mapped card - Canon FG2-5202 (hardwired to IRQ7). It 
> did not work for me. But the other (I/O) mapped cards do neither. They seem 
> to work if there's no SCSI device connected but I was not able to get neither 
> IBM DORS-32160 hard disk nor SONY CDU415 CD-ROM working.
> 
> The driver hangs the machine completely because it waits for timeout using 
> time_before with interrupts disabled - e.g. in NCR5380_poll_politely() in 
> drivers/scsi/NCR5380.c.
> 
> Tried older kernels to find when did it work last time - and found none! 2.4 
> kernels were able to at least display device name and firmware version. Maybe 
> I should try some older CPU & motherboard (this was on a P3, IIRC).


I pulled out my Pentium 100 machine from the closet today.  I did some
tests with the DTC3181e and a Mustek scanner and found some old notes.

1.  The g_NCR5380 driver loads, under kernel 2.6.9 as delivered with
Fedora Core 3, but after performing some Inquiry commands (and maybe
some Test Unit Ready commands) to non-existant Targets it Oops-es the
kernel.  It appears to be problems with abort handling.

2. I know for sure that the driver worked with this machine on Redhat
5.0 or 5.2, Kernel 2.0.32  (that was RedHat 5.x before RedHat 9.0 which
was the last RedHat distro before the split into RHEL and Fedora Core)
both with my DTC card and Mustek scanner and my SUMO card with an
external Exabyte 8500 tape drive.

3. I have some half completed source code for a dedicated driver module
for the SUMO SCSI AT card.  I was working on with kernel version 2.2.5
at the time.  I'm very sure the g_NCR530 driver worked then too.

4. Alan Cox left some comments in the driver talking about waiting for
kernel 2.3 to add SMP support to the g_NCR5380 driver.  It may be
prudent to assume the driver is not SMP safe.  It may also lets me knwo
the driver had to be working still sometime in kernel v2.2


5. I recall noting at one point in the NCR5380.[ch] files' evolution
that some really platform specific code (Motorola VME cards?) started
getting hacked into the driver.  Maybe that has been split out by now. 

On a somewhat related note, I also found my old Pro Audio Spectrum 16
card, that had a NCR5380 SCSI host embedded into a Zilog chip on the
board (From the days when sound cards provided a SCSI drive interface
for playing CD-ROMs).  It used to work with the pas16 SCSI driver (which
is based on the NCR5380.[ch] files).  I don't know if the pas16 driver
still works.


My only working machine with ISA slots is a Pentium 100.  It is too slow
for me to do any serious development on, so I likely won't be making any
patches to the g_NCR5380 driver.

Good luck.

Regards,
Andy

> > > ---
> > >
> > >  drivers/scsi/g_NCR5380.c |   43 +++++++++++++++++++------------------
> > >  drivers/scsi/g_NCR5380.h |    6 ++---
> > >  2 files changed, 26 insertions(+), 23 deletions(-)
> > >
> > > diff -puN drivers/scsi/g_NCR5380.c~g_ncr5380-fix-broken-mmio-compilation

> 


