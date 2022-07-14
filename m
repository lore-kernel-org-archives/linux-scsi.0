Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B8AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 11:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238697AbiGNLWs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 07:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238678AbiGNLWh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 07:22:37 -0400
Received: from sinsgout.his.huawei.com (sinsgout.his.huawei.com [119.8.179.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2AA564FF;
        Thu, 14 Jul 2022 04:22:26 -0700 (PDT)
Received: from sinmsgout03.his.huawei.com (unknown [172.28.115.130])
        by sinsgout.his.huawei.com (SkyGuard) with ESMTP id 4LkBsp2Rmfz3h1s3;
        Thu, 14 Jul 2022 19:22:22 +0800 (CST)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.156.148])
        by sinmsgout03.his.huawei.com (SkyGuard) with ESMTP id 4LkBrQ6KWpz9v7Bs;
        Thu, 14 Jul 2022 19:21:10 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Jul 2022 13:22:15 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Jul 2022 12:22:11 +0100
From:   John Garry <john.garry@huawei.com>
To:     <damien.lemoal@opensource.wdc.com>, <joro@8bytes.org>,
        <will@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hch@lst.de>,
        <m.szyprowski@samsung.com>, <robin.murphy@arm.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <iommu@lists.linux.dev>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v6 3/6] scsi: core: Cap shost max_sectors according to DMA limits only once
Date:   Thu, 14 Jul 2022 19:15:26 +0800
Message-ID: <1657797329-98541-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1657797329-98541-1-git-send-email-john.garry@huawei.com>
References: <1657797329-98541-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The shost->max_sectors is repeatedly capped according to the host DMA
mapping limit for each sdev in __scsi_init_queue(). This is unnecessary, so
set only once when adding the host.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/hosts.c    | 5 +++++
 drivers/scsi/scsi_lib.c | 4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8352f90d997d..d04bd2c7c9f1 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -236,6 +236,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 	shost->dma_dev = dma_dev;
 
+	if (dma_dev->dma_mask) {
+		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
+				dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
+	}
+
 	error = scsi_mq_setup_tags(shost);
 	if (error)
 		goto fail;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6ffc9e4258a8..6ce8acea322a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1884,10 +1884,6 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 		blk_queue_max_integrity_segments(q, shost->sg_prot_tablesize);
 	}
 
-	if (dev->dma_mask) {
-		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
-				dma_max_mapping_size(dev) >> SECTOR_SHIFT);
-	}
 	blk_queue_max_hw_sectors(q, shost->max_sectors);
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 	dma_set_seg_boundary(dev, shost->dma_boundary);
-- 
2.35.3

