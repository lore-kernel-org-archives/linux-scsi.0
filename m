From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 41/47] xen-scsifront: add scsi device as argument to scsifront_do_request()
Date: Wed, 28 Jun 2017 10:33:07 +0200
Message-ID: <1498638793-44672-42-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751855AbdF1Ide (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:34 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add scsi device as argument to scsifront_do_request() so that it
will be possible to call it with a NULL command pointer.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/xen-scsifront.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 36f59a1..04af950 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -175,7 +175,8 @@ static void scsifront_put_rqid(struct vscsifrnt_info *info, uint32_t id)
 		scsifront_wake_up(info);
 }
 
-static int scsifront_do_request(struct vscsifrnt_info *info,
+static int scsifront_do_request(struct scsi_device *sdev,
+				struct vscsifrnt_info *info,
 				struct vscsifrnt_shadow *shadow)
 {
 	struct vscsiif_front_ring *ring = &(info->ring);
@@ -202,17 +203,20 @@ static int scsifront_do_request(struct vscsifrnt_info *info,
 	ring_req->ref_rqid    = shadow->ref_rqid;
 	ring_req->nr_segments = shadow->nr_segments;
 
-	ring_req->id      = sc->device->id;
-	ring_req->lun     = sc->device->lun;
-	ring_req->channel = sc->device->channel;
-	ring_req->cmd_len = sc->cmd_len;
-
-	BUG_ON(sc->cmd_len > VSCSIIF_MAX_COMMAND_SIZE);
-
-	memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
-
-	ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
-	ring_req->timeout_per_command = sc->request->timeout / HZ;
+	ring_req->id      = sdev->id;
+	ring_req->lun     = sdev->lun;
+	ring_req->channel = sdev->channel;
+	if (sc) {
+		ring_req->cmd_len = sc->cmd_len;
+		BUG_ON(sc->cmd_len > VSCSIIF_MAX_COMMAND_SIZE);
+		memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
+		ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
+		ring_req->timeout_per_command = sc->request->timeout / HZ;
+	} else {
+		ring_req->cmd_len = VSCSIIF_MAX_COMMAND_SIZE;
+		memset(ring_req->cmnd, 0, VSCSIIF_MAX_COMMAND_SIZE);
+		ring_req->sc_data_direction = DMA_NONE;
+	}
 
 	for (i = 0; i < (shadow->nr_segments & ~VSCSIIF_SG_GRANT); i++)
 		ring_req->seg[i] = shadow->seg[i];
@@ -556,7 +560,7 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 		return 0;
 	}
 
-	if (scsifront_do_request(info, shadow)) {
+	if (scsifront_do_request(sc->device, info, shadow)) {
 		scsifront_gnttab_done(info, shadow);
 		goto busy;
 	}
@@ -601,7 +605,7 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 		if (scsifront_enter(info))
 			goto fail;
 
-		if (!scsifront_do_request(info, shadow))
+		if (!scsifront_do_request(sc->device, info, shadow))
 			break;
 
 		scsifront_return(info);
-- 
1.8.5.6
