Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71CFC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8C16143C
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbhEJO2N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 10:28:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2759 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238904AbhEJOZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 10:25:47 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Ff38H3gGRzqTrb;
        Mon, 10 May 2021 22:19:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 22:22:24 +0800
From:   John Garry <john.garry@huawei.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <hch@lst.de>, <m.szyprowski@samsung.com>
CC:     <iommu@lists.linux-foundation.org>, <baolu.lu@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, <sai.praneeth.prakhya@intel.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 01/15] iommu: Reactor iommu_group_store_type()
Date:   Mon, 10 May 2021 22:17:15 +0800
Message-ID: <1620656249-68890-2-git-send-email-john.garry@huawei.com>
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

Function iommu_group_store_type() supports changing the default domain of
an IOMMU group.

Many conditions need to be satisfied and steps taken for this action to be
successful.

Satisfying these conditions and steps will be required for setting other
IOMMU group attributes, so factor into a common part and a part specific
to update the IOMMU group attribute.

No functional change intended.

Some code comments are tidied up also.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/iommu/iommu.c | 73 +++++++++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 808ab70d5df5..4d12b607918c 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3169,20 +3169,23 @@ static int iommu_change_dev_def_domain(struct iommu_group *group,
 }
 
 /*
- * Changing the default domain through sysfs requires the users to ubind the
- * drivers from the devices in the iommu group. Return failure if this doesn't
- * meet.
+ * Changing the default domain or any other IOMMU group attribute through sysfs
+ * requires the users to unbind the drivers from the devices in the IOMMU group.
+ * Return failure if this precondition is not met.
  *
  * We need to consider the race between this and the device release path.
  * device_lock(dev) is used here to guarantee that the device release path
  * will not be entered at the same time.
  */
-static ssize_t iommu_group_store_type(struct iommu_group *group,
-				      const char *buf, size_t count)
+static ssize_t iommu_group_store_common(struct iommu_group *group,
+					const char *buf, size_t count,
+					int (*cb)(const char *buf,
+						  struct iommu_group *group,
+						  struct device *dev))
 {
 	struct group_device *grp_dev;
 	struct device *dev;
-	int ret, req_type;
+	int ret;
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
@@ -3190,25 +3193,16 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 	if (WARN_ON(!group))
 		return -EINVAL;
 
-	if (sysfs_streq(buf, "identity"))
-		req_type = IOMMU_DOMAIN_IDENTITY;
-	else if (sysfs_streq(buf, "DMA"))
-		req_type = IOMMU_DOMAIN_DMA;
-	else if (sysfs_streq(buf, "auto"))
-		req_type = 0;
-	else
-		return -EINVAL;
-
 	/*
 	 * Lock/Unlock the group mutex here before device lock to
-	 * 1. Make sure that the iommu group has only one device (this is a
+	 * 1. Make sure that the IOMMU group has only one device (this is a
 	 *    prerequisite for step 2)
 	 * 2. Get struct *dev which is needed to lock device
 	 */
 	mutex_lock(&group->mutex);
 	if (iommu_group_device_count(group) != 1) {
 		mutex_unlock(&group->mutex);
-		pr_err_ratelimited("Cannot change default domain: Group has more than one device\n");
+		pr_err_ratelimited("Cannot change IOMMU group default domain attribute: Group has more than one device\n");
 		return -EINVAL;
 	}
 
@@ -3220,16 +3214,16 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 	/*
 	 * Don't hold the group mutex because taking group mutex first and then
 	 * the device lock could potentially cause a deadlock as below. Assume
-	 * two threads T1 and T2. T1 is trying to change default domain of an
-	 * iommu group and T2 is trying to hot unplug a device or release [1] VF
-	 * of a PCIe device which is in the same iommu group. T1 takes group
-	 * mutex and before it could take device lock assume T2 has taken device
-	 * lock and is yet to take group mutex. Now, both the threads will be
-	 * waiting for the other thread to release lock. Below, lock order was
-	 * suggested.
+	 * two threads, T1 and T2. T1 is trying to change default domain
+	 * attribute of an IOMMU group and T2 is trying to hot unplug a device
+	 * or release [1] VF of a PCIe device which is in the same IOMMU group.
+	 * T1 takes the group mutex and before it could take device lock T2 may
+	 * have taken device lock and is yet to take group mutex. Now, both the
+	 * threads will be waiting for the other thread to release lock. Below,
+	 * lock order was suggested.
 	 * device_lock(dev);
 	 *	mutex_lock(&group->mutex);
-	 *		iommu_change_dev_def_domain();
+	 *		cb->iommu_change_dev_def_domain(); [example cb]
 	 *	mutex_unlock(&group->mutex);
 	 * device_unlock(dev);
 	 *
@@ -3243,7 +3237,7 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 	 */
 	mutex_unlock(&group->mutex);
 
-	/* Check if the device in the group still has a driver bound to it */
+	/* Check if the only device in the group still has a driver bound */
 	device_lock(dev);
 	if (device_is_bound(dev)) {
 		pr_err_ratelimited("Device is still bound to driver\n");
@@ -3251,7 +3245,7 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 		goto out;
 	}
 
-	ret = iommu_change_dev_def_domain(group, dev, req_type);
+	ret = (cb)(buf, group, dev);
 	ret = ret ?: count;
 
 out:
@@ -3260,3 +3254,28 @@ static ssize_t iommu_group_store_type(struct iommu_group *group,
 
 	return ret;
 }
+
+static int iommu_group_store_type_cb(const char *buf,
+				     struct iommu_group *group,
+				     struct device *dev)
+{
+	int type;
+
+	if (sysfs_streq(buf, "identity"))
+		type = IOMMU_DOMAIN_IDENTITY;
+	else if (sysfs_streq(buf, "DMA"))
+		type = IOMMU_DOMAIN_DMA;
+	else if (sysfs_streq(buf, "auto"))
+		type = 0;
+	else
+		return -EINVAL;
+
+	return iommu_change_dev_def_domain(group, dev, type);
+}
+
+static ssize_t iommu_group_store_type(struct iommu_group *group,
+				      const char *buf, size_t count)
+{
+	return iommu_group_store_common(group, buf, count,
+					iommu_group_store_type_cb);
+}
-- 
2.26.2

