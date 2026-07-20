Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAB93B71BB;
	Mon, 20 Jul 2026 07:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784531705; cv=none; b=MgY9eiw08aJ+2Z7JwujCe4kEdvcHqTTMTeztEpKzPDKEAKT9ydTyHXEQfD6hOsYbAUEr0QtvLpo86bC3DTwgWIDF0xM+A5Xq9JAM2EUL24NMeASb3VzHDh5KlbnIwZhFzh2zTVUf0gxh7VNTifGfVIh1oJijPiqVghIWGZpPYxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784531705; c=relaxed/simple;
	bh=y7uvseoErJEP6MwHos+HIes6GKq9NmoNxMsKcGfBBdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yrphn8pTVRd+rqqfwHUW6CStNGKK/CoMbwXNgJBA09NJuSGPxyMxWQTLgS4m/1GlE4J8r2iLPpJx0+64ZXqHFwpBXunT3nc0UbR0xe9LB0O1ssHVsOtwgQVaK+R6q2SFsvFDa4AsjiUArNdxKhK8O597Vkfs8BSIgH10/suffxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S63WW0zG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S63WW0zG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A275D1F000E9;
	Mon, 20 Jul 2026 07:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784531703;
	bh=lBEIN7nl7KIo1Jvh7tnGX59hRviMLj8Y83k91GgZ6xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S63WW0zGtmfdph91w3pKD5nTAHuD34zOJ/ipj8ijn2C0wJzMMFWJqbF1lSj7k0a5B
	 TOchTYvKQeDF8q856euyCb1cojNzkY73IPl7yHEHhfxDXqoxUab6Ab7EJwvQMls0GD
	 cOn1fhGLOr3i9ndNynLMOZsQDUCIuV30jw2ns5zNJLMxfcx5peMWURL0q3eFgs45fN
	 OL+HK2OIODm7FNjgYbhm7jc/d2wX4a2bHdXgcPGNF39i02Tu5AkQphEsXd6NeVlcc0
	 J+tu6bVPYkPENOyljHetJzeIcR56QUkYldnuq0sKN0JjqtEcjZEk04/7cDMHnqqAe1
	 L6V82DCIgquPg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v6 1/2] ata: libata-scsi: terminate deferred commands on time out
Date: Mon, 20 Jul 2026 16:14:49 +0900
Message-ID: <20260720071450.1877625-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720071450.1877625-1-dlemoal@kernel.org>
References: <20260720071450.1877625-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a command timeout occurs while we have deferred non-NCQ commands
waiting to be issued, the SCSI EH task is not immediately woken up as the
waiting deferred commands are never issued nor completed, thus leaving
the SCSI host in a busy state with the test
"shost->host_failed != scsi_host_busy(shost))" in the function
scsi_error_handler() being true and preventing the SCSI EH task from being
woken up. Eventually, when the deferred commands also time out, the SCSI
EH task is woken up and the timeout processing occurs.

Avoid this unnecessary SCSI EH task wake-up additional time by scheduling
a retry of all waiting deferred QCs, using the eh_timed_out SCSI host
template operation. The function ata_scsi_eh_timed_out() is introduced to
implement this operation. However, we cannot use libata EH function
ata_scsi_cmd_error_handler() to terminate the deferred commands with
DID_REQUEUE for retrying them because this function is not executed unless
the SCSI EH task wakes up.

The solution is to schedule libata EH and to mark all deferred QCs as
belonging to EH, so that the SCSI host is not kept busy.
ata_scsi_requeue_deferred_qc() is modified to implement this with
ata_qc_schedule_eh(). Doing so handles all cases where we have to retry
or terminate deferred QCs:
1) If an NCQ error occurs: libata EH is already scheduled and no new
   command will be accepted until libata EH completes. All deferred QCs
   are terminated with ata_scsi_qc_done() and DID_REQUEUE so that they
   are retried once libata EH finishes running.
2) An NCQ command timeout occurs: ata_scsi_eh_timed_out() is called from
   scsi_timeout(), flagging the deferred QCs with ATA_QCFLAG_RETRY and
   calling ata_qc_schedule_eh() to schedule EH. scsi_timeout() then calls
   scsi_eh_scmd_add() which prevents the SCSI host from being kept busy.
3) A deferred QC times out while waiting to be issued: this is similar to
   case 2, but in this case, the deferred QC is not flagged with
   ATA_QCFLAG_RETRY.

