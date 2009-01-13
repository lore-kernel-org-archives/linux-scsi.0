From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Restart scsi_device_lookup_by_target
Date: Tue, 13 Jan 2009 14:50:30 +0100
Message-ID: <496C9C26.9020106@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040906090709040903060106"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:40226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660AbZAMNud (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 08:50:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------040906090709040903060106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

currently we have this:

struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
                                                 uint lun)
{
        struct scsi_device *sdev;
        struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
        unsigned long flags;

        spin_lock_irqsave(shost->host_lock, flags);
        sdev = __scsi_device_lookup_by_target(starget, lun);
        if (sdev && scsi_device_get(sdev))
                sdev = NULL;
        spin_unlock_irqrestore(shost->host_lock, flags);

        return sdev;
}

now consider an sdev list with two entries for LUN 0, the first
being in SDEV_DEL and the second being in SDEV_RUNNING.

scsi_device_lookup_by_target will always return NULL here, as
it will never be able to skip past the first (unuseable)
entry. So scsi_report_lun_scan will happily create duplicate
sdevs for LUN 0 and we'll be getting the infamous

sysfs: duplicate filename 'xxxx' can not be created

errors.

What we should be doing here is to restart
__scsi_device_lookup_by_target() if we find an
sdev but cannot use it (ie is in SDEV_DEL).

James, please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------040906090709040903060106
Content-Type: text/plain;
 name="scsi-restart-lookup-by-target"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-restart-lookup-by-target"

Restart scsi_device_lookup_by_target()

When scsi_device_lookup_by_target() will always return
the first sdev with a matching LUN, regardless of
the state. However, when this sdev is in SDEV_DEL
it's quite possible to have additional sdevs in the
list with the same LUN which are active.
So we should restart __scsi_device_lookup_by_target()
whenever we find an sdev with state SDEV_DEL.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 62a4618..ac0488b 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -1158,7 +1158,7 @@ static int esp_reconnect(struct esp *esp)
 			   ESP_BUSID);
 
 	tp = &esp->target[target];
-	dev = __scsi_device_lookup_by_target(tp->starget, lun);
+	dev = __scsi_device_lookup_by_target(tp->starget, NULL, lun);
 	if (!dev) {
 		printk(KERN_ERR PFX "esp%d: Reconnect, no lp "
 		       "tgt[%u] lun[%u]\n",
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index f8b79d4..b2c3c61 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1094,23 +1094,29 @@ EXPORT_SYMBOL(__starget_for_each_device);
 /**
  * __scsi_device_lookup_by_target - find a device given the target (UNLOCKED)
  * @starget:	SCSI target pointer
+ * @sdev:	SCSI device pointer
  * @lun:	SCSI Logical Unit Number
  *
  * Description: Looks up the scsi_device with the specified @lun for a given
  * @starget.  The returned scsi_device does not have an additional
  * reference.  You must hold the host's host_lock over this call and
- * any access to the returned scsi_device.
+ * any access to the returned scsi_device. If @sdev is not NULL use the
+ * specified @sdev as a starting point after which to start the lookup.
  *
  * Note:  The only reason why drivers should use this is because
  * they need to access the device list in irq context.  Otherwise you
  * really want to use scsi_device_lookup_by_target instead.
  **/
 struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
+						   struct scsi_device *sdev,
 						   uint lun)
 {
-	struct scsi_device *sdev;
+	if (!sdev)
+		sdev = list_prepare_entry(sdev, &starget->devices,
+					  same_target_siblings);
 
-	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
+	list_for_each_entry_continue(sdev, &starget->devices,
+				     same_target_siblings) {
 		if (sdev->lun ==lun)
 			return sdev;
 	}
@@ -1131,14 +1137,15 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_target);
 struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
 						 uint lun)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev = NULL;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	sdev = __scsi_device_lookup_by_target(starget, lun);
+ restart:
+	sdev = __scsi_device_lookup_by_target(starget, sdev, lun);
 	if (sdev && scsi_device_get(sdev))
-		sdev = NULL;
+		goto restart;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	return sdev;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bb80937..710f150 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -285,6 +285,7 @@ extern struct scsi_device *__scsi_device_lookup(struct Scsi_Host *,
 extern struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *,
 							uint);
 extern struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *,
+							  struct scsi_device *,
 							  uint);
 extern void starget_for_each_device(struct scsi_target *, void *,
 		     void (*fn)(struct scsi_device *, void *));

--------------040906090709040903060106--
