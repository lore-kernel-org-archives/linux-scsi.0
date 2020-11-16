Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60102C55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99FB22370
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PaAlmlN1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgKPJJB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 04:09:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728531AbgKPJJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 04:09:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605517739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NBlcwixDeij9jtY3WYF417Hx5FZ2dhJB1nxSwj3Zydc=;
        b=PaAlmlN1I0aeVQXEwmVvcN3HKRfzmhnqw+zqTJD8GJcp1GjiTWXYmqUhWWcUAV7kUCgH+t
        7zZSdK8zzNMfo7f7j5vDZT+dr/OgU6j0J5YTaXlvevsLlZIq+mvidy7FEffiUbbdqyHXKz
        FjtDXM3daYyHhgIjn+FEPX2Sn2QEWgs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-AIx48d-bO_C0i8O_Z6xzrQ-1; Mon, 16 Nov 2020 04:08:56 -0500
X-MC-Unique: AIx48d-bO_C0i8O_Z6xzrQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45A2510B9CA1;
        Mon, 16 Nov 2020 09:08:55 +0000 (UTC)
Received: from localhost (ovpn-13-166.pek2.redhat.com [10.72.13.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA720171F4;
        Mon, 16 Nov 2020 09:08:51 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
Subject: [PATCH V4 11/12] scsi: make sure sdev->queue_depth is <= max(shost->can_queue, 1024)
Date:   Mon, 16 Nov 2020 17:07:36 +0800
Message-Id: <20201116090737.50989-12-ming.lei@redhat.com>
In-Reply-To: <20201116090737.50989-1-ming.lei@redhat.com>
References: <20201116090737.50989-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Limit scsi device's queue depth is less than max(host->can_queue, 1024)
in scsi_change_queue_depth(), and 1024 is big enough for saturating
current fast SCSI LUN(SSD, or raid volume on multiple SSDs).

We need this patch for replacing sdev->device_busy with sbitmap which
has to be pre-allocated with reasonable max depth.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 24619c3bebd5..a28d48c850cf 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -214,6 +214,15 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 	scsi_io_completion(cmd, good_bytes);
 }
 
+
+/*
+ * 1024 is big enough for saturating the fast scsi LUN now
+ */
+static int scsi_device_max_queue_depth(struct scsi_device *sdev)
+{
+	return max_t(int, sdev->host->can_queue, 1024);
+}
+
 /**
  * scsi_change_queue_depth - change a device's queue depth
  * @sdev: SCSI Device in question
@@ -223,6 +232,8 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
  */
 int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
 {
+	depth = min_t(int, depth, scsi_device_max_queue_depth(sdev));
+
 	if (depth > 0) {
 		sdev->queue_depth = depth;
 		wmb();
-- 
2.25.4

