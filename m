Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB2AC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DB2E613CA
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhGIINf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 04:13:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231403AbhGIINf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 04:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625818252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hTFmuCN1nhaQls6kJgr9OGlbYp4H896z+x88MfyTwr8=;
        b=SK8mApN4IEuQx0lP6miJWywiijc5aCyNZtRXBGDbUjC7JgbPCxKNDzHGTAMVXmWJq8kXxz
        1XHIf0IfVDPz1lrHgzmNYTlwWx+NoVnC3UN88WrC1iJpAOww0ZiyE4+VvKnuC9Eunu+AgP
        oqyLKUM/1zhM5dWNnivVnKJZiQkh4fg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-bX2_Ubk3MfGti4POoUDefg-1; Fri, 09 Jul 2021 04:10:51 -0400
X-MC-Unique: bX2_Ubk3MfGti4POoUDefg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 139871084F40;
        Fri,  9 Jul 2021 08:10:49 +0000 (UTC)
Received: from localhost (ovpn-13-13.pek2.redhat.com [10.72.13.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C14EB5C1D5;
        Fri,  9 Jul 2021 08:10:37 +0000 (UTC)
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
Subject: [PATCH V3 02/10] blk-mq: Introduce blk_mq_dev_map_queues
Date:   Fri,  9 Jul 2021 16:09:57 +0800
Message-Id: <20210709081005.421340-3-ming.lei@redhat.com>
In-Reply-To: <20210709081005.421340-1-ming.lei@redhat.com>
References: <20210709081005.421340-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce blk_mq_dev_map_queues so that we can remove all kinds of
map_queues implementation(pci, virtio, rdma, ...) out of block layer.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-map.c     | 53 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  5 ++++
 2 files changed, 58 insertions(+)

diff --git a/block/blk-mq-map.c b/block/blk-mq-map.c
index 3db84d3197f1..e3ba2ef1e9e2 100644
--- a/block/blk-mq-map.c
+++ b/block/blk-mq-map.c
@@ -94,3 +94,56 @@ int blk_mq_hw_queue_to_node(struct blk_mq_queue_map *qmap, unsigned int index)
 
 	return NUMA_NO_NODE;
 }
+
+/**
+ * blk_mq_dev_map_queues - provide generic queue mapping
+ * @qmap:	CPU to hardware queue map.
+ * @dev_off:	Offset to use for the device
+ * @get_queue_affinity:	Callback to retrieve queue affinity
+ * @dev_data:	Device data passed to get_queue_affinity()
+ * @fallback:	If true, fallback to default blk-mq mapping in case of
+ * any failure
+ *
+ * Generic function to setup each queue mapping in @qmap. It will query
+ * each queue's affinity via @get_queue_affinity and built queue mapping
+ * that maps a queue to the CPUs in the queue affinity.
+ *
+ * Driver has to set correct @dev_data, so that the driver callback
+ * of @get_queue_affinity can work correctly.
+ */
+int blk_mq_dev_map_queues(struct blk_mq_queue_map *qmap, void *dev_data,
+		int dev_off, get_queue_affinty_fn *get_queue_affinity,
+		bool fallback)
+{
+	const struct cpumask *mask;
+	unsigned int queue, cpu;
+
+	/*
+	 * fallback to default mapping if driver doesn't provide
+	 * get_queue_affinity callback
+	 */
+	if (!get_queue_affinity) {
+		fallback = true;
+		goto fallback;
+	}
+
+	for (queue = 0; queue < qmap->nr_queues; queue++) {
+		mask = get_queue_affinity(dev_data, dev_off, queue);
+		if (!mask)
+			goto fallback;
+
+		for_each_cpu(cpu, mask)
+			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+	}
+
+	return 0;
+
+fallback:
+	if (!fallback) {
+		WARN_ON_ONCE(qmap->nr_queues > 1);
+		blk_mq_clear_mq_map(qmap);
+		return 0;
+	}
+	return blk_mq_map_queues(qmap);
+}
+EXPORT_SYMBOL_GPL(blk_mq_dev_map_queues);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index fd2de2b422ed..b6090d691594 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -553,7 +553,12 @@ void blk_mq_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout);
 
+typedef const struct cpumask * (get_queue_affinty_fn)(void *dev_data,
+		int dev_off, int queue_idx);
 int blk_mq_map_queues(struct blk_mq_queue_map *qmap);
+int blk_mq_dev_map_queues(struct blk_mq_queue_map *qmap, void *dev_data,
+		int dev_off, get_queue_affinty_fn *get_queue_affinity,
+		bool fallback);
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
 
 void blk_mq_quiesce_queue_nowait(struct request_queue *q);
-- 
2.31.1

