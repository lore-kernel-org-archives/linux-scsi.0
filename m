From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] allow a transport to pre-initialize starget_data
Date: Mon, 15 Aug 2005 15:42:10 +0200
Message-ID: <20050815134210.GA19426@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:63952 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932534AbVHONmN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 09:42:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Add a new void *transport_data argument to scsi_scan_target so that a
transport-class can fill in known information before actually scanning
the target.  This is needed by the upcoming SAS transport class patch.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_scan.c	2005-08-13 13:53:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_scan.c	2005-08-15 15:32:57.000000000 +0200
@@ -329,7 +329,8 @@
 }
 
 static struct scsi_target *scsi_alloc_target(struct device *parent,
-					     int channel, uint id)
+					     int channel, uint id,
+					     void *transport_data)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct device *dev = NULL;
@@ -344,6 +345,12 @@
 		return NULL;
 	}
 	memset(starget, 0, size);
+
+	if (transport_data) {
+		memcpy((char *)starget->starget_data, transport_data,
+				shost->transportt->target_size);
+	}
+
 	dev = &starget->dev;
 	device_initialize(dev);
 	starget->reap_ref = 1;
@@ -1244,8 +1251,9 @@
 	struct scsi_device *sdev;
 	struct device *parent = &shost->shost_gendev;
 	int res;
-	struct scsi_target *starget = scsi_alloc_target(parent, channel, id);
+	struct scsi_target *starget;
 
+	starget = scsi_alloc_target(parent, channel, id, NULL);
 	if (!starget)
 		return ERR_PTR(-ENOMEM);
 
@@ -1301,7 +1309,8 @@
  *     sequential scan of LUNs on the target id.
  **/
 void scsi_scan_target(struct device *parent, unsigned int channel,
-		      unsigned int id, unsigned int lun, int rescan)
+		      unsigned int id, unsigned int lun, int rescan,
+		      void *transport_data)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
@@ -1316,8 +1325,7 @@
 		return;
 
 
-	starget = scsi_alloc_target(parent, channel, id);
-
+	starget = scsi_alloc_target(parent, channel, id, transport_data);
 	if (!starget)
 		return;
 
@@ -1388,10 +1396,12 @@
 				order_id = shost->max_id - id - 1;
 			else
 				order_id = id;
-			scsi_scan_target(&shost->shost_gendev, channel, order_id, lun, rescan);
+			scsi_scan_target(&shost->shost_gendev, channel,
+					 order_id, lun, rescan, NULL);
 		}
 	else
-		scsi_scan_target(&shost->shost_gendev, channel, id, lun, rescan);
+		scsi_scan_target(&shost->shost_gendev, channel,
+				 id, lun, rescan, NULL);
 }
 
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
@@ -1492,7 +1502,8 @@
 	struct scsi_device *sdev;
 	struct scsi_target *starget;
 
-	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
+	starget = scsi_alloc_target(&shost->shost_gendev, 0,
+				    shost->this_id, NULL);
 	if (!starget)
 		return NULL;
 
Index: scsi-misc-2.6/drivers/scsi/scsi_transport_fc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_transport_fc.c	2005-08-13 13:53:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_transport_fc.c	2005-08-15 15:32:42.000000000 +0200
@@ -1653,7 +1653,7 @@
 	struct fc_rport *rport = (struct fc_rport *)data;
 
 	scsi_scan_target(&rport->dev, rport->channel, rport->scsi_target_id,
-			SCAN_WILD_CARD, 1);
+			SCAN_WILD_CARD, 1, NULL);
 }
 
 
Index: scsi-misc-2.6/include/scsi/scsi_device.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_device.h	2005-08-13 13:54:07.000000000 +0200
+++ scsi-misc-2.6/include/scsi/scsi_device.h	2005-08-15 15:32:42.000000000 +0200
@@ -238,7 +238,8 @@
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
 extern void scsi_scan_target(struct device *parent, unsigned int channel,
-			     unsigned int id, unsigned int lun, int rescan);
+			     unsigned int id, unsigned int lun, int rescan,
+			     void *transport_data);
 extern void scsi_target_reap(struct scsi_target *);
 extern void scsi_target_block(struct device *);
 extern void scsi_target_unblock(struct device *);
