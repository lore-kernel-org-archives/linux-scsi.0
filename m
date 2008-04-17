From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Query regarding modifying the DMA Mask based on the available
	memory in the system
Date: Thu, 17 Apr 2008 09:18:52 -0500
Message-ID: <1208441932.3150.4.camel@localhost.localdomain>
References: <5AE055B67BB5764693E2900C7E3699BE010CAB76@pamail.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42324 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564AbYDQOS4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2008 10:18:56 -0400
In-Reply-To: <5AE055B67BB5764693E2900C7E3699BE010CAB76@pamail.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-04-17 at 16:40 +0800, Prakash, Sathya wrote:
> Currently the MPT Fusion drivers set DMA Mask to 64 bit if the
> architecture of the system is 64bit and if the hardware supports 64 bit
> DMA address. 
> Also in all 64 bit systems the fusion drivers use SGESimple64_t to send
> scatter gather elements to firmware. 
> 
> Even with 64 bit systems which has available memory less than 4GB the
> SGESimple64_t is used, to increase the performance I am thinking of
> modifying the driver to check the system memory in the system using the
> function si_meminfo() and if the memory is less than 4GB, then the
> driver will set the 32 bit DMA mask and will use SGESimple32_t to send
> the SGE to firmware. 
> 
> I am not sure whether this change works fine? I couldn't see any SCSI
> driver using the si_meminfo and this function seems not to return the
> physical layout of the memory. 

That's because it's not the right way to do this.

For drivers that can alter their descriptor types, we have this
function:

dma_get_required_mask()

It returns the largest mask necessary to reach all of memory.  Note:
This isn't necessarily the same as the largest physical memory on
systems because some systems with IOMMUs deliberately always return
addresses in 32 bits even in a 64 bit system.

For a usage example, see:

aic79xx_osm_pci.c:ahd_linux_pci_dev_probe()

The aic79xx has three possible descriptor formats:  A 32 bit one; a
packed 39 bit one and a full 64 bit one (which takes double the space).
It uses the above function to find out what it needs to use (the 64 bit
descriptor is operationally slower on the chip).

James


