From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 14/22] scsi_dh_alua: Allow workqueue to run synchronously
Date: Tue, 12 Jan 2016 16:40:50 +0100
Message-ID: <1452613258-94084-15-git-send-email-hare@suse.de>
References: <1452613258-94084-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762804AbcALPlG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2016 10:41:06 -0500
In-Reply-To: <1452613258-94084-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Some arrays may only capable of handling one STPG at a time,
so this patch adds a singlethreaded workqueue for STPGs to be
submitted synchronously.
Synchronous STPG can be activated by setting the second module
option to '1'. The corresponding entry in multipath.conf would be:
  hardware_handler "3 alua 1 1"

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 41 ++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 9d56d6a..eb12074 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -64,6 +64,7 @@
 /* device handler flags */
 #define ALUA_OPTIMIZE_STPG		0x01
 #define ALUA_RTPG_EXT_HDR_UNSUPP	0x02
+#define ALUA_SYNC_STPG			0x04
 /* State machine flags */
 #define ALUA_PG_RUN_RTPG		0x10
 #define ALUA_PG_RUN_STPG		0x20
@@ -76,6 +77,7 @@ MODULE_PARM_DESC(optimize_stpg, "Allow use of a non-optimized path, rather than
 static LIST_HEAD(port_group_list);
 static DEFINE_SPINLOCK(port_group_lock);
 static struct workqueue_struct *kaluad_wq;
+static struct workqueue_struct *kaluad_sync_wq;
 
 struct alua_port_group {
 	struct kref		kref;
@@ -700,6 +702,7 @@ static void alua_rtpg_work(struct work_struct *work)
 	int err = SCSI_DH_OK;
 	struct alua_queue_data *qdata, *tmp;
 	unsigned long flags;
+	struct workqueue_struct *alua_wq = kaluad_wq;
 
 	spin_lock_irqsave(&pg->lock, flags);
 	sdev = pg->rtpg_sdev;
@@ -709,6 +712,8 @@ static void alua_rtpg_work(struct work_struct *work)
 		spin_unlock_irqrestore(&pg->lock, flags);
 		return;
 	}
+	if (pg->flags & ALUA_SYNC_STPG)
+		alua_wq = kaluad_sync_wq;
 	pg->flags |= ALUA_PG_RUNNING;
 	if (pg->flags & ALUA_PG_RUN_RTPG) {
 		spin_unlock_irqrestore(&pg->lock, flags);
@@ -717,7 +722,7 @@ static void alua_rtpg_work(struct work_struct *work)
 		if (err == SCSI_DH_RETRY) {
 			pg->flags &= ~ALUA_PG_RUNNING;
 			spin_unlock_irqrestore(&pg->lock, flags);
-			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
+			queue_delayed_work(alua_wq, &pg->rtpg_work,
 					   pg->interval * HZ);
 			return;
 		}
@@ -735,7 +740,7 @@ static void alua_rtpg_work(struct work_struct *work)
 			pg->interval = 0;
 			pg->flags &= ~ALUA_PG_RUNNING;
 			spin_unlock_irqrestore(&pg->lock, flags);
-			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
+			queue_delayed_work(alua_wq, &pg->rtpg_work,
 					   pg->interval * HZ);
 			return;
 		}
@@ -764,6 +769,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 {
 	int start_queue = 0;
 	unsigned long flags;
+	struct workqueue_struct *alua_wq = kaluad_wq;
 
 	if (!pg)
 		return;
@@ -781,10 +787,12 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		scsi_device_get(sdev);
 		start_queue = 1;
 	}
+	if (pg->flags & ALUA_SYNC_STPG)
+		alua_wq = kaluad_sync_wq;
 	spin_unlock_irqrestore(&pg->lock, flags);
 
 	if (start_queue &&
-	    !queue_delayed_work(kaluad_wq, &pg->rtpg_work,
+	    !queue_delayed_work(alua_wq, &pg->rtpg_work,
 				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS))) {
 		scsi_device_put(sdev);
 		kref_put(&pg->kref, release_port_group);
@@ -811,30 +819,36 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 	return err;
 }
 /*
- * alua_set_params - set/unset the optimize flag
+ * alua_set_params - set/unset the optimize and sync flag
  * @sdev: device on the path to be activated
  * params - parameters in the following format
  *      "no_of_params\0param1\0param2\0param3\0...\0"
  * For example, to set the flag pass the following parameters
  * from multipath.conf
- *     hardware_handler        "2 alua 1"
+ *     hardware_handler        "3 alua 1 1"
  */
 static int alua_set_params(struct scsi_device *sdev, const char *params)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	struct alua_port_group *pg = NULL;
-	unsigned int optimize = 0, argc;
+	unsigned int optimize = 0, sync = 0, argc;
 	const char *p = params;
 	int result = SCSI_DH_OK;
 	unsigned long flags;
 
-	if ((sscanf(params, "%u", &argc) != 1) || (argc != 1))
+	if ((sscanf(params, "%u", &argc) != 1) || (argc > 2))
 		return -EINVAL;
 
 	while (*p++)
 		;
 	if ((sscanf(p, "%u", &optimize) != 1) || (optimize > 1))
 		return -EINVAL;
+	if (argc == 2) {
+		while (*p++)
+			;
+		if ((sscanf(p, "%u", &sync) != 1) || (sync > 1))
+			return -EINVAL;
+	}
 
 	rcu_read_lock();
 	pg = rcu_dereference(h->pg);
@@ -846,7 +860,11 @@ static int alua_set_params(struct scsi_device *sdev, const char *params)
 	if (optimize)
 		pg->flags |= ALUA_OPTIMIZE_STPG;
 	else
-		pg->flags |= ~ALUA_OPTIMIZE_STPG;
+		pg->flags &= ~ALUA_OPTIMIZE_STPG;
+	if (sync)
+		pg->flags |= ALUA_SYNC_STPG;
+	else
+		pg->flags &= ~ALUA_SYNC_STPG;
 	spin_unlock_irqrestore(&pg->lock, flags);
 	rcu_read_unlock();
 
@@ -1010,10 +1028,16 @@ static int __init alua_init(void)
 		/* Temporary failure, bypass */
 		return SCSI_DH_DEV_TEMP_BUSY;
 	}
+	kaluad_sync_wq = create_workqueue("kaluad_sync");
+	if (!kaluad_sync_wq) {
+		destroy_workqueue(kaluad_wq);
+		return SCSI_DH_DEV_TEMP_BUSY;
+	}
 	r = scsi_register_device_handler(&alua_dh);
 	if (r != 0) {
 		printk(KERN_ERR "%s: Failed to register scsi device handler",
 			ALUA_DH_NAME);
+		destroy_workqueue(kaluad_sync_wq);
 		destroy_workqueue(kaluad_wq);
 	}
 	return r;
@@ -1022,6 +1046,7 @@ static int __init alua_init(void)
 static void __exit alua_exit(void)
 {
 	scsi_unregister_device_handler(&alua_dh);
+	destroy_workqueue(kaluad_sync_wq);
 	destroy_workqueue(kaluad_wq);
 }
 
-- 
1.8.5.6

