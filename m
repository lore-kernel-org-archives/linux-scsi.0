Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213BBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C40613A7
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348070AbhI3FXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 01:23:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348045AbhI3FXp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 01:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632979322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0sKvzl1S1AnFk1PwGWAsvKYt90LSgZ57DclyOTi7Ok8=;
        b=V5YqOeGQiLk0eV8rgET4k8CbSYEJd7KrSs7fd6FbIJFWFSD0duq1lACBOR9HadH19NDrUH
        jnWL+Bet2NQgOx4cLyAPq5gV9YZLv/x4rDHrOnw64rci8Kn4Mf+R44qeLTsB+OG/E3SSVH
        BQwE9rU1fGJ6tQOiywvkvcKEi4Jvrvw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-xzaAO0vhOEmyVZuVg3F9cA-1; Thu, 30 Sep 2021 01:22:01 -0400
X-MC-Unique: xzaAO0vhOEmyVZuVg3F9cA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 195E283DB29;
        Thu, 30 Sep 2021 05:22:00 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8676C19733;
        Thu, 30 Sep 2021 05:21:34 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Changhui Zhong <czhong@redhat.com>, Yi Zhang <yi.zhang@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/2] scsi: core: put LLD module refcnt after SCSI device is released
Date:   Thu, 30 Sep 2021 13:20:28 +0800
Message-Id: <20210930052028.934747-3-ming.lei@redhat.com>
In-Reply-To: <20210930052028.934747-1-ming.lei@redhat.com>
References: <20210930052028.934747-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI host release is triggered when SCSI device is released, and we have to
make sure that LLD module won't be unloaded before SCSI host instance is
released.

So put LLD module refcnt after SCSI device is released.

SCSI device release may be moved into workqueue context if scsi_device_put
is called in interrupt context, and handle this case by piggybacking
putting LLD module refcnt into SCSI device release handler.

Reported-by: Changhui Zhong <czhong@redhat.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi.c        | 14 ++++++++++++--
 drivers/scsi/scsi_sysfs.c  |  8 ++++++++
 include/scsi/scsi_device.h |  1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b241f9e3885c..7cad256ba895 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -553,8 +553,18 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	module_put(sdev->host->hostt->module);
-	put_device(&sdev->sdev_gendev);
+	struct module *mod = sdev->host->hostt->module;
+	/*
+	 * sdev->sdev_gendev's real release handler will be scheduled into
+	 * user context if we are in interrupt context, and we have to put
+	 * LLD module refcnt after the device is really released.
+	 */
+	preempt_disable();
+	if (put_device(&sdev->sdev_gendev) && in_interrupt())
+		sdev->put_lld_mod_refcnt = 1;
+	else
+		module_put(mod);
+	preempt_enable();
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 86793259e541..dc056ba5a656 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -449,9 +449,14 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	unsigned long flags;
+	struct module *lld_mod;
+	bool put_lld_mod_refcnt;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
+	lld_mod = sdev->host->hostt->module;
+	put_lld_mod_refcnt = sdev->put_lld_mod_refcnt;
+
 	scsi_dh_release_device(sdev);
 
 	parent = sdev->sdev_gendev.parent;
@@ -502,6 +507,9 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
+
+	if (put_lld_mod_refcnt)
+		module_put(lld_mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 430b73bd02ac..9d3fcb9cfd01 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -206,6 +206,7 @@ struct scsi_device {
 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
 					 * creation time */
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
+	unsigned put_lld_mod_refcnt:1;  /* Put LLD mod refcnt */
 
 	bool offline_already;		/* Device offline message logged */
 
-- 
2.31.1

