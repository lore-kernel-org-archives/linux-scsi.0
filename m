From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Query regarding modifying the DMA Mask based on the available
	memory in the system
Date: Thu, 17 Apr 2008 10:03:41 -0500
Message-ID: <1208444622.3150.10.camel@localhost.localdomain>
References: <5AE055B67BB5764693E2900C7E3699BE010CAB76@pamail.ad.lsil.com>
	 <1208441932.3150.4.camel@localhost.localdomain>
	 <87iqygk0bu.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34927 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758952AbYDQPDp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2008 11:03:45 -0400
In-Reply-To: <87iqygk0bu.fsf@basil.nowhere.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org

On Thu, 2008-04-17 at 16:44 +0200, Andi Kleen wrote:
> >
> > For drivers that can alter their descriptor types, we have this
> > function:
> >
> > dma_get_required_mask()
> 
> Are you sure we have it? It seems to be in drivers/base/platform.c
> conditional on ARCH_HAS_DMA_GET_REQUIRED_MASK, but according to my
> grep no architecture ever sets that flag.

Yes ... positive.  That's the default and correct implementation based
on the largest addressable physical memory.

> I don't think it would be very hard to implement on x86 at least,
> mind you. Just nobody seems to have done it so far.

Really, only machines with IOMMUs that want to restrict this need
implement it.  Current safety is predicated on the assumption that no
architectures with IOMMUs never return bus physical addresses above
memory physical.  If that's not true, then they *have* to implement
this.  For all others its an optimisation to return a more restricted
range.

James


