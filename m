From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] correct module refcounting
Date: 28 Oct 2003 15:46:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067377564.1788.39.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:33540 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261750AbTJ1VqF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 16:46:05 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>

There's a race window between doing the last scsi_device_put and having
the devices actually released where the module may be unloaded.  The fix
is to move the module accounting into the
scsi_allocate_sdev/scsi_free_sdev pieces of the SCSI routines.

I also think we probably want to move sdev_gendev population into
scsi_allocate_sdev.  Note this will change how we do initial scans
because now we'll be using the generic device release infrastructure to
free even temporary devices.  Unless anyone has a better idea...?

Finally, when this is done, we can take a device reference over both
scsi_get_command/scsi_put_command and also within the scsi_request_fn so
we know the device can never be released while it has outstanding
commands or while we are running its queues.

James

===== drivers/scsi/scsi.c 1.130 vs edited =====
--- 1.130/drivers/scsi/scsi.c	Mon Oct 27 06:01:49 2003
+++ edited/drivers/scsi/scsi.c	Tue Oct 28 15:39:10 2003
@@ -897,10 +897,6 @@
 		return -ENXIO;
 	if (!get_device(&sdev->sdev_gendev))
 		return -ENXIO;
-	if (!try_module_get(sdev->host->hostt->module)) {
-		put_device(&sdev->sdev_gendev);
-		return -ENXIO;
-	}
 	return 0;
 }
 EXPORT_SYMBOL(scsi_device_get);
@@ -915,7 +911,6 @@
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	module_put(sdev->host->hostt->module);
 	put_device(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_device_put);
===== drivers/scsi/scsi_scan.c 1.110 vs edited =====
--- 1.110/drivers/scsi/scsi_scan.c	Mon Oct 27 06:01:50 2003
+++ edited/drivers/scsi/scsi_scan.c	Tue Oct 28 15:39:00 2003
@@ -192,6 +192,9 @@
 	struct scsi_device *sdev, *device;
 	unsigned long flags;
 
+	if (!try_module_get(sdev->host->hostt->module))
+		goto out;
+
 	sdev = kmalloc(sizeof(*sdev), GFP_ATOMIC);
 	if (!sdev)
 		goto out;
@@ -299,6 +302,7 @@
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	kfree(sdev->inquiry);
+	module_put(sdev->host->hostt->module);
 	kfree(sdev);
 }
 



