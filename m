From: Ke Wei <kewei@marvell.com>
Subject: [PATCH] libsas: User mode app failed to send ioctl commands to SATA
 drive.
Date: Mon, 12 Jan 2009 18:28:01 +0800
Message-ID: <496B1B31.4050606@marvell.com>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:38559 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751517AbZALK2G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 05:28:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jeff@garzik.org>, djwong@us.ibm.com, Jason Chu <jasonchu@marvell.com>, Michael

The context of scsi_host's hostdata points to a sas ha structure with libsas
module, but the libata casts this pointer to a ata_port structure when ioctl
sends HDIO_GET_IDENTITY.

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9e92107..e6acc55 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -412,20 +412,9 @@ int ata_std_bios_param(struct scsi_device *sdev, struct
block_device *bdev,
 	return 0;
 }

-/**
- *	ata_get_identity - Handler for HDIO_GET_IDENTITY ioctl
- *	@sdev: SCSI device to get identify data for
- *	@arg: User buffer area for identify data
- *
- *	LOCKING:
- *	Defined by the SCSI layer.  We don't really care.
- *
- *	RETURNS:
- *	Zero on success, negative errno on error.
- */
-static int ata_get_identity(struct scsi_device *sdev, void __user *arg)
+static int __ata_get_identity(struct scsi_device *sdev,
+			struct ata_port *ap, void __user *arg)
 {
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
 	u16 __user *dst = arg;
 	char buf[40];
@@ -452,6 +441,23 @@ static int ata_get_identity(struct scsi_device *sdev, void
__user *arg)
 }

 /**
+ *	ata_get_identity - Handler for HDIO_GET_IDENTITY ioctl
+ *	@sdev: SCSI device to get identify data for
+ *	@arg: User buffer area for identify data
+ *
+ *	LOCKING:
+ *	Defined by the SCSI layer.  We don't really care.
+ *
+ *	RETURNS:
+ *	Zero on success, negative errno on error.
+ */
+static int ata_get_identity(struct scsi_device *sdev, void __user *arg)
+{
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	return __ata_get_identity(sdev, ap, arg);
+}
+
+/**
  *	ata_cmd_ioctl - Handler for HDIO_DRIVE_CMD ioctl
  *	@scsidev: Device to which we are issuing command
  *	@arg: User provided data for issuing command
@@ -3714,3 +3720,10 @@ int ata_sas_queuecmd(struct scsi_cmnd *cmd, void
(*done)(struct scsi_cmnd *),
 	return rc;
 }
 EXPORT_SYMBOL_GPL(ata_sas_queuecmd);
+
+int ata_sas_get_identity(struct scsi_device *scsidev,
+			struct ata_port *ap, void __user *arg)
+{
+	return __ata_get_identity(scsidev, ap, arg);
+}
+EXPORT_SYMBOL_GPL(ata_sas_get_identity);

diff --git a/drivers/scsi/libsas/sas_scsi_host.c
b/drivers/scsi/libsas/sas_scsi_host.c
index 7448387..30c419c 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -46,6 +46,7 @@
 #include <linux/freezer.h>
 #include <linux/scatterlist.h>
 #include <linux/libata.h>
+#include <linux/hdreg.h>

 /* ---------- SCSI Host glue ---------- */

@@ -716,8 +717,13 @@ int sas_ioctl(struct scsi_device *sdev, int cmd, void
__user *arg)
 {
 	struct domain_device *dev = sdev_to_domain_dev(sdev);

-	if (dev_is_sata(dev))
-		return ata_scsi_ioctl(sdev, cmd, arg);
+	if (dev_is_sata(dev)) {
+		if (cmd == HDIO_GET_IDENTITY)
+			return ata_sas_get_identity(sdev, dev->sata_dev.ap,
+						arg);
+		else
+			return ata_scsi_ioctl(sdev, cmd, arg);
+	}

 	return -EINVAL;
 }

diff --git a/include/linux/libata.h b/include/linux/libata.h
index b6b8a7f..8c1c5e1 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -936,6 +936,8 @@ extern void ata_sas_port_stop(struct ata_port *ap);
 extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
 extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct
scsi_cmnd *),
 			    struct ata_port *ap);
+extern int ata_sas_get_identity(struct scsi_device *scsidev,
+			struct ata_port *ap, void __user *arg);
 extern int sata_scr_valid(struct ata_link *link);
 extern int sata_scr_read(struct ata_link *link, int reg, u32 *val);
 extern int sata_scr_write(struct ata_link *link, int reg, u32 val);



