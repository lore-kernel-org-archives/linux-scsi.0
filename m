From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/35] hpsa: poll controller to detect device change event
Date: Tue, 18 Feb 2014 13:55:43 -0600
Message-ID: <20140218195543.15787.89381.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43514 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaBRT5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:57:16 -0500
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 792DB60962
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:57:16 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

For shared SAS configurations, hosts need to poll Smart Arrays
periodically in order to be able to detect configuration changes
such as logical drives being added or removed from remote hosts.
A register on the controller indicates when such events have
occurred, and the driver polls the register via a workqueue
and kicks off a rescan of devices if such an event is detected.
Additionally, changes to logical drive raid offload eligibility
are autodetected in this way.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Scott Teel <scott.teel@hp.com>
---
 drivers/scsi/hpsa.c     |  108 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/hpsa.h     |    1 
 drivers/scsi/hpsa_cmd.h |    3 +
 3 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 92662e6..b34a355 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -220,6 +220,8 @@ static inline void finish_cmd(struct CommandList *c);
 static void hpsa_wait_for_mode_change_ack(struct ctlr_info *h);
 #define BOARD_NOT_READY 0
 #define BOARD_READY 1
+static void hpsa_drain_commands(struct ctlr_info *h);
+static void hpsa_flush_cache(struct ctlr_info *h);
 
 static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
 {
@@ -5022,6 +5024,23 @@ static inline void hpsa_p600_dma_prefetch_quirk(struct ctlr_info *h)
 	writel(dma_prefetch, h->vaddr + I2O_DMA1_CFG);
 }
 
+static void hpsa_wait_for_clear_event_notify_ack(struct ctlr_info *h)
+{
+	int i;
+	u32 doorbell_value;
+	unsigned long flags;
+	/* wait until the clear_event_notify bit 6 is cleared by controller. */
+	for (i = 0; i < MAX_CONFIG_WAIT; i++) {
+		spin_lock_irqsave(&h->lock, flags);
+		doorbell_value = readl(h->vaddr + SA5_DOORBELL);
+		spin_unlock_irqrestore(&h->lock, flags);
+		if (!(doorbell_value & DOORBELL_CLEAR_EVENTS))
+			break;
+		/* delay and try again */
+		msleep(20);
+	}
+}
+
 static void hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 {
 	int i;
@@ -5398,6 +5417,79 @@ static void detect_controller_lockup(struct ctlr_info *h)
 	h->last_heartbeat_timestamp = now;
 }
 
