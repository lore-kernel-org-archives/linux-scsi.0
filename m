From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 6/11] Rename __scsi_remove_device() into
 scsi_sysfs_remove_sdev()
Date: Mon, 18 Jun 2007 11:01:54 +0200
Message-ID: <20070618090154.D0601D44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:34339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715AbXFRJBz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 05:01:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


__scsi_remove_device() is actually the counterpart to
scsi_sysfs_add_sdev(). So we'd better rename it to avoid
confusion.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_priv.h  |    2 +-
 drivers/scsi/scsi_scan.c  |    4 ++--
 drivers/scsi/scsi_sysfs.c |   10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index ee8efe8..642f777 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -114,7 +114,7 @@ extern void scsi_sysfs_unregister(void);
 extern void scsi_sysfs_device_initialize(struct scsi_device *);
 extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
-extern void __scsi_remove_device(struct scsi_device *);
+extern void scsi_sysfs_remove_sdev(struct scsi_device *);
 
 extern struct bus_type scsi_bus_type;
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a367423..9195ffb 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1099,7 +1099,7 @@ static int scsi_probe_and_add_lun(struct
 			if (scsi_device_get(sdev) == 0) {
 				*sdevp = sdev;
 			} else {
-				__scsi_remove_device(sdev);
+				scsi_sysfs_remove_sdev(sdev);
 				scsi_destroy_device(sdev);
 				res = SCSI_SCAN_NO_RESPONSE;
 			}
@@ -1815,7 +1815,7 @@ void scsi_forget_host(struct Scsi_Host *
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		__scsi_remove_device(sdev);
+		scsi_sysfs_remove_sdev(sdev);
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index de66b08..0e11fa3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -747,7 +747,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 			error = attr_add(&sdev->sdev_gendev,
 					sdev->host->hostt->sdev_attrs[i]);
 			if (error) {
-				__scsi_remove_device(sdev);
+				scsi_sysfs_remove_sdev(sdev);
 				scsi_destroy_device(sdev);
 				goto out;
 			}
@@ -762,7 +762,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 							scsi_sysfs_sdev_attrs[i]);
 			error = device_create_file(&sdev->sdev_gendev, attr);
 			if (error) {
-				__scsi_remove_device(sdev);
+				scsi_sysfs_remove_sdev(sdev);
 				scsi_destroy_device(sdev);
 				goto out;
 			}
@@ -774,7 +774,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	return error;
 }
 
-void __scsi_remove_device(struct scsi_device *sdev)
+void scsi_sysfs_remove_sdev(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
 
@@ -783,7 +783,7 @@ void __scsi_remove_device(struct scsi_de
 
 	class_device_del(&sdev->sdev_classdev);
 	/* Release the refcount hold for the classdev */
-	put_device(&sdev->sdev_gendev);
+	put_device(dev);
 	transport_remove_device(dev);
 	device_del(dev);
 }
@@ -797,7 +797,7 @@ void scsi_remove_device(struct scsi_devi
 	struct Scsi_Host *shost = sdev->host;
 
 	mutex_lock(&shost->scan_mutex);
-	__scsi_remove_device(sdev);
+	scsi_sysfs_remove_sdev(sdev);
 	scsi_destroy_device(sdev);
 	mutex_unlock(&shost->scan_mutex);
 }
-- 
1.4.3.4

