Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A6AC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F7EA6143C
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhEJO0v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 10:26:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2676 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbhEJOXq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 10:23:46 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Ff39B4WTgz1BKvs;
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
Subject: [PATCH v2 07/15] iommu: Add iommu_realloc_dev_group()
Date:   Mon, 10 May 2021 22:17:21 +0800
Message-ID: <1620656249-68890-8-git-send-email-john.garry@huawei.com>
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

Add a function to re-alloc IOMMU group default domain.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/iommu/iommu.c | 12 ++++++++++++
 include/linux/iommu.h |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f7253a973ab9..bdb9aa47dfca 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3191,6 +3191,18 @@ static int iommu_change_dev_def_domain(struct iommu_group *group,
 	return ret;
 }
 
+int iommu_realloc_dev_group(struct device *dev)
+{
+	struct iommu_group *group;
+	int ret;
+
+	group = iommu_group_get(dev);
+	ret = iommu_change_dev_def_domain(group, dev, 0, true);
+	iommu_group_put(group);
+
+	return ret;
+}
+
 /*
  * Changing the default domain or any other IOMMU group attribute through sysfs
  * requires the users to unbind the drivers from the devices in the IOMMU group.
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index e26abda94792..6e187746af0f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -482,6 +482,7 @@ bool iommu_get_dma_strict(struct iommu_domain *domain);
 
 extern int report_iommu_fault(struct iommu_domain *domain, struct device *dev,
 			      unsigned long iova, int flags);
+extern int iommu_realloc_dev_group(struct device *dev);
 
 static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
 {
@@ -699,6 +700,11 @@ static inline size_t iommu_map_sg_atomic(struct iommu_domain *domain,
 	return 0;
 }
 
+static inline int iommu_realloc_dev_group(struct device *dev)
+{
+	return -ENODEV;
+}
+
 static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
 {
 }
-- 
2.26.2

