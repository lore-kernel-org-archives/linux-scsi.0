Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D2EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A90CE617E5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349661AbhI3MqX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 08:46:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348891AbhI3MqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 08:46:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633005879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YwEArWBcIjvEs0gywbtF/H8ad3ezfvjoSEdYUaPyebw=;
        b=cjziEX1XTqPdA3q+VKRXvRdbP1VwaXK6OlyHpVHNRO9UlK2gQCBsFvT4mkSgFCXBI/ykme
        B2Q4d1c/VkbIlev6BMjEjLIPSxagIEoYQOdp0s2665zxhoqvl8n2XfEWGBk66A5lXxfucm
        IvNIJ2omF+1lm33RL06pNh487EJ9b0I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-8fkfvg-qPaiqemzV_9lrhg-1; Thu, 30 Sep 2021 08:44:38 -0400
X-MC-Unique: 8fkfvg-qPaiqemzV_9lrhg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D5D61006AB2;
        Thu, 30 Sep 2021 12:44:37 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D072B5D9CA;
        Thu, 30 Sep 2021 12:44:19 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH V3] scsi: core: put LLD module refcnt after SCSI device is released
Date:   Thu, 30 Sep 2021 20:44:15 +0800
Message-Id: <20210930124415.1160754-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI host release is triggered when SCSI device is freed, and we have to
make sure that LLD module won't be unloaded before SCSI host instance is
released because shost->hostt is required in host release handler.

So make sure to put LLD module refcnt after SCSI device is released.

Fix one kernel panic of 'BUG: unable to handle page fault for address'
reported by Changhui and Yi.

Reported-by: Changhui Zhong <czhong@redhat.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi.c        |  4 +++-
 drivers/scsi/scsi_sysfs.c  | 12 ++++++++++++
 include/scsi/scsi_device.h |  1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b241f9e3885c..291ecc33b1fe 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -553,8 +553,10 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	module_put(sdev->host->hostt->module);
+	struct module *mod = sdev->host->hostt->module;
+
 	put_device(&sdev->sdev_gendev);
+	module_put(mod);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 86793259e541..9ada26814011 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -449,9 +449,16 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	unsigned long flags;
+	struct module *mod;
+	bool put_mod = false;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
+	if (sdev->put_lld_mod_ref) {
+		mod = sdev->host->hostt->module;
+		put_mod = true;
+	}
+
 	scsi_dh_release_device(sdev);
 
 	parent = sdev->sdev_gendev.parent;
@@ -502,11 +509,16 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
+	if (put_mod)
+		module_put(mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
+
+	sdp->put_lld_mod_ref = try_module_get(sdp->host->hostt->module);
+
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 430b73bd02ac..54b46d590e2d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -206,6 +206,7 @@ struct scsi_device {
 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
 					 * creation time */
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
+	unsigned put_lld_mod_ref:1;	/* Put LLD module ref in release */
 
 	bool offline_already;		/* Device offline message logged */
 
-- 
2.31.1

