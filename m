From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 14/23] scsi_dh_alua: Allow workqueue to run synchronously
Date: Fri, 19 Feb 2016 09:17:11 +0100
Message-ID: <1455869840-122786-15-git-send-email-hare@suse.de>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1427049AbcBSIRt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 03:17:49 -0500
In-Reply-To: <1455869840-122786-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Some arrays may only capable of handling one STPG at a time,
so this patch adds a singlethreaded workqueue for STPGs to be
submitted synchronously.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 8318852..a3cb069 100644
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
@@ -686,6 +688,7 @@ static void alua_rtpg_work(struct work_struct *work)
 	int err = SCSI_DH_OK;
 	struct alua_queue_data *qdata, *tmp;
 	unsigned long flags;
+	struct workqueue_struct *alua_wq = kaluad_wq;
 
 	spin_lock_irqsave(&pg->lock, flags);
 	sdev = pg->rtpg_sdev;
@@ -695,6 +698,8 @@ static void alua_rtpg_work(struct work_struct *work)
 		spin_unlock_irqrestore(&pg->lock, flags);
 		return;
 	}
+	if (pg->flags & ALUA_SYNC_STPG)
+		alua_wq = kaluad_sync_wq;
 	pg->flags |= ALUA_PG_RUNNING;
 	if (pg->flags & ALUA_PG_RUN_RTPG) {
 		pg->flags &= ~ALUA_PG_RUN_RTPG;
@@ -705,7 +710,7 @@ static void alua_rtpg_work(struct work_struct *work)
 			pg->flags &= ~ALUA_PG_RUNNING;
 			pg->flags |= ALUA_PG_RUN_RTPG;
 			spin_unlock_irqrestore(&pg->lock, flags);
-			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
+			queue_delayed_work(alua_wq, &pg->rtpg_work,
 					   pg->interval * HZ);
 			return;
 		}
@@ -722,7 +727,7 @@ static void alua_rtpg_work(struct work_struct *work)
 			pg->interval = 0;
 			pg->flags &= ~ALUA_PG_RUNNING;
 			spin_unlock_irqrestore(&pg->lock, flags);
-			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
+			queue_delayed_work(alua_wq, &pg->rtpg_work,
 					   pg->interval * HZ);
 			return;
 		}
@@ -751,6 +756,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 {
 	int start_queue = 0;
 	unsigned long flags;
+	struct workqueue_struct *alua_wq = kaluad_wq;
 
 	if (!pg)
 		return;
@@ -768,10 +774,12 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
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
@@ -990,10 +998,16 @@ static int __init alua_init(void)
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
@@ -1002,6 +1016,7 @@ static int __init alua_init(void)
 static void __exit alua_exit(void)
 {
 	scsi_unregister_device_handler(&alua_dh);
+	destroy_workqueue(kaluad_sync_wq);
 	destroy_workqueue(kaluad_wq);
 }
 
-- 
1.8.5.6

