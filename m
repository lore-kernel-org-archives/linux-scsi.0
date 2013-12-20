From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/16] scsi_dh_alua: Use workqueue for RTPG
Date: Fri, 20 Dec 2013 13:13:41 +0100
Message-ID: <1387541621-54967-17-git-send-email-hare@suse.de>
References: <1387541621-54967-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab3LTMNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 07:13:45 -0500
In-Reply-To: <1387541621-54967-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, Hannes Reinecke <hare@suse.de>

The current ALUA device_handler has two drawbacks:
- We're sending a 'SET TARGET PORT GROUP' command to every LUN,
  disregarding the fact that several LUNs might be in a port group
  and will be automatically switched whenever _any_ LUN within
  that port group receives the command.
- Whenever a LUN is in 'transitioning' mode we cannot block I/O
  to that LUN, instead the controller has to abort the command.
  This leads to increased traffic across the wire and heavy load
  on the controller during switchover.

With this patch the RTPG handling is moved to a workqueue, which
is being run once per port group. This reduces the number of
'REPORT TARGET PORT GROUP' and 'SET TARGET PORT GROUPS' which
will be send to the controller. It also allows us to block
I/O to any LUN / port group found to be in 'transitioning' ALUA
mode, as the workqueue item will be requeued until the controller
moves out of transitioning.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 389 ++++++++++++++++++++++-------
 1 file changed, 304 insertions(+), 85 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e6b2565..1493291 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -22,6 +22,8 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/rcupdate.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
@@ -58,13 +60,20 @@
 #define ALUA_INQUIRY_SIZE		36
 #define ALUA_FAILOVER_TIMEOUT		60
 #define ALUA_FAILOVER_RETRIES		5
+#define ALUA_RTPG_DELAY_MSECS		5
 
 /* flags passed from user level */
-#define ALUA_OPTIMIZE_STPG		1
-#define ALUA_RTPG_EXT_HDR_UNSUPP	2
+#define ALUA_OPTIMIZE_STPG		0x01
+#define ALUA_RTPG_EXT_HDR_UNSUPP	0x02
+/* State machine flags */
+#define ALUA_PG_RUN_RTPG		0x10
+#define ALUA_PG_RUN_STPG		0x20
+#define ALUA_PG_STPG_DONE		0x40
+
 
 static LIST_HEAD(port_group_list);
 static DEFINE_SPINLOCK(port_group_lock);
+static struct workqueue_struct *kmpath_aluad;
 
 struct alua_port_group {
 	struct kref		kref;
@@ -81,14 +90,26 @@ struct alua_port_group {
 	unsigned char		*buff;
 	int			bufflen;
 	unsigned char		transition_tmo;
+	unsigned long		expiry;
+	unsigned long		interval;
+	struct delayed_work	rtpg_work;
+	spinlock_t		rtpg_lock;
+	struct list_head	rtpg_list;
+	struct scsi_device	*rtpg_sdev;
 };
 
 struct alua_dh_data {
 	struct alua_port_group	*pg;
+	spinlock_t		pg_lock;
 	int			rel_port;
 	int			tpgs;
+	int			error;
 	unsigned		flags; /* used for optimizing STPG */
-	struct scsi_device	*sdev;
+	struct completion       init_complete;
+};
+
+struct alua_queue_data {
+	struct list_head	entry;
 	activate_complete	callback_fn;
 	void			*callback_data;
 };
@@ -98,11 +119,13 @@ struct alua_dh_data {
 
 static char print_alua_state(int);
 static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
+static void alua_rtpg_work(struct work_struct *work);
+static void alua_check(struct scsi_device *sdev);
 
 static inline struct alua_dh_data *get_alua_data(struct scsi_device *sdev)
 {
 	struct scsi_dh_data *scsi_dh_data = sdev->scsi_dh_data;
-	BUG_ON(scsi_dh_data == NULL);
+
 	return ((struct alua_dh_data *) scsi_dh_data->buf);
 }
 
@@ -570,9 +593,12 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 			    ALUA_DH_NAME, group_id, h->rel_port);
 	}
 	if (pg) {
-		h->pg = pg;
 		kref_get(&pg->kref);
 		spin_unlock(&port_group_lock);
+		spin_lock(&h->pg_lock);
+		rcu_assign_pointer(h->pg, pg);
+		spin_unlock(&h->pg_lock);
+		synchronize_rcu();
 		err = SCSI_DH_OK;
 		goto out;
 	}
@@ -601,9 +627,17 @@ static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 	pg->state = TPGS_STATE_OPTIMIZED;
 	pg->flags = h->flags;
 	kref_init(&pg->kref);
+	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
+	INIT_LIST_HEAD(&pg->rtpg_list);
+	spin_lock_init(&pg->rtpg_lock);
 	list_add(&pg->node, &port_group_list);
