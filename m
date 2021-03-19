Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79560C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 13:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 532B764F3B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 13:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhCSNbO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 09:31:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14016 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhCSNan (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 09:30:43 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F24T269c5zPkbj;
        Fri, 19 Mar 2021 21:27:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 21:30:06 +0800
From:   John Garry <john.garry@huawei.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hch@lst.de>,
        <m.szyprowski@samsung.com>, <robin.murphy@arm.com>
CC:     <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 1/6] iommu: Move IOVA power-of-2 roundup into allocator
Date:   Fri, 19 Mar 2021 21:25:43 +0800
Message-ID: <1616160348-29451-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1616160348-29451-1-git-send-email-john.garry@huawei.com>
References: <1616160348-29451-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the IOVA size power-of-2 rcache roundup into the IOVA allocator.

This is to eventually make it possible to be able to configure the upper
limit of the IOVA rcache range.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/iommu/dma-iommu.c |  8 ------
 drivers/iommu/iova.c      | 51 ++++++++++++++++++++++++++-------------
 2 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index af765c813cc8..15b7270a5c2a 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -429,14 +429,6 @@ static dma_addr_t iommu_dma_alloc_iova(struct iommu_domain *domain,
 
 	shift = iova_shift(iovad);
 	iova_len = size >> shift;
-	/*
-	 * Freeing non-power-of-two-sized allocations back into the IOVA caches
-	 * will come back to bite us badly, so we have to waste a bit of space
-	 * rounding up anything cacheable to make sure that can't happen. The
-	 * order of the unadjusted size will still match upon freeing.
-	 */
-	if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
-		iova_len = roundup_pow_of_two(iova_len);
 
 	dma_limit = min_not_zero(dma_limit, dev->bus_dma_limit);
 
diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index e6e2fa85271c..e62e9e30b30c 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -179,7 +179,7 @@ iova_insert_rbtree(struct rb_root *root, struct iova *iova,
 
 static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
 		unsigned long size, unsigned long limit_pfn,
-			struct iova *new, bool size_aligned)
+			struct iova *new, bool size_aligned, bool fast)
 {
 	struct rb_node *curr, *prev;
 	struct iova *curr_iova;
@@ -188,6 +188,15 @@ static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
 	unsigned long align_mask = ~0UL;
 	unsigned long high_pfn = limit_pfn, low_pfn = iovad->start_pfn;
 
+	/*
+	 * Freeing non-power-of-two-sized allocations back into the IOVA caches
+	 * will come back to bite us badly, so we have to waste a bit of space
+	 * rounding up anything cacheable to make sure that can't happen. The
+	 * order of the unadjusted size will still match upon freeing.
+	 */
+	if (fast && size < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
+		size = roundup_pow_of_two(size);
+
 	if (size_aligned)
 		align_mask <<= fls_long(size - 1);
 
@@ -288,21 +297,10 @@ void iova_cache_put(void)
 }
 EXPORT_SYMBOL_GPL(iova_cache_put);
 
-/**
- * alloc_iova - allocates an iova
- * @iovad: - iova domain in question
- * @size: - size of page frames to allocate
- * @limit_pfn: - max limit address
- * @size_aligned: - set if size_aligned address range is required
- * This function allocates an iova in the range iovad->start_pfn to limit_pfn,
- * searching top-down from limit_pfn to iovad->start_pfn. If the size_aligned
- * flag is set then the allocated address iova->pfn_lo will be naturally
- * aligned on roundup_power_of_two(size).
- */
-struct iova *
-alloc_iova(struct iova_domain *iovad, unsigned long size,
+static struct iova *
+__alloc_iova(struct iova_domain *iovad, unsigned long size,
 	unsigned long limit_pfn,
-	bool size_aligned)
+	bool size_aligned, bool fast)
 {
 	struct iova *new_iova;
 	int ret;
@@ -312,7 +310,7 @@ alloc_iova(struct iova_domain *iovad, unsigned long size,
 		return NULL;
 
 	ret = __alloc_and_insert_iova_range(iovad, size, limit_pfn + 1,
-			new_iova, size_aligned);
+			new_iova, size_aligned, fast);
 
 	if (ret) {
 		free_iova_mem(new_iova);
@@ -321,6 +319,25 @@ alloc_iova(struct iova_domain *iovad, unsigned long size,
 
 	return new_iova;
 }
+
+/**
+ * alloc_iova - allocates an iova
+ * @iovad: - iova domain in question
+ * @size: - size of page frames to allocate
+ * @limit_pfn: - max limit address
+ * @size_aligned: - set if size_aligned address range is required
+ * This function allocates an iova in the range iovad->start_pfn to limit_pfn,
+ * searching top-down from limit_pfn to iovad->start_pfn. If the size_aligned
+ * flag is set then the allocated address iova->pfn_lo will be naturally
+ * aligned on roundup_power_of_two(size).
+ */
+struct iova *
+alloc_iova(struct iova_domain *iovad, unsigned long size,
+	unsigned long limit_pfn,
+	bool size_aligned)
+{
+	return __alloc_iova(iovad, size, limit_pfn, size_aligned, false);
+}
 EXPORT_SYMBOL_GPL(alloc_iova);
 
 static struct iova *
@@ -433,7 +450,7 @@ alloc_iova_fast(struct iova_domain *iovad, unsigned long size,
 		return iova_pfn;
 
 retry:
-	new_iova = alloc_iova(iovad, size, limit_pfn, true);
+	new_iova = __alloc_iova(iovad, size, limit_pfn, true, true);
 	if (!new_iova) {
 		unsigned int cpu;
 
-- 
2.26.2

