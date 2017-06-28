From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 47/47] scsi: Do not allocate scsi command in scsi_ioctl_reset()
Date: Wed, 28 Jun 2017 10:33:13 +0200
Message-ID: <1498638793-44672-48-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53804 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751942AbdF1Idk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:40 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

As we now have moved the error handler functions to not rely on
a scsi command we can drop the out-of-band scsi command allocation
from scsi_ioctl_reset().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 124 +++++++++++++++++++---------------------------
 1 file changed, 50 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4a7fe97f..ab178e8 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -728,16 +728,22 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 		complete(eh_action);
 }
 
+static void __scsi_report_device_reset(struct scsi_device *sdev)
+{
+	sdev->was_reset = 1;
+	sdev->expecting_cc_ua = 1;
+}
+
 /**
  * scsi_try_host_reset - ask host adapter to reset itself
- * @scmd:	SCSI cmd to send host reset.
+ * @host:	SCSI host to be reset.
  */
-static int scsi_try_host_reset(struct scsi_cmnd *scmd)
+static int scsi_try_host_reset(struct Scsi_Host *host)
 {
 	unsigned long flags;
 	int rtn;
-	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
+	struct scsi_device *sdev;
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		shost_printk(KERN_INFO, host, "Snd Host RST\n"));
@@ -751,7 +757,8 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 		if (!hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
 		spin_lock_irqsave(host->host_lock, flags);
-		scsi_report_bus_reset(host, scmd_channel(scmd));
+		__shost_for_each_device(sdev, host)
+			__scsi_report_device_reset(sdev);
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
@@ -760,43 +767,38 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 
 /**
  * scsi_try_bus_reset - ask host to perform a bus reset
- * @scmd:	SCSI cmd to send bus reset.
+ * @host:	SCSI host to send bus reset.
+ * @channel:	bus number to be reset.
  */
-static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
+static int scsi_try_bus_reset(struct Scsi_Host *host, int channel)
 {
 	unsigned long flags;
 	int rtn;
-	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
 
-	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+	SCSI_LOG_ERROR_RECOVERY(3, shost_printk(KERN_INFO, host,
 		"%s: Snd Bus RST\n", __func__));
 
 	if (!hostt->eh_bus_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_bus_reset_handler(host, scmd_channel(scmd));
+	rtn = hostt->eh_bus_reset_handler(host, channel);
 
 	if (rtn == SUCCESS) {
 		if (!hostt->skip_settle_delay)
 			ssleep(BUS_RESET_SETTLE_TIME);
 		spin_lock_irqsave(host->host_lock, flags);
-		scsi_report_bus_reset(host, scmd_channel(scmd));
+		scsi_report_bus_reset(host, channel);
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
 	return rtn;
 }
 
-static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
-{
-	sdev->was_reset = 1;
-	sdev->expecting_cc_ua = 1;
-}
-
 /**
  * scsi_try_target_reset - Ask host to perform a target reset
- * @scmd:	SCSI cmd used to send a target reset
+ * @shost:	SCSI Host
+ * @starget:	SCSI target to be reset
  *
  * Notes:
  *    There is no timeout for this operation.  if this operation is
@@ -804,13 +806,13 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  */
-static int scsi_try_target_reset(struct scsi_cmnd *scmd)
+static int scsi_try_target_reset(struct Scsi_Host *host,
+				 struct scsi_target *starget)
 {
 	unsigned long flags;
 	int rtn;
-	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_device *sdev;
 	struct scsi_host_template *hostt = host->hostt;
-	struct scsi_target *starget = scsi_target(scmd->device);
 
 	if (!hostt->eh_target_reset_handler)
 		return FAILED;
@@ -818,8 +820,11 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 	rtn = hostt->eh_target_reset_handler(starget);
 	if (rtn == SUCCESS) {
 		spin_lock_irqsave(host->host_lock, flags);
-		__starget_for_each_device(starget, NULL,
-					  __scsi_report_device_reset);
+		__shost_for_each_device(sdev, host) {
+			if ((sdev->channel == starget->channel) &&
+			    (sdev->id == starget->id))
+				__scsi_report_device_reset(sdev);
+		}
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
@@ -836,17 +841,17 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  */
-static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
+static int scsi_try_bus_device_reset(struct scsi_device *sdev)
 {
 	int rtn;
-	struct scsi_host_template *hostt = scmd->device->host->hostt;
+	struct scsi_host_template *hostt = sdev->host->hostt;
 
 	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_device_reset_handler(scmd->device);
+	rtn = hostt->eh_device_reset_handler(sdev);
 	if (rtn == SUCCESS)
-		__scsi_report_device_reset(scmd->device, NULL);
+		__scsi_report_device_reset(sdev);
 	return rtn;
 }
 
@@ -878,11 +883,15 @@ static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
 
 static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 {
-	if (scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd) != SUCCESS)
-		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
-			if (scsi_try_target_reset(scmd) != SUCCESS)
-				if (scsi_try_bus_reset(scmd) != SUCCESS)
-					scsi_try_host_reset(scmd);
+	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_target *starget = scsi_target(scmd->device);
+	int channel = scmd->device->channel;
+
+	if (scsi_try_to_abort_cmd(host->hostt, scmd) != SUCCESS)
+		if (scsi_try_bus_device_reset(scmd->device) != SUCCESS)
+			if (scsi_try_target_reset(host, starget) != SUCCESS)
+				if (scsi_try_bus_reset(host, channel) != SUCCESS)
+					scsi_try_host_reset(host);
 }
 
 /**
@@ -1430,7 +1439,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 		SCSI_LOG_ERROR_RECOVERY(3,
 			sdev_printk(KERN_INFO, sdev,
 				     "%s: Sending BDR\n", current->comm));
-		rtn = scsi_try_bus_device_reset(bdr_scmd);
+		rtn = scsi_try_bus_device_reset(sdev);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			if (!scsi_device_online(sdev) ||
 			    rtn == FAST_IO_FAIL ||
@@ -1495,7 +1504,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 			shost_printk(KERN_INFO, shost,
 				     "%s: Sending target reset to target %d\n",
 				     current->comm, id));
-		rtn = scsi_try_target_reset(scmd);
+		rtn = scsi_try_target_reset(shost, scsi_target(scmd->device));
 		if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
@@ -1570,7 +1579,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			shost_printk(KERN_INFO, shost,
 				     "%s: Sending BRST chan: %d\n",
 				     current->comm, channel));
-		rtn = scsi_try_bus_reset(chan_scmd);
+		rtn = scsi_try_bus_reset(shost, channel);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd_channel(scmd)) {
@@ -1608,15 +1617,12 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
 	int rtn;
 
 	if (!list_empty(work_q)) {
-		scmd = list_entry(work_q->next,
-				  struct scsi_cmnd, eh_entry);
-
 		SCSI_LOG_ERROR_RECOVERY(3,
 			shost_printk(KERN_INFO, shost,
 				     "%s: Sending HRST\n",
 				     current->comm));
 
-		rtn = scsi_try_host_reset(scmd);
+		rtn = scsi_try_host_reset(shost);
 		if (rtn == SUCCESS) {
 			list_splice_init(work_q, &check_list);
 		} else if (rtn == FAST_IO_FAIL) {
@@ -2221,7 +2227,7 @@ void scsi_report_bus_reset(struct Scsi_Host *shost, int channel)
 
 	__shost_for_each_device(sdev, shost) {
 		if (channel == sdev_channel(sdev))
-			__scsi_report_device_reset(sdev, NULL);
+			__scsi_report_device_reset(sdev);
 	}
 }
 EXPORT_SYMBOL(scsi_report_bus_reset);
@@ -2255,16 +2261,11 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 	__shost_for_each_device(sdev, shost) {
 		if (channel == sdev_channel(sdev) &&
 		    target == sdev_id(sdev))
-			__scsi_report_device_reset(sdev, NULL);
+			__scsi_report_device_reset(sdev);
 	}
 }
 EXPORT_SYMBOL(scsi_report_device_reset);
 
-static void
-scsi_reset_provider_done_command(struct scsi_cmnd *scmd)
-{
-}
-
 /**
  * scsi_ioctl_reset: explicitly reset a host/bus/target/device
  * @dev:	scsi_device to operate on
@@ -2273,9 +2274,7 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 int
 scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 {
-	struct scsi_cmnd *scmd;
 	struct Scsi_Host *shost = dev->host;
-	struct request *rq;
 	unsigned long flags;
 	int error = 0, rtn, val;
 
@@ -2290,24 +2289,6 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 		return -EIO;
 
 	error = -EIO;
-	rq = kzalloc(sizeof(struct request) + sizeof(struct scsi_cmnd) +
-			shost->hostt->cmd_size, GFP_KERNEL);
-	if (!rq)
-		goto out_put_autopm_host;
-	blk_rq_init(NULL, rq);
-
-	scmd = (struct scsi_cmnd *)(rq + 1);
-	scsi_init_command(dev, scmd);
-	scmd->request = rq;
-	scmd->cmnd = scsi_req(rq)->cmd;
-
-	scmd->scsi_done		= scsi_reset_provider_done_command;
-	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
-
-	scmd->cmd_len			= 0;
-
-	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
-
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->tmf_in_progress = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -2317,22 +2298,22 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 		rtn = SUCCESS;
 		break;
 	case SG_SCSI_RESET_DEVICE:
-		rtn = scsi_try_bus_device_reset(scmd);
+		rtn = scsi_try_bus_device_reset(dev);
 		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		/* FALLTHROUGH */
 	case SG_SCSI_RESET_TARGET:
-		rtn = scsi_try_target_reset(scmd);
+		rtn = scsi_try_target_reset(shost, scsi_target(dev));
 		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		/* FALLTHROUGH */
 	case SG_SCSI_RESET_BUS:
-		rtn = scsi_try_bus_reset(scmd);
+		rtn = scsi_try_bus_reset(shost, dev->channel);
 		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		/* FALLTHROUGH */
 	case SG_SCSI_RESET_HOST:
-		rtn = scsi_try_host_reset(scmd);
+		rtn = scsi_try_host_reset(shost);
 		if (rtn == SUCCESS)
 			break;
 	default:
@@ -2357,11 +2338,6 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 
 	wake_up(&shost->host_wait);
 	scsi_run_host_queues(shost);
-
-	scsi_put_command(scmd);
-	kfree(rq);
-
-out_put_autopm_host:
 	scsi_autopm_put_host(shost);
 	return error;
 }
-- 
1.8.5.6
