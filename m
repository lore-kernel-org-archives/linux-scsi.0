From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/20] scsi_dh_alua: Send TEST UNIT READY to poll for transitioning
Date: Wed,  8 Jul 2015 11:06:17 +0200
Message-ID: <1436346378-96518-20-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934536AbbGHJGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:35 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

Sending a 'REPORT TARGET PORT GROUP' command is a costly operation,
as the array has to gather information about all ports.
So instead of using RTPG to poll for a status update when a port
is in transitioning we should be sending a TEST UNIT READY, and
wait for the sense code to report success.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 33 ++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 44b57bc..30310c8 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -549,6 +549,30 @@ static int alua_check_sense(struct scsi_device *sdev,
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
@@ -820,7 +844,16 @@ static void alua_rtpg_work(struct work_struct *work)
 		return;
 	}
 	if (pg->flags & ALUA_PG_RUN_RTPG) {
+		int state = pg->state;
 		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+		if (state == TPGS_STATE_TRANSITIONING) {
+			if (alua_tur(sdev) == SCSI_DH_RETRY) {
+				queue_delayed_work(pg->work_q, &pg->rtpg_work,
+						   pg->interval * HZ);
+				return;
+			}
+			/* Send RTPG on failure or if TUR indicates SUCCESS */
+		}
 		err = alua_rtpg(sdev, pg);
 		if (err == SCSI_DH_RETRY) {
 			queue_delayed_work(pg->work_q, &pg->rtpg_work,
-- 
1.8.5.2

