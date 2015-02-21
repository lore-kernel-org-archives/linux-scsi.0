From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 42/43] hpsa: cleanup reset
Date: Sat, 21 Feb 2015 16:21:16 -0600
Message-ID: <20150221222116.21954.97964.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:49650 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbbBUWWe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:22:34 -0500
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

Synchronize completion the reset with completion of outstanding commands

Extending the newly-added synchronous abort functionality,
now also synchronize resets with the completion of outstanding commands.
Rename the wait queue to reflect the fact that it's being used for both
types of waits.  Also, don't complete commands which are terminated
due to a reset operation.

fix for controller lockup during reset

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |  199 +++++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/hpsa.h     |    5 +
 drivers/scsi/hpsa_cmd.h |    1 
 3 files changed, 177 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ea66c1d..3531ed8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -281,6 +281,11 @@ static inline bool hpsa_is_cmd_idle(struct CommandList *c)
 	return c->scsi_cmd == SCSI_CMD_IDLE;
 }
 
+static inline bool hpsa_is_pending_event(struct CommandList *c)
+{
+	return c->abort_pending || c->reset_pending;
+}
+
 /* extract sense key, asc, and ascq from sense data.  -1 means invalid. */
 static void decode_sense_data(const u8 *sense_data, int sense_data_len,
 			int *sense_key, int *asc, int *ascq)
