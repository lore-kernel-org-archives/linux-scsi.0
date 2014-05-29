From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 11/24] hpsa: use per-cpu variable for lockup_detected
Date: Thu, 29 May 2014 10:53:18 -0500
Message-ID: <20140529155318.8180.49035.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:19849 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809AbaE2Pyq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:54:46 -0400
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id C55A15CC
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:35:28 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Avoid excessive locking by using per-cpu variable for lockup_detected

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Scott Teel <scott.teel@hp.com>
---
 drivers/scsi/hpsa.c |   80 ++++++++++++++++++++++++++++++++++-----------------
 drivers/scsi/hpsa.h |    2 +
 2 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e8090e2..acb88e5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -48,6 +48,7 @@
 #include <linux/bitmap.h>
 #include <linux/atomic.h>
 #include <linux/jiffies.h>
+#include <linux/percpu.h>
 #include <asm/div64.h>
 #include "hpsa_cmd.h"
 #include "hpsa.h"
@@ -1991,20 +1992,26 @@ static inline void hpsa_scsi_do_simple_cmd_core(struct ctlr_info *h,
 	wait_for_completion(&wait);
 }
 
+static u32 lockup_detected(struct ctlr_info *h)
+{
+	int cpu;
+	u32 rc, *lockup_detected;
+
+	cpu = get_cpu();
+	lockup_detected = per_cpu_ptr(h->lockup_detected, cpu);
+	rc = *lockup_detected;
+	put_cpu();
+	return rc;
+}
+
 static void hpsa_scsi_do_simple_cmd_core_if_no_lockup(struct ctlr_info *h,
 	struct CommandList *c)
 {
-	unsigned long flags;
-
 	/* If controller lockup detected, fake a hardware error. */
-	spin_lock_irqsave(&h->lock, flags);
-	if (unlikely(h->lockup_detected)) {
-		spin_unlock_irqrestore(&h->lock, flags);
+	if (unlikely(lockup_detected(h)))
 		c->err_info->CommandStatus = CMD_HARDWARE_ERR;
-	} else {
-		spin_unlock_irqrestore(&h->lock, flags);
+	else
 		hpsa_scsi_do_simple_cmd_core(h, c);
-	}
 }
 
 #define MAX_DRIVER_CMD_RETRIES 25
@@ -3964,7 +3971,6 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 	struct hpsa_scsi_dev_t *dev;
 	unsigned char scsi3addr[8];
 	struct CommandList *c;
-	unsigned long flags;
 	int rc = 0;
 
 	/* Get the ptr to our adapter structure out of cmd->host. */
@@ -3977,14 +3983,11 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 	}
 	memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
 
-	spin_lock_irqsave(&h->lock, flags);
-	if (unlikely(h->lockup_detected)) {
-		spin_unlock_irqrestore(&h->lock, flags);
+	if (unlikely(lockup_detected(h))) {
 		cmd->result = DID_ERROR << 16;
 		done(cmd);
 		return 0;
 	}
-	spin_unlock_irqrestore(&h->lock, flags);
 	c = cmd_alloc(h);
 	if (c == NULL) {			/* trouble... */
 		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
@@ -4096,16 +4099,13 @@ static int do_not_scan_if_controller_locked_up(struct ctlr_info *h)
 	 * we can prevent new rescan threads from piling up on a
 	 * locked up controller.
 	 */
-	spin_lock_irqsave(&h->lock, flags);
-	if (unlikely(h->lockup_detected)) {
-		spin_unlock_irqrestore(&h->lock, flags);
+	if (unlikely(lockup_detected(h))) {
 		spin_lock_irqsave(&h->scan_lock, flags);
 		h->scan_finished = 1;
 		wake_up_all(&h->scan_wait_queue);
 		spin_unlock_irqrestore(&h->scan_lock, flags);
 		return 1;
 	}
-	spin_unlock_irqrestore(&h->lock, flags);
 	return 0;
 }
 
@@ -6761,16 +6761,38 @@ static void fail_all_cmds_on_list(struct ctlr_info *h, struct list_head *list)
 	}
 }
 
