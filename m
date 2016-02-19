From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 13/23] scsi_dh_alua: Use workqueue for RTPG
Date: Fri, 19 Feb 2016 09:17:10 +0100
Message-ID: <1455869840-122786-14-git-send-email-hare@suse.de>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1427064AbcBSIRu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 03:17:50 -0500
In-Reply-To: <1455869840-122786-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

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

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 296 +++++++++++++++++++++++------
 1 file changed, 242 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 7a351cf..8318852 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -59,10 +59,15 @@
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
+#define ALUA_PG_RUNNING			0x40
 
 static uint optimize_stpg;
 module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR);
@@ -70,9 +75,11 @@ MODULE_PARM_DESC(optimize_stpg, "Allow use of a non-optimized path, rather than
 
 static LIST_HEAD(port_group_list);
 static DEFINE_SPINLOCK(port_group_lock);
+static struct workqueue_struct *kaluad_wq;
 
 struct alua_port_group {
 	struct kref		kref;
+	struct rcu_head		rcu;
 	struct list_head	node;
 	unsigned char		device_id_str[256];
 	int			device_id_len;
@@ -82,12 +89,25 @@ struct alua_port_group {
 	int			pref;
 	unsigned		flags; /* used for optimizing STPG */
 	unsigned char		transition_tmo;
+	unsigned long		expiry;
+	unsigned long		interval;
+	struct delayed_work	rtpg_work;
+	spinlock_t		lock;
+	struct list_head	rtpg_list;
+	struct scsi_device	*rtpg_sdev;
 };
 
 struct alua_dh_data {
 	struct alua_port_group	*pg;
 	int			group_id;
+	spinlock_t		pg_lock;
 	struct scsi_device	*sdev;
+	int			init_error;
+	struct mutex		init_mutex;
+};
+
+struct alua_queue_data {
+	struct list_head	entry;
 	activate_complete	callback_fn;
 	void			*callback_data;
 };
@@ -95,18 +115,22 @@ struct alua_dh_data {
 #define ALUA_POLICY_SWITCH_CURRENT	0
 #define ALUA_POLICY_SWITCH_ALL		1
 
-static int alua_rtpg(struct scsi_device *, struct alua_port_group *);
-static char print_alua_state(int);
+static void alua_rtpg_work(struct work_struct *work);
+static void alua_rtpg_queue(struct alua_port_group *pg,
+			    struct scsi_device *sdev,
+			    struct alua_queue_data *qdata);
 
 static void release_port_group(struct kref *kref)
 {
 	struct alua_port_group *pg;
 
 	pg = container_of(kref, struct alua_port_group, kref);
+	if (pg->rtpg_sdev)
+		flush_delayed_work(&pg->rtpg_work);
 	spin_lock(&port_group_lock);
 	list_del(&pg->node);
 	spin_unlock(&port_group_lock);
-	kfree(pg);
+	kfree_rcu(pg, rcu);
 }
 
 /*
@@ -225,6 +249,10 @@ struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
 	if (optimize_stpg)
 		pg->flags |= ALUA_OPTIMIZE_STPG;
 	kref_init(&pg->kref);
+	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
+	INIT_LIST_HEAD(&pg->rtpg_list);
+	INIT_LIST_HEAD(&pg->node);
+	spin_lock_init(&pg->lock);
 
 	spin_lock(&port_group_lock);
 	tmp_pg = alua_find_get_pg(pg->device_id_str, pg->device_id_len,
@@ -304,6 +332,7 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 			  int tpgs)
 {
 	int rel_port = -1, group_id;
+	struct alua_port_group *pg, *old_pg = NULL;
 
 	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
 	if (group_id < 0) {
@@ -318,18 +347,30 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 		return SCSI_DH_DEV_UNSUPP;
 	}
 
-	h->pg = alua_alloc_pg(sdev, group_id, tpgs);
-	if (IS_ERR(h->pg)) {
-		if (PTR_ERR(h->pg) == -ENOMEM)
+	pg = alua_alloc_pg(sdev, group_id, tpgs);
+	if (IS_ERR(pg)) {
+		if (PTR_ERR(pg) == -ENOMEM)
 			return SCSI_DH_NOMEM;
 		return SCSI_DH_DEV_UNSUPP;
 	}
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: device %s port group %x rel port %x\n",
-		    ALUA_DH_NAME, h->pg->device_id_str,
-		    h->group_id, rel_port);
+		    ALUA_DH_NAME, pg->device_id_str, group_id, rel_port);
+
+	/* Check for existing port group references */
+	spin_lock(&h->pg_lock);
+	old_pg = h->pg;
+	if (old_pg != pg) {
+		/* port group has changed. Update to new port group */
+		rcu_assign_pointer(h->pg, pg);
+	}
+	alua_rtpg_queue(h->pg, sdev, NULL);
+	spin_unlock(&h->pg_lock);
+
+	if (old_pg)
+		kref_put(&old_pg->kref, release_port_group);
 
-	return alua_rtpg(sdev, h->pg);
+	return SCSI_DH_OK;
 }
 
 static char print_alua_state(int state)
@@ -423,14 +464,17 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
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
+		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
+
+		if (pg->transition_tmo)
+			transition_tmo = pg->transition_tmo * HZ;
+
+		pg->expiry = round_jiffies_up(jiffies + transition_tmo);
+	}
 
 	buff = kzalloc(bufflen, GFP_KERNEL);
 	if (!buff)
@@ -473,16 +517,18 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			err = SCSI_DH_RETRY;
 		else if (sense_hdr.sense_key == UNIT_ATTENTION)
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
 
@@ -497,6 +543,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: kmalloc buffer failed\n",__func__);
 			/* Temporary failure, bypass */
+			pg->expiry = 0;
 			return SCSI_DH_DEV_TEMP_BUSY;
 		}
 		goto retry;
