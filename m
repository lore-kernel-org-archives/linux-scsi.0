Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A0DC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAB22207BC
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgE2Nrj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 09:47:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:35698 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgE2Nri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 09:47:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D9702AF16;
        Fri, 29 May 2020 13:47:36 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] scsi: move target device list to xarray
Date:   Fri, 29 May 2020 15:47:28 +0200
Message-Id: <20200529134730.146573-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200529134730.146573-1-hare@suse.de>
References: <20200529134730.146573-1-hare@suse.de>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/scsi.c        | 35 +++++++++++++++++++++--------------
 drivers/scsi/scsi_lib.c    |  9 ++++-----
 drivers/scsi/scsi_scan.c   |  4 ++--
 drivers/scsi/scsi_sysfs.c  | 29 +++++++++++++++++++++++++++--
 include/scsi/scsi_device.h |  4 ++--
 5 files changed, 56 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d601424e32b2..a3e01708744f 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -601,13 +601,14 @@ static struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
 void starget_for_each_device(struct scsi_target *starget, void *data,
 		     void (*fn)(struct scsi_device *, void *))
 {
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct scsi_device *sdev;
+	unsigned long lun_idx = 0;
 
-	shost_for_each_device(sdev, shost) {
-		if ((sdev->channel == starget->channel) &&
-		    (sdev->id == starget->id))
-			fn(sdev, data);
+	xa_for_each(&starget->__devices, lun_idx, sdev) {
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
+	unsigned long lun_idx = 0;
 
-	__shost_for_each_device(sdev, shost) {
-		if ((sdev->channel == starget->channel) &&
-		    (sdev->id == starget->id))
-			fn(sdev, data);
-	}
+	xa_for_each(&starget->__devices, lun_idx, sdev)
+		fn(sdev, data);
 }
 EXPORT_SYMBOL(__starget_for_each_device);
 
@@ -658,12 +656,21 @@ EXPORT_SYMBOL(__starget_for_each_device);
 struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
 						   u64 lun)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev = NULL;
+	unsigned long lun_idx = 0;
+
+	if (lun < UINT_MAX)
+		sdev = xa_load(&starget->__devices, lun);
+	if (sdev && sdev->lun == lun) {
+		if (sdev->sdev_state == SDEV_DEL)
+			sdev = NULL;
+		return sdev;
+	}
 
-	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
+	xa_for_each(&starget->__devices, lun_idx, sdev) {
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
-		if (sdev->lun ==lun)
+		if (sdev->lun == lun)
 			return sdev;
 	}
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 06c260f6cdae..fc01591d32a8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -372,9 +372,9 @@ static void scsi_kick_queue(struct request_queue *q)
 static void scsi_single_lun_run(struct scsi_device *current_sdev)
 {
 	struct Scsi_Host *shost = current_sdev->host;
-	struct scsi_device *sdev, *tmp;
+	struct scsi_device *sdev;
 	struct scsi_target *starget = scsi_target(current_sdev);
-	unsigned long flags;
+	unsigned long flags, lun_idx = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	starget->starget_sdev_user = NULL;
@@ -391,8 +391,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (starget->starget_sdev_user)
 		goto out;
-	list_for_each_entry_safe(sdev, tmp, &starget->devices,
-			same_target_siblings) {
+	xa_for_each(&starget->__devices, lun_idx, sdev) {
 		if (sdev == current_sdev)
 			continue;
 		if (scsi_device_get(sdev))
@@ -401,7 +400,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_kick_queue(sdev->request_queue);
 		spin_lock_irqsave(shost->host_lock, flags);
-	
+
 		scsi_device_put(sdev);
 	}
  out:
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b72265614a9b..e88ee895ab2a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -235,7 +235,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	mutex_init(&sdev->state_mutex);
 	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
-	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
@@ -327,6 +326,7 @@ static void scsi_target_dev_release(struct device *dev)
 	struct device *parent = dev->parent;
 	struct scsi_target *starget = to_scsi_target(dev);
 
+	xa_destroy(&starget->__devices);
 	kfree(starget);
 	put_device(parent);
 }
@@ -414,7 +414,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->id = id;
 	starget->channel = channel;
 	starget->can_queue = 0;
-	INIT_LIST_HEAD(&starget->devices);
+	xa_init_flags(&starget->__devices, XA_FLAGS_ALLOC);
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index a694b25be5da..05a0111d4a6d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -434,6 +434,7 @@ static void scsi_device_cls_release(struct device *class_dev)
 static void scsi_device_dev_release_usercontext(struct work_struct *work)
 {
 	struct scsi_device *sdev;
+	struct scsi_target *starget;
 	struct device *parent;
 	struct list_head *this, *tmp;
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
@@ -441,6 +442,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	unsigned long flags;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
+	starget = sdev->sdev_target;
 
 	scsi_dh_release_device(sdev);
 
@@ -448,7 +450,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
 	list_del(&sdev->siblings);
-	list_del(&sdev->same_target_siblings);
+	xa_erase(&starget->__devices, sdev->lun_idx);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
@@ -1590,6 +1592,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	unsigned long flags;
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_target  *starget = sdev->sdev_target;
+	int ret = -ERANGE;
 
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
@@ -1617,7 +1620,29 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_add_tail(&sdev->same_target_siblings, &starget->devices);
+	if (sdev->lun < 256) {
+		sdev->lun_idx = sdev->lun;
+		ret = xa_insert(&starget->__devices, (unsigned int)sdev->lun,
+				sdev, GFP_ATOMIC);
+	}
+	/*
+	 * Use a free index if the LUN is larger than 32 bit or
+	 * if the index is already taken. Leave the lower 256
+	 * entries free to avoid collisions.
+	 */
+	if (ret) {
+		struct xa_limit scsi_lun_limit = {
+			.min = 256,
+			.max = UINT_MAX,
+		};
+		ret = xa_alloc(&starget->__devices, &sdev->lun_idx,
+			       sdev, scsi_lun_limit, GFP_ATOMIC);
+	}
+	if (ret) {
+		shost_printk(KERN_ERR, shost,
+			     "LUN index %u:%u:%llu allocation error %d\n",
+			     sdev_channel(sdev), sdev_id(sdev), sdev->lun, ret);
+	}
 	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/*
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8cb31bbd8a82..56801661f481 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -104,7 +104,6 @@ struct scsi_device {
 
 	/* the next two are protected by the host->host_lock */
 	struct list_head    siblings;   /* list of all devices on this host */
-	struct list_head    same_target_siblings; /* just the devices sharing same target id */
 
 	atomic_t device_busy;		/* commands actually active on LLDD */
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
@@ -123,6 +122,7 @@ struct scsi_device {
 
 	u16 id, channel;
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
+	struct xarray		__devices;
 	struct device		dev;
 	struct kref		reap_ref; /* last put renders target invisible */
 	u16			channel;
-- 
2.16.4

