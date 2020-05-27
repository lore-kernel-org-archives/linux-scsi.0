Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68326C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 14:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43E46207D8
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 14:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388138AbgE0OOP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 10:14:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:51224 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730131AbgE0OOO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 May 2020 10:14:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B3A9BB125;
        Wed, 27 May 2020 14:14:13 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] scsi: convert target lookup to xarray
Date:   Wed, 27 May 2020 16:13:57 +0200
Message-Id: <20200527141400.58087-2-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200527141400.58087-1-hare@suse.de>
References: <20200527141400.58087-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use an xarray instead of lists for holding the scsi targets.
I've also shortened the 'channel' and 'id' values to 16 bit
as none of the drivers requires a full 32bit range for either
of them, and by shortening them we can use them as the index
into the xarray for storing the scsi_target pointer.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c       |  2 +-
 drivers/scsi/scsi.c        | 35 ++++++++++++++++++++++++-----------
 drivers/scsi/scsi_scan.c   | 39 +++++++++++++--------------------------
 drivers/scsi/scsi_sysfs.c  | 15 +++++++++++----
 include/scsi/scsi_device.h |  4 ++--
 include/scsi/scsi_host.h   |  2 +-
 6 files changed, 52 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 7ec91c3a66ca..7109afad0183 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -383,7 +383,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	spin_lock_init(shost->host_lock);
 	shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
-	INIT_LIST_HEAD(&shost->__targets);
+	xa_init(&shost->__targets);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 56c24a73e0c7..25c815355d1a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -575,6 +575,19 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL(__scsi_iterate_devices);
 
+/**
+ * __scsi_target_lookup  -  find a target based on channel and target id
+ * @shost:	SCSI host pointer
+ * @channel:	channel number of the target
+ * @id:		ID of the target
+ *
+ */
+static struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
+					 u16 channel, u16 id)
+{
+	return xa_load(&shost->__targets, (channel << 16) | id);
+}
+
 /**
  * starget_for_each_device  -  helper to walk all devices of a target
  * @starget:	target whose devices we want to iterate over.
@@ -670,8 +683,8 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_target);
 struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
 						 u64 lun)
 {
-	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct scsi_device *sdev;
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -701,19 +714,19 @@ EXPORT_SYMBOL(scsi_device_lookup_by_target);
  * really want to use scsi_device_lookup instead.
  **/
 struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
-		uint channel, uint id, u64 lun)
+		u16 channel, u16 id, u64 lun)
 {
+	struct scsi_target *starget;
 	struct scsi_device *sdev;
 
-	list_for_each_entry(sdev, &shost->__devices, siblings) {
-		if (sdev->sdev_state == SDEV_DEL)
-			continue;
-		if (sdev->channel == channel && sdev->id == id &&
-				sdev->lun ==lun)
-			return sdev;
-	}
+	starget = __scsi_target_lookup(shost, channel, id);
+	if (!starget)
+		return NULL;
+	sdev = __scsi_device_lookup_by_target(starget, lun);
+	if (sdev && sdev->sdev_state == SDEV_DEL)
+		sdev = NULL;
 
-	return NULL;
+	return sdev;
 }
 EXPORT_SYMBOL(__scsi_device_lookup);
 
@@ -729,7 +742,7 @@ EXPORT_SYMBOL(__scsi_device_lookup);
  * needs to be released with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
-		uint channel, uint id, u64 lun)
+		u16 channel, u16 id, u64 lun)
 {
 	struct scsi_device *sdev;
 	unsigned long flags;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2437a7570ce..c47cddef1839 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -304,11 +304,15 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	return NULL;
 }
 
+#define scsi_target_index(s) \
+	((((unsigned long)(s)->channel) << 16) | (s)->id)
+
 static void scsi_target_destroy(struct scsi_target *starget)
 {
 	struct device *dev = &starget->dev;
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
+	unsigned long tid = scsi_target_index(starget);
 
 	BUG_ON(starget->state == STARGET_DEL);
 	starget->state = STARGET_DEL;
@@ -316,7 +320,7 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->hostt->target_destroy)
 		shost->hostt->target_destroy(starget);
