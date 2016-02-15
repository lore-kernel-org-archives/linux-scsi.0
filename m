From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv7 16/23] scsi_dh_alua: Recheck state on unit attention
Date: Mon, 15 Feb 2016 09:24:43 +0100
Message-ID: <1455524690-121073-17-git-send-email-hare@suse.de>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbcBOIY5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Feb 2016 03:24:57 -0500
In-Reply-To: <1455524690-121073-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When we receive a unit attention code of 'ALUA state changed'
we should recheck the state, as it might be due to an implicit
ALUA state transition. This allows us to return NEEDS_RETRY
instead of ADD_TO_MLQUEUE, allowing to terminate the retries
after a certain time.
At the same time a workqueue item might already be queued, which
should be started immediately to avoid any delays.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 67 ++++++++++++++++++++++++------
 1 file changed, 55 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 9d5a861..c09a523 100644
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
@@ -368,7 +369,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 	}
 	if (sdev->synchronous_alua)
 		pg->flags |= ALUA_SYNC_STPG;
-	alua_rtpg_queue(h->pg, sdev, NULL);
+	alua_rtpg_queue(h->pg, sdev, NULL, true);
 	spin_unlock(&h->pg_lock);
 
 	if (old_pg)
@@ -404,18 +405,24 @@ static int alua_check_sense(struct scsi_device *sdev,
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
@@ -426,16 +433,20 @@ static int alua_check_sense(struct scsi_device *sdev,
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
@@ -710,7 +721,7 @@ static void alua_rtpg_work(struct work_struct *work)
 		spin_unlock_irqrestore(&pg->lock, flags);
 		err = alua_rtpg(sdev, pg);
 		spin_lock_irqsave(&pg->lock, flags);
-		if (err == SCSI_DH_RETRY) {
+		if (err == SCSI_DH_RETRY || pg->flags & ALUA_PG_RUN_RTPG) {
 			pg->flags &= ~ALUA_PG_RUNNING;
 			pg->flags |= ALUA_PG_RUN_RTPG;
 			spin_unlock_irqrestore(&pg->lock, flags);
@@ -726,7 +737,7 @@ static void alua_rtpg_work(struct work_struct *work)
 		spin_unlock_irqrestore(&pg->lock, flags);
 		err = alua_stpg(sdev, pg);
 		spin_lock_irqsave(&pg->lock, flags);
-		if (err == SCSI_DH_RETRY) {
+		if (err == SCSI_DH_RETRY || pg->flags & ALUA_PG_RUN_RTPG) {
 			pg->flags |= ALUA_PG_RUN_RTPG;
 			pg->interval = 0;
 			pg->flags &= ~ALUA_PG_RUNNING;
@@ -756,7 +767,7 @@ static void alua_rtpg_work(struct work_struct *work)
 
 static void alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
-			    struct alua_queue_data *qdata)
+			    struct alua_queue_data *qdata, bool force)
 {
 	int start_queue = 0;
 	unsigned long flags;
@@ -769,6 +780,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 	if (qdata) {
 		list_add_tail(&qdata->entry, &pg->rtpg_list);
 		pg->flags |= ALUA_PG_RUN_STPG;
+		force = true;
 	}
 	if (pg->rtpg_sdev == NULL) {
 		pg->interval = 0;
@@ -777,7 +789,15 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		pg->rtpg_sdev = sdev;
 		scsi_device_get(sdev);
 		start_queue = 1;
+	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force) {
+		pg->flags |= ALUA_PG_RUN_RTPG;
+		/* Do not queue if the worker is already running */
+		if (!(pg->flags & ALUA_PG_RUNNING)) {
+			kref_get(&pg->kref);
+			start_queue = 1;
+		}
 	}
+
 	if (pg->flags & ALUA_SYNC_STPG)
 		alua_wq = kaluad_sync_wq;
 	spin_unlock_irqrestore(&pg->lock, flags);
@@ -892,7 +912,7 @@ static int alua_activate(struct scsi_device *sdev,
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
-	alua_rtpg_queue(pg, sdev, qdata);
+	alua_rtpg_queue(pg, sdev, qdata, true);
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
@@ -901,6 +921,29 @@ out:
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
+
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

