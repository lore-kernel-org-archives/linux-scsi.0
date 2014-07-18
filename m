From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/14] scsi: convert host_busy to atomic_t
Date: Fri, 18 Jul 2014 12:13:06 +0200
Message-ID: <1405678393-11497-8-git-send-email-hch@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Avoid taking the host-wide host_lock to check the per-host queue limit.
Instead we do an atomic_inc_return early on to grab our slot in the queue,
and if nessecary decrement it after finishing all checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Webb Scales <webbnh@hp.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Robert Elliott <elliott@hp.com>
---
 drivers/scsi/advansys.c             |  4 +-
 drivers/scsi/libiscsi.c             |  4 +-
 drivers/scsi/libsas/sas_scsi_host.c |  5 ++-
 drivers/scsi/qlogicpti.c            |  2 +-
 drivers/scsi/scsi.c                 |  2 +-
 drivers/scsi/scsi_error.c           |  7 ++--
 drivers/scsi/scsi_lib.c             | 74 ++++++++++++++++++++++---------------
 drivers/scsi/scsi_sysfs.c           |  9 ++++-
 include/scsi/scsi_host.h            | 10 ++---
 9 files changed, 69 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index e716d0a..43761c1 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2512,7 +2512,7 @@ static void asc_prt_scsi_host(struct Scsi_Host *s)
 
 	printk("Scsi_Host at addr 0x%p, device %s\n", s, dev_name(boardp->dev));
 	printk(" host_busy %u, host_no %d,\n",
-	       s->host_busy, s->host_no);
+	       atomic_read(&s->host_busy), s->host_no);
 
 	printk(" base 0x%lx, io_port 0x%lx, irq %d,\n",
 	       (ulong)s->base, (ulong)s->io_port, boardp->irq);
