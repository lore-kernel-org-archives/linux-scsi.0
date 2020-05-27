Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D47C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 14:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF20B207D8
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 14:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388041AbgE0OON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 10:14:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:51214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729959AbgE0OON (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 May 2020 10:14:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B336EB123;
        Wed, 27 May 2020 14:14:13 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] scsi: move target device list to xarray
Date:   Wed, 27 May 2020 16:13:59 +0200
Message-Id: <20200527141400.58087-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200527141400.58087-1-hare@suse.de>
References: <20200527141400.58087-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use xarray for device lookup by target. LUNs below 256 are linear,
and can be used directly as the index into the xarray.
LUNs above 256 have a distinct LUN format, and are not necessarily
linear. They'll be stored in indices above 256 in the xarray, with
the next free index in the xarray.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c        | 28 +++++++++++++++-------------
 drivers/scsi/scsi_lib.c    |  8 +++-----
 drivers/scsi/scsi_scan.c   |  7 +++++--
 drivers/scsi/scsi_sysfs.c  | 15 +++++++++++++--
 include/scsi/scsi_device.h |  4 ++--
 5 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 25c815355d1a..36aec2b37caa 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -601,13 +601,14 @@ static struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
 void starget_for_each_device(struct scsi_target *starget, void *data,
 		     void (*fn)(struct scsi_device *, void *))
 {
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct scsi_device *sdev;
+	unsigned long lun_id = 0;
 
-	shost_for_each_device(sdev, shost) {
-		if ((sdev->channel == starget->channel) &&
-		    (sdev->id == starget->id))
-			fn(sdev, data);
+	xa_for_each(&starget->devices, lun_id, sdev) {
+		if (scsi_device_get(sdev))
+			continue;
+		fn(sdev, data);
+		scsi_device_put(sdev);
 	}
 }
 EXPORT_SYMBOL(starget_for_each_device);
@@ -629,14 +630,11 @@ EXPORT_SYMBOL(starget_for_each_device);
 void __starget_for_each_device(struct scsi_target *starget, void *data,
 			       void (*fn)(struct scsi_device *, void *))
 {
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct scsi_device *sdev;
+	unsigned long lun_id = 0;
 
-	__shost_for_each_device(sdev, shost) {
-		if ((sdev->channel == starget->channel) &&
-		    (sdev->id == starget->id))
-			fn(sdev, data);
-	}
+	xa_for_each(&starget->devices, lun_id, sdev)
+		fn(sdev, data);
 }
 EXPORT_SYMBOL(__starget_for_each_device);
 
@@ -659,11 +657,15 @@ struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
 						   u64 lun)
 {
 	struct scsi_device *sdev;
+	unsigned long lun_idx = 0;
+
+	if (lun < 256)
+		return xa_load(&starget->devices, lun);
 
-	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
+	xa_for_each(&starget->devices, lun_idx, sdev) {
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
-		if (sdev->lun ==lun)
+		if (sdev->lun == lun)
 			return sdev;
 	}
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c163fa22267c..23c99fbe47d5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -361,9 +361,9 @@ static void scsi_kick_queue(struct request_queue *q)
 static void scsi_single_lun_run(struct scsi_device *current_sdev)
 {
 	struct Scsi_Host *shost = current_sdev->host;
-	struct scsi_device *sdev, *tmp;
+	struct scsi_device *sdev;
 	struct scsi_target *starget = scsi_target(current_sdev);
-	unsigned long flags;
+	unsigned long flags, lun_id = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	starget->starget_sdev_user = NULL;
@@ -380,8 +380,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (starget->starget_sdev_user)
 		goto out;
-	list_for_each_entry_safe(sdev, tmp, &starget->devices,
-			same_target_siblings) {
+	xa_for_each(&starget->devices, lun_id, sdev) {
 		if (sdev == current_sdev)
 			continue;
 		if (scsi_device_get(sdev))
@@ -390,7 +389,6 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_kick_queue(sdev->request_queue);
 		spin_lock_irqsave(shost->host_lock, flags);
-	
 		scsi_device_put(sdev);
 	}
  out:
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c47cddef1839..6fce5fe6ef32 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -232,10 +232,13 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->id = starget->id;
 	sdev->lun = lun;
 	sdev->channel = starget->channel;
+	if (lun < 256)
+		sdev->lun_idx = lun;
+	else
+		sdev->lun_idx = (unsigned int)-1;
 	mutex_init(&sdev->state_mutex);
 	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
-	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
@@ -417,7 +420,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->id = id;
 	starget->channel = channel;
 	starget->can_queue = 0;
-	INIT_LIST_HEAD(&starget->devices);
+	xa_init(&starget->devices);
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 95aaa96ce03b..b9ed56d6bd95 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -434,6 +434,7 @@ static void scsi_device_cls_release(struct device *class_dev)
 static void scsi_device_dev_release_usercontext(struct work_struct *work)
 {
 	struct scsi_device *sdev;
+	struct scsi_target *starget = sdev->sdev_target;
 	struct device *parent;
 	struct list_head *this, *tmp;
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
@@ -448,7 +449,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
 	list_del(&sdev->siblings);
-	list_del(&sdev->same_target_siblings);
+	xa_erase(&starget->devices, sdev->lun_idx);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
@@ -1621,7 +1622,17 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_add_tail(&sdev->same_target_siblings, &starget->devices);
+	if (sdev->lun_idx != (unsigned long)-1)
+		WARN_ON(!xa_insert(&starget->devices, sdev->lun_idx,
+				   sdev, GFP_KERNEL));
+	else {
+		struct xa_limit scsi_lun_limit = {
+			.min = 256,
+			.max = UINT_MAX,
+		};
+		WARN_ON(!xa_alloc(&starget->devices, &sdev->lun_idx,
+				  sdev, scsi_lun_limit, GFP_KERNEL));
+	}
 	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/*
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 28034cc0fce5..2c6b9d8bc40e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -104,7 +104,6 @@ struct scsi_device {
 
 	/* the next two are protected by the host->host_lock */
 	struct list_head    siblings;   /* list of all devices on this host */
-	struct list_head    same_target_siblings; /* just the devices sharing same target id */
 
 	atomic_t device_busy;		/* commands actually active on LLDD */
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
@@ -123,6 +122,7 @@ struct scsi_device {
 
 	unsigned int id, channel;
 	u64 lun;
+	unsigned int lun_idx;		/* Index into target device xarray */
 	unsigned int manufacturer;	/* Manufacturer of device, for using 
 					 * vendor-specific cmd's */
 	unsigned sector_size;	/* size in bytes */
@@ -285,7 +285,7 @@ enum scsi_target_state {
 struct scsi_target {
 	struct scsi_device	*starget_sdev_user;
 	struct list_head	siblings;
-	struct list_head	devices;
+	struct xarray		devices;
 	struct device		dev;
 	struct kref		reap_ref; /* last put renders target invisible */
 	unsigned int		channel;
-- 
2.16.4

