Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C5E416103;
	Tue, 21 Jul 2026 06:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784616042; cv=none; b=Yh+pI2WdfICom2Z67sxKPoWx9h1asBEr8ZlE/QQLS1qUauOcl80Iouvht+yE2pCGPbOttx2uxe/S9nCOKsV7kUWeC851tgPjICgqawzRbYSHC2R3l8IHForJJ22A+NYzPVV4vbY7fj5h7CsZGJChCmxwpLDs45SvPnoCIB69cqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784616042; c=relaxed/simple;
	bh=ayzg419vslShZ5xAr0/iIyB3M0zIqOLxhAYIdX3BCo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoR0RGFKP648JQ9lixxLsik+Rsdag2a3gQCLLDEGFahl9ePnXuGFCmpQPOAlg/23xnl2KdQWpGOojCrUwNL7i/expqFdQ9Fy2kIH61754UKmvKPVPl9FvCJLFFWeLVy6L/nckzY2QA9hqdhhJyyjyUc3B9a9UERTtkeUON14aO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XX55RMc3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XX55RMc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D151F00A3D;
	Tue, 21 Jul 2026 06:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784616040;
	bh=igXsY17JYgLBdTk4U/gCbjOJMKSZV8oX4ztJSrkylfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XX55RMc3W1r2y+TYB84O6647RP9XI5BNE0tj73LDiEE76Z79+JjgvKRKvz7jfAYlL
	 LTElDwa1gA4CUADnQs8z8DS+Pt8zGddRrSZHNl0Lk5v8HwSCwvXkXMiLmgJASrcPIU
	 FDeWsPTOg4I2Nl4kuv+D+QwwcpYshSjtwTcdeVBLSEVU9EPL3gtkR6FYxouolVww5m
	 i6MhkZkrbcSIAZuDE7cGjrUgIElApagzk0lwYaymUGlSr+A3390/01s2mXVLz5ktG0
	 nX/oNzjwEeNOg7/yh6D7Nywv+LFPfGEzDMQT52yjMiIe/gJ0l6c5Vfmn32GkZRZ6RH
	 kIX7D4iQm/oNA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v7 1/2] ata: libata-scsi: terminate deferred commands on time out
Date: Tue, 21 Jul 2026 15:40:26 +0900
Message-ID: <20260721064027.2081195-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721064027.2081195-1-dlemoal@kernel.org>
References: <20260721064027.2081195-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a command times out while we have deferred non-NCQ commands waiting to
be issued, the SCSI EH task is not immediately woken up as the waiting
deferred commands are never issued nor completed, thus leaving the SCSI
host in a busy state (shost->host_failed != scsi_host_busy(shost)) which
prevents the SCSI EH task from being woken up. Eventually, when the
deferred commands also time out, the SCSI EH task is woken up and the
timeout processing occurs.

Avoid this unnecessary SCSI EH task wake-up additional time by scheduling
a retry of all waiting deferred QCs, using the eh_timed_out SCSI host
template operation. The function ata_scsi_eh_timed_out() is introduced to
implement this operation.

However, terminating deferred commands with DID_REQUEUE to force a retry
by calling the function ata_scsi_requeue_deferred_qc() may still keep the
SCSI host in a busy state because the block layer may immediately re-issue
these commands. The solution to this is to schedule libata EH for the
port which suffered the command timeout to prevent accepting any new
command. ata_scsi_requeue_deferred_qc() is modified to add a call to
ata_port_schedule_eh() for this purpose.

In addition to this change, ata_scsi_requeue_deferred_qc() is also
modified to take a new timedout_scmd scsi command argument which indicates
the SCSI command that timed out. With this additional argument,
ata_scsi_requeue_deferred_qc() can now also terminate with DID_TIME_OUT
any timed out deferred qc, which simplifies ata_scsi_cmd_error_handler().
In this case, ata_scsi_requeue_deferred_qc() returns SCSI_EH_DONE, with
this return value propagated back to the ata_scsi_eh_timed_out() operation
to indicate to scsi_timeout() that the timed out command was handled and
no further processing is needed.

For non-timed out deferred qc that need to be retried,
ata_scsi_requeue_deferred_qc() returns SCSI_EH_NOT_HANDLED, thus
indicating to scsi_timeout() that the timed out command needs to go
through the SCSI EH (and libata EH) processing by adding it to the EH work
queue with scsi_eh_scmd_add().

