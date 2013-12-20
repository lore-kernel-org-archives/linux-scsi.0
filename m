From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/16] scsi_dh_alua: revert commit a8e5a2d593cbfccf530c3382c2c328d2edaa7b66
Date: Fri, 20 Dec 2013 13:13:40 +0100
Message-ID: <1387541621-54967-16-git-send-email-hare@suse.de>
References: <1387541621-54967-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab3LTMNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 07:13:45 -0500
In-Reply-To: <1387541621-54967-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, Hannes Reinecke <hare@suse.de>

Obsoleted by the next patch.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index baaae3f..e6b2565 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -678,13 +678,12 @@ static int alua_check_sense(struct scsi_device *sdev,
 /*
  * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
  * @sdev: the device to be evaluated.
- * @wait_for_transition: if nonzero, wait ALUA_FAILOVER_TIMEOUT seconds for device to exit transitioning state
  *
  * Evaluate the Target Port Group State.
  * Returns SCSI_DH_DEV_OFFLINED if the path is
  * found to be unusable.
  */
-static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int wait_for_transition)
+static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 {
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sense_hdr;
@@ -774,7 +773,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 	else
 		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
 
-	if (wait_for_transition && (orig_transition_tmo != pg->transition_tmo)) {
+	if (orig_transition_tmo != pg->transition_tmo) {
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: transition timeout set to %d seconds\n",
 			    ALUA_DH_NAME, pg->transition_tmo);
@@ -812,19 +811,14 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 
 	switch (pg->state) {
 	case TPGS_STATE_TRANSITIONING:
-		if (wait_for_transition) {
-			if (time_before(jiffies, expiry)) {
-				/* State transition, retry */
-				interval += 2000;
-				msleep(interval);
-				goto retry;
-			}
-			err = SCSI_DH_RETRY;
-		} else {
-			err = SCSI_DH_OK;
+		if (time_before(jiffies, expiry)) {
+			/* State transition, retry */
+			interval += 2000;
+			msleep(interval);
+			goto retry;
 		}
-
 		/* Transitioning time exceeded, set port to standby */
+		err = SCSI_DH_RETRY;
 		pg->state = TPGS_STATE_STANDBY;
 		break;
 	case TPGS_STATE_OFFLINE:
-- 
1.7.12.4

