From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/14] scsi: convert device_busy to atomic_t
Date: Fri, 18 Jul 2014 12:13:07 +0200
Message-ID: <1405678393-11497-9-git-send-email-hch@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Avoid taking the queue_lock to check the per-device queue limit.  Instead
we do an atomic_inc_return early on to grab our slot in the queue,
and if necessary decrement it after finishing all checks.

Unlike the host and target busy counters this doesn't allow us to avoid the
queue_lock in the request_fn due to the way the interface works, but it'll
allow us to prepare for using the blk-mq code, which doesn't use the
queue_lock at all, and it at least avoids a queue_lock round trip in
scsi_device_unbusy, which is still important given how busy the queue_lock
is.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Webb Scales <webbnh@hp.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Robert Elliott <elliott@hp.com>
---
 drivers/message/fusion/mptsas.c |  2 +-
 drivers/scsi/scsi_lib.c         | 50 +++++++++++++++++++++++------------------
 drivers/scsi/scsi_sysfs.c       | 10 ++++++++-
 drivers/scsi/sg.c               |  2 +-
 include/scsi/scsi_device.h      |  4 +---
 5 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 711fcb5..d636dbe 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3763,7 +3763,7 @@ mptsas_send_link_status_event(struct fw_event_work *fw_event)
 						printk(MYIOC_s_DEBUG_FMT
 						"SDEV OUTSTANDING CMDS"
 						"%d\n", ioc->name,
-						sdev->device_busy));
+						atomic_read(&sdev->device_busy)));
 				}
 
 			}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d0bd7e0..1ddf0fb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -302,9 +302,7 @@ void scsi_device_unbusy(struct scsi_device *sdev)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 
-	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
-	sdev->device_busy--;
-	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
+	atomic_dec(&sdev->device_busy);
 }
 
 /*
@@ -355,9 +353,9 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 
 static inline int scsi_device_is_busy(struct scsi_device *sdev)
 {
-	if (sdev->device_busy >= sdev->queue_depth || sdev->device_blocked)
+	if (atomic_read(&sdev->device_busy) >= sdev->queue_depth ||
+	    sdev->device_blocked)
 		return 1;
-
 	return 0;
 }
 
@@ -1204,7 +1202,7 @@ scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 		 * queue must be restarted, so we schedule a callback to happen
 		 * shortly.
 		 */
-		if (sdev->device_busy == 0)
+		if (atomic_read(&sdev->device_busy) == 0)
 			blk_delay_queue(q, SCSI_QUEUE_DELAY);
 		break;
 	default:
@@ -1255,26 +1253,33 @@ static void scsi_unprep_fn(struct request_queue *q, struct request *req)
 static inline int scsi_dev_queue_ready(struct request_queue *q,
 				  struct scsi_device *sdev)
 {
-	if (sdev->device_busy == 0 && sdev->device_blocked) {
+	unsigned int busy;
+
+	busy = atomic_inc_return(&sdev->device_busy) - 1;
+	if (sdev->device_blocked) {
+		if (busy)
+			goto out_dec;
+
 		/*
 		 * unblock after device_blocked iterates to zero
 		 */
-		if (--sdev->device_blocked == 0) {
-			SCSI_LOG_MLQUEUE(3,
-				   sdev_printk(KERN_INFO, sdev,
-				   "unblocking device at zero depth\n"));
-		} else {
+		if (--sdev->device_blocked != 0) {
 			blk_delay_queue(q, SCSI_QUEUE_DELAY);
-			return 0;
+			goto out_dec;
 		}
+		SCSI_LOG_MLQUEUE(3, sdev_printk(KERN_INFO, sdev,
+				   "unblocking device at zero depth\n"));
 	}
-	if (scsi_device_is_busy(sdev))
-		return 0;
+
+	if (busy >= sdev->queue_depth)
+		goto out_dec;
 
 	return 1;
+out_dec:
+	atomic_dec(&sdev->device_busy);
+	return 0;
 }
 
-
 /*
  * scsi_target_queue_ready: checks if there we can send commands to target
  * @sdev: scsi device on starget to check.
@@ -1448,7 +1453,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	 * bump busy counts.  To bump the counters, we need to dance
 	 * with the locks as normal issue path does.
 	 */
-	sdev->device_busy++;
+	atomic_inc(&sdev->device_busy);
 	atomic_inc(&shost->host_busy);
 	atomic_inc(&starget->target_busy);
 
@@ -1544,7 +1549,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * accept it.
 		 */
 		req = blk_peek_request(q);
-		if (!req || !scsi_dev_queue_ready(q, sdev))
+		if (!req)
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
@@ -1554,13 +1559,14 @@ static void scsi_request_fn(struct request_queue *q)
 			continue;
 		}
 
+		if (!scsi_dev_queue_ready(q, sdev))
+			break;
 
 		/*
 		 * Remove the request from the request list.
 		 */
 		if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
 			blk_start_request(req);
-		sdev->device_busy++;
 
 		spin_unlock_irq(q->queue_lock);
 		cmd = req->special;
@@ -1630,9 +1636,9 @@ static void scsi_request_fn(struct request_queue *q)
 	 */
 	spin_lock_irq(q->queue_lock);
 	blk_requeue_request(q, req);
-	sdev->device_busy--;
+	atomic_dec(&sdev->device_busy);
 out_delay:
-	if (sdev->device_busy == 0 && !scsi_device_blocked(sdev))
+	if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 }
 
@@ -2371,7 +2377,7 @@ scsi_device_quiesce(struct scsi_device *sdev)
 		return err;
 
 	scsi_run_queue(sdev->request_queue);
-	while (sdev->device_busy) {
+	while (atomic_read(&sdev->device_busy)) {
 		msleep_interruptible(200);
 		scsi_run_queue(sdev->request_queue);
 	}
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 7ec5e06..54e3dac 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -585,13 +585,21 @@ static int scsi_sdev_check_buf_bit(const char *buf)
  * Create the actual show/store functions and data structures.
  */
 sdev_rd_attr (device_blocked, "%d\n");
-sdev_rd_attr (device_busy, "%d\n");
 sdev_rd_attr (type, "%d\n");
 sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
 
+static ssize_t
+sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	return snprintf(buf, 20, "%d\n", atomic_read(&sdev->device_busy));
+}
+static DEVICE_ATTR(device_busy, S_IRUGO, sdev_show_device_busy, NULL);
+
 /*
  * TODO: can we make these symlinks to the block layer ones?
  */
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7a291f5..01cf888 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2574,7 +2574,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 			      scsidp->id, scsidp->lun, (int) scsidp->type,
 			      1,
 			      (int) scsidp->queue_depth,
-			      (int) scsidp->device_busy,
+			      (int) atomic_read(&scsidp->device_busy),
 			      (int) scsi_device_online(scsidp));
 	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4e078b6..3329901 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -81,9 +81,7 @@ struct scsi_device {
 	struct list_head    siblings;   /* list of all devices on this host */
 	struct list_head    same_target_siblings; /* just the devices sharing same target id */
 
-	/* this is now protected by the request_queue->queue_lock */
-	unsigned int device_busy;	/* commands actually active on
-					 * low-level. protected by queue_lock. */
+	atomic_t device_busy;		/* commands actually active on LLDD */
 	spinlock_t list_lock;
 	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
 	struct list_head starved_entry;
-- 
1.9.1
