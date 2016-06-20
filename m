From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] scsi: disable VPD page check on error
Date: Mon, 20 Jun 2016 08:57:47 +0200
Message-ID: <1466405868-87720-3-git-send-email-hare@suse.de>
References: <1466405868-87720-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbcFTHdw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 03:33:52 -0400
In-Reply-To: <1466405868-87720-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If we encounter an error during initial VPD page scan we should be
setting the 'skip_vpd_pages' bit to avoid further accesses.
Any errors during rescan should be ignored, as we might encounter
temporary I/O errors during rescan.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi.c      | 9 ++++++++-
 drivers/scsi/scsi_priv.h | 2 +-
 drivers/scsi/scsi_scan.c | 4 ++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1deb6ad..1ff4a0b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -770,13 +770,14 @@ EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
 /**
  * scsi_attach_vpd - Attach Vital Product Data to a SCSI device structure
  * @sdev: The device to ask
+ * @first_scan: true if called during initial scan
  *
  * Attach the 'Device Identification' VPD page (0x83) and the
  * 'Unit Serial Number' VPD page (0x80) to a SCSI device
  * structure. This information can be used to identify the device
  * uniquely.
  */
-void scsi_attach_vpd(struct scsi_device *sdev)
+void scsi_attach_vpd(struct scsi_device *sdev, bool first_scan)
 {
 	int result, i;
 	int vpd_len = SCSI_VPD_PG_LEN;
@@ -796,6 +797,8 @@ retry_pg0:
 	result = scsi_vpd_inquiry(sdev, vpd_buf, 0, vpd_len);
 	if (result < 0) {
 		kfree(vpd_buf);
+		if (first_scan)
+			sdev->skip_vpd_pages = 1;
 		return;
 	}
 	if (result > vpd_len) {
@@ -822,6 +825,8 @@ retry_pg80:
 		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x80, vpd_len);
 		if (result < 0) {
 			kfree(vpd_buf);
+			if (first_scan)
+				sdev->skip_vpd_pages = 1;
 			return;
 		}
 		if (result > vpd_len) {
@@ -851,6 +856,8 @@ retry_pg83:
 		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x83, vpd_len);
 		if (result < 0) {
 			kfree(vpd_buf);
+			if (first_scan)
+				sdev->skip_vpd_pages = 1;
 			return;
 		}
 		if (result > vpd_len) {
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 6c3db56..0c4cc6d 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -31,7 +31,7 @@ extern void scsi_exit_hosts(void);
 /* scsi.c */
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
-void scsi_attach_vpd(struct scsi_device *sdev);
+void scsi_attach_vpd(struct scsi_device *sdev, bool first_scan);
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd);
 void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e0a78f5..dcc08ad 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -997,7 +997,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	}
 
 	if (sdev->scsi_level >= SCSI_3)
-		scsi_attach_vpd(sdev);
+		scsi_attach_vpd(sdev, true);
 
 	sdev->max_queue_depth = sdev->queue_depth;
 
@@ -1536,7 +1536,7 @@ void scsi_rescan_device(struct device *dev)
 
 	device_lock(dev);
 
-	scsi_attach_vpd(sdev);
+	scsi_attach_vpd(sdev, false);
 
 	if (sdev->handler && sdev->handler->rescan)
 		sdev->handler->rescan(sdev);
-- 
1.8.5.6

