From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/20] scsi_dh_alua: Use workqueue for RTPG
Date: Wed,  8 Jul 2015 11:06:14 +0200
Message-ID: <1436346378-96518-17-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934508AbbGHJGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:32 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

The current ALUA device_handler has two drawbacks:
- We're sending a 'SET TARGET PORT GROUP' command to every LUN,
  disregarding the fact that several LUNs might be in a port group
  and will be automatically switched whenever _any_ LUN within
  that port group receives the command.
- Whenever a LUN is in 'transitioning' mode we cannot block I/O
  to that LUN, instead the controller has to abort the command.
  This leads to increased traffic across the wire and heavy load
  on the controller during switchover.

With this patch the RTPG handling is moved to a per-portgroup
workqueue. This reduces the number of 'REPORT TARGET PORT GROUP'
and 'SET TARGET PORT GROUPS' sent to the controller as we're sending
them now per port group, and not per device as previously.
It also allows us to block I/O to any LUN / port group found to be
in 'transitioning' ALUA mode, as the workqueue item will be requeued
until the controller moves out of transitioning.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 412 ++++++++++++++++++++++++-----
 1 file changed, 349 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 88c150a..ea47d15 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -22,6 +22,8 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/rcupdate.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
@@ -59,10 +61,15 @@
 #define ALUA_RTPG_SIZE			128
 #define ALUA_FAILOVER_TIMEOUT		60
 #define ALUA_FAILOVER_RETRIES		5
+#define ALUA_RTPG_DELAY_MSECS		5
 
 /* device handler flags */
-#define ALUA_OPTIMIZE_STPG		1
-#define ALUA_RTPG_EXT_HDR_UNSUPP	2
+#define ALUA_OPTIMIZE_STPG		0x01
+#define ALUA_RTPG_EXT_HDR_UNSUPP	0x02
+/* State machine flags */
+#define ALUA_PG_RUN_RTPG		0x10
+#define ALUA_PG_RUN_STPG		0x20
+
 
 static LIST_HEAD(port_group_list);
 static DEFINE_SPINLOCK(port_group_lock);
@@ -79,13 +86,29 @@ struct alua_port_group {
 	int			pref;
 	unsigned		flags; /* used for optimizing STPG */
 	unsigned char		transition_tmo;
+	unsigned long		expiry;
+	unsigned long		interval;
+	char			work_q_name[264];
+	struct workqueue_struct *work_q;
+	struct delayed_work	rtpg_work;
+	struct delayed_work	stpg_work;
+	struct delayed_work	qdata_work;
+	spinlock_t		rtpg_lock;
+	struct list_head	rtpg_list;
+	struct scsi_device	*rtpg_sdev;
 };
 
 struct alua_dh_data {
 	struct alua_port_group	*pg;
+	spinlock_t		pg_lock;
 	int			rel_port;
 	int			tpgs;
-	struct scsi_device	*sdev;
+	int			error;
+	struct completion       init_complete;
+};
+
+struct alua_queue_data {
+	struct list_head	entry;
 	activate_complete	callback_fn;
 	void			*callback_data;
 };
@@ -94,6 +117,10 @@ struct alua_dh_data {
 #define ALUA_POLICY_SWITCH_ALL		1
 
 static char print_alua_state(int);
+static void alua_rtpg_work(struct work_struct *work);
+static void alua_stpg_work(struct work_struct *work);
+static void alua_qdata_work(struct work_struct *work);
+static void alua_check(struct scsi_device *sdev);
 
 static void release_port_group(struct kref *kref)
 {
@@ -104,6 +131,9 @@ static void release_port_group(struct kref *kref)
 	spin_lock(&port_group_lock);
 	list_del(&pg->node);
 	spin_unlock(&port_group_lock);
+	WARN_ON(pg->rtpg_sdev);
+	if (pg->work_q)
+		destroy_workqueue(pg->work_q);
 	kfree(pg);
 }
 
@@ -374,13 +404,17 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		if (memcmp(tmp_pg->device_id, device_id,
 			   device_id_size))
 			continue;
-		h->pg = tmp_pg;
 		kref_get(&tmp_pg->kref);
+		spin_lock(&h->pg_lock);
+		rcu_assign_pointer(h->pg, tmp_pg);
+		spin_unlock(&h->pg_lock);
 		break;
 	}
 	spin_unlock(&port_group_lock);
