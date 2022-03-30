Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CB1C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 11:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343719AbiC3LqD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Mar 2022 07:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343715AbiC3LqC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2022 07:46:02 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BDC25DA80;
        Wed, 30 Mar 2022 04:44:15 -0700 (PDT)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KT4Jx1ZJdz67MgZ;
        Wed, 30 Mar 2022 19:41:37 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 30 Mar 2022 13:44:12 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 30 Mar 2022 12:44:10 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2] scsi: core: Refine how we set tag_set NUMA node
Date:   Wed, 30 Mar 2022 19:38:35 +0800
Message-ID: <1648640315-21419-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For SCSI hosts which enable host_tagset the NUMA node returned from
blk_mq_hw_queue_to_node() is NUMA_NO_NODE always. Then, since in
scsi_mq_setup_tags() the default we choose for the tag_set NUMA node is
NUMA_NO_NODE, we always evaluate the NUMA node as NUMA_NO_NODE in
functions like blk_mq_alloc_rq_map().

The reason we get NUMA_NO_NODE from blk_mq_hw_queue_to_node() is that
the hctx_idx passed is BLK_MQ_NO_HCTX_IDX - so we can't match against a
(HW) queue mapping index.

Improve this by defaulting the tag_set NUMA node to the same NUMA node
of the SCSI host DMA dev.

Signed-off-by: John Garry <john.garry@huawei.com>
---
Difference to v1:
- use dev_to_node()

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f69b77cbf538..8352f90d997d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -229,10 +229,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (error)
 		goto fail;
 
-	error = scsi_mq_setup_tags(shost);
-	if (error)
-		goto fail;
-
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;
 	if (!dma_dev)
@@ -240,6 +236,10 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 	shost->dma_dev = dma_dev;
 
+	error = scsi_mq_setup_tags(shost);
+	if (error)
+		goto fail;
+
 	/*
 	 * Increase usage count temporarily here so that calling
 	 * scsi_autopm_put_host() will trigger runtime idle if there is
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a7788184908e..e14ad193a9c8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1977,7 +1977,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	tag_set->nr_maps = shost->nr_maps ? : 1;
 	tag_set->queue_depth = shost->can_queue;
 	tag_set->cmd_size = cmd_size;
-	tag_set->numa_node = NUMA_NO_NODE;
+	tag_set->numa_node = dev_to_node(shost->dma_dev);
 	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
 	tag_set->flags |=
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
-- 
2.26.2