+static void set_lockup_detected_for_all_cpus(struct ctlr_info *h, u32 value)
+{
+	int i, cpu;
+
+	cpu = cpumask_first(cpu_online_mask);
+	for (i = 0; i < num_online_cpus(); i++) {
+		u32 *lockup_detected;
+		lockup_detected = per_cpu_ptr(h->lockup_detected, cpu);
+		*lockup_detected = value;
+		cpu = cpumask_next(cpu, cpu_online_mask);
+	}
+	wmb(); /* be sure the per-cpu variables are out to memory */
+}
+
 static void controller_lockup_detected(struct ctlr_info *h)
 {
 	unsigned long flags;
+	u32 lockup_detected;
 
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
 	spin_lock_irqsave(&h->lock, flags);
-	h->lockup_detected = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
+	lockup_detected = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
+	if (!lockup_detected) {
+		/* no heartbeat, but controller gave us a zero. */
+		dev_warn(&h->pdev->dev,
+			"lockup detected but scratchpad register is zero\n");
+		lockup_detected = 0xffffffff;
+	}
+	set_lockup_detected_for_all_cpus(h, lockup_detected);
 	spin_unlock_irqrestore(&h->lock, flags);
 	dev_warn(&h->pdev->dev, "Controller lockup detected: 0x%08x\n",
-			h->lockup_detected);
+			lockup_detected);
 	pci_disable_device(h->pdev);
 	spin_lock_irqsave(&h->lock, flags);
 	fail_all_cmds_on_list(h, &h->cmpQ);
@@ -6905,7 +6927,7 @@ static void hpsa_monitor_ctlr_worker(struct work_struct *work)
 	struct ctlr_info *h = container_of(to_delayed_work(work),
 					struct ctlr_info, monitor_ctlr_work);
 	detect_controller_lockup(h);
-	if (h->lockup_detected)
+	if (lockup_detected(h))
 		return;
 
 	if (hpsa_ctlr_needs_rescan(h) || hpsa_offline_devices_ready(h)) {
@@ -6969,6 +6991,13 @@ reinit_after_soft_reset:
 	spin_lock_init(&h->offline_device_lock);
 	spin_lock_init(&h->scan_lock);
 	spin_lock_init(&h->passthru_count_lock);
+
+	/* Allocate and clear per-cpu variable lockup_detected */
+	h->lockup_detected = alloc_percpu(u32);
+	if (!h->lockup_detected)
+		goto clean1;
+	set_lockup_detected_for_all_cpus(h, 0);
+
 	rc = hpsa_pci_init(h);
 	if (rc != 0)
 		goto clean1;
@@ -7092,6 +7121,8 @@ clean4:
 	free_irqs(h);
 clean2:
 clean1:
+	if (h->lockup_detected)
+		free_percpu(h->lockup_detected);
 	kfree(h);
 	return rc;
 }
@@ -7100,16 +7131,10 @@ static void hpsa_flush_cache(struct ctlr_info *h)
 {
 	char *flush_buf;
 	struct CommandList *c;
-	unsigned long flags;
 
 	/* Don't bother trying to flush the cache if locked up */
-	spin_lock_irqsave(&h->lock, flags);
-	if (unlikely(h->lockup_detected)) {
-		spin_unlock_irqrestore(&h->lock, flags);
+	if (unlikely(lockup_detected(h)))
 		return;
-	}
-	spin_unlock_irqrestore(&h->lock, flags);
-
 	flush_buf = kzalloc(4, GFP_KERNEL);
 	if (!flush_buf)
 		return;
@@ -7193,6 +7218,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	kfree(h->hba_inquiry_data);
 	pci_disable_device(pdev);
 	pci_release_regions(pdev);
+	free_percpu(h->lockup_detected);
 	kfree(h);
 }
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index fa63576..8e8310e 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -191,7 +191,7 @@ struct ctlr_info {
 	u64 last_heartbeat_timestamp;
 	u32 heartbeat_sample_interval;
 	atomic_t firmware_flash_in_progress;
-	u32 lockup_detected;
+	u32 *lockup_detected;
 	struct delayed_work monitor_ctlr_work;
 	int remove_in_progress;
 	u32 fifo_recently_full;

