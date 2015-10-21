From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 13/37] cxlflash: Fix to avoid stall while waiting on TMF
Date: Wed, 21 Oct 2015 15:13:21 -0500
Message-ID: <1445458401-3279-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:43109 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbbJUUOo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:14:44 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 16:14:44 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 9645D6E804C
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:02:53 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKEgPf47710436
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:14:42 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKEdkL026818
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:14:41 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

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

