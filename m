From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] scsi: remove extra white space at the end of the line
Date: Thu, 21 Dec 2017 10:40:49 +0800
Message-ID: <20171221024049.36509-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:52694 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755928AbdLUCdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 21:33:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>

My editor always try to remove the extra white space at the end of the
line when I make some changes. I'm tired of adjusting them manually.
Can we remove them in mainline?

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/scsi.c       |  2 +-
 drivers/scsi/scsi_lib.c   | 20 ++++++++++----------
 drivers/scsi/scsi_scan.c  | 10 +++++-----
 drivers/scsi/scsi_sysfs.c |  4 ++--
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a7e4fba..0f5bc03 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -185,7 +185,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
 	cmd->serial_number = host->cmd_serial_number++;
-	if (cmd->serial_number == 0) 
+	if (cmd->serial_number == 0)
 		cmd->serial_number = host->cmd_serial_number++;
 }
 EXPORT_SYMBOL(scsi_cmd_get_serial);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index bcc1694..a8dffd0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -385,7 +385,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_kick_queue(sdev->request_queue);
 		spin_lock_irqsave(shost->host_lock, flags);
-	
+
 		scsi_device_put(sdev);
 	}
  out:
@@ -1018,7 +1018,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb)
 			blk_rq_nr_phys_segments(req), sdb->table.sgl)))
 		return BLKPREP_DEFER;
 
-	/* 
+	/*
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
@@ -1826,7 +1826,7 @@ static void scsi_request_fn(struct request_queue *q)
 
 		if (!scsi_host_queue_ready(q, shost, sdev))
 			goto host_not_ready;
-	
+
 		if (sdev->simple_tags)
 			cmd->flags |= SCMD_TAGGED;
 		else
@@ -2412,7 +2412,7 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 		real_buffer[1] = data->medium_type;
 		real_buffer[2] = data->device_specific;
 		real_buffer[3] = data->block_descriptor_length;
-		
+
 
 		cmd[0] = MODE_SELECT;
 		cmd[4] = len;
@@ -2496,7 +2496,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		if (scsi_sense_valid(sshdr)) {
 			if ((sshdr->sense_key == ILLEGAL_REQUEST) &&
 			    (sshdr->asc == 0x20) && (sshdr->ascq == 0)) {
-				/* 
+				/*
 				 * Invalid command operation code
 				 */
 				sdev->use_10_for_ms = 0;
@@ -2598,7 +2598,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 			goto illegal;
 		}
 		break;
-			
+
 	case SDEV_RUNNING:
 		switch (oldstate) {
 		case SDEV_CREATED:
@@ -2909,7 +2909,7 @@ static void scsi_wait_for_queuecommand(struct scsi_device *sdev)
  *	(which must be a legal transition).  When the device is in this
  *	state, only special requests will be accepted, all others will
  *	be deferred.  Since special requests may also be requeued requests,
- *	a successful return doesn't guarantee the device will be 
+ *	a successful return doesn't guarantee the device will be
  *	totally quiescent.
  *
  *	Must be called with user context, may sleep.
@@ -3014,10 +3014,10 @@ int scsi_internal_device_block_nowait(struct scsi_device *sdev)
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
 		blk_mq_quiesce_queue_nowait(q);
@@ -3067,7 +3067,7 @@ static int scsi_internal_device_block(struct scsi_device *sdev)
 
 	return err;
 }
- 
+
 void scsi_start_queue(struct scsi_device *sdev)
 {
 	struct request_queue *q = sdev->request_queue;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4012464..c122f49 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -108,7 +108,7 @@ MODULE_PARM_DESC(scan, "sync, async, manual, or none. "
 static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ + 18;
 
 module_param_named(inq_timeout, scsi_inq_timeout, uint, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(inq_timeout, 
+MODULE_PARM_DESC(inq_timeout,
 		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
 		 " Default is 20. Some devices may need more; most need less.");
 
@@ -612,7 +612,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			 * not-ready to ready transition [asc/ascq=0x28/0x0]
 			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
 			 * INQUIRY should not yield UNIT_ATTENTION
-			 * but many buggy devices do so anyway. 
+			 * but many buggy devices do so anyway.
 			 */
 			if ((driver_byte(result) & DRIVER_SENSE) &&
 			    scsi_sense_valid(&sshdr)) {
@@ -858,7 +858,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * Don't set the device offline here; rather let the upper
 	 * level drivers eval the PQ to decide whether they should
 	 * attach. So remove ((inq_result[0] >> 5) & 7) == 1 check.
-	 */ 
+	 */
 
 	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
 	sdev->lockable = sdev->removable;
@@ -1001,7 +1001,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 }
 
 #ifdef CONFIG_SCSI_LOGGING
-/** 
+/**
  * scsi_inq_str - print INQUIRY data from min to max index, strip trailing whitespace
  * @buf:   Output buffer with at least end-first+1 bytes of space
  * @inq:   Inquiry buffer (input)
@@ -1501,7 +1501,7 @@ EXPORT_SYMBOL(__scsi_add_device);
 int scsi_add_device(struct Scsi_Host *host, uint channel,
 		    uint target, u64 lun)
 {
-	struct scsi_device *sdev = 
+	struct scsi_device *sdev =
 		__scsi_add_device(host, channel, target, lun, NULL);
 	if (IS_ERR(sdev))
 		return PTR_ERR(sdev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f796bd6..66fc622 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -622,7 +622,7 @@ static int scsi_sdev_check_buf_bit(const char *buf)
 			return 1;
 		else if (buf[0] == '0')
 			return 0;
-		else 
+		else
 			return -EINVAL;
 	} else
 		return -EINVAL;
@@ -788,7 +788,7 @@ store_queue_type_field(struct device *dev, struct device_attribute *attr,
 
 	if (!sdev->tagged_supported)
 		return -EINVAL;
-		
+
 	sdev_printk(KERN_INFO, sdev,
 		    "ignoring write to deprecated queue_type attribute");
 	return count;
-- 
2.9.5
