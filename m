From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix breakage in the SCSI generic tag code
Date: Sat, 19 Mar 2005 13:09:13 -0600
Message-ID: <1111259353.5525.24.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:56489 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262656AbVCSTKA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2005 14:10:00 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j2JJ9xA25114
	for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2005 14:09:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

When I redid the target allocation routines, I inadvertently broke the
generic tag code.  The problem is that the device is added to the host
list after slave_configure in the new code.  This is too late since if
any command disconnects during the initial inquiry phase, we now cannot
find the device for the reconnect.  The fix is to add the device to the
lists earlier.

James

===== drivers/scsi/scsi_sysfs.c 1.69 vs edited =====
--- 1.69/drivers/scsi/scsi_sysfs.c	2005-02-16 19:05:37 -06:00
+++ edited/drivers/scsi/scsi_sysfs.c	2005-03-19 12:56:31 -06:00
@@ -561,15 +561,7 @@
  **/
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
-	struct Scsi_Host *shost = sdev->host;
-	struct scsi_target *starget = scsi_target(sdev);
 	int error, i;
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	list_add_tail(&sdev->same_target_siblings, &starget->devices);
-	list_add_tail(&sdev->siblings, &shost->__devices);
-	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
 		return error;
@@ -786,6 +778,10 @@
 
 void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 {
+	unsigned long flags;
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_target  *starget = sdev->sdev_target;
+
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.release = scsi_device_dev_release;
@@ -801,6 +797,10 @@
 		 sdev->channel, sdev->id, sdev->lun);
 	sdev->scsi_level = SCSI_2;
 	transport_setup_device(&sdev->sdev_gendev);
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_add_tail(&sdev->same_target_siblings, &starget->devices);
+	list_add_tail(&sdev->siblings, &shost->__devices);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 int scsi_is_sdev_device(const struct device *dev)


