Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CA0C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 00:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319502250F
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 00:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730290AbhARAwn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Jan 2021 19:52:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730198AbhARAwL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Jan 2021 19:52:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610931044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lPxOXpRZEK8+IoExIpG2BMHmyj4cl+h7wOpVuwGrBn8=;
        b=VScn8PCQRQIxh7vHQF4RoPRDka4AOeSDG2zSHPSy4hzvsescOeKO0BOojStxDQCTJglcR7
        elcdY5CREvU2cVbrPGVNI6/+glMi5RZCWESRCJ+LOlqpHtBpM03BUSIUJ5GAQNta94V4gp
        6CSjAlnBinmywnQ37YmKJC07r5k5Gyw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-3MLxtRWzPGSKtHIXp-e0JQ-1; Sun, 17 Jan 2021 19:50:42 -0500
X-MC-Unique: 3MLxtRWzPGSKtHIXp-e0JQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B61D2800D55;
        Mon, 18 Jan 2021 00:50:40 +0000 (UTC)
Received: from localhost (ovpn-12-73.pek2.redhat.com [10.72.12.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D7C15D9CC;
        Mon, 18 Jan 2021 00:50:36 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V6 12/13] scsi: make sure sdev->queue_depth is <= max(shost->can_queue, 1024)
Date:   Mon, 18 Jan 2021 08:49:20 +0800
Message-Id: <20210118004921.202545-13-ming.lei@redhat.com>
In-Reply-To: <20210118004921.202545-1-ming.lei@redhat.com>
References: <20210118004921.202545-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
2.28.0

