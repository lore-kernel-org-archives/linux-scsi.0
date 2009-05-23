From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] fix potential deadlock with async scanning
Date: Sat, 23 May 2009 16:07:44 -0500
Message-ID: <1243112864.3630.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60524 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751AbZEWVHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 May 2009 17:07:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>

The recent attempted conversion to the async code exposed a deadlock
within the existing async scanning code, whereby all external scan
callers take the scan mutex, then wait for the async scans to complete.
Unfortunately the async scan threads take, drop and retake this mutex,
so they can deadlock.

The fix is to wait for the scans first before taking the scan mutex.
The problem would only affect hosts that both call scsi_scan_host() and
later add extra devices.

James

---
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c447838..1363420 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1516,10 +1516,10 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	if (!starget)
 		return ERR_PTR(-ENOMEM);
 
-	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
+	mutex_lock(&shost->scan_mutex);
 	if (scsi_host_scan_allowed(shost))
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 	mutex_unlock(&shost->scan_mutex);
@@ -1631,10 +1631,10 @@ void scsi_scan_target(struct device *parent, unsigned int channel,
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
 		return;
 
-	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
+	mutex_lock(&shost->scan_mutex);
 	if (scsi_host_scan_allowed(shost))
 		__scsi_scan_target(parent, channel, id, lun, rescan);
 	mutex_unlock(&shost->scan_mutex);
@@ -1684,10 +1684,10 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
 		return -EINVAL;
 
-	mutex_lock(&shost->scan_mutex);
 	if (!shost->async_scan)
 		scsi_complete_async_scans();
 
+	mutex_lock(&shost->scan_mutex);
 	if (scsi_host_scan_allowed(shost)) {
 		if (channel == SCAN_WILD_CARD)
 			for (channel = 0; channel <= shost->max_channel;


