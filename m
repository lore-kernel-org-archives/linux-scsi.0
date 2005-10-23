From: Jeff Garzik <jgarzik@pobox.com>
Subject: [patch 4/6] SCSI HCIL: kill all uses of spi_scan_target()
Date: Sat, 22 Oct 2005 21:40:12 -0400
Message-ID: <20051023014012.GD18279@havoc.gtf.org>
References: <20051023013618.GA18201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33246 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751376AbVJWBkM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 21:40:12 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 825AD1C095FB
	for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2005 21:40:12 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9N1eCcG018406
	for linux-scsi@vger.kernel.org; Sat, 22 Oct 2005 21:40:12 -0400
Content-Disposition: inline
In-Reply-To: <20051023013618.GA18201@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Allocate a target at each callsite, then call scsi_scan_target()

Also, minor stuff:

- export scsi_alloc_target().  eventually this will wind up
  renamed to spi_alloc_target(), and become a wrapper around
  scsi_alloc_target().

- s/scsi_scan_channel/spi_scan_channel/

Signed-off-by: Jeff Garzik <jgarzik@pobox.com>


d35ab3386289899854cb66f877acca185eb83392
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 92fc94b..a48d958 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -326,8 +326,8 @@ static struct scsi_target *__scsi_find_t
 	return found_starget;
 }
 
-static struct scsi_target *scsi_alloc_target(struct device *parent,
-					     int channel, uint id)
+struct scsi_target *scsi_alloc_target(struct device *parent,
+				      int channel, uint id)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct device *dev = NULL;
@@ -402,6 +402,7 @@ static struct scsi_target *scsi_alloc_ta
 	kfree(starget);
 	return found_target;
 }
+EXPORT_SYMBOL(scsi_alloc_target);
 
 /**
  * scsi_target_reap - check to see if target is in use and destroy if not
@@ -1414,10 +1415,11 @@ void scsi_scan_target(struct scsi_target
 }
 EXPORT_SYMBOL(scsi_scan_target);
 
-static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
-			      unsigned int id, unsigned int lun, int rescan)
+static void spi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
+			     unsigned int id, unsigned int lun, int rescan)
 {
 	uint order_id;
+	struct scsi_target *starget;
 
 	if (id == SCAN_WILD_CARD)
 		for (id = 0; id < shost->max_id; ++id) {
@@ -1437,12 +1439,23 @@ static void scsi_scan_channel(struct Scs
 				order_id = shost->max_id - id - 1;
 			else
 				order_id = id;
-			__spi_scan_target(&shost->shost_gendev, channel,
-					order_id, lun, rescan);
+
+			if (shost->this_id == order_id)
+				/*
+				 * Don't scan the host adapter
+				 */
+				continue;
+
+			starget = scsi_alloc_target(&shost->shost_gendev,
+						    channel, order_id);
+			if (starget)
+				__scsi_scan_target(starget, lun, rescan);
 		}
-	else
-		__spi_scan_target(&shost->shost_gendev, channel,
-				id, lun, rescan);
+	else {
+		starget = scsi_alloc_target(&shost->shost_gendev, channel, id);
+		if (starget)
+			__scsi_scan_target(starget, lun, rescan);
+	}
 }
 
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
@@ -1461,10 +1474,10 @@ int scsi_scan_host_selected(struct Scsi_
 		if (channel == SCAN_WILD_CARD)
 			for (channel = 0; channel <= shost->max_channel;
 			     channel++)
-				scsi_scan_channel(shost, channel, id, lun,
+				spi_scan_channel(shost, channel, id, lun,
 						  rescan);
 		else
-			scsi_scan_channel(shost, channel, id, lun, rescan);
+			spi_scan_channel(shost, channel, id, lun, rescan);
 	}
 	up(&shost->scan_mutex);
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 91d23e9..f7ae486 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1672,9 +1672,12 @@ static void
 fc_scsi_scan_rport(void *data)
 {
 	struct fc_rport *rport = (struct fc_rport *)data;
+	struct scsi_target *starget;
 
-	spi_scan_target(&rport->dev, rport->channel, rport->scsi_target_id,
-			SCAN_WILD_CARD, 1);
+	starget = scsi_alloc_target(&rport->dev, rport->channel,
+				    rport->scsi_target_id);
+	if (starget)
+		scsi_scan_target(starget, SCAN_WILD_CARD, 1);
 }
 
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index f6c1a96..cf40f74 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -578,8 +578,12 @@ int sas_rphy_add(struct sas_rphy *rphy)
 	spin_unlock(&sas_host->lock);
 
 	if (rphy->scsi_target_id != -1) {
-		spi_scan_target(&rphy->dev, parent->number,
-				rphy->scsi_target_id, ~0, 0);
+		struct scsi_target *starget;
+
+		starget = scsi_alloc_target(&rphy->dev, parent->number,
+					    rphy->scsi_target_id);
+		if (starget)
+			scsi_scan_target(starget, ~0, 0);
 	}
 
 	return 0;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c7cdb23..c5e31fe 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -246,6 +246,8 @@ extern int scsi_device_set_state(struct 
 				 enum scsi_device_state state);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
+extern struct scsi_target *scsi_alloc_target(struct device *parent,
+					     int channel, uint id);
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
 extern void spi_scan_target(struct device *parent, unsigned int channel,
