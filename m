Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31B8C07E9C
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98C85613C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 08:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhGIIOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 04:14:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231414AbhGIIOD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 04:14:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625818280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vk9L1G0njXZFju3Oa4mrApnhj5rcqMsMKonFv8gUeQA=;
        b=a3ArBK4bvx9bnNTEB7zmp97c75+UNzZQ/zTnZJnr/M4sU+Trnhcu4/GzHBWlNw0pyi0dP1
        6XCXkQZszmH4vJDyjMgcoR/PnGjEYBarV8mbuj+9Sg/tdFBTL9XCF0/xMthAHJo6RLdkPg
        uKfnaWAHj+YZ71yQBw9AURNM1uNpyR0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-aA_Q4guMN7ur9y0N5-yJzg-1; Fri, 09 Jul 2021 04:11:16 -0400
X-MC-Unique: aA_Q4guMN7ur9y0N5-yJzg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B34D81084F40;
        Fri,  9 Jul 2021 08:11:14 +0000 (UTC)
Received: from localhost (ovpn-13-13.pek2.redhat.com [10.72.13.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CE625D6D3;
        Fri,  9 Jul 2021 08:11:09 +0000 (UTC)
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
Subject: [PATCH V3 06/10] virito: add APIs for retrieving vq affinity
Date:   Fri,  9 Jul 2021 16:10:01 +0800
Message-Id: <20210709081005.421340-7-ming.lei@redhat.com>
In-Reply-To: <20210709081005.421340-1-ming.lei@redhat.com>
References: <20210709081005.421340-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

virtio-blk/virtio-scsi needs this API for retrieving vq's affinity.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/virtio/virtio.c | 10 ++++++++++
 include/linux/virtio.h  |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 4b15c00c0a0a..ab593a8350d4 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -448,6 +448,16 @@ int virtio_device_restore(struct virtio_device *dev)
 EXPORT_SYMBOL_GPL(virtio_device_restore);
 #endif
 
+const struct cpumask *virtio_get_vq_affinity(struct virtio_device *dev,
+		int index)
+{
+	if (!dev->config->get_vq_affinity)
+		return NULL;
+
+	return dev->config->get_vq_affinity(dev, index);
+}
+EXPORT_SYMBOL_GPL(virtio_get_vq_affinity);
+
 static int virtio_init(void)
 {
 	if (bus_register(&virtio_bus) != 0)
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index b1894e0323fa..99fbba9981cc 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -139,6 +139,8 @@ int virtio_device_restore(struct virtio_device *dev);
 #endif
 
 size_t virtio_max_dma_size(struct virtio_device *vdev);
+const struct cpumask *virtio_get_vq_affinity(struct virtio_device *dev,
+		int index);
 
 #define virtio_device_for_each_vq(vdev, vq) \
 	list_for_each_entry(vq, &vdev->vqs, list)
-- 
2.31.1

