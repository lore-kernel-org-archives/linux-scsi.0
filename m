Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC302417D8F;
	Tue, 21 Jul 2026 06:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784616043; cv=none; b=ZOlP9Volje2VSlcrKqbdlI3BNFiFvCaCu9ts059MCmLQG//1KXw96pq1wBoBOlSA0LERL/vdgYSE9cB5OK8/x9hwadG+tvmlIKQtJDBzeCqktXvMVipKJWw64GNkkx4ymD3YuadJCnewomn1PXGEb0XqDQZj5oX9iQ/BVQfl5Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784616043; c=relaxed/simple;
	bh=ouLPKGxF1vD+S0h3U7KzlQJsjJwZuN6il4B7iLvQu70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlvQvN0TgNTxO03FBJQwOGvbVCLBy33j4QiTn69Q/R34HnxFgjPam48LBi/xt3cDkbfuejwW4qEk/Tu863twEHzztRkoG/VOG5cVbsA1FxaE/L4joP+Ak/pE9NJAWYrEnpKLgUpjvYlYYLGRm26iScYqUdcuc7glL7ZBpTjzVGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BgIXhMSm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BgIXhMSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DA31F000E9;
	Tue, 21 Jul 2026 06:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784616041;
	bh=xLWPzEdzVa6Eak5YTWSWLMOhwld/kGRTIpheajMCp8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgIXhMSmgMAREk9ix0ud21rzIdrpIfMuJnZEWlSpkbUcZnZwR3Wks0Fmzgz+J2HLx
	 f0D7rwISRKUOzU+OBfej4pZfbOkb6OVvQnryFgt7EUdhwJtqS+0P4EfosyrLgwPfC/
	 PUuZdvkS0h1Qtpcg4M+60PmPNu/1RrboUfuwSUPRcVs8BLSTYdDm76GLphZ9C84Yt/
	 ZhZxtRAQvVfxpd/pLv5713xslfRT0S+5N+BEIFbASmaXxWiK8KXRv3yb12QV1oS7PM
	 Zkr0rCewK8ibfQfFYhKzi4qb05bWofvS4pb4Qr2crre3SGRW6UzIdxDWoITFkVY/fK
	 yRBnZj4RkTGSQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v7 2/2] scsi: libsas: terminate deferred commands on time out
Date: Tue, 21 Jul 2026 15:40:27 +0900
Message-ID: <20260721064027.2081195-3-dlemoal@kernel.org>
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

Avoid this unnecessary additional SCSI EH wake up time with the same
method as implemented in libata-scsi, using the eh_timed_out SCSI host
template operation. The function sas_eh_timed_out() implements this
operation and executes the function ata_scsi_retry_deferred_qc()
for SATA devices.

Co-developed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/ata/libata-scsi.c           |  5 +++--
 drivers/scsi/libsas/sas_scsi_host.c | 15 +++++++++++++++
 include/linux/libata.h              |  2 ++
 include/scsi/libsas.h               |  2 ++
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c2f2f711fd98..ec7ea8f3ce40 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1779,8 +1779,8 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
 		queue_work(system_highpri_wq, &link->deferred_qc_work);
 }
 
-static enum scsi_timeout_action
-ata_scsi_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd)
+enum scsi_timeout_action ata_scsi_retry_deferred_qc(struct ata_port *ap,
+						    struct scsi_cmnd *scmd)
 {
 	enum scsi_timeout_action action;
 	unsigned long flags;
@@ -1791,6 +1791,7 @@ ata_scsi_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd)
 
 	return action;
 }
+EXPORT_SYMBOL_GPL(ata_scsi_retry_deferred_qc);
 
 enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *scmd)
 {
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index c83282733ec4..97ac3db5dccb 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -502,6 +502,21 @@ int sas_eh_target_reset_handler(struct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL_GPL(sas_eh_target_reset_handler);
 
+/*
+ * Handle deferred QCs in case of a command timeout.
+ * See ata_scsi_eh_timed_out() for details.
+ */
+enum scsi_timeout_action sas_eh_timed_out(struct scsi_cmnd *cmd)
+{
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
+
+	if (dev_is_sata(dev))
+		return ata_scsi_retry_deferred_qc(dev->sata_dev.ap, cmd);
+
+	return SCSI_EH_NOT_HANDLED;
+}
+EXPORT_SYMBOL_GPL(sas_eh_timed_out);
+
 /* Try to reset a device */
 static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 327da43d7496..ca0a7e025e9e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1153,6 +1153,8 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
 #endif
 extern enum scsi_qc_status ata_scsi_queuecmd(struct Scsi_Host *h,
 					     struct scsi_cmnd *cmd);
+enum scsi_timeout_action ata_scsi_retry_deferred_qc(struct ata_port *ap,
+						    struct scsi_cmnd *scmd);
 enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *cmd);
 #if IS_REACHABLE(CONFIG_ATA)
 bool ata_scsi_dma_need_drain(struct request *rq);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 163f23c92b41..c7017ae76c61 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -705,6 +705,7 @@ void sas_task_abort(struct sas_task *);
 int sas_eh_abort_handler(struct scsi_cmnd *cmd);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
 int sas_eh_target_reset_handler(struct scsi_cmnd *cmd);
+enum scsi_timeout_action sas_eh_timed_out(struct scsi_cmnd *cmd);
 
 extern void sas_target_destroy(struct scsi_target *);
 extern int sas_sdev_init(struct scsi_device *);
@@ -743,6 +744,7 @@ void sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
 	.this_id			= -1,				\
 	.eh_device_reset_handler	= sas_eh_device_reset_handler,	\
 	.eh_target_reset_handler	= sas_eh_target_reset_handler,	\
+	.eh_timed_out			= sas_eh_timed_out,		\
 	.target_destroy			= sas_target_destroy,		\
 	.ioctl				= sas_ioctl,			\
 
-- 
2.55.0

