From: Ulrich Schweitzer <us-@gmx.de>
Subject: Re: [Bugme-new] [Bug 10226] New: BusLogic Flashpoint SCSI Adapter not working with x86_64 kernels
Date: Wed, 12 Mar 2008 21:25:49 +0100
Message-ID: <200803122125.50161.us-@gmx.de>
References: <bug-10226-10286@http.bugzilla.kernel.org/> <47D825B5.7060201@panasas.com> <1205348570.2941.140.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60644 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751828AbYCLU0A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 16:26:00 -0400
In-Reply-To: <1205348570.2941.140.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

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
