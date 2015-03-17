From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 03/42] hpsa: rework controller command submission
Date: Tue, 17 Mar 2015 15:02:42 -0500
Message-ID: <20150317200241.19856.46521.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:35868 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbbCQUEV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:04:21 -0400
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 7FB3E4AF5
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2015 20:04:21 +0000 (UTC)
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webb.scales@hp.com>

Allow driver initiated commands to have a timeout.  It does not
yet try to do anything with timeouts on such commands.

We are sending a reset in order to get rid of a command we want to abort.
If we make it return on the same reply queue as the command we want to abort,
the completion of the aborted command will not race with the completion of
the reset command.

Rename hpsa_scsi_do_simple_cmd_core() to hpsa_scsi_do_simple_cmd(), since
this function is the interface for issuing commands to the controller and
not the "core" of that implementation.  Add a parameter to it which allows
the caller to specify the reply queue to be used.  Modify existing callers
to specify the default reply queue.

Rename __hpsa_scsi_do_simple_cmd_core() to hpsa_scsi_do_simple_cmd_core(),
since this routine is the "core" implementation of the "do simple command"
function and there is no longer any other function with a similar name.
Modify the existing callers of this routine (other than
hpsa_scsi_do_simple_cmd()) to instead call hpsa_scsi_do_simple_cmd(), since
it will now accept the reply_queue paramenter, and it provides a controller
lock-up check.  (Also, tweak two related message strings to make them
distinct from each other.)

Submitting a command to a locked up controller always results in a timeout,
so check for controller lock-up before submitting.

This is to enable fixing a race between command completions and
abort completions on different reply queues in a subsequent patch.
We want to be able to specify which reply queue an abort completion
should occur on so that it cannot race the completion of the command
it is trying to abort.

The following race was possible in theory:

  1. Abort command is sent to hardware.
  2. Command to be aborted simultaneously completes on another
     reply queue.
  3. Hardware receives abort command, decides command has already
     completed and indicates this to the driver via another different
     reply queue.
  4. driver processes abort completion finds that the hardware does not know
     about the command, concludes that therefore the command cannot complete,
     returns SUCCESS indicating to the mid-layer that the scsi_cmnd may be
     re-used.
  5. Command from step 2 is processed and completed back to scsi mid
     layer (after we already promised that would never happen.)

Fix by forcing aborts to complete on the same reply queue as the command
they are aborting.

Piggybacking device rescanning functionality onto the lockup
detection thread is not a good idea because if the controller
locks up during device rescanning, then the thread could get
stuck, then the lockup isn't detected.  Use separate work
queues for device rescanning and lockup detection.

Detect controller lockup in abort handler.

After a lockup is detected, return DO_NO_CONNECT which results in immediate
termination of commands rather than DID_ERR which results in retries.

Modify detect_controller_lockup() to return the result, to remove the need for a separate check.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |  326 ++++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/hpsa_cmd.h |    5 +
 2 files changed, 254 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9b88726..488f81b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -253,6 +253,8 @@ static int hpsa_scsi_ioaccel_queue_command(struct ctlr_info *h,
 	struct CommandList *c, u32 ioaccel_handle, u8 *cdb, int cdb_len,
 	u8 *scsi3addr, struct hpsa_scsi_dev_t *phys_disk);
 static void hpsa_command_resubmit_worker(struct work_struct *work);
