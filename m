From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] x86-64: pci-gart iommu sg chaining zeroes wrong sg.
Date: Fri, 28 Sep 2007 01:38:27 +0900
Message-ID: <20070928013550M.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52295 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbXI0Qjf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2007 12:39:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

This patch is for Jens' block tree (sg chaining branch).

I don't have the hardware but this looks like a bug.

---
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86-64: pci-gart iommu sg chaining zeroes a wrong sg's dma_length

Needs to zero the end of the list.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86_64/kernel/pci-gart.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index 27b7db4..a4151a7 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -425,9 +425,10 @@ int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 	if (dma_map_cont(start_sg, i - start, sgmap, pages, need) < 0)
 		goto error;
 	out++;
+	sgmap = sg_next(sgmap);
 	flush_gart();
 	if (out < nents)
-		ps->dma_length = 0;
+		sgmap->dma_length = 0;
 	return out;
 
 error:
-- 
1.5.2.4

