From: Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] scsi: fix potential integer signedness problem
Date: Mon, 18 Jan 2016 14:55:09 -0500
Message-ID: <1453146909-28314-1-git-send-email-wuninsu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Since len is signed integer variable, it is better to check
whether len is non-negative or not.
If non-negative value len gives, it can cause heap overflow.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/scsi/scsi_lib.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fa6b2c4..5c64c80 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -271,7 +271,7 @@ int scsi_execute_req_flags(struct scsi_device *sdev, const unsigned char *cmd,
 {
 	char *sense = NULL;
 	int result;
-	
+
 	if (sshdr) {
 		sense = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
 		if (!sense)
@@ -374,7 +374,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_kick_queue(sdev->request_queue);
 		spin_lock_irqsave(shost->host_lock, flags);
-	
+
 		scsi_device_put(sdev);
 	}
  out:
@@ -1089,7 +1089,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
 					req->mq_ctx != NULL)))
 		return BLKPREP_DEFER;
 
-	/* 
+	/*
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
@@ -1835,7 +1835,7 @@ static void scsi_request_fn(struct request_queue *q)
 
 		if (!scsi_host_queue_ready(q, shost, sdev))
 			goto host_not_ready;
-	
+
 		if (sdev->simple_tags)
 			cmd->flags |= SCMD_TAGGED;
 		else
@@ -2349,6 +2349,9 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 	unsigned char *real_buffer;
 	int ret;
 
+	if (len < 0)
+		return -EINVAL;
+
 	memset(cmd, 0, sizeof(cmd));
 	cmd[1] = (pf ? 0x10 : 0) | (sp ? 0x01 : 0);
 
@@ -2386,7 +2389,7 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 		real_buffer[1] = data->medium_type;
 		real_buffer[2] = data->device_specific;
 		real_buffer[3] = data->block_descriptor_length;
-		
+
 
 		cmd[0] = MODE_SELECT;
 		cmd[4] = len;
@@ -2470,7 +2473,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		if (scsi_sense_valid(sshdr)) {
 			if ((sshdr->sense_key == ILLEGAL_REQUEST) &&
 			    (sshdr->asc == 0x20) && (sshdr->ascq == 0)) {
-				/* 
+				/*
 				 * Invalid command operation code
 				 */
 				sdev->use_10_for_ms = 0;
@@ -2562,7 +2565,7 @@ EXPORT_SYMBOL(scsi_test_unit_ready);
  *	@sdev:	scsi device to change the state of.
  *	@state:	state to change to.
  *
- *	Returns zero if unsuccessful or an error if the requested 
+ *	Returns zero if unsuccessful or an error if the requested
  *	transition is illegal.
  */
 int
@@ -2582,7 +2585,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 			goto illegal;
 		}
 		break;
-			
+
 	case SDEV_RUNNING:
 		switch (oldstate) {
 		case SDEV_CREATED:
@@ -2859,7 +2862,7 @@ EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
  *	(which must be a legal transition).  When the device is in this
  *	state, only special requests will be accepted, all others will
  *	be deferred.  Since special requests may also be requeued requests,
- *	a successful return doesn't guarantee the device will be 
+ *	a successful return doesn't guarantee the device will be
  *	totally quiescent.
  *
  *	Must be called with user context, may sleep.
@@ -2940,7 +2943,7 @@ EXPORT_SYMBOL(scsi_target_resume);
  *
  * Returns zero if successful or error if not
  *
- * Notes:       
+ * Notes:
  *	This routine transitions the device to the SDEV_BLOCK state
  *	(which must be a legal transition).  When the device is in this
  *	state, all commands are deferred until the scsi lld reenables
@@ -2961,10 +2964,10 @@ scsi_internal_device_block(struct scsi_device *sdev)
 			return err;
 	}
 
-	/* 
+	/*
 	 * The device has transitioned to SDEV_BLOCK.  Stop the
 	 * block layer from calling the midlayer with this device's
-	 * request queue. 
+	 * request queue.
 	 */
 	if (q->mq_ops) {
 		blk_mq_stop_hw_queues(q);
@@ -2977,7 +2980,7 @@ scsi_internal_device_block(struct scsi_device *sdev)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_block);
- 
+
 /**
  * scsi_internal_device_unblock - resume a device after a block request
  * @sdev:	device to resume
@@ -2989,7 +2992,7 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_block);
  *
  * Returns zero if successful or error if not.
  *
- * Notes:       
+ * Notes:
  *	This routine transitions the device to the SDEV_RUNNING state
  *	or to one of the offline states (which must be a legal transition)
  *	allowing the midlayer to goose the queue for this device.
@@ -2998,7 +3001,7 @@ int
 scsi_internal_device_unblock(struct scsi_device *sdev,
 			     enum scsi_device_state new_state)
 {
-	struct request_queue *q = sdev->request_queue; 
+	struct request_queue *q = sdev->request_queue;
 	unsigned long flags;
 
 	/*
-- 
1.9.1