+static u32 lockup_detected(struct ctlr_info *h);
+static int detect_controller_lockup(struct ctlr_info *h);
 
 static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
 {
@@ -748,30 +750,43 @@ static inline u32 next_command(struct ctlr_info *h, u8 q)
  * a separate special register for submitting commands.
  */
 
-/* set_performant_mode: Modify the tag for cciss performant
+/*
+ * set_performant_mode: Modify the tag for cciss performant
  * set bit 0 for pull model, bits 3-1 for block fetch
  * register number
  */
-static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
+#define DEFAULT_REPLY_QUEUE (-1)
+static void set_performant_mode(struct ctlr_info *h, struct CommandList *c,
+					int reply_queue)
 {
 	if (likely(h->transMethod & CFGTBL_Trans_Performant)) {
 		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
-		if (likely(h->msix_vector > 0))
+		if (unlikely(!h->msix_vector))
+			return;
+		if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
 			c->Header.ReplyQueue =
 				raw_smp_processor_id() % h->nreply_queues;
+		else
+			c->Header.ReplyQueue = reply_queue % h->nreply_queues;
 	}
 }
 
 static void set_ioaccel1_performant_mode(struct ctlr_info *h,
-						struct CommandList *c)
+						struct CommandList *c,
+						int reply_queue)
 {
 	struct io_accel1_cmd *cp = &h->ioaccel_cmd_pool[c->cmdindex];
 
-	/* Tell the controller to post the reply to the queue for this
+	/*
+	 * Tell the controller to post the reply to the queue for this
 	 * processor.  This seems to give the best I/O throughput.
 	 */
-	cp->ReplyQueue = smp_processor_id() % h->nreply_queues;
-	/* Set the bits in the address sent down to include:
+	if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
+		cp->ReplyQueue = smp_processor_id() % h->nreply_queues;
+	else
+		cp->ReplyQueue = reply_queue % h->nreply_queues;
+	/*
+	 * Set the bits in the address sent down to include:
 	 *  - performant mode bit (bit 0)
 	 *  - pull count (bits 1-3)
 	 *  - command type (bits 4-6)
@@ -781,15 +796,21 @@ static void set_ioaccel1_performant_mode(struct ctlr_info *h,
 }
 
 static void set_ioaccel2_performant_mode(struct ctlr_info *h,
-						struct CommandList *c)
+						struct CommandList *c,
+						int reply_queue)
 {
 	struct io_accel2_cmd *cp = &h->ioaccel2_cmd_pool[c->cmdindex];
 
-	/* Tell the controller to post the reply to the queue for this
+	/*
+	 * Tell the controller to post the reply to the queue for this
 	 * processor.  This seems to give the best I/O throughput.
 	 */
-	cp->reply_queue = smp_processor_id() % h->nreply_queues;
-	/* Set the bits in the address sent down to include:
+	if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
+		cp->reply_queue = smp_processor_id() % h->nreply_queues;
+	else
+		cp->reply_queue = reply_queue % h->nreply_queues;
+	/*
+	 * Set the bits in the address sent down to include:
 	 *  - performant mode bit not used in ioaccel mode 2
 	 *  - pull count (bits 0-3)
 	 *  - command type isn't needed for ioaccel2
@@ -826,26 +847,32 @@ static void dial_up_lockup_detection_on_fw_flash_complete(struct ctlr_info *h,
 		h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
 }
 
-static void enqueue_cmd_and_start_io(struct ctlr_info *h,
-	struct CommandList *c)
+static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
+	struct CommandList *c, int reply_queue)
 {
 	dial_down_lockup_detection_during_fw_flash(h, c);
 	atomic_inc(&h->commands_outstanding);
 	switch (c->cmd_type) {
 	case CMD_IOACCEL1:
-		set_ioaccel1_performant_mode(h, c);
+		set_ioaccel1_performant_mode(h, c, reply_queue);
 		writel(c->busaddr, h->vaddr + SA5_REQUEST_PORT_OFFSET);
 		break;
 	case CMD_IOACCEL2:
-		set_ioaccel2_performant_mode(h, c);
+		set_ioaccel2_performant_mode(h, c, reply_queue);
 		writel(c->busaddr, h->vaddr + IOACCEL2_INBOUND_POSTQ_32);
 		break;
 	default:
-		set_performant_mode(h, c);
+		set_performant_mode(h, c, reply_queue);
 		h->access.submit_command(h, c);
 	}
 }
 
+static void enqueue_cmd_and_start_io(struct ctlr_info *h,
+					struct CommandList *c)
+{
+	__enqueue_cmd_and_start_io(h, c, DEFAULT_REPLY_QUEUE);
+}
+
 static inline int is_hba_lunid(unsigned char scsi3addr[])
 {
 	return memcmp(scsi3addr, RAID_CTLR_LUNID, 8) == 0;
@@ -1877,6 +1904,19 @@ static void complete_scsi_command(struct CommandList *cp)
 	if (cp->cmd_type == CMD_IOACCEL2 || cp->cmd_type == CMD_IOACCEL1)
 		atomic_dec(&cp->phys_disk->ioaccel_cmds_out);
 
+	/*
+	 * We check for lockup status here as it may be set for
+	 * CMD_SCSI, CMD_IOACCEL1 and CMD_IOACCEL2 commands by
+	 * fail_all_oustanding_cmds()
+	 */
+	if (unlikely(ei->CommandStatus == CMD_CTLR_LOCKUP)) {
+		/* DID_NO_CONNECT will prevent a retry */
+		cmd->result = DID_NO_CONNECT << 16;
+		cmd_free(h, cp);
+		cmd->scsi_done(cmd);
+		return;
+	}
+
 	if (cp->cmd_type == CMD_IOACCEL2)
 		return process_ioaccel2_completion(h, cp, cmd, dev);
 
@@ -2091,14 +2131,36 @@ static int hpsa_map_one(struct pci_dev *pdev,
 	return 0;
 }
 
-static inline void hpsa_scsi_do_simple_cmd_core(struct ctlr_info *h,
-	struct CommandList *c)
+#define NO_TIMEOUT ((unsigned long) -1)
+#define DEFAULT_TIMEOUT 30000 /* milliseconds */
+static int hpsa_scsi_do_simple_cmd_core(struct ctlr_info *h,
+	struct CommandList *c, int reply_queue, unsigned long timeout_msecs)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 
 	c->waiting = &wait;
-	enqueue_cmd_and_start_io(h, c);
-	wait_for_completion(&wait);
+	__enqueue_cmd_and_start_io(h, c, reply_queue);
+	if (timeout_msecs == NO_TIMEOUT) {
+		/* TODO: get rid of this no-timeout thing */
+		wait_for_completion_io(&wait);
+		return IO_OK;
+	}
+	if (!wait_for_completion_io_timeout(&wait,
+					msecs_to_jiffies(timeout_msecs))) {
+		dev_warn(&h->pdev->dev, "Command timed out.\n");
+		return -ETIMEDOUT;
+	}
+	return IO_OK;
+}
+
+static int hpsa_scsi_do_simple_cmd(struct ctlr_info *h, struct CommandList *c,
+				   int reply_queue, unsigned long timeout_msecs)
+{
+	if (unlikely(lockup_detected(h))) {
+		c->err_info->CommandStatus = CMD_CTLR_LOCKUP;
+		return IO_OK;
+	}
+	return hpsa_scsi_do_simple_cmd_core(h, c, reply_queue, timeout_msecs);
 }
 
 static u32 lockup_detected(struct ctlr_info *h)
