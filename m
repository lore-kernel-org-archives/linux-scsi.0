Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30ADEC761A6
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Mar 2023 16:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjC3Qve (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Mar 2023 12:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbjC3QvM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2023 12:51:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBA7E1B7
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 09:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680194985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tWLfr6zOSYpW2Ndy7nOzOanTYNyfYEXJcweDob4VB9c=;
        b=XU8PBDAS2uP6KUrinGwEmTUPqx+GzFeo430xWtHr1WCZRsLstfPrR7EXg9OlXHNhakSIeF
        a+tQohtf5JER3dgd9tMTSlEfcE2UTKMyGLoXqvzkFOaQ5U/iiGpF/ElHm+ZD1g6K4mBPbM
        eTtN586DayQox0cWvPitovxSruaNxpI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-nmttRDtoObG4Y7BCsTcSEA-1; Thu, 30 Mar 2023 12:49:44 -0400
X-MC-Unique: nmttRDtoObG4Y7BCsTcSEA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28A9D88B781
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 16:49:44 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.224.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C39DD2027041
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 16:49:43 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
Date:   Thu, 30 Mar 2023 18:49:43 +0200
Message-Id: <20230330164943.11607-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

