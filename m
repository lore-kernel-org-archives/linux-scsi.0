From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] mpt2sas: Fall back to 64 bit coherent mask if 64 bit DMA
 / 32 bit coherent mask not supported
Date: Tue, 12 May 2015 18:24:43 -0500
Message-ID: <55528BBB.3000809@linux.vnet.ibm.com>
References: <555279A8.6060906@linux.vnet.ibm.com> <1431468627.20218.64.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:37024 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964961AbbELXYu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2015 19:24:50 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 12 May 2015 17:24:49 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 6A68B19D8040
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 17:15:50 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4CNOceI48169148
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 16:24:38 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4CNOkcq019557
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 17:24:46 -0600
In-Reply-To: <1431468627.20218.64.camel@kernel.crashing.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, linux-scsi <linux-scsi@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Daniel Kreling <kreling@linux.vnet.ibm.com>

On 05/12/2015 05:10 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2015-05-12 at 17:07 -0500, Brian King wrote:
>> The mpt2sas driver was changed late last year in that it now requests a 64 bit DMA
>> mask, then requests a 32 bit coherent DMA mask, then later requests a 64 bit coherent
>> DMA mask. This was 5fb1bf8aaa832e1e9ca3198de7bbecb8eff7db9c. This breaks 64 bit DMA
>> support for mpt2sas on Power and we always fall back to using 32 bit DMA. Looking
>> at the commit log, it looks like this was an intentional change.
>>
>> Ben - you had a patch set you had posted to the list back in Feb of this year, but it
>> doesn't look like it got merged. 
> 
> Right, it was broken, we can't do that unfortunately. It's a hard
> problem to fix.
> 
>> https://lists.ozlabs.org/pipermail/linuxppc-dev/2015-February/125087.html
>>
>> This would fix the issue I'm seeing on mpt2sas. Do you plan to dust that patch set
>> off and upstream it? Were there issues with it that still need to be resolved?
> 
> No that patch doesn't actually work.
> 
> What we need is essentially a new set of DMA ops that can route an
> individual map request via the iommu or the bypass window depending on
> what mask applies.

Ok. For the interim, then, Sreekanth, would you consider a patch such as the one
below to allow mpt2sas to support 64 bit DMA on architectures that don't support
a 32 bit coherent mask and a 64 bit dma mask at the same time? Only compile tested
at this point. Will run it on a Power machine shortly to confirm it doesn't
break anything...


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


8<-------


Commit 5fb1bf8aaa832e1e9ca3198de7bbecb8eff7db9c broke 64 bit DMA for mpt2sas on Power.
That commit changed the sequence for setting up the DMA and coherent DMA masks so
that during initialization the driver requests a 64 bit DMA mask and a 32 bit consistent
DMA mask, then later requests a 64 bit consistent DMA mask. The Power architecture does
not currently support this, which results in always falling back to a 32 bit DMA window,
which has a negative impact on performance. Tweak this algorithm slightly so that
if requesting a 32 bit consistent mask fails after we've successfully set a 64 bit
DMA mask, just try to get a 64 bit consistent mask. This should preserve existing
behavior on platforms that support mixed mask setting and restore previous functionality
to those that do not.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/mpt2sas/mpt2sas_base.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/mpt2sas/mpt2sas_base.c~mpt2sas_dma_mask drivers/scsi/mpt2sas/mpt2sas_base.c
--- linux/drivers/scsi/mpt2sas/mpt2sas_base.c~mpt2sas_dma_mask	2015-05-12 16:09:58.228687852 -0500
+++ linux-bjking1/drivers/scsi/mpt2sas/mpt2sas_base.c	2015-05-12 17:38:31.588060903 -0500
@@ -1200,12 +1200,14 @@ _base_config_dma_addressing(struct MPT2S
 		const uint64_t required_mask =
 		    dma_get_required_mask(&pdev->dev);
 		if ((required_mask > DMA_BIT_MASK(32)) &&
-		    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) &&
-		    !pci_set_consistent_dma_mask(pdev, consistent_dma_mask)) {
-			ioc->base_add_sg_single = &_base_add_sg_single_64;
-			ioc->sge_size = sizeof(Mpi2SGESimple64_t);
-			ioc->dma_mask = 64;
-			goto out;
+		    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+			if (!pci_set_consistent_dma_mask(pdev, consistent_dma_mask) ||
+			    !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
+				ioc->base_add_sg_single = &_base_add_sg_single_64;
+				ioc->sge_size = sizeof(Mpi2SGESimple64_t);
+				ioc->dma_mask = 64;
+				goto out;
+			}
 		}
 	}
 
_

