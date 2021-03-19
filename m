Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64B9C4332E
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 13:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83FFD64F59
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 13:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhCSNaq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 09:30:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14019 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhCSNaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 09:30:20 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F24T24tC4zPkFh;
        Fri, 19 Mar 2021 21:27:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 21:30:08 +0800
From:   John Garry <john.garry@huawei.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hch@lst.de>,
        <m.szyprowski@samsung.com>, <robin.murphy@arm.com>
CC:     <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 5/6] dma-mapping/iommu: Add dma_set_max_opt_size()
Date:   Fri, 19 Mar 2021 21:25:47 +0800
Message-ID: <1616160348-29451-6-git-send-email-john.garry@huawei.com>
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

Add a function to allow the max size which we want to optimise DMA mappings
for.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/iommu/dma-iommu.c   |  2 +-
 include/linux/dma-map-ops.h |  1 +
 include/linux/dma-mapping.h |  5 +++++
 kernel/dma/mapping.c        | 11 +++++++++++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index a5dfbd6c0496..d35881fcfb9c 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -447,7 +447,6 @@ static dma_addr_t iommu_dma_alloc_iova(struct iommu_domain *domain,
 	return (dma_addr_t)iova << shift;
 }
 
-__maybe_unused
 static void iommu_dma_set_opt_size(struct device *dev, size_t size)
 {
 	struct iommu_domain *domain = iommu_get_dma_domain(dev);
@@ -1278,6 +1277,7 @@ static const struct dma_map_ops iommu_dma_ops = {
 	.map_resource		= iommu_dma_map_resource,
 	.unmap_resource		= iommu_dma_unmap_resource,
 	.get_merge_boundary	= iommu_dma_get_merge_boundary,
+	.set_max_opt_size	= iommu_dma_set_opt_size,
 };
 
 /*
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 51872e736e7b..fed7a183b3b9 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -64,6 +64,7 @@ struct dma_map_ops {
 	u64 (*get_required_mask)(struct device *dev);
 	size_t (*max_mapping_size)(struct device *dev);
 	unsigned long (*get_merge_boundary)(struct device *dev);
+	void (*set_max_opt_size)(struct device *dev, size_t size);
 };
 
 #ifdef CONFIG_DMA_OPS
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2a984cb4d1e0..91fe770145d4 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -144,6 +144,7 @@ u64 dma_get_required_mask(struct device *dev);
 size_t dma_max_mapping_size(struct device *dev);
 bool dma_need_sync(struct device *dev, dma_addr_t dma_addr);
 unsigned long dma_get_merge_boundary(struct device *dev);
+void dma_set_max_opt_size(struct device *dev, size_t size);
 #else /* CONFIG_HAS_DMA */
 static inline dma_addr_t dma_map_page_attrs(struct device *dev,
 		struct page *page, size_t offset, size_t size,
@@ -257,6 +258,10 @@ static inline unsigned long dma_get_merge_boundary(struct device *dev)
 {
 	return 0;
 }
+static inline void dma_set_max_opt_size(struct device *dev, size_t size)
+{
+}
+
 #endif /* CONFIG_HAS_DMA */
 
 struct page *dma_alloc_pages(struct device *dev, size_t size,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index b6a633679933..59e6acb1c471 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -608,3 +608,14 @@ unsigned long dma_get_merge_boundary(struct device *dev)
 	return ops->get_merge_boundary(dev);
 }
 EXPORT_SYMBOL_GPL(dma_get_merge_boundary);
+
+void dma_set_max_opt_size(struct device *dev, size_t size)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (!ops || !ops->set_max_opt_size)
+		return;
+
+	ops->set_max_opt_size(dev, size);
+}
+EXPORT_SYMBOL_GPL(dma_set_max_opt_size);
-- 
2.26.2

