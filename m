From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [0/21] Remove isa_unchecked_dma and some more GFP_DMAs in the mid layer v2
Date: Thu,  6 Mar 2008 21:51:12 +0100 (CET)
Message-ID: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:3792 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760025AbYCFUv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


This is v2 of the patchkit. I believe I addressed all review feedback
and did some more improvements. In particular the drivers all
use dma_alloc_coherent now (but with NULL devices) and scsi scan etc.
will not do any unnecessary bouncing. This is done by extending
the block layer to export two new allocation functions for non bouncy
memory. That is why you're in Cc, Jens.

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
the bouncing for all data anyways.

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