One side effect of these changes is that the function atapi_qc_complete()
needs to be modified to ensure that a deferred ATAPI command that needs
to be retried is completed with DID_REQUEUE instead of the default
SAM_STAT_GOOD status, and a command that timed out is completed with
DID_TIME_OUT instead of SAM_STAT_CHECK_CONDITION.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-eh.c   |  29 +++-------
 drivers/ata/libata-scsi.c | 108 ++++++++++++++++++++++++++++++++++----
 drivers/ata/libata.h      |   3 +-
 include/linux/libata.h    |   2 +
 4 files changed, 107 insertions(+), 35 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 05df7ea6954a..e01277ee1fa9 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -650,29 +650,12 @@ int ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap,
 		set_host_byte(scmd, DID_OK);
 
 		ata_qc_for_each_raw(ap, qc, i) {
-			if (qc->scsicmd != scmd)
-				continue;
-			if ((qc->flags & ATA_QCFLAG_ACTIVE) ||
-			    qc == qc->dev->link->deferred_qc)
+			if (qc->scsicmd == scmd &&
+			    qc->flags & ATA_QCFLAG_ACTIVE)
 				break;
 		}
 
-		if (i < ATA_MAX_QUEUE && qc == qc->dev->link->deferred_qc) {
-			/*
-			 * This is a deferred command that timed out while
-			 * waiting for the command queue to drain. Since the qc
-			 * is not active yet (deferred_qc is still set, so the
-			 * deferred qc work has not issued the command yet),
-			 * simply signal the timeout by finishing the SCSI
-			 * command and clear the deferred qc to prevent the
-			 * deferred qc work from issuing this qc.
-			 */
-			WARN_ON_ONCE(qc->flags & ATA_QCFLAG_ACTIVE);
-			qc->dev->link->deferred_qc = NULL;
-			cancel_work(&qc->dev->link->deferred_qc_work);
-			set_host_byte(scmd, DID_TIME_OUT);
-			scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
-		} else if (i < ATA_MAX_QUEUE) {
+		if (i < ATA_MAX_QUEUE) {
 			/* the scmd has an associated qc */
 			if (!(qc->flags & ATA_QCFLAG_EH)) {
 				/* which hasn't failed yet, timeout */
@@ -948,10 +931,10 @@ static void ata_eh_set_pending(struct ata_port *ap, bool fastdrain)
 	ap->pflags |= ATA_PFLAG_EH_PENDING;
 
 	/*
-	 * If we have a deferred qc, requeue it so that it is retried once EH
-	 * completes.
+	 * If we have deferred QCs, requeue them so that the SCSI EH task can
+	 * run.
 	 */
-	ata_scsi_requeue_deferred_qc(ap);
+	ata_scsi_requeue_deferred_qc(ap, NULL);
 
 	if (!fastdrain)
 		return;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5868526301a2..c2f2f711fd98 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1685,26 +1685,75 @@ void ata_scsi_deferred_qc_work(struct work_struct *work)
 	spin_unlock_irqrestore(ap->lock, flags);
 }
 
-void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
+enum scsi_timeout_action ata_scsi_requeue_deferred_qc(struct ata_port *ap,
+						struct scsi_cmnd *timedout_scmd)
 {
+	enum scsi_timeout_action action = SCSI_EH_NOT_HANDLED;
+	struct ata_queued_cmd *qc;
 	struct ata_link *link;
+	u32 host_byte;
 
 	lockdep_assert_held(ap->lock);
 
 	/*
-	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
-	 * do not try to be smart about what to do with this deferred command
-	 * and simply requeue it by completing it with DID_REQUEUE.
+	 * If we have deferred QCs when a reset, a timeout or an NCQ command
+	 * fails, do not try to be smart about what to do with the deferred
+	 * commands and simply terminate them and let the SCSI layer decide
+	 * what to do.
 	 */
 	ata_for_each_link(link, ap, PMP_FIRST) {
-		struct ata_queued_cmd *qc = link->deferred_qc;
+		qc = link->deferred_qc;
+		if (!qc)
+			continue;
+
+		/*
+		 * Clear the deferred QC so that the deferred work does not try
+		 * to issue it.
+		 */
+		link->deferred_qc = NULL;
+		cancel_work(&link->deferred_qc_work);
+
+		/*
+		 * We are going to complete some scsi command, either with
+		 * DID_TIME_OUT if the command timed out while waiting for being
+		 * issued, or with DID_REQUEUE if another command timed out or
+		 * we had a failed command. However, the block layer may re-issue
+		 * immediately these commands, keeping the scsi host busy and
+		 * thus preventing the SCSI EH task from running.
+		 * So schedule EH on the port to prevent accepting new commands
+		 * until everything is sorted out with the error or timeout that
+		 * got us here in the first place. Note that we set EH pending
+		 * on the port before calling ata_port_schedule_eh() so that we
+		 * do not reenter this function from ata_eh_set_pending() with
+		 * timedout_scmd being NULL and erroneously retry deferred QCs
+		 * that have timed out on other links.
+		 */
+		if (!ata_port_eh_scheduled(ap)) {
+			ap->pflags |= ATA_PFLAG_EH_PENDING;
+			ata_port_schedule_eh(ap);
+		}
 
-		if (qc) {
-			link->deferred_qc = NULL;
-			cancel_work(&link->deferred_qc_work);
-			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
+		/*
+		 * If we are being called from scsi_timeout(), then we have a
+		 * non-NULL timedout_scmd. If the timed out command is for a
+		 * deferred qc, terminate it with DID_TIME_OUT and tell
+		 * scsi_timeout() that we are done. Otherwise, ask for a retry
+		 * with DID_REQUEUE and tell scsi_timeout() that we have not
+		 * handled the timeout so that the timed out command gets added
+		 * to the EH work queue with scsi_eh_scmd_add(), for later
+		 * handling with libata EH ata_scsi_cmd_error_handler().
+		 */
+		if (qc->scsicmd != timedout_scmd) {
+			qc->scsicmd->allowed++;
+			host_byte = DID_REQUEUE;
+		} else {
+			host_byte = DID_TIME_OUT;
+			action = SCSI_EH_DONE;
 		}
+		ata_scsi_qc_done(qc, true, host_byte << 16);
 	}
+
+	return action;
 }
 
 static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
@@ -1723,13 +1772,42 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
 		return;
 
 	if (ata_port_eh_scheduled(ap)) {
-		ata_scsi_requeue_deferred_qc(ap);
+		ata_scsi_requeue_deferred_qc(ap, NULL);
 		return;
 	}
 	if (!ap->ops->qc_defer(qc))
 		queue_work(system_highpri_wq, &link->deferred_qc_work);
 }
 
+static enum scsi_timeout_action
+ata_scsi_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd)
+{
+	enum scsi_timeout_action action;
+	unsigned long flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+	action = ata_scsi_requeue_deferred_qc(ap, scmd);
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	return action;
+}
+
+enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *scmd)
+{
+	struct ata_port *ap = ata_shost_to_port(scmd->device->host);
+
+	/*
+	 * ata_scsi_cmd_error_handler() takes care of timed-out deferred queued
+	 * commands. However, if we had any other command time out and we have
+	 * deferred QCs, we must let scsi_timeout() handle them with
+	 * scsi_eh_scmd_add() so that we do not unnecessarilly delay starting
+	 * the SCSI EH task. So requeue all deferred queued commands for retry
+	 * through libata EH.
+	 */
+	return ata_scsi_retry_deferred_qc(ap, scmd);
+}
+EXPORT_SYMBOL_GPL(ata_scsi_eh_timed_out);
+
 static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 {
 	struct ata_link *link = qc->dev->link;
@@ -2936,7 +3014,15 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
 			qc->dev->sdev->locked = 0;
 
-		ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
+		if (cmd->result)
+			ata_scsi_qc_done(qc, false, 0);
+		else
+			ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
+		return;
+	}
+
+	if (cmd->result) {
+		ata_scsi_qc_done(qc, false, 0);
 		return;
 	}
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 700627596ce1..8dacc1daabf0 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -180,7 +180,8 @@ enum scsi_qc_status __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 					struct ata_port *ap)
 	__must_hold(ap->lock);
 void ata_scsi_deferred_qc_work(struct work_struct *work);