@@ -2113,25 +2175,19 @@ static u32 lockup_detected(struct ctlr_info *h)
 	return rc;
 }
 
-static void hpsa_scsi_do_simple_cmd_core_if_no_lockup(struct ctlr_info *h,
-	struct CommandList *c)
-{
-	/* If controller lockup detected, fake a hardware error. */
-	if (unlikely(lockup_detected(h)))
-		c->err_info->CommandStatus = CMD_HARDWARE_ERR;
-	else
-		hpsa_scsi_do_simple_cmd_core(h, c);
-}
-
 #define MAX_DRIVER_CMD_RETRIES 25
-static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
-	struct CommandList *c, int data_direction)
+static int hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
+	struct CommandList *c, int data_direction, unsigned long timeout_msecs)
 {
 	int backoff_time = 10, retry_count = 0;
+	int rc;
 
 	do {
 		memset(c->err_info, 0, sizeof(*c->err_info));
-		hpsa_scsi_do_simple_cmd_core(h, c);
+		rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE,
+						  timeout_msecs);
+		if (rc)
+			break;
 		retry_count++;
 		if (retry_count > 3) {
 			msleep(backoff_time);
@@ -2142,6 +2198,9 @@ static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
 			check_for_busy(h, c)) &&
 			retry_count <= MAX_DRIVER_CMD_RETRIES);
 	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
