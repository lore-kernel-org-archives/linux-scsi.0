Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970CFC76196
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 18:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjDCSkO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Apr 2023 14:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjDCSkM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2023 14:40:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E2A114
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2023 11:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680547155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tWLfr6zOSYpW2Ndy7nOzOanTYNyfYEXJcweDob4VB9c=;
        b=Fz83qf+0iNpJV3yS2xeRbjs4OAV+MPg7CKkS9ftlCd0YtwyXZeujqvwJfS+wP7Kq5bH71O
        ES91Wu7I9HAA9sez2U9pLH/JWjaOywcLinQp7OJs0QI2wgA5+z5nNZFWNATQimmQ2+aHmB
        Fh8Oa1a4ptGeHnU6FTrylWFwya99FGg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-ks-bPV16M6iLKx5afLo4Qg-1; Mon, 03 Apr 2023 14:39:12 -0400
X-MC-Unique: ks-bPV16M6iLKx5afLo4Qg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D23A129ABA1E;
        Mon,  3 Apr 2023 18:39:11 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.224.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 200F0140EBF4;
        Mon,  3 Apr 2023 18:39:11 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, ranjan.kumar@broadcom.com,
        sathya.prakash@broadcom.com
Subject: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
Date:   Mon,  3 Apr 2023 20:39:10 +0200
Message-Id: <20230403183910.5485-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set the state to deleted in sd_shutdown so that the attached LLD
doesn't receive new I/O (can happen when in kexec) later after
LLD's shutdown function has been called.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/sd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4f28dd617eca..8095f0302e66 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3694,10 +3694,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 static void sd_shutdown(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_device *sdp;
 
 	if (!sdkp)
 		return;         /* this can happen */
 
+	sdp = sdkp->device;
+
 	if (pm_runtime_suspended(dev))
 		return;
 
@@ -3710,6 +3713,10 @@ static void sd_shutdown(struct device *dev)
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
+
+	mutex_lock(&sdp->state_mutex);
+	scsi_device_set_state(sdp, SDEV_DEL);
+	mutex_unlock(&sdp->state_mutex);
 }
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
-- 
2.39.2

