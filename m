From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix allocating target in scsi scan
Date: Wed, 3 Nov 2010 22:38:53 +0800
Message-ID: <AANLkTi=VdM5xzxcfQ+w1j8R3=3s4r-riKytzGKRznLOd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64646 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0KCOiz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2010 10:38:55 -0400
Received: by wwe15 with SMTP id 15so753341wwe.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2010 07:38:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When allocating target fails NUL is directly returned without making
certain that it already exists.

The uncertainty is fixed by checking already created targets, then
returns the correct.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_scan.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_scan.c	2010-11-03 22:29:34.000000000 +0800
@@ -410,7 +410,7 @@ static struct scsi_target *scsi_alloc_ta
 	starget = kzalloc(size, GFP_KERNEL);
 	if (!starget) {
 		printk(KERN_ERR "%s: allocation failure\n", __func__);
-		return NULL;
+		goto retry;
 	}
 	dev = &starget->dev;
 	device_initialize(dev);
@@ -435,7 +435,10 @@ static struct scsi_target *scsi_alloc_ta
 	found_target = __scsi_find_target(parent, channel, id);
 	if (found_target)
 		goto found;
-
+	if (! dev) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return NULL;
+	}
 	list_add_tail(&starget->siblings, &shost->__targets);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/* allocate and add */
@@ -459,14 +462,17 @@ static struct scsi_target *scsi_alloc_ta
 	found_target->reap_ref++;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	if (found_target->state != STARGET_DEL) {
-		put_device(dev);
+		if (dev)
+			put_device(dev);
 		return found_target;
 	}
 	/* Unfortunately, we found a dying target; need to
 	 * wait until it's dead before we can get a new one */
 	put_device(&found_target->dev);
 	flush_scheduled_work();
-	goto retry;
+	if (dev)
+		goto retry;
+	return NULL;
 }

 static void scsi_target_reap_usercontext(struct work_struct *work)
