From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add ability to deny binding to SPI transport class
Date: Sun, 14 Aug 2005 14:34:06 -0500
Message-ID: <1124048047.18802.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:28611 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751060AbVHNTeT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2005 15:34:19 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j7EJY8A05124
	for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2005 15:34:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This patch is necessary if we begin exposing underlying physical disks
(which can attach to the SPI transport class) of the hardware RAID
cards, since we don't want any SPI parameters binding to the raid
devices.

James

--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1068,6 +1072,7 @@ static int spi_device_match(struct attri
 {
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost;
+	struct spi_internal *i;
 
 	if (!scsi_is_sdev_device(dev))
 		return 0;
@@ -1080,6 +1085,9 @@ static int spi_device_match(struct attri
 	/* Note: this class has no device attributes, so it has
 	 * no per-HBA allocation and thus we don't need to distinguish
 	 * the attribute containers for the device */
+	i = to_spi_internal(shost->transportt);
+	if (i->f->deny_binding && i->f->deny_binding(sdev->sdev_target))
+		return 0;
 	return 1;
 }
 
@@ -1087,6 +1095,7 @@ static int spi_target_match(struct attri
 			    struct device *dev)
 {
 	struct Scsi_Host *shost;
+	struct scsi_target *starget;
 	struct spi_internal *i;
 
 	if (!scsi_is_target_device(dev))
@@ -1098,7 +1107,11 @@ static int spi_target_match(struct attri
 		return 0;
 
 	i = to_spi_internal(shost->transportt);
-	
+	starget = to_scsi_target(dev);
+
+	if (i->f->deny_binding && i->f->deny_binding(starget))
+		return 0;
+
 	return &i->t.target_attrs.ac == cont;
 }
 
diff --git a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
--- a/include/scsi/scsi_transport_spi.h
+++ b/include/scsi/scsi_transport_spi.h
@@ -120,6 +120,7 @@ struct spi_function_template {
 	void	(*set_hold_mcs)(struct scsi_target *, int);
 	void	(*get_signalling)(struct Scsi_Host *);
 	void	(*set_signalling)(struct Scsi_Host *, enum spi_signal_type);
+	int	(*deny_binding)(struct scsi_target *);
 	/* The driver sets these to tell the transport class it
 	 * wants the attributes displayed in sysfs.  If the show_ flag
 	 * is not set, the attribute will be private to the transport


