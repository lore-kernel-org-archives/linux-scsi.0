Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453053ED3BA;
	Thu, 16 Jul 2026 08:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191143; cv=none; b=PGMkkefMZC1SJGXF12ez7wI8plAEzDrR5vI7TxOiCG/HatyLT9/z/rUQ7lVfzzf0FHwtWlNrGljzQTO3cLiwFgMRWLGzEEJ3yreru/CjykDBqj05y5xNKMUHKEKpQs1FLxtxKi5ktSxhqjeU4uIrU9u8avckn4gNegGz6yHbtpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191143; c=relaxed/simple;
	bh=hlbOMmAGJR8/XJu86SXzH8cH9NmoSyplbKoejR5Mvpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6dH2sFL/LdljCrg8bzI3dSXJmTHcrw6NP18V0ALxuqxFZuff2lDXeDLyUPDHav5IDVBT0vr5+TRvU3PuWGBee5lklG15t64J/OuOHEJWmSnMsJrwzTB1kOy+uEU+CDqQScoR6nS2/dnsZDTSWOwsOneTjdDAAChHDDCXv9CsFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcW3fuzf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcW3fuzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296A61F00A3F;
	Thu, 16 Jul 2026 08:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784191141;
	bh=vtGHVALnKe+zM3VF5ROaGc6HARSb4gHr4ZOgX+CPozw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcW3fuzf5rxQCm/WV3wFpbY7SXRYXp8tCp+ZGewBramTDaN8w20cYO9fwFkeQatxo
	 pK1zy6BMgs2X++PfI6sKDzZFaRiwRUKaFmRm2dcXdZGU14pRTA5R1s2j2lRQp8xjWX
	 FDS41488Z6lByX0vit4f2iubs8a4aKOISM6JN8YS2WZtAQH7KGL0Fx3clV7uLxrYqH
	 OnfhKPo+sZodL1lg6SQyv5MWkS8Qsu6VwRGk4ZYlkg3aHXeB0oinUyVkDTBq+d8ZIl
	 BWK8tRBnNNFynvi/y5D4txB7s5IcA6ClhUoK9M6VXZbkktEu0mVefZ/4vtRy6muP1O
	 Wa5kBXmhrNcyw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 2/2] scsi: libsas: terminate deferred commands on time out
Date: Thu, 16 Jul 2026 17:38:47 +0900
Message-ID: <20260716083847.926102-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716083847.926102-1-dlemoal@kernel.org>
References: <20260716083847.926102-1-dlemoal@kernel.org>
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
---
 drivers/ata/libata-scsi.c           |  4 ++--
 drivers/scsi/libsas/sas_scsi_host.c | 15 +++++++++++++++
 include/linux/libata.h              |  1 +
 include/scsi/libsas.h               |  2 ++
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1870669b8e05..878527cc2b0e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1708,8 +1708,7 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
 		queue_work(system_highpri_wq, &link->deferred_qc_work);
 }
 
-static void ata_scsi_retry_deferred_qc(struct ata_port *ap,
-				       struct scsi_cmnd *scmd)
+void ata_scsi_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 
@@ -1717,6 +1716,7 @@ static void ata_scsi_retry_deferred_qc(struct ata_port *ap,
 	ata_eh_retry_deferred_qc(ap, scmd);
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
index 51178acd68d7..18f76c3db4a4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1153,6 +1153,7 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
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

