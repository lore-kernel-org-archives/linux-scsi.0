Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97147C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 725432077D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RPpe2T/p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgGUKxf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 06:53:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58686 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729207AbgGUKxe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 06:53:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595328813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mU9LuvbxIIqQES8VkndiAmGnMN0LZw77R+JT+vMfjKM=;
        b=RPpe2T/pkgdhmritA4f1a/I1OW9Ye6X1ygMWLUCvvFsXu8lqXkuUNvPx9WYxsuMDJ/RUH2
        hfqdry5zXrE1PXaM7HIkkjxwg4bXmqnYov/AkiE/N/5fmaV1a8BdLXTBDp9NOvo1clzOrv
        NU98InWy5vxuU2gPCFp2JMoSsaF5t+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-TU50TFU3PYG9zwlYETAStw-1; Tue, 21 Jul 2020 06:53:29 -0400
X-MC-Unique: TU50TFU3PYG9zwlYETAStw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 693008014D7;
        Tue, 21 Jul 2020 10:53:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87CB47621A;
        Tue, 21 Jul 2020 10:53:09 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-block@vger.kernel.org (open list:BLOCK LAYER),
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org (open list:NVM EXPRESS DRIVER),
        linux-scsi@vger.kernel.org (open list:SCSI CDROM DRIVER),
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        linux-mmc@vger.kernel.org (open list:SONY MEMORYSTICK SUBSYSTEM),
        Christoph Hellwig <hch@lst.de>,
        Satya Tangirala <satyat@google.com>,
        nbd@other.debian.org (open list:NETWORK BLOCK DEVICE (NBD)),
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        virtualization@lists.linux-foundation.org (open list:VIRTIO CORE AND
        NET DRIVERS), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 01/10] block: introduce blk_is_valid_logical_block_size
Date:   Tue, 21 Jul 2020 13:52:30 +0300
Message-Id: <20200721105239.8270-2-mlevitsk@redhat.com>
In-Reply-To: <20200721105239.8270-1-mlevitsk@redhat.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kernel block layer has never supported logical block
sizes less that SECTOR_SIZE nor larger that PAGE_SIZE.

Some drivers have runtime configurable block size,
so it makes sense to have common helper for that.

Signed-off-by: Maxim Levitsky  <mlevitsk@redhat.com>
---
 block/blk-settings.c   | 18 ++++++++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9a2c23cd97007..3c4ef0d00c2bc 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -311,6 +311,21 @@ void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
 }
 EXPORT_SYMBOL(blk_queue_max_segment_size);
 
+
+/**
+ * blk_check_logical_block_size - check if logical block size is supported
+ * by the kernel
+ * @size:  the logical block size, in bytes
+ *
+ * Description:
+ *   This function checks if the block layers supports given block size
+ **/
+bool blk_is_valid_logical_block_size(unsigned int size)
+{
+	return size >= SECTOR_SIZE && size <= PAGE_SIZE && !is_power_of_2(size);
+}
+EXPORT_SYMBOL(blk_is_valid_logical_block_size);
+
 /**
  * blk_queue_logical_block_size - set logical block size for the queue
  * @q:  the request queue for the device
@@ -323,6 +338,8 @@ EXPORT_SYMBOL(blk_queue_max_segment_size);
  **/
 void blk_queue_logical_block_size(struct request_queue *q, unsigned int size)
 {
+	WARN_ON(!blk_is_valid_logical_block_size(size));
+
 	q->limits.logical_block_size = size;
 
 	if (q->limits.physical_block_size < size)
@@ -330,6 +347,7 @@ void blk_queue_logical_block_size(struct request_queue *q, unsigned int size)
 
 	if (q->limits.io_min < q->limits.physical_block_size)
 		q->limits.io_min = q->limits.physical_block_size;
+
 }
 EXPORT_SYMBOL(blk_queue_logical_block_size);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 57241417ff2f8..2ed3151397e41 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1099,6 +1099,7 @@ extern void blk_queue_max_write_same_sectors(struct request_queue *q,
 		unsigned int max_write_same_sectors);
 extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
 		unsigned int max_write_same_sectors);
+extern bool blk_is_valid_logical_block_size(unsigned int size);
 extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_zone_append_sectors(struct request_queue *q,
 		unsigned int max_zone_append_sectors);
-- 
2.26.2

