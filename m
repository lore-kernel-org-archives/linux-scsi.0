Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEAB37189B;
	Mon, 13 Jul 2026 04:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783915987; cv=none; b=OLrgveOZR2XVYLU9Wk8GzeLAWxkpZA0R8SG/C8JXFXm3xZD08Y7/otHvNezNPLbpQ5L1dlZflEgYO4Ucfx75xAXMIOL8ZehfXQ0IOuxF1PAvVoIEc5vo38l1HMAbJUq0hY2DCkOqKoF4070EC2cTyysoZDCFG0ni+XWry+Dkm14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783915987; c=relaxed/simple;
	bh=gdsgy/DIKkH8jqY1X23nO6p5VjtyfcGk788c6Ii0oyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5i/itOjbpiisLl/qIg4AODPbklpTg41AY0DpUM9s+y1CkunEBpOqI4CaKb2UmtXhm4SgolabxATJDC4zzRPsMYr/smvkXQPCYkHUMncce+NWp0ODLN7yuWu9Uh6XF/XnKA9/88dSDn/D8NV9UWAjonNZ1Eup4TAfloPt0jJzmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EhENaHQT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EhENaHQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0860A1F00A3A;
	Mon, 13 Jul 2026 04:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783915985;
	bh=sVkoAzFL7Q+zCCMf//Zthonnrph3yIRFVF2yno5xznM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EhENaHQT/15LLCTTv0a8ifrIj5tGO0v6NxBYXBgr+Z5YJGGCNs5pvgHUjRpfAtfkU
	 tTn189FdlfX5KHlrVKAjteXm/a4jjP5J+h3b/MGnUriLCdhtZau6zaBV0SW5Ho3dtE
	 oolmjuJU8v/9Ae9jfaDnHVxuied0BI11KtvqX10jQ/lATaDBnBFGrnHvl6DiwGFAXh
	 IsTVPB8pA0z4fFggw5q6o80fEBgdcvnQ2zr+T2+f3ZpktetipWJxIeN66o09u+wb0E
	 eJhDljf7xoZsAtgKE7JQ9VBqCY3AMT+EHr60qDUXsoSuQDbMk/kGNrOSycIXgwMZDZ
	 de4P1A0cyrxtg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 1/2] ata: libata-scsi: terminate deferred commands on time out
Date: Mon, 13 Jul 2026 13:12:51 +0900
Message-ID: <20260713041252.463401-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260713041252.463401-1-dlemoal@kernel.org>
References: <20260713041252.463401-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a command timeout occurs while we have a deferred non-NCQ command
waiting to be issued, the SCSI EH task is not immediately woken up as the
waiting deferred command is never issued nor completed, thus leaving this
command to always be counted as "busy" for the SCSI host. This results in
the test "shost->host_failed != scsi_host_busy(shost))" in the function
scsi_error_handler() to always be true, keeping the EH task sleeping.
Eventually, when the deferred command also times out, the SCSI EH task
is woken up and the timeout processing occurs.

Avoid this unnecessary SCSI EH task wake-up additional time using the
eh_timed_out SCSI host template operation. The function
ata_scsi_eh_timed_out() is introduced to implement this operation. This
function calls the new helper ata_eh_schedule_deferred_qc_retry() to
schedule a retry through libata EH of all differed queued command, except
for a differed queued commands that timed out as that case is handled in
ata_scsi_cmd_error_handler().

Since ata_scsi_eh_timed_out() does not directly handles the timeout itself
and eventual re-issuing of deferred commands, this function returns
SCSI_EH_NOT_HANDLED to have scsi_timeout() continue with the regular
timeout handling, using scsi_abort_command() and scsi_eh_scmd_add(), thus
preventing the wkae-up delay for SCSI EH task.

Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-eh.c   | 35 ++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-scsi.c | 22 ++++++++++++++++++++++
 drivers/ata/libata.h      |  2 ++
 include/linux/libata.h    |  2 ++
 4 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 05df7ea6954a..8e9d57c6f039 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -546,6 +546,31 @@ static void ata_eh_unload(struct ata_port *ap)
 	spin_unlock_irqrestore(ap->lock, flags);
 }
 
+void ata_eh_schedule_deferred_qc_retry(struct ata_port *ap,
+				       struct scsi_cmnd *scmd)
+{
+	struct ata_queued_cmd *qc;
+	struct ata_link *link;
+	unsigned long flags;
+
+	/*
+	 * Trigger EH for retrying any deferred qc that is not the queued
+	 * command for scmd.
+	 */
+	spin_lock_irqsave(ap->lock, flags);
+	ata_for_each_link(link, ap, PMP_FIRST) {
+		qc = link->deferred_qc;
+		if (!qc || qc->scsicmd == scmd)
+			continue;
+
+		link->deferred_qc = NULL;
+		cancel_work(&link->deferred_qc_work);
+		qc->flags |= ATA_QCFLAG_RETRY;
+		ata_qc_schedule_eh(qc);
+	}
+	spin_unlock_irqrestore(ap->lock, flags);
+}
+
 /**
  *	ata_scsi_error - SCSI layer error handler callback
  *	@host: SCSI host on which error occurred
@@ -1214,9 +1239,17 @@ static void __ata_eh_qc_complete(struct ata_queued_cmd *qc)
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
index 5868526301a2..89ef2eef72a0 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1730,6 +1730,28 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
 		queue_work(system_highpri_wq, &link->deferred_qc_work);
 }
 
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
+	ata_eh_schedule_deferred_qc_retry(ap, scmd);
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
index 700627596ce1..e1fdecd93ccf 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -198,6 +198,8 @@ extern void ata_eh_about_to_do(struct ata_link *link, struct ata_device *dev,
 			       unsigned int action);
 extern void ata_eh_done(struct ata_link *link, struct ata_device *dev,
 			unsigned int action);
+void ata_eh_schedule_deferred_qc_retry(struct ata_port *ap,
+				       struct scsi_cmnd *scmd);
 extern void ata_eh_autopsy(struct ata_port *ap);
 const char *ata_get_cmd_name(u8 command);
 extern void ata_eh_report(struct ata_port *ap);
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