@@ -983,7 +988,7 @@ static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
 
 static void enqueue_cmd_and_start_io(struct ctlr_info *h, struct CommandList *c)
 {
-	if (unlikely(c->abort_pending))
+	if (unlikely(hpsa_is_pending_event(c)))
 		return finish_cmd(c);
 
 	__enqueue_cmd_and_start_io(h, c, DEFAULT_REPLY_QUEUE);
@@ -1476,6 +1481,8 @@ static void hpsa_figure_phys_disk_ptrs(struct ctlr_info *h,
 	if (nraid_map_entries > RAID_MAP_MAX_ENTRIES)
 		nraid_map_entries = RAID_MAP_MAX_ENTRIES;
 
+	logical_drive->nphysical_disks = nraid_map_entries;
+
 	qdepth = 0;
 	for (i = 0; i < nraid_map_entries; i++) {
 		logical_drive->phys_disk[i] = NULL;
@@ -2046,6 +2053,8 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 static void hpsa_cmd_resolve_events(struct ctlr_info *h,
 		struct CommandList *c)
 {
+	bool do_wake = false;
+
 	/*
 	 * Prevent the following race in the abort handler:
 	 *
@@ -2057,16 +2066,35 @@ static void hpsa_cmd_resolve_events(struct ctlr_info *h,
 	 *    finds struct CommandList and tries to aborts it
 	 * Now we have aborted the wrong command.
 	 *
-	 * Clear c->scsi_cmd here so that the abort handler will know this
-	 * command has completed.  Then, check to see if the abort handler is
+	 * Reset c->scsi_cmd here so that the abort or reset handler will know
+	 * this command has completed.  Then, check to see if the handler is
 	 * waiting for this command, and, if so, wake it.
 	 */
 	c->scsi_cmd = SCSI_CMD_IDLE;
-	mb(); /* Ensure c->scsi_cmd is set to SCSI_CMD_IDLE */
+	mb();	/* Declare command idle before checking for pending events. */
 	if (c->abort_pending) {
+		do_wake = true;
 		c->abort_pending = false;
-		wake_up_all(&h->abort_sync_wait_queue);
 	}
+	if (c->reset_pending) {
+		unsigned long flags;
+		struct hpsa_scsi_dev_t *dev;
+
+		/*
+		 * There appears to be a reset pending; lock the lock and
+		 * reconfirm.  If so, then decrement the count of outstanding
+		 * commands and wake the reset command if this is the last one.
+		 */
+		spin_lock_irqsave(&h->lock, flags);
+		dev = c->reset_pending;		/* Re-fetch under the lock. */
+		if (dev && atomic_dec_and_test(&dev->reset_cmds_out))
+			do_wake = true;
+		c->reset_pending = NULL;
+		spin_unlock_irqrestore(&h->lock, flags);
+	}
+
+	if (do_wake)
+		wake_up_all(&h->event_sync_wait_queue);
 }
 
 static void hpsa_cmd_resolve_and_free(struct ctlr_info *h,
@@ -2114,10 +2142,6 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 			c2->error_data.status == 0))
 		return hpsa_cmd_free_and_done(h, c, cmd);
 
-	/* don't requeue a command which is being aborted */
-	if (unlikely(c->abort_pending))
-		return hpsa_cmd_abort_and_free(h, c, cmd);
-
 	/*
 	 * Any RAID offload error results in retry which will use
 	 * the normal I/O path so the controller can handle whatever's
@@ -2212,6 +2236,13 @@ static void complete_scsi_command(struct CommandList *cp)
 		return hpsa_cmd_free_and_done(h, cp, cmd);
 	}
 
+	if ((unlikely(hpsa_is_pending_event(cp)))) {
+		if (cp->reset_pending)
+			return hpsa_cmd_resolve_and_free(h, cp);
+		if (cp->abort_pending)
+			return hpsa_cmd_abort_and_free(h, cp, cmd);
+	}
+
 	if (cp->cmd_type == CMD_IOACCEL2)
 		return process_ioaccel2_completion(h, cp, cmd, dev);
 
@@ -2239,14 +2270,10 @@ static void complete_scsi_command(struct CommandList *cp)
 		if (is_logical_dev_addr_mode(dev->scsi3addr)) {
 			if (ei->CommandStatus == CMD_IOACCEL_DISABLED)
 				dev->offload_enabled = 0;
-			if (!cp->abort_pending)
-				return hpsa_retry_cmd(h, cp);
+			return hpsa_retry_cmd(h, cp);
 		}
 	}
 
-	if (cp->abort_pending)
-		ei->CommandStatus = CMD_ABORTED;
-
 	/* an error has occurred */
 	switch (ei->CommandStatus) {
 
@@ -2666,6 +2693,123 @@ out:
 	return rc;
 }
 
+static bool hpsa_cmd_dev_match(struct ctlr_info *h, struct CommandList *c,
+			       struct hpsa_scsi_dev_t *dev,
+			       unsigned char *scsi3addr)
+{
+	int i;
+	bool match = false;
+	struct io_accel2_cmd *c2 = &h->ioaccel2_cmd_pool[c->cmdindex];
+	struct hpsa_tmf_struct *ac = (struct hpsa_tmf_struct *) c2;
+
+	if (hpsa_is_cmd_idle(c))
+		return false;
+
+	switch (c->cmd_type) {
+	case CMD_SCSI:
+	case CMD_IOCTL_PEND:
+		match = !memcmp(scsi3addr, &c->Header.LUN.LunAddrBytes,
+				sizeof(c->Header.LUN.LunAddrBytes));
+		break;
+
+	case CMD_IOACCEL1:
+	case CMD_IOACCEL2:
+		if (c->phys_disk == dev) {
+			/* HBA mode match */
+			match = true;
+		} else {
+			/* Possible RAID mode -- check each phys dev. */
+			/* FIXME:  Do we need to take out a lock here?  If
+			 * so, we could just call hpsa_get_pdisk_of_ioaccel2()
+			 * instead. */
+			for (i = 0; i < dev->nphysical_disks && !match; i++) {
+				/* FIXME: an alternate test might be
+				 *
+				 * match = dev->phys_disk[i]->ioaccel_handle
+				 *              == c2->scsi_nexus;      */
+				match = dev->phys_disk[i] == c->phys_disk;
+			}
+		}
+		break;
+
+	case IOACCEL2_TMF:
+		for (i = 0; i < dev->nphysical_disks && !match; i++) {
+			match = dev->phys_disk[i]->ioaccel_handle ==
+					le32_to_cpu(ac->it_nexus);
+		}
+		break;
+
+	case 0:		/* The command is in the middle of being initialized. */
+		match = false;
+		break;
+
+	default:
+		dev_err(&h->pdev->dev, "unexpected cmd_type: %d\n",
+			c->cmd_type);
+		BUG();
+	}
+
+	return match;
+}
+
+static int hpsa_do_reset(struct ctlr_info *h, struct hpsa_scsi_dev_t *dev,
+	unsigned char *scsi3addr, u8 reset_type, int reply_queue)
+{
+	int i;
+	int rc = 0;
+
+	/* We can really only handle one reset at a time */
+	if (mutex_lock_interruptible(&h->reset_mutex) == -EINTR) {
+		dev_warn(&h->pdev->dev, "concurrent reset wait interrupted.\n");
+		return -EINTR;
+	}
+
+	BUG_ON(atomic_read(&dev->reset_cmds_out) != 0);
+
+	for (i = 0; i < h->nr_cmds; i++) {
+		struct CommandList *c = h->cmd_pool + i;
+		int refcount = atomic_inc_return(&c->refcount);
+
+		if (refcount > 1 && hpsa_cmd_dev_match(h, c, dev, scsi3addr)) {
+			unsigned long flags;
+
+			/*
+			 * Mark the target command as having a reset pending,
+			 * then lock a lock so that the command cannot complete
+			 * while we're considering it.  If the command is not
+			 * idle then count it; otherwise revoke the event.
+			 */
+			c->reset_pending = dev;
+			spin_lock_irqsave(&h->lock, flags);	/* Implied MB */
+			if (!hpsa_is_cmd_idle(c))
+				atomic_inc(&dev->reset_cmds_out);
+			else
+				c->reset_pending = NULL;
+			spin_unlock_irqrestore(&h->lock, flags);
+		}
+
+		cmd_free(h, c);
+	}
+
+	rc = hpsa_send_reset(h, scsi3addr, reset_type, reply_queue);
+	if (!rc)
+		wait_event(h->event_sync_wait_queue,
+			atomic_read(&dev->reset_cmds_out) == 0 ||
+			lockup_detected(h));
+
+	if (unlikely(lockup_detected(h))) {
+			dev_warn(&h->pdev->dev,
+				 "Controller lockup detected during reset wait\n");
+			rc = -ENODEV;
+		}
+
+	if (unlikely(rc))
+		atomic_set(&dev->reset_cmds_out, 0);
+
+	mutex_unlock(&h->reset_mutex);
+	return rc;
+}
+
 static void hpsa_get_raid_level(struct ctlr_info *h,
 	unsigned char *scsi3addr, unsigned char *raid_level)
 {
@@ -3515,6 +3659,7 @@ static void hpsa_get_ioaccel_drive_info(struct ctlr_info *h,
 	else
 		dev->queue_depth = DRIVE_QUEUE_DEPTH; /* conservative */
 	atomic_set(&dev->ioaccel_cmds_out, 0);
+	atomic_set(&dev->reset_cmds_out, 0);
 }
 
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
@@ -4654,6 +4799,8 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 		cmd->result = DID_NO_CONNECT << 16;
 		return hpsa_cmd_free_and_done(c->h, c, cmd);
 	}
+	if (c->reset_pending)
+		return hpsa_cmd_resolve_and_free(c->h, c);
 	if (c->abort_pending)
 		return hpsa_cmd_abort_and_free(c->h, c, cmd);
 	if (c->cmd_type == CMD_IOACCEL2) {
@@ -5024,8 +5171,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 
 	dev = scsicmd->device->hostdata;
 	if (!dev) {
-		dev_err(&h->pdev->dev, "hpsa_eh_device_reset_handler: "
-			"device lookup failed.\n");
+		dev_err(&h->pdev->dev, "%s: device lookup failed\n", __func__);
 		return FAILED;
 	}
 
@@ -5060,15 +5206,13 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 		dev->expose_state);
 
 	/* send a reset to the SCSI LUN which the command was sent to */
-	rc = hpsa_send_reset(h, dev->scsi3addr, HPSA_RESET_TYPE_LUN,
-			     DEFAULT_REPLY_QUEUE);
-	if (rc == 0)
-		return SUCCESS;
-
+	rc = hpsa_do_reset(h, dev, dev->scsi3addr, HPSA_RESET_TYPE_LUN,
+			   DEFAULT_REPLY_QUEUE);
 	dev_warn(&h->pdev->dev,
-		"resetting scsi %d:%d:%d:%d failed\n",
-		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
-	return FAILED;
+		 "resetting scsi %d:%d:%d:%d %s\n",
+		 h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
+		 rc == 0 ? "completed successfully" : "failed");
+	return rc == 0 ? SUCCESS : FAILED;
 }
 
 static void swizzle_abort_tag(u8 *tag)
@@ -5247,7 +5391,7 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 			"Reset as abort: Resetting physical device at scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
 			psa[0], psa[1], psa[2], psa[3],
 			psa[4], psa[5], psa[6], psa[7]);
