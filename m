From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 37/47] aic79xx: use scsi device as argument for BUILD_SCSIID()
Date: Wed, 28 Jun 2017 10:33:03 +0200
Message-ID: <1498638793-44672-38-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53816 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751819AbdF1Ida (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:30 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 0797c2f..66f9450 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -541,8 +541,8 @@ void ahd_insb(struct ahd_softc * ahd, long port,
 }
 
 /******************************** Macros **************************************/
-#define BUILD_SCSIID(ahd, cmd)						\
-	(((scmd_id(cmd) << TID_SHIFT) & TID) | (ahd)->our_id)
+#define BUILD_SCSIID(ahd, sdev)					\
+	(((sdev_id(sdev) << TID_SHIFT) & TID) | (ahd)->our_id)
 
 /*
  * Return a string describing the driver.
@@ -837,7 +837,7 @@ static DEF_SCSI_QCMD(ahd_linux_queue)
 	ahd_set_sense_residual(reset_scb, 0);
 	reset_scb->platform_data->xfer_len = 0;
 	reset_scb->hscb->control = 0;
-	reset_scb->hscb->scsiid = BUILD_SCSIID(ahd,cmd);
+	reset_scb->hscb->scsiid = BUILD_SCSIID(ahd, cmd->device);
 	reset_scb->hscb->lun = cmd->device->lun;
 	reset_scb->hscb->cdb_len = 0;
 	reset_scb->hscb->task_management = SIU_TASKMGMT_LUN_RESET;
@@ -1598,7 +1598,7 @@ struct scsi_host_template aic79xx_driver_template = {
 	 * Fill out basics of the HSCB.
 	 */
 	hscb->control = 0;
-	hscb->scsiid = BUILD_SCSIID(ahd, cmd);
+	hscb->scsiid = BUILD_SCSIID(ahd, cmd->device);
 	hscb->lun = cmd->device->lun;
 	scb->hscb->task_management = 0;
 	mask = SCB_GET_TARGET_MASK(ahd, scb);
-- 
1.8.5.6
