From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10226] BusLogic Flashpoint SCSI Adapter not working with x86_64 kernels
Date: Wed, 12 Mar 2008 13:26:09 -0700 (PDT)
Message-ID: <20080312202609.3038A11D107@picon.linux-foundation.org>
References: <bug-10226-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751918AbYCLU0L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 16:26:11 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2CKQuZD015731
	for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2008 13:26:58 -0700
In-Reply-To: <bug-10226-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10226





------- Comment #8 from us-@gmx.de  2008-03-12 13:26 -------
On Wednesday March 12 2008, James Bottomley wrote:
> On Wed, 2008-03-12 at 20:49 +0200, Boaz Harrosh wrote:
> > On Wed, Mar 12 2008 at 20:36 +0200, James Bottomley 
<James.Bottomley@HansenPartnership.com> wrote:
> > > Actually, this is the problem in BusLogic.h:
> > >
> > > /*
> > >   FlashPoint support is only available for the Intel x86 Architecture
> > > with CONFIG_PCI set.
> > > */
> > >
> > > #ifndef __i386__
> > > #undef CONFIG_SCSI_OMIT_FLASHPOINT
> > > #define CONFIG_SCSI_OMIT_FLASHPOINT
> > > #endif
> > >
> > > #ifndef CONFIG_PCI
> > > #undef CONFIG_SCSI_OMIT_FLASHPOINT
> > > #define CONFIG_SCSI_OMIT_FLASHPOINT
> > > #define BusLogic_InitializeProbeInfoListISA
> > > BusLogic_InitializeProbeInfoList #endif
> > >
> > > Having this dependency logic done in the header file is not very user
> > > friendly, but the comment is pretty clear.  I can move it to Kconfig,
> > > but it will still not work on x86_64 if that comment is accurate.
> > >
> > > James
> >
> > I think the all thing is total bullshit and should be removed. First
> > it says x86 but that's not what is checked.
>
> Yes it is ... when this driver was written, i386 and x86 were
> synonymous.
>
> >  Second if it is LE bad
> > then it should be possible to be compiled on other ARCHs and problems
> > reported and fixed. There is never a point in not letting it compile.
>
> This is just a guess ...
>
> Flashpoint is 7,700 lines long; be my guest and look in it to see what
> the problem is.  Unfortunately, the original author isn't around to
> explain the reasoning.
>
> However, it seems obvious to me that the packed sccb format will
> immediately fail on a 64 bit system, so I don't think it's at all safe
> to blindly enable it.  The driver also doesn't look to be big endian
> safe.

You are right. I removed those lines and recompiled the module.  Now I get 

BusLogic: FlashPoint Host Adapter detected at PCI Bus 4 Device 8
BusLogic: I/O Address 0xCC00 PCI Address 0xFDBFE000, but FlashPoint
BusLogic: Probe Function failed to validate it.

when I try to insert it.

Sorry for straying off topic, but this has to be the right crowd to ask:
I assume that the driver won't be ported to x86_64 soon (if ever), so I'll 
need a different SCSI adapter. Is the Adaptec AHA-2940 supported on x86_64 
(those are cheap on ebay)? If not, what other, preferably cheap, SE SCSI 
adapter would you recommend?

Ulrich


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
