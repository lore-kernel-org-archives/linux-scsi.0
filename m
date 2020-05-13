Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AA6C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9AA320659
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 21:36:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="es7LDGHd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgEMVgg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 17:36:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25833 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729418AbgEMVgf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 17:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589405794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iioQcBbajt6DsUMKLZoLl0V6Rvd1hdXit98PKWtkBAI=;
        b=es7LDGHdghcqrnExeTHurlp51N7I4bWk5tgGeJmgV2orDBr7rIik22kaLXKSBS41rq2jFO
        /bQfadjf0C5g6Xe7JVGtGds47To3bxCEicRVMjBaeqTAjpM8tB0ISMAP5SAwEyKyegCuUt
        NYofKndycmNghDKYdFabxAIoGoaRqJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-vcL4IhL6NSCY0talxyAN3Q-1; Wed, 13 May 2020 17:36:30 -0400
X-MC-Unique: vcL4IhL6NSCY0talxyAN3Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C179EC1A1;
        Wed, 13 May 2020 21:36:29 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D609B5D9E5;
        Wed, 13 May 2020 21:36:28 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [RFC PATCH v2 6/7] scsi: Add durable_name for dev_printk
Date:   Wed, 13 May 2020 16:36:20 -0500
Message-Id: <20200513213621.470411-7-tasleson@redhat.com>
In-Reply-To: <20200513213621.470411-1-tasleson@redhat.com>
References: <20200513213621.470411-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the needed functions to fill out the durable_name function
call back for scsi based storage devices.  This allows calls
into dev_printk for scsi devices to have a persistent id
associated with them.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/scsi/scsi_lib.c    | 14 ++++++++++++++
 drivers/scsi/scsi_sysfs.c  | 23 +++++++++++++++++++++++
 drivers/scsi/sd.c          |  2 ++
 include/scsi/scsi_device.h |  3 +++
 4 files changed, 42 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 610ee41fa54c..482e41ec23c2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3121,3 +3121,17 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 	return group_id;
 }
 EXPORT_SYMBOL(scsi_vpd_tpg_id);
+
+int scsi_durable_name(struct scsi_device *sdev, char *buf, size_t len)
+{
+	int vpd_len = 0;
+
+	vpd_len = scsi_vpd_lun_id(sdev, buf, len);
+	if (vpd_len > 0 && vpd_len < len)
+		vpd_len++;
+	else
+		vpd_len = 0;
+
+	return vpd_len;
+}
+EXPORT_SYMBOL(scsi_durable_name);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 677b5c5403d2..f09f5c94ebbd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1582,6 +1582,28 @@ static struct device_type scsi_dev_type = {
 	.groups =	scsi_sdev_attr_groups,
 };
 
+
+int dev_to_scsi_durable_name(const struct device *dev, char *buf, size_t len)
+{
+	struct scsi_device *sd_dev = NULL;
+
+	// When we go through dev_printk in the scsi layer, dev is embedded
+	// in a struct scsi_device.  When we go through the block layer,
+	// dev is embedded in struct genhd, thus we need different paths to
+	// retrieve the struct scsi_device to call scsi_durable_name.
+	if (dev->type == &scsi_dev_type) {
+		sd_dev = to_scsi_device(dev);
+	} else if (dev->parent && dev->parent->type == &scsi_dev_type) {
+		sd_dev = to_scsi_device(dev->parent);
+	} else {
+		// We have a pointer to something else, bail
+		return 0;
+	}
+
+	return scsi_durable_name(sd_dev, buf, len);
+}
+EXPORT_SYMBOL(dev_to_scsi_durable_name);
+
 void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
 	unsigned long flags;
@@ -1591,6 +1613,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.type = &scsi_dev_type;
+	sdev->sdev_gendev.durable_name = dev_to_scsi_durable_name;
 	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2710a0e5ae6d..774f1a8910a2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3359,6 +3359,8 @@ static int sd_probe(struct device *dev)
 	gd->private_data = &sdkp->driver;
 	gd->queue = sdkp->device->request_queue;
 
+	disk_to_dev(gd)->durable_name = dev_to_scsi_durable_name;
+
 	/* defaults, until the device tells us otherwise */
 	sdp->sector_size = 512;
 	sdkp->capacity = 0;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f8312a3e5b42..496774ff79fc 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -459,6 +459,9 @@ extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
 extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
+extern int dev_to_scsi_durable_name(const struct device *dev, char *buf,
+					size_t len);
+extern int scsi_durable_name(struct scsi_device *sdev, char *buf, size_t len);
 
 #ifdef CONFIG_PM
 extern int scsi_autopm_get_device(struct scsi_device *);
-- 
2.25.4

