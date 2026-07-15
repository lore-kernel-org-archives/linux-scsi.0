Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3611E3D8911;
	Wed, 15 Jul 2026 08:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784105922; cv=none; b=fiYtsybSDAi+p8TVzIwUp8m2iBiBkn4dzkYqYqb+r3/eBMsIQVFtGkWUMJ3eygR+CEJ6V6OvFSAOqq0P0L+ANWCVRef9F4w/E0Kngmsp+Js+VFaI61y/JEN6/SrRlGvOsYlZNKPV4pRVwqQ3nH5k+Fr4EtbPESzNzGxCq9nBrl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784105922; c=relaxed/simple;
	bh=FqdaFxNwLIRcz2SMjcfmRzJR4DZy72rrmo6Sy4IlZI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEmFrb8uXNmJCzjjvdzxXdxhtfF9dFMLPLx2pzFQgN5f8hyO3TgfEnVo0yLJ1pD4V58brkzgUQkGmvkrT9BNGP/7XMcdud0dVRPVO9osrRoEu9dbrRwK3uZeNAxW1TElTf8xA0Btd01j0htnZ+w1FtxOpQYSI3oaA3jJ1jygjqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0SmCCA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0SmCCA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D211F1F00A3A;
	Wed, 15 Jul 2026 08:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784105917;
	bh=wgAC4Vea26TbVb4jtZe8qThvxzGbUcZWn5Moq0YnE+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0SmCCA8ELuaDpkWd1HygcBTUTCm/7fiD1LyEodI9EdP+6cPVJ2pMSlBd0zyQkBV+
	 16ynLDNNbyKtvKF0s/wNdxXJNQosgjyrW7x8oDrwllIZ0Wj0Gq3IVp7kDTjB5G5P3h
	 qbwZBFgRd2S8jRfQ4IRBh/5nJPp6Y9j0/Z+fT061qJhzJxngjgfbdm1GaLNpbAMESR
	 oPfqItFQBZOt+KbIIOweZk0huDfJ9vC2EJG51FoewR7JAQ8HNHZFSw6vNvkNOH7+rM
	 9/+pHXr+vG5ALKzmXKGMh6OjxP6BrVUCzBzlJvNcBP3chpZInBWFTtlFwgKS2apUnM
	 oUf+RUubWqSDQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 1/2] ata: libata-scsi: terminate deferred commands on time out
Date: Wed, 15 Jul 2026 17:58:23 +0900
Message-ID: <20260715085824.854200-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260715085824.854200-1-dlemoal@kernel.org>
References: <20260715085824.854200-1-dlemoal@kernel.org>
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
these commands to always be counted as "busy" for the SCSI host. This
results in the test "shost->host_failed != scsi_host_busy(shost))" in the
function scsi_error_handler() to always be true, keeping the SCSI EH task
sleeping. Eventually, when the deferred commands also time out, the SCSI
EH task is woken up and the timeout processing occurs.

Avoid this unnecessary SCSI EH task wake-up additional time by immediately
scheduling a retry of all waiting deferred QCs, using the eh_timed_out
SCSI host template operation. The function ata_scsi_eh_timed_out() is
introduced to implement this operation.

However, ata_scsi_eh_timed_out() cannot use the function
ata_scsi_requeue_deferred_qc() to force a retry of waiting deferred QCs,
because this function completes the waiting QCs using ata_scsi_qc_done(),
thus trigerring a requeue at the block layer, which itself may result in
an immediate reissuing of the QCs, thus keeping the device in a busy state
which prevents the SCSI EH task from waking up. To avoid this,
ata_scsi_requeue_deferred_qc() is reimplemented as
ata_eh_retry_deferred_qc() so that the retry of the waiting deferred QCs
is scheduled through libata EH with ata_qc_schedule_eh(), with the waiting
QCs flagged with ATA_QCFLAG_RETRY. Since ata_scsi_requeue_deferred_qc()
was already called only when EH was already scheduled or running, this new
scheduling of libata EH does not add overhead and guarantees that the
device is not kept in a busy state, allowing the SCSI EH task to run and
to execute libata EH. Once done, the deferred QCs retry is scheduled from
ata_eh_finish() calling ata_eh_qc_retry(). This new path requires a small
modification of __ata_eh_qc_complete() to avoid warnings due to the fact
that deferred QCs are not flagged as active (ATA_QCFLAG_ACTIVE is not set
as these QCs have not been issued yet).

Of note is that since ata_scsi_cmd_error_handler() already handles
directly deferred QCs that timed out, ata_eh_retry_deferred_qc() always
ignores a deferred QC that correspond to a timed out SCSI command.

Since ata_scsi_eh_timed_out() does not fully handle the timeout itself,
this function returns SCSI_EH_NOT_HANDLED to have scsi_timeout() continue
with the regular timeout handling, using scsi_abort_command() and
scsi_eh_scmd_add(), thus preventing the wkae-up delay for SCSI EH task.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-eh.c   | 38 +++++++++++++++++++++-----
 drivers/ata/libata-scsi.c | 56 +++++++++++++++++++++++----------------
 drivers/ata/libata.h      |  2 +-
 include/linux/libata.h    |  2 ++
 4 files changed, 68 insertions(+), 30 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 29ec0f7fef4a..7943593d49c8 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -546,6 +546,27 @@ static void ata_eh_unload(struct ata_port *ap)
 	spin_unlock_irqrestore(ap->lock, flags);
 }
 