+static int hpsa_kickoff_rescan(struct ctlr_info *h)
+{
+	int i;
+	char *event_type;
+
+	/* Ask the controller to clear the events we're handling. */
+	if (h->transMethod & (CFGTBL_Trans_io_accel1) &&
+		(h->events & HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_STATE_CHANGE ||
+		 h->events & HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_CONFIG_CHANGE)) {
+
+		if (h->events & HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_STATE_CHANGE)
+			event_type = "state change";
+		if (h->events & HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_CONFIG_CHANGE)
+			event_type = "configuration change";
+		/* Stop sending new RAID offload reqs via the IO accelerator */
+		scsi_block_requests(h->scsi_host);
+		for (i = 0; i < h->ndevices; i++)
+			h->dev[i]->offload_enabled = 0;
+		hpsa_drain_commands(h);
+		/* Set 'accelerator path config change' bit */
+		dev_warn(&h->pdev->dev,
+			"Acknowledging event: 0x%08x (HP SSD Smart Path %s)\n",
+			h->events, event_type);
+		writel(h->events, &(h->cfgtable->clear_event_notify));
+		/* Set the "clear event notify field update" bit 6 */
+		writel(DOORBELL_CLEAR_EVENTS, h->vaddr + SA5_DOORBELL);
+		/* Wait until ctlr clears 'clear event notify field', bit 6 */
+		hpsa_wait_for_clear_event_notify_ack(h);
+		scsi_unblock_requests(h->scsi_host);
+	} else {
+		/* Acknowledge controller notification events. */
+		writel(h->events, &(h->cfgtable->clear_event_notify));
+		writel(DOORBELL_CLEAR_EVENTS, h->vaddr + SA5_DOORBELL);
+		hpsa_wait_for_clear_event_notify_ack(h);
+#if 0
+		writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
+		hpsa_wait_for_mode_change_ack(h);
+#endif
+	}
+
+	/* Something in the device list may have changed to trigger
+	 * the event, so do a rescan.
+	 */
+	hpsa_scan_start(h->scsi_host);
+	/* release reference taken on scsi host in check_controller_events */
+	scsi_host_put(h->scsi_host);
+	return 0;
+}
+
+/* Check a register on the controller to see if there are configuration
+ * changes (added/changed/removed logical drives, etc.) which mean that
+ * we should rescan the controller for devices.  If so, add the controller
+ * to the list of controllers needing to be rescanned, and gets a
+ * reference to the associated scsi_host.
+ */
+static void hpsa_ctlr_needs_rescan(struct ctlr_info *h)
+{
+	if (!(h->fw_support & MISC_FW_EVENT_NOTIFY))
+		return;
+
+	h->events = readl(&(h->cfgtable->event_notify));
+	if (!h->events)
+		return;
+
+	/*
+	 * Take a reference on scsi host for the duration of the scan
+	 * Release in hpsa_kickoff_rescan().  No lock needed for scan_list
+	 * as only a single thread accesses this list.
+	 */
+	scsi_host_get(h->scsi_host);
+	hpsa_kickoff_rescan(h);
+}
+
 static void hpsa_monitor_ctlr_worker(struct work_struct *work)
 {
 	unsigned long flags;
@@ -5406,6 +5498,7 @@ static void hpsa_monitor_ctlr_worker(struct work_struct *work)
 	detect_controller_lockup(h);
 	if (h->lockup_detected)
 		return;
+	hpsa_ctlr_needs_rescan(h);
 	spin_lock_irqsave(&h->lock, flags);
 	if (h->remove_in_progress) {
 		spin_unlock_irqrestore(&h->lock, flags);
@@ -5947,6 +6040,21 @@ clean_up:
 	kfree(h->blockFetchTable);
 }
 
+static void hpsa_drain_commands(struct ctlr_info *h)
+{
+	int cmds_out;
+	unsigned long flags;
+
+	do { /* wait for all outstanding commands to drain out */
+		spin_lock_irqsave(&h->lock, flags);
+		cmds_out = h->commands_outstanding;
+		spin_unlock_irqrestore(&h->lock, flags);
+		if (cmds_out <= 0)
+			break;
+		msleep(100);
+	} while (1);
+}
+
 /*
  *  This is it.  Register the PCI driver information for the cards we control
  *  the OS will call our registered routines when it finds one of our cards.
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index ae08f1c..df2f88d 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -176,6 +176,7 @@ struct ctlr_info {
 #define HPSATMF_LOG_QRY_TASK    (1 << 23)
 #define HPSATMF_LOG_QRY_TSET    (1 << 24)
 #define HPSATMF_LOG_QRY_ASYNC   (1 << 25)
+	u32 events;
 };
 #define HPSA_ABORT_MSG 0
 #define HPSA_DEVICE_RESET_MSG 1
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index c1ae8d2..21f8a61 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -128,6 +128,7 @@
 #define CFGTBL_AccCmds          0x00000001l
 #define DOORBELL_CTLR_RESET	0x00000004l
 #define DOORBELL_CTLR_RESET2	0x00000020l
+#define DOORBELL_CLEAR_EVENTS	0x00000040l
 
 #define CFGTBL_Trans_Simple     0x00000002l
 #define CFGTBL_Trans_Performant 0x00000004l
@@ -495,6 +496,8 @@ struct CfgTable {
 	u32		io_accel_max_embedded_sg_count;
 	u32		io_accel_request_size_offset;
 	u32		event_notify;
+#define HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_STATE_CHANGE (1 << 30)
+#define HPSA_EVENT_NOTIFY_ACCEL_IO_PATH_CONFIG_CHANGE (1 << 31)
 	u32		clear_event_notify;
 };
 

