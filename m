Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B685BC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 985CC613C7
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhGIIOR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 04:14:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231477AbhGIIOQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 04:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625818293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uAae/n/zle4IpDOSCa7FGlf3dZkUVsBnDfub+cgN0WQ=;
        b=V0b9S0tJy8WoWywNmXQrbUCV+V5ymP2z3AcO+Hq+lkBJ4eGQAwSdyLgW4Ot/9Cqeo+3CrD
        eqiPgEQComusZmV2JsqokpSYll8lv+NlTzmKJ1q3JPIxIVuBCMUa3YTrQosmNKEkUt/om3
        iscs9EhMTbZ/K2qXjRIhsxaG26t4/Ek=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-DXw8UBVePIamzHzY9TYfDg-1; Fri, 09 Jul 2021 04:11:32 -0400
X-MC-Unique: DXw8UBVePIamzHzY9TYfDg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18847A40C0;
        Fri,  9 Jul 2021 08:11:30 +0000 (UTC)
Received: from localhost (ovpn-13-13.pek2.redhat.com [10.72.13.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CF5260C04;
        Fri,  9 Jul 2021 08:11:24 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 09/10] blk-mq: remove map queue helpers for pci, rdma and virtio
Date:   Fri,  9 Jul 2021 16:10:04 +0800
Message-Id: <20210709081005.421340-10-ming.lei@redhat.com>
In-Reply-To: <20210709081005.421340-1-ming.lei@redhat.com>
References: <20210709081005.421340-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now we have switched to blk_mq_dev_map_queues(), so remove these
helpers and source files.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/Makefile        |  3 ---
 block/blk-mq-pci.c    | 48 -------------------------------------------
 block/blk-mq-rdma.c   | 44 ---------------------------------------
 block/blk-mq-virtio.c | 46 -----------------------------------------
 4 files changed, 141 deletions(-)
 delete mode 100644 block/blk-mq-pci.c
 delete mode 100644 block/blk-mq-rdma.c
 delete mode 100644 block/blk-mq-virtio.c

diff --git a/block/Makefile b/block/Makefile
index 0f31c7e8a475..9437518a16ae 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -31,9 +31,6 @@ obj-$(CONFIG_IOSCHED_BFQ)	+= bfq.o
 obj-$(CONFIG_BLK_CMDLINE_PARSER)	+= cmdline-parser.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o blk-integrity.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY_T10)	+= t10-pi.o
-obj-$(CONFIG_BLK_MQ_PCI)	+= blk-mq-pci.o
-obj-$(CONFIG_BLK_MQ_VIRTIO)	+= blk-mq-virtio.o
-obj-$(CONFIG_BLK_MQ_RDMA)	+= blk-mq-rdma.o
 obj-$(CONFIG_BLK_DEV_ZONED)	+= blk-zoned.o
 obj-$(CONFIG_BLK_WBT)		+= blk-wbt.o
 obj-$(CONFIG_BLK_DEBUG_FS)	+= blk-mq-debugfs.o
