From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/17] scsi_dh_alua: Recheck state on unit attention
Date: Mon,  4 May 2015 14:42:21 +0200
Message-ID: <1430743343-47174-16-git-send-email-hare@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbbEDMmn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:43 -0400
In-Reply-To: <1430743343-47174-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When we receive a unit attention code of 'ALUA state changed'
we should recheck the state, as it might be due to an implicit
ALUA state transition.
At the same time a workqueue item might already be queued, which
should be started immediately to avoid any delays.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 65 +++++++++++++++++-------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 142c95b..cf83005 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -69,6 +69,7 @@
 /* State machine flags */
 #define ALUA_PG_RUN_RTPG		0x10
 #define ALUA_PG_RUN_STPG		0x20
+#define ALUA_PG_RUNNING			0x40
 
 
 static LIST_HEAD(port_group_list);
@@ -119,7 +120,7 @@ struct alua_queue_data {
 static char print_alua_state(int);
 static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
 static void alua_rtpg_work(struct work_struct *work);
-static void alua_check(struct scsi_device *sdev);
+static void alua_check(struct scsi_device *sdev, bool force);
 
 static int realloc_buffer(struct alua_port_group *pg, unsigned len)
 {
@@ -487,7 +488,7 @@ static char print_alua_state(int state)
 }
 
 static int alua_check_sense(struct scsi_device *sdev,
-			    struct scsi_sense_hdr *sense_hdr)
+			     struct scsi_sense_hdr *sense_hdr)
 {
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
@@ -496,36 +497,34 @@ static int alua_check_sense(struct scsi_device *sdev,
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
-			 * Mode parameter changed
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
 
@@ -589,7 +588,6 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			goto retry;
 		}
 
-		err = alua_check_sense(sdev, &sense_hdr);
 		if (sense_hdr.sense_key == UNIT_ATTENTION)
 			err = ADD_TO_MLQUEUE;
 		if (err == ADD_TO_MLQUEUE &&
@@ -744,7 +742,6 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			/* Retry RTPG */
 			return err;
 		}
-		err = alua_check_sense(sdev, &sense_hdr);
 		sdev_printk(KERN_INFO, sdev, "%s: stpg failed\n",
 			    ALUA_DH_NAME);
 		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
@@ -771,15 +768,18 @@ static void alua_rtpg_work(struct work_struct *work)
 		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
 		return;
 	}
+	pg->flags |= ALUA_PG_RUNNING;
 	if (pg->flags & ALUA_PG_RUN_RTPG) {
 		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
 		err = alua_rtpg(sdev, pg);
+		spin_lock_irqsave(&pg->rtpg_lock, flags);
 		if (err == SCSI_DH_RETRY) {
+			pg->flags &= ~ALUA_PG_RUNNING;
+			spin_unlock_irqrestore(&pg->rtpg_lock, flags);
 			queue_delayed_work(scsidh_aluad, &pg->rtpg_work,
 					   pg->interval * HZ);
 			return;
 		}
-		spin_lock_irqsave(&pg->rtpg_lock, flags);
 		pg->flags &= ~ALUA_PG_RUN_RTPG;
 		if (err != SCSI_DH_OK)
 			pg->flags &= ~ALUA_PG_RUN_STPG;
@@ -792,6 +792,7 @@ static void alua_rtpg_work(struct work_struct *work)
 		if (err == SCSI_DH_RETRY) {
 			pg->flags |= ALUA_PG_RUN_RTPG;
 			pg->interval = 0;
+			pg->flags &= ~ALUA_PG_RUNNING;
 			spin_unlock_irqrestore(&pg->rtpg_lock, flags);
 			queue_delayed_work(scsidh_aluad, &pg->rtpg_work,
 				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
@@ -809,13 +810,16 @@ static void alua_rtpg_work(struct work_struct *work)
 			qdata->callback_fn(qdata->callback_data, err);
 		kfree(qdata);
 	}
+	spin_lock_irqsave(&pg->rtpg_lock, flags);
+	pg->flags &= ~ALUA_PG_RUNNING;
+	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
 	kref_put(&pg->kref, release_port_group);
 	scsi_device_put(sdev);
 }
 
 static void alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
-			    struct alua_queue_data *qdata)
+			    struct alua_queue_data *qdata, bool force)
 {
 	int start_queue = 0;
 	unsigned long flags;
@@ -836,12 +840,15 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		pg->rtpg_sdev = sdev;
 		scsi_device_get(sdev);
 		start_queue = 1;
-	}
+	} else if (!(pg->flags & ALUA_PG_RUNNING) && force)
+		start_queue = 1;
+
 	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
 
 	if (start_queue)
-		queue_delayed_work(scsidh_aluad, &pg->rtpg_work,
-				   msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
+		mod_delayed_work(scsidh_aluad, &pg->rtpg_work,
+				 msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
+
 	kref_put(&pg->kref, release_port_group);
 }
 
@@ -874,7 +881,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 	complete(&h->init_complete);
 	if (pg) {
 		pg->expiry = 0;
-		alua_rtpg_queue(pg, sdev, NULL);
+		alua_rtpg_queue(pg, sdev, NULL, true);
 		kref_put(&pg->kref, release_port_group);
 	}
 	return h->error;
@@ -986,7 +993,7 @@ static int alua_activate(struct scsi_device *sdev,
 		pg->flags |= ALUA_OPTIMIZE_STPG;
 		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
 	}
-	alua_rtpg_queue(pg, sdev, qdata);
+	alua_rtpg_queue(pg, sdev, qdata, true);
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
@@ -1000,7 +1007,7 @@ out:
  *
  * Check the device status
  */
-static void alua_check(struct scsi_device *sdev)
+static void alua_check(struct scsi_device *sdev, bool force)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	struct alua_port_group *pg;
@@ -1010,7 +1017,7 @@ static void alua_check(struct scsi_device *sdev)
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

