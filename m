Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B5FC4321E
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Dec 2022 13:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiLDN6z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Dec 2022 08:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiLDN6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Dec 2022 08:58:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4495612768
        for <linux-scsi@vger.kernel.org>; Sun,  4 Dec 2022 05:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670162280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DMJcglLInLrmIi7yKNd9FNZ4Aoj1MSVrKvA6pl0gT7k=;
        b=UKZ9bokeQq0i/79py/r7bB02Mq00gYLba17GiW/OUzVlCKEPdg4C86nSSZzRh4N5vo3Fsr
        z+jf0kyT5Jpk4N2XfXSA4C7lNhB/+ulCH4yUNTTWyuWIuIACVSXgF17olVPWgEETTZoK0I
        /5oZRFefWBBDaEcGKv83+3b8bvsfTFg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-Lmb-v_1yNWi69-UY7YOC3A-1; Sun, 04 Dec 2022 08:57:58 -0500
X-MC-Unique: Lmb-v_1yNWi69-UY7YOC3A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B93129AB3E1
        for <linux-scsi@vger.kernel.org>; Sun,  4 Dec 2022 13:57:58 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-192-22.brq.redhat.com [10.40.192.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BC10492B08
        for <linux-scsi@vger.kernel.org>; Sun,  4 Dec 2022 13:57:57 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
Date:   Sun,  4 Dec 2022 14:57:57 +0100
Message-Id: <20221204135757.11595-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set the state to deleted in sd_shutdown so that the attached LLD
doesn't get new I/O (can happen when in kexec for example) later after
LLD's shutdown function has been called.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/sd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 47dafe6b8a66..52e9d67917ec 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3676,10 +3676,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
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
 
@@ -3692,6 +3695,10 @@ static void sd_shutdown(struct device *dev)
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
2.38.1