ata_scsi_requeue_deferred_qc() is modified with an additional argument
indicating (if non-NULL) if the function is being called due to a timedout
command. Using this additional argument allows distinguishing between
case (2) and (3) above: commands that did not time out are flagged with
ATA_QCFLAG_RETRY and ata_qc_schedule_eh() called. Commands that timed out
are also scheduled for EH but not flagged with ATA_QCFLAG_RETRY. Finally,
if ata_scsi_requeue_deferred_qc() is called in the case of a failed
command (case 1 above), since EH was already scheduled in that case, the
deferred command is immediately terminated with ata_scsi_qc_done() and
DID_REQUEUE status.

Since ata_qc_schedule_eh() calls ata_eh_set_pending(), which then calls
ata_scsi_requeue_deferred_qc() when ATA_PFLAG_EH_PENDING is not already
set, for cases (2) and (3), the port is flagged with ATA_PFLAG_EH_PENDING
before calling ata_qc_schedule_eh() so that we do not re-enter
ata_scsi_requeue_deferred_qc().

With these changes, ata_scsi_cmd_error_handler() cannot rely on a QC
device link deferred_qc field to identify a deferred queued command (that
field is now always cleared before entering ata_scsi_cmd_error_handler()).
This is solved by introducing the queued command flag ATA_QCFLAG_DEFERRED
which is set in ata_scsi_qc_issue() for a queued command that is being
deferred and cleared in ata_scsi_deferred_qc_work() when a deferred QC is
issued (to ensure that any failure of the QC from this point on is handled
regularly).

Retrying of all deferred QCs is handled from ata_eh_finish() with
ata_eh_qc_retry(), with ata_scsi_cmd_error_handler() setting the host byte
of deferred QCs to either DID_REQUEUE or DID_TIME_OUT (case 2 and 3
above) and calling scsi_eh_finish_cmd(). __ata_eh_qc_complete() is
modified to directly complete deferred QCs to avoid calling again
scsi_eh_finish_cmd(). One side effect of this change is that the function
atapi_qc_complete() is modified to ensure that a deferred ATAPI command
that needs to be retried is completed with DID_REQUEUE instead of
the default SAM_STAT_GOOD status, and a command that timeoued out is
completed with DID_TIME_OUT instead of SAM_STAT_CHECK_CONDITION.

Since ata_scsi_eh_timed_out() does not fully handle the timeout itself,
this function returns SCSI_EH_NOT_HANDLED to have scsi_timeout() continue
with the regular timeout handling, using scsi_abort_command() and
scsi_eh_scmd_add(), thus preventing the wake-up delay for SCSI EH task.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-eh.c   | 48 +++++++++++++++-----
 drivers/ata/libata-scsi.c | 94 ++++++++++++++++++++++++++++++++++-----
 drivers/ata/libata.h      |  2 +-
 include/linux/libata.h    |  3 ++
 4 files changed, 124 insertions(+), 23 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 05df7ea6954a..a35d55fedf1e 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -653,23 +653,36 @@ int ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap,
 			if (qc->scsicmd != scmd)
 				continue;
 			if ((qc->flags & ATA_QCFLAG_ACTIVE) ||
-			    qc == qc->dev->link->deferred_qc)
+			    (qc->flags & ATA_QCFLAG_DEFERRED))
 				break;
 		}
 
