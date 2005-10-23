From: Jeff Garzik <jgarzik@pobox.com>
Subject: [patch 5/6] SCSI HCIL: kill spi_scan_target(), __spi_scan_target()
Date: Sat, 22 Oct 2005 21:40:43 -0400
Message-ID: <20051023014043.GE18279@havoc.gtf.org>
References: <20051023013618.GA18201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33502 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751377AbVJWBkn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 21:40:43 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 6328B1C0960B
	for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2005 21:40:43 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9N1ehlc018423
	for linux-scsi@vger.kernel.org; Sat, 22 Oct 2005 21:40:43 -0400
Content-Disposition: inline
In-Reply-To: <20051023013618.GA18201@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Jeff Garzik <jgarzik@pobox.com>


4accfa89ef54c2f7405de58da9b40aa38ef876ca
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a48d958..3b7a0a7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1345,51 +1345,6 @@ static void __scsi_scan_target(struct sc
 	put_device(&starget->dev);
 }
 
-static void __spi_scan_target(struct device *parent, unsigned int channel,
-		unsigned int id, unsigned int lun, int rescan)
-{
-	struct Scsi_Host *shost = dev_to_shost(parent);
-	struct scsi_target *starget;
-
-	if (shost->this_id == id)
-		/*
-		 * Don't scan the host adapter
-		 */
-		return;
-
-	starget = scsi_alloc_target(parent, channel, id);
-	if (starget)
-		__scsi_scan_target(starget, lun, rescan);
-}
-
-/**
- * spi_scan_target - scan a target id, possibly including all LUNs on the
- *     target.
- * @parent:	host to scan
- * @channel:	channel to scan
- * @id:		target id to scan
- * @lun:	Specific LUN to scan or SCAN_WILD_CARD
- * @rescan:	passed to LUN scanning routines
- *
- * Description:
- *     Scan the target id on @parent, @channel, and @id. Scan at least LUN 0,
- *     and possibly all LUNs on the target id.
- *
- *     First try a REPORT LUN scan, if that does not scan the target, do a
- *     sequential scan of LUNs on the target id.
- **/
-void spi_scan_target(struct device *parent, unsigned int channel,
-		      unsigned int id, unsigned int lun, int rescan)
-{
-	struct Scsi_Host *shost = dev_to_shost(parent);
-
-	down(&shost->scan_mutex);
-	if (scsi_host_scan_allowed(shost))
-		__spi_scan_target(parent, channel, id, lun, rescan);
-	up(&shost->scan_mutex);
-}
-EXPORT_SYMBOL(spi_scan_target);
-
 /**
  * scsi_scan_target - scan a target id, possibly including all LUNs on the
  *     target.
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c5e31fe..83cc223 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -250,8 +250,6 @@ extern struct scsi_target *scsi_alloc_ta
 					     int channel, uint id);
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
-extern void spi_scan_target(struct device *parent, unsigned int channel,
-			    unsigned int id, unsigned int lun, int rescan);
 extern void scsi_scan_target(struct scsi_target *target,
 			     unsigned int lun, int rescan);
 extern void scsi_target_reap(struct scsi_target *);
