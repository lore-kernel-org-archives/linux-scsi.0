Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DDCE573;
	Fri, 10 Jul 2026 00:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783642021; cv=none; b=e6jEYLOgdlLVeNbh0i7XJ5eJMqtd4gnNrUV1hpgy30nwnXpxVlXSDmCmI5H/U1or1P+Dy+3oe39nPnrf0yeGYJOKOuPlY0/a2aENfclXNTfyU1tgL40lfEKP0rbDzEgBw5FdlIvpyMrvFB1GAEYlmLRhePIkbGwThvKsrqc5G+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783642021; c=relaxed/simple;
	bh=IPJz7ITQzPcZuNH/woq2sgd6amjLPCNCejtCSv36SEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5Px74ZWNlVCVLMc+i5IVafhPoqPxHbpaEXPTCKxdLD74YM/XOemlaglsnGTe0so0awWEArzjSrebfr8Jcvc00goM4LXW3n3AbuZ69cvIYUroE80o0alzXWAorXj0D/Nepxm+o/BIpH0BRoCPgG340sLKGGYta0pxDIJFOgc6oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dyx4jKhT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dyx4jKhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BFF1F00A3D;
	Fri, 10 Jul 2026 00:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783642020;
	bh=0VkhkwkbfjRIfVW8gV44wk0txDoUZkGrb1K4leULJr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dyx4jKhT7QwkDzVghCZkZRTTTei2rilqZM6NUFCOShVqYxm8AGn3Mn5jLp24fqJ8X
	 DKyl6hWDAcoEsy8U5R7X+xyFvW3qYt/nEqrKUeV7x0RzHE0tjhjTVdMUcWph/VJ0Wz
	 zdNV8J2esRcal78eCHuvJEd8dH5E7No8e6U1dFCNw0YYVPzPwM+yKw4gZlbH6NyAFT
	 jmSIxkNNlcFOB8+Gq22vNA4/RwnfXN1Mi2Gs5Iu5po3eNxDHfmfCkUqVBmkbynxLc8
	 sR5C+/rC1IS0kskRaxfEgwpwNUrFkCwJo9KIcLc3j6u1uBMZXk9/oDUuUM2g8P8HiE
	 w8LegrtSaNMVA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 2/2] scsi: libsas: terminate deferred commands on time out
Date: Fri, 10 Jul 2026 09:06:46 +0900
Message-ID: <20260710000646.1202200-3-dlemoal@kernel.org>
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
waiting to be issued, the scsi EH task is never woken up as the waiting
deferred command is never issued nor completed, thus leaving this command
to always be counted as "busy" for the SCSI host. This results in the
scsi_error_handler() function test "shost->host_failed !=
scsi_host_busy(shost))" to always be true, keeping the SCSI EH task
sleeping. Eventually, when the deferred command also times out, the EH
task is woken up and the timeout processing starts.

Avoid this unnecessary additional EH trigger wait time with the same
method as implemented in libata-scsi, using the eh_timed_out SCSI host
template operation. The function sas_eh_timed_out() implements this
operation and executes the helper function ata_scsi_port_eh_timed_out()
if the device is a sata one.

Co-developed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c           |  5 +++--
 drivers/scsi/libsas/sas_scsi_host.c | 17 +++++++++++++++++
 include/linux/libata.h              |  2 ++
 include/scsi/libsas.h               |  2 ++
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b6e25aab01d5..78f19537119a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1734,8 +1734,8 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
 		queue_work(system_highpri_wq, &link->deferred_qc_work);
 }
 
-static enum scsi_timeout_action
-ata_scsi_port_eh_timed_out(struct ata_port *ap, struct scsi_cmnd *scmd)
+enum scsi_timeout_action ata_scsi_port_eh_timed_out(struct ata_port *ap,
+						    struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 
@@ -1757,6 +1757,7 @@ ata_scsi_port_eh_timed_out(struct ata_port *ap, struct scsi_cmnd *scmd)
 	 */
 	return SCSI_EH_NOT_HANDLED;
 }
+EXPORT_SYMBOL_GPL(ata_scsi_port_eh_timed_out);
 
 enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *scmd)
 {
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index c83282733ec4..578fa8fd70f0 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -502,6 +502,23 @@ int sas_eh_target_reset_handler(struct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL_GPL(sas_eh_target_reset_handler);
 
+/*
+ * Handle deferred QCs in case of a timeout.
+ * See ata_scsi_port_eh_timed_out() for details.
+ */
+enum scsi_timeout_action sas_eh_timed_out(struct scsi_cmnd *cmd)
+{
+	struct domain_device *dev = NULL;
+
+	if (cmd)
+		dev = cmd_to_domain_dev(cmd);
+	if (!dev || !dev_is_sata(dev))
+		return SCSI_EH_NOT_HANDLED;
+
+	return ata_scsi_port_eh_timed_out(dev->sata_dev.ap, cmd);
+}
+EXPORT_SYMBOL_GPL(sas_eh_timed_out);
+
 /* Try to reset a device */
 static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 327da43d7496..2958a2fa3da0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1153,6 +1153,8 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
 #endif
 extern enum scsi_qc_status ata_scsi_queuecmd(struct Scsi_Host *h,
 					     struct scsi_cmnd *cmd);
+enum scsi_timeout_action ata_scsi_port_eh_timed_out(struct ata_port *ap,
+						    struct scsi_cmnd *cmd);
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

