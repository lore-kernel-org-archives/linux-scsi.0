From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v3 1/2] Ensure that the SCSI error handler gets woken up
Date: Mon,  4 Dec 2017 10:06:23 -0800
Message-ID: <20171204180624.18722-2-bart.vanassche@wdc.com>
References: <20171204180624.18722-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:29886 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752326AbdLDSGd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 13:06:33 -0500
In-Reply-To: <20171204180624.18722-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Konstantin Khorenko <khorenko@virtuozzo.com>, Stuart Hayes <stuart.w.hayes@gmail.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org

If scsi_eh_scmd_add() is called concurrently with
scsi_host_queue_ready() while shost->host_blocked > 0 then it can
happen that neither function wakes up the SCSI error handler. Fix
this by making every function that decreases the host_busy counter
wake up the error handler if necessary and by protecting the
host_failed checks with the SCSI host lock.

Reported-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
References: https://marc.info/?l=linux-kernel&m=150461610630736
Fixes: commit 746650160866 ("scsi: convert host_busy to atomic_t")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/hosts.c      |  6 ++++++
 drivers/scsi/scsi_error.c | 18 ++++++++++++++++--
 drivers/scsi/scsi_lib.c   | 39 ++++++++++++++++++++++++++++-----------
 include/scsi/scsi_host.h  |  2 ++
 4 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index a306af6a5ea7..a0a7e4ff255c 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -324,6 +324,9 @@ static void scsi_host_dev_release(struct device *dev)
 
 	scsi_proc_hostdir_rm(shost->hostt);
 
+	/* Wait for functions invoked through call_rcu(&shost->rcu, ...) */
+	rcu_barrier();
+
 	if (shost->tmf_work_q)
 		destroy_workqueue(shost->tmf_work_q);
 	if (shost->ehandler)
@@ -331,6 +334,8 @@ static void scsi_host_dev_release(struct device *dev)
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
 
+	destroy_rcu_head(&shost->rcu);
+
 	if (shost->shost_state == SHOST_CREATED) {
 		/*
 		 * Free the shost_dev device name here if scsi_host_alloc()
@@ -399,6 +404,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
+	init_rcu_head(&shost->rcu);
 
 	index = ida_simple_get(&host_index_ida, 0, 0, GFP_KERNEL);
 	if (index < 0)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5e89049e9b4e..258b8a741992 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -226,6 +226,17 @@ static void scsi_eh_reset(struct scsi_cmnd *scmd)
 	}
 }
 
+static void scsi_eh_inc_host_failed(struct rcu_head *head)
+{
+	struct Scsi_Host *shost = container_of(head, typeof(*shost), rcu);
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->host_failed++;
+	scsi_eh_wakeup(shost);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
 /**
  * scsi_eh_scmd_add - add scsi cmd to error handling.
  * @scmd:	scmd to run eh on.
@@ -248,9 +259,12 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 
 	scsi_eh_reset(scmd);
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
-	shost->host_failed++;
-	scsi_eh_wakeup(shost);
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	/*
+	 * Ensure that all tasks observe the host state change before the
+	 * host_failed change.
+	 */
+	call_rcu(&shost->rcu, scsi_eh_inc_host_failed);
 }
 
 /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b6d3842b6809..5cbc69b2b1ae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -318,22 +318,39 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 		cmd->cmd_len = scsi_command_size(cmd->cmnd);
 }
 
-void scsi_device_unbusy(struct scsi_device *sdev)
+/*
+ * Decrement the host_busy counter and wake up the error handler if necessary.
+ * Avoid as follows that the error handler is not woken up if shost->host_busy
+ * == shost->host_failed: use call_rcu() in scsi_eh_scmd_add() in combination
+ * with an RCU read lock in this function to ensure that this function in its
+ * entirety either finishes before scsi_eh_scmd_add() increases the
+ * host_failed counter or that it notices the shost state change made by
+ * scsi_eh_scmd_add().
+ */
+static void scsi_dec_host_busy(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = sdev->host;
-	struct scsi_target *starget = scsi_target(sdev);
 	unsigned long flags;
 
+	rcu_read_lock();
 	atomic_dec(&shost->host_busy);
-	if (starget->can_queue > 0)
-		atomic_dec(&starget->target_busy);
-
-	if (unlikely(scsi_host_in_recovery(shost) &&
-		     (shost->host_failed || shost->host_eh_scheduled))) {
+	if (unlikely(scsi_host_in_recovery(shost))) {
 		spin_lock_irqsave(shost->host_lock, flags);
-		scsi_eh_wakeup(shost);
+		if (shost->host_failed || shost->host_eh_scheduled)
+			scsi_eh_wakeup(shost);
 		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
+	rcu_read_unlock();
+}
+
+void scsi_device_unbusy(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_target *starget = scsi_target(sdev);
+
+	scsi_dec_host_busy(shost);
+
+	if (starget->can_queue > 0)
+		atomic_dec(&starget->target_busy);
 
 	atomic_dec(&sdev->device_busy);
 }
@@ -1531,7 +1548,7 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 		list_add_tail(&sdev->starved_entry, &shost->starved_list);
 	spin_unlock_irq(shost->host_lock);
 out_dec:
-	atomic_dec(&shost->host_busy);
+	scsi_dec_host_busy(shost);
 	return 0;
 }
 
@@ -2017,7 +2034,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return BLK_STS_OK;
 
 out_dec_host_busy:
-       atomic_dec(&shost->host_busy);
+	scsi_dec_host_busy(shost);
 out_dec_target_busy:
 	if (scsi_target(sdev)->can_queue > 0)
 		atomic_dec(&scsi_target(sdev)->target_busy);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index a8b7bf879ced..1a1df0d21ee3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -571,6 +571,8 @@ struct Scsi_Host {
 		struct blk_mq_tag_set	tag_set;
 	};
 
+	struct rcu_head rcu;
+
 	atomic_t host_busy;		   /* commands actually active on low-level */
 	atomic_t host_blocked;
 
-- 
2.15.0
