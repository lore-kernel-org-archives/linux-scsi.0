From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/3] scsi_dh_alua: Ensure that alua_activate() calls the completion function
Date: Fri, 17 Mar 2017 17:02:02 -0700
Message-ID: <20170318000203.7469-3-bart.vanassche@sandisk.com>
References: <20170318000203.7469-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170318000203.7469-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Callers of scsi_dh_activate(), e.g. dm-mpath, assume that this
function either returns an error code or calls the completion
function. Make alua_activate() call the completion function even
if scsi_device_get() fails.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Tang Junhui <tang.junhui@zte.com.cn>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e0b15f3dd303..b6849d3ecefe 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -113,7 +113,7 @@ struct alua_queue_data {
 #define ALUA_POLICY_SWITCH_ALL		1
 
 static void alua_rtpg_work(struct work_struct *work);
-static void alua_rtpg_queue(struct alua_port_group *pg,
+static bool alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
 			    struct alua_queue_data *qdata, bool force);
 static void alua_check(struct scsi_device *sdev, bool force);
@@ -862,7 +862,13 @@ static void alua_rtpg_work(struct work_struct *work)
 	kref_put(&pg->kref, release_port_group);
 }
 
-static void alua_rtpg_queue(struct alua_port_group *pg,
+/**
+ * alua_rtpg_queue() - cause RTPG to be submitted asynchronously
+ *
+ * Returns true if and only if alua_rtpg_work() will be called asynchronously.
+ * That function is responsible for calling @qdata->fn().
+ */
+static bool alua_rtpg_queue(struct alua_port_group *pg,
 			    struct scsi_device *sdev,
 			    struct alua_queue_data *qdata, bool force)
 {
@@ -871,7 +877,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 	struct workqueue_struct *alua_wq = kaluad_wq;
 
 	if (!pg || scsi_device_get(sdev))
-		return;
+		return false;
 
 	spin_lock_irqsave(&pg->lock, flags);
 	if (qdata) {
@@ -907,6 +913,8 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 	}
 	if (sdev)
 		scsi_device_put(sdev);
+
+	return true;
 }
 
 /*
@@ -1007,11 +1015,13 @@ static int alua_activate(struct scsi_device *sdev,
 		mutex_unlock(&h->init_mutex);
 		goto out;
 	}
-	fn = NULL;
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
-	alua_rtpg_queue(pg, sdev, qdata, true);
+	if (alua_rtpg_queue(pg, sdev, qdata, true))
+		fn = NULL;
+	else
+		err = SCSI_DH_DEV_OFFLINED;
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
-- 
2.12.0
