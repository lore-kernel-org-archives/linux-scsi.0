From: mchristi@redhat.com
Subject: [PATCH 4/5] scsi: add new async device reset support
Date: Wed, 25 May 2016 02:55:02 -0500
Message-ID: <1464162903-14735-5-git-send-email-mchristi@redhat.com>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

Currently, if the SCSI eh runs then before we do a LUN_RESET
we stop the host. This patch and the block layer one before it
begin to add infrastructure to be able to do a LUN_RESET and
eventually do a transport level recovery without having to stop the
host.

For LUn-reset, this patch adds a new callout, eh_async_device_reset_handler,
which works similar to how LLDs handle SG_SCSI_RESET_DEVICE where the
LLD manages the commands that are affected.

eh_async_device_reset_handler:

The LLD should perform a LUN RESET that affects all commands
that have been accepted by its queuecommand callout for the
device passed in to the callout. While the reset handler is running,
queuecommand will not be running or called for the device.

Unlike eh_device_reset_handler, queuecommand may still be
called for other devices, and the LLD must call scsi_done for the
commands that have been affected by the reset.

If SUCCESS or FAST_IO_FAIL is returned, the scsi_cmnds cleaned up
must be failed with DID_ABORT.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/scsi/scsi_error.c | 31 ++++++++++++++++++++++++++++---
 drivers/scsi/scsi_lib.c   |  6 ++++++
 drivers/scsi/scsi_priv.h  |  1 +
 include/scsi/scsi_host.h  | 17 +++++++++++++++++
 4 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 984ddcb..cec2dfb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -853,16 +853,41 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
 	int rtn;
 	struct scsi_host_template *hostt = scmd->device->host->hostt;
+	struct scsi_device *sdev = scmd->device;
 
-	if (!hostt->eh_device_reset_handler)
+	if (!hostt->eh_device_reset_handler &&
+	    !hostt->eh_async_device_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_device_reset_handler(scmd);
+	if (hostt->eh_device_reset_handler) {
+		rtn = hostt->eh_device_reset_handler(scmd);
+	} else {
+		if (!blk_reset_queue(sdev->request_queue))
+			rtn = SUCCESS;
+		else
+			rtn = FAILED;
+	}
 	if (rtn == SUCCESS)
-		__scsi_report_device_reset(scmd->device, NULL);
+		__scsi_report_device_reset(sdev, NULL);
 	return rtn;
 }
 
+enum blk_eh_timer_return scsi_reset_queue(struct request_queue *q)
+{
+	struct scsi_device *sdev = q->queuedata;
+	struct scsi_host_template *hostt = sdev->host->hostt;
+	int rtn;
+
+	if (!hostt->eh_async_device_reset_handler)
+		return -EOPNOTSUPP;
+
+	rtn = hostt->eh_async_device_reset_handler(sdev);
+	if (rtn == SUCCESS || rtn == FAST_IO_FAIL)
+		return BLK_EH_HANDLED;
+
+	return BLK_EH_NOT_HANDLED;
+}
+
 /**
  * scsi_try_to_abort_cmd - Ask host to abort a SCSI command
  * @hostt:	SCSI driver host template
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8106515..11374dd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -779,6 +779,10 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 		set_host_byte(cmd, DID_OK);
 		error = -ENODATA;
 		break;
+	case DID_ABORT:
+		set_host_byte(cmd, DID_OK);
+		error = -EINTR;
+		break;
 	default:
 		error = -EIO;
 		break;
@@ -2159,6 +2163,7 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 	blk_queue_softirq_done(q, scsi_softirq_done);
 	blk_queue_rq_timed_out(q, scsi_times_out);
 	blk_queue_lld_busy(q, scsi_lld_busy);
+	blk_queue_reset(q, scsi_reset_queue);
 	return q;
 }
 
@@ -2167,6 +2172,7 @@ static struct blk_mq_ops scsi_mq_ops = {
 	.queue_rq	= scsi_queue_rq,
 	.complete	= scsi_softirq_done,
 	.timeout	= scsi_timeout,
+	.reset		= scsi_reset_queue,
 	.init_request	= scsi_init_request,
 	.exit_request	= scsi_exit_request,
 };
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 27b4d0a..2e03168 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -67,6 +67,7 @@ extern void scsi_exit_devinfo(void);
 
 /* scsi_error.c */
 extern void scmd_eh_abort_handler(struct work_struct *work);
+extern enum blk_eh_timer_return scsi_reset_queue(struct request_queue *q);
 extern enum blk_eh_timer_return scsi_times_out(struct request *req);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index fcfa3d7..532deb5 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -146,6 +146,23 @@ struct scsi_host_template {
 	 */
 	int (* eh_abort_handler)(struct scsi_cmnd *);
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
+	/*
+	 * eh_async_device_reset_handler - Perform LUN RESET
+	 * @scsi_device: scsi device to reset
+	 *
+	 * The LLD should perform a LUN RESET that affects all commands
+	 * that have been accepted by its queuecommand callout for the
+	 * device passed in. While the reset handler is running, queuecommand
+	 * will not be called for the device.
+	 *
+	 * Unlike eh_device_reset_handler, queuecommand may still be called
+	 * for other devices, and the LLD must call scsi_done for the commands
+	 * that have been affected by the reset.
+	 *
+	 * If SUCCESS or FAST_IO_FAIL is returned, the scsi_cmnds for
+	 * scsi_device must be failed with DID_ABORT.
+	 */
+	int (* eh_async_device_reset_handler)(struct scsi_device *);
 	int (* eh_target_reset_handler)(struct scsi_cmnd *);
 	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
 	int (* eh_host_reset_handler)(struct scsi_cmnd *);
-- 
2.7.2
