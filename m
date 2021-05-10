Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B068C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48964610F8
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbhEJO1H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 10:27:07 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2757 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbhEJOXq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 10:23:46 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Ff38H6LJkzqTs0;
        Mon, 10 May 2021 22:19:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 22:22:25 +0800
From:   John Garry <john.garry@huawei.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <hch@lst.de>, <m.szyprowski@samsung.com>
CC:     <iommu@lists.linux-foundation.org>, <baolu.lu@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, <sai.praneeth.prakhya@intel.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 03/15] iommu: Allow max opt DMA len be set for a group via sysfs
Date:   Mon, 10 May 2021 22:17:17 +0800
Message-ID: <1620656249-68890-4-git-send-email-john.garry@huawei.com>
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

Add support to allow the maximum optimised DMA len be set for an IOMMU
group via sysfs.

This much the same with the method to change the default domain type for a
group.

However, unlike changing the default domain type, the new domains will be
allocated on a member device reprobe path.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/iommu/iommu.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 4d12b607918c..63cdfb11ebed 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -45,6 +45,7 @@ struct iommu_group {
 	struct iommu_domain *default_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
+	size_t max_opt_dma_size;
 };
 
 struct group_device {
@@ -86,6 +87,9 @@ static int iommu_create_device_direct_mappings(struct iommu_group *group,
 static struct iommu_group *iommu_group_get_for_dev(struct device *dev);
 static ssize_t iommu_group_store_type(struct iommu_group *group,
 				      const char *buf, size_t count);
+static ssize_t iommu_group_store_max_opt_dma_size(struct iommu_group *group,
+						  const char *buf,
+						  size_t count);
 
 #define IOMMU_GROUP_ATTR(_name, _mode, _show, _store)		\
 struct iommu_group_attribute iommu_group_attr_##_name =		\
@@ -554,6 +558,12 @@ static ssize_t iommu_group_show_type(struct iommu_group *group,
 	return strlen(type);
 }
 
+static ssize_t iommu_group_show_max_opt_dma_size(struct iommu_group *group,
+				     char *buf)
+{
+	return sprintf(buf, "%zu\n", group->max_opt_dma_size);
+}
+
 static IOMMU_GROUP_ATTR(name, S_IRUGO, iommu_group_show_name, NULL);
 
 static IOMMU_GROUP_ATTR(reserved_regions, 0444,
@@ -562,6 +572,9 @@ static IOMMU_GROUP_ATTR(reserved_regions, 0444,
 static IOMMU_GROUP_ATTR(type, 0644, iommu_group_show_type,
 			iommu_group_store_type);
 
+static IOMMU_GROUP_ATTR(max_opt_dma_size, 0644, iommu_group_show_max_opt_dma_size,
+			iommu_group_store_max_opt_dma_size);
+
 static void iommu_group_release(struct kobject *kobj)
 {
 	struct iommu_group *group = to_iommu_group(kobj);
@@ -648,6 +661,10 @@ struct iommu_group *iommu_group_alloc(void)
 	if (ret)
 		return ERR_PTR(ret);
 
+	ret = iommu_group_create_file(group, &iommu_group_attr_max_opt_dma_size);
+	if (ret)
+		return ERR_PTR(ret);
+
 	pr_debug("Allocated group %d\n", group->id);
 
 	return group;
@@ -3279,3 +3296,29 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 	return iommu_group_store_common(group, buf, count,
 					iommu_group_store_type_cb);
 }
+
+static int iommu_group_store_max_opt_dma_size_cb(const char *buf,
+						 struct iommu_group *group,
+						 struct device *dev)
+{
+	unsigned long val;
+	char *endp;
+
+	val = simple_strtoul(buf, &endp, 0);
+	if (endp == buf)
+		return -EINVAL;
+
+	mutex_lock(&group->mutex);
+	group->max_opt_dma_size = val;
+	mutex_unlock(&group->mutex);
+
+	return 0;
+}
+
+static ssize_t iommu_group_store_max_opt_dma_size(struct iommu_group *group,
+						  const char *buf,
+						  size_t count)
+{
+	return iommu_group_store_common(group, buf, count,
+					iommu_group_store_max_opt_dma_size_cb);
+}
-- 
2.26.2