+	if (retry_count > MAX_DRIVER_CMD_RETRIES)
+		rc = -EIO;
+	return rc;
 }
 
 static void hpsa_print_cmd(struct ctlr_info *h, char *txt,
@@ -2218,6 +2277,9 @@ static void hpsa_scsi_interpret_error(struct ctlr_info *h,
 	case CMD_UNABORTABLE:
 		hpsa_print_cmd(h, "unabortable", cp);
 		break;
+	case CMD_CTLR_LOCKUP:
+		hpsa_print_cmd(h, "controller lockup detected", cp);
+		break;
 	default:
 		hpsa_print_cmd(h, "unknown status", cp);
 		dev_warn(d, "Unknown command status %x\n",
@@ -2245,7 +2307,10 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 		rc = -1;
 		goto out;
 	}
-	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
+	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
+			PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+	if (rc)
+		goto out;
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		hpsa_scsi_interpret_error(h, c);
@@ -2275,7 +2340,10 @@ static int hpsa_bmic_ctrl_mode_sense(struct ctlr_info *h,
 		rc = -1;
 		goto out;
 	}
-	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
+	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
+					PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+	if (rc)
+		goto out;
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		hpsa_scsi_interpret_error(h, c);
@@ -2287,7 +2355,7 @@ out:
 	}
 
 static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
-	u8 reset_type)
+	u8 reset_type, int reply_queue)
 {
 	int rc = IO_OK;
 	struct CommandList *c;
@@ -2304,7 +2372,11 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 	(void) fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0,
 			scsi3addr, TYPE_MSG);
 	c->Request.CDB[1] = reset_type; /* fill_cmd defaults to LUN reset */
-	hpsa_scsi_do_simple_cmd_core(h, c);
+	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
+	if (rc) {
+		dev_warn(&h->pdev->dev, "Failed to send reset command\n");
+		goto out;
+	}
 	/* no unmap needed here because no data xfer. */
 
 	ei = c->err_info;
@@ -2312,6 +2384,7 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 		hpsa_scsi_interpret_error(h, c);
 		rc = -1;
 	}
+out:
 	cmd_free(h, c);
 	return rc;
 }
@@ -2429,15 +2502,18 @@ static int hpsa_get_raid_map(struct ctlr_info *h,
 			sizeof(this_device->raid_map), 0,
 			scsi3addr, TYPE_CMD)) {
 		dev_warn(&h->pdev->dev, "Out of memory in hpsa_get_raid_map()\n");
-		cmd_free(h, c);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out;
 	}
-	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
+	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
+					PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+	if (rc)
+		goto out;
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		hpsa_scsi_interpret_error(h, c);
-		cmd_free(h, c);
-		return -1;
+		rc = -1;
+		goto out;
 	}
 	cmd_free(h, c);
 
@@ -2449,6 +2525,9 @@ static int hpsa_get_raid_map(struct ctlr_info *h,
 	}
 	hpsa_debug_map_buff(h, rc, &this_device->raid_map);
 	return rc;
+out:
+	cmd_free(h, c);
+	return rc;
 }
 
 static int hpsa_bmic_id_physical_device(struct ctlr_info *h,
@@ -2468,7 +2547,8 @@ static int hpsa_bmic_id_physical_device(struct ctlr_info *h,
 	c->Request.CDB[2] = bmic_device_index & 0xff;
 	c->Request.CDB[9] = (bmic_device_index >> 8) & 0xff;
 
-	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
+	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE,
+						NO_TIMEOUT);
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		hpsa_scsi_interpret_error(h, c);
@@ -2603,7 +2683,10 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 	}
 	if (extended_response)
 		c->Request.CDB[1] = extended_response;
-	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
+	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
+					PCI_DMA_FROMDEVICE, NO_TIMEOUT);
+	if (rc)
+		goto out;
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 &&
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
@@ -2696,7 +2779,7 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 {
 	struct CommandList *c;
 	unsigned char *sense, sense_key, asc, ascq;
-	int ldstat = 0;
+	int rc, ldstat = 0;
 	u16 cmd_status;
 	u8 scsi_status;
 #define ASC_LUN_NOT_READY 0x04
@@ -2707,7 +2790,11 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 	if (!c)
 		return 0;
 	(void) fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0, scsi3addr, TYPE_CMD);
