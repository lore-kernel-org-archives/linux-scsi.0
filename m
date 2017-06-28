From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 38/47] aic7xxx: use scsi device as argument for BUILD_SCSIID()
Date: Wed, 28 Jun 2017 10:33:04 +0200
Message-ID: <1498638793-44672-39-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53783 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751521AbdF1Ida (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:30 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 5f9d2ae..72f3007 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -817,10 +817,10 @@ struct scsi_host_template aic7xxx_driver_template = {
 /**************************** Tasklet Handler *********************************/
 
 /******************************** Macros **************************************/
-#define BUILD_SCSIID(ahc, cmd)						    \
-	((((cmd)->device->id << TID_SHIFT) & TID)			    \
-	| (((cmd)->device->channel == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
-	| (((cmd)->device->channel == 0) ? 0 : TWIN_CHNLB))
+#define BUILD_SCSIID(ahc, sdev)						    \
+	((((sdev)->id << TID_SHIFT) & TID)			    \
+	| (((sdev)->channel == 0) ? (ahc)->our_id : (ahc)->our_id_b) \
+	| (((sdev)->channel == 0) ? 0 : TWIN_CHNLB))
 
 /******************************** Bus DMA *************************************/
 int
@@ -1477,7 +1477,7 @@ struct scsi_host_template aic7xxx_driver_template = {
 	 * Fill out basics of the HSCB.
 	 */
 	hscb->control = 0;
-	hscb->scsiid = BUILD_SCSIID(ahc, cmd);
+	hscb->scsiid = BUILD_SCSIID(ahc, cmd->device);
 	hscb->lun = cmd->device->lun;
 	mask = SCB_GET_TARGET_MASK(ahc, scb);
 	tinfo = ahc_fetch_transinfo(ahc, SCB_GET_CHANNEL(ahc, scb),
-- 
1.8.5.6
