From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 30/36] scsi_dh_alua: Send TEST UNIT READY to poll for transitioning
Date: Tue, 29 Sep 2015 12:47:32 +0200
Message-ID: <1443523658-87622-31-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934714AbbI2KsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:48:06 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Sending a 'REPORT TARGET PORT GROUP' command is a costly operation,
as the array has to gather information about all ports.
So instead of using RTPG to poll for a status update when a port
is in transitioning we should be sending a TEST UNIT READY, and
wait for the sense code to report success.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ewan Milne <emilne@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 37 ++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index dd8682e..7476c8a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -490,6 +490,30 @@ static int alua_check_sense(struct scsi_device *sdev,
 }
 
 /*
+ * alua_tur - Send a TEST UNIT READY
+ * @sdev: device to which the TEST UNIT READY command should be send
+ *
+ * Send a TEST UNIT READY to @sdev to figure out the device state
+ * Returns SCSI_DH_RETRY if the sense code is NOT READY/ALUA TRANSITIONING,
+ * SCSI_DH_OK if no error occured, and SCSI_DH_IO otherwise.
+ */
+static int alua_tur(struct scsi_device *sdev)
+{
+	struct scsi_sense_hdr sense_hdr;
+	int retval;
+
+	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
+				      ALUA_FAILOVER_RETRIES, &sense_hdr);
+	if (sense_hdr.sense_key == NOT_READY &&
+	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
+		return SCSI_DH_RETRY;
+	else if (retval)
+		return SCSI_DH_IO;
+	else
+		return SCSI_DH_OK;
+}
+
+/*
  * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
  * @sdev: the device to be evaluated.
  *
@@ -750,7 +774,20 @@ static void alua_rtpg_work(struct work_struct *work)
 	}
 	pg->flags |= ALUA_PG_RUNNING;
 	if (pg->flags & ALUA_PG_RUN_RTPG) {
+		int state = pg->state;
+
 		spin_unlock_irqrestore(&pg->lock, flags);
+		if (state == TPGS_STATE_TRANSITIONING) {
+			if (alua_tur(sdev) == SCSI_DH_RETRY) {
+				spin_lock_irqsave(&pg->lock, flags);
+				pg->flags &= ~ALUA_PG_RUNNING;
+				spin_unlock_irqrestore(&pg->lock, flags);
+				queue_delayed_work(kaluad_wq, &pg->rtpg_work,
+						   pg->interval * HZ);
+				return;
+			}
+			/* Send RTPG on failure or if TUR indicates SUCCESS */
+		}
 		err = alua_rtpg(sdev, pg);
 		spin_lock_irqsave(&pg->lock, flags);
 		if (err == SCSI_DH_RETRY) {
-- 
1.8.5.6

