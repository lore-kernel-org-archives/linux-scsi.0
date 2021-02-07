Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865E1C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 09:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A11864E43
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 09:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBGJY4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 04:24:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25101 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229793AbhBGJYo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 04:24:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612689797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vYtWTnAXgtFS9ppvSzY14Z8fWYhtiqYqAeHMrlM/v8A=;
        b=HC08yQXW1G0Kk+HeVDO6WwZlRpedKD2+/05VGWbu0xb0997qWNwPM4HM4StZf8nN2h5CnE
        rZVGJMrv0AAPnuPRM/yCBpKBnK/FWRW9i/kNwJNAN3H3ejCQXCaqdKeRQ1v+BAXGbMGS01
        k5y5fSg8inx9N+YXrN8sm74oqVX1UsM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-ynmM4MOJMG-ep7gMi6xxtg-1; Sun, 07 Feb 2021 04:23:13 -0500
X-MC-Unique: ynmM4MOJMG-ep7gMi6xxtg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CEDE801962;
        Sun,  7 Feb 2021 09:23:12 +0000 (UTC)
Received: from localhost (ovpn-13-9.pek2.redhat.com [10.72.13.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2A6F10016FF;
        Sun,  7 Feb 2021 09:23:01 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V8 12/13] scsi: make sure sdev->queue_depth is <= max(shost->can_queue, 1024)
Date:   Sun,  7 Feb 2021 17:20:28 +0800
Message-Id: <20210207092029.1558550-13-ming.lei@redhat.com>
In-Reply-To: <20210207092029.1558550-1-ming.lei@redhat.com>
References: <20210207092029.1558550-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
2.29.2