-	h->pg = pg;
+	kref_get(&pg->kref);
 	spin_unlock(&port_group_lock);
+	spin_lock(&h->pg_lock);
+	rcu_assign_pointer(h->pg, pg);
+	spin_unlock(&h->pg_lock);
+	kref_put(&pg->kref, release_port_group);
+	synchronize_rcu();
 	err = SCSI_DH_OK;
 out:
 	kfree(buff);
@@ -637,11 +671,14 @@ static int alua_check_sense(struct scsi_device *sdev,
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
@@ -690,15 +727,15 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
 	unsigned err, retval;
-	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 
-	if (!pg->transition_tmo)
-		expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT * HZ);
-	else
-		expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
-
+	if (!pg->expiry) {
+		if (!pg->transition_tmo)
+			pg->expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT * HZ);
+		else
+			pg->expiry = round_jiffies_up(jiffies + pg->transition_tmo * HZ);
+	}
  retry:
 	retval = submit_rtpg(sdev, pg->buff, pg->bufflen, sense, pg->flags);
 
@@ -713,6 +750,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 				err = SCSI_DH_DEV_TEMP_BUSY;
 			else
 				err = SCSI_DH_IO;
+			pg->expiry = 0;
 			return err;
 		}
 
@@ -734,14 +772,15 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		err = alua_check_sense(sdev, &sense_hdr);
 		if (sense_hdr.sense_key == UNIT_ATTENTION)
 			err = ADD_TO_MLQUEUE;
-		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
+		if (err == ADD_TO_MLQUEUE &&
+		    pg->expiry != 0 && time_before(jiffies, pg->expiry)) {
 			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry, ",
 				    ALUA_DH_NAME);
 			scsi_show_sense_hdr(&sense_hdr);
 			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry, ",
 				    ALUA_DH_NAME);
 			scsi_show_extd_sense(sense_hdr.asc, sense_hdr.ascq);
-			goto retry;
+			return SCSI_DH_RETRY;
 		}
 		sdev_printk(KERN_INFO, sdev, "%s: rtpg failed, ",
 			    ALUA_DH_NAME);
@@ -749,6 +788,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		sdev_printk(KERN_INFO, sdev, "%s: rtpg failed, ",
 			    ALUA_DH_NAME);
 		scsi_show_extd_sense(sense_hdr.asc, sense_hdr.ascq);
+		pg->expiry = 0;
 		return SCSI_DH_IO;
 	}
 
@@ -761,6 +801,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: kmalloc buffer failed\n",__func__);
 			/* Temporary failure, bypass */
+			pg->expiry = 0;
 			return SCSI_DH_DEV_TEMP_BUSY;
 		}
 		goto retry;
@@ -774,10 +815,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
 
 	if (orig_transition_tmo != pg->transition_tmo) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: transition timeout set to %d seconds\n",
