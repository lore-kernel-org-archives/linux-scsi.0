From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 39/47] aic79xx: do not reference scsi command when resetting device
Date: Wed, 28 Jun 2017 10:33:05 +0200
Message-ID: <1498638793-44672-40-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53820 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751865AbdF1Idf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:35 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When sending a device reset we should not take a reference to the
scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 66f9450..695e93e 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -536,8 +536,10 @@ void ahd_insb(struct ahd_softc * ahd, long port,
 	struct scsi_cmnd *cmd;
 
 	cmd = scb->io_ctx;
-	ahd_sync_sglist(ahd, scb, BUS_DMASYNC_POSTWRITE);
-	scsi_dma_unmap(cmd);
+	if (cmd) {
+		ahd_sync_sglist(ahd, scb, BUS_DMASYNC_POSTWRITE);
+		scsi_dma_unmap(cmd);
+	}
 }
 
 /******************************** Macros **************************************/
@@ -830,7 +832,7 @@ static DEF_SCSI_QCMD(ahd_linux_queue)
 
 	tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
 				    cmd->device->id, &tstate);
-	reset_scb->io_ctx = cmd;
+	reset_scb->io_ctx = NULL;
 	reset_scb->platform_data->dev = dev;
 	reset_scb->sg_count = 0;
 	ahd_set_residual(reset_scb, 0);
@@ -1787,9 +1789,16 @@ struct scsi_host_template aic79xx_driver_template = {
 	dev = scb->platform_data->dev;
 	dev->active--;
 	dev->openings++;
-	if ((cmd->result & (CAM_DEV_QFRZN << 16)) != 0) {
-		cmd->result &= ~(CAM_DEV_QFRZN << 16);
-		dev->qfrozen--;
+	if (cmd) {
+		if ((cmd->result & (CAM_DEV_QFRZN << 16)) != 0) {
+			cmd->result &= ~(CAM_DEV_QFRZN << 16);
+			dev->qfrozen--;
+		}
+	} else if (scb->flags & SCB_DEVICE_RESET) {
+		if (ahd->platform_data->eh_done)
+			complete(ahd->platform_data->eh_done);
+		ahd_free_scb(ahd, scb);
+		return;
 	}
 	ahd_linux_unmap_scb(ahd, scb);
 
-- 
1.8.5.6
