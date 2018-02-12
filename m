From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] scsi: Avoid that .queuecommand() gets called for a quiesced SCSI device
Date: Mon, 12 Feb 2018 10:57:17 -0800
Message-ID: <20180212185717.28002-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:53977 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbeBLS5S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 13:57:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>

Several SCSI transport and LLD drivers surround code that does not
tolerate concurrent calls of .queuecommand() with scsi_target_block() /
scsi_target_unblock(). These last two functions use
blk_mq_quiesce_queue() / blk_mq_unquiesce_queue() for scsi-mq request
queues to prevent concurrent .queuecommand() calls. However, that is
not sufficient to prevent .queuecommand() calls from scsi_send_eh_cmnd().
Hence surround the .queuecommand() call from the SCSI error handler with
code that avoids that .queuecommand() gets called in the quiesced state.

Notes:
- Converting the .queuecommand() call in scsi_send_eh_cmnd() into
  code that calls blk_get_request() + blk_execute_rq() is not an
  option since scsi_send_eh_cmnd() must be able to make forward progress
  even if all requests are allocated.
- Converting the .queuecommand() call in scsi_send_eh_cmnd() into a
  blk_execute_rq() or blk_mq_requeue_request() call is not an option either
  because that would require to change every individual function in the I/O
  path. Each function in the I/O path would have to be modified such that it
  handles requests received from the block layer core and request received
  from the SCSI EH differently. Since struct scsi_cmnd is not initialized by
  the block layer for filesystem requests, it is not possible to determine
  in scsi_queue_rq() whether or not a request has been submitted by the
  SCSI EH without modifying the block layer.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_error.c  | 13 +++++++++++++
 drivers/scsi/scsi_lib.c    |  2 ++
 drivers/scsi/scsi_scan.c   |  1 +
 include/scsi/scsi_device.h |  1 +
 4 files changed, 17 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a05111f7f345..3817083819c2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1041,6 +1041,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	unsigned long timeleft = timeout;
 	struct scsi_eh_save ses;
 	const unsigned long stall_for = msecs_to_jiffies(100);
+	DEFINE_WAIT(wait);
 	int rtn;
 
 retry:
@@ -1049,7 +1050,19 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 
 	scsi_log_send(scmd);
 	scmd->scsi_done = scsi_eh_done;
+	mutex_lock(&sdev->state_mutex);
+	while (sdev->sdev_state == SDEV_QUIESCE) {
+		prepare_to_wait(&sdev->state_wq, &wait, TASK_INTERRUPTIBLE);
+		mutex_unlock(&sdev->state_mutex);
+		SCSI_LOG_ERROR_RECOVERY(5, sdev_printk(KERN_DEBUG, sdev,
+			"%s: state %d <> %d\n", __func__, sdev->sdev_state,
+			SDEV_QUIESCE));
+		schedule();
+		mutex_lock(&sdev->state_mutex);
+	}
+	finish_wait(&sdev->state_wq, &wait);
 	rtn = shost->hostt->queuecommand(shost, scmd);
+	mutex_unlock(&sdev->state_mutex);
 	if (rtn) {
 		if (timeleft > stall_for) {
 			scsi_eh_restore_cmnd(scmd, &ses);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a86df9ca7d1c..b03cb2d5b733 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2730,6 +2730,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 
 	}
 	sdev->sdev_state = state;
+	wake_up_all(&sdev->state_wq);
 	return 0;
 
  illegal:
@@ -3189,6 +3190,7 @@ int scsi_internal_device_unblock_nowait(struct scsi_device *sdev,
 	default:
 		return -EINVAL;
 	}
+	wake_up_all(&sdev->state_wq);
 	scsi_start_queue(sdev);
 
 	return 0;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0880d975eed3..32439ca61c18 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -232,6 +232,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->id = starget->id;
 	sdev->lun = lun;
 	sdev->channel = starget->channel;
+	init_waitqueue_head(&sdev->state_wq);
 	mutex_init(&sdev->state_mutex);
 	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7ae177c8e399..eb9063202036 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -222,6 +222,7 @@ struct scsi_device {
 	void			*handler_data;
 
 	unsigned char		access_state;
+	struct wait_queue_head	state_wq;
 	struct mutex		state_mutex;
 	enum scsi_device_state sdev_state;
 	struct task_struct	*quiesced_by;
-- 
2.16.1
