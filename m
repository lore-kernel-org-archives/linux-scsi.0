Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9322C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8459B611BD
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhEJO0x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 10:26:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2758 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbhEJOXq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 10:23:46 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Ff38H4mTnzqTrf;
        Mon, 10 May 2021 22:19:11 +0800 (CST)
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
Subject: [PATCH v2 06/15] iommu: Allow iommu_change_dev_def_domain() realloc default domain for same type
Date:   Mon, 10 May 2021 22:17:20 +0800
Message-ID: <1620656249-68890-7-git-send-email-john.garry@huawei.com>
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

Allow iommu_change_dev_def_domain() to create a new default domain, keeping
the same as current in case type argument is not set.

Also remove comment about function purpose, which will become stale.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/iommu/iommu.c | 53 ++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 62e4491f32e0..f7253a973ab9 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3065,16 +3065,13 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
  * @prev_dev: The device in the group (this is used to make sure that the device
  *	 hasn't changed after the caller has called this function)
  * @type: The type of the new default domain that gets associated with the group
+ * @new: Allocate new default domain, keeping same type when no type passed
  *
  * Returns 0 on success and error code on failure
  *
- * Note:
- * 1. Presently, this function is called only when user requests to change the
- *    group's default domain type through /sys/kernel/iommu_groups/<grp_id>/type
- *    Please take a closer look if intended to use for other purposes.
  */
 static int iommu_change_dev_def_domain(struct iommu_group *group,
-				       struct device *prev_dev, int type)
+				       struct device *prev_dev, int type, bool new)
 {
 	struct iommu_domain *prev_dom;
 	struct group_device *grp_dev;
@@ -3127,28 +3124,32 @@ static int iommu_change_dev_def_domain(struct iommu_group *group,
 		goto out;
 	}
 
-	dev_def_dom = iommu_get_def_domain_type(dev);
-	if (!type) {
+	if (new && !type) {
+		type = prev_dom->type;
+	} else {
+		dev_def_dom = iommu_get_def_domain_type(dev);
+		if (!type) {
+			/*
+			 * If the user hasn't requested any specific type of domain and
+			 * if the device supports both the domains, then default to the
+			 * domain the device was booted with
+			 */
+			type = dev_def_dom ? : iommu_def_domain_type;
+		} else if (dev_def_dom && type != dev_def_dom) {
+			dev_err_ratelimited(prev_dev, "Device cannot be in %s domain\n",
+					    iommu_domain_type_str(type));
+			ret = -EINVAL;
+			goto out;
+		}
+
 		/*
-		 * If the user hasn't requested any specific type of domain and
-		 * if the device supports both the domains, then default to the
-		 * domain the device was booted with
+		 * Switch to a new domain only if the requested domain type is different
+		 * from the existing default domain type
 		 */
-		type = dev_def_dom ? : iommu_def_domain_type;
-	} else if (dev_def_dom && type != dev_def_dom) {
-		dev_err_ratelimited(prev_dev, "Device cannot be in %s domain\n",
-				    iommu_domain_type_str(type));
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/*
-	 * Switch to a new domain only if the requested domain type is different
-	 * from the existing default domain type
-	 */
-	if (prev_dom->type == type) {
-		ret = 0;
-		goto out;
+		if (prev_dom->type == type) {
+			ret = 0;
+			goto out;
+		}
 	}
 
 	/* Sets group->default_domain to the newly allocated domain */
@@ -3292,7 +3293,7 @@ static int iommu_group_store_type_cb(const char *buf,
 	else
 		return -EINVAL;
 
-	return iommu_change_dev_def_domain(group, dev, type);
+	return iommu_change_dev_def_domain(group, dev, type, false);
 }
 
 static ssize_t iommu_group_store_type(struct iommu_group *group,
-- 
2.26.2

