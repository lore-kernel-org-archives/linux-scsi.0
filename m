From: Brian King <brking@us.ibm.com>
Subject: [PATCH 05/16] libata: Add __ata_scsi_ioctl
Date: Fri, 17 Feb 2006 16:20:09 -0600
Message-ID: <200602172220.k1HMKAOs003203@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:30166 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751828AbWBQWUR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 17:20:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


In preparation for SAS, export a new interface that SAS LLDDs can
call to handle libata ioctls. The existing interface in insufficient
for this purpose since it assumes it owns the scsi_host struct.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-scsi.c |   36 ++++++++++++++++----------
 libata-dev-bjking1/include/linux/libata.h     |    1 
 2 files changed, 24 insertions(+), 13 deletions(-)

diff -puN drivers/scsi/libata-scsi.c~libata_scsi_ioctl drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_scsi_ioctl	2006-02-17 15:53:37.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-02-17 15:53:37.000000000 -0600
@@ -255,22 +255,10 @@ int ata_task_ioctl(struct scsi_device *s
 	return rc;
 }
 
-int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
+int __ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
 {
-	struct ata_port *ap;
-	struct ata_device *dev;
 	int val = -EINVAL, rc = -EINVAL;
 
-	ap = (struct ata_port *) &scsidev->host->hostdata[0];
-	if (!ap)
-		goto out;
-
-	dev = ata_scsi_find_dev(ap, scsidev);
-	if (!dev) {
-		rc = -ENODEV;
-		goto out;
-	}
-
 	switch (cmd) {
 	case ATA_IOC_GET_IO32:
 		val = 0;
@@ -299,6 +287,28 @@ int ata_scsi_ioctl(struct scsi_device *s
 		break;
 	}
 
+	return rc;
+}
+EXPORT_SYMBOL_GPL(__ata_scsi_ioctl);
+
+int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
+{
+	struct ata_port *ap;
+	struct ata_device *dev;
+	int rc = -EINVAL;
+
+	ap = (struct ata_port *) &scsidev->host->hostdata[0];
+	if (!ap)
+		goto out;
+
+	dev = ata_scsi_find_dev(ap, scsidev);
+	if (!dev) {
+		rc = -ENODEV;
+		goto out;
+	}
+
+	rc = __ata_scsi_ioctl(scsidev, cmd, arg);
+
 out:
 	return rc;
 }
diff -puN include/linux/libata.h~libata_scsi_ioctl include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_scsi_ioctl	2006-02-17 15:53:37.000000000 -0600
+++ libata-dev-bjking1/include/linux/libata.h	2006-02-17 15:53:37.000000000 -0600
@@ -498,6 +498,7 @@ extern int ata_device_add(const struct a
 extern void ata_host_set_remove(struct ata_host_set *host_set);
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
+extern int __ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
 extern enum scsi_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 extern int ata_scsi_error(struct Scsi_Host *host);
_
