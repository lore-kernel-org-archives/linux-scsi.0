From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 1/3] switch sdev sysfs attributes to default attributes
Date: Thu, 20 Sep 2007 13:46:07 +0200
Message-ID: <20070920114607.A52BC26807@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:49248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbXITLqJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2007 07:46:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: kay.sievers@vrfy.org, linux-scsi@vger.kernel.org

With the current target allocation code a target is registered
with sysfs for each possible target; it will be deleted again
if no useable LUN on this target is found. This results in a
lot of 'target add/target remove' uevents.

This patch reworks the target allocation code so that only
uevents for existing targets are sent. The sysfs registration
is split off from the existing scsi_target_alloc() into a
in a new scsi_add_target() function, which should be called
whenever an existing target is found.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/scsi/scsi_scan.c   |   73 +++++++++++++++++++++++++++++----------------
 include/scsi/scsi_device.h |    3 +
 2 files changed, 50 insertions(+), 26 deletions(-)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -319,7 +319,15 @@ static void scsi_target_dev_release(stru
 {
 	struct device *parent = dev->parent;
 	struct scsi_target *starget = to_scsi_target(dev);
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	unsigned long flags;
 
+	transport_destroy_device(&starget->dev);
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (shost->hostt->target_destroy)
+		shost->hostt->target_destroy(starget);
+	list_del_init(&starget->siblings);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 	kfree(starget);
 	put_device(parent);
 }
@@ -391,7 +399,7 @@ static struct scsi_target *scsi_alloc_ta
 	starget->channel = channel;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
-	starget->state = STARGET_RUNNING;
+	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -404,18 +412,6 @@ static struct scsi_target *scsi_alloc_ta
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/* allocate and add */
 	transport_setup_device(dev);
-	error = device_add(dev);
-	if (error) {
-		dev_err(dev, "target device_add failed, error %d\n", error);
-		spin_lock_irqsave(shost->host_lock, flags);
-		list_del_init(&starget->siblings);
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		transport_destroy_device(dev);
-		put_device(parent);
-		kfree(starget);
-		return NULL;
-	}
-	transport_add_device(dev);
 	if (shost->hostt->target_alloc) {
 		error = shost->hostt->target_alloc(starget);
 
@@ -423,13 +419,15 @@ static struct scsi_target *scsi_alloc_ta
 			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
 			/* don't want scsi_target_reap to do the final
 			 * put because it will be under the host lock */
-			get_device(dev);
-			scsi_target_reap(starget);
-			put_device(dev);
+			spin_lock_irqsave(shost->host_lock, flags);
+			list_del_init(&starget->siblings);
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			transport_destroy_device(dev);
+			put_device(parent);
+			kfree(starget);
 			return NULL;
 		}
 	}
-	get_device(dev);
 
 	return starget;
 
@@ -448,6 +446,24 @@ static struct scsi_target *scsi_alloc_ta
 	goto retry;
 }
 
+static int scsi_add_target(struct scsi_target *starget)
+{
+	int error;
+
+	error = device_add(&starget->dev);
+	if (error) {
+		dev_err(&starget->dev, "target device_add failed, error %d\n", error);
+		get_device(&starget->dev);
+		scsi_target_reap(starget);
+		put_device(&starget->dev);
+		return error;
+	}
+	transport_add_device(&starget->dev);
+	starget->state = STARGET_RUNNING;
+
+	return 0;
+}
+
 static void scsi_target_reap_usercontext(struct work_struct *work)
 {
 	struct scsi_target *starget =
@@ -457,12 +473,6 @@ static void scsi_target_reap_usercontext
 
 	transport_remove_device(&starget->dev);
 	device_del(&starget->dev);
-	transport_destroy_device(&starget->dev);
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (shost->hostt->target_destroy)
-		shost->hostt->target_destroy(starget);
-	list_del_init(&starget->siblings);
-	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(&starget->dev);
 }
 
@@ -483,7 +493,12 @@ void scsi_target_reap(struct scsi_target
 	spin_lock_irqsave(shost->host_lock, flags);
 
 	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
-		BUG_ON(starget->state == STARGET_DEL);
+		if (starget->state == STARGET_CREATED) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			starget->state = STARGET_DEL;
+			put_device(&starget->dev);
+			return;
+		}
 		starget->state = STARGET_DEL;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		execute_in_process_context(scsi_target_reap_usercontext,
@@ -1042,12 +1057,17 @@ static int scsi_probe_and_add_lun(struct
 					scsi_inq_str(vend, result, 8, 16),
 					scsi_inq_str(mod, result, 16, 32));
 			});
+			if (scsi_add_target(starget))
+				goto out_free_result;
+
 		}
-		
 		res = SCSI_SCAN_TARGET_PRESENT;
 		goto out_free_result;
 	}
 
+	if (lun == 0 && scsi_add_target(starget))
+		goto out_free_result;
+
 	/*
 	 * Some targets may set slight variations of PQ and PDT to signal
 	 * that no LUN is present, so don't add sdev in these cases.
@@ -1846,6 +1866,9 @@ struct scsi_device *scsi_get_host_dev(st
 	if (!starget)
 		goto out;
 
+	if (scsi_add_target(starget))
+		goto out;
+
 	sdev = scsi_alloc_sdev(starget, 0, NULL);
 	if (sdev) {
 		sdev->sdev_gendev.parent = get_device(&starget->dev);
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -163,7 +163,8 @@ struct scsi_device {
 	sdev_printk(prefix, (scmd)->device, fmt, ##a)
 
 enum scsi_target_state {
-	STARGET_RUNNING = 1,
+	STARGET_CREATED = 1,
+	STARGET_RUNNING,
 	STARGET_DEL,
 };
 
