Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE96C32C942
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 10:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787912515; cv=none; b=nKnBQAP2qohFMlXG7tODqumGuvAqKOR6b5JtLTibcTgWlYEPIc6D3IQeSZt2vawsOUlxSQXPRJP7I43K8Yw8sTNpKxyW1dEqqxTKQVFk9+UXnmLndy3aLL/sHueM4OED4oonvxcywQl7Xu2jpF4NV6Bu0fi0FKEdyW2I14ltaYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787912515; c=relaxed/simple;
	bh=bwTr8Q9/PV3ludg73IViJ3egSVsuMkJNR6wUibdWcwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HRTyYCcAe4XcmBA3z28UYmSt35hL+3fs56dLUn2tFai04KYOX1bTtD5t5OIW80rOqeUG+xzvB+DWrEM4aCA5MucG4P4gei24knNxIg+yskEk48QYa0oHwVqTT1QooyaZAla2Q5wcHjsEHCTe5r+Y7u6vjiSsgpJxWiiORykFxmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 9EE45C527D;
	Fri, 28 Aug 2026 12:21:49 +0200 (CEST)
Message-ID: <ec3d38d7-3da1-4a0b-a256-b0e56ead9764@proxmox.com>
Date: Fri, 28 Aug 2026 12:21:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] scsi: megaraid_sas: Limit NVMe request size to the PRP
 chain frame
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260827175743.734593-1-t.lamprecht@proxmox.com>
 <20260827182106.535D61F000E9@smtp.kernel.org>
Content-Language: en-US
From: Thomas Lamprecht <t.lamprecht@proxmox.com>
In-Reply-To: <20260827182106.535D61F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1787912498820

Am 27.08.26 um 20:21 schrieb sashiko-bot@kernel.org:
> [Severity: Critical]
> This is a pre-existing issue, but since this patch directly addresses how
> megasas_make_prp_nvme() builds PRP chains and accounts for page boundaries,
> does the chain boundary detection logic in that function safely calculate
> the boundary?
> 
> Looking at megasas_make_prp_nvme() in
> drivers/scsi/megaraid/megaraid_sas_fusion.c:
> 
> 	page_mask_result = (uintptr_t)(ptr_sgl + 1) & page_mask;
>
> This tests the virtual address (ptr_sgl) against the NVMe page mask instead
> of the physical IOVA address. If the system uses an IOMMU and creates an
> unaligned virtual mapping for the DMA pool (modulo the NVMe page size), this
> will miscalculate physical NVMe page boundaries.

The observation is correct FWICT, but does not require a change to this
patch and probably also not in practice as no > 4K NVMes/controllers exist
AFAIK.

The sg_frame pool is created with an alignment of MR_DEFAULT_NVME_PAGE_SIZE:

	fusion->sg_dma_pool =
		dma_pool_create("mr_sg", &instance->pdev->dev,
				instance->max_chain_frame_sz,
				MR_DEFAULT_NVME_PAGE_SIZE, 0);

while the mask the loop tests against comes from

	mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
				MR_DEFAULT_NVME_PAGE_SIZE);

dma_pool backs its blocks with allocations of max(size, PAGE_SIZE), so the
CPU and DMA bases of a pool page are both PAGE_SIZE aligned and the blocks
sit at the same offset in each. The two tests agree as long as
mr_nvme_pg_size divides PAGE_SIZE, and can diverge once it is larger. The
driver then places the chain pointer where it sees a boundary and the
controller looks for one somewhere else, so it would read a data PRP as a
list pointer.

The misalignment can also introduce a chain pointer where an aligned buffer
has none: for a 4 KiB chain frame with an 8 KiB NVMe page size, a buffer at
0 modulo 8 KiB never trips the test, while one at 4 KiB modulo 8 KiB trips
it at offset 4088.

Reaching it needs instance->nvme_page_size above PAGE_SIZE, so above 4096 on
x86. The encoding allows it, 1 << (scratch_pad_3 & MR_NVME_PAGE_SIZE_MASK)
with a shift of at least 12, but NVMe puts the minimum memory page size at 4
KiB and the OCP datacenter SSD spec requires drives to report exactly that,
so I would not expect a larger value here. I have no data on what the MR
firmware actually reports, though. The driver logs the value at probe,

	dev_info(&instance->pdev->dev, "NVME page size\t: (%d)\n",
		 instance->nvme_page_size);

so a dmesg grep for "NVME page size" on any of the affected machines would
settle it. If one of them reports more than 4 KiB then this is live there,
and I would like to know.

This patch neither introduces nor widens that: it bounds how large a
transfer may be and does not touch where the chain pointers land.

The term that reserves room for the chain pointers,

	instance->max_chain_frame_sz / mr_nvme_pg_size

does share the assumption though: it counts boundaries as if the frame base
were page aligned, just as the test in megasas_make_prp_nvme() does, so with
a misaligned base it can be one short. I replayed the loop for chain frames
of 1024 to 15872 bytes, NVMe page sizes of 4, 8 and 16 KiB, every 4 KiB base
offset within a page, every 512 byte transfer start offset, and both
coalesced and one-entry-per-page scatterlists. The list never leaves the
frame, but above 4 KiB the worst case fills it exactly instead of leaving
the slot of slack it leaves today. At 4 KiB, where the pool alignment makes
the count exact, the margin stays.

So I would keep it out of this fix. The test wants ptr_sgl_phys instead;
that patch is below the scissors.

-- >8 --
Subject: [PATCH] scsi: megaraid_sas: Test PRP boundaries on DMA address

megasas_make_prp_nvme() decides where the chain pointer that continues a
PRP list into the next page goes by testing the CPU address of the next
entry:

	page_mask_result = (uintptr_t)(ptr_sgl + 1) & page_mask;

The controller walks the same list by its DMA address. dma_pool backs its
blocks with allocations of max(size, PAGE_SIZE), so the CPU and DMA bases
of a pool page are both PAGE_SIZE aligned and the blocks sit at the same
offset in each. The two therefore agree modulo mr_nvme_pg_size only while
that divides PAGE_SIZE. Above it the driver can place the chain pointer
where the controller does not look for one, and the controller then
follows a data PRP as a list pointer.

The misalignment can add a boundary rather than move it: for a 4 KiB chain
frame with an 8 KiB NVMe page size a buffer at 0 modulo 8 KiB never trips
the test, while one at 4 KiB modulo 8 KiB trips it at offset 4088.

ptr_sgl_phys advances in lockstep with ptr_sgl, so test that instead.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-scsi/20260827182106.535D61F000E9@smtp.kernel.org
Signed-off-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
---
NOTE: not really tested end-to-end as I do not have any controller
reporting an NVMe page size above 4096 here, not even sure one exists?

 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 056cbe50e19e..fad747206ed1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2221,7 +2221,7 @@ megasas_make_prp_nvme(struct megasas_instance *instance, struct scsi_cmnd *scmd,
 		offset = (u32)(sge_addr & page_mask);
 
 		/* Put PRP pointer due to page boundary*/
-		page_mask_result = (uintptr_t)(ptr_sgl + 1) & page_mask;
+		page_mask_result = (ptr_sgl_phys + 8) & page_mask;
 		if (unlikely(!page_mask_result)) {
 			scmd_printk(KERN_NOTICE,
 				    scmd, "page boundary ptr_sgl: 0x%p\n",

