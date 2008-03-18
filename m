From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 8/8] Remove reap_ref
Date: Tue, 18 Mar 2008 14:32:28 +0100
Message-ID: <20080318133228.ACA1F159169@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51378 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbYCRNcb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 09:32:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


struct scsi_target contains a 'reap_ref' counter, which is
basically a reference counter for the target.
As we now have proper reference counting we can remove it.
This also cleans out the calling sequence for scsi_target_reap(),
which now will only be called from the release function of the
scsi_device, so we're guaranteed to always have a valid target.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c   |   23 ++++++++++++++---------
 drivers/scsi/scsi_sysfs.c  |    3 ---
 include/scsi/scsi_device.h |    1 -
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index be54354..29f7037 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -402,7 +402,6 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	}
 	dev = &starget->dev;
 	device_initialize(dev);
-	starget->reap_ref = 1;
 	dev->parent = get_device(parent);
 	sprintf(dev->bus_id, "target%d:%d:%d",
 		shost->host_no, channel, id);
@@ -448,7 +447,6 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	return starget;
 
  found:
-	found_target->reap_ref++;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	if (found_target->state != STARGET_DEL) {
 		put_device(parent);
@@ -505,7 +503,7 @@ void scsi_target_reap(struct scsi_target *starget)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
+	if (list_empty(&starget->devices)) {
 		if (starget->state == STARGET_CREATED) {
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			starget->state = STARGET_DEL;
@@ -1516,8 +1514,13 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	if (scsi_host_scan_allowed(shost))
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 	mutex_unlock(&shost->scan_mutex);
-	transport_configure_device(&starget->dev);
-	scsi_target_reap(starget);
+	/*
+	 * scsi_target_reap is called from the release function
+	 * of each sdev.
+	 */
+	if (starget->state != STARGET_DEL)
+		transport_configure_device(&starget->dev);
+
 	put_device(&starget->dev);
 
 	return sdev;
@@ -1595,10 +1598,12 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
 	}
 
  out_reap:
-	/* now determine if the target has any children at all
-	 * and if not, nuke it */
-	transport_configure_device(&starget->dev);
-	scsi_target_reap(starget);
+	/*
+	 * scsi_target_reap is called from the release function
+	 * of each sdev.
+	 */
+	if (starget->state != STARGET_DEL)
+		transport_configure_device(&starget->dev);
 
 	put_device(&starget->dev);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7d744e0..df1c415 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -297,7 +297,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	starget = to_scsi_target(parent);
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
@@ -937,7 +936,6 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	struct scsi_device *sdev;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	starget->reap_ref++;
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
@@ -950,7 +948,6 @@ static void __scsi_remove_target(struct scsi_target *starget)
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	scsi_target_reap(starget);
 }
 
 static int __remove_child (struct device * dev, void * data)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f6a9fe0..ccc437b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -196,7 +196,6 @@ struct scsi_target {
 	struct list_head	siblings;
 	struct list_head	devices;
 	struct device		dev;
-	unsigned int		reap_ref; /* protected by the host lock */
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
-- 
1.5.2.4

