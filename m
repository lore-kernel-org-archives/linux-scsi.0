From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Query regarding modifying the DMA Mask based on the available memory in the system
Date: Thu, 17 Apr 2008 12:06:52 +0200
Message-ID: <874pa0iymb.fsf@basil.nowhere.org>
References: <5AE055B67BB5764693E2900C7E3699BE010CAB76@pamail.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:62335 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934200AbYDQKH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2008 06:07:29 -0400
In-Reply-To: <5AE055B67BB5764693E2900C7E3699BE010CAB76@pamail.ad.lsil.com> (Sathya Prakash's message of "Thu, 17 Apr 2008 16:40:43 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

"Prakash, Sathya" <Sathya.Prakash@lsi.com> writes:

> Hi All,
> Currently the MPT Fusion drivers set DMA Mask to 64 bit if the
> architecture of the system is 64bit and if the hardware supports 64 bit
> DMA address. 
> Also in all 64 bit systems the fusion drivers use SGESimple64_t to send
> scatter gather elements to firmware. 
>
> Even with 64 bit systems which has available memory less than 4GB the

Actually it doesn't depend on the available memory, but where the
memory is mapped. In practice on x86 system due to the PCI memory hole
if you have >3GB (and sometimes >2GB) you already have memory mapped
beyond the 4GB boundary.

> SGESimple64_t is used, to increase the performance I am thinking of
> modifying the driver to check the system memory in the system using the
> function si_meminfo() and if the memory is less than 4GB, then the
> driver will set the 32 bit DMA mask and will use SGESimple32_t to send
> the SGE to firmware. 
>
> I am not sure whether this change works fine? I couldn't see any SCSI
> driver using the si_meminfo and this function seems not to return the
> physical layout of the memory. 

As David pointed out it wouldn't work on systems with a true IOMMU
(which will be more and in the future). I'm not sure it makes too much
sense to really optimize for the <4GB case on servers either because
these are getting rarer and rarer too at today's memory prices.

Anyways if you really still want to do this the right way would
be probably some new interface in the PCI-DMA API that DTRT 
with IOMMU (nothing) and without. The x86-64 pci dma
code already has some boot options to force this (iommu=forcesac), 
but it currently only works with the AMD GART driver.

I guess it could make somer sense to be able to control this from
the driver. e.g. something like pci_dma_prefer_mask(....) 
and the low level architecture would return if that makes
sense on the current setup or not. Wouldn't be very hard
to implement. But again I'm not sure it's really a good idea
because all the trends are against this.

Please don't do a #ifdef driver specific hack.

-Andi
