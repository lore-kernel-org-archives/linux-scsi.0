From: Matthew Wilcox <matthew@wil.cx>
Subject: [RFC] libata support for async scanning
Date: Fri, 12 May 2006 23:05:29 -0600
Message-ID: <20060513050529.GS12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52709 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932338AbWEMFF3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 May 2006 01:05:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I don't think SATA target scanning occupies a huge amount of boot time,
however it will currently force all async scanners to complete before it
scans.  The Rolls-Royce solution would be somethinkg akin to the new
scsi_scan_host(), but I don't think that's necessaary.  This patch just
acknowledges that async scanning exists and will permit the drive
additions to finish some time after libata has triggered the probe.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: ./drivers/scsi/libata-scsi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/libata-scsi.c,v
retrieving revision 1.38
diff -u -p -r1.38 libata-scsi.c
--- ./drivers/scsi/libata-scsi.c	19 Apr 2006 04:55:59 -0000	1.38
+++ ./drivers/scsi/libata-scsi.c	13 May 2006 04:56:30 -0000
@@ -2733,16 +2733,19 @@ void ata_scsi_simulate(struct ata_port *
 void ata_scsi_scan_host(struct ata_port *ap)
 {
 	struct ata_device *dev;
+	struct async_scan_data *data;
 	unsigned int i;
 
 	if (ap->flags & ATA_FLAG_PORT_DISABLED)
 		return;
 
+	data = scsi_prep_async_scan(ap->host);
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		dev = &ap->device[i];
 
 		if (ata_dev_present(dev))
 			scsi_scan_target(&ap->host->shost_gendev, 0, i, 0, 0);
 	}
+	scsi_finish_async_scan(data);
 }
 
