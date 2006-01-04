From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] sas: fix removal of devices behind expanders
Date: Wed, 4 Jan 2006 13:45:20 +0100
Message-ID: <20060104124520.GA30070@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:15056 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751650AbWADMpc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 07:45:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

We need to iterate over all children when removing and expander, else
stale objects will be around after host removal.  This fixes the oops
Eric Moore saw when removing and reloading mptsas.

Also don't try the scsi_remove_target call unless operating on an end
device.  The current unconditional call is harmless but confusing.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_transport_sas.c	2006-01-04 13:35:46.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c	2006-01-04 13:40:22.000000000 +0100
@@ -687,7 +687,17 @@
 	struct Scsi_Host *shost = dev_to_shost(parent->dev.parent);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 
-	scsi_remove_target(dev);
+	switch (rphy->identify.device_type) {
+	case SAS_END_DEVICE:
+		scsi_remove_target(dev);
+		break;
+	case SAS_EDGE_EXPANDER_DEVICE:
+	case SAS_FANOUT_EXPANDER_DEVICE:
+		device_for_each_child(dev, NULL, do_sas_phy_delete);
+		break;
+	default:
+		break;
+	}
 
 	transport_remove_device(dev);
 	device_del(dev);
