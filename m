Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B94BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 07:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24D1E61165
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 07:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243544AbhKIHPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 02:15:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243506AbhKIHPa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 02:15:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636441964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4e1SOw0qm99517HgL8VV+WSt1ycW8ms5ogP7+32Qx68=;
        b=Wv/cmbRzJ1m2pzLFN/MPauLgn3TNAnPelMAU5XgLU8SAGjbFvCMX5IMixWvGzRJpNou5M8
        lGAa5F/gAaK36Poo0R9UHU5lrMsrVn3LOihSaGUj/MRaTfGIVA1V0l0Y2+fMlIoZjZuJRx
        ip3mKd+1bBHAdVXjqRjKKLQyV/pk99Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-SOzd6mSbNKqCLmwp5H7ivA-1; Tue, 09 Nov 2021 02:12:41 -0500
X-MC-Unique: SOzd6mSbNKqCLmwp5H7ivA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01D438799E0;
        Tue,  9 Nov 2021 07:12:40 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE24819C59;
        Tue,  9 Nov 2021 07:12:24 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 2/4] scsi: avoid to quiesce sdev->request_queue two times
Date:   Tue,  9 Nov 2021 15:11:42 +0800
Message-Id: <20211109071144.181581-3-ming.lei@redhat.com>
In-Reply-To: <20211109071144.181581-1-ming.lei@redhat.com>
References: <20211109071144.181581-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For fixing queue quiesce race between driver and block layer(elevator
switch, update nr_requests, ...), we need to support concurrent quiesce
and unquiesce, which requires the two to be balanced.

blk_mq_quiesce_queue() calls blk_mq_quiesce_queue_nowait() for updating
quiesce depth and marking the flag, then scsi_internal_device_block() calls
blk_mq_quiesce_queue_nowait() two times actually.

Fix the double quiesce and keep quiesce and unquiesce balanced.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue quiesce/unquiesce")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9c2b99e12ce3..1cd3ef9056d5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2645,6 +2645,14 @@ scsi_target_resume(struct scsi_target *starget)
 }
 EXPORT_SYMBOL(scsi_target_resume);
 
+static int __scsi_internal_device_block_nowait(struct scsi_device *sdev)
+{
+	if (scsi_device_set_state(sdev, SDEV_BLOCK))
+		return scsi_device_set_state(sdev, SDEV_CREATED_BLOCK);
+
+	return 0;
+}
+
 /**
  * scsi_internal_device_block_nowait - try to transition to the SDEV_BLOCK state
  * @sdev: device to block
@@ -2661,24 +2669,16 @@ EXPORT_SYMBOL(scsi_target_resume);
  */
 int scsi_internal_device_block_nowait(struct scsi_device *sdev)
 {
-	struct request_queue *q = sdev->request_queue;
-	int err = 0;
-
-	err = scsi_device_set_state(sdev, SDEV_BLOCK);
-	if (err) {
-		err = scsi_device_set_state(sdev, SDEV_CREATED_BLOCK);
-
-		if (err)
-			return err;
-	}
+	int ret = __scsi_internal_device_block_nowait(sdev);
 
 	/*
 	 * The device has transitioned to SDEV_BLOCK.  Stop the
 	 * block layer from calling the midlayer with this device's
 	 * request queue.
 	 */
-	blk_mq_quiesce_queue_nowait(q);
-	return 0;
+	if (!ret)
+		blk_mq_quiesce_queue_nowait(sdev->request_queue);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
 
@@ -2699,13 +2699,12 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
  */
 static int scsi_internal_device_block(struct scsi_device *sdev)
 {
-	struct request_queue *q = sdev->request_queue;
 	int err;
 
 	mutex_lock(&sdev->state_mutex);
-	err = scsi_internal_device_block_nowait(sdev);
+	err = __scsi_internal_device_block_nowait(sdev);
 	if (err == 0)
-		blk_mq_quiesce_queue(q);
+		blk_mq_quiesce_queue(sdev->request_queue);
 	mutex_unlock(&sdev->state_mutex);
 
 	return err;
-- 
2.31.1

