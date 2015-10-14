From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 1/3] SCSI: Introduce device_lock and target_lock in Scsi_Host
Date: Wed, 14 Oct 2015 15:50:06 +0200
Message-ID: <f2ff8b554116663d7acf35fa84c23886bf486ffb.1444829611.git.jthumshirn@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbbJNNuP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Oct 2015 09:50:15 -0400
In-Reply-To: <cover.1444829611.git.jthumshirn@suse.de>
In-Reply-To: <cover.1444829611.git.jthumshirn@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

Introduce target_lock and device_lock to untangle the __devices and __targets
lists from the host_lock.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/53c700.c     |  3 +++
 drivers/scsi/hosts.c      |  2 ++
 drivers/scsi/scsi.c       |  8 ++++----
 drivers/scsi/scsi_scan.c  | 10 +++++-----
 drivers/scsi/scsi_sysfs.c | 18 ++++++++----------
 include/scsi/scsi_host.h  |  2 ++
 6 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a209c34..e2b4d04 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1093,6 +1093,7 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 		struct NCR_700_command_slot *slot;
 		__u8 reselection_id = hostdata->reselection_id;
 		struct scsi_device *SDp;
+		unsigned long flags;
 
 		lun = hostdata->msgin[0] & 0x1f;
 
@@ -1100,7 +1101,9 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 		DEBUG(("scsi%d: (%d:%d) RESELECTED!\n",
 		       host->host_no, reselection_id, lun));
 		/* clear the reselection indicator */
+		spin_lock_irqsave(host->device_lock, flags);
 		SDp = __scsi_device_lookup(host, 0, reselection_id, lun);
+		spin_unlock_irqrestore(host->device_lock, flags);
 		if(unlikely(SDp == NULL)) {
 			printk(KERN_ERR "scsi%d: (%d:%d) HAS NO device\n",
 			       host->host_no, reselection_id, lun);
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e..6855434 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -380,6 +380,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
 	shost->host_lock = &shost->default_lock;
 	spin_lock_init(shost->host_lock);
+	spin_lock_init(&shost->device_lock);
+	spin_lock_init(&shost->target_lock);
 	shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->__targets);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 207d6a7..0e1046a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -970,7 +970,7 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 	struct scsi_device *next = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->device_lock, flags);
 	while (list->next != &shost->__devices) {
 		next = list_entry(list->next, struct scsi_device, siblings);
 		/* skip devices that we can't get a reference to */
@@ -979,7 +979,7 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 		next = NULL;
 		list = list->next;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->device_lock, flags);
 
 	if (prev)
 		scsi_device_put(prev);
@@ -1144,11 +1144,11 @@ struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
 	struct scsi_device *sdev;
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->device_lock, flags);
 	sdev = __scsi_device_lookup(shost, channel, id, lun);
 	if (sdev && scsi_device_get(sdev))
 		sdev = NULL;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->device_lock, flags);
 
 	return sdev;
 }
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f9f3f82..ac68531 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -441,14 +441,14 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
  retry:
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->target_lock, flags);
 
 	found_target = __scsi_find_target(parent, channel, id);
 	if (found_target)
 		goto found;
 
 	list_add_tail(&starget->siblings, &shost->__targets);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->target_lock, flags);
 	/* allocate and add */
 	transport_setup_device(dev);
 	if (shost->hostt->target_alloc) {
@@ -1854,15 +1854,15 @@ void scsi_forget_host(struct Scsi_Host *shost)
 	unsigned long flags;
 
  restart:
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->device_lock, flags);
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irqrestore(&shost->device_lock, flags);
 		__scsi_remove_device(sdev);
 		goto restart;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->device_lock, flags);
 }
 
 /**
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b333389..d7afea9 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1131,20 +1131,18 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	unsigned long flags;
 	struct scsi_device *sdev;
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->device_lock, flags);
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
 		    sdev->id != starget->id ||
 		    scsi_device_get(sdev))
 			continue;
-		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
 		scsi_device_put(sdev);
-		spin_lock_irqsave(shost->host_lock, flags);
 		goto restart;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->device_lock, flags);
 }
 
 /**
@@ -1164,22 +1162,22 @@ void scsi_remove_target(struct device *dev)
 	/* remove targets being careful to lookup next entry before
 	 * deleting the last
 	 */
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->target_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
 			/* assuming new targets arrive at the end */
 			kref_get(&starget->reap_ref);
-			spin_unlock_irqrestore(shost->host_lock, flags);
+			spin_unlock_irqrestore(&shost->target_lock, flags);
 			if (last)
 				scsi_target_reap(last);
 			last = starget;
 			__scsi_remove_target(starget);
-			spin_lock_irqsave(shost->host_lock, flags);
+			spin_lock_irqsave(&shost->target_lock, flags);
 		}
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->target_lock, flags);
 
 	if (last)
 		scsi_target_reap(last);
@@ -1262,10 +1260,10 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 		sdev->lun_in_cdb = 1;
 
 	transport_setup_device(&sdev->sdev_gendev);
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&shost->device_lock, flags);
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
 	list_add_tail(&sdev->siblings, &shost->__devices);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&shost->device_lock, flags);
 	/*
 	 * device can now only be removed via __scsi_remove_device() so hold
 	 * the target.  Target will be held in CREATED state until something
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e113c75..764020a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -558,6 +558,8 @@ struct Scsi_Host {
 
 	spinlock_t		default_lock;
 	spinlock_t		*host_lock;
+	spinlock_t		device_lock; /* protects the __devices list */
+	spinlock_t		target_lock; /* protects the __targets list */
 
 	struct mutex		scan_mutex;/* serialize scanning activity */
 
-- 
1.8.5.6

