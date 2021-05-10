Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7B4C43460
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 583716143C
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242223AbhEJO2Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 10:28:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2679 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238909AbhEJOZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 10:25:47 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Ff39B5ghvz1BKw7;
        Mon, 10 May 2021 22:19:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 22:22:26 +0800
From:   John Garry <john.garry@huawei.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <hch@lst.de>, <m.szyprowski@samsung.com>
CC:     <iommu@lists.linux-foundation.org>, <baolu.lu@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, <sai.praneeth.prakhya@intel.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 08/15] dma-iommu: Add iommu_reconfig_dev_group_dma()
Date:   Mon, 10 May 2021 22:17:22 +0800
Message-ID: <1620656249-68890-9-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620656249-68890-1-git-send-email-john.garry@huawei.com>
References: <1620656249-68890-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a function to reconfigure the IOMMU group for a device, if necessary.

IOVAs are cached in power-of-2 granules, so there is no point in allocating
a new IOMMU domain if the current range is suitable.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/iommu/dma-iommu.c | 25 +++++++++++++++++++++++++
 include/linux/dma-iommu.h |  4 ++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index f6d3302bb829..4fb82c554ede 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -315,6 +315,31 @@ static bool dev_is_untrusted(struct device *dev)
 	return dev_is_pci(dev) && to_pci_dev(dev)->untrusted;
 }
 
+void iommu_reconfig_dev_group_dma(struct device *dev)
+{
+	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	unsigned long shift, iova_len;
+	struct iova_domain *iovad;
+	size_t max_opt_dma_size;
+
+	if (!cookie || cookie->type != IOMMU_DMA_IOVA_COOKIE)
+		return;
+
+	max_opt_dma_size = iommu_group_get_max_opt_dma_size(dev->iommu_group);
+	if (!max_opt_dma_size)
+		return;
+
+	iovad = &cookie->iovad;
+	shift = iova_shift(iovad);
+	iova_len = max_opt_dma_size >> shift;
+
+	if (iova_domain_len_is_cached(iovad, iova_len))
+		return;
+
+	iommu_realloc_dev_group(dev);
+}
+
 /**
  * iommu_dma_init_domain - Initialise a DMA mapping domain
  * @domain: IOMMU domain previously prepared by iommu_get_dma_cookie()
diff --git a/include/linux/dma-iommu.h b/include/linux/dma-iommu.h
index 6e75a2d689b4..097398b76dcc 100644
--- a/include/linux/dma-iommu.h
+++ b/include/linux/dma-iommu.h
@@ -20,6 +20,7 @@ void iommu_put_dma_cookie(struct iommu_domain *domain);
 
 /* Setup call for arch DMA mapping code */
 void iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 size);
+void iommu_reconfig_dev_group_dma(struct device *dev);
 
 /* The DMA API isn't _quite_ the whole story, though... */
 /*
@@ -53,6 +54,9 @@ static inline void iommu_setup_dma_ops(struct device *dev, u64 dma_base,
 		u64 size)
 {
 }
+static inline void iommu_reconfig_dev_group_dma(struct device *dev)
+{
+}
 
 static inline int iommu_get_dma_cookie(struct iommu_domain *domain)
 {
-- 
2.26.2

