Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6910C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 11:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CEB62074B
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 11:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgFBLeV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 07:34:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:37894 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgFBLeU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Jun 2020 07:34:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5C4EAAE00;
        Tue,  2 Jun 2020 11:34:20 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] scsi: remove direct device lookup per host
Date:   Tue,  2 Jun 2020 13:33:09 +0200
Message-Id: <20200602113311.121513-5-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200602113311.121513-1-hare@suse.de>
References: <20200602113311.121513-1-hare@suse.de>
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
 drivers/scsi/scsi.c        | 84 ++++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/scsi_scan.c   | 30 ++++++++++++-----
 drivers/scsi/scsi_sysfs.c  | 20 +++++------
 include/scsi/scsi_device.h | 13 ++++---
 include/scsi/scsi_host.h   |  3 +-
 6 files changed, 117 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index be599c855701..aebef37684e8 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -384,7 +384,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->host_lock = &shost->default_lock;
 	spin_lock_init(shost->host_lock);
 	shost->shost_state = SHOST_CREATED;
-	INIT_LIST_HEAD(&shost->__devices);
 	xa_init_flags(&shost->__targets, XA_FLAGS_LOCK_IRQ);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a3e01708744f..6a1d8c6bd8f9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -554,18 +554,48 @@ EXPORT_SYMBOL(scsi_device_put);
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
-		if (!scsi_device_get(next))
+	if (!prev) {
+		starget = xa_find(&shost->__targets, &tid,
+				       UINT_MAX, XA_PRESENT);
+		if (starget) {
+			next = xa_find(&starget->__devices, &lun_idx,
+				       UINT_MAX, XA_PRESENT);
+			if (!scsi_device_get(next)) {
+				spin_unlock_irqrestore(shost->host_lock, flags);
+				return next;
+			}
+		}
+	} else {
+		starget = prev->sdev_target;
+		tid = (starget->channel << 16) | starget->id;
+		lun_idx = prev->lun_idx;
+	}
+	while (starget) {
+		next = xa_find_after(&starget->__devices, &lun_idx,
+				     UINT_MAX, XA_PRESENT);
+		if (next) {
+			if (!scsi_device_get(next))
+				break;
+			continue;
+		}
+		/* No more LUNs on this target, switch to the next */
+		starget = xa_find_after(&shost->__targets, &tid,
+					UINT_MAX, XA_PRESENT);
+		if (!starget) {
+			next = NULL;
+			break;
+		}
+		lun_idx = 0;
+		next = xa_find(&starget->__devices, &lun_idx,
+			       UINT_MAX, XA_PRESENT);
+		if (next && !scsi_device_get(next))
 			break;
-		next = NULL;
-		list = list->next;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
@@ -575,6 +605,46 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
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
+				       UINT_MAX, XA_PRESENT);
+		if (starget)
+			return xa_find(&starget->__devices, &lun_idx,
+				       UINT_MAX, XA_PRESENT);
+	} else {
+		starget = prev->sdev_target;
+		tid = scsi_target_index(starget);
+		lun_idx = prev->lun_idx;
+	}
+	while (starget) {
+		next = xa_find_after(&starget->__devices, &lun_idx,
+				     UINT_MAX, XA_PRESENT);
+		if (next)
+			return next;
+		/* No more LUNs on this target, switch to the next */
+		starget = xa_find_after(&shost->__targets, &tid,
+					UINT_MAX, XA_PRESENT);
+		if (!starget)
+			return NULL;
+
+		lun_idx = 0;
+		next = xa_find(&starget->__devices, &lun_idx,
+			       UINT_MAX, XA_PRESENT);
+		if (next)
+			return next;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(__scsi_iterate_devices_unlocked);
+
 /**
  * __scsi_target_lookup  -  find a target based on channel and target id
  * @shost:	SCSI host pointer
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 51faeb0dd742..8afb71c036d5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -234,7 +234,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->channel = starget->channel;
 	mutex_init(&sdev->state_mutex);
 	sdev->sdev_state = SDEV_CREATED;
-	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->starved_entry);
 	INIT_LIST_HEAD(&sdev->event_list);
 	spin_lock_init(&sdev->list_lock);
@@ -1851,17 +1850,30 @@ EXPORT_SYMBOL(scsi_scan_host);
 
 void scsi_forget_host(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev;
+	struct scsi_target *starget, *starget_next;
+	struct scsi_device *sdev, *sdev_next;
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
+	starget = xa_find(&shost->__targets, &tid, UINT_MAX, XA_PRESENT);
+	while (starget) {
+		unsigned long lun_idx = 0;
+
+		starget_next = xa_find_after(&shost->__targets, &tid, UINT_MAX, XA_PRESENT);
+
+		sdev = xa_find(&starget->__devices, &lun_idx, UINT_MAX, XA_PRESENT);
+		while (sdev) {
+			sdev_next = xa_find_after(&starget->__devices, &lun_idx, UINT_MAX, XA_PRESENT);
+
+			if (sdev->sdev_state != SDEV_DEL) {
+				spin_unlock_irqrestore(shost->host_lock, flags);
+				__scsi_remove_device(sdev);
+				spin_lock_irqsave(shost->host_lock, flags);
+			}
+			sdev = sdev_next;
+		}
+		starget = starget_next;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5b009ec97250..1abedbcf0521 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -449,7 +449,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	parent = sdev->sdev_gendev.parent;
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	list_del(&sdev->siblings);
 	/* Use cmpxchg to avoid accidental deletion */
 	tmp_sdev = xa_cmpxchg(&starget->__devices, sdev->lun_idx, sdev,
 			      NULL, GFP_ATOMIC);
@@ -1480,29 +1479,31 @@ static void __scsi_remove_target(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *sdev_next;
+	unsigned long lun_idx = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
- restart:
-	list_for_each_entry(sdev, &shost->__devices, siblings) {
+	sdev = xa_find(&starget->__devices, &lun_idx, UINT_MAX, XA_PRESENT);
+	while (sdev) {
+		sdev_next = xa_find_after(&starget->__devices, &lun_idx, UINT_MAX, XA_PRESENT);
+
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
-		    !get_device(&sdev->sdev_gendev))
+		    !get_device(&sdev->sdev_gendev)) {
+			sdev = sdev_next;
 			continue;
+		}
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
 		put_device(&sdev->sdev_gendev);
 		spin_lock_irqsave(shost->host_lock, flags);
-		goto restart;
+		sdev = sdev_next;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
@@ -1651,7 +1652,6 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 			     "LUN index %u:%u:%llu allocation error %d\n",
 			     sdev_channel(sdev), sdev_id(sdev), sdev->lun, ret);
 	}
-	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/*
 	 * device can now only be removed via __scsi_remove_device() so hold
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 56801661f481..3690af6ce6af 100644
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
 
@@ -381,6 +378,10 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
 	     (sdev); \
 	     (sdev) = __scsi_iterate_devices((shost), (sdev)))
 
+/* only exposed to implement shost_for_each_device */
+struct scsi_device *__scsi_iterate_devices_unlocked(struct Scsi_Host *,
+						    struct scsi_device *);
+
 /**
  * __shost_for_each_device - iterate over all devices of a host (UNLOCKED)
  * @sdev: the &struct scsi_device to use as a cursor
@@ -394,8 +395,10 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
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

