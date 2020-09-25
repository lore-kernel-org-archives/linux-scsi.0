Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2CCC47432
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF6A235FD
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z1XU8uol"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgIYQTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729472AbgIYQTk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:40 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I8nvqUGVqAwMorQosWtn1/SwIepEf1j+KL4FD6RqP0c=;
        b=Z1XU8uolsY5vaAsSn7NUydYMBU/wzpcui/H3Vrbx3wSnhLXNZO3PWbkgLVXseD3W2ZBLm7
        L0vpkgraCNUOOOfabANj846rx0rMv/uH3OFnKqNW1G+8B8/eqNEkFrgaM4wqo8ZMn2u9jn
        e73UUp2bWBbSn25q/zEnd4XlvwJkfF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-3_Q53fmcNXCUjYOrAROw0w-1; Fri, 25 Sep 2020 12:19:36 -0400
X-MC-Unique: 3_Q53fmcNXCUjYOrAROw0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D371104FC89;
        Fri, 25 Sep 2020 16:19:35 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CED4A5D9DC;
        Fri, 25 Sep 2020 16:19:34 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 04/12] scsi: Add durable_name for dev_printk
Date:   Fri, 25 Sep 2020 11:19:21 -0500
Message-Id: <20200925161929.1136806-5-tasleson@redhat.com>
In-Reply-To: <20200925161929.1136806-1-tasleson@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the needed functions to fill out the durable_name function
call back for scsi based storage devices.  This allows calls
into dev_printk for scsi devices to have a persistent id
associated with them.

Signed-off-by: Tony Asleson <tasleson@redhat.com>
---
 drivers/scsi/scsi_lib.c    |  9 +++++++++
 drivers/scsi/scsi_sysfs.c  | 35 ++++++++++++++++++++++++++++-------
 drivers/scsi/sd.c          |  2 ++
 include/scsi/scsi_device.h |  3 +++
 4 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 06056e9ec333..aa5601733763 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3151,3 +3151,12 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 	return group_id;
 }
 EXPORT_SYMBOL(scsi_vpd_tpg_id);
+
+int scsi_durable_name(struct scsi_device *sdev, char *buf, size_t len)
+{
+	int vpd_len = scsi_vpd_lun_id(sdev, buf, len);
+	if (vpd_len > 0 && vpd_len < len)
+		return vpd_len + 1;
+	return 0;
+}
+EXPORT_SYMBOL(scsi_durable_name);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 163dbcb741c1..c4840bc80b47 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -504,15 +504,19 @@ static struct class sdev_class = {
 	.dev_release	= scsi_device_cls_release,
 };
 
+static struct scsi_device *dev_to_scsi_device(const struct device *dev)
+{
+	return dev->type == &scsi_dev_type ? to_scsi_device(dev) : NULL;
+}
+
 /* all probing is done in the individual ->probe routines */
 static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 {
-	struct scsi_device *sdp;
+	struct scsi_device *sdp = dev_to_scsi_device(dev);
 
-	if (dev->type != &scsi_dev_type)
+	if (!sdp)
 		return 0;
 
-	sdp = to_scsi_device(dev);
 	if (sdp->no_uld_attach)
 		return 0;
 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
@@ -520,13 +524,11 @@ static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 
 static int scsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev = dev_to_scsi_device(dev);
 
-	if (dev->type != &scsi_dev_type)
+	if (!sdev)
 		return 0;
 
-	sdev = to_scsi_device(dev);
-
 	add_uevent_var(env, "MODALIAS=" SCSI_DEVICE_MODALIAS_FMT, sdev->type);
 	return 0;
 }
@@ -1582,6 +1584,24 @@ static struct device_type scsi_dev_type = {
 	.groups =	scsi_sdev_attr_groups,
 };
 
+int dev_to_scsi_durable_name(const struct device *dev, char *buf, size_t len)
+{
+	/*
+	 * When we go through dev_printk in the scsi layer, dev is embedded
+	 * in a struct scsi_device.  When we go through the block layer,
+	 * dev is embedded in struct genhd, thus we need different paths to
+	 * retrieve the struct scsi_device to call scsi_durable_name.
+	 */
+	struct scsi_device *sdev = dev_to_scsi_device(dev);
+	if (!sdev)
+		sdev = dev_to_scsi_device(dev->parent);
+	if (!sdev)
+		return 0;
+
+	return scsi_durable_name(sdev, buf, len);
+}
+EXPORT_SYMBOL(dev_to_scsi_durable_name);
+
 void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
 	unsigned long flags;
@@ -1591,6 +1611,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.type = &scsi_dev_type;
+	sdev->sdev_gendev.durable_name = dev_to_scsi_durable_name;
 	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d90fefffe31b..69ff339fa5ea 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3386,6 +3386,8 @@ static int sd_probe(struct device *dev)
 	gd->private_data = &sdkp->driver;
 	gd->queue = sdkp->device->request_queue;
 
+	disk_to_dev(gd)->durable_name = dev_to_scsi_durable_name;
+
 	/* defaults, until the device tells us otherwise */
 	sdp->sector_size = 512;
 	sdkp->capacity = 0;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bc5909033d13..7b6cff11d502 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -464,6 +464,9 @@ extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
 extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
+extern int dev_to_scsi_durable_name(const struct device *dev, char *buf,
+					size_t len);
+extern int scsi_durable_name(struct scsi_device *sdev, char *buf, size_t len);
 
 #ifdef CONFIG_PM
 extern int scsi_autopm_get_device(struct scsi_device *);
-- 
2.26.2

