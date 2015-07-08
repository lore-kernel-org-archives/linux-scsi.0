From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/20] scsi_dh_alua: Recheck state on unit attention
Date: Wed,  8 Jul 2015 11:06:15 +0200
Message-ID: <1436346378-96518-18-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933801AbbGHJGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:33 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

When we receive a unit attention code of 'ALUA state changed'
we should recheck the state, as it might be due to an implicit
ALUA state transition.
At the same time a workqueue item might already be queued, which
should be started immediately to avoid any delays.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 48 +++++++++++++++---------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ea47d15..aa58659 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -120,7 +120,7 @@ static char print_alua_state(int);
 static void alua_rtpg_work(struct work_struct *work);
 static void alua_stpg_work(struct work_struct *work);
 static void alua_qdata_work(struct work_struct *work);
-static void alua_check(struct scsi_device *sdev);
+static void alua_check(struct scsi_device *sdev, bool force);
 
 static void release_port_group(struct kref *kref)
 {
@@ -505,7 +505,7 @@ static char print_alua_state(int state)
 }
 
 static int alua_check_sense(struct scsi_device *sdev,
-			    struct scsi_sense_hdr *sense_hdr)
+			     struct scsi_sense_hdr *sense_hdr)
 {
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
@@ -514,36 +514,34 @@ static int alua_check_sense(struct scsi_device *sdev,
 			 * LUN Not Accessible - ALUA state transition
 			 * Kickoff worker to update internal state.
 			 */
-			alua_check(sdev);
-			return ADD_TO_MLQUEUE;
+			alua_check(sdev, false);
+			return NEEDS_RETRY;
 		}
 		break;
 	case UNIT_ATTENTION:
-		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
-			/*
-			 * Power On, Reset, or Bus Device Reset, just retry.
-			 */
-			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x04)
-			/*
-			 * Device internal reset
-			 */
-			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
+		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
 			/*
-			 * Mode Parameter Changed
+			 * Power On, Reset, or Bus Device Reset.
+			 * Might have obscured a state transition,
+			 * so schedule a recheck.
 			 */
+			alua_check(sdev, true);
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06)
+		}
+		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
 			/*
 			 * ALUA state changed
 			 */
+			alua_check(sdev, true);
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07)
+		}
+		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
 			/*
 			 * Implicit ALUA state transition failed
 			 */
+			alua_check(sdev, true);
 			return ADD_TO_MLQUEUE;
+		}
 		break;
 	}
 
@@ -899,7 +897,7 @@ static void alua_qdata_work(struct work_struct *work)
 
 static void alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
-			    struct alua_queue_data *qdata)
+			    struct alua_queue_data *qdata, bool force)
 {
 	int start_queue = 0;
 	unsigned long flags;
@@ -920,7 +918,9 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		pg->rtpg_sdev = sdev;
 		scsi_device_get(sdev);
 		start_queue = 1;
-	}
+	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force)
+		start_queue = 1;
+
 	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
 
 	if (start_queue)
@@ -959,7 +959,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 	complete(&h->init_complete);
 	if (pg) {
 		pg->expiry = 0;
-		alua_rtpg_queue(pg, sdev, NULL);
+		alua_rtpg_queue(pg, sdev, NULL, true);
 		kref_put(&pg->kref, release_port_group);
 	}
 	return h->error;
@@ -1072,7 +1072,7 @@ static int alua_activate(struct scsi_device *sdev,
 		pg->flags |= ALUA_OPTIMIZE_STPG;
 		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
 	}
-	alua_rtpg_queue(pg, sdev, qdata);
+	alua_rtpg_queue(pg, sdev, qdata, true);
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
@@ -1086,7 +1086,7 @@ out:
  *
  * Check the device status
  */
-static void alua_check(struct scsi_device *sdev)
+static void alua_check(struct scsi_device *sdev, bool force)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	struct alua_port_group *pg;
@@ -1096,7 +1096,7 @@ static void alua_check(struct scsi_device *sdev)
 	if (pg) {
 		kref_get(&pg->kref);
 		rcu_read_unlock();
-		alua_rtpg_queue(pg, sdev, NULL);
+		alua_rtpg_queue(pg, sdev, NULL, force);
 		kref_put(&pg->kref, release_port_group);
 	} else
 		rcu_read_unlock();
-- 
1.8.5.2

