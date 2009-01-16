From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libsas: User mode app failed to send ioctl commands to
 SATA drive.
Date: Fri, 16 Jan 2009 07:20:10 -0500
Message-ID: <49707B7A.90100@garzik.org>
References: <496B1B31.4050606@marvell.com> <1231774426.3256.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090505030609080508060701"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45807 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109AbZAPMUR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 07:20:17 -0500
In-Reply-To: <1231774426.3256.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: kewei@marvell.com, linux-scsi@vger.kernel.org, djwong@us.ibm.com, Jason Chu <jasonchu@marvell.com>, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>

This is a multi-part message in MIME format.
--------------090505030609080508060701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> On Mon, 2009-01-12 at 18:28 +0800, Ke Wei wrote:
>> The context of scsi_host's hostdata points to a sas ha structure with libsas
>> module, but the libata casts this pointer to a ata_port structure when ioctl
>> sends HDIO_GET_IDENTITY.
> 
> This is a good find thanks.  I think there's a small problem in the way
> the layering is done.
> 
> I think ata_scsi_ioctl needs to be expanded to pass the port in all the
> time.   That way other implementors don't have to remember to special
> case HDIO_GET_IDENTITY.
> 
> When you redo this, ipr will need altering as well (rather than also
> having the identity exception added).

The attached appears to be what is needed.  We cannot change 
ata_scsi_ioctl() because every libata driver uses that function directly 
in its SCSI template as the driver's ioctl hook.

Ack, and I'll apply?

	Jeff




--------------090505030609080508060701
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 71218d7..552ecae 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6638,7 +6638,6 @@ EXPORT_SYMBOL_GPL(ata_dev_pair);
 EXPORT_SYMBOL_GPL(ata_port_disable);
 EXPORT_SYMBOL_GPL(ata_ratelimit);
 EXPORT_SYMBOL_GPL(ata_wait_register);
-EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_destroy);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9e92107..fbc2953 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -423,9 +423,9 @@ int ata_std_bios_param(struct scsi_device *sdev, struct block_device *bdev,
  *	RETURNS:
  *	Zero on success, negative errno on error.
  */
-static int ata_get_identity(struct scsi_device *sdev, void __user *arg)
+static int ata_get_identity(struct ata_port *ap, struct scsi_device *sdev,
+			    void __user *arg)
 {
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
 	u16 __user *dst = arg;
 	char buf[40];
@@ -645,7 +645,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	return rc;
 }
 
-int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
+int __ata_scsi_ioctl(struct ata_port *ap, struct scsi_device *scsidev,
+		     int cmd, void __user *arg)
 {
 	int val = -EINVAL, rc = -EINVAL;
 
@@ -663,7 +664,7 @@ int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
 		return 0;
 
 	case HDIO_GET_IDENTITY:
-		return ata_get_identity(scsidev, arg);
+		return ata_get_identity(ap, scsidev, arg);
 
 	case HDIO_DRIVE_CMD:
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
@@ -682,6 +683,14 @@ int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(__ata_scsi_ioctl);
+
+int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
+{
+	return __ata_scsi_ioctl(ata_shost_to_port(scsidev->host),
+				scsidev, cmd, arg);
+}
+EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 
 /**
  *	ata_scsi_qc_new - acquire new ata_queued_cmd reference
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 841f460..464e566 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4912,7 +4912,7 @@ static int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	if (res && ipr_is_gata(res)) {
 		if (cmd == HDIO_GET_IDENTITY)
 			return -ENOTTY;
-		return ata_scsi_ioctl(sdev, cmd, arg);
+		return __ata_scsi_ioctl(res->sata_port->ap, sdev, cmd, arg);
 	}
 
 	return -EINVAL;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 7448387..93aa393 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -717,7 +717,7 @@ int sas_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
 
 	if (dev_is_sata(dev))
-		return ata_scsi_ioctl(sdev, cmd, arg);
+		return __ata_scsi_ioctl(dev->sata_dev.ap, sdev, cmd, arg);
 
 	return -EINVAL;
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b6b8a7f..fb3e5f6 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -926,6 +926,8 @@ extern void ata_host_init(struct ata_host *, struct device *,
 			  unsigned long, struct ata_port_operations *);
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
+extern int __ata_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
+			    int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,

--------------090505030609080508060701--