@@ -3346,7 +3346,7 @@ static void asc_prt_driver_conf(struct seq_file *m, struct Scsi_Host *shost)
 
 	seq_printf(m,
 		   " host_busy %u, max_id %u, max_lun %llu, max_channel %u\n",
-		   shost->host_busy, shost->max_id,
+		   atomic_read(&shost->host_busy), shost->max_id,
 		   shost->max_lun, shost->max_channel);
 
 	seq_printf(m,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f2db82b..f9f3a12 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2971,7 +2971,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	 */
 	for (;;) {
 		spin_lock_irqsave(session->host->host_lock, flags);
-		if (!session->host->host_busy) { /* OK for ERL == 0 */
+		if (!atomic_read(&session->host->host_busy)) { /* OK for ERL == 0 */
 			spin_unlock_irqrestore(session->host->host_lock, flags);
 			break;
 		}
@@ -2979,7 +2979,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		msleep_interruptible(500);
 		iscsi_conn_printk(KERN_INFO, conn, "iscsi conn_destroy(): "
 				  "host_busy %d host_failed %d\n",
-				  session->host->host_busy,
+				  atomic_read(&session->host->host_busy),
 				  session->host->host_failed);
 		/*
 		 * force eh_abort() to unblock
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 7d02a19..24e477d 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -813,7 +813,7 @@ retry:
 	spin_unlock_irq(shost->host_lock);
 
 	SAS_DPRINTK("Enter %s busy: %d failed: %d\n",
-		    __func__, shost->host_busy, shost->host_failed);
+		    __func__, atomic_read(&shost->host_busy), shost->host_failed);
 	/*
 	 * Deal with commands that still have SAS tasks (i.e. they didn't
 	 * complete via the normal sas_task completion mechanism),
@@ -858,7 +858,8 @@ out:
 		goto retry;
 
 	SAS_DPRINTK("--- Exit %s: busy: %d failed: %d tries: %d\n",
-		    __func__, shost->host_busy, shost->host_failed, tries);
+		    __func__, atomic_read(&shost->host_busy),
+		    shost->host_failed, tries);
 }
 
 enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 6d48d30..740ae49 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -959,7 +959,7 @@ static inline void update_can_queue(struct Scsi_Host *host, u_int in_ptr, u_int
 	/* Temporary workaround until bug is found and fixed (one bug has been found
 	   already, but fixing it makes things even worse) -jj */
 	int num_free = QLOGICPTI_REQ_QUEUE_LEN - REQ_QUEUE_DEPTH(in_ptr, out_ptr) - 64;
-	host->can_queue = host->host_busy + num_free;
+	host->can_queue = atomic_read(&host->host_busy) + num_free;
 	host->sg_tablesize = QLOGICPTI_MAX_SG(num_free);
 }
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 6200a26..21fb97b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -600,7 +600,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 			if (level > 3)
 				scmd_printk(KERN_INFO, cmd,
 					    "scsi host busy %d failed %d\n",
-					    cmd->device->host->host_busy,
+					    atomic_read(&cmd->device->host->host_busy),
 					    cmd->device->host->host_failed);
 		}
 	}
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index e4a5324..5db8454 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -59,7 +59,7 @@ static int scsi_try_to_abort_cmd(struct scsi_host_template *,
 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
-	if (shost->host_busy == shost->host_failed) {
+	if (atomic_read(&shost->host_busy) == shost->host_failed) {
 		trace_scsi_eh_wakeup(shost);
 		wake_up_process(shost->ehandler);
 		SCSI_LOG_ERROR_RECOVERY(5, shost_printk(KERN_INFO, shost,
@@ -2164,7 +2164,7 @@ int scsi_error_handler(void *data)
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
-		    shost->host_failed != shost->host_busy) {
+		    shost->host_failed != atomic_read(&shost->host_busy)) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				shost_printk(KERN_INFO, shost,
 					     "scsi_eh_%d: sleeping\n",
@@ -2178,7 +2178,8 @@ int scsi_error_handler(void *data)
 			shost_printk(KERN_INFO, shost,
 				     "scsi_eh_%d: waking up %d/%d/%d\n",
 				     shost->host_no, shost->host_eh_scheduled,
-				     shost->host_failed, shost->host_busy));
+				     shost->host_failed,
+				     atomic_read(&shost->host_busy)));
 
 		/*
 		 * We have a host that is failing for some reason.  Figure out
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0580711..d0bd7e0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -292,14 +292,17 @@ void scsi_device_unbusy(struct scsi_device *sdev)
 	struct scsi_target *starget = scsi_target(sdev);
 	unsigned long flags;
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->host_busy--;
+	atomic_dec(&shost->host_busy);
 	atomic_dec(&starget->target_busy);
+
 	if (unlikely(scsi_host_in_recovery(shost) &&
-		     (shost->host_failed || shost->host_eh_scheduled)))
+		     (shost->host_failed || shost->host_eh_scheduled))) {
+		spin_lock_irqsave(shost->host_lock, flags);
 		scsi_eh_wakeup(shost);
-	spin_unlock(shost->host_lock);
-	spin_lock(sdev->request_queue->queue_lock);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+	}
+
+	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->device_busy--;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 }
@@ -367,7 +370,8 @@ static inline int scsi_target_is_busy(struct scsi_target *starget)
 
 static inline int scsi_host_is_busy(struct Scsi_Host *shost)
 {
-	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
+	if ((shost->can_queue > 0 &&
+	     atomic_read(&shost->host_busy) >= shost->can_queue) ||
 	    shost->host_blocked || shost->host_self_blocked)
 		return 1;
 
@@ -1334,38 +1338,54 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 				   struct Scsi_Host *shost,
 				   struct scsi_device *sdev)
 {
-	int ret = 0;
-
-	spin_lock_irq(shost->host_lock);
+	unsigned int busy;
 
 	if (scsi_host_in_recovery(shost))
-		goto out;
-	if (shost->host_busy == 0 && shost->host_blocked) {
+		return 0;
+
+	busy = atomic_inc_return(&shost->host_busy) - 1;
+	if (shost->host_blocked) {
+		if (busy)
+			goto starved;
+
 		/*
 		 * unblock after host_blocked iterates to zero
 		 */
-		if (--shost->host_blocked != 0)
-			goto out;
+		spin_lock_irq(shost->host_lock);
+		if (--shost->host_blocked != 0) {
+			spin_unlock_irq(shost->host_lock);
+			goto out_dec;
+		}
+		spin_unlock_irq(shost->host_lock);
 
 		SCSI_LOG_MLQUEUE(3,
 			shost_printk(KERN_INFO, shost,
 				     "unblocking host at zero depth\n"));
 	}
-	if (scsi_host_is_busy(shost)) {
-		if (list_empty(&sdev->starved_entry))
-			list_add_tail(&sdev->starved_entry, &shost->starved_list);
-		goto out;
-	}
+
+	if (shost->can_queue > 0 && busy >= shost->can_queue)
+		goto starved;
+	if (shost->host_self_blocked)
+		goto starved;
 
 	/* We're OK to process the command, so we can't be starved */
-	if (!list_empty(&sdev->starved_entry))
-		list_del_init(&sdev->starved_entry);
+	if (!list_empty(&sdev->starved_entry)) {
+		spin_lock_irq(shost->host_lock);
+		if (!list_empty(&sdev->starved_entry))
+			list_del_init(&sdev->starved_entry);
+		spin_unlock_irq(shost->host_lock);
+	}
 
-	shost->host_busy++;
-	ret = 1;
-out:
+	return 1;
+
+starved:
+	spin_lock_irq(shost->host_lock);
+	if (list_empty(&sdev->starved_entry))
+		list_add_tail(&sdev->starved_entry, &shost->starved_list);
 	spin_unlock_irq(shost->host_lock);
-	return ret;
+out_dec:
+	atomic_dec(&shost->host_busy);
+	return 0;
 }
 
 /*
@@ -1429,12 +1449,8 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	 * with the locks as normal issue path does.
 	 */
 	sdev->device_busy++;
