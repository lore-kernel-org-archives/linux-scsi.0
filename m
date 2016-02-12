From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv6 18/23] scsi_dh_alua: Send TEST UNIT READY to poll for transitioning
Date: Fri, 12 Feb 2016 09:25:41 +0100
Message-ID: <1455265546-44470-19-git-send-email-hare@suse.de>
References: <1455265546-44470-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbcBLIZx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2016 03:25:53 -0500
In-Reply-To: <1455265546-44470-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>

Sending a 'REPORT TARGET PORT GROUP' command is a costly operation,
as the array has to gather information about all ports.
So instead of using RTPG to poll for a status update when a port
is in transitioning we should be sending a TEST UNIT READY, and
wait for the sense code to report success.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ewan Milne <emilne@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 38 ++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ed77b7c..35ad81f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -466,6 +466,30 @@ static int alua_check_sense(struct scsi_device *sdev,
 }
 
 /*
+ * alua_tur - Send a TEST UNIT READY
+ * @sdev: device to which the TEST UNIT READY command should be send
+ *
+ * Send a TEST UNIT READY to @sdev to figure out the device state
+ * Returns SCSI_DH_RETRY if the sense code is NOT READY/ALUA TRANSITIONING,
+ * SCSI_DH_OK if no error occurred, and SCSI_DH_IO otherwise.
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
@@ -734,8 +758,22 @@ static void alua_rtpg_work(struct work_struct *work)
 		alua_wq = kaluad_sync_wq;
 	pg->flags |= ALUA_PG_RUNNING;
 	if (pg->flags & ALUA_PG_RUN_RTPG) {
+		int state = pg->state;
+
 		pg->flags &= ~ALUA_PG_RUN_RTPG;
 		spin_unlock_irqrestore(&pg->lock, flags);
+		if (state == TPGS_STATE_TRANSITIONING) {
+			if (alua_tur(sdev) == SCSI_DH_RETRY) {
+				spin_lock_irqsave(&pg->lock, flags);
+				pg->flags &= ~ALUA_PG_RUNNING;
+				pg->flags |= ALUA_PG_RUN_RTPG;
+				spin_unlock_irqrestore(&pg->lock, flags);
+				queue_delayed_work(alua_wq, &pg->rtpg_work,
+						   pg->interval * HZ);
+				return;
+			}
+			/* Send RTPG on failure or if TUR indicates SUCCESS */
+		}
 		err = alua_rtpg(sdev, pg);
 		spin_lock_irqsave(&pg->lock, flags);
 		if (err == SCSI_DH_RETRY || pg->flags & ALUA_PG_RUN_RTPG) {
-- 
1.8.5.6