-	hpsa_scsi_do_simple_cmd_core(h, c);
+	rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE, NO_TIMEOUT);
+	if (rc) {
+		cmd_free(h, c);
+		return 0;
+	}
 	sense = c->err_info->SenseInfo;
 	sense_key = sense[2];
 	asc = sense[12];
@@ -4040,7 +4127,11 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 						dev->phys_disk[map_index]);
 }
 
-/* Submit commands down the "normal" RAID stack path */
+/*
+ * Submit commands down the "normal" RAID stack path
+ * All callers to hpsa_ciss_submit must check lockup_detected
+ * beforehand, before (opt.) and after calling cmd_alloc
+ */
 static int hpsa_ciss_submit(struct ctlr_info *h,
 	struct CommandList *c, struct scsi_cmnd *cmd,
 	unsigned char scsi3addr[])
@@ -4151,7 +4242,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
 
 	if (unlikely(lockup_detected(h))) {
-		cmd->result = DID_ERROR << 16;
+		cmd->result = DID_NO_CONNECT << 16;
 		cmd->scsi_done(cmd);
 		return 0;
 	}
@@ -4161,7 +4252,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	if (unlikely(lockup_detected(h))) {
-		cmd->result = DID_ERROR << 16;
+		cmd->result = DID_NO_CONNECT << 16;
 		cmd_free(h, c);
 		cmd->scsi_done(cmd);
 		return 0;
@@ -4356,7 +4447,10 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 		/* Send the Test Unit Ready, fill_cmd can't fail, no mapping */
 		(void) fill_cmd(c, TEST_UNIT_READY, h,
 				NULL, 0, 0, lunaddr, TYPE_CMD);
-		hpsa_scsi_do_simple_cmd_core(h, c);
+		rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE,
+						NO_TIMEOUT);
+		if (rc)
+			goto do_it_again;
 		/* no unmap needed here because no data xfer. */
 
 		if (c->err_info->CommandStatus == CMD_SUCCESS)
@@ -4367,7 +4461,7 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 			(c->err_info->SenseInfo[2] == NO_SENSE ||
 			c->err_info->SenseInfo[2] == UNIT_ATTENTION))
 			break;
-
+do_it_again:
 		dev_warn(&h->pdev->dev, "waiting %d secs "
 			"for device to become ready.\n", waittime);
 		rc = 1; /* device not ready. */
@@ -4405,13 +4499,46 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 			"device lookup failed.\n");
 		return FAILED;
 	}
-	dev_warn(&h->pdev->dev, "resetting device %d:%d:%d:%d\n",
-		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
+
+	/* if controller locked up, we can guarantee command won't complete */
+	if (lockup_detected(h)) {
+		dev_warn(&h->pdev->dev,
+			"scsi %d:%d:%d:%d RESET FAILED, lockup detected\n",
+			h->scsi_host->host_no, dev->bus, dev->target,
+			dev->lun);
+		return FAILED;
+	}
+
+	/* this reset request might be the result of a lockup; check */
+	if (detect_controller_lockup(h)) {
+		dev_warn(&h->pdev->dev,
+			 "scsi %d:%d:%d:%d RESET FAILED, new lockup detected\n",
+			 h->scsi_host->host_no, dev->bus, dev->target,
+			 dev->lun);
+		return FAILED;
+	}
+
+	dev_warn(&h->pdev->dev,
+		"scsi %d:%d:%d:%d: %s %.8s %.16s resetting RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
+		h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
+		scsi_device_type(dev->devtype),
+		dev->vendor,
+		dev->model,
+		dev->raid_level > RAID_UNKNOWN ?
+			"RAID-?" : raid_label[dev->raid_level],
+		dev->offload_config ? '+' : '-',
+		dev->offload_enabled ? '+' : '-',
+		dev->expose_state);
+
 	/* send a reset to the SCSI LUN which the command was sent to */
-	rc = hpsa_send_reset(h, dev->scsi3addr, HPSA_RESET_TYPE_LUN);
+	rc = hpsa_send_reset(h, dev->scsi3addr, HPSA_RESET_TYPE_LUN,
+			     DEFAULT_REPLY_QUEUE);
 	if (rc == 0 && wait_for_device_to_become_ready(h, dev->scsi3addr) == 0)
 		return SUCCESS;
 
+	dev_warn(&h->pdev->dev,
+		"scsi %d:%d:%d:%d reset failed\n",
+		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
 	return FAILED;
 }
 
@@ -4456,7 +4583,7 @@ static void hpsa_get_tag(struct ctlr_info *h,
 }
 
 static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
-	struct CommandList *abort, int swizzle)
+	struct CommandList *abort, int swizzle, int reply_queue)
 {
 	int rc = IO_OK;
 	struct CommandList *c;
@@ -4474,9 +4601,9 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 		0, 0, scsi3addr, TYPE_MSG);
 	if (swizzle)
 		swizzle_abort_tag(&c->Request.CDB[4]);
