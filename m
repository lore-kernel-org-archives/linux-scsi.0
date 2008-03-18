From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 5/8] rework scsi_target allocation
Date: Tue, 18 Mar 2008 14:32:28 +0100
Message-ID: <20080318133228.764CA15915C@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbYCRNcd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 09:32:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


The current target allocation code registeres each possible target
with sysfs; it will be deleted again if no useable LUN on this target
was found. This results in a string of 'target add/target remove' uevents.

This patch reworks the target allocation code so that only
uevents for existing targets are sent. The sysfs registration
is split off from the existing scsi_target_alloc() into a
in a new scsi_add_target() function, which should be called
whenever an existing target is found. Only then a uevent is
sent, so we'll be generating events for existing targets only.

And while we're at it the cleanup code has been moved to the
->release function, so that the target will always be useable
as long as the reference to it is held.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/scsi/scsi_scan.c   |   74 ++++++++++++++++++++++++++++---------------
 include/scsi/scsi_device.h |    3 +-
 2 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e1644b2..be54354 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -326,7 +326,15 @@ static void scsi_target_dev_release(struct device *dev)
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
@@ -406,7 +414,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->channel = channel;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
-	starget->state = STARGET_RUNNING;
+	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -419,18 +427,6 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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
 
@@ -438,9 +434,12 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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
@@ -463,21 +462,31 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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
 		container_of(work, struct scsi_target, ew.work);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	unsigned long flags;
 
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
 
@@ -497,7 +506,12 @@ void scsi_target_reap(struct scsi_target *starget)
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
@@ -1056,12 +1070,17 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
@@ -1886,6 +1905,9 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 	if (!starget)
 		goto out;
 
+	if (scsi_add_target(starget))
+		goto out;
+
 	sdev = scsi_alloc_sdev(starget, 0, NULL);
 	if (sdev) {
 		sdev->sdev_gendev.parent = get_device(&starget->dev);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index b8b19e2..f6a9fe0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -181,7 +181,8 @@ struct scsi_device {
 	sdev_printk(prefix, (scmd)->device, fmt, ##a)
 
 enum scsi_target_state {
-	STARGET_RUNNING = 1,
+	STARGET_CREATED = 1,
+	STARGET_RUNNING,
 	STARGET_DEL,
 };
 
-- 
1.5.2.4

