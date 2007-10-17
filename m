From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] IA64: iommu uses sg_next with an invalid sg element
Date: Wed, 17 Oct 2007 17:49:27 +0900
Message-ID: <20071017174927N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:56517 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbXJQIto (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 04:49:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, tony.luck@intel.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

sg list elements might not be continuous.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/hp/common/sba_iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 4338f41..3c95f41 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -1179,7 +1179,6 @@ sba_fill_pdir(
 	u64 *pdirp = NULL;
 	unsigned long dma_offset = 0;
 
-	dma_sg--;
 	while (nents-- > 0) {
 		int     cnt = startsg->dma_length;
 		startsg->dma_length = 0;
@@ -1201,7 +1200,8 @@ sba_fill_pdir(
 			u32 pide = startsg->dma_address & ~PIDE_FLAG;
 			dma_offset = (unsigned long) pide & ~iovp_mask;
 			startsg->dma_address = 0;
-			dma_sg = sg_next(dma_sg);
+			if (n_mappings)
+				dma_sg = sg_next(dma_sg);
 			dma_sg->dma_address = pide | ioc->ibase;
 			pdirp = &(ioc->pdir_base[pide >> iovp_shift]);
 			n_mappings++;
-- 
1.5.2.4

