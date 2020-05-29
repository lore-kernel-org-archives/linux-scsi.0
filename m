Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DA4C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 749802145D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgE2Nrj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 09:47:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:35678 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgE2Nri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 09:47:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D1220AF72;
        Fri, 29 May 2020 13:47:36 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/5] scsi: convert target lookup to xarray
Date:   Fri, 29 May 2020 15:47:26 +0200
Message-Id: <20200529134730.146573-2-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200529134730.146573-1-hare@suse.de>
References: <20200529134730.146573-1-hare@suse.de>
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
 drivers/scsi/hosts.c       |  3 ++-
 drivers/scsi/scsi.c        | 32 ++++++++++++++++++------------
 drivers/scsi/scsi_scan.c   | 49 ++++++++++++++++++++--------------------------
 drivers/scsi/scsi_sysfs.c  |  9 ++++++---
 include/scsi/scsi_device.h | 15 +++++++++-----
 include/scsi/scsi_host.h   |  2 +-
 6 files changed, 60 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 7ec91c3a66ca..87537b0745c1 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -189,6 +189,7 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
+	xa_destroy(&shost->__targets);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -383,7 +384,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	spin_lock_init(shost->host_lock);
 	shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
-	INIT_LIST_HEAD(&shost->__targets);
+	xa_init_flags(&shost->__targets, XA_FLAGS_LOCK_IRQ);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 56c24a73e0c7..d601424e32b2 100644
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
@@ -701,19 +714,14 @@ EXPORT_SYMBOL(scsi_device_lookup_by_target);
  * really want to use scsi_device_lookup instead.
  **/
 struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
-		uint channel, uint id, u64 lun)
+		u16 channel, u16 id, u64 lun)
 {
-	struct scsi_device *sdev;
+	struct scsi_target *starget;
 
-	list_for_each_entry(sdev, &shost->__devices, siblings) {
-		if (sdev->sdev_state == SDEV_DEL)
-			continue;
-		if (sdev->channel == channel && sdev->id == id &&
-				sdev->lun ==lun)
-			return sdev;
-	}
-
-	return NULL;
+	starget = __scsi_target_lookup(shost, channel, id);
+	if (!starget)
+		return NULL;
+	return __scsi_device_lookup_by_target(starget, lun);
 }
 EXPORT_SYMBOL(__scsi_device_lookup);
 
@@ -729,7 +737,7 @@ EXPORT_SYMBOL(__scsi_device_lookup);
  * needs to be released with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
-		uint channel, uint id, u64 lun)
+		u16 channel, u16 id, u64 lun)
 {
 	struct scsi_device *sdev;
 	unsigned long flags;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2437a7570ce..b72265614a9b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -309,6 +309,7 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	struct device *dev = &starget->dev;
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
+	unsigned long tid = scsi_target_index(starget);
 
 	BUG_ON(starget->state == STARGET_DEL);
 	starget->state = STARGET_DEL;
@@ -316,7 +317,7 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->hostt->target_destroy)
 		shost->hostt->target_destroy(starget);
-	list_del_init(&starget->siblings);
+	xa_erase(&shost->__targets, tid);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(dev);
 }
@@ -341,27 +342,6 @@ int scsi_is_target_device(const struct device *dev)
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
@@ -417,6 +397,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	struct scsi_target *starget;
 	struct scsi_target *found_target;
 	int error, ref_got;
+	unsigned long tid;
 
 	starget = kzalloc(size, GFP_KERNEL);
 	if (!starget) {
@@ -433,19 +414,29 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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
-	if (found_target)
+	found_target = xa_load(&shost->__targets, tid);
+	if (found_target) {
+		get_device(&found_target->dev);
 		goto found;
-
-	list_add_tail(&starget->siblings, &shost->__targets);
+	}
+	error = xa_insert(&shost->__targets, tid, starget, GFP_ATOMIC);
+	if (error) {
+		dev_printk(KERN_ERR, dev,
+			     "target %u:%u index allocation failed, error %d\n",
+			     channel, id, error);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		put_device(dev);
+		kfree(starget);
+		return NULL;
+	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/* allocate and add */
 	transport_setup_device(dev);
@@ -453,7 +444,9 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		error = shost->hostt->target_alloc(starget);
 
 		if(error) {
-			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
+			dev_printk(KERN_ERR, dev,
+				   "target %u:%u allocation failed, error %d\n",
+				   channel, id, error);
 			/* don't want scsi_target_reap to do the final
 			 * put because it will be under the host lock */
 			scsi_target_destroy(starget);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 163dbcb741c1..a694b25be5da 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1512,11 +1512,14 @@ void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	struct scsi_target *starget;
+	unsigned long tid = 0;
 	unsigned long flags;
 
-restart:
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry(starget, &shost->__targets, siblings) {
+	for(starget = xa_find(&shost->__targets, &tid, UINT_MAX, XA_PRESENT);
+	    (starget);
+	    starget = xa_find_after(&shost->__targets, &tid,
+				    UINT_MAX, XA_PRESENT)) {
 		if (starget->state == STARGET_DEL ||
 		    starget->state == STARGET_REMOVE ||
 		    starget->state == STARGET_CREATED_REMOVE)
@@ -1530,7 +1533,7 @@ void scsi_remove_target(struct device *dev)
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			__scsi_remove_target(starget);
 			scsi_target_reap(starget);
-			goto restart;
+			spin_lock_irqsave(shost->host_lock, flags);
 		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c3cba2aaf934..8cb31bbd8a82 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -121,7 +121,7 @@ struct scsi_device {
 
 	unsigned long last_queue_ramp_up;	/* last queue ramp up time */
 
-	unsigned int id, channel;
+	u16 id, channel;
 	u64 lun;
 	unsigned int manufacturer;	/* Manufacturer of device, for using 
 					 * vendor-specific cmd's */
@@ -288,8 +288,8 @@ struct scsi_target {
 	struct list_head	devices;
 	struct device		dev;
 	struct kref		reap_ref; /* last put renders target invisible */
-	unsigned int		channel;
-	unsigned int		id; /* target id ... replace
+	u16			channel;
+	u16			id; /* target id ... replace
 				     * scsi_device.id eventually */
 	unsigned int		create:1; /* signal that it needs to be added */
 	unsigned int		single_lun:1;	/* Indicates we should only
@@ -321,6 +321,11 @@ struct scsi_target {
 	/* starget_data must be the last element!!!! */
 } __attribute__((aligned(sizeof(unsigned long))));
 
+static inline u32 scsi_target_index(struct scsi_target *starget)
+{
+	return (starget->channel << 16) | (starget->id);
+}
+
 #define to_scsi_target(d)	container_of(d, struct scsi_target, dev)
 static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
 {
@@ -345,9 +350,9 @@ extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
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