-void ata_scsi_requeue_deferred_qc(struct ata_port *ap);
+enum scsi_timeout_action ata_scsi_requeue_deferred_qc(struct ata_port *ap,
+						      struct scsi_cmnd *scmd);
 
 /* libata-eh.c */
 extern unsigned int ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 96e626d6a7ca..327da43d7496 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1153,6 +1153,7 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
 #endif
 extern enum scsi_qc_status ata_scsi_queuecmd(struct Scsi_Host *h,
 					     struct scsi_cmnd *cmd);
+enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *cmd);
 #if IS_REACHABLE(CONFIG_ATA)
 bool ata_scsi_dma_need_drain(struct request *rq);
 #else
@@ -1464,6 +1465,7 @@ extern const struct attribute_group *ata_common_sdev_groups[];
 	.ioctl			= ata_scsi_ioctl,		\
 	ATA_SCSI_COMPAT_IOCTL					\
 	.queuecommand		= ata_scsi_queuecmd,		\
+	.eh_timed_out		= ata_scsi_eh_timed_out,	\
 	.dma_need_drain		= ata_scsi_dma_need_drain,	\
 	.this_id		= ATA_SHT_THIS_ID,		\
 	.emulated		= ATA_SHT_EMULATED,		\
-- 
2.55.0