-	spin_unlock(sdev->request_queue->queue_lock);
-	spin_lock(shost->host_lock);
-	shost->host_busy++;
+	atomic_inc(&shost->host_busy);
 	atomic_inc(&starget->target_busy);
-	spin_unlock(shost->host_lock);
-	spin_lock(sdev->request_queue->queue_lock);
 
 	blk_complete_request(req);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5f36788..7ec5e06 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -334,7 +334,6 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(eh_deadline, S_IRUGO | S_IWUSR, show_shost_eh_deadline, store_shost_eh_deadline);
 
 shost_rd_attr(unique_id, "%u\n");
-shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
@@ -344,6 +343,14 @@ shost_rd_attr(prot_capabilities, "%u\n");
 shost_rd_attr(prot_guard_type, "%hd\n");
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
 
+static ssize_t
+show_host_busy(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	return snprintf(buf, 20, "%hu\n", atomic_read(&shost->host_busy));
+}
+static DEVICE_ATTR(host_busy, S_IRUGO, show_host_busy, NULL);
+
 static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_unique_id.attr,
 	&dev_attr_host_busy.attr,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b2bc519..51f7911 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -582,13 +582,9 @@ struct Scsi_Host {
 	 */
 	struct blk_queue_tag	*bqt;
 
-	/*
-	 * The following two fields are protected with host_lock;
-	 * however, eh routines can safely access during eh processing
-	 * without acquiring the lock.
-	 */
-	unsigned int host_busy;		   /* commands actually active on low-level */
-	unsigned int host_failed;	   /* commands that failed. */
+	atomic_t host_busy;		   /* commands actually active on low-level */
+	unsigned int host_failed;	   /* commands that failed.
+					      protected by host_lock */
 	unsigned int host_eh_scheduled;    /* EH scheduled without command */
     
 	unsigned int host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
-- 
1.9.1