-		if (i < ATA_MAX_QUEUE && qc == qc->dev->link->deferred_qc) {
+		if (i < ATA_MAX_QUEUE && (qc->flags & ATA_QCFLAG_DEFERRED)) {
 			/*
-			 * This is a deferred command that timed out while
-			 * waiting for the command queue to drain. Since the qc
-			 * is not active yet (deferred_qc is still set, so the
-			 * deferred qc work has not issued the command yet),
-			 * simply signal the timeout by finishing the SCSI
-			 * command and clear the deferred qc to prevent the
-			 * deferred qc work from issuing this qc.
+			 * This is a deferred qc, which we need to either retry
+			 * if flagged with ATA_QCFLAG_RETRY, or otherwise
+			 * terminate as it timed out while waiting for the
+			 * command queue to drain. Since the qc is not active
+			 * yet, mark it as belonging to EH and finish the SCSI
+			 * command so that ata_eh_finish() signals the timeout.
 			 */
 			WARN_ON_ONCE(qc->flags & ATA_QCFLAG_ACTIVE);
 			qc->dev->link->deferred_qc = NULL;
 			cancel_work(&qc->dev->link->deferred_qc_work);
+
+			if (qc->flags & ATA_QCFLAG_RETRY) {
+				/*
+				 * Retry the qc: do not change its allowed retry
+				 * count as ata_eh_finish() -> ata_eh_qc_retry()
+				 * will take care of that.
+				 */
+				set_host_byte(scmd, DID_REQUEUE);
+				scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
+				continue;
+			}
+
+			qc->err_mask |= AC_ERR_TIMEOUT;
+			qc->flags |= ATA_QCFLAG_EH;
 			set_host_byte(scmd, DID_TIME_OUT);
 			scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
 		} else if (i < ATA_MAX_QUEUE) {
@@ -948,10 +961,10 @@ static void ata_eh_set_pending(struct ata_port *ap, bool fastdrain)
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
@@ -1214,8 +1227,19 @@ static void __ata_eh_qc_complete(struct ata_queued_cmd *qc)
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	unsigned long flags;
 
+	/*
+	 * If we are retrying a deferred QC after a timeout, it is not active
+	 * and we already called scsi_eh_finish_cmd() in
+	 * ata_scsi_cmd_error_handler(). So all we need to do is to complete it
+	 * directly.
+	 */
 	spin_lock_irqsave(ap->lock, flags);
 	qc->scsidone = ata_eh_scsidone;
+	if (qc->flags & ATA_QCFLAG_DEFERRED) {
+		qc->complete_fn(qc);
+		spin_unlock_irqrestore(ap->lock, flags);
+		return;
+	}
 	__ata_qc_complete(qc);
 	WARN_ON(ata_tag_valid(qc->tag));
 	spin_unlock_irqrestore(ap->lock, flags);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5868526301a2..b02b4ca5c09e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1679,31 +1679,63 @@ void ata_scsi_deferred_qc_work(struct work_struct *work)
 	if (qc && !ata_port_eh_scheduled(ap)) {
 		WARN_ON_ONCE(ap->ops->qc_defer(qc));
 		link->deferred_qc = NULL;
+		qc->flags &= ~ATA_QCFLAG_DEFERRED;
 		ata_qc_issue(ap, qc);
 	}
 
 	spin_unlock_irqrestore(ap->lock, flags);
 }
 
-void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
+void ata_scsi_requeue_deferred_qc(struct ata_port *ap,
+				  struct scsi_cmnd *timedout_scmd)
 {
+	struct ata_queued_cmd *qc;
 	struct ata_link *link;
 
 	lockdep_assert_held(ap->lock);
 
 	/*
-	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
-	 * do not try to be smart about what to do with this deferred command
-	 * and simply requeue it by completing it with DID_REQUEUE.
+	 * Trigger EH for any deferred qc, to either retry them or handle one
+	 * that timed out.
 	 */
 	ata_for_each_link(link, ap, PMP_FIRST) {
-		struct ata_queued_cmd *qc = link->deferred_qc;
+		qc = link->deferred_qc;
+		if (!qc)
+			continue;
 
-		if (qc) {
-			link->deferred_qc = NULL;
-			cancel_work(&link->deferred_qc_work);
+		link->deferred_qc = NULL;
+		cancel_work(&link->deferred_qc_work);
+
+		if (!timedout_scmd) {
+			/*
+			 * We are retrying due to some error. Complete the
+			 * request and ask for a requeue. In this case, since EH
+			 * was scheduled already, the block layer attempting to
+			 * re-issue the command immediately will not lead to the
+			 * device being kept busy, thus allowing SCSI EH task to
+			 * run.
+			 */
 			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
+			continue;
 		}
+
+		/*
+		 * We are being called from scsi_timeout(). scsi_eh_scmd_add()
+		 * will add the command to eh_work_q and it will be handled by
+		 * ata_scsi_cmd_error_handler(). So here, we only need to
+		 * indicate if we want a retry if the command did not timeout.
+		 */
+		if (qc->scsicmd != timedout_scmd)
+			qc->flags |= ATA_QCFLAG_RETRY;
+
+		/*
+		 * Schedule EH, but set EH pending on the port so that we do not
+		 * reenter this function from ata_eh_set_pending() with
+		 * timedout_scmd being NULL and erroneously retry deferred QCs
+		 * that have timed out on other links.
+		 */
+		ap->pflags |= ATA_PFLAG_EH_PENDING;
+		ata_qc_schedule_eh(qc);
 	}
 }
 
@@ -1723,13 +1755,45 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
 		return;
 
 	if (ata_port_eh_scheduled(ap)) {
-		ata_scsi_requeue_deferred_qc(ap);
+		ata_scsi_requeue_deferred_qc(ap, NULL);
 		return;
 	}
 	if (!ap->ops->qc_defer(qc))
 		queue_work(system_highpri_wq, &link->deferred_qc_work);
 }
 
+static void ata_scsi_retry_deferred_qc(struct ata_port *ap,
+				       struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+	ata_scsi_requeue_deferred_qc(ap, scmd);
+	spin_unlock_irqrestore(ap->lock, flags);
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
+	ata_scsi_retry_deferred_qc(ap, scmd);
+
+	/*
+	 * Let scsi_timeout() know that it must continue with handling the
+	 * timeout as we in fact did not do much here.
+	 */
+	return SCSI_EH_NOT_HANDLED;
+}
+EXPORT_SYMBOL_GPL(ata_scsi_eh_timed_out);
+
 static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 {
 	struct ata_link *link = qc->dev->link;
@@ -1823,6 +1887,7 @@ static int ata_scsi_qc_issue(struct ata_port *ap, struct ata_queued_cmd *qc)
 	 * commands complete.
 	 */
 	if (!ata_is_ncq(qc->tf.protocol)) {
+		qc->flags |= ATA_QCFLAG_DEFERRED;
 		link->deferred_qc = qc;
 		return 0;
 	}
@@ -2916,6 +2981,7 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 
 	/* handle completion from EH */
 	if (unlikely(err_mask || qc->flags & ATA_QCFLAG_SENSE_VALID)) {
+		u32 result = SAM_STAT_CHECK_CONDITION;
 
 		if (!(qc->flags & ATA_QCFLAG_SENSE_VALID))
 			ata_gen_passthru_sense(qc);
@@ -2936,7 +3002,15 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
 			qc->dev->sdev->locked = 0;
 
-		ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
+		if (qc->err_mask & AC_ERR_TIMEOUT)
+			result = DID_TIME_OUT << 16;
+
+		ata_scsi_qc_done(qc, true, result);
+		return;
+	}
+
+	if (qc->flags & ATA_QCFLAG_RETRY) {
+		ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
 		return;
 	}
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 700627596ce1..d99b3cef1351 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -180,7 +180,7 @@ enum scsi_qc_status __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 					struct ata_port *ap)
 	__must_hold(ap->lock);
 void ata_scsi_deferred_qc_work(struct work_struct *work);
-void ata_scsi_requeue_deferred_qc(struct ata_port *ap);
+void ata_scsi_requeue_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd);
 
 /* libata-eh.c */
 extern unsigned int ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 96e626d6a7ca..e1227a2134d2 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -277,6 +277,7 @@ enum {
 	ATA_QCFLAG_QUIET	= (1 << 6), /* don't report device error */
 	ATA_QCFLAG_RETRY	= (1 << 7), /* retry after failure */
 	ATA_QCFLAG_HAS_CDL	= (1 << 8), /* qc has CDL a descriptor set */
+	ATA_QCFLAG_DEFERRED	= (1 << 9), /* Deferred qc */
 
 	ATA_QCFLAG_EH		= (1 << 16), /* cmd aborted and owned by EH */
 	ATA_QCFLAG_SENSE_VALID	= (1 << 17), /* sense data valid */
@@ -1153,6 +1154,7 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
 #endif
 extern enum scsi_qc_status ata_scsi_queuecmd(struct Scsi_Host *h,
 					     struct scsi_cmnd *cmd);
+enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *cmd);
 #if IS_REACHABLE(CONFIG_ATA)
 bool ata_scsi_dma_need_drain(struct request *rq);
 #else
@@ -1464,6 +1466,7 @@ extern const struct attribute_group *ata_common_sdev_groups[];
 	.ioctl			= ata_scsi_ioctl,		\
 	ATA_SCSI_COMPAT_IOCTL					\
 	.queuecommand		= ata_scsi_queuecmd,		\
+	.eh_timed_out		= ata_scsi_eh_timed_out,	\
 	.dma_need_drain		= ata_scsi_dma_need_drain,	\
 	.this_id		= ATA_SHT_THIS_ID,		\
 	.emulated		= ATA_SHT_EMULATED,		\
-- 
2.55.0