-	hpsa_scsi_do_simple_cmd_core(h, c);
+	(void) hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
 	hpsa_get_tag(h, abort, &taglower, &tagupper);
-	dev_dbg(&h->pdev->dev, "%s: Tag:0x%08x:%08x: do_simple_cmd_core completed.\n",
+	dev_dbg(&h->pdev->dev, "%s: Tag:0x%08x:%08x: do_simple_cmd(abort) completed.\n",
 		__func__, tagupper, taglower);
 	/* no unmap needed here because no data xfer. */
 
@@ -4508,7 +4635,7 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
  */
 
 static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
-	unsigned char *scsi3addr, struct CommandList *abort)
+	unsigned char *scsi3addr, struct CommandList *abort, int reply_queue)
 {
 	int rc = IO_OK;
 	struct scsi_cmnd *scmd; /* scsi command within request being aborted */
@@ -4551,7 +4678,7 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 			"Reset as abort: Resetting physical device at scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
 			psa[0], psa[1], psa[2], psa[3],
 			psa[4], psa[5], psa[6], psa[7]);
-	rc = hpsa_send_reset(h, psa, HPSA_RESET_TYPE_TARGET);
+	rc = hpsa_send_reset(h, psa, HPSA_RESET_TYPE_TARGET, reply_queue);
 	if (rc != 0) {
 		dev_warn(&h->pdev->dev,
 			"Reset as abort: Failed on physical device at scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
@@ -4585,7 +4712,7 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
  * make this true someday become false.
  */
 static int hpsa_send_abort_both_ways(struct ctlr_info *h,
-	unsigned char *scsi3addr, struct CommandList *abort)
+	unsigned char *scsi3addr, struct CommandList *abort, int reply_queue)
 {
 	/* ioccelerator mode 2 commands should be aborted via the
 	 * accelerated path, since RAID path is unaware of these commands,
@@ -4593,10 +4720,20 @@ static int hpsa_send_abort_both_ways(struct ctlr_info *h,
 	 * Change abort to physical device reset.
 	 */
 	if (abort->cmd_type == CMD_IOACCEL2)
-		return hpsa_send_reset_as_abort_ioaccel2(h, scsi3addr, abort);
+		return hpsa_send_reset_as_abort_ioaccel2(h, scsi3addr,
+							abort, reply_queue);
+
+	return hpsa_send_abort(h, scsi3addr, abort, 0, reply_queue) &&
+			hpsa_send_abort(h, scsi3addr, abort, 1, reply_queue);
+}
 
-	return hpsa_send_abort(h, scsi3addr, abort, 0) &&
-			hpsa_send_abort(h, scsi3addr, abort, 1);
+/* Find out which reply queue a command was meant to return on */
+static int hpsa_extract_reply_queue(struct ctlr_info *h,
+					struct CommandList *c)
+{
+	if (c->cmd_type == CMD_IOACCEL2)
+		return h->ioaccel2_cmd_pool[c->cmdindex].reply_queue;
+	return c->Header.ReplyQueue;
 }
 
 /* Send an abort for the specified command.
@@ -4614,7 +4751,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	char msg[256];		/* For debug messaging. */
 	int ml = 0;
 	__le32 tagupper, taglower;
-	int refcount;
+	int refcount, reply_queue;
 
 	/* Find the controller of the command to be aborted */
 	h = sdev_to_hba(sc->device);
@@ -4622,8 +4759,23 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 			"ABORT REQUEST FAILED, Controller lookup failed.\n"))
 		return FAILED;
 
