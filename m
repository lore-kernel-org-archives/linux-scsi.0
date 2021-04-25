Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD41C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 08:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B8D1613B4
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 08:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhDYI7U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 04:59:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229694AbhDYI7U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Apr 2021 04:59:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619341120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9XMNgph7pfp6Sn4gR+e9FqJfKyDwk7Q14I9+0tXapEU=;
        b=U0lDTA+qNk2qiMOm4qSxTspbarjz5I93bqeqk62EqBar2BEzEy6XtQNrLKAi96VHoJ2D3h
        wo1DcPu6fO3mXVr2Z0FmQXe7Xz/DVCHZMk1W6Zw+SfxFos1BS5GOUU1dHj0WuYfTzWs4TU
        eEDdpzmXvXfQK2M0dg6PpE2wQEpeT3s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-s3okdzmXPgazHHveUS35cw-1; Sun, 25 Apr 2021 04:58:36 -0400
X-MC-Unique: s3okdzmXPgazHHveUS35cw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38F581898296;
        Sun, 25 Apr 2021 08:58:35 +0000 (UTC)
Received: from localhost (ovpn-13-143.pek2.redhat.com [10.72.13.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B812177CE;
        Sun, 25 Apr 2021 08:58:31 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 6/8] block: drivers: complete request locally from blk_mq_tagset_busy_iter
Date:   Sun, 25 Apr 2021 16:57:51 +0800
Message-Id: <20210425085753.2617424-7-ming.lei@redhat.com>
In-Reply-To: <20210425085753.2617424-1-ming.lei@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It can be a bit hard for driver to avoid request UAF between normal
completion and completion via blk_mq_tagset_busy_iter() if async
completion is done in blk_mq_tagset_busy_iter(). Cause request->tag
is only freed after .mq_ops->complete() is called, and rquest->tag
may still be valid after blk_mq_complete_request() is returned from
normal completion path, so this request is still visible in
blk_mq_tagset_busy_iter().

This patch itself can't avoid such request UAF completely. We will
grab a request reference in next patch when walking request via
blk_mq_tagset_busy_iter() for fixing such race, that is why we have
to convert to blk_mq_complete_request_locally() first.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 2 +-
 drivers/block/nbd.c               | 2 +-
 drivers/nvme/host/core.c          | 2 +-
 drivers/scsi/scsi_lib.c           | 6 +++++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 3be0dbc674bd..05f5e36ee608 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3748,7 +3748,7 @@ static bool mtip_no_dev_cleanup(struct request *rq, void *data, bool reserv)
 	struct mtip_cmd *cmd = blk_mq_rq_to_pdu(rq);
 
 	cmd->status = BLK_STS_IOERR;
-	blk_mq_complete_request(rq);
+	blk_mq_complete_request_locally(rq);
 	return true;
 }
 
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4ff71b579cfc..3dcf3288efa8 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -809,7 +809,7 @@ static bool nbd_clear_req(struct request *req, void *data, bool reserved)
 	cmd->status = BLK_STS_IOERR;
 	mutex_unlock(&cmd->lock);
 
-	blk_mq_complete_request(req);
+	blk_mq_complete_request_locally(req);
 	return true;
 }
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0896e21642be..a605954477da 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -381,7 +381,7 @@ bool nvme_cancel_request(struct request *req, void *data, bool reserved)
 
 	nvme_req(req)->status = NVME_SC_HOST_ABORTED_CMD;
 	nvme_req(req)->flags |= NVME_REQ_CANCELLED;
-	blk_mq_complete_request(req);
+	blk_mq_complete_request_locally(req);
 	return true;
 }
 EXPORT_SYMBOL_GPL(nvme_cancel_request);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c289991ffaed..7cbaee282b6d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1568,7 +1568,11 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
 	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
 		return;
 	trace_scsi_dispatch_cmd_done(cmd);
-	blk_mq_complete_request(cmd->request);
+
+	if (unlikely(host_byte(cmd->result) != DID_OK))
+		blk_mq_complete_request_locally(cmd->request);
+	else
+		blk_mq_complete_request(cmd->request);
 }
 
 static void scsi_mq_put_budget(struct request_queue *q)
-- 
2.29.2

