Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EDFC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbiAVLMM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:12:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234203AbiAVLMM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:12:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FPH7dGVIFzXjTeIzBsKDE0c39uig7yHFFZMv14xZNew=;
        b=ZB7DeHvjW+B4GCzDDYruNdnibnabBSBVNdr1KthWwiVchqlLohbgC7lC4A8dy3KqbxLn3V
        I6FwJNodTP6H3/T/33S32ybgxdWcT26yRHXC/eRI7Z1ilfxFfxU0Gm49XpI8lscJww/AHr
        ODwU3pZ4PJmEc/8nEwIxxQ8eKb1q29M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-5UCEbBjDNkKDyihBe5yZDw-1; Sat, 22 Jan 2022 06:12:07 -0500
X-MC-Unique: 5UCEbBjDNkKDyihBe5yZDw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A88F72F47;
        Sat, 22 Jan 2022 11:12:06 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56A1B7B9D3;
        Sat, 22 Jan 2022 11:12:01 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 05/13] block: only account passthrough IO from userspace
Date:   Sat, 22 Jan 2022 19:10:46 +0800
Message-Id: <20220122111054.1126146-6-ming.lei@redhat.com>
In-Reply-To: <20220122111054.1126146-1-ming.lei@redhat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Passthrough request from userspace has one active block_device/disk
associated, so they can be accounted via rq->q->disk. For other
passthrough request, there may not be disk/block_device for the queue,
since either the queue has not a disk or the disk may be deleted
already.

Add flag of BLK_MQ_REQ_USER_IO for only accounting passthrough request
from userspace.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c            | 13 ++++++++++++-
 drivers/nvme/host/ioctl.c |  2 +-
 drivers/scsi/scsi_ioctl.c |  3 ++-
 include/linux/blk-mq.h    |  2 ++
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a6d4780580fc..0d25cc5778c9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -336,6 +336,17 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 }
 EXPORT_SYMBOL(blk_rq_init);
 
+static inline bool blk_mq_io_may_account(struct blk_mq_alloc_data *data)
+{
+	if (!blk_op_is_passthrough(data->cmd_flags))
+		return true;
+
+	if (data->flags & BLK_MQ_REQ_USER_IO)
+		return true;
+
+	return false;
+}
+
 static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 		struct blk_mq_tags *tags, unsigned int tag, u64 alloc_time_ns)
 {
@@ -351,7 +362,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 
 	if (data->flags & BLK_MQ_REQ_PM)
 		data->rq_flags |= RQF_PM;
-	if (blk_queue_io_stat(q))
+	if (blk_queue_io_stat(q) && blk_mq_io_may_account(data))
 		data->rq_flags |= RQF_IO_STAT;
 	rq->rq_flags = data->rq_flags;
 
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 22314962842d..f94afc38a6e3 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -66,7 +66,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	void *meta = NULL;
 	int ret;
 
-	req = nvme_alloc_request(q, cmd, 0);
+	req = nvme_alloc_request(q, cmd, BLK_MQ_REQ_USER_IO);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index e13fd380deb6..b262fe06dacc 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -440,7 +440,8 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 
 	ret = -ENOMEM;
 	rq = scsi_alloc_request(sdev->request_queue, writing ?
-			     REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
+			     REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+			     BLK_MQ_REQ_USER_IO);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	req = scsi_req(rq);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d319ffa59354..d2ad2ed11723 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -709,6 +709,8 @@ enum {
 	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
 	/* set RQF_PM */
 	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 2),
+	/* user IO request */
+	BLK_MQ_REQ_USER_IO	= (__force blk_mq_req_flags_t)(1 << 3),
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
-- 
2.31.1