-	if (h->pg)
+	if (h->pg) {
+		synchronize_rcu();
 		return SCSI_DH_OK;
+	}
 
 	pg = kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
 	if (!pg) {
@@ -402,6 +436,20 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 	pg->tpgs = h->tpgs;
 	pg->state = TPGS_STATE_OPTIMIZED;
 	kref_init(&pg->kref);
+	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
+	INIT_DELAYED_WORK(&pg->stpg_work, alua_stpg_work);
+	INIT_DELAYED_WORK(&pg->qdata_work, alua_qdata_work);
+	INIT_LIST_HEAD(&pg->rtpg_list);
+	INIT_LIST_HEAD(&pg->node);
+	spin_lock_init(&pg->rtpg_lock);
+	snprintf(pg->work_q_name, sizeof(pg->work_q_name),
+		 "alua_wq_%s_%d", pg->device_id_str, pg->group_id);
+	pg->work_q = create_singlethread_workqueue(pg->work_q_name);
+	if (!pg->work_q) {
+		kref_put(&pg->kref, release_port_group);
+		/* Temporary failure, bypass */
+		return SCSI_DH_DEV_TEMP_BUSY;
+	}
 	spin_lock(&port_group_lock);
 	/*
 	 * Re-check list again to catch
@@ -415,15 +463,19 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 		if (memcmp(tmp_pg->device_id, pg->device_id,
 			   device_id_size))
 			continue;
-		h->pg = tmp_pg;
 		kref_get(&tmp_pg->kref);
+		spin_lock(&h->pg_lock);
+		rcu_assign_pointer(h->pg, tmp_pg);
+		spin_unlock(&h->pg_lock);
 		kfree(pg);
 		pg = NULL;
 		break;
 	}
 	if (pg) {
 		list_add(&pg->node, &port_group_list);
-		h->pg = pg;
+		spin_lock(&h->pg_lock);
+		rcu_assign_pointer(h->pg, pg);
+		spin_unlock(&h->pg_lock);
 	}
 	spin_unlock(&port_group_lock);
 
@@ -457,11 +509,14 @@ static int alua_check_sense(struct scsi_device *sdev,
 {
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a)
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
 			/*
 			 * LUN Not Accessible - ALUA state transition
+			 * Kickoff worker to update internal state.
 			 */
+			alua_check(sdev);
 			return ADD_TO_MLQUEUE;
+		}
 		break;
 	case UNIT_ATTENTION:
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
@@ -510,14 +565,15 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
 	unsigned char *ucp, *buff;
 	unsigned err, retval;
-	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 
-	if (!pg->transition_tmo)
-		expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT * HZ);
-	else
-		expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
+	if (!pg->expiry) {
+		if (!pg->transition_tmo)
+			pg->expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT * HZ);
+		else
+			pg->expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
+	}
 
 	buff = kzalloc(bufflen, GFP_KERNEL);
 	if (!buff)
@@ -538,6 +594,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			else
 				err = SCSI_DH_IO;
 			kfree(buff);
+			pg->expiry = 0;
 			return err;
 		}
 
@@ -564,16 +621,18 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			err = SCSI_DH_RETRY;
 		if (sense_hdr.sense_key == UNIT_ATTENTION)
 			err = SCSI_DH_RETRY;
-		if (err == SCSI_DH_RETRY && time_before(jiffies, expiry)) {
+		if (err == SCSI_DH_RETRY &&
+		    pg->expiry != 0 && time_before(jiffies, pg->expiry)) {
 			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
 				    ALUA_DH_NAME);
 			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
-			goto retry;
+			return err;
 		}
 		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
 			    ALUA_DH_NAME);
 		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
 		kfree(buff);
+		pg->expiry = 0;
 		return SCSI_DH_IO;
 	}
 
@@ -588,6 +647,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: kmalloc buffer failed\n",__func__);
 			/* Temporary failure, bypass */
+			pg->expiry = 0;
 			return SCSI_DH_DEV_TEMP_BUSY;
 		}
 		goto retry;
@@ -603,7 +663,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: transition timeout set to %d seconds\n",
 			    ALUA_DH_NAME, pg->transition_tmo);
-		expiry = jiffies + pg->transition_tmo * HZ;
+		pg->expiry = jiffies + pg->transition_tmo * HZ;
 	}
 
 	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