-	list_del_init(&starget->siblings);
+	xa_erase(&shost->__targets, tid);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(dev);
 }
@@ -341,27 +345,6 @@ int scsi_is_target_device(const struct device *dev)
 }
 EXPORT_SYMBOL(scsi_is_target_device);
 
-static struct scsi_target *__scsi_find_target(struct device *parent,
-					      int channel, uint id)
-{
-	struct scsi_target *starget, *found_starget = NULL;
-	struct Scsi_Host *shost = dev_to_shost(parent);
-	/*
-	 * Search for an existing target for this sdev.
-	 */
-	list_for_each_entry(starget, &shost->__targets, siblings) {
-		if (starget->id == id &&
-		    starget->channel == channel) {
-			found_starget = starget;
-			break;
-		}
-	}
-	if (found_starget)
-		get_device(&found_starget->dev);
-
-	return found_starget;
-}
-
 /**
  * scsi_target_reap_ref_release - remove target from visibility
  * @kref: the reap_ref in the target being released
@@ -417,6 +400,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	struct scsi_target *starget;
 	struct scsi_target *found_target;
 	int error, ref_got;
+	unsigned long tid;
 
 	starget = kzalloc(size, GFP_KERNEL);
 	if (!starget) {
@@ -433,19 +417,22 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->id = id;
 	starget->channel = channel;
 	starget->can_queue = 0;
-	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
+	tid = scsi_target_index(starget);
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	found_target = __scsi_find_target(parent, channel, id);
+	found_target = xa_load(&shost->__targets, tid);
 	if (found_target)
 		goto found;
-
-	list_add_tail(&starget->siblings, &shost->__targets);
+	if (xa_insert(&shost->__targets, tid, starget, GFP_KERNEL)) {
+		dev_printk(KERN_ERR, dev, "target index busy\n");
+		kfree(starget);
+		return NULL;
+	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/* allocate and add */
 	transport_setup_device(dev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 163dbcb741c1..95aaa96ce03b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1512,15 +1512,19 @@ void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	struct scsi_target *starget;
+	unsigned long tid = 0;
 	unsigned long flags;
 
-restart:
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry(starget, &shost->__targets, siblings) {
+	starget = xa_find(&shost->__targets, &tid, ULONG_MAX, XA_PRESENT);
+	while (starget) {
 		if (starget->state == STARGET_DEL ||
 		    starget->state == STARGET_REMOVE ||
-		    starget->state == STARGET_CREATED_REMOVE)
+		    starget->state == STARGET_CREATED_REMOVE) {
+			starget = xa_find_after(&shost->__targets, &tid,
+						ULONG_MAX, XA_PRESENT);
 			continue;
+		}
 		if (starget->dev.parent == dev || &starget->dev == dev) {
 			kref_get(&starget->reap_ref);
 			if (starget->state == STARGET_CREATED)
@@ -1530,7 +1534,10 @@ void scsi_remove_target(struct device *dev)
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			__scsi_remove_target(starget);
 			scsi_target_reap(starget);
-			goto restart;
+			spin_lock_irqsave(shost->host_lock, flags);
+			starget = xa_find_after(&shost->__targets, &tid,
+						ULONG_MAX, XA_PRESENT);
+			continue;
 		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c3cba2aaf934..28034cc0fce5 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -345,9 +345,9 @@ extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern int __must_check scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
-					      uint, uint, u64);
+					      u16, u16, u64);
 extern struct scsi_device *__scsi_device_lookup(struct Scsi_Host *,
-						uint, uint, u64);
+						u16, u16, u64);
 extern struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *,
 							u64);
 extern struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 822e8cda8d9b..b9395676c75b 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -521,7 +521,7 @@ struct Scsi_Host {
 	 * access this list directly from a driver.
 	 */
 	struct list_head	__devices;
-	struct list_head	__targets;
+	struct xarray		__targets;
 	
 	struct list_head	starved_list;
 
-- 
2.16.4

