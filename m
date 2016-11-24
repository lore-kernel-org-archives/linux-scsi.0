From: tang.junhui@zte.com.cn
Subject: [PATCH] scsi_dh_alua: Add return value and check for alua_rtpg_queue() to avoid DM devices I/Os hang
Date: Thu, 24 Nov 2016 18:25:05 +0800
Message-ID: <1479983105-7264-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1.zte.com.cn ([202.103.147.172]:46078 "EHLO out1.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935138AbcKXKws (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Nov 2016 05:52:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, zhang.kai16@zte.com.cn, "tang.junhui" <tang.junhui@zte.com.cn>

From: "tang.junhui" <tang.junhui@zte.com.cn>

Activate_complete fn() must be called in alua_activate() if
alua_rtpg_queue() failed, otherwise, it would cause I/Os hang in DM
devices. So this patch add return value and check for alua_rtpg_queue().

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 7bb2068..62075c7 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -113,7 +113,7 @@ struct alua_queue_data {
 #define ALUA_POLICY_SWITCH_ALL		1
 
 static void alua_rtpg_work(struct work_struct *work);
-static void alua_rtpg_queue(struct alua_port_group *pg,
+static int alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
 			    struct alua_queue_data *qdata, bool force);
 static void alua_check(struct scsi_device *sdev, bool force);
@@ -862,7 +862,7 @@ static void alua_rtpg_work(struct work_struct *work)
 	kref_put(&pg->kref, release_port_group);
 }
 
-static void alua_rtpg_queue(struct alua_port_group *pg,
+static int alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
 			    struct alua_queue_data *qdata, bool force)
 {
@@ -871,7 +871,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 	struct workqueue_struct *alua_wq = kaluad_wq;
 
 	if (!pg)
-		return;
+		return SCSI_DH_IO;
 
 	spin_lock_irqsave(&pg->lock, flags);
 	if (qdata) {
@@ -906,7 +906,10 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		if (sdev)
 			scsi_device_put(sdev);
 		kref_put(&pg->kref, release_port_group);
+		return SCSI_DH_IO;
 	}
+
+	return SCSI_DH_OK;
 }
 
 /*
@@ -1007,11 +1010,12 @@ static int alua_activate(struct scsi_device *sdev,
 		mutex_unlock(&h->init_mutex);
 		goto out;
 	}
-	fn = NULL;
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
-	alua_rtpg_queue(pg, sdev, qdata, true);
+	err = alua_rtpg_queue(pg, sdev, qdata, true);
+	if (!err)
+		fn = NULL;
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
-- 
2.8.1.windows.1


