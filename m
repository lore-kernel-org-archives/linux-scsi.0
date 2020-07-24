Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EFFC433FC
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7472120658
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 17:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B7iTNU3K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgGXRRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 13:17:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58230 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726639AbgGXRRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 13:17:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595611038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y66z1B4c6fd79YJ8+1DTAA3bMJbfS37SvBej44OKRts=;
        b=B7iTNU3KhN9Ep3ZR8JAoHIXOtYlyL8gpWiyhpUajBjpbfL+kfNH3onJFN2CY5/tfTWlxsk
        Y9rQl08D59v6Rc0hwRb1x2a5XbtWE8aY0pd43/wpRGXkEL44R6M1fXh8s/x16/TS/ImYjC
        8JIbJQG5OkExppFwh/cR3pg47rc43R0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-dMhTJkwrMRupsvzsxnVuJQ-1; Fri, 24 Jul 2020 13:17:17 -0400
X-MC-Unique: dMhTJkwrMRupsvzsxnVuJQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1BDB91275;
        Fri, 24 Jul 2020 17:17:15 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93F3874F64;
        Fri, 24 Jul 2020 17:17:14 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
Subject: [v4 04/11] scsi: Add durable_name for dev_printk
Date:   Fri, 24 Jul 2020 12:16:59 -0500
Message-Id: <20200724171706.1550403-5-tasleson@redhat.com>
In-Reply-To: <20200724171706.1550403-1-tasleson@redhat.com>
References: <20200724171706.1550403-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 06c260f6cdae..9f6c41162c55 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3142,3 +3142,17 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
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
index 163dbcb741c1..f719b63f4b63 100644
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
index a793cb08d025..f40e4cb4a5f6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3360,6 +3360,8 @@ static int sd_probe(struct device *dev)
 	gd->private_data = &sdkp->driver;
 	gd->queue = sdkp->device->request_queue;
 
+	disk_to_dev(gd)->durable_name = dev_to_scsi_durable_name;
+
 	/* defaults, until the device tells us otherwise */
 	sdp->sector_size = 512;
 	sdkp->capacity = 0;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c3cba2aaf934..7be5861565f7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -461,6 +461,9 @@ extern void sdev_disable_disk_events(struct scsi_device *sdev);
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

