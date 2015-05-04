From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/17] scsi_dh_alua: Use workqueue for RTPG
Date: Mon,  4 May 2015 14:42:20 +0200
Message-ID: <1430743343-47174-15-git-send-email-hare@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbbEDMml (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:41 -0400
In-Reply-To: <1430743343-47174-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

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
 drivers/scsi/device_handler/scsi_dh_alua.c | 343 +++++++++++++++++++++++------
 1 file changed, 280 insertions(+), 63 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 2a5e2b2..142c95b 100644
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
@@ -59,13 +61,19 @@
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
+
 
 static LIST_HEAD(port_group_list);
 static DEFINE_SPINLOCK(port_group_lock);
+static struct workqueue_struct *scsidh_aluad;
 
 struct alua_port_group {
 	struct kref		kref;
@@ -82,13 +90,25 @@ struct alua_port_group {
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
@@ -98,6 +118,8 @@ struct alua_dh_data {
 
 static char print_alua_state(int);
 static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
+static void alua_rtpg_work(struct work_struct *work);
+static void alua_check(struct scsi_device *sdev);
 
 static int realloc_buffer(struct alua_port_group *pg, unsigned len)
 {
@@ -399,9 +421,12 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
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
 		return SCSI_DH_OK;
 	}
 	pg = kzalloc(sizeof(struct alua_port_group), GFP_ATOMIC);
@@ -427,9 +452,14 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h)
 	pg->tpgs = h->tpgs;
 	pg->state = TPGS_STATE_OPTIMIZED;
 	kref_init(&pg->kref);
+	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
+	INIT_LIST_HEAD(&pg->rtpg_list);
+	spin_lock_init(&pg->rtpg_lock);
 	list_add(&pg->node, &port_group_list);
-	h->pg = pg;
 	spin_unlock(&port_group_lock);
+	spin_lock(&h->pg_lock);
+	rcu_assign_pointer(h->pg, pg);
+	spin_unlock(&h->pg_lock);
 
 	return SCSI_DH_OK;
 }
@@ -461,11 +491,14 @@ static int alua_check_sense(struct scsi_device *sdev,
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
@@ -514,15 +547,15 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
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
 
@@ -537,6 +570,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 				err = SCSI_DH_DEV_TEMP_BUSY;
 			else
 				err = SCSI_DH_IO;
+			pg->expiry = 0;
 			return err;
 		}
 
@@ -558,15 +592,17 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		err = alua_check_sense(sdev, &sense_hdr);
 		if (sense_hdr.sense_key == UNIT_ATTENTION)
 			err = ADD_TO_MLQUEUE;
-		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
+		if (err == ADD_TO_MLQUEUE &&
+		    pg->expiry != 0 && time_before(jiffies, pg->expiry)) {
 			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
 				    ALUA_DH_NAME);
 			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
-			goto retry;
+			return SCSI_DH_RETRY;
 		}
 		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
 			    ALUA_DH_NAME);
 		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
+		pg->expiry = 0;
 		return SCSI_DH_IO;
 	}
 
@@ -579,6 +615,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: kmalloc buffer failed\n",__func__);
 			/* Temporary failure, bypass */
+			pg->expiry = 0;
 			return SCSI_DH_DEV_TEMP_BUSY;
 		}
 		goto retry;
@@ -595,7 +632,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: transition timeout set to %d seconds\n",
 			    ALUA_DH_NAME, pg->transition_tmo);
-		expiry = jiffies + pg->transition_tmo * HZ;
+		pg->expiry = jiffies + pg->transition_tmo * HZ;
 	}
 
 	if ((pg->buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
@@ -629,23 +666,26 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
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
 	return err;
@@ -665,8 +705,8 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	struct scsi_sense_hdr sense_hdr;
 
 	if (!(pg->tpgs & TPGS_MODE_EXPLICIT)) {
-		/* Only implicit ALUA supported, retry */
-		return SCSI_DH_RETRY;
+		/* Only implicit ALUA supported */
+		return SCSI_DH_OK;
 	}
 	switch (pg->state) {
 	case TPGS_STATE_OPTIMIZED:
@@ -692,8 +732,6 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		return SCSI_DH_NOSYS;
 		break;
 	}
-	/* Set state to transitioning */
-	pg->state = TPGS_STATE_TRANSITIONING;
 	retval = submit_stpg(sdev, pg->group_id, sense);
 
 	if (retval) {
@@ -715,6 +753,98 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	return err;
 }
 
+static void alua_rtpg_work(struct work_struct *work)
+{
+	struct alua_port_group *pg =
+		container_of(work, struct alua_port_group, rtpg_work.work);
+	struct scsi_device *sdev;
+	LIST_HEAD(qdata_list);
+	int err = SCSI_DH_OK;
+	struct alua_queue_data *qdata, *tmp;
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
+			queue_delayed_work(scsidh_aluad, &pg->rtpg_work,
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
+		err = alua_stpg(sdev, pg);
+		spin_lock_irqsave(&pg->rtpg_lock, flags);
+		pg->flags &= ~ALUA_PG_RUN_STPG;
+		if (err == SCSI_DH_RETRY) {
+			pg->flags |= ALUA_PG_RUN_RTPG;
+			pg->interval = 0;
+			spin_unlock_irqrestore(&pg->rtpg_lock, flags);
+			queue_delayed_work(scsidh_aluad, &pg->rtpg_work,
+				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
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
+		queue_delayed_work(scsidh_aluad, &pg->rtpg_work,
+				   msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
+	kref_put(&pg->kref, release_port_group);
+}
+
 /*
  * alua_initialize - Initialize ALUA state
  * @sdev: the device to be initialized
@@ -724,22 +854,32 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
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
@@ -756,6 +896,10 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
 	unsigned int optimize = 0, argc;
 	const char *p = params;
 	int result = SCSI_DH_OK;
+	unsigned long flags;
+
+	if (!h)
+		return -ENXIO;
 
 	if ((sscanf(params, "%u", &argc) != 1) || (argc != 1))
 		return -EINVAL;
@@ -773,10 +917,12 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
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
@@ -800,24 +946,48 @@ static int alua_activate(struct scsi_device *sdev,
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
+		err = SCSI_DH_NOSYS;
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
@@ -825,6 +995,28 @@ out:
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
@@ -833,14 +1025,22 @@ out:
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
@@ -865,11 +1065,13 @@ static int alua_bus_attach(struct scsi_device *sdev)
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
@@ -888,10 +1090,17 @@ failed:
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
+			flush_workqueue(scsidh_aluad);
+		kref_put(&pg->kref, release_port_group);
 	}
 	kfree(h);
 }
@@ -911,16 +1120,24 @@ static int __init alua_init(void)
 {
 	int r;
 
+	scsidh_aluad = create_singlethread_workqueue("scsi_dh_aluad");
+	if (!scsidh_aluad) {
+		printk(KERN_ERR "scsi_dh_aluad creation failed.\n");
+		return -EINVAL;
+	}
 	r = scsi_register_device_handler(&alua_dh);
-	if (r != 0)
+	if (r != 0) {
 		printk(KERN_ERR "%s: Failed to register scsi device handler",
 			ALUA_DH_NAME);
+		destroy_workqueue(scsidh_aluad);
+	}
 	return r;
 }
 
 static void __exit alua_exit(void)
 {
 	scsi_unregister_device_handler(&alua_dh);
+	destroy_workqueue(scsidh_aluad);
 }
 
 module_init(alua_init);
-- 
1.8.5.2

