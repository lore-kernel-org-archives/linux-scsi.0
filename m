From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] sas: fix remote phy removal
Date: Sun, 25 Sep 2005 23:10:33 +0200
Message-ID: <20050925211033.GA13128@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:11233 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932298AbVIYVKm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Sep 2005 17:10:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Brown paperback bug:  sas_rphy_delete was ordered completely
wrong.  Fix it up to be the same order as sas_phy_delete or
fc_rport_terminate and fix rphy objects that leaked after module
removal.

This patch should go to Linus for 2.6.13


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_sas.c	2005-09-25 15:10:14.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_transport_sas.c	2005-09-25 15:59:51.000000000 +0200
@@ -652,17 +652,16 @@
 	struct Scsi_Host *shost = dev_to_shost(parent->dev.parent);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 
-	transport_destroy_device(&rphy->dev);
+	scsi_remove_target(dev);
 
-	scsi_remove_target(&rphy->dev);
+	transport_remove_device(dev);
+	device_del(dev);
+	transport_destroy_device(dev);
 
 	spin_lock(&sas_host->lock);
 	list_del(&rphy->list);
 	spin_unlock(&sas_host->lock);
 
-	transport_remove_device(dev);
-	device_del(dev);
-	transport_destroy_device(dev);
 	put_device(&parent->dev);
 }
 EXPORT_SYMBOL(sas_rphy_delete);