-	rc = hpsa_send_reset(h, psa, HPSA_RESET_TYPE_TARGET, reply_queue);
+	rc = hpsa_do_reset(h, dev, psa, HPSA_RESET_TYPE_TARGET, reply_queue);
 	if (rc != 0) {
 		dev_warn(&h->pdev->dev,
 			"Reset as abort: Failed on physical device at scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
@@ -5486,7 +5630,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 		return FAILED;
 	}
 	dev_info(&h->pdev->dev, "%s SENT, SUCCESS\n", msg);
-	wait_event(h->abort_sync_wait_queue,
+	wait_event(h->event_sync_wait_queue,
 		   abort->scsi_cmd != sc || lockup_detected(h));
 	cmd_free(h, abort);
 	return !lockup_detected(h) ? SUCCESS : FAILED;
@@ -7935,7 +8079,8 @@ reinit_after_soft_reset:
 		return hpsa_init_cleanup(h, rc);
 	init_waitqueue_head(&h->scan_wait_queue);
 	init_waitqueue_head(&h->abort_cmd_wait_queue);
-	init_waitqueue_head(&h->abort_sync_wait_queue);
+	init_waitqueue_head(&h->event_sync_wait_queue);
+	mutex_init(&h->reset_mutex);
 	h->scan_finished = 1; /* no scan currently in progress */
 
 	pci_set_drvdata(pdev, h);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index b1ae888..a9e33b3 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -47,6 +47,7 @@ struct hpsa_scsi_dev_t {
 	unsigned char raid_level;	/* from inquiry page 0xC1 */
 	unsigned char volume_offline;	/* discovered via TUR or VPD */
 	u16 queue_depth;		/* max queue_depth for this device */
+	atomic_t reset_cmds_out;	/* Count of commands to-be affected */
 	atomic_t ioaccel_cmds_out;	/* Only used for physical devices
 					 * counts commands sent to physical
 					 * device via "ioaccel" path.
@@ -70,6 +71,7 @@ struct hpsa_scsi_dev_t {
 	 * devices in order to honor physical device queue depth limits.
 	 */
 	struct hpsa_scsi_dev_t *phys_disk[RAID_MAP_MAX_ENTRIES];
+	int nphysical_disks;
 	int supports_aborts;
 #define HPSA_DO_NOT_EXPOSE	0x0
 #define HPSA_SG_ATTACH		0x1
@@ -267,7 +269,8 @@ struct ctlr_info {
 	struct workqueue_struct *rescan_ctlr_wq;
 	atomic_t abort_cmds_available;
 	wait_queue_head_t abort_cmd_wait_queue;
-	wait_queue_head_t abort_sync_wait_queue;
+	wait_queue_head_t event_sync_wait_queue;
+	struct mutex reset_mutex;
 };
 
 struct offline_device_entry {
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index f986402..c601622 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -441,6 +441,7 @@ struct CommandList {
 	struct hpsa_scsi_dev_t *phys_disk;
 
 	int abort_pending;
+	struct hpsa_scsi_dev_t *reset_pending;
 	atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
 } __aligned(COMMANDLIST_ALIGNMENT);
 

