From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Query regarding modifying the DMA Mask based on the available
	memory in the system
Date: Thu, 17 Apr 2008 10:36:47 -0500
Message-ID: <1208446607.3150.16.camel@localhost.localdomain>
References: <5AE055B67BB5764693E2900C7E3699BE010CAB76@pamail.ad.lsil.com>
	 <1208441932.3150.4.camel@localhost.localdomain>
	 <87iqygk0bu.fsf@basil.nowhere.org>
	 <1208444622.3150.10.camel@localhost.localdomain>
	 <4807678A.8020906@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34735 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760898AbYDQPgv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2008 11:36:51 -0400
In-Reply-To: <4807678A.8020906@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org

On Thu, 2008-04-17 at 17:06 +0200, Andi Kleen wrote:
> James Bottomley wrote:
> > On Thu, 2008-04-17 at 16:44 +0200, Andi Kleen wrote:
> >>> For drivers that can alter their descriptor types, we have this
> >>> function:
> >>>
> >>> dma_get_required_mask()
> >> Are you sure we have it? It seems to be in drivers/base/platform.c
> >> conditional on ARCH_HAS_DMA_GET_REQUIRED_MASK, but according to my
> >> grep no architecture ever sets that flag.
> > 
> > Yes ... positive.  That's the default and correct implementation based
> > on the largest addressable physical memory.
> 
> Ok but still the whole thing is completely useless right now.

Why?  At least for aic it performs as advertised: allows the driver to
select the most efficient descriptor format.

> >> I don't think it would be very hard to implement on x86 at least,
> >> mind you. Just nobody seems to have done it so far.
> > 
> > Really, only machines with IOMMUs that want to restrict this need
> > implement it. 
> 
> I don't think so. For once in the scenario described by the original
> poster it makes some sense even without IOMMU.

OK, perhaps I don't understand something then:  The fusion is
essentially similar to the aic except it doesn't have the 39 bit packed
descriptor format, so it wants to use the 32 bit format (which is
faster) if no physical memory will be over 4GB.  That's what the
dma_get_required_mask() was exactly designed for and how it is currently
being used.

If a machine has no iommu how can the required mask be different from
the lowest mask that will reach all of physical memory?

James


