From: Jeff Garzik <jgarzik@pobox.com>
Subject: [patch 1/6] SCSI HCIL: s/scsi_scan_target/spi_scan_target/
Date: Sat, 22 Oct 2005 21:37:30 -0400
Message-ID: <20051023013730.GA18279@havoc.gtf.org>
References: <20051023013618.GA18201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:30430 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751343AbVJWBha (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 21:37:30 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 72E281C095FB
	for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2005 21:37:30 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9N1bUoM018314
	for linux-scsi@vger.kernel.org; Sat, 22 Oct 2005 21:37:30 -0400
Content-Disposition: inline
In-Reply-To: <20051023013618.GA18201@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Jeff Garzik <jgarzik@pobox.com>


7c3609190a89e051779a50f1b139eeb0856d7c0b
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 327c5d7..db98b54 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1306,7 +1306,7 @@ void scsi_rescan_device(struct device *d
 }
 EXPORT_SYMBOL(scsi_rescan_device);
 
-static void __scsi_scan_target(struct device *parent, unsigned int channel,
+static void __spi_scan_target(struct device *parent, unsigned int channel,
 		unsigned int id, unsigned int lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
@@ -1357,7 +1357,7 @@ static void __scsi_scan_target(struct de
 }
 
 /**
- * scsi_scan_target - scan a target id, possibly including all LUNs on the
+ * spi_scan_target - scan a target id, possibly including all LUNs on the
  *     target.
  * @parent:	host to scan
  * @channel:	channel to scan
@@ -1372,17 +1372,17 @@ static void __scsi_scan_target(struct de
  *     First try a REPORT LUN scan, if that does not scan the target, do a
  *     sequential scan of LUNs on the target id.
  **/
-void scsi_scan_target(struct device *parent, unsigned int channel,
+void spi_scan_target(struct device *parent, unsigned int channel,
 		      unsigned int id, unsigned int lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 
 	down(&shost->scan_mutex);
 	if (scsi_host_scan_allowed(shost))
-		__scsi_scan_target(parent, channel, id, lun, rescan);
+		__spi_scan_target(parent, channel, id, lun, rescan);
 	up(&shost->scan_mutex);
 }
-EXPORT_SYMBOL(scsi_scan_target);
+EXPORT_SYMBOL(spi_scan_target);
 
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, unsigned int lun, int rescan)
@@ -1407,11 +1407,11 @@ static void scsi_scan_channel(struct Scs
 				order_id = shost->max_id - id - 1;
 			else
 				order_id = id;
-			__scsi_scan_target(&shost->shost_gendev, channel,
+			__spi_scan_target(&shost->shost_gendev, channel,
 					order_id, lun, rescan);
 		}
 	else
-		__scsi_scan_target(&shost->shost_gendev, channel,
+		__spi_scan_target(&shost->shost_gendev, channel,
 				id, lun, rescan);
 }
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2cab556..91d23e9 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1673,7 +1673,7 @@ fc_scsi_scan_rport(void *data)
 {
 	struct fc_rport *rport = (struct fc_rport *)data;
 
-	scsi_scan_target(&rport->dev, rport->channel, rport->scsi_target_id,
+	spi_scan_target(&rport->dev, rport->channel, rport->scsi_target_id,
 			SCAN_WILD_CARD, 1);
 }
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1d145d2..f6c1a96 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -578,7 +578,7 @@ int sas_rphy_add(struct sas_rphy *rphy)
 	spin_unlock(&sas_host->lock);
 
 	if (rphy->scsi_target_id != -1) {
-		scsi_scan_target(&rphy->dev, parent->number,
+		spi_scan_target(&rphy->dev, parent->number,
 				rphy->scsi_target_id, ~0, 0);
 	}
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7ece056..814a7d8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -248,8 +248,8 @@ extern int scsi_device_quiesce(struct sc
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
-extern void scsi_scan_target(struct device *parent, unsigned int channel,
-			     unsigned int id, unsigned int lun, int rescan);
+extern void spi_scan_target(struct device *parent, unsigned int channel,
+			    unsigned int id, unsigned int lun, int rescan);
 extern void scsi_target_reap(struct scsi_target *);
 extern void scsi_target_block(struct device *);
 extern void scsi_target_unblock(struct device *);
