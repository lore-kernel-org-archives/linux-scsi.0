Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EABC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 13:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E470464F82
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 13:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhCSNar (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 09:30:47 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14022 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhCSNaX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 09:30:23 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F24T25Y6CzPkQv;
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
Subject: [PATCH 0/6] dma mapping/iommu: Allow IOMMU IOVA rcache range to be configured
Date:   Fri, 19 Mar 2021 21:25:42 +0800
Message-ID: <1616160348-29451-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For streaming DMA mappings involving an IOMMU and whose IOVA len regularly
exceeds the IOVA rcache upper limit (meaning that they are not cached),
performance can be reduced. 

This is much more pronounced from commit 4e89dce72521 ("iommu/iova: Retry
from last rb tree node if iova search fails"), as discussed at [0].

IOVAs which cannot be cached are highly involved in the IOVA aging issue,
as discussed at [1].

This series attempts to allow the device driver hint what upper limit its
DMA mapping IOVA lengths would be, so that the caching range may be
increased.

Some figures on storage scenario:
v5.12-rc3 baseline:			600K IOPS
With series:				1300K IOPS
With reverting 4e89dce72521: 		1250K IOPS

All above are for IOMMU strict mode. Non-strict mode gives ~1750K IOPS in
all scenarios.

I will say that APIs and their semantics are a bit ropey - any better
ideas welcome...

[0] https://lore.kernel.org/linux-iommu/20210129092120.1482-1-thunder.leizhen@huawei.com/
[1] https://lore.kernel.org/linux-iommu/1607538189-237944-1-git-send-email-john.garry@huawei.com/

John Garry (6):
  iommu: Move IOVA power-of-2 roundup into allocator
  iova: Add a per-domain count of reserved nodes
  iova: Allow rcache range upper limit to be configurable
  iommu: Add iommu_dma_set_opt_size()
  dma-mapping/iommu: Add dma_set_max_opt_size()
  scsi: hisi_sas: Set max optimal DMA size for v3 hw

 drivers/iommu/dma-iommu.c              | 23 ++++---
 drivers/iommu/iova.c                   | 88 ++++++++++++++++++++------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 +
 include/linux/dma-map-ops.h            |  1 +
 include/linux/dma-mapping.h            |  5 ++
 include/linux/iova.h                   | 12 +++-
 kernel/dma/mapping.c                   | 11 ++++
 7 files changed, 115 insertions(+), 27 deletions(-)

-- 
2.26.2

