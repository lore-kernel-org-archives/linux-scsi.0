Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FEAC6369E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 09:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 769E6221FE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Nov 2020 09:54:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="br9jmL6t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgKSJyW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 04:54:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726545AbgKSJyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Nov 2020 04:54:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605779660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=97cazTe/1uWPNREL6u+67P3TVuCfyIX/i/NVHrpGqhI=;
        b=br9jmL6tnyYMP1mTOMoCN98v0Y6icXE7Ik+RAv+8Gezb1Butx9WAYyn/2jHF3UwUYnL5GR
        o+e4SjqH6TVjlqkTcqPsAFENDvWQsAo0hHjVJO1zl8LKoIg/ezOjcTc13TCQ2rd8In2KYX
        w7YcDaIJYd02Y9WFl1iOCevbXjoYuEs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-ZmJUBlS-OvaeujhfEJrX1w-1; Thu, 19 Nov 2020 04:54:16 -0500
X-MC-Unique: ZmJUBlS-OvaeujhfEJrX1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 163AD1005D5A;
        Thu, 19 Nov 2020 09:54:15 +0000 (UTC)
Received: from T590 (ovpn-13-167.pek2.redhat.com [10.72.13.167])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA41B19C47;
        Thu, 19 Nov 2020 09:54:07 +0000 (UTC)
Date:   Thu, 19 Nov 2020 17:54:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V5 12/13] scsi: make sure sdev->queue_depth is <=
 max(shost->can_queue, 1024)
Message-ID: <20201119095403.GD279559@T590>
References: <20201119094705.280390-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119094705.280390-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From 967683585dedee8ce7a2a1f2cef25c3c99427e03 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 7 May 2020 17:37:25 +0800
Subject: [PATCH V5 12/13] scsi: make sure sdev->queue_depth is <=
 max(shost->can_queue, 1024)

Limit scsi device's queue depth is less than max(host->can_queue, 1024)
in scsi_change_queue_depth(), and 1024 is big enough for saturating
current fast SCSI LUN(SSD, or raid volume on multiple SSDs). Also
single hw queue depth is usually enough for saturating single LUN
because per-core performance is often considered in storage design.

We need this patch for replacing sdev->device_busy with sbitmap which
has to be pre-allocated with reasonable max depth.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

