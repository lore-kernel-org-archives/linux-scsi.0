Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09A1C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A91646145F
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbhEJO04 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 10:26:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2677 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbhEJOXq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 10:23:46 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Ff39B4pCWz1BKvy;
        Mon, 10 May 2021 22:19:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 22:22:28 +0800
From:   John Garry <john.garry@huawei.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <hch@lst.de>, <m.szyprowski@samsung.com>
CC:     <iommu@lists.linux-foundation.org>, <baolu.lu@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, <sai.praneeth.prakhya@intel.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 12/15] iommu: Add iommu_set_dev_dma_opt_size()
Date:   Mon, 10 May 2021 22:17:26 +0800
Message-ID: <1620656249-68890-13-git-send-email-john.garry@huawei.com>
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

Add a function which allows the max optimised IOMMU DMA size to be set.

When set successfully, return -EPROBE_DEFER to inform the caller that the
device driver needs to be reprobed to take effect.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/iommu/iommu.c | 47 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/iommu.h |  7 +++++++
 2 files changed, 54 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index bdb9aa47dfca..263d78e26c48 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3058,6 +3058,53 @@ u32 iommu_sva_get_pasid(struct iommu_sva *handle)
 }
 EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
 
+int iommu_set_dev_dma_opt_size(struct device *dev, size_t size)
+{
+	struct iommu_group *group = iommu_group_get(dev);
+	struct group_device *grp_dev;
+	struct device *_dev;
+	int ret, group_count;
+
+	if (!group)
+		return 0;
+
+	mutex_lock(&group->mutex);
+
+	/*
+	 * If already set, then ignore. We may have been set via sysfs, so
+	 * honour that.
+	 */
+	if (group->max_opt_dma_size) {
+		ret = 0;
+		goto out;
+	}
+
+	group_count = iommu_group_device_count(group);
+	if (group_count != 1) {
+		dev_err_ratelimited(dev, "Cannot change DMA opt size: Group has more than one device group_count=%d\n",
+				    group_count);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Since group has only one device */
+	grp_dev = list_first_entry(&group->devices, struct group_device, list);
+	_dev = grp_dev->dev;
+
+	if (_dev != dev) {
+		dev_err_ratelimited(dev, "Cannot set DMA max opt size - device has changed\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
+	group->max_opt_dma_size = size;
+	ret = -EPROBE_DEFER;
+out:
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+	return ret;
+}
+
 /*
  * Changes the default domain of an iommu group that has *only* one device
  *
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6e187746af0f..36871e8ae636 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -428,6 +428,7 @@ extern void iommu_get_resv_regions(struct device *dev, struct list_head *list);
 extern void iommu_put_resv_regions(struct device *dev, struct list_head *list);
 extern void generic_iommu_put_resv_regions(struct device *dev,
 					   struct list_head *list);
+extern int iommu_set_dev_dma_opt_size(struct device *dev, size_t size);
 extern void iommu_set_default_passthrough(bool cmd_line);
 extern void iommu_set_default_translated(bool cmd_line);
 extern bool iommu_default_passthrough(void);
@@ -740,6 +741,12 @@ static inline int iommu_get_group_resv_regions(struct iommu_group *group,
 	return -ENODEV;
 }
 
+static inline int iommu_set_dev_dma_opt_size(struct device *dev,
+						 size_t size)
+{
+	return -ENODEV;
+}
+
 static inline void iommu_set_default_passthrough(bool cmd_line)
 {
 }
-- 
2.26.2

