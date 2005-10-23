From: Jeff Garzik <jgarzik@pobox.com>
Subject: [patch 3/6] SCSI HCIL: add scsi_scan_target()
Date: Sat, 22 Oct 2005 21:38:49 -0400
Message-ID: <20051023013849.GC18279@havoc.gtf.org>
References: <20051023013618.GA18201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:31198 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751362AbVJWBiu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 21:38:50 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 109AB1C0960B
	for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2005 21:38:50 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9N1cnbK018367
	for linux-scsi@vger.kernel.org; Sat, 22 Oct 2005 21:38:49 -0400
Content-Disposition: inline
In-Reply-To: <20051023013618.GA18201@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


__spi_scan_target() becomes a wrapper around __scsi_scan_target()

Signed-off-by: Jeff Garzik <jgarzik@pobox.com>


eb622527338014ebd80e10d60821d1f1559e2ac3
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0cbcbe7..92fc94b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1306,23 +1306,11 @@ void scsi_rescan_device(struct device *d
 }
 EXPORT_SYMBOL(scsi_rescan_device);
 
-static void __spi_scan_target(struct device *parent, unsigned int channel,
-		unsigned int id, unsigned int lun, int rescan)
+static void __scsi_scan_target(struct scsi_target *starget,
+		unsigned int lun, int rescan)
 {
-	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
 	int res;
-	struct scsi_target *starget;
-
-	if (shost->this_id == id)
-		/*
-		 * Don't scan the host adapter
-		 */
-		return;
-
-	starget = scsi_alloc_target(parent, channel, id);
-	if (!starget)
-		return;
 
 	get_device(&starget->dev);
 	if (lun != SCAN_WILD_CARD) {
@@ -1356,6 +1344,23 @@ static void __spi_scan_target(struct dev
 	put_device(&starget->dev);
 }
 
+static void __spi_scan_target(struct device *parent, unsigned int channel,
+		unsigned int id, unsigned int lun, int rescan)
+{
+	struct Scsi_Host *shost = dev_to_shost(parent);
+	struct scsi_target *starget;
+
+	if (shost->this_id == id)
+		/*
+		 * Don't scan the host adapter
+		 */
+		return;
+
+	starget = scsi_alloc_target(parent, channel, id);
+	if (starget)
+		__scsi_scan_target(starget, lun, rescan);
+}
+
 /**
  * spi_scan_target - scan a target id, possibly including all LUNs on the
  *     target.
@@ -1384,6 +1389,31 @@ void spi_scan_target(struct device *pare
 }
 EXPORT_SYMBOL(spi_scan_target);
 
+/**
+ * scsi_scan_target - scan a target id, possibly including all LUNs on the
+ *     target.
+ * @target:	target to scan
+ * @lun:	Specific LUN to scan or SCAN_WILD_CARD
+ * @rescan:	passed to LUN scanning routines
+ *
+ * Description:
+ *     Scan the target id on @parent, @channel, and @id. Scan at least LUN 0,
+ *     and possibly all LUNs on the target id.
+ *
+ *     First try a REPORT LUN scan, if that does not scan the target, do a
+ *     sequential scan of LUNs on the target id.
+ **/
+void scsi_scan_target(struct scsi_target *target, unsigned int lun, int rescan)
+{
+	struct Scsi_Host *shost = dev_to_shost(target->dev.parent);
+
+	down(&shost->scan_mutex);
+	if (scsi_host_scan_allowed(shost))
+		__scsi_scan_target(target, lun, rescan);
+	up(&shost->scan_mutex);
+}
+EXPORT_SYMBOL(scsi_scan_target);
+
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, unsigned int lun, int rescan)
 {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 814a7d8..c7cdb23 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -250,6 +250,8 @@ extern void scsi_target_quiesce(struct s
 extern void scsi_target_resume(struct scsi_target *);
 extern void spi_scan_target(struct device *parent, unsigned int channel,
 			    unsigned int id, unsigned int lun, int rescan);
+extern void scsi_scan_target(struct scsi_target *target,
+			     unsigned int lun, int rescan);
 extern void scsi_target_reap(struct scsi_target *);
 extern void scsi_target_block(struct device *);
 extern void scsi_target_unblock(struct device *);
