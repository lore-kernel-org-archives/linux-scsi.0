Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE3ABC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 07:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B50C561881
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 07:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348810AbhI3HmU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 03:42:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348769AbhI3HmT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 03:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632987637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ccs4WWvjs0K52txyrZNPClOBKyTtvncpkY1Ppjbp8Dg=;
        b=Gv1pq2ba3hMkd/gsR2ouAv2cwPnWTuiQTioDdOZibZfBManzbs1m2q20TRwWmekRzBr7br
        JxhrCVyxbkHPelCRJFHfHkeWaemUv9xFogx7N/Szx/N9Kdx4iyjZz3LPYfL05cWuMudu2b
        ayWFMazljRfativhUJGD2Y9G6d7LU98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-A32UsdvdNaChoPUXqyLsfw-1; Thu, 30 Sep 2021 03:40:35 -0400
X-MC-Unique: A32UsdvdNaChoPUXqyLsfw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5C0B824FB8;
        Thu, 30 Sep 2021 07:40:34 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F10111972D;
        Thu, 30 Sep 2021 07:40:33 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH V2] scsi: core: put LLD module refcnt after SCSI device is released
Date:   Thu, 30 Sep 2021 15:40:26 +0800
Message-Id: <20210930074026.1011114-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI host release is triggered when SCSI device is freed, and we have to
make sure that LLD module won't be unloaded before SCSI host instance is
released because shost->hostt is required in host release handler.

So put LLD module refcnt after SCSI device is released.

The real release handler can be run from wq context in case of
in_interrupt(), so add one atomic counter for serializing putting
module via current and wq context. This way is fine since we don't
call scsi_device_put() in fast IO path.

Reported-by: Changhui Zhong <czhong@redhat.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi.c        |  8 +++++++-
 drivers/scsi/scsi_sysfs.c  | 10 ++++++++++
 include/scsi/scsi_device.h |  2 ++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b241f9e3885c..b6612161587f 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -553,8 +553,14 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	module_put(sdev->host->hostt->module);
+	struct module *mod = sdev->host->hostt->module;
+
+	atomic_inc(&sdev->put_dev_cnt);
+
 	put_device(&sdev->sdev_gendev);
+
+	if (atomic_dec_if_positive(&sdev->put_dev_cnt) >= 0)
+		module_put(mod);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 86793259e541..ba6defac91ae 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -449,9 +449,16 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	unsigned long flags;
+	struct module *mod;
+	bool put_mod = false;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
+	if (atomic_dec_if_positive(&sdev->put_dev_cnt) >= 0) {
+		put_mod = true;
+		mod = sdev->host->hostt->module;
+	}
+
 	scsi_dh_release_device(sdev);
 
 	parent = sdev->sdev_gendev.parent;
@@ -502,6 +509,9 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
+
+	if (put_mod)
+		module_put(mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 430b73bd02ac..76268c473c22 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -111,6 +111,8 @@ struct scsi_device {
 	struct sbitmap budget_map;
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
 
+	atomic_t put_dev_cnt;	/* increased by 1 when we are putting device */
+
 	atomic_t restarts;
 	spinlock_t list_lock;
 	struct list_head starved_entry;
-- 
2.31.1

