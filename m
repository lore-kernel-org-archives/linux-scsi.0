Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5598C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BC74208B3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgGTC5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 22:57:52 -0400
Received: from smtp.infotech.no ([82.134.31.41]:42926 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgGTC5w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jul 2020 22:57:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 65A2720425C;
        Mon, 20 Jul 2020 04:57:49 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kvvDbrvZihg7; Mon, 20 Jul 2020 04:57:46 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id E95EC20424C;
        Mon, 20 Jul 2020 04:57:45 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v5 1/9] scsi: convert target lookup to xarray
Date:   Sun, 19 Jul 2020 22:57:34 -0400
Message-Id: <20200720025742.349296-2-dgilbert@interlog.com>
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

Use an xarray instead of lists for holding the scsi targets.
I've also shortened the 'channel' and 'id' values to 16 bit
as none of the drivers requires a full 32bit range for either
of them, and by shortening them we can use them as the index
into the xarray for storing the scsi_target pointer.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/hosts.c       |  4 +++-
 drivers/scsi/scsi.c        | 32 +++++++++++++++----------
 drivers/scsi/scsi_scan.c   | 49 ++++++++++++++++----------------------
 drivers/scsi/scsi_sysfs.c  | 16 +++++++++----
 include/scsi/scsi_device.h | 15 ++++++++----
 include/scsi/scsi_host.h   |  2 +-
 6 files changed, 65 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 7ec91c3a66ca..be599c855701 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -189,6 +189,8 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
+	WARN_ON(!xa_empty(&shost->__targets));
+	xa_destroy(&shost->__targets);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -383,7 +385,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
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
index f2437a7570ce..9fc35b6cbc30 100644
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
@@ -433,27 +414,37 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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
-
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
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	if (error) {
+		dev_printk(KERN_ERR, dev,
+			     "target %u:%u index allocation failed, error %d\n",
+			     channel, id, error);
+		put_device(dev);
+		kfree(starget);
+		return NULL;
+	}
 	/* allocate and add */
 	transport_setup_device(dev);
 	if (shost->hostt->target_alloc) {
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
index 163dbcb741c1..83bdcb032853 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1511,16 +1511,21 @@ static void __scsi_remove_target(struct scsi_target *starget)
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget;
+	struct scsi_target *starget, *starget_next;
+	unsigned long tid = 0;
 	unsigned long flags;
 
-restart:
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry(starget, &shost->__targets, siblings) {
+	starget = xa_find(&shost->__targets, &tid, UINT_MAX, XA_PRESENT);
+	while (starget) {
+		starget_next = xa_find_after(&shost->__targets, &tid,
+					     UINT_MAX, XA_PRESENT);
 		if (starget->state == STARGET_DEL ||
 		    starget->state == STARGET_REMOVE ||
-		    starget->state == STARGET_CREATED_REMOVE)
+		    starget->state == STARGET_CREATED_REMOVE) {
+			starget = starget_next;
 			continue;
+		}
 		if (starget->dev.parent == dev || &starget->dev == dev) {
 			kref_get(&starget->reap_ref);
 			if (starget->state == STARGET_CREATED)
@@ -1530,8 +1535,9 @@ void scsi_remove_target(struct device *dev)
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			__scsi_remove_target(starget);
 			scsi_target_reap(starget);
-			goto restart;
+			spin_lock_irqsave(shost->host_lock, flags);
 		}
+		starget = starget_next;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bc5909033d13..867559eca33d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -121,7 +121,7 @@ struct scsi_device {
 
 	unsigned long last_queue_ramp_up;	/* last queue ramp up time */
 
-	unsigned int id, channel;
+	u16 id, channel;
 	u64 lun;
 	unsigned int manufacturer;	/* Manufacturer of device, for using 
 					 * vendor-specific cmd's */
@@ -291,8 +291,8 @@ struct scsi_target {
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
@@ -324,6 +324,11 @@ struct scsi_target {
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
@@ -348,9 +353,9 @@ extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
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
index 46ef8cccc982..d0a765dd995a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -528,7 +528,7 @@ struct Scsi_Host {
 	 * access this list directly from a driver.
 	 */
 	struct list_head	__devices;
-	struct list_head	__targets;
+	struct xarray		__targets;
 	
 	struct list_head	starved_list;
 
-- 
2.25.1

