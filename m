From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] libata: improve device scan
Date: Mon, 03 Oct 2005 15:45:24 -0400
Message-ID: <43418A54.8080709@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090501050800040601080002"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:38814 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932393AbVJCTpa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2005 15:45:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

This is a multi-part message in MIME format.
--------------090501050800040601080002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


The attached patch changes libata device scanning from using the legacy 
"bang at the door" method of probing devices, to one that calls 
scsi_scan_target() for each target (ATA device) that the libata 
transport layer found.

Completely untested, feedback welcome.  This should improve the speed of 
SATA probing a tad, and certainly makes it quite a bit less ugly.

This might get moved, eventually, into an ATA transport class, depending 
on how things shape up in the future.

	Jeff




--------------090501050800040601080002
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/scsi/libata-core.c b/drivers/scsi/libata-core.c
--- a/drivers/scsi/libata-core.c
+++ b/drivers/scsi/libata-core.c
@@ -4113,7 +4113,7 @@ int ata_device_add(struct ata_probe_ent 
 	for (i = 0; i < count; i++) {
 		struct ata_port *ap = host_set->ports[i];
 
-		scsi_scan_host(ap->host);
+		ata_scsi_scan_host(ap);
 	}
 
 	dev_set_drvdata(dev, host_set);
diff --git a/drivers/scsi/libata-scsi.c b/drivers/scsi/libata-scsi.c
--- a/drivers/scsi/libata-scsi.c
+++ b/drivers/scsi/libata-scsi.c
@@ -1678,3 +1678,15 @@ void ata_scsi_simulate(u16 *id,
 	}
 }
 
+void ata_scsi_scan_host(struct ata_port *ap)
+{
+	unsigned int i;
+
+	if (ap->flags & ATA_FLAG_PORT_DISABLED)
+		return;
+
+	for (i = 0; i < ATA_MAX_DEVICES; i++)
+		if (ata_dev_present(&ap->device[i]))
+			scsi_scan_target(&ap->host->shost_gendev, 0, i, ~0, 0);
+}
+
diff --git a/drivers/scsi/libata.h b/drivers/scsi/libata.h
--- a/drivers/scsi/libata.h
+++ b/drivers/scsi/libata.h
@@ -51,6 +51,7 @@ extern void swap_buf_le16(u16 *buf, unsi
 
 
 /* libata-scsi.c */
+extern void ata_scsi_scan_host(struct ata_port *ap);
 extern void ata_to_sense_error(struct ata_queued_cmd *qc, u8 drv_stat);
 extern int ata_scsi_error(struct Scsi_Host *host);
 extern unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,

--------------090501050800040601080002--
