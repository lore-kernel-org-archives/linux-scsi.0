From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.7-rc2
Date: Sat, 11 Jun 2016 13:53:18 -0700
Message-ID: <1465678398.2364.69.camel@HansenPartnership.com>
References: <1465668572.2364.26.camel@HansenPartnership.com>
	 <CA+55aFyBOPjFoVMzGhxarXBtRfCVBBarxt-+L-_T63Taam9_qA@mail.gmail.com>
	 <CA+55aFzoFPQB6GQ-bZZJQ2bQNxDyqioxZmsDxW=P7tVOauC+AA@mail.gmail.com>
	 <1465674067.2364.43.camel@HansenPartnership.com>
	 <CA+55aFxYA66mbx9jrWCmK5SeCA1EEgKMK=wXUGJjT-JyxOWTOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59570 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883AbcFKUxV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2016 16:53:21 -0400
In-Reply-To: <CA+55aFxYA66mbx9jrWCmK5SeCA1EEgKMK=wXUGJjT-JyxOWTOA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Jan Stancek <jstancek@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sat, 2016-06-11 at 12:57 -0700, Linus Torvalds wrote:
> On Sat, Jun 11, 2016 at 12:41 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > 
> > It looks like there's a hole where the emulation should be for the
> > VPD
> > inquiry, which is what cause the whole hang up and never speak to
> > us
> > again problem.
> 
> So? What makes you think real hardware doesn't have those kinds of
> issues?

It does.  USB SCSI emulation chips are notorious for crashing when they
see the "wrong" command.  However, our fix is mostly to blacklist the
command from ever being seen by those devices as well.  That's what the
usb unusual_devs.h file is full of.

> This is no different from all the various real pieces of hardware 
> that lock up when you ask for a particular mode page that they don't
> support. We are *very* careful not to randomly read mode pages 
> because of that issue. Several things are done only if the device 
> claims it is of a sufficiently new SCSI revision etc.
> 
> None of this is new.

Right, we've got a way of coping, it's either blacklist or programmatic
compensation if we can recognise the characteristic.

> The fact that Windows apparently doesn't do the VPD inquiry - since
> qemu works work windows - should make you very very worried. Instead,
> you completely ignore this and say "oh, it's just a qemu bug".

Windows does do VPD inquiries, but not, apparently for CD ROMS.  It is
feasible for us to blacklist all CD ROMS (type ROM and WORM) like
windows apparently does, but then I'll get complaints from people whose
high end devices are no-longer optimally configured by default and
whose burn speeds have dropped as a result.

> Software that isn't tested doesn't work. That's simply a fact that
> all programmers should be intimately familiar with. I'm hoping you
> know that.
> 
> Buit why the hell do you then believe that hardware is any different?
> Because I can most definitely tell you it isn't.

I did describe how we build heuristics to cope with buggy hardware.  A
Blacklist is part of that.

> Really. You have entirely ignored the "nobody has apparently ever
> asked for vpd information" argument.

OK, so historically everyone mostly ignored the VPD pages because the
limits they describe only mattered for a few devices and most I/O
stacks couldn't be programmed to the characteristics they were
describing anyway.  Then came SSDs and a high performance penalty in
the FTL for not sending optimally sized and aligned writes and suddenly
we all had to rewrite our I/O stacks to cope and be able to receive
this wisdom from the device via the block characteristics VPD pages so
our users could get the expected IOPS out of their shiny new and
expensive devices ... and by we I mean Linux, Windows and a host of
other operating systems.

Once we did it for SSDs, everyone wanted go faster stripes for their
devices as well (array vendors and even some spinning rust type
vendors), so we got sucked into a whole cycle.

> You also don't say what it was that we did to start asking for vpd
> information. What's the commit this fixes? What is it that actually
> introduced this problem? And why can it not - like our mode page
> things - look at a lot of other fields first to judge whether the
> known problematic access is really worth it.

I think it's this one:

ommit e4c36ad756ec2de36b05c66bb50ed4ff47b0fdb0
Author: Hannes Reinecke <hare@suse.de>
Date:   Fri Apr 1 08:57:37 2016 +0200

    scsi: vpd pages are mandatory for SPC-2

The QEMU device seems to identify itself as SCSI 3 SPC-2 (SPC means
SCSI Primary Command Conformance, it's a flag the device can set to
show which standard revision it claims to comply with).  If we raise
the bar to SPC-3 then we'd not ask it for VPD pages, but we'd miss a
lot of conforming SPC-2 devices which we'd then have to whitelist.

> Look at all those other blacklists we have. They are for real 
> devices. Things like "don't do mode page 3f" etc. All the checks we 
> do before we decide it's even worth it asking for caching
> information.
> 
> We have a lot of "let's be cautious" with mode page accesses. What 
> did we do that is different for vpd? Maybe that wasn't cautious
> enough.

We tied them to a particular level of advertised conformance. 
 Initially it was SPC-3 and above, but with the above commit we lowered
it to SPC-2 and above.

> Because we do have *other* devices that already have skip_vpd_pages
> set.  So this whole thing was clearly never limited to qemu
> emulation.
> 
> So answer me already: what was the change that actually made us break
> recently?

See above.

> And *why* do you seem to continue to believe that hardware cannot be
> broken, despite all the evidence that said hardware has never ever
> been tested?

We don't.  We tried the blacklist everything and then conservatively
whitelist it with discard and that didn't really work out so well for
us either, so now we're trying the probe the device for what they say
the support in the standard and use it, with blacklists for devices
that lie approach.

James

