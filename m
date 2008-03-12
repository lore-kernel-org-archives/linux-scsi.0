From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 10226] New: BusLogic Flashpoint SCSI Adapter
	not working with x86_64 kernels
Date: Wed, 12 Mar 2008 14:02:50 -0500
Message-ID: <1205348570.2941.140.camel@localhost.localdomain>
References: <bug-10226-10286@http.bugzilla.kernel.org/>
	 <20080311134440.fb1609cb.akpm@linux-foundation.org>
	 <47D7B875.4020606@panasas.com>  <200803121920.13571.us-@gmx.de>
	 <1205347010.2941.127.camel@localhost.localdomain>
	 <47D825B5.7060201@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42480 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYCLTCx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 15:02:53 -0400
In-Reply-To: <47D825B5.7060201@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Ulrich Schweitzer <us-@gmx.de>, Andrew Morton <akpm@linux-foundation.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2008-03-12 at 20:49 +0200, Boaz Harrosh wrote:
> On Wed, Mar 12 2008 at 20:36 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Wed, 2008-03-12 at 19:20 +0100, Ulrich Schweitzer wrote:
> >> On Wednesday March 12 2008, Boaz Harrosh wrote:
> >>
> >>> An attached config file could help.
> >>> It looks like you need ISA_DMA_API && VIRT_TO_BUS enabled are they?
> >> They are both enabled, but consider that I didn't customize the kernel in any 
> >> way besides changing the processor type to K8 and setting CONFIG_IKCONFIG and 
> >> CONFIG_IKCONFIG_PROC. I don't know if I need the options you mentioned.
> >>
> >> I first noticed the problem with a Fedora kernel and compiled this one only to 
> >> confirm that the problem exists in the vanilla kernel as well.
> >>
> >> Here is the complete .config:
> > 
> > Actually, this is the problem in BusLogic.h:
> > 
> > /*
> >   FlashPoint support is only available for the Intel x86 Architecture with
> >   CONFIG_PCI set.
> > */
> > 
> > #ifndef __i386__
> > #undef CONFIG_SCSI_OMIT_FLASHPOINT
> > #define CONFIG_SCSI_OMIT_FLASHPOINT
> > #endif
> > 
> > #ifndef CONFIG_PCI
> > #undef CONFIG_SCSI_OMIT_FLASHPOINT
> > #define CONFIG_SCSI_OMIT_FLASHPOINT
> > #define BusLogic_InitializeProbeInfoListISA BusLogic_InitializeProbeInfoList
> > #endif
> > 
> > Having this dependency logic done in the header file is not very user
> > friendly, but the comment is pretty clear.  I can move it to Kconfig,
> > but it will still not work on x86_64 if that comment is accurate.
> > 
> > James
> > 
> 
> I think the all thing is total bullshit and should be removed. First
> it says x86 but that's not what is checked.

Yes it is ... when this driver was written, i386 and x86 were
synonymous.

>  Second if it is LE bad
> then it should be possible to be compiled on other ARCHs and problems
> reported and fixed. There is never a point in not letting it compile.

This is just a guess ...

Flashpoint is 7,700 lines long; be my guest and look in it to see what
the problem is.  Unfortunately, the original author isn't around to
explain the reasoning.

However, it seems obvious to me that the packed sccb format will
immediately fail on a 64 bit system, so I don't think it's at all safe
to blindly enable it.  The driver also doesn't look to be big endian
safe.

> At most a | BROKEN logic in Kconfig.
> 
> The all thing stinks of Windowism with the capitalized file names and all
> that stuff.

James