diff --git a/block/blk-mq-pci.c b/block/blk-mq-pci.c
deleted file mode 100644
index b595a94c4d16..000000000000
--- a/block/blk-mq-pci.c
+++ /dev/null
@@ -1,48 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2016 Christoph Hellwig.
- */
-#include <linux/kobject.h>
-#include <linux/blkdev.h>
-#include <linux/blk-mq.h>
-#include <linux/blk-mq-pci.h>
-#include <linux/pci.h>
-#include <linux/module.h>
-
-#include "blk-mq.h"
-
-/**
- * blk_mq_pci_map_queues - provide a default queue mapping for PCI device
- * @qmap:	CPU to hardware queue map.
- * @pdev:	PCI device associated with @set.
- * @offset:	Offset to use for the pci irq vector
- *
- * This function assumes the PCI device @pdev has at least as many available
- * interrupt vectors as @set has queues.  It will then query the vector
- * corresponding to each queue for it's affinity mask and built queue mapping
- * that maps a queue to the CPUs that have irq affinity for the corresponding
- * vector.
- */
-int blk_mq_pci_map_queues(struct blk_mq_queue_map *qmap, struct pci_dev *pdev,
-			    int offset)
-{
-	const struct cpumask *mask;
-	unsigned int queue, cpu;
-
-	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		mask = pci_irq_get_affinity(pdev, queue + offset);
-		if (!mask)
-			goto fallback;
-
-		for_each_cpu(cpu, mask)
-			qmap->mq_map[cpu] = qmap->queue_offset + queue;
-	}
-
-	return 0;
-
-fallback:
-	WARN_ON_ONCE(qmap->nr_queues > 1);
-	blk_mq_clear_mq_map(qmap);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(blk_mq_pci_map_queues);
diff --git a/block/blk-mq-rdma.c b/block/blk-mq-rdma.c
deleted file mode 100644
index 14f968e58b8f..000000000000
--- a/block/blk-mq-rdma.c
+++ /dev/null
@@ -1,44 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2017 Sagi Grimberg.
- */
-#include <linux/blk-mq.h>
-#include <linux/blk-mq-rdma.h>
-#include <rdma/ib_verbs.h>
-
-/**
- * blk_mq_rdma_map_queues - provide a default queue mapping for rdma device
- * @map:	CPU to hardware queue map.
- * @dev:	rdma device to provide a mapping for.
- * @first_vec:	first interrupt vectors to use for queues (usually 0)
- *
- * This function assumes the rdma device @dev has at least as many available
- * interrupt vetors as @set has queues.  It will then query it's affinity mask
- * and built queue mapping that maps a queue to the CPUs that have irq affinity
- * for the corresponding vector.
- *
- * In case either the driver passed a @dev with less vectors than
- * @set->nr_hw_queues, or @dev does not provide an affinity mask for a
- * vector, we fallback to the naive mapping.
- */
-int blk_mq_rdma_map_queues(struct blk_mq_queue_map *map,
-		struct ib_device *dev, int first_vec)
-{
-	const struct cpumask *mask;
-	unsigned int queue, cpu;
-
-	for (queue = 0; queue < map->nr_queues; queue++) {
-		mask = ib_get_vector_affinity(dev, first_vec + queue);
-		if (!mask)
-			goto fallback;
-
-		for_each_cpu(cpu, mask)
-			map->mq_map[cpu] = map->queue_offset + queue;
-	}
-
-	return 0;
-
-fallback:
-	return blk_mq_map_queues(map);
-}
-EXPORT_SYMBOL_GPL(blk_mq_rdma_map_queues);
diff --git a/block/blk-mq-virtio.c b/block/blk-mq-virtio.c
deleted file mode 100644
index 7b8a42c35102..000000000000
--- a/block/blk-mq-virtio.c
+++ /dev/null
@@ -1,46 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2016 Christoph Hellwig.
- */
-#include <linux/device.h>
-#include <linux/blk-mq.h>
-#include <linux/blk-mq-virtio.h>
-#include <linux/virtio_config.h>
-#include <linux/module.h>
-#include "blk-mq.h"
-
-/**
- * blk_mq_virtio_map_queues - provide a default queue mapping for virtio device
- * @qmap:	CPU to hardware queue map.
- * @vdev:	virtio device to provide a mapping for.
- * @first_vec:	first interrupt vectors to use for queues (usually 0)
- *
- * This function assumes the virtio device @vdev has at least as many available
- * interrupt vectors as @set has queues.  It will then query the vector
- * corresponding to each queue for it's affinity mask and built queue mapping
- * that maps a queue to the CPUs that have irq affinity for the corresponding
- * vector.
- */
-int blk_mq_virtio_map_queues(struct blk_mq_queue_map *qmap,
-		struct virtio_device *vdev, int first_vec)
-{
-	const struct cpumask *mask;
-	unsigned int queue, cpu;
-
-	if (!vdev->config->get_vq_affinity)
-		goto fallback;
-
-	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		mask = vdev->config->get_vq_affinity(vdev, first_vec + queue);
-		if (!mask)
-			goto fallback;
-
-		for_each_cpu(cpu, mask)
-			qmap->mq_map[cpu] = qmap->queue_offset + queue;
-	}
-
-	return 0;
-fallback:
-	return blk_mq_map_queues(qmap);
-}
-EXPORT_SYMBOL_GPL(blk_mq_virtio_map_queues);
-- 
2.31.1

