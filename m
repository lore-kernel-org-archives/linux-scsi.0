Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC108C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C803D6143C
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbhEJO06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 10:26:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2675 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbhEJOXq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 10:23:46 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Ff39B2nMzz1BKvg;
        Mon, 10 May 2021 22:19:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 22:22:27 +0800
From:   John Garry <john.garry@huawei.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <hch@lst.de>, <m.szyprowski@samsung.com>
CC:     <iommu@lists.linux-foundation.org>, <baolu.lu@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, <sai.praneeth.prakhya@intel.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 09/15] iova: Add init_iova_domain_ext()
Date:   Mon, 10 May 2021 22:17:23 +0800
Message-ID: <1620656249-68890-10-git-send-email-john.garry@huawei.com>
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

Add extended version of init_iova_domain() which accepts an max opt
iova length argument, and use it to set the rcaches range.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/iommu/iova.c | 29 +++++++++++++++++++++++------
 include/linux/iova.h |  9 +++++++++
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 95892a0433cc..273a689006c3 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -23,7 +23,7 @@ static bool iova_rcache_insert(struct iova_domain *iovad,
 static unsigned long iova_rcache_get(struct iova_domain *iovad,
 				     unsigned long size,
 				     unsigned long limit_pfn);
-static void init_iova_rcaches(struct iova_domain *iovad);
+static void init_iova_rcaches(struct iova_domain *iovad, unsigned long iova_len);
 static void free_cpu_cached_iovas(unsigned int cpu, struct iova_domain *iovad);
 static void free_iova_rcaches(struct iova_domain *iovad);
 static void fq_destroy_all_entries(struct iova_domain *iovad);
@@ -47,8 +47,8 @@ static struct iova *to_iova(struct rb_node *node)
 }
 
 void
-init_iova_domain(struct iova_domain *iovad, unsigned long granule,
-	unsigned long start_pfn)
+__init_iova_domain(struct iova_domain *iovad, unsigned long granule,
+	unsigned long start_pfn, unsigned long iova_len)
 {
 	/*
 	 * IOVA granularity will normally be equal to the smallest
@@ -71,7 +71,21 @@ init_iova_domain(struct iova_domain *iovad, unsigned long granule,
 	rb_link_node(&iovad->anchor.node, NULL, &iovad->rbroot.rb_node);
 	rb_insert_color(&iovad->anchor.node, &iovad->rbroot);
 	cpuhp_state_add_instance_nocalls(CPUHP_IOMMU_IOVA_DEAD, &iovad->cpuhp_dead);
-	init_iova_rcaches(iovad);
+	init_iova_rcaches(iovad, iova_len);
+}
+
+void
+init_iova_domain_ext(struct iova_domain *iovad, unsigned long granule,
+	unsigned long start_pfn, unsigned long iova_len)
+{
+	__init_iova_domain(iovad, granule, start_pfn, iova_len);
+}
+
+void
+init_iova_domain(struct iova_domain *iovad, unsigned long granule,
+	unsigned long start_pfn)
+{
+	__init_iova_domain(iovad, granule, start_pfn, 0);
 }
 EXPORT_SYMBOL_GPL(init_iova_domain);
 
@@ -883,14 +897,17 @@ bool iova_domain_len_is_cached(struct iova_domain *iovad, unsigned long iova_len
 	return iova_len_to_rcache_max(iova_len) == iovad->rcache_max_size;
 }
 
-static void init_iova_rcaches(struct iova_domain *iovad)
+static void init_iova_rcaches(struct iova_domain *iovad, unsigned long iova_len)
 {
 	struct iova_cpu_rcache *cpu_rcache;
 	struct iova_rcache *rcache;
 	unsigned int cpu;
 	int i;
 
-	iovad->rcache_max_size = IOVA_RANGE_CACHE_MAX_SIZE;
+	if (iova_len)
+		iovad->rcache_max_size = iova_len_to_rcache_max(iova_len);
+	else
+		iovad->rcache_max_size = IOVA_RANGE_CACHE_MAX_SIZE;
 
 	iovad->rcaches = kcalloc(iovad->rcache_max_size,
 				 sizeof(*iovad->rcaches), GFP_KERNEL);
diff --git a/include/linux/iova.h b/include/linux/iova.h
index 04cc8eb6de38..cfe416b6a8c7 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -154,6 +154,8 @@ struct iova *reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
 	unsigned long pfn_hi);
 void init_iova_domain(struct iova_domain *iovad, unsigned long granule,
 	unsigned long start_pfn);
+void init_iova_domain_ext(struct iova_domain *iovad, unsigned long granule,
+	unsigned long start_pfn, unsigned long iova_len);
 int init_iova_flush_queue(struct iova_domain *iovad,
 			  iova_flush_cb flush_cb, iova_entry_dtor entry_dtor);
 struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn);
@@ -222,6 +224,13 @@ static inline void init_iova_domain(struct iova_domain *iovad,
 {
 }
 
+static inline void init_iova_domain_ext(struct iova_domain *iovad,
+				    unsigned long granule,
+				    unsigned long start_pfn,
+				    unsigned long iova_len)
+{
+}
+
 static inline int init_iova_flush_queue(struct iova_domain *iovad,
 					iova_flush_cb flush_cb,
 					iova_entry_dtor entry_dtor)
-- 
2.26.2

