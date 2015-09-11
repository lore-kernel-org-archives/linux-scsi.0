From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 14/29] cxlflash: Protect TMF waitq with spinlock
Date: Fri, 11 Sep 2015 16:16:23 -0500
Message-ID: <1442006183-46961-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:57317 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbbIKVQl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:16:41 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 17:16:40 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id C82C538C804F
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:16:38 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLGcGx56688874
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 21:16:38 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLGabZ032439
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:16:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Use a spinlock to protect the TMF waitq instead of borrowing
the internal waitq lock. Also introduce a timeout for when the
TMF fails to complete so the appropriate status can be sent back
to the stack.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  1 +
 drivers/scsi/cxlflash/main.c   | 55 +++++++++++++++++++++++++-----------------
 2 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 2855b09..c8327ac 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -126,6 +126,7 @@ struct cxlflash_cfg {
 	struct list_head lluns; /* list of llun_info structs */
 
 	wait_queue_head_t tmf_waitq;
+	spinlock_t tmf_slock;
 	bool tmf_active;
 	wait_queue_head_t reset_waitq;
 	enum cxlflash_state state;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 600c7f9..29e40cc 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -249,11 +249,10 @@ static void cmd_complete(struct afu_cmd *cmd)
 		scp->scsi_done(scp);
 
 		if (cmd_is_tmf) {
-			spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
+			spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 			cfg->tmf_active = false;
 			wake_up_all_locked(&cfg->tmf_waitq);
-			spin_unlock_irqrestore(&cfg->tmf_waitq.lock,
-					       lock_flags);
+			spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 		}
 	} else
 		complete(&cmd->cevent);
@@ -420,6 +419,7 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	struct device *dev = &cfg->dev->dev;
 	ulong lock_flags;
 	int rc = 0;
+	ulong to;
 
 	cmd = cmd_checkout(afu);
 	if (unlikely(!cmd)) {
@@ -428,15 +428,15 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 		goto out;
 	}
 
-	/* If a Task Management Function is active, do not send one more.
-	 */
-	spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
+	/* When Task Management Function is active do not send another */
+	spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 	if (cfg->tmf_active)
-		wait_event_interruptible_locked_irq(cfg->tmf_waitq,
-						    !cfg->tmf_active);
+		wait_event_interruptible_lock_irq(cfg->tmf_waitq,
+						  !cfg->tmf_active,
+						  cfg->tmf_slock);
 	cfg->tmf_active = true;
 	cmd->cmd_tmf = true;
-	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 
 	cmd->rcb.ctx_id = afu->ctx_hndl;
 	cmd->rcb.port_sel = port_sel;
@@ -457,15 +457,24 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	rc = send_cmd(afu, cmd);
 	if (unlikely(rc)) {
 		cmd_checkin(cmd);
-		spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
+		spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 		cfg->tmf_active = false;
-		spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+		spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 		goto out;
 	}
 
-	spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
-	wait_event_interruptible_locked_irq(cfg->tmf_waitq, !cfg->tmf_active);
-	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+	spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
+	to = msecs_to_jiffies(5000);
+	to = wait_event_interruptible_lock_irq_timeout(cfg->tmf_waitq,
+						       !cfg->tmf_active,
+						       cfg->tmf_slock,
+						       to);
+	if (!to) {
+		cfg->tmf_active = false;
+		dev_err(dev, "%s: TMF timed out!\n", __func__);
+		rc = -1;
+	}
+	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 out:
 	return rc;
 }
@@ -512,16 +521,17 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 			    get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
 			    get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
 
-	/* If a Task Management Function is active, wait for it to complete
+	/*
+	 * If a Task Management Function is active, wait for it to complete
 	 * before continuing with regular commands.
 	 */
-	spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
+	spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 	if (cfg->tmf_active) {
-		spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+		spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
-	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 
 	switch (cfg->state) {
 	case STATE_RESET:
@@ -713,11 +723,12 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	/* If a Task Management Function is active, wait for it to complete
 	 * before continuing with remove.
 	 */
-	spin_lock_irqsave(&cfg->tmf_waitq.lock, lock_flags);
+	spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 	if (cfg->tmf_active)
-		wait_event_interruptible_locked_irq(cfg->tmf_waitq,
-						    !cfg->tmf_active);
-	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
+		wait_event_interruptible_lock_irq(cfg->tmf_waitq,
+						  !cfg->tmf_active,
+						  cfg->tmf_slock);
+	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 
 	cfg->state = STATE_FAILTERM;
 	atomic_inc(&cfg->remove_active);
-- 
2.1.0

