Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1259C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 03:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99415610E7
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 03:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhKCDrB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 23:47:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhKCDrB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 23:47:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635911065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7LHoignc8TJYM7NTUVCMDJ7Ni6Hm7VZpBUyllkhydfo=;
        b=VBMr8AIogYll2cY5c0JBPqqeCUPd0fv+UDkBGPGfQn6Gw8QW7K+L5muLz7Q0qpjYKyDG64
        3HbSQQcc49zHZ5HBQ27iZ4pWj2cExznA+IovFd7TMiihengcVVUPaOxTc5d0yaHaEdFPpX
        Oj2fTPLmrVvS9Rqe3IBrUVoR4RVGebc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-0ulroueFO9WMJQriVZsbOw-1; Tue, 02 Nov 2021 23:44:22 -0400
X-MC-Unique: 0ulroueFO9WMJQriVZsbOw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E174D1006AA2;
        Wed,  3 Nov 2021 03:44:20 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 555E91017E37;
        Wed,  3 Nov 2021 03:44:12 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/4] scsi: make sure that request queue queiesce and unquiesce balanced
Date:   Wed,  3 Nov 2021 11:43:04 +0800
Message-Id: <20211103034305.3691555-4-ming.lei@redhat.com>
In-Reply-To: <20211103034305.3691555-1-ming.lei@redhat.com>
References: <20211103034305.3691555-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For fixing queue quiesce race between driver and block layer(elevator
switch, update nr_requests, ...), we need to support concurrent quiesce
and unquiesce, which requires the two call balanced.

It isn't easy to audit that in all scsi drivers, especially the two may
be called from different contexts, so do it in scsi core with one
per-device atomic variable to balance quiesce and unquiesce.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue quiesce/unquiesce")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c    | 30 +++++++++++++++++++++---------
 include/scsi/scsi_device.h |  1 +
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1cd3ef9056d5..e8925a35cb3a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2653,6 +2653,25 @@ static int __scsi_internal_device_block_nowait(struct scsi_device *sdev)
 	return 0;
 }
 
+void scsi_start_queue(struct scsi_device *sdev)
+{
+	if (cmpxchg(&sdev->queue_stopped, 1, 0))
+		blk_mq_unquiesce_queue(sdev->request_queue);
+}
+
+static void scsi_stop_queue(struct scsi_device *sdev, bool nowait)
+{
+	if (!cmpxchg(&sdev->queue_stopped, 0, 1)) {
+		if (nowait)
+			blk_mq_quiesce_queue_nowait(sdev->request_queue);
+		else
+			blk_mq_quiesce_queue(sdev->request_queue);
+	} else {
+		if (!nowait)
+			blk_mq_wait_quiesce_done(sdev->request_queue);
+	}
+}
+
 /**
  * scsi_internal_device_block_nowait - try to transition to the SDEV_BLOCK state
  * @sdev: device to block
@@ -2677,7 +2696,7 @@ int scsi_internal_device_block_nowait(struct scsi_device *sdev)
 	 * request queue.
 	 */
 	if (!ret)
-		blk_mq_quiesce_queue_nowait(sdev->request_queue);
+		scsi_stop_queue(sdev, true);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
@@ -2704,19 +2723,12 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 	mutex_lock(&sdev->state_mutex);
 	err = __scsi_internal_device_block_nowait(sdev);
 	if (err == 0)
-		blk_mq_quiesce_queue(sdev->request_queue);
+		scsi_stop_queue(sdev, false);
 	mutex_unlock(&sdev->state_mutex);
 
 	return err;
 }
 
-void scsi_start_queue(struct scsi_device *sdev)
-{
-	struct request_queue *q = sdev->request_queue;
-
-	blk_mq_unquiesce_queue(q);
-}
-
 /**
  * scsi_internal_device_unblock_nowait - resume a device after a block request
  * @sdev:	device to resume
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 430b73bd02ac..d1c6fc83b1e3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -207,6 +207,7 @@ struct scsi_device {
 					 * creation time */
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
 
+	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
-- 
2.31.1

