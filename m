Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A0AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 14:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65DBC2084C
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 14:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbgE0OOP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 10:14:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:51216 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730030AbgE0OON (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 May 2020 10:14:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B300FAB99;
        Wed, 27 May 2020 14:14:13 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] scsi: remove direct device lookup per host
Date:   Wed, 27 May 2020 16:14:00 +0200
Message-Id: <20200527141400.58087-5-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200527141400.58087-1-hare@suse.de>
References: <20200527141400.58087-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drop the per-host device list for direct lookup and iterate
over the targets and devices xarrays instead.
As both are now using xarrays the lookup is more efficient
as we can use the provided indices based on the HCTL id
to do a direct lookup instead of traversing lists.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c       |  1 -
 drivers/scsi/scsi.c        | 68 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_scan.c   | 20 ++++++++------
 drivers/scsi/scsi_sysfs.c  | 13 ++-------
 include/scsi/scsi_device.h | 13 +++++----
 include/scsi/scsi_host.h   |  3 +-
 6 files changed, 85 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 7109afad0183..004a50a95560 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -382,7 +382,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->host_lock = &shost->default_lock;
 	spin_lock_init(shost->host_lock);
 	shost->shost_state = SHOST_CREATED;
-	INIT_LIST_HEAD(&shost->__devices);
 	xa_init(&shost->__targets);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 36aec2b37caa..172767e7ee71 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -554,18 +554,39 @@ EXPORT_SYMBOL(scsi_device_put);
 struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 					   struct scsi_device *prev)
 {
-	struct list_head *list = (prev ? &prev->siblings : &shost->__devices);
+	struct scsi_target *starget;
 	struct scsi_device *next = NULL;
 	unsigned long flags;
+	unsigned long tid = 0, lun_idx = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	while (list->next != &shost->__devices) {
-		next = list_entry(list->next, struct scsi_device, siblings);
-		/* skip devices that we can't get a reference to */
+	if (!prev) {
+		starget = xa_find(&shost->__targets, &tid,
+				       ULONG_MAX, XA_PRESENT);
+		if (starget) {
+			next = xa_find(&starget->devices, &lun_idx,
+				       ULONG_MAX, XA_PRESENT);
+			if (!scsi_device_get(next)) {
+				spin_unlock_irqrestore(shost->host_lock, flags);
+				return next;
+			}
+		}
+	} else {
+		starget = prev->sdev_target;
+		lun_idx = prev->lun_idx;
+	}
+	while (starget) {
+		tid = (starget->channel << 16) | starget->id;
+		next = xa_find_after(&starget->devices, &tid,
+				     ULONG_MAX, XA_PRESENT);
+		if (!next) {
+			lun_idx = 0;
+			starget = xa_find_after(&shost->__targets, &tid,
+						ULONG_MAX, XA_PRESENT);
+			continue;
+		}
 		if (!scsi_device_get(next))
 			break;
-		next = NULL;
-		list = list->next;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
@@ -575,6 +596,38 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL(__scsi_iterate_devices);
 
+/* helper for __shost_for_each_device, see that for documentation */
+struct scsi_device *__scsi_iterate_devices_unlocked(struct Scsi_Host *shost,
+						    struct scsi_device *prev)
+{
+	struct scsi_target *starget;
+	struct scsi_device *next = NULL;
+	unsigned long tid = 0, lun_idx = 0;
+
+	if (!prev) {
+		starget = xa_find(&shost->__targets, &tid,
+				       ULONG_MAX, XA_PRESENT);
+		if (starget)
+			return xa_find(&starget->devices, &lun_idx,
+				       ULONG_MAX, XA_PRESENT);
+	} else {
+		starget = prev->sdev_target;
+		lun_idx = prev->lun_idx;
+	}
+	while (starget) {
+		tid = (starget->channel << 16) | starget->id;
+		next = xa_find_after(&starget->devices, &tid,
+				     ULONG_MAX, XA_PRESENT);
+		if (next)
+			return next;
+		lun_idx = 0;
+		starget = xa_find_after(&shost->__targets, &tid,
+					ULONG_MAX, XA_PRESENT);
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(__scsi_iterate_devices_unlocked);
+
 /**
  * __scsi_target_lookup  -  find a target based on channel and target id
  * @shost:	SCSI host pointer
@@ -582,11 +635,12 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
  * @id:		ID of the target
  *
  */
-static struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
+struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
 					 u16 channel, u16 id)
 {
 	return xa_load(&shost->__targets, (channel << 16) | id);
 }
+EXPORT_SYMBOL(__scsi_target_lookup);
 
 /**
  * starget_for_each_device  -  helper to walk all devices of a target
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6fce5fe6ef32..24179591848b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -238,7 +238,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		sdev->lun_idx = (unsigned int)-1;
 	mutex_init(&sdev->state_mutex);
 	sdev->sdev_state = SDEV_CREATED;
-	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
@@ -1849,17 +1848,22 @@ EXPORT_SYMBOL(scsi_scan_host);
 
 void scsi_forget_host(struct Scsi_Host *shost)
 {
+	struct scsi_target *starget;
 	struct scsi_device *sdev;
 	unsigned long flags;
+	unsigned long tid = 0;
 
- restart:
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry(sdev, &shost->__devices, siblings) {
-		if (sdev->sdev_state == SDEV_DEL)
-			continue;
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		__scsi_remove_device(sdev);
-		goto restart;
+	xa_for_each(&shost->__targets, tid, starget) {
+		unsigned long lun_id = 0;
+
+		xa_for_each(&starget->devices, lun_id, sdev) {
+			if (sdev->sdev_state == SDEV_DEL)
+				continue;
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			__scsi_remove_device(sdev);
+			spin_lock_irqsave(shost->host_lock, flags);
+		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b9ed56d6bd95..24822f6ee136 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -434,7 +434,6 @@ static void scsi_device_cls_release(struct device *class_dev)
 static void scsi_device_dev_release_usercontext(struct work_struct *work)
 {
 	struct scsi_device *sdev;
-	struct scsi_target *starget = sdev->sdev_target;
 	struct device *parent;
 	struct list_head *this, *tmp;
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
@@ -448,8 +447,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	parent = sdev->sdev_gendev.parent;
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	list_del(&sdev->siblings);
-	xa_erase(&starget->devices, sdev->lun_idx);
+	xa_erase(&sdev->sdev_target->devices, sdev->lun_idx);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
@@ -1475,19 +1473,16 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
 	struct scsi_device *sdev;
+	unsigned long lun_idx = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
- restart:
-	list_for_each_entry(sdev, &shost->__devices, siblings) {
+	xa_for_each(&starget->devices, lun_idx, sdev) {
 		/*
 		 * We cannot call scsi_device_get() here, as
 		 * we might've been called from rmmod() causing
 		 * scsi_device_get() to fail the module_is_live()
 		 * check.
 		 */
-		if (sdev->channel != starget->channel ||
-		    sdev->id != starget->id)
-			continue;
 		if (sdev->sdev_state == SDEV_DEL ||
 		    sdev->sdev_state == SDEV_CANCEL ||
 		    !get_device(&sdev->sdev_gendev))
@@ -1496,7 +1491,6 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		scsi_remove_device(sdev);
 		put_device(&sdev->sdev_gendev);
 		spin_lock_irqsave(shost->host_lock, flags);
-		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
@@ -1633,7 +1627,6 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 		WARN_ON(!xa_alloc(&starget->devices, &sdev->lun_idx,
 				  sdev, scsi_lun_limit, GFP_KERNEL));
 	}
-	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/*
 	 * device can now only be removed via __scsi_remove_device() so hold
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2c6b9d8bc40e..b811b5e3adfe 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -102,9 +102,6 @@ struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
 
-	/* the next two are protected by the host->host_lock */
-	struct list_head    siblings;   /* list of all devices on this host */
-
 	atomic_t device_busy;		/* commands actually active on LLDD */
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
 
@@ -376,6 +373,10 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
 	     (sdev); \
 	     (sdev) = __scsi_iterate_devices((shost), (sdev)))
 
+/* only exposed to implement shost_for_each_device */
+struct scsi_device *__scsi_iterate_devices_unlocked(struct Scsi_Host *,
+						    struct scsi_device *);
+
 /**
  * __shost_for_each_device - iterate over all devices of a host (UNLOCKED)
  * @sdev: the &struct scsi_device to use as a cursor
@@ -389,8 +390,10 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
  * device list in interrupt context.  Otherwise you really want to use
  * shost_for_each_device instead.
  */
-#define __shost_for_each_device(sdev, shost) \
-	list_for_each_entry((sdev), &((shost)->__devices), siblings)
+#define __shost_for_each_device(sdev, shost)				\
+	for((sdev) = __scsi_iterate_devices_unlocked((shost), NULL);	\
+	    (sdev);							\
+	    (sdev) = __scsi_iterate_devices_unlocked((shost),(sdev)))
 
 extern int scsi_change_queue_depth(struct scsi_device *, int);
 extern int scsi_track_queue_full(struct scsi_device *, int);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b9395676c75b..ee0b72075e9f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -520,9 +520,8 @@ struct Scsi_Host {
 	 * their __ prefixed variants with the lock held. NEVER
 	 * access this list directly from a driver.
 	 */
-	struct list_head	__devices;
 	struct xarray		__targets;
-	
+
 	struct list_head	starved_list;
 
 	spinlock_t		default_lock;
-- 
2.16.4

