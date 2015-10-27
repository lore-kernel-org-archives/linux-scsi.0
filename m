From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: restart list search after unlock in
 scsi_remove_target
Date: Tue, 27 Oct 2015 13:14:40 -0700
Message-ID: <562FDB30.1060304@sandisk.com>
References: <20151019143546.GA7486@lst.de> <1445848537.16404.26.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0077.outbound.protection.outlook.com ([207.46.100.77]:31621
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965031AbbJ0UOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Oct 2015 16:14:45 -0400
In-Reply-To: <1445848537.16404.26.camel@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 10/26/2015 01:35 AM, Johannes Thumshirn wrote:
> I haven't heard anything from the original reporter of the lockup but
> my test's went all O.K., so
> 
> Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Hello Christoph and Johannes,

How about the patch below, which is a variant of Christoph's patch ?

Thanks,

Bart.

[PATCH] scsi: Restart list search after unlock in scsi_remove_target

When dropping a lock while iterating a list we must restart the search
as other threads could have manipulated the list under us.  Without this
we can get stuck in an endless loop. Introduce a new member variable
"visible" in struct scsi_target to track presence in sysfs.

Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_scan.c   | 16 +++-------------
 drivers/scsi/scsi_sysfs.c  | 19 ++++++-------------
 include/scsi/scsi_device.h |  1 +
 3 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f9f3f82..7b74470 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -314,7 +314,6 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
 
-	starget->state = STARGET_DEL;
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->hostt->target_destroy)
@@ -379,12 +378,8 @@ static void scsi_target_reap_ref_release(struct kref *kref)
 	struct scsi_target *starget
 		= container_of(kref, struct scsi_target, reap_ref);
 
-	/*
-	 * if we get here and the target is still in the CREATED state that
-	 * means it was allocated but never made visible (because a scan
-	 * turned up no LUNs), so don't call device_del() on it.
-	 */
-	if (starget->state != STARGET_CREATED) {
+	if (starget->visible) {
+		starget->visible = false;
 		transport_remove_device(&starget->dev);
 		device_del(&starget->dev);
 	}
@@ -507,12 +502,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
  */
 void scsi_target_reap(struct scsi_target *starget)
 {
-	/*
-	 * serious problem if this triggers: STARGET_DEL is only set in the if
-	 * the reap_ref drops to zero, so we're trying to do another final put
-	 * on an already released kref
-	 */
-	BUG_ON(starget->state == STARGET_DEL);
+	starget->state = STARGET_DEL;
 	scsi_target_reap_ref_put(starget);
 }
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5e085d4..de8e202 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -974,7 +974,7 @@ static int scsi_target_add(struct scsi_target *starget)
 {
 	int error;
 
-	if (starget->state != STARGET_CREATED)
+	if (starget->visible)
 		return 0;
 
 	error = device_add(&starget->dev);
@@ -983,6 +983,7 @@ static int scsi_target_add(struct scsi_target *starget)
 		return error;
 	}
 	transport_add_device(&starget->dev);
+	starget->visible = true;
 	starget->state = STARGET_RUNNING;
 
 	pm_runtime_set_active(&starget->dev);
@@ -1166,31 +1167,23 @@ static void __scsi_remove_target(struct scsi_target *starget)
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget, *last = NULL;
+	struct scsi_target *starget;
 	unsigned long flags;
 
-	/* remove targets being careful to lookup next entry before
-	 * deleting the last
-	 */
+restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
-			/* assuming new targets arrive at the end */
 			kref_get(&starget->reap_ref);
 			spin_unlock_irqrestore(shost->host_lock, flags);
-			if (last)
-				scsi_target_reap(last);
-			last = starget;
 			__scsi_remove_target(starget);
-			spin_lock_irqsave(shost->host_lock, flags);
+			scsi_target_reap(starget);
+			goto restart;
 		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	if (last)
-		scsi_target_reap(last);
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index fe89d7c..d5a5f21 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -267,6 +267,7 @@ struct scsi_target {
 	unsigned int		expecting_lun_change:1;	/* A device has reported
 						 * a 3F/0E UA, other devices on
 						 * the same target will also. */
+	unsigned int		visible:1; /* visible in sysfs */
 	/* commands actually active on LLD. */
 	atomic_t		target_busy;
 	atomic_t		target_blocked;
-- 
2.1.4

