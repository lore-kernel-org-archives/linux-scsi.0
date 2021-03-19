Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2FEC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 13:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E56AD64F10
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 13:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhCSNap (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 09:30:45 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14018 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhCSNaT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 09:30:19 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F24T25scqzPkWX;
        Fri, 19 Mar 2021 21:27:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 21:30:07 +0800
From:   John Garry <john.garry@huawei.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hch@lst.de>,
        <m.szyprowski@samsung.com>, <robin.murphy@arm.com>
CC:     <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 2/6] iova: Add a per-domain count of reserved nodes
Date:   Fri, 19 Mar 2021 21:25:44 +0800
Message-ID: <1616160348-29451-3-git-send-email-john.garry@huawei.com>
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

To help learn if the domain has regular IOVA nodes, add a count of
reserved nodes, calculated at init time.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/iommu/iova.c | 2 ++
 include/linux/iova.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index e62e9e30b30c..cecc74fb8663 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -717,6 +717,8 @@ reserve_iova(struct iova_domain *iovad,
 	 * or need to insert remaining non overlap addr range
 	 */
 	iova = __insert_new_range(iovad, pfn_lo, pfn_hi);
+	if (iova)
+		iovad->reserved_node_count++;
 finish:
 
 	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
diff --git a/include/linux/iova.h b/include/linux/iova.h
index c834c01c0a5b..fd3217a605b2 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -95,6 +95,7 @@ struct iova_domain {
 						   flush-queues */
 	atomic_t fq_timer_on;			/* 1 when timer is active, 0
 						   when not */
+	int reserved_node_count;
 };
 
 static inline unsigned long iova_size(struct iova *iova)
-- 
2.26.2

