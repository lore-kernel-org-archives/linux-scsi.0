Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048D53F5BFA;
	Thu,  9 Jul 2026 08:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783586390; cv=none; b=M8Jr39upyGAvZq/PUqsdNe+e1zgR+O3FeU5rAvIr+l5iF9QrZWSN6+qhCvAUmfrOOMGMlJ/TofXcBJf9wdyzz3xWBUDyb9naezlTrC7mz9BDPMTBunkys2Q06K1YRB9aHaRF44hWrWxOBigeGLqMIhqBpBUKBlop4V47g62R2PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783586390; c=relaxed/simple;
	bh=qplhuVEOtDfuKGwAIaxclMasM7DyhppE/47e8Mwj8p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XW4ReQvje4heZ4eoxuQ4yXqrMzAAYl2lmAW7pptv5OKyoDbgD0JGqbdbKkNRl3NDNRqrepaDgqn9GS/S2rO3iohOwOHApVz+pJvcneAjrzTal0j2Ru97hYb/tZc5pQjGiYY1EDzYPBlWUZ446uRPpELIV+hGLFmPIa6YbA667rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DR4mu1MJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DR4mu1MJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4931F00A3A;
	Thu,  9 Jul 2026 08:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783586387;
	bh=AiHnbba24AlG31qtyHPV12EikRad/a+bPbHX1a8EKbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DR4mu1MJBO5CCD9sk1ZzvDIgs7px49gNB0S1IG+Pqo4dd/zFOCwBwoJpj5RrjjX/v
	 HnbnagMqpnxjHnjM8hR67v+rJxoZfOvgaCmLFWrS/A79eduOfY6RWpVczaUdW1Hib0
	 zpgHOWDp/ftl+Prq4/V0QQDt6Ox2uBuayf219tYzKronk5Bxvw9/5jJFyVrUbjrIzu
	 1eOhPlbuHp2GyQHSxRMCrFqftzjFeaqVUjG/w7ZjJM0QRqudlJhSeMSjFidZMpc9Ja
	 rmg5AD43atNkv7HZsZnBmlB7U1kaFlo4VHxjlWBBQ9Z9a8Uw5tyF3z3ZNR1xwhUp++
	 4qiJRRqZH83bA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v1 1/2] ata: libata-scsi: terminate deferred commands on time out
Date: Thu,  9 Jul 2026 17:39:33 +0900
Message-ID: <20260709083934.1116862-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260709083934.1116862-1-dlemoal@kernel.org>
References: <20260709083934.1116862-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a command timeout occurs while we have a deferred non-NCQ command
waiting to be issued, the scsi EH task is never woken up as the waiting
deferred command is never issued nor completed, thus leaving this command
to always be counted as "busy" for the scsi host. This results in the
scsi_error_handler() function test "shost->host_failed !=
scsi_host_busy(shost))" to always be true, keeping the EH task sleeping.
Eventuially, when the deferred command also times out, the EH task is
woken up and the timeout processing occurs.

Avoid this unnecessary EH trigger wait time using the eh_timed_out scsi
host template operation. The function ata_scsi_eh_timed_out() is
introduced to implement this operation using the helper function
ata_scsi_port_eh_timed_out(). This function forces a requeue, or a timed
out completion, of any deferred queued command when a time out error
occurs. Since the timeout itself and eventual re-issuing of commands is
not handled by this helper, SCSI_EH_NOT_HANDLED is returned to have
scsi_timeout() continue with the regular timeout handling.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-eh.c   |  2 +-
 drivers/ata/libata-scsi.c | 53 +++++++++++++++++++++++++++++++++------
 drivers/ata/libata.h      |  3 ++-
 include/linux/libata.h    |  2 ++
 4 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 05df7ea6954a..57d3d2d11dd8 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -951,7 +951,7 @@ static void ata_eh_set_pending(struct ata_port *ap, bool fastdrain)
 	 * If we have a deferred qc, requeue it so that it is retried once EH
 	 * completes.
 	 */
-	ata_scsi_requeue_deferred_qc(ap);
+	ata_scsi_requeue_deferred_qc(ap, NULL);
 
 	if (!fastdrain)
 		return;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5868526301a2..8328778ec046 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1685,7 +1685,8 @@ void ata_scsi_deferred_qc_work(struct work_struct *work)
 	spin_unlock_irqrestore(ap->lock, flags);
 }
 
-void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
+void ata_scsi_requeue_deferred_qc(struct ata_port *ap,
+				  struct scsi_cmnd *timed_out_scmd)
 {
 	struct ata_link *link;
 
@@ -1698,12 +1699,19 @@ void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
 	 */
 	ata_for_each_link(link, ap, PMP_FIRST) {
 		struct ata_queued_cmd *qc = link->deferred_qc;
+		u32 host_byte;
 
-		if (qc) {
-			link->deferred_qc = NULL;
-			cancel_work(&link->deferred_qc_work);
-			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
-		}
+		if (!qc)
+			continue;
+
+		link->deferred_qc = NULL;
+		cancel_work(&link->deferred_qc_work);
+
+		if (qc->scsicmd == timed_out_scmd)
+			host_byte = DID_TIME_OUT;
+		else
+			host_byte = DID_REQUEUE;
+		ata_scsi_qc_done(qc, true, host_byte << 16);
 	}
 }
 
@@ -1723,13 +1731,44 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
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
+ata_scsi_port_eh_timed_out(struct ata_port *ap, struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+
+	/*
+	 * We had a timeout, either for an NCQ command or for one deferred
+	 * queued command. If we have deferred QCs and we do not release them
+	 * immediately, we will have shost->host_failed != scsi_host_busy()
+	 * until the deferred QCs also timeout. This unnecessarilly increases
+	 * the time it takes for scsi EH to start. Terminate all deferred QCs
+	 * to avoid that.
+	 */
+	spin_lock_irqsave(ap->lock, flags);
+	ata_scsi_requeue_deferred_qc(ap, scmd);
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	/*
+	 * Let scsi_timeout() know that it must continue with handling the
+	 * timeout as we in fact did not do much here.
+	 */
+	return SCSI_EH_NOT_HANDLED;
+}
+
+enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *scmd)
+{
+	return ata_scsi_port_eh_timed_out(ata_shost_to_port(scmd->device->host),
+					  scmd);
+}
+EXPORT_SYMBOL_GPL(ata_scsi_eh_timed_out);
+
 static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 {
 	struct ata_link *link = qc->dev->link;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 700627596ce1..14912e140686 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -180,7 +180,8 @@ enum scsi_qc_status __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 					struct ata_port *ap)
 	__must_hold(ap->lock);
 void ata_scsi_deferred_qc_work(struct work_struct *work);
-void ata_scsi_requeue_deferred_qc(struct ata_port *ap);
+void ata_scsi_requeue_deferred_qc(struct ata_port *ap,
+				  struct scsi_cmnd *timed_out_scmd);
 
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

