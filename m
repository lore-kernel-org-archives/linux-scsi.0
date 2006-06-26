From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] scsi midlayer: fix sdev reuse after free
Date: Mon, 26 Jun 2006 14:53:47 -0400
Message-ID: <1151348028.5883.16.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:31975 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932644AbWFZSxn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 14:53:43 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k5QIrgxq012685
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2006 11:53:42 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The conversion to execute_in_process_context() highlighted a use-after-free
race condition. Although the sdev was torn down, it remained in the linked
lists looked at by scan, and allowed scan to reuse the sdev.

This patch removes the sdev from the lists at the point it tears down the
sdev.

-- james s

Signed-off-by: James Smart <james.smart@emulex.com>

diff -upNr a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	2006-06-14 11:37:09.000000000 -0400
+++ b/drivers/scsi/scsi_sysfs.c	2006-06-26 14:48:31.000000000 -0400
@@ -231,8 +231,6 @@ static void scsi_device_dev_release_user
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
 	starget->reap_ref++;
-	list_del(&sdev->siblings);
-	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
@@ -735,10 +733,15 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	unsigned long flags;
 
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
 
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	list_del(&sdev->siblings);
+	list_del(&sdev->same_target_siblings);
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 	class_device_unregister(&sdev->sdev_classdev);
 	transport_remove_device(dev);
 	device_del(dev);


