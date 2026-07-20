Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF463B71C2;
	Mon, 20 Jul 2026 07:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784531706; cv=none; b=BJe18wW9sV/66f2UPpD5JXTEd1hgLThooztGu2djxsmCCw++8H3G6kNCe1URcQpz7tPVQcwjiuCMB4amL7gChMLzmO3xL7QqQhzsh7wY0jxv0kuMkXh41ibHLlwsoGEcDUQ3L6P9DQu64QUOFtRZ/t20smiCtSAt56+Mt2bi03I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784531706; c=relaxed/simple;
	bh=9BUpk15qLaEqgljyK7r6LiiLwaL+fn/w+l7ArgL2ug8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCtSEHGHXveeBFhWr3JE56M8tXzRulfD4QXaQEGlX6JVOIfelkdZqiZvS2j+mI84mGKEejtVXIDTBemFhIFlQN1120z9R7TfPqK9vokoSUmezrFoFHr7YUZNYf7mMNx893jRMfWXEdyU0xcA7PcLKFitOJm9n7s75NSM7y6er+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5F22iSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5F22iSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB41A1F00A3A;
	Mon, 20 Jul 2026 07:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784531704;
	bh=XnZ44fXzchTURL82v3BAxbRhbVgIBwIKvte3R4h7aCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5F22iSkycEsH7btk9txCaw8NJFWX7nt1GuoS+o2DU+oO5PM4dxksvDQ9WAaiwXI8
	 fQpQEX4RiVBqeSoebL57Q+hH09V7y10cp8WIFHr1CICVza83YazFIIit6mryNO/HV+
	 QpsharlXAHHbpLTy87vX/cmJl++A5XKdi7dCk6wZjhVK5IeJ6Itu9oQgPD7P8yedPd
	 gIZyKSScYY/3Lp+HiuaYeb0KXe5tMgvm0+ZGDqwcIy4BruB2GFqq14g1JFuUDF28gp
	 3bo5G90O/LirCGsGbo606d2b/Dzy8dSBFPOSPFI+m/CCM7lydHSKP9gRshIkVKB/iB
	 MKgf8HExmi8rA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v6 2/2] scsi: libsas: terminate deferred commands on time out
Date: Mon, 20 Jul 2026 16:14:50 +0900
Message-ID: <20260720071450.1877625-3-dlemoal@kernel.org>
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

If a command timeout occurs while we have a deferred non-NCQ command
waiting to be issued, the SCSI EH task is not immediately woken up as the
waiting deferred command is never issued nor completed, thus leaving this
command to always be counted as "busy" for the SCSI host. This results in
the test "shost->host_failed != scsi_host_busy(shost))" in the function
scsi_error_handler() to always be true, keeping the EH task sleeping.
Eventually, when the deferred command also times out, the SCSI EH task
is woken up and the timeout processing occurs.

Avoid this unnecessary additional SCSI EH trigger wait time with the same
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
 drivers/ata/libata-scsi.c           |  4 ++--
 drivers/scsi/libsas/sas_scsi_host.c | 15 +++++++++++++++
 include/linux/libata.h              |  1 +
 include/scsi/libsas.h               |  2 ++
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b02b4ca5c09e..dfd7fc2c8cb6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1762,8 +1762,7 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
 		queue_work(system_highpri_wq, &link->deferred_qc_work);
 }
 
-static void ata_scsi_retry_deferred_qc(struct ata_port *ap,
-				       struct scsi_cmnd *scmd)
+void ata_scsi_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 
@@ -1771,6 +1770,7 @@ static void ata_scsi_retry_deferred_qc(struct ata_port *ap,
 	ata_scsi_requeue_deferred_qc(ap, scmd);
 	spin_unlock_irqrestore(ap->lock, flags);
 }
+EXPORT_SYMBOL_GPL(ata_scsi_retry_deferred_qc);
 
 enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *scmd)
 {
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index c83282733ec4..9bc98a30d9f4 100644
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
+		ata_scsi_retry_deferred_qc(dev->sata_dev.ap, cmd);
+
+	return SCSI_EH_NOT_HANDLED;
+}
+EXPORT_SYMBOL_GPL(sas_eh_timed_out);
+
 /* Try to reset a device */
 static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e1227a2134d2..b8086cac2d04 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1154,6 +1154,7 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
 #endif
 extern enum scsi_qc_status ata_scsi_queuecmd(struct Scsi_Host *h,
 					     struct scsi_cmnd *cmd);
+void ata_scsi_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd);
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

