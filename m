Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBC1C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 843E2208B3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgGTC54 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 22:57:56 -0400
Received: from smtp.infotech.no ([82.134.31.41]:42952 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbgGTC5z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jul 2020 22:57:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 5E5B420426F;
        Mon, 20 Jul 2020 04:57:53 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZUMna8pGkirQ; Mon, 20 Jul 2020 04:57:51 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 6269520425B;
        Mon, 20 Jul 2020 04:57:48 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v5 3/9] scsi: move target device list to xarray
Date:   Sun, 19 Jul 2020 22:57:36 -0400
Message-Id: <20200720025742.349296-4-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720025742.349296-1-dgilbert@interlog.com>
References: <20200720025742.349296-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Use xarray for device lookup by target. If the LUN only uses
the first two levels (ie 32 bit) it can be used directly
as the index into the xarray.
LUNs using more than two levels will overflow the xarray index;
they will be stored in the next free index in the xarray.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi.c        | 35 +++++++++++++++++++++--------------
 drivers/scsi/scsi_lib.c    |  9 ++++-----
 drivers/scsi/scsi_scan.c   |  5 +++--
 drivers/scsi/scsi_sysfs.c  | 36 +++++++++++++++++++++++++++++++++---
 include/scsi/scsi_device.h |  4 ++--
 5 files changed, 63 insertions(+), 26 deletions(-)

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
index 0ba7a65e7c8d..b4bd42e7392b 100644
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
+	unsigned long flags, lun_idx = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	starget->starget_sdev_user = NULL;
@@ -380,8 +380,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (starget->starget_sdev_user)
 		goto out;
-	list_for_each_entry_safe(sdev, tmp, &starget->devices,
-			same_target_siblings) {
+	xa_for_each(&starget->__devices, lun_idx, sdev) {
 		if (sdev == current_sdev)
 			continue;
 		if (scsi_device_get(sdev))
@@ -390,7 +389,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_kick_queue(sdev->request_queue);
 		spin_lock_irqsave(shost->host_lock, flags);
-	
+
 		scsi_device_put(sdev);
 	}
  out:
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9fc35b6cbc30..51faeb0dd742 100644
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
@@ -327,6 +326,8 @@ static void scsi_target_dev_release(struct device *dev)
 	struct device *parent = dev->parent;
 	struct scsi_target *starget = to_scsi_target(dev);
 
+	WARN_ON(!xa_empty(&starget->__devices));
+	xa_destroy(&starget->__devices);
 	kfree(starget);
 	put_device(parent);
 }
@@ -414,7 +415,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->id = id;
 	starget->channel = channel;
 	starget->can_queue = 0;
-	INIT_LIST_HEAD(&starget->devices);
+	xa_init_flags(&starget->__devices, XA_FLAGS_ALLOC);
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 83bdcb032853..3a56c713d9bd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -433,7 +433,8 @@ static void scsi_device_cls_release(struct device *class_dev)
 
 static void scsi_device_dev_release_usercontext(struct work_struct *work)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *tmp_sdev;
+	struct scsi_target *starget;
 	struct device *parent;
 	struct list_head *this, *tmp;
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
@@ -441,6 +442,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	unsigned long flags;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
+	starget = sdev->sdev_target;
 
 	scsi_dh_release_device(sdev);
 
@@ -448,7 +450,12 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
 	list_del(&sdev->siblings);
-	list_del(&sdev->same_target_siblings);
+	/* Use cmpxchg to avoid accidental deletion */
+	tmp_sdev = xa_cmpxchg(&starget->__devices, sdev->lun_idx, sdev,
+			      NULL, GFP_ATOMIC);
+	if (tmp_sdev != sdev)
+		sdev_printk(KERN_WARNING, sdev,
+			    "index %u reassigned!\n", sdev->lun_idx);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
@@ -1593,6 +1600,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	unsigned long flags;
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_target  *starget = sdev->sdev_target;
+	int ret = -ERANGE;
 
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
@@ -1620,7 +1628,29 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_add_tail(&sdev->same_target_siblings, &starget->devices);
+	if (sdev->lun < UINT_MAX) {
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
index 867559eca33d..4d06c059aa01 100644
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
@@ -288,7 +288,7 @@ enum scsi_target_state {
 struct scsi_target {
 	struct scsi_device	*starget_sdev_user;
 	struct list_head	siblings;
-	struct list_head	devices;
+	struct xarray		__devices;
 	struct device		dev;
 	struct kref		reap_ref; /* last put renders target invisible */
 	u16			channel;
-- 
2.25.1