-	if (lockup_detected(h))
+	/* If controller locked up, we can guarantee command won't complete */
+	if (lockup_detected(h)) {
+		dev_warn(&h->pdev->dev,
+			"scsi %d:%d:%d:%llu scmd %p ABORT FAILED, lockup detected\n",
+			h->scsi_host->host_no, sc->device->channel,
+			sc->device->id, sc->device->lun, sc);
 		return FAILED;
+	}
+
+	/* This is a good time to check if controller lockup has occurred */
+	if (detect_controller_lockup(h)) {
+		dev_warn(&h->pdev->dev,
+			 "scsi %d:%d:%d:%llu scmd %p ABORT FAILED, new lockup detected\n",
+			 h->scsi_host->host_no, sc->device->channel,
+			 sc->device->id, sc->device->lun, sc);
+		return FAILED;
+	}
 
 	/* Check that controller supports some kind of task abort */
 	if (!(HPSATMF_PHYS_TASK_ABORT & h->TMFSupportFlags) &&
@@ -4656,6 +4808,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 	hpsa_get_tag(h, abort, &taglower, &tagupper);
+	reply_queue = hpsa_extract_reply_queue(h, abort);
 	ml += sprintf(msg+ml, "Tag:0x%08x:%08x ", tagupper, taglower);
 	as  = abort->scsi_cmd;
 	if (as != NULL)
@@ -4670,7 +4823,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	 * by the firmware (but not to the scsi mid layer) but we can't
 	 * distinguish which.  Send the abort down.
 	 */
-	rc = hpsa_send_abort_both_ways(h, dev->scsi3addr, abort);
+	rc = hpsa_send_abort_both_ways(h, dev->scsi3addr, abort, reply_queue);
 	if (rc != 0) {
 		dev_warn(&h->pdev->dev, "scsi %d:%d:%d:%d %s\n",
 			h->scsi_host->host_no,
@@ -4995,7 +5148,9 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		c->SG[0].Len = cpu_to_le32(iocommand.buf_size);
 		c->SG[0].Ext = cpu_to_le32(HPSA_SG_LAST); /* not chaining */
 	}
-	hpsa_scsi_do_simple_cmd_core_if_no_lockup(h, c);
+	rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE, NO_TIMEOUT);
+	if (rc)
+		rc = -EIO;
 	if (iocommand.buf_size > 0)
 		hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_BIDIRECTIONAL);
 	check_ioctl_unit_attention(h, c);
@@ -5125,7 +5280,11 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 		}
 		c->SG[--i].Ext = cpu_to_le32(HPSA_SG_LAST);
 	}
-	hpsa_scsi_do_simple_cmd_core_if_no_lockup(h, c);
+	status = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE, NO_TIMEOUT);
+	if (status) {
+		status = -EIO;
+		goto cleanup0;
+	}
 	if (sg_used)
 		hpsa_pci_unmap(h->pdev, c, sg_used, PCI_DMA_BIDIRECTIONAL);
 	check_ioctl_unit_attention(h, c);
@@ -6272,6 +6431,8 @@ static int hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 	 * as we enter this code.)
 	 */
 	for (i = 0; i < MAX_MODE_CHANGE_WAIT; i++) {
+		if (h->remove_in_progress)
+			goto done;
 		spin_lock_irqsave(&h->lock, flags);
 		doorbell_value = readl(h->vaddr + SA5_DOORBELL);
 		spin_unlock_irqrestore(&h->lock, flags);
@@ -6667,17 +6828,21 @@ static void fail_all_outstanding_cmds(struct ctlr_info *h)
 {
 	int i, refcount;
 	struct CommandList *c;
+	int failcount = 0;
 
 	flush_workqueue(h->resubmit_wq); /* ensure all cmds are fully built */
 	for (i = 0; i < h->nr_cmds; i++) {
 		c = h->cmd_pool + i;
 		refcount = atomic_inc_return(&c->refcount);
 		if (refcount > 1) {
-			c->err_info->CommandStatus = CMD_HARDWARE_ERR;
+			c->err_info->CommandStatus = CMD_CTLR_LOCKUP;
 			finish_cmd(c);
+			failcount++;
 		}
 		cmd_free(h, c);
 	}
+	dev_warn(&h->pdev->dev,
+		"failed %d commands in fail_all\n", failcount);
 }
 
 static void set_lockup_detected_for_all_cpus(struct ctlr_info *h, u32 value)
@@ -6705,18 +6870,19 @@ static void controller_lockup_detected(struct ctlr_info *h)
 	if (!lockup_detected) {
 		/* no heartbeat, but controller gave us a zero. */
 		dev_warn(&h->pdev->dev,
-			"lockup detected but scratchpad register is zero\n");
+			"lockup detected after %d but scratchpad register is zero\n",
+			h->heartbeat_sample_interval / HZ);
 		lockup_detected = 0xffffffff;
 	}
 	set_lockup_detected_for_all_cpus(h, lockup_detected);
 	spin_unlock_irqrestore(&h->lock, flags);