-			    ALUA_DH_NAME, pg->transition_tmo);
-		expiry = jiffies + pg->transition_tmo * HZ;
+		printk(KERN_INFO
+		       "%s: target %s transition timeout set to %d seconds\n",
+		       ALUA_DH_NAME, pg->target_id_str, pg->transition_tmo);
+		pg->expiry = jiffies + pg->transition_tmo * HZ;
 	}
 
 	if ((pg->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
@@ -797,37 +838,40 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		off = 8 + (ucp[7] * 4);
 	}
 
-	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
-		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
-		    pg->pref ? "preferred" : "non-preferred",
-		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
-		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
-		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
-		    valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
-		    valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
-		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
-		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
+	printk(KERN_INFO "%s: target %s port group %02x state %c %s "
+	       "supports %c%c%c%c%c%c%c\n", ALUA_DH_NAME, pg->target_id_str,
+	       pg->group_id, print_alua_state(pg->state),
+	       pg->pref ? "preferred" : "non-preferred",
+	       valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
+	       valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
+	       valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
+	       valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
+	       valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
+	       valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
+	       valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
 
 	switch (pg->state) {
 	case TPGS_STATE_TRANSITIONING:
-		if (time_before(jiffies, expiry)) {
+		if (time_before(jiffies, pg->expiry)) {
 			/* State transition, retry */
-			interval += 2000;
-			msleep(interval);
-			goto retry;
+			pg->interval += 2;
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
 	return err;
@@ -847,8 +891,8 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	struct scsi_sense_hdr sense_hdr;
 
 	if (!(pg->tpgs & TPGS_MODE_EXPLICIT)) {
-		/* Only implicit ALUA supported, retry */
-		return SCSI_DH_RETRY;
+		/* Only implicit ALUA supported */
+		return SCSI_DH_OK;
 	}
 	switch (pg->state) {
 	case TPGS_STATE_OPTIMIZED:
@@ -873,8 +917,6 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			    ALUA_DH_NAME, pg->state);
 		return SCSI_DH_NOSYS;
 	}
-	/* Set state to transitioning */
-	pg->state = TPGS_STATE_TRANSITIONING;
 	retval = submit_stpg(sdev, pg->group_id, sense);
 
 	if (retval) {
@@ -899,6 +941,102 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	return err;
 }
 
+static void alua_rtpg_work(struct work_struct *work)
+{
+	struct alua_port_group *pg =
+		container_of(work, struct alua_port_group, rtpg_work.work);
+	struct scsi_device *sdev = pg->rtpg_sdev;
+	LIST_HEAD(qdata_list);
+	int err = SCSI_DH_OK;
+	struct alua_queue_data *qdata, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pg->rtpg_lock, flags);
+	if (pg->flags & ALUA_PG_RUN_RTPG) {
+		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+		err = alua_rtpg(sdev, pg);
+		if (err == SCSI_DH_RETRY) {
+			queue_delayed_work(kmpath_aluad, &pg->rtpg_work,
+					   pg->interval * HZ);
+			return;
+		}
+		spin_lock_irqsave(&pg->rtpg_lock, flags);
+		pg->flags &= ~ALUA_PG_RUN_RTPG;
+	}
+	if (pg->flags & ALUA_PG_RUN_STPG) {
+		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+		err = alua_stpg(sdev, pg);
+		spin_lock_irqsave(&pg->rtpg_lock, flags);
+		pg->flags &= ~ALUA_PG_RUN_STPG;
+		pg->flags |= ALUA_PG_STPG_DONE;
+		if (err == SCSI_DH_RETRY) {
+			pg->flags |= ALUA_PG_RUN_RTPG;
+			pg->interval = ALUA_RTPG_DELAY_MSECS * 1000;
+			spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+			queue_delayed_work(kmpath_aluad, &pg->rtpg_work,
+					   pg->interval * HZ);
+			return;
+		}
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
+	if (qdata)
+		list_add_tail(&qdata->entry, &pg->rtpg_list);
+	if (pg->rtpg_sdev == NULL) {
+		pg->interval = 0;
+		pg->flags &= ~ALUA_PG_STPG_DONE;
+		pg->flags |= ALUA_PG_RUN_RTPG;
+		if (qdata)
+			pg->flags |= ALUA_PG_RUN_STPG;
+
+		kref_get(&pg->kref);
+		pg->rtpg_sdev = sdev;
+		scsi_device_get(sdev);
+		start_queue = 1;
+	} else {
+		/*
+		 * RTPG update is already queued.
+		 * Check if STPG is scheduled or done,
+		 * and set the STPG flag if not.
+		 */
+		if (qdata &&
+		    !(pg->flags & ALUA_PG_RUN_STPG) &&
+		    !(pg->flags & ALUA_PG_STPG_DONE))
+			pg->flags |= ALUA_PG_RUN_STPG;
+	}
+	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+
+	if (start_queue)
+		queue_delayed_work(kmpath_aluad, &pg->rtpg_work,
+				   msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
+	kref_put(&pg->kref, release_port_group);
+}
+
 /*
  * alua_initialize - Initialize ALUA state
  * @sdev: the device to be initialized
@@ -908,21 +1046,30 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
  */
 static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 {
-	int err;
-
-	err = alua_check_tpgs(sdev, h);
-	if (err != SCSI_DH_OK)
-		goto out;
-
-	err = alua_vpd_inquiry(sdev, h);
-	if (err != SCSI_DH_OK || !h->pg)
-		goto out;
-
-	kref_get(&h->pg->kref);
-	err = alua_rtpg(sdev, h->pg);
-	kref_put(&h->pg->kref, release_port_group);
-out:
-	return err;
+	struct alua_port_group *pg = NULL;
+
+	h->error = alua_check_tpgs(sdev, h);
+	if (h->error == SCSI_DH_OK) {
+		h->error = alua_vpd_inquiry(sdev, h);
+		rcu_read_lock();
+		pg = rcu_dereference(h->pg);
+		if (!pg) {
+			rcu_read_unlock();
+			h->tpgs = TPGS_MODE_NONE;
+			if (h->error == SCSI_DH_OK)
+				h->error = SCSI_DH_IO;
+		} else {
+			kref_get(&pg->kref);
+			rcu_read_unlock();
+		}
+	}
+	complete(&h->init_complete);
+	if (pg) {
+		pg->expiry = 0;
+		alua_rtpg_queue(pg, sdev, NULL);
+	}
+	kref_put(&pg->kref, release_port_group);
+	return h->error;
 }
 
 /*
@@ -941,6 +1088,9 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
 	const char *p = params;
 	int result = SCSI_DH_OK;
 
+	if (!h)
+		return -ENXIO;
+
 	if ((sscanf(params, "%u", &argc) != 1) || (argc != 1))
 		return -EINVAL;
 
@@ -975,31 +1125,77 @@ static int alua_activate(struct scsi_device *sdev,
 			activate_complete fn, void *data)
 {
 	struct alua_dh_data *h = get_alua_data(sdev);
-	int err = SCSI_DH_OK;
+	struct alua_queue_data *qdata;
+	struct alua_port_group *pg;
 
-	if (!h->pg)
-		goto out;
+	if (!h) {
+		if (fn)
+			fn(data, SCSI_DH_NOSYS);
+		return 0;
+	}
 
 	if (optimize_stpg)
 		h->flags |= ALUA_OPTIMIZE_STPG;
 
-	kref_get(&h->pg->kref);
-	err = alua_rtpg(sdev, h->pg);
-	if (err != SCSI_DH_OK) {
-		kref_put(&h->pg->kref, release_port_group);
-		goto out;
+	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
+	if (!qdata) {
+		if (fn)
+			fn(data, SCSI_DH_RETRY);
+		return 0;
 	}
-	err = alua_stpg(sdev, h->pg);
-	if (err == SCSI_DH_RETRY)
-		err = alua_rtpg(sdev, h->pg);
-	kref_put(&h->pg->kref, release_port_group);
-out:
-	if (fn)
-		fn(data, err);
+
+	qdata->callback_fn = fn;
+	qdata->callback_data = data;
+
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
+			if (fn)
+				fn(data, h->error);
+			return 0;
+		}
+	}
+	kref_get(&pg->kref);
+	rcu_read_unlock();
+
+	alua_rtpg_queue(pg, sdev, qdata);
+	kref_put(&pg->kref, release_port_group);
 	return 0;
 }
 
 /*
+ * alua_check - check path status
+ * @sdev: device on the path to be checked
+ *
+ * Check the device status
+ */
+static void alua_check(struct scsi_device *sdev)
+{
+	struct alua_dh_data *h = get_alua_data(sdev);
+	struct alua_port_group *pg;
+
+	if (!h)
+		return;
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
@@ -1008,14 +1204,22 @@ out:
 static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 {
 	struct alua_dh_data *h = get_alua_data(sdev);
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
@@ -1069,11 +1273,12 @@ static int alua_bus_attach(struct scsi_device *sdev)
 
 	scsi_dh_data->scsi_dh = &alua_dh;
 	h = (struct alua_dh_data *) scsi_dh_data->buf;
+	spin_lock_init(&h->pg_lock);
 	h->tpgs = TPGS_MODE_UNINITIALIZED;
-	h->pg = NULL;
+	rcu_assign_pointer(h->pg, NULL);
 	h->rel_port = -1;
-	h->sdev = sdev;
-
+	h->error = SCSI_DH_OK;
+	init_completion(&h->init_complete);
 	err = alua_initialize(sdev, h);
 	if ((err != SCSI_DH_OK) && (err != SCSI_DH_DEV_OFFLINED))
 		goto failed;
@@ -1102,17 +1307,23 @@ static void alua_bus_detach(struct scsi_device *sdev)
 {
 	struct scsi_dh_data *scsi_dh_data;
 	struct alua_dh_data *h;
+	struct alua_port_group *pg = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	scsi_dh_data = sdev->scsi_dh_data;
 	sdev->scsi_dh_data = NULL;
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
-
 	h = (struct alua_dh_data *) scsi_dh_data->buf;
-	if (h->pg) {
-		kref_put(&h->pg->kref, release_port_group);
-		h->pg = NULL;
+	spin_lock(&h->pg_lock);
+	pg = h->pg;
+	rcu_assign_pointer(h->pg, NULL);
+	spin_unlock(&h->pg_lock);
+	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+	synchronize_rcu();
+	if (pg) {
+		if (pg->rtpg_sdev)
+			flush_workqueue(kmpath_aluad);
+		kref_put(&pg->kref, release_port_group);
 	}
 	kfree(scsi_dh_data);
 	module_put(THIS_MODULE);
@@ -1123,16 +1334,24 @@ static int __init alua_init(void)
 {
 	int r;
 
+	kmpath_aluad = create_singlethread_workqueue("kmpath_aluad");
+	if (!kmpath_aluad) {
+		printk(KERN_ERR "kmpath_aluad creation failed.\n");
+		return -EINVAL;
+	}
 	r = scsi_register_device_handler(&alua_dh);
-	if (r != 0)
+	if (r != 0) {
 		printk(KERN_ERR "%s: Failed to register scsi device handler",
 			ALUA_DH_NAME);
+		destroy_workqueue(kmpath_aluad);
+	}
 	return r;
 }
 
 static void __exit alua_exit(void)
 {
 	scsi_unregister_device_handler(&alua_dh);
+	destroy_workqueue(kmpath_aluad);
 }
 
 module_init(alua_init);
-- 
1.7.12.4