@@ -637,23 +697,26 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
 	switch (pg->state) {
 	case TPGS_STATE_TRANSITIONING:
-		if (time_before(jiffies, expiry)) {
+		if (time_before(jiffies, pg->expiry)) {
 			/* State transition, retry */
-			interval += 2000;
-			msleep(interval);
-			goto retry;
+			pg->interval = 2;
+			err = SCSI_DH_RETRY;
+		} else {
+			/* Transitioning time exceeded, set port to standby */
+			err = SCSI_DH_IO;
+			pg->state = TPGS_STATE_STANDBY;
+			pg->expiry = 0;
 		}
-		/* Transitioning time exceeded, set port to standby */
-		err = SCSI_DH_RETRY;
-		pg->state = TPGS_STATE_STANDBY;
 		break;
 	case TPGS_STATE_OFFLINE:
 		/* Path unusable */
 		err = SCSI_DH_DEV_OFFLINED;
+		pg->expiry = 0;
 		break;
 	default:
 		/* Useable path if active */
 		err = SCSI_DH_OK;
+		pg->expiry = 0;
 		break;
 	}
 	kfree(buff);
@@ -674,8 +737,8 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	struct scsi_sense_hdr sense_hdr;
 
 	if (!(pg->tpgs & TPGS_MODE_EXPLICIT)) {
-		/* Only implicit ALUA supported, retry */
-		return SCSI_DH_RETRY;
+		/* Only implicit ALUA supported */
+		return SCSI_DH_OK;
 	}
 	switch (pg->state) {
 	case TPGS_STATE_OPTIMIZED:
@@ -701,8 +764,6 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		return SCSI_DH_NOSYS;
 		break;
 	}
-	/* Set state to transitioning */
-	pg->state = TPGS_STATE_TRANSITIONING;
 	retval = submit_stpg(sdev, pg->group_id, sense);
 
 	if (retval) {
@@ -724,6 +785,150 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	return SCSI_DH_RETRY;
 }
 
+static void alua_rtpg_work(struct work_struct *work)
+{
+	struct alua_port_group *pg =
+		container_of(work, struct alua_port_group, rtpg_work.work);
+	struct scsi_device *sdev;
+	int err = SCSI_DH_OK;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pg->rtpg_lock, flags);
+	sdev = pg->rtpg_sdev;
+	if (!sdev) {
+		WARN_ON(pg->flags & ALUA_PG_RUN_RTPG ||
+			pg->flags & ALUA_PG_RUN_STPG);
+		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+		return;
+	}
+	if (pg->flags & ALUA_PG_RUN_RTPG) {
+		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+		err = alua_rtpg(sdev, pg);
+		if (err == SCSI_DH_RETRY) {
+			queue_delayed_work(pg->work_q, &pg->rtpg_work,
+					   pg->interval * HZ);
+			return;
+		}
+		spin_lock_irqsave(&pg->rtpg_lock, flags);
+		pg->flags &= ~ALUA_PG_RUN_RTPG;
+		if (err != SCSI_DH_OK)
+			pg->flags &= ~ALUA_PG_RUN_STPG;
+	}
+	if (pg->flags & ALUA_PG_RUN_STPG) {
+		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+		queue_delayed_work(pg->work_q, &pg->stpg_work, 0);
+		return;
+	}
+	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+	queue_delayed_work(pg->work_q, &pg->qdata_work, 0);
+}
+
+static void alua_stpg_work(struct work_struct *work)
+{
+	struct alua_port_group *pg =
+		container_of(work, struct alua_port_group, stpg_work.work);
+	struct scsi_device *sdev;
+	int err = SCSI_DH_OK;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pg->rtpg_lock, flags);
+	sdev = pg->rtpg_sdev;
+	if (!sdev) {
+		WARN_ON(pg->flags & ALUA_PG_RUN_STPG);
+		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+		return;
+	}
+
+	if (pg->flags & ALUA_PG_RUN_STPG) {
+		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+		err = alua_stpg(sdev, pg);
+		spin_lock_irqsave(&pg->rtpg_lock, flags);
+		pg->flags &= ~ALUA_PG_RUN_STPG;
+		if (err == SCSI_DH_RETRY) {
+			pg->flags |= ALUA_PG_RUN_RTPG;
+			pg->interval = 0;
+		}
+	}
+	if (pg->flags & ALUA_PG_RUN_RTPG) {
+		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+		queue_delayed_work(pg->work_q, &pg->rtpg_work,
+				   msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
+		return;
+	}
+
+	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+	queue_delayed_work(pg->work_q, &pg->qdata_work, 0);
+}
+
+static void alua_qdata_work(struct work_struct *work)
+{
+	struct alua_port_group *pg =
+		container_of(work, struct alua_port_group, qdata_work.work);
+	struct scsi_device *sdev;
+	LIST_HEAD(qdata_list);
+	int err = SCSI_DH_OK;
+	struct alua_queue_data *qdata, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pg->rtpg_lock, flags);
+	sdev = pg->rtpg_sdev;
+	if (WARN_ON(!sdev)) {
+		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+		return;
+	}
+	if (pg->flags & ALUA_PG_RUN_RTPG) {
+		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+		queue_delayed_work(pg->work_q, &pg->rtpg_work,
+				   msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
+		return;
+	}
+
+	list_splice_init(&pg->rtpg_list, &qdata_list);
+	pg->rtpg_sdev = NULL;
+	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+
+	list_for_each_entry_safe(qdata, tmp, &qdata_list, entry) {
+		list_del(&qdata->entry);
+		if (qdata->callback_fn)
+			qdata->callback_fn(qdata->callback_data, err);
+		kfree(qdata);
+	}
+	kref_put(&pg->kref, release_port_group);
+	scsi_device_put(sdev);
+}
+
+static void alua_rtpg_queue(struct alua_port_group *pg,
+			    struct scsi_device *sdev,
+			    struct alua_queue_data *qdata)
+{
+	int start_queue = 0;
+	unsigned long flags;
+
+	if (!pg)
+		return;
+
+	kref_get(&pg->kref);
+	spin_lock_irqsave(&pg->rtpg_lock, flags);
+	if (qdata) {
+		list_add_tail(&qdata->entry, &pg->rtpg_list);
+		pg->flags |= ALUA_PG_RUN_STPG;
+	}
+	if (pg->rtpg_sdev == NULL) {
+		pg->interval = 0;
+		pg->flags |= ALUA_PG_RUN_RTPG;
+		kref_get(&pg->kref);
+		pg->rtpg_sdev = sdev;
+		scsi_device_get(sdev);
+		start_queue = 1;
+	}
+	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+
+	if (start_queue)
+		queue_delayed_work(pg->work_q, &pg->rtpg_work,
+				   msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
+	kref_put(&pg->kref, release_port_group);
+}
+
 /*
  * alua_initialize - Initialize ALUA state
  * @sdev: the device to be initialized
@@ -733,22 +938,33 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
  */
 static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	int err;
-
-	err = alua_check_tpgs(sdev, h);
-	if (err != SCSI_DH_OK)
-		goto out;
-
-	err = alua_check_vpd(sdev, h);
-	if (err != SCSI_DH_OK || !h->pg)
-		goto out;
+	struct alua_port_group *pg = NULL;
 
-	kref_get(&h->pg->kref);
-	err = alua_rtpg(sdev, h->pg, 0);
-	kref_put(&h->pg->kref, release_port_group);
-out:
-	return err;
+	h->error = alua_check_tpgs(sdev, h);
+	if (h->error == SCSI_DH_OK) {
+		h->error = alua_check_vpd(sdev, h);
+		rcu_read_lock();
+		pg = rcu_dereference(h->pg);
+		if (!pg) {
+			rcu_read_unlock();
+			h->tpgs = TPGS_MODE_NONE;
+			if (h->error == SCSI_DH_OK)
+				h->error = SCSI_DH_IO;
+		} else {
+			WARN_ON(h->error != SCSI_DH_OK);
+			kref_get(&pg->kref);
+			rcu_read_unlock();
+		}
+	}
+	complete(&h->init_complete);
+	if (pg) {
+		pg->expiry = 0;
+		alua_rtpg_queue(pg, sdev, NULL);
+		kref_put(&pg->kref, release_port_group);
+	}
+	return h->error;
 }
