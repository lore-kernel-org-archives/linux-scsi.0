From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 10226] New: BusLogic Flashpoint SCSI Adapter
	not working with x86_64 kernels
Date: Wed, 12 Mar 2008 13:36:50 -0500
Message-ID: <1205347010.2941.127.camel@localhost.localdomain>
References: <bug-10226-10286@http.bugzilla.kernel.org/>
	 <20080311134440.fb1609cb.akpm@linux-foundation.org>
	 <47D7B875.4020606@panasas.com>  <200803121920.13571.us-@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47167 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbYCLSgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 14:36:55 -0400
In-Reply-To: <200803121920.13571.us-@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ulrich Schweitzer <us-@gmx.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2008-03-12 at 19:20 +0100, Ulrich Schweitzer wrote:
> On Wednesday March 12 2008, Boaz Harrosh wrote:
> 
> > An attached config file could help.
> > It looks like you need ISA_DMA_API && VIRT_TO_BUS enabled are they?
> 
> They are both enabled, but consider that I didn't customize the kernel in any 
> way besides changing the processor type to K8 and setting CONFIG_IKCONFIG and 
> CONFIG_IKCONFIG_PROC. I don't know if I need the options you mentioned.
> 
> I first noticed the problem with a Fedora kernel and compiled this one only to 
> confirm that the problem exists in the vanilla kernel as well.
> 
> Here is the complete .config:

Actually, this is the problem in BusLogic.h:

/*
  FlashPoint support is only available for the Intel x86 Architecture with
  CONFIG_PCI set.
*/

#ifndef __i386__
#undef CONFIG_SCSI_OMIT_FLASHPOINT
#define CONFIG_SCSI_OMIT_FLASHPOINT
#endif

#ifndef CONFIG_PCI
#undef CONFIG_SCSI_OMIT_FLASHPOINT
#define CONFIG_SCSI_OMIT_FLASHPOINT
#define BusLogic_InitializeProbeInfoListISA BusLogic_InitializeProbeInfoList
#endif

Having this dependency logic done in the header file is not very user
friendly, but the comment is pretty clear.  I can move it to Kconfig,
but it will still not work on x86_64 if that comment is accurate.

James


