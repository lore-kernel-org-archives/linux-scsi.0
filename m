From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/36] scsi_dh_alua: rework alua_check_tpgs() to return the tpgs mode
Date: Tue, 29 Sep 2015 12:47:20 +0200
Message-ID: <1443523658-87622-19-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934644AbbI2Kr7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:47:59 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Instead of returning an error code in alua_check_tpgs() we should
rather return the tpgs mode directly and have a cleanup syntax.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index b72cea6..c6fcfa5 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -167,24 +167,23 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
  * Examine the TPGS setting of the sdev to find out if ALUA
  * is supported.
  */
-static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
+static int alua_check_tpgs(struct scsi_device *sdev)
 {
-	int err = SCSI_DH_OK;
+	int tpgs = TPGS_MODE_NONE;
 
 	/*
 	 * ALUA support for non-disk devices is fraught with
 	 * difficulties, so disable it for now.
 	 */
 	if (sdev->type != TYPE_DISK) {
-		h->tpgs = TPGS_MODE_NONE;
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: disable for non-disk devices\n",
 			    ALUA_DH_NAME);
-		return SCSI_DH_DEV_UNSUPP;
+		return tpgs;
 	}
 
-	h->tpgs = scsi_device_tpgs(sdev);
-	switch (h->tpgs) {
+	tpgs = scsi_device_tpgs(sdev);
+	switch (tpgs) {
 	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: supports implicit and explicit TPGS\n",
@@ -201,18 +200,16 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
 	case TPGS_MODE_NONE:
 		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
 			    ALUA_DH_NAME);
-		err = SCSI_DH_DEV_UNSUPP;
 		break;
 	default:
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: unsupported TPGS setting %d\n",
-			    ALUA_DH_NAME, h->tpgs);
-		h->tpgs = TPGS_MODE_NONE;
-		err = SCSI_DH_DEV_UNSUPP;
+			    ALUA_DH_NAME, tpgs);
+		tpgs = TPGS_MODE_NONE;
 		break;
 	}
 
-	return err;
+	return tpgs;
 }
 
 /*
@@ -587,10 +584,10 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
  */
 static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	int err;
+	int err = SCSI_DH_DEV_UNSUPP;
 
-	err = alua_check_tpgs(sdev, h);
-	if (err != SCSI_DH_OK)
+	h->tpgs = alua_check_tpgs(sdev);
+	if (h->tpgs == TPGS_MODE_NONE)
 		goto out;
 
 	err = alua_check_vpd(sdev, h);
-- 
1.8.5.6