+
 /*
  * alua_set_params - set/unset the optimize flag
  * @sdev: device on the path to be activated
@@ -765,6 +981,10 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
 	unsigned int optimize = 0, argc;
 	const char *p = params;
 	int result = SCSI_DH_OK;
+	unsigned long flags;
+
+	if (!h)
+		return -ENXIO;
 
 	if ((sscanf(params, "%u", &argc) != 1) || (argc != 1))
 		return -EINVAL;
@@ -782,10 +1002,12 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
 	}
 	rcu_read_unlock();
 
+	spin_lock_irqsave(&pg->rtpg_lock, flags);
 	if (optimize)
 		pg->flags |= ALUA_OPTIMIZE_STPG;
 	else
 		pg->flags |= ~ALUA_OPTIMIZE_STPG;
+	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
 
 	return result;
 }
@@ -809,24 +1031,49 @@ static int alua_activate(struct scsi_device *sdev,
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	int err = SCSI_DH_OK;
+	struct alua_queue_data *qdata;
+	struct alua_port_group *pg;
 
-	if (!h->pg)
+	if (!h) {
+		err = SCSI_DH_NOSYS;
 		goto out;
+	}
 
-	kref_get(&h->pg->kref);
+	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
+	if (!qdata) {
+		err = SCSI_DH_RES_TEMP_UNAVAIL;
+		goto out;
+	}
+	qdata->callback_fn = fn;
+	qdata->callback_data = data;
 
-	if (optimize_stpg)
-		h->pg->flags |= ALUA_OPTIMIZE_STPG;
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (!pg) {
+		rcu_read_unlock();
+		wait_for_completion(&h->init_complete);
+		rcu_read_lock();
+		pg = rcu_dereference(h->pg);
+		if (!pg) {
+			rcu_read_unlock();
+			kfree(qdata);
+			err = h->error;
+			goto out;
+		}
+	}
+	fn = NULL;
+	kref_get(&pg->kref);
+	rcu_read_unlock();
 
-	err = alua_rtpg(sdev, h->pg, 1);
-	if (err != SCSI_DH_OK) {
-		kref_put(&h->pg->kref, release_port_group);
-		goto out;
+	if (optimize_stpg) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&pg->rtpg_lock, flags);
+		pg->flags |= ALUA_OPTIMIZE_STPG;
+		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
 	}
-	err = alua_stpg(sdev, h->pg);
-	if (err == SCSI_DH_RETRY)
-		err = alua_rtpg(sdev, h->pg, 1);
-	kref_put(&h->pg->kref, release_port_group);
+	alua_rtpg_queue(pg, sdev, qdata);
+	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
 		fn(data, err);
@@ -834,6 +1081,28 @@ out:
 }
 
 /*
+ * alua_check - check path status
+ * @sdev: device on the path to be checked
+ *
+ * Check the device status
+ */
+static void alua_check(struct scsi_device *sdev)
+{
+	struct alua_dh_data *h = sdev->handler_data;
+	struct alua_port_group *pg;
+
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (pg) {
+		kref_get(&pg->kref);
+		rcu_read_unlock();
+		alua_rtpg_queue(pg, sdev, NULL);
+		kref_put(&pg->kref, release_port_group);
+	} else
+		rcu_read_unlock();
+}
+
+/*
  * alua_prep_fn - request callback
  *
  * Fail I/O to all paths not in state
@@ -842,14 +1111,22 @@ out:
 static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 {
 	struct alua_dh_data *h = sdev->handler_data;
-	int state;
+	struct alua_port_group *pg;
+	int state = TPGS_STATE_OPTIMIZED;
 	int ret = BLKPREP_OK;
 
-	if (!h->pg)
+	if (!h)
 		return ret;
-	kref_get(&h->pg->kref);
-	state = h->pg->state;
-	kref_put(&h->pg->kref, release_port_group);
+
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (pg) {
+		state = pg->state;
+		/* Defer I/O while rtpg_work is active */
+		if (pg->rtpg_sdev)
+			state = TPGS_STATE_TRANSITIONING;
+	}
+	rcu_read_unlock();
 	if (state == TPGS_STATE_TRANSITIONING)
 		ret = BLKPREP_DEFER;
 	else if (state != TPGS_STATE_OPTIMIZED &&
@@ -874,11 +1151,13 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	h = kzalloc(sizeof(*h) , GFP_KERNEL);
 	if (!h)
 		return -ENOMEM;
+	spin_lock_init(&h->pg_lock);
 	h->tpgs = TPGS_MODE_UNINITIALIZED;
-	h->pg = NULL;
+	rcu_assign_pointer(h->pg, NULL);
 	h->rel_port = -1;
-	h->sdev = sdev;
+	h->error = SCSI_DH_OK;
 
+	init_completion(&h->init_complete);
 	err = alua_initialize(sdev, h);
 	if (err != SCSI_DH_OK && err != SCSI_DH_DEV_OFFLINED)
 		goto failed;
@@ -897,10 +1176,17 @@ failed:
 static void alua_bus_detach(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h = sdev->handler_data;
+	struct alua_port_group *pg;
 
-	if (h->pg) {
-		kref_put(&h->pg->kref, release_port_group);
-		h->pg = NULL;
+	spin_lock(&h->pg_lock);
+	pg = h->pg;
+	rcu_assign_pointer(h->pg, NULL);
+	spin_unlock(&h->pg_lock);
+	synchronize_rcu();
+	if (pg) {
+		if (pg->rtpg_sdev)
+			flush_workqueue(pg->work_q);
+		kref_put(&pg->kref, release_port_group);
 	}
 	sdev->handler_data = NULL;
 	kfree(h);
-- 
1.8.5.2

