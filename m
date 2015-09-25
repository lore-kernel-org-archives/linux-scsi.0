From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v4 13/32] cxlflash: Fix to avoid stall while waiting on TMF
Date: Fri, 25 Sep 2015 18:16:07 -0500
Message-ID: <1443222967-9424-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:46336 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbbIYXRp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 19:17:45 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 25 Sep 2015 17:17:45 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id B86A619D803E
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 17:08:35 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8PNGMQK5636500
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 16:16:30 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8PNH95d032500
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 17:17:10 -0600
In-Reply-To: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Borrowing the TMF waitq's spinlock causes a stall condition when
waiting for the TMF to complete. To remedy, introduce our own spin
lock to serialize TMF and use the appropriate wait services.

Also add a timeout while waiting for a TMF completion. When a TMF
times out, report back a failure such that a bigger hammer reset
can occur.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  1 +
 drivers/scsi/cxlflash/main.c   | 55 +++++++++++++++++++++++++-----------------
 2 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index b038ac7..7a0cb5c 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -124,6 +124,7 @@ struct cxlflash_cfg {
 	struct list_head lluns; /* list of llun_info structs */
 
 	wait_queue_head_t tmf_waitq;
+	spinlock_t tmf_slock;
 	bool tmf_active;
 	wait_queue_head_t reset_waitq;
 	enum cxlflash_state state;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 527ff85..110037d 100644
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
 	cxlflash_stop_term_user_contexts(cfg);
-- 
2.1.0

