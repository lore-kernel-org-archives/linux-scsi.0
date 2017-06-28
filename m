From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 42/47] xen-scsifront: call scsifront_action_handler() with a NULL command argument
Date: Wed, 28 Jun 2017 10:33:08 +0200
Message-ID: <1498638793-44672-43-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53803 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751927AbdF1Idk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:40 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

For device reset we shouldn't rely on the scsi command, so allow
scsifront_action_handler() to be called with a NULL command argument.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/xen-scsifront.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 04af950..b093619 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -582,21 +582,27 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
  * We have to wait until an answer is returned. This answer contains the
  * result to be returned to the requestor.
  */
-static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
+static int scsifront_action_handler(struct scsi_device *sdev,
+				    struct scsi_cmnd *sc)
 {
-	struct Scsi_Host *host = sc->device->host;
+	struct Scsi_Host *host = sdev->host;
 	struct vscsifrnt_info *info = shost_priv(host);
-	struct vscsifrnt_shadow *shadow, *s = scsi_cmd_priv(sc);
+	struct vscsifrnt_shadow *shadow, *s;
 	int err = 0;
 
 	shadow = kzalloc(sizeof(*shadow), GFP_NOIO);
 	if (!shadow)
 		return FAILED;
 
-	shadow->act = act;
 	shadow->rslt_reset = RSLT_RESET_WAITING;
 	shadow->sc = sc;
-	shadow->ref_rqid = s->rqid;
+	if (sc) {
+		s = scsi_cmd_priv(sc);
+		shadow->ref_rqid = s->rqid;
+		shadow->act = VSCSIIF_ACT_SCSI_ABORT;
+	} else
+		shadow->act = VSCSIIF_ACT_SCSI_RESET;
+
 	init_waitqueue_head(&shadow->wq_reset);
 
 	spin_lock_irq(host->host_lock);
@@ -646,13 +652,13 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 static int scsifront_eh_abort_handler(struct scsi_cmnd *sc)
 {
 	pr_debug("%s\n", __func__);
-	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_ABORT);
+	return scsifront_action_handler(sc->device, sc);
 }
 
 static int scsifront_dev_reset_handler(struct scsi_cmnd *sc)
 {
 	pr_debug("%s\n", __func__);
-	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_RESET);
+	return scsifront_action_handler(sc->device, NULL);
 }
 
 static int scsifront_sdev_configure(struct scsi_device *sdev)
-- 
1.8.5.6