-	dev_warn(&h->pdev->dev, "Controller lockup detected: 0x%08x\n",
-			lockup_detected);
+	dev_warn(&h->pdev->dev, "Controller lockup detected: 0x%08x after %d\n",
+			lockup_detected, h->heartbeat_sample_interval / HZ);
 	pci_disable_device(h->pdev);
 	fail_all_outstanding_cmds(h);
 }
 
-static void detect_controller_lockup(struct ctlr_info *h)
+static int detect_controller_lockup(struct ctlr_info *h)
 {
 	u64 now;
 	u32 heartbeat;
@@ -6726,7 +6892,7 @@ static void detect_controller_lockup(struct ctlr_info *h)
 	/* If we've received an interrupt recently, we're ok. */
 	if (time_after64(h->last_intr_timestamp +
 				(h->heartbeat_sample_interval), now))
-		return;
+		return false;
 
 	/*
 	 * If we've already checked the heartbeat recently, we're ok.
@@ -6735,7 +6901,7 @@ static void detect_controller_lockup(struct ctlr_info *h)
 	 */
 	if (time_after64(h->last_heartbeat_timestamp +
 				(h->heartbeat_sample_interval), now))
-		return;
+		return false;
 
 	/* If heartbeat has not changed since we last looked, we're not ok. */
 	spin_lock_irqsave(&h->lock, flags);
@@ -6743,12 +6909,13 @@ static void detect_controller_lockup(struct ctlr_info *h)
 	spin_unlock_irqrestore(&h->lock, flags);
 	if (h->last_heartbeat == heartbeat) {
 		controller_lockup_detected(h);
-		return;
+		return true;
 	}
 
 	/* We're ok. */
 	h->last_heartbeat = heartbeat;
 	h->last_heartbeat_timestamp = now;
+	return false;
 }
 
 static void hpsa_ack_ctlr_events(struct ctlr_info *h)
@@ -7092,8 +7259,10 @@ static void hpsa_flush_cache(struct ctlr_info *h)
 {
 	char *flush_buf;
 	struct CommandList *c;
+	int rc;
 
 	/* Don't bother trying to flush the cache if locked up */
+	/* FIXME not necessary if do_simple_cmd does the check */
 	if (unlikely(lockup_detected(h)))
 		return;
 	flush_buf = kzalloc(4, GFP_KERNEL);
@@ -7109,7 +7278,10 @@ static void hpsa_flush_cache(struct ctlr_info *h)
 		RAID_CTLR_LUNID, TYPE_CMD)) {
 		goto out;
 	}
-	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_TODEVICE);
+	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
+					PCI_DMA_TODEVICE, NO_TIMEOUT);
+	if (rc)
+		goto out;
 	if (c->err_info->CommandStatus != 0)
 out:
 		dev_warn(&h->pdev->dev,
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 76d5499..f52c847 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -43,6 +43,11 @@
 #define CMD_TIMEOUT             0x000B
 #define CMD_UNABORTABLE		0x000C
 #define CMD_IOACCEL_DISABLED	0x000E
+#define CMD_CTLR_LOCKUP		0xffff
+/* Note: CMD_CTLR_LOCKUP is not a value defined by the CISS spec
+ * it is a value defined by the driver that commands can be marked
+ * with when a controller lockup has been detected by the driver
+ */
 
 
 /* Unit Attentions ASC's as defined for the MSA2012sa */

