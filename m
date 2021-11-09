Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4A1C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 07:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A620F61165
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 07:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243506AbhKIHPj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 02:15:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37126 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243501AbhKIHPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 02:15:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636441973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oc2lkjt1FcG05LBJpejYqoufbkOOAb4McRHTh5Lmbuc=;
        b=imvlG3OtHCnX54ThnBmzqlHIRoa5EcRChHdh6B2i8Tjie2KpiqIYcB6UnmAZruzJ55UNgI
        pUDh0pF2/4tPUbi0dAKSRozFSNVGP6THh7hLidFfAlobX50+J6ElVbcpWMVHoMqVXLCEwX
        lGXncOzbf+S5grta9uJIoO0m8aBXc1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-m467EQgLPga8FrxF9KRZdA-1; Tue, 09 Nov 2021 02:12:51 -0500
X-MC-Unique: m467EQgLPga8FrxF9KRZdA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8A3318125C5;
        Tue,  9 Nov 2021 07:12:50 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9992379449;
        Tue,  9 Nov 2021 07:12:42 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 3/4] scsi: make sure that request queue queiesce and unquiesce balanced
Date:   Tue,  9 Nov 2021 15:11:43 +0800
Message-Id: <20211109071144.181581-4-ming.lei@redhat.com>
In-Reply-To: <20211109071144.181581-1-ming.lei@redhat.com>
References: <20211109071144.181581-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 drivers/scsi/scsi_lib.c    | 37 ++++++++++++++++++++++++++++---------
 include/scsi/scsi_device.h |  1 +
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1cd3ef9056d5..9e3bf028f95a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2653,6 +2653,32 @@ static int __scsi_internal_device_block_nowait(struct scsi_device *sdev)
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
+	/*
+	 * The atomic variable of ->queue_stopped covers that
+	 * blk_mq_quiesce_queue* is balanced with blk_mq_unquiesce_queue.
+	 *
+	 * However, we still need to wait until quiesce is done
+	 * in case that queue has been stopped.
+	 */
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
@@ -2677,7 +2703,7 @@ int scsi_internal_device_block_nowait(struct scsi_device *sdev)
 	 * request queue.
 	 */
 	if (!ret)
-		blk_mq_quiesce_queue_nowait(sdev->request_queue);
+		scsi_stop_queue(sdev, true);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
@@ -2704,19 +2730,12 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
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

