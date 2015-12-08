From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/20] revert commit a8e5a2d593cb ("[SCSI] scsi_dh_alua: ALUA handler attach should succeed while TPG is transitioning")
Date: Tue,  8 Dec 2015 08:37:30 +0100
Message-ID: <1449560260-53407-11-git-send-email-hare@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933196AbbLHHhr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 02:37:47 -0500
In-Reply-To: <1449560260-53407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Obsoleted by the next patch.

Reviewed-by: Ewan Milne <emilne@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 31 ++++++++++++------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 1eacf3f..8d80ac6 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -91,7 +91,7 @@ struct alua_dh_data {
 #define ALUA_POLICY_SWITCH_CURRENT	0
 #define ALUA_POLICY_SWITCH_ALL		1
 
-static int alua_rtpg(struct scsi_device *, struct alua_port_group *, int);
+static int alua_rtpg(struct scsi_device *, struct alua_port_group *);
 static char print_alua_state(int);
 
 static void release_port_group(struct kref *kref)
@@ -331,7 +331,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 	if (!h->pg)
 		return SCSI_DH_NOMEM;
 
-	return alua_rtpg(sdev, h->pg, 0);
+	return alua_rtpg(sdev, h->pg);
 }
 
 static char print_alua_state(int state)
@@ -414,13 +414,12 @@ static int alua_check_sense(struct scsi_device *sdev,
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
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
@@ -511,8 +510,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 	else
 		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
 
-	if (wait_for_transition &&
-	    (orig_transition_tmo != pg->transition_tmo)) {
+	if (orig_transition_tmo != pg->transition_tmo) {
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: transition timeout set to %d seconds\n",
 			    ALUA_DH_NAME, pg->transition_tmo);
@@ -550,19 +548,14 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 
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
@@ -723,14 +716,14 @@ static int alua_activate(struct scsi_device *sdev,
 	if (optimize_stpg)
 		h->pg->flags |= ALUA_OPTIMIZE_STPG;
 
-	err = alua_rtpg(sdev, h->pg, 1);
+	err = alua_rtpg(sdev, h->pg);
 	if (err != SCSI_DH_OK) {
 		kref_put(&h->pg->kref, release_port_group);
 		goto out;
 	}
 	err = alua_stpg(sdev, h->pg);
 	if (err == SCSI_DH_RETRY)
-		err = alua_rtpg(sdev, h->pg, 1);
+		err = alua_rtpg(sdev, h->pg);
 	kref_put(&h->pg->kref, release_port_group);
 out:
 	if (fn)
-- 
1.8.5.6

