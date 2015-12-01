From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/18] scsi_dh_alua: rework alua_check_tpgs() to return the tpgs mode
Date: Tue,  1 Dec 2015 10:16:53 +0100
Message-ID: <1448961418-29013-14-git-send-email-hare@suse.de>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057AbbLAJRN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:17:13 -0500
In-Reply-To: <1448961418-29013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Instead of returning an error code in alua_check_tpgs() we should
rather return the tpgs mode directly and have a cleaner syntax.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index d54f42e..c9751c9 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -262,24 +262,23 @@ static unsigned submit_stpg(struct alua_dh_data *h)
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
@@ -296,18 +295,16 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
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
@@ -627,10 +624,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
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

