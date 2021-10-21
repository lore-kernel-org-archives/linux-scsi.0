Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5E4C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D553C610EA
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 15:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhJUPDF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 11:03:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231520AbhJUPDE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 11:03:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634828448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tz2xu4sWqcSOb/9a4Rz/JwgRFgv27Mh1vfD2WxARp6k=;
        b=IViuuYjydMLp8qLTLPI+/ww8S/0hs8SJZRPtO2+HOe8Q6C9btUny0A3WeHbbEd79sz8x7i
        dsnHYzYXa5p53TrgUKP1XW5a//5Ti+wT+iuZ4/yWG1oBo5+a8pJEBxHf+w+httJbjNDa65
        C/L2wyxafw6yO/jl2qXsxxGhJVttDww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-1yF5Y0nLPl2VIT-pgMgn7A-1; Thu, 21 Oct 2021 11:00:46 -0400
X-MC-Unique: 1yF5Y0nLPl2VIT-pgMgn7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F2111014BEB;
        Thu, 21 Oct 2021 15:00:38 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 086147DA13;
        Thu, 21 Oct 2021 15:00:36 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/3] scsi: make sure that request queue queiesce and unquiesce balanced
Date:   Thu, 21 Oct 2021 22:59:17 +0800
Message-Id: <20211021145918.2691762-3-ming.lei@redhat.com>
In-Reply-To: <20211021145918.2691762-1-ming.lei@redhat.com>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For fixing queue quiesce race between driver and block layer(elevator
switch, update nr_requests, ...), we need to support concurrent quiesce
and unquiesce, which requires the two call balanced.

It isn't easy to audit that in all scsi drivers, especially the two may
be called from different contexts, so do it in scsi core with one per-device
bit flag & global spinlock, basically zero cost since request queue quiesce
is seldom triggered.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue quiesce/unquiesce")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c    | 45 ++++++++++++++++++++++++++++++--------
 include/scsi/scsi_device.h |  1 +
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 51fcd46be265..414f4daf8005 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2638,6 +2638,40 @@ static int __scsi_internal_device_block_nowait(struct scsi_device *sdev)
 	return 0;
 }
 
+static DEFINE_SPINLOCK(sdev_queue_stop_lock);
+
+void scsi_start_queue(struct scsi_device *sdev)
+{
+	bool need_start;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
+	need_start = sdev->queue_stopped;
+	sdev->queue_stopped = 0;
+	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
+
+	if (need_start)
+		blk_mq_unquiesce_queue(sdev->request_queue);
+}
+
+static void scsi_stop_queue(struct scsi_device *sdev, bool nowait)
+{
+	bool need_stop;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
+	need_stop = !sdev->queue_stopped;
+	sdev->queue_stopped = 1;
+	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
+
+	if (need_stop) {
+		if (nowait)
+			blk_mq_quiesce_queue_nowait(sdev->request_queue);
+		else
+			blk_mq_quiesce_queue(sdev->request_queue);
+	}
+}
+
 /**
  * scsi_internal_device_block_nowait - try to transition to the SDEV_BLOCK state
  * @sdev: device to block
@@ -2662,7 +2696,7 @@ int scsi_internal_device_block_nowait(struct scsi_device *sdev)
 	 * request queue.
 	 */
 	if (!ret)
-		blk_mq_quiesce_queue_nowait(sdev->request_queue);
+		scsi_stop_queue(sdev, true);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
@@ -2689,19 +2723,12 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
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
index 430b73bd02ac..ac74beccffa2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -206,6 +206,7 @@ struct scsi_device {
 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
 					 * creation time */
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
+	unsigned queue_stopped:1;	/* request queue is quiesced */
 
 	bool offline_already;		/* Device offline message logged */
 
-- 
2.31.1