@@ -512,7 +559,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: transition timeout set to %d seconds\n",
 			    ALUA_DH_NAME, pg->transition_tmo);
-		expiry = jiffies + pg->transition_tmo * HZ;
+		pg->expiry = jiffies + pg->transition_tmo * HZ;
 	}
 
 	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
@@ -546,23 +593,26 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
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
@@ -627,6 +677,107 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	return SCSI_DH_RETRY;
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
+	spin_lock_irqsave(&pg->lock, flags);
+	sdev = pg->rtpg_sdev;
+	if (!sdev) {
+		WARN_ON(pg->flags & ALUA_PG_RUN_RTPG);
+		WARN_ON(pg->flags & ALUA_PG_RUN_STPG);
+		spin_unlock_irqrestore(&pg->lock, flags);
+		return;
+	}
+	pg->flags |= ALUA_PG_RUNNING;
+	if (pg->flags & ALUA_PG_RUN_RTPG) {
+		pg->flags &= ~ALUA_PG_RUN_RTPG;
+		spin_unlock_irqrestore(&pg->lock, flags);
+		err = alua_rtpg(sdev, pg);
+		spin_lock_irqsave(&pg->lock, flags);
+		if (err == SCSI_DH_RETRY) {
+			pg->flags &= ~ALUA_PG_RUNNING;
+			pg->flags |= ALUA_PG_RUN_RTPG;
+			spin_unlock_irqrestore(&pg->lock, flags);
+			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
+					   pg->interval * HZ);
+			return;
+		}
+		if (err != SCSI_DH_OK)
+			pg->flags &= ~ALUA_PG_RUN_STPG;
+	}
+	if (pg->flags & ALUA_PG_RUN_STPG) {
+		pg->flags &= ~ALUA_PG_RUN_STPG;
+		spin_unlock_irqrestore(&pg->lock, flags);
+		err = alua_stpg(sdev, pg);
+		spin_lock_irqsave(&pg->lock, flags);
+		if (err == SCSI_DH_RETRY) {
+			pg->flags |= ALUA_PG_RUN_RTPG;
+			pg->interval = 0;
+			pg->flags &= ~ALUA_PG_RUNNING;
+			spin_unlock_irqrestore(&pg->lock, flags);
+			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
+					   pg->interval * HZ);
+			return;
+		}
+	}
+
+	list_splice_init(&pg->rtpg_list, &qdata_list);
+	pg->rtpg_sdev = NULL;
+	spin_unlock_irqrestore(&pg->lock, flags);
+
+	list_for_each_entry_safe(qdata, tmp, &qdata_list, entry) {
+		list_del(&qdata->entry);
+		if (qdata->callback_fn)
+			qdata->callback_fn(qdata->callback_data, err);
+		kfree(qdata);
+	}
+	spin_lock_irqsave(&pg->lock, flags);
+	pg->flags &= ~ALUA_PG_RUNNING;
+	spin_unlock_irqrestore(&pg->lock, flags);
+	scsi_device_put(sdev);
+	kref_put(&pg->kref, release_port_group);
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
+	spin_lock_irqsave(&pg->lock, flags);
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
+	spin_unlock_irqrestore(&pg->lock, flags);
+
+	if (start_queue &&
+	    !queue_delayed_work(kaluad_wq, &pg->rtpg_work,
+				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS))) {
+		scsi_device_put(sdev);
+		kref_put(&pg->kref, release_port_group);
+	}
+}
+
 /*
  * alua_initialize - Initialize ALUA state
  * @sdev: the device to be initialized
@@ -638,10 +789,12 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	int err = SCSI_DH_DEV_UNSUPP, tpgs;
 
+	mutex_lock(&h->init_mutex);
 	tpgs = alua_check_tpgs(sdev);
 	if (tpgs != TPGS_MODE_NONE)
 		err = alua_check_vpd(sdev, h, tpgs);
-
+	h->init_error = err;
+	mutex_unlock(&h->init_mutex);
 	return err;
 }
 /*
@@ -656,10 +809,11 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 static int alua_set_params(struct scsi_device *sdev, const char *params)
 {
 	struct alua_dh_data *h = sdev->handler_data;
-	struct alua_port_group *pg = NULL;
+	struct alua_port_group __rcu *pg = NULL;
 	unsigned int optimize = 0, argc;
 	const char *p = params;
 	int result = SCSI_DH_OK;
+	unsigned long flags;
 
 	if ((sscanf(params, "%u", &argc) != 1) || (argc != 1))
 		return -EINVAL;
@@ -669,14 +823,19 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
 	if ((sscanf(p, "%u", &optimize) != 1) || (optimize > 1))
 		return -EINVAL;
 
-	pg = h->pg;
-	if (!pg)
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (!pg) {
+		rcu_read_unlock();
 		return -ENXIO;
-
+	}
+	spin_lock_irqsave(&pg->lock, flags);
 	if (optimize)
 		pg->flags |= ALUA_OPTIMIZE_STPG;
 	else
 		pg->flags &= ~ALUA_OPTIMIZE_STPG;
+	spin_unlock_irqrestore(&pg->lock, flags);
+	rcu_read_unlock();
 
 	return result;
 }
@@ -696,21 +855,33 @@ static int alua_activate(struct scsi_device *sdev,
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	int err = SCSI_DH_OK;
+	struct alua_queue_data *qdata;
+	struct alua_port_group __rcu *pg;
 
-	if (!h->pg)
+	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
+	if (!qdata) {
+		err = SCSI_DH_RES_TEMP_UNAVAIL;
 		goto out;
-
-	kref_get(&h->pg->kref);
-
-	err = alua_rtpg(sdev, h->pg);
-	if (err != SCSI_DH_OK) {
-		kref_put(&h->pg->kref, release_port_group);
+	}
+	qdata->callback_fn = fn;
+	qdata->callback_data = data;
+
+	mutex_lock(&h->init_mutex);
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (!pg || !kref_get_unless_zero(&pg->kref)) {
+		rcu_read_unlock();
+		kfree(qdata);
+		err = h->init_error;
+		mutex_unlock(&h->init_mutex);
 		goto out;
 	}
-	err = alua_stpg(sdev, h->pg);
-	if (err == SCSI_DH_RETRY)
-		err = alua_rtpg(sdev, h->pg);
-	kref_put(&h->pg->kref, release_port_group);
+	fn = NULL;
+	rcu_read_unlock();
+	mutex_unlock(&h->init_mutex);
+
+	alua_rtpg_queue(pg, sdev, qdata);
+	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
 		fn(data, err);
@@ -726,14 +897,15 @@ out:
 static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 {
 	struct alua_dh_data *h = sdev->handler_data;
-	int state;
+	struct alua_port_group __rcu *pg;
+	int state = TPGS_STATE_OPTIMIZED;
 	int ret = BLKPREP_OK;
 
-	if (!h->pg)
-		return ret;
-	kref_get(&h->pg->kref);
-	state = h->pg->state;
-	kref_put(&h->pg->kref, release_port_group);
+	rcu_read_lock();
+	pg = rcu_dereference(h->pg);
+	if (pg)
+		state = pg->state;
+	rcu_read_unlock();
 	if (state == TPGS_STATE_TRANSITIONING)
 		ret = BLKPREP_DEFER;
 	else if (state != TPGS_STATE_OPTIMIZED &&
@@ -758,9 +930,12 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	h = kzalloc(sizeof(*h) , GFP_KERNEL);
 	if (!h)
 		return -ENOMEM;
-	h->pg = NULL;
+	spin_lock_init(&h->pg_lock);
+	rcu_assign_pointer(h->pg, NULL);
+	h->init_error = SCSI_DH_OK;
 	h->sdev = sdev;
 
+	mutex_init(&h->init_mutex);
 	err = alua_initialize(sdev, h);
 	if (err == SCSI_DH_NOMEM)
 		ret = -ENOMEM;
@@ -781,11 +956,16 @@ failed:
 static void alua_bus_detach(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h = sdev->handler_data;
+	struct alua_port_group *pg;
+
+	spin_lock(&h->pg_lock);
+	pg = h->pg;
+	rcu_assign_pointer(h->pg, NULL);
+	h->sdev = NULL;
+	spin_unlock(&h->pg_lock);
+	if (pg)
+		kref_put(&pg->kref, release_port_group);
 
-	if (h->pg) {
-		kref_put(&h->pg->kref, release_port_group);
-		h->pg = NULL;
-	}
 	sdev->handler_data = NULL;
 	kfree(h);
 }
@@ -805,16 +985,24 @@ static int __init alua_init(void)
 {
 	int r;
 
+	kaluad_wq = alloc_workqueue("kaluad", WQ_MEM_RECLAIM, 0);
+	if (!kaluad_wq) {
+		/* Temporary failure, bypass */
+		return SCSI_DH_DEV_TEMP_BUSY;
+	}
 	r = scsi_register_device_handler(&alua_dh);
-	if (r != 0)
+	if (r != 0) {
 		printk(KERN_ERR "%s: Failed to register scsi device handler",
 			ALUA_DH_NAME);
+		destroy_workqueue(kaluad_wq);
+	}
 	return r;
 }
 
 static void __exit alua_exit(void)
 {
 	scsi_unregister_device_handler(&alua_dh);
+	destroy_workqueue(kaluad_wq);
 }
 
 module_init(alua_init);
-- 
1.8.5.6

