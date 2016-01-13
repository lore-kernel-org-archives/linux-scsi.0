From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 17/24] scsi_dh_alua: Recheck state on unit attention
Date: Wed, 13 Jan 2016 09:09:52 +0100
Message-ID: <1452672599-9820-18-git-send-email-hare@suse.de>
References: <1452672599-9820-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbcAMIKU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 03:10:20 -0500
In-Reply-To: <1452672599-9820-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When we receive a unit attention code of 'ALUA state changed'
we should recheck the state, as it might be due to an implicit
ALUA state transition. This allows us to return NEEDS_RETRY
instead of ADD_TO_MLQUEUE, allowing to terminate the retries
after a certain time.
At the same time a workqueue item might already be queued, which
should be started immediately to avoid any delays.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 57 ++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f0687ba..294551a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -120,7 +120,8 @@ struct alua_queue_data {
 static void alua_rtpg_work(struct work_struct *work);
 static void alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
-			    struct alua_queue_data *qdata);
+			    struct alua_queue_data *qdata, bool force);
+static void alua_check(struct scsi_device *sdev, bool force);
 
 static void release_port_group(struct kref *kref)
 {
@@ -380,7 +381,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 	}
 	if (bflags & BLIST_SYNC_ALUA)
 		pg->flags |= ALUA_SYNC_STPG;
-	alua_rtpg_queue(h->pg, sdev, NULL);
+	alua_rtpg_queue(h->pg, sdev, NULL, true);
 	spin_unlock(&h->pg_lock);
 
 	if (pg_updated)
@@ -418,18 +419,24 @@ static int alua_check_sense(struct scsi_device *sdev,
 {
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a)
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
 			/*
 			 * LUN Not Accessible - ALUA state transition
 			 */
-			return ADD_TO_MLQUEUE;
+			alua_check(sdev, false);
+			return NEEDS_RETRY;
+		}
 		break;
 	case UNIT_ATTENTION:
-		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
+		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
 			/*
-			 * Power On, Reset, or Bus Device Reset, just retry.
+			 * Power On, Reset, or Bus Device Reset.
+			 * Might have obscured a state transition,
+			 * so schedule a recheck.
 			 */
+			alua_check(sdev, true);
 			return ADD_TO_MLQUEUE;
+		}
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x04)
 			/*
 			 * Device internal reset
@@ -440,16 +447,20 @@ static int alua_check_sense(struct scsi_device *sdev,
 			 * Mode Parameters Changed
 			 */
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06)
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
 		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
 			/*
 			 * Inquiry data has changed
@@ -771,7 +782,7 @@ static void alua_rtpg_work(struct work_struct *work)
 
 static void alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
-			    struct alua_queue_data *qdata)
+			    struct alua_queue_data *qdata, bool force)
 {
 	int start_queue = 0;
 	unsigned long flags;
@@ -792,7 +803,9 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		pg->rtpg_sdev = sdev;
 		scsi_device_get(sdev);
 		start_queue = 1;
-	}
+	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force)
+		start_queue = 1;
+
 	if (pg->flags & ALUA_SYNC_STPG)
 		alua_wq = kaluad_sync_wq;
 	spin_unlock_irqrestore(&pg->lock, flags);
@@ -907,7 +920,7 @@ static int alua_activate(struct scsi_device *sdev,
 	fn = NULL;
 	rcu_read_unlock();
 
-	alua_rtpg_queue(pg, sdev, qdata);
+	alua_rtpg_queue(pg, sdev, qdata, true);
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
@@ -916,6 +929,28 @@ out:
 }
 
 /*
+ * alua_check - check path status
+ * @sdev: device on the path to be checked
+ *
+ * Check the device status
+ */
+static void alua_check(struct scsi_device *sdev, bool force)
+{
+	struct alua_dh_data *h = sdev->handler_data;
+	struct alua_port_group *pg;
+
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (!pg || !kref_get_unless_zero(&pg->kref)) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+	alua_rtpg_queue(pg, sdev, NULL, force);
+	kref_put(&pg->kref, release_port_group);
+}
+
+/*
  * alua_prep_fn - request callback
  *
  * Fail I/O to all paths not in state
-- 
1.8.5.6

