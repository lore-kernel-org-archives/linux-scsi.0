From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 10226] New: BusLogic Flashpoint SCSI Adapter
	not working with x86_64 kernels
Date: Wed, 12 Mar 2008 07:29:49 -0400
Message-ID: <1205321389.2941.95.camel@localhost.localdomain>
References: <bug-10226-10286@http.bugzilla.kernel.org/>
	 <20080311134440.fb1609cb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37476 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbYCLMN1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 08:13:27 -0400
In-Reply-To: <20080311134440.fb1609cb.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, us-@gmx.de, protasnb <protasnb@gmail.com>


On Tue, 2008-03-11 at 13:44 -0700, Andrew Morton wrote:
> I thought that scsi-related bugzilla reports were being autosent to
> linux-scsi but afacit that isn't working.  Is it supposed to be?

It certainly is ... no-one's watching the bugzilla, so if it's not
sending the email, the bug reports will just be getting dropped.   I've
cc'd Natalie to see if she can investigate the problem.

> Anyway, have a bug!  We don't appear to have a buslogic maintainer?

Not since Leonard Zubkoff, I'm afraid, no.

> On Tue, 11 Mar 2008 13:24:49 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=10226
> > 
> >            Summary: BusLogic Flashpoint SCSI Adapter not working with x86_64
> >                     kernels
> >            Product: SCSI Drivers
> >            Version: 2.5
> >      KernelVersion: 2.6.24.3
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: BUSLOGIC
> >         AssignedTo: scsi_drivers-buslogic@kernel-bugs.osdl.org
> >         ReportedBy: us-@gmx.de
> > 
> > 
> > Latest working kernel version: unknown
> > 
> > Earliest failing kernel version: unknown (but 2.6.18 fails, too)
> > 
> > Distribution: Debian Etch
> > 
> > Hardware Environment: BusLogic Flashpoint BT-950 UW-SCSI on ASUS M2NPV-VM with
> > Athlon64 Brisbane
> > 
> > Software Environment: Minimal Debian installation (just the netinstall image
> > plus build environment to be able to build the kernel)
> > 
> > Problem Description:
> > BusLogic Flashpoint Adapter doesn't work with kernels compiled for x86_64.
> > 'dmesg' shows
> > 
> > BusLogic: FlashPoint Host Adapter detected at PCI Bus 4 Device 8
> > BusLogic: I/O Address 0xCC00 PCI Address 0xFDBFE000, irq 16, but FlashPoint
> > BusLogic: support was omitted in this kernel configuration.
> > 
> > even though CONFIG_SCSI_OMIT_FLASHPOINT was not set.
> > The SCSi Adapter works fine with a kernel compiled with the same configuration
> > for i686. 'dmesg' in that case shows 

Um, are you sure about that?  The kernel source has these particular
lines enclosed in

#ifndef CONFIG_SCSI_OMIT_FLASHPOINT 
...
#else
print the message you see
#endif

So that symbol has to be defined somewhere, somehow.

Could you do a 

grep -r SCSI_OMIT_FLASHPOINT .

In your kernel build and see what turns up?

Thanks,

James


