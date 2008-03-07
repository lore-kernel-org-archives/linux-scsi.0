From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [0/20] Remove isa_unchecked_dma and some more GFP_DMAs in the mid layer v3
Date: Fri,  7 Mar 2008 18:53:59 +0100 (CET)
Message-ID: <20080307653.720459648@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:11184 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbYCGRyC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 12:54:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


v2: various cleanups, use dma_alloc_coherent instead of naked GFP_DMA
    add blk_* allocators to avoid bouncing in SCSI scan
v3: Remove cmnd/sense buffer bouncing in advansys. 
    Replace sense_buffer_mask with a single bit

Original description:

This patchkit fixes all existing drivers that used isa_unchecked_dma
to not need that anymore.  I have some upcoming infrastructure changes 
for DMA memory management and isa_unchecked_dma was in the way.

Enabling isa_unchecked_dma had several effects:
- All incoming scsi_cmnds were in GFP_DMA memory.
Only one driver relied on that actually (advansys), the others all accessed
the scsi_cmnds only with the CPU.
- scsi hostdata is allocated with GFP_DMA
A lot of drivers relied on that. I converted them all to allocate hostdata
in a separate buffer linked to rom the scsi host structure.
- Enabling block layer bouncing for all data. That's the most important one.
I changed all drivers to do that directly instead of relying on the mid
layer for it.
- sense_buffer is allocated with GFP_DMA. That was also commonly
required and not easy to fix so I created a separate host template
field that enables sense_buffer bouncing.

Also while I was it I removed also a lot of GFP_DMAs in the frontend
drivers which are not needed anymore because the block layer does
the bouncing for all data anyways. Or rather we ask the block layer
now to bounce.

The main problem of the patchkit is that is that I wasn't able
to test the drivers because I don't have any of the hardware. All
changes (except perhaps advansys) were relatively simple and straight
forward so I don't expect many problems though.

If anybody has any of these ISA SCSI adapters and would be willing to test
them with these patches that would be appreciated.
I suspect actually that some of the ISA drivers are actually already
bitrotted independently of these changes. Hopefully they won't make
anything worse though. 

Patches against 2.6.25rc4

These are a lot of patches. I can set up a git tree if that makes
merging easier. Please let me now if I should do that.

-Andi
