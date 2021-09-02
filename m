Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B81C88C85
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 16:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF80561A6D
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 16:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346156AbhIBQZ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 12:25:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235934AbhIBQZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 12:25:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630599867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rYY4qCa8o5rvtklcU6k4vUi6GE1RBlBKBvGbmMAvFOs=;
        b=EwGH3xpVT6Wq8KKMxerQTCdKlt+NAJZ+CQ5DD2DcpG0YiLk/BddYtcBKPzkzf992EB95Hs
        C9yVKNOX6vn8YJLT/usqSOTV9+ydM8vClwe0NWBPvw8N513qMsfqO5LAXJrBqH2wgo11Ao
        WTqtsWtymtRMxs/Kk23Ob8SREZ8RSYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-awjXb0EUMtKwxRUQXvyZnQ-1; Thu, 02 Sep 2021 12:24:26 -0400
X-MC-Unique: awjXb0EUMtKwxRUQXvyZnQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F12506D582
        for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2021 16:24:25 +0000 (UTC)
Received: from emilne.bos.redhat.com (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C07916A8FF
        for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2021 16:24:25 +0000 (UTC)
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: sd: do not call device_add() on scsi_disk with uninitialized gendisk ->queue
Date:   Thu,  2 Sep 2021 12:24:25 -0400
Message-Id: <20210902162425.17208-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calling device_add() makes the scsi_disk visible in sysfs, the accessor
routines reference sdkp->disk->queue which was not yet set properly.
Fix this by initializing gendisk fields earlier in the function.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6d2d636..97ab18b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3428,6 +3428,13 @@ static int sd_probe(struct device *dev)
 		goto out_free_index;
 	}
 
+	gd->major = sd_major((index & 0xf0) >> 4);
+	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+
+	gd->fops = &sd_fops;
+	gd->private_data = &sdkp->driver;
+	gd->queue = sdp->request_queue;
+
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
@@ -3456,13 +3463,6 @@ static int sd_probe(struct device *dev)
 	get_device(dev);
 	dev_set_drvdata(dev, sdkp);
 
-	gd->major = sd_major((index & 0xf0) >> 4);
-	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-
-	gd->fops = &sd_fops;
-	gd->private_data = &sdkp->driver;
-	gd->queue = sdkp->device->request_queue;
-
 	/* defaults, until the device tells us otherwise */
 	sdp->sector_size = 512;
 	sdkp->capacity = 0;
-- 
2.1.0

