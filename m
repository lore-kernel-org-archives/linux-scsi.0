From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] scsi-ml: Add helper code so transport classes can
 control queueing
Date: Thu, 31 Jan 2008 16:28:06 -0600
Message-ID: <47A24B76.3030606@cs.wisc.edu>
References: <1201815396998-git-send-email-michaelc@cs.wisc.edu> <1201815396956-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010406050100070804000709"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44467 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933448AbYAaW2N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 17:28:13 -0500
Received: from [20.15.0.6] (c-75-73-66-60.hsd1.mn.comcast.net [75.73.66.60])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id m0VMSCM2023702
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2008 16:28:12 -0600
In-Reply-To: <1201815396956-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010406050100070804000709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

michaelc@cs.wisc.edu wrote:
> +static inline int scsi_target_ready(struct scsi_device *sdev)
> +{
> +	struct scsi_target *starget = scsi_target(sdev);
> +
> +	if (starget->single_lun) {
> +		if (starget->starget_sdev_user &&
> +		    starget->starget_sdev_user != sdev)
> +			return 0;
> +		starget->starget_sdev_user = sdev;
> +	}
> +
> +	if (starget->can_queue && starget->target_busy >= starget->can_queue)
> +		return 0;
> +	if (starget->target_busy == 0 && starget->target_blocked) {
> +		/*
> +		 * unblock after target_blocked iterates to zero
> +		 */
> +		if (--starget->target_blocked == 0) {
> +			SCSI_LOG_MLQUEUE(3,
> +				   starget_printk(KERN_INFO, starget,
> +				   "unblocking target at zero depth\n"));
> +		} else {
> +			blk_plug_device(sdev->request_queue);
> +			return 0;
> +		}
> +	}
> +	if (starget->target_blocked)
> +		return 0;
>

Sorry old patch. This one can starve devices here. An updated patch is 
attached.

--------------010406050100070804000709
Content-Type: text/x-patch;
 name="tgt-can-queue.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tgt-can-queue.patch"

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b35d194..339760a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -628,9 +628,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	if (rtn) {
 		if (scsi_delete_timer(cmd)) {
 			atomic_inc(&cmd->device->iodone_cnt);
-			scsi_queue_insert(cmd,
-					  (rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
-					  rtn : SCSI_MLQUEUE_HOST_BUSY);
+
+			if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
+			    rtn != SCSI_MLQUEUE_TARGET_BUSY)
+				rtn = SCSI_MLQUEUE_HOST_BUSY;
+
+			scsi_queue_insert(cmd, rtn);
 		}
 		SCSI_LOG_MLQUEUE(3,
 		    printk("queuecommand : request rejected\n"));
@@ -729,6 +732,7 @@ static struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 void scsi_finish_command(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
+	struct scsi_target *starget = scsi_target(sdev);
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_driver *drv;
 	unsigned int good_bytes;
@@ -744,6 +748,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 	 * XXX(hch): What about locking?
          */
         shost->host_blocked = 0;
+	starget->target_blocked = 0;
         sdev->device_blocked = 0;
 
 	/*
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b12fb31..9590630 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -114,6 +114,7 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
+	struct scsi_target *starget = scsi_target(device);
 	struct request_queue *q = device->request_queue;
 	unsigned long flags;
 
@@ -133,10 +134,17 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	 * if a command is requeued with no other commands outstanding
 	 * either for the device or for the host.
 	 */
-	if (reason == SCSI_MLQUEUE_HOST_BUSY)
-		host->host_blocked = host->max_host_blocked;
-	else if (reason == SCSI_MLQUEUE_DEVICE_BUSY)
-		device->device_blocked = device->max_device_blocked;
+	switch (reason) {
+	case SCSI_MLQUEUE_HOST_BUSY:
+ 		host->host_blocked = host->max_host_blocked;
+		break;
+	case SCSI_MLQUEUE_DEVICE_BUSY:
+ 		device->device_blocked = device->max_device_blocked;
+		break;
+	case SCSI_MLQUEUE_TARGET_BUSY:
+		starget->target_blocked = starget->max_target_blocked;
+		break;
+	}
 
 	/*
 	 * Decrement the counters, since these commands are no longer
@@ -452,10 +460,12 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 void scsi_device_unbusy(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
+	struct scsi_target *starget = scsi_target(sdev);
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_busy--;
+	starget->target_busy--;
 	if (unlikely(scsi_host_in_recovery(shost) &&
 		     (shost->host_failed || shost->host_eh_scheduled)))
 		scsi_eh_wakeup(shost);
@@ -1296,6 +1306,51 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 	return 1;
 }
 
+
+/*
+ * scsi_target_ready: checks if there we can send commands to target
+ * @sdev: scsi device on starget to check.
+ *
+ * Called with the host lock held.
+ */
+static inline int scsi_target_ready(struct Scsi_Host *shost,
+				    struct scsi_device *sdev)
+{
+	struct scsi_target *starget = scsi_target(sdev);
+
+	if (starget->single_lun) {
+		if (starget->starget_sdev_user &&
+		    starget->starget_sdev_user != sdev)
+			return 0;
+		starget->starget_sdev_user = sdev;
+	}
+
+	if (starget->target_busy == 0 && starget->target_blocked) {
+		/*
+		 * unblock after target_blocked iterates to zero
+		 */
+		if (--starget->target_blocked == 0) {
+			SCSI_LOG_MLQUEUE(3,
+				   starget_printk(KERN_INFO, starget,
+				   "unblocking target at zero depth\n"));
+		} else {
+			blk_plug_device(sdev->request_queue);
+			return 0;
+		}
+	}
+
+	if ((starget->can_queue > 0 &&
+	     starget->target_busy >= starget->can_queue) ||
+	     starget->target_blocked) {
+		if (list_empty(&sdev->starved_entry))
+			list_add_tail(&sdev->starved_entry,
+				      &shost->starved_list);
+		return 0;
+	}
+
+	return 1;
+}
+
 /*
  * scsi_host_queue_ready: if we can send requests to shost, return 1 else
  * return 0. We must end up running the queue again whenever 0 is
@@ -1343,6 +1398,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 {
 	struct scsi_cmnd *cmd = req->special;
 	struct scsi_device *sdev = cmd->device;
+	struct scsi_target *starget = scsi_target(sdev);
 	struct Scsi_Host *shost = sdev->host;
 
 	blkdev_dequeue_request(req);
@@ -1366,6 +1422,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	spin_unlock(sdev->request_queue->queue_lock);
 	spin_lock(shost->host_lock);
 	shost->host_busy++;
+	starget->target_busy++;
 	spin_unlock(shost->host_lock);
 	spin_lock(sdev->request_queue->queue_lock);
 
@@ -1479,14 +1536,13 @@ static void scsi_request_fn(struct request_queue *q)
 		}
 		spin_lock(shost->host_lock);
 
+		if (!scsi_target_ready(shost, sdev))
+			goto not_ready;
+
 		if (!scsi_host_queue_ready(q, shost, sdev))
 			goto not_ready;
-		if (scsi_target(sdev)->single_lun) {
-			if (scsi_target(sdev)->starget_sdev_user &&
-			    scsi_target(sdev)->starget_sdev_user != sdev)
-				goto not_ready;
-			scsi_target(sdev)->starget_sdev_user = sdev;
-		}
+
+		scsi_target(sdev)->target_busy++;
 		shost->host_busy++;
 
 		/*
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1dc165a..c9f7b74 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -396,6 +396,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		shost->host_no, channel, id);
 	starget->id = id;
 	starget->channel = channel;
+	starget->can_queue = 0;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
 	starget->state = STARGET_RUNNING;
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8225157..d4b23fc 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -367,6 +367,7 @@ struct scsi_lun {
 #define SCSI_MLQUEUE_HOST_BUSY   0x1055
 #define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
 #define SCSI_MLQUEUE_EH_RETRY    0x1057
+#define SCSI_MLQUEUE_TARGET_BUSY 0x1058
 
 /*
  *  Use these to separate status msg and our bytes
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ab7acbe..f8e4184 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -205,6 +205,16 @@ struct scsi_target {
 						 * for the device at a time. */
 	unsigned int		pdt_1f_for_no_lun;	/* PDT = 0x1f */
 						/* means no lun present */
+	/* commands actually active on LLD. protected by host lock. */
+	unsigned int		target_busy;
+	/*
+	 * LLDs should set this in the slave_alloc host template callout.
+	 * If set to zero then there is not limit.
+	 */
+	unsigned int		can_queue;
+	unsigned int		target_blocked;
+	unsigned int		max_target_blocked;
+#define SCSI_DEFAULT_TARGET_BLOCKED	3
 
 	char			scsi_level;
 	struct execute_work	ew;

--------------010406050100070804000709--