+void ata_eh_retry_deferred_qc(struct ata_port *ap,
+			      struct scsi_cmnd *timedout_scmd)
+{
+	struct ata_queued_cmd *qc;
+	struct ata_link *link;
+
+	lockdep_assert_held(ap->lock);
+
+	/* Trigger EH for retrying any deferred qc that has not timed out. */
+	ata_for_each_link(link, ap, PMP_FIRST) {
+		qc = link->deferred_qc;
+		if (!qc || qc->scsicmd == timedout_scmd)
+			continue;
+
+		link->deferred_qc = NULL;
+		cancel_work(&link->deferred_qc_work);
+		qc->flags |= ATA_QCFLAG_RETRY;
+		ata_qc_schedule_eh(qc);
+	}
+}
+
 /**
  *	ata_scsi_error - SCSI layer error handler callback
  *	@host: SCSI host on which error occurred
@@ -947,11 +968,8 @@ static void ata_eh_set_pending(struct ata_port *ap, bool fastdrain)
 
 	ap->pflags |= ATA_PFLAG_EH_PENDING;
 
-	/*
-	 * If we have a deferred qc, requeue it so that it is retried once EH
-	 * completes.
-	 */
-	ata_scsi_requeue_deferred_qc(ap);
+	/* If we have deferred QCs, tell EH to retry them. */
+	ata_eh_retry_deferred_qc(ap, NULL);
 
 	if (!fastdrain)
 		return;
@@ -1214,9 +1232,17 @@ static void __ata_eh_qc_complete(struct ata_queued_cmd *qc)
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	unsigned long flags;
 
+
+	/*
+	 * If we are retrying a deferred QC after a timeout, it is not active
+	 * and all we need to do is to complete it directly.
+	 */
 	spin_lock_irqsave(ap->lock, flags);
 	qc->scsidone = ata_eh_scsidone;
-	__ata_qc_complete(qc);
+	if ((qc->flags & ATA_QCFLAG_RETRY) && !(qc->flags & ATA_QCFLAG_ACTIVE))
+		qc->complete_fn(qc);
+	else
+		__ata_qc_complete(qc);
 	WARN_ON(ata_tag_valid(qc->tag));
 	spin_unlock_irqrestore(ap->lock, flags);
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5868526301a2..1870669b8e05 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1685,28 +1685,6 @@ void ata_scsi_deferred_qc_work(struct work_struct *work)
 	spin_unlock_irqrestore(ap->lock, flags);
 }
 
-void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
-{
-	struct ata_link *link;
-
-	lockdep_assert_held(ap->lock);
-
-	/*
-	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
-	 * do not try to be smart about what to do with this deferred command
-	 * and simply requeue it by completing it with DID_REQUEUE.
-	 */
-	ata_for_each_link(link, ap, PMP_FIRST) {
-		struct ata_queued_cmd *qc = link->deferred_qc;
-
-		if (qc) {
-			link->deferred_qc = NULL;
-			cancel_work(&link->deferred_qc_work);
-			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
-		}
-	}
-}
-
 static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
 {
 	struct ata_queued_cmd *qc = link->deferred_qc;
@@ -1723,13 +1701,45 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
 		return;
 
 	if (ata_port_eh_scheduled(ap)) {
-		ata_scsi_requeue_deferred_qc(ap);
+		ata_eh_retry_deferred_qc(ap, NULL);
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
+	ata_eh_retry_deferred_qc(ap, scmd);
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
+	 * deferred queued commands, we must let scsi_timeout() handle them
+	 * with scsi_eh_scmd_add() so that we do not unnecessarilly delay
+	 * starting the SCSI EH task. So schedule all deferred queued commands
+	 * for retry through EH.
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
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 700627596ce1..efaccebe93f5 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -180,7 +180,6 @@ enum scsi_qc_status __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 					struct ata_port *ap)
 	__must_hold(ap->lock);
 void ata_scsi_deferred_qc_work(struct work_struct *work);
-void ata_scsi_requeue_deferred_qc(struct ata_port *ap);
 
 /* libata-eh.c */
 extern unsigned int ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
@@ -198,6 +197,7 @@ extern void ata_eh_about_to_do(struct ata_link *link, struct ata_device *dev,
 			       unsigned int action);
 extern void ata_eh_done(struct ata_link *link, struct ata_device *dev,
 			unsigned int action);
+void ata_eh_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd);
 extern void ata_eh_autopsy(struct ata_port *ap);
 const char *ata_get_cmd_name(u8 command);
 extern void ata_eh_report(struct ata_port *ap);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 30fdf673b887..51178acd68d7 100644
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
@@ -1461,6 +1462,7 @@ extern const struct attribute_group *ata_common_sdev_groups[];
 	.ioctl			= ata_scsi_ioctl,		\
 	ATA_SCSI_COMPAT_IOCTL					\
 	.queuecommand		= ata_scsi_queuecmd,		\
+	.eh_timed_out		= ata_scsi_eh_timed_out,	\
 	.dma_need_drain		= ata_scsi_dma_need_drain,	\
 	.this_id		= ATA_SHT_THIS_ID,		\
 	.emulated		= ATA_SHT_EMULATED,		\
-- 
2.55.0

