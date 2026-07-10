Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F5E9443;
	Fri, 10 Jul 2026 00:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783642020; cv=none; b=WC5mAWzPM49dpGXpKq5a6KXlXn+k341cT381nLLo/p5k8imLci0vhc4be8IeuVbw/rGUU+bx1P3t8hpnQGPehq+O+Be5jeiUrT+9Fwd5OmQwHdhYzjwntCIJ6lILtv9cD5cIfYRoPZABsUu/ivsWB96bp4PYZVMW+e1+MsKq28w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783642020; c=relaxed/simple;
	bh=V/CyalsdJKnMO4YCU3vU19m069iyRVvoldcLK/M+ILU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUBaVYTdLSpsfASoWIxGHHhftrYpfvRBTPtZoxBWxS/j5xtY8c2XiSlRvBgXRdIzJt0WPI1+pjjoKTVIQrAawQOZJTIdOUTRllb5RKVFK5qnGZ4ZtuzAuGKZVQQm+N1ZkbP5Mg8SiojycK+clfxCQqU52kk78mLkD7a3dw5xB30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W1Bk+qUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W1Bk+qUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CF61F00A3F;
	Fri, 10 Jul 2026 00:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783642019;
	bh=q/ooY3G3GWXvC2VsC1yclRhq8K0meYaBcuekbBParfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1Bk+qUkgttLeGtBoZpRl5c9PfIfg2v3I94wfv0HbfIFafsd2RblkuBWbvBsscWGU
	 eTcwex2A+gf8Gj/Cijpscs5Y+9vfApCK2cVByTeCfAHI2Bm0iQOopyHjQlZV02PNVH
	 EcQkJK/3K3xVd2vt7K9ZJ28EJjbGS/23Fn3e/qEncQyQ4GqQXI7c8U3xbML7DiLUm1
	 f9loYrc5iOSt6hLQ0dpTaPQXJX5xavoamBWwMGhzQleddZG5neW2IH3VyBUnPZDJTJ
	 2bPQH1k6qigih/E6sgYI+TxbQr4j5F71LH+zJWlZoObWLWDoKteXHVg1aw1g491N6h
	 8i9ub5ZN6HzcQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 1/2] ata: libata-scsi: terminate deferred commands on time out
Date: Fri, 10 Jul 2026 09:06:45 +0900
Message-ID: <20260710000646.1202200-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260710000646.1202200-1-dlemoal@kernel.org>
References: <20260710000646.1202200-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a command timeout occurs while we have a deferred non-NCQ command
waiting to be issued, the SCSI EH task is never woken up as the waiting
deferred command is never issued nor completed, thus leaving this command
to always be counted as "busy" for the SCSI host. This results in the
scsi_error_handler() function test "shost->host_failed !=
scsi_host_busy(shost))" to always be true, keeping the EH task sleeping.
Eventuially, when the deferred command also times out, the SCSI EH task
is woken up and the timeout processing occurs.

Avoid this unnecessary EH trigger additional wait time using the
eh_timed_out SCSI host template operation. The function
ata_scsi_eh_timed_out() is introduced to implement this operation using
the helper function ata_scsi_port_eh_timed_out(). This function calls
ata_scsi_requeue_deferred_qc() to force a requeue of deferred QCs, except
for QCs that actually timed out. In this case,
ata_scsi_cmd_error_handler() processing of timed out deferred QCs still
applies.  Since the timeout itself and eventual re-issuing of deferred
commands is not handled by this helper, SCSI_EH_NOT_HANDLED is returned
to have scsi_timeout() continue with the regular timeout handling.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-eh.c   |  2 +-
 drivers/ata/libata-scsi.c | 51 +++++++++++++++++++++++++++++++++------
 drivers/ata/libata.h      |  3 ++-
 include/linux/libata.h    |  2 ++
 4 files changed, 48 insertions(+), 10 deletions(-)

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
index 5868526301a2..b6e25aab01d5 100644
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
 
@@ -1694,16 +1695,19 @@ void ata_scsi_requeue_deferred_qc(struct ata_port *ap)
 	/*
 	 * If we have a deferred qc when a reset occurs or NCQ commands fail,
 	 * do not try to be smart about what to do with this deferred command
-	 * and simply requeue it by completing it with DID_REQUEUE.
+	 * and simply requeue it by completing it with DID_REQUEUE. The
+	 * exception here is if the deferred qc timed out, in which case, we
+	 * leave it as is as ata_scsi_cmd_error_handler() will take care of it.
 	 */
 	ata_for_each_link(link, ap, PMP_FIRST) {
 		struct ata_queued_cmd *qc = link->deferred_qc;
 
-		if (qc) {
-			link->deferred_qc = NULL;
-			cancel_work(&link->deferred_qc_work);
-			ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
-		}
+		if (!qc || qc->scsicmd == timed_out_scmd)
+			continue;
+
+		link->deferred_qc = NULL;
+		cancel_work(&link->deferred_qc_work);
+		ata_scsi_qc_done(qc, true, DID_REQUEUE << 16);
 	}
 }
 
@@ -1723,13 +1727,44 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
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

