Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C4CC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFFC3611BF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 14:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239170AbhEJO1W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 10:27:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2754 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbhEJOXq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 10:23:46 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Ff38H5mrnzqTrg;
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
Subject: [PATCH v2 00/15] dma mapping/iommu: Allow IOMMU IOVA rcache range to be configured
Date:   Mon, 10 May 2021 22:17:14 +0800
Message-ID: <1620656249-68890-1-git-send-email-john.garry@huawei.com>
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

This series allows the IOVA rcache range be configured, so that we may
cache all IOVAs per domain, thus improving performance.

A new IOMMU group sysfs file is added - max_opt_dma_size - which is used
indirectly to configure the IOVA rcache range:
/sys/kernel/iommu_groups/X/max_opt_dma_size

This file is updated same as how the IOMMU group default domain type is
updated, i.e. must unbind the only device in the group first. However, the
IOMMU default domain is reallocated in the device driver reprobe, and not
immediately.

In addition, we keep (from v1 series) the DMA mapping API to allow DMA max
optimised size be set from a LLDD. How it works is a lot different. When
the LLDD calls this during probe, once the value is successfully recorded, we
return -EDEFER_PROBE. In the reprobe, the IOMM group default domain is
reallocated, and the new IOVA domain rcache upper limit is set according
to that DMA max optimised size. As such, we don't operate on a live IOMMU
domain.

Note that the DMA mapping API frontend is not strictly required, but saves
the LLDD calling IOMMU APIs directly, that being not preferred.

Some figures for storage scenario:
v5.13-rc1 baseline:			1200K IOPS
With series:				1800K IOPS

All above are for IOMMU strict mode. Non-strict mode gives ~1800K IOPS in
all scenarios.

Patch breakdown:
1-11: Add support for setting DMA max optimised size via sysfs
12-15: Add support for setting DMA max optimised size from LLDD

[0] https://lore.kernel.org/linux-iommu/20210129092120.1482-1-thunder.leizhen@huawei.com/
[1] https://lore.kernel.org/linux-iommu/1607538189-237944-1-git-send-email-john.garry@huawei.com/

Differences to v1:
- Many
- Change method to not operate on a 'live' IOMMU domain:
	- rather, force device driver to be re-probed once
	  dma_max_opt_size is set, and reconfig a new IOMMU group then
- Add iommu sysfs max_dma_opt_size file, and allow updating same as how
  group type is changed 

John Garry (15):
  iommu: Reactor iommu_group_store_type()
  iova: Allow rcache range upper limit to be flexible
  iommu: Allow max opt DMA len be set for a group via sysfs
  iommu: Add iommu_group_get_max_opt_dma_size()
  iova: Add iova_domain_len_is_cached()
  iommu: Allow iommu_change_dev_def_domain() realloc default domain for
    same type
  iommu: Add iommu_realloc_dev_group()
  dma-iommu: Add iommu_reconfig_dev_group_dma()
  iova: Add init_iova_domain_ext()
  dma-iommu: Use init_iova_domain_ext() for IOVA domain init
  dma-iommu: Reconfig group domain
  iommu: Add iommu_set_dev_dma_opt_size()
  dma-mapping: Add dma_set_max_opt_size()
  dma-iommu: Add iommu_dma_set_opt_size()
  scsi: hisi_sas: Set max optimal DMA size for v3 hw

 drivers/iommu/dma-iommu.c              |  51 +++++-
 drivers/iommu/iommu.c                  | 231 +++++++++++++++++++------
 drivers/iommu/iova.c                   |  61 +++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |   5 +
 include/linux/dma-iommu.h              |   4 +
 include/linux/dma-map-ops.h            |   1 +
 include/linux/dma-mapping.h            |   8 +
 include/linux/iommu.h                  |  19 ++
 include/linux/iova.h                   |  21 ++-
 kernel/dma/mapping.c                   |  11 ++
 10 files changed, 344 insertions(+), 68 deletions(-)

-- 
2.26.2

