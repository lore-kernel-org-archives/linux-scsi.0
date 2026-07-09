Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DB63F4DCD;
	Thu,  9 Jul 2026 08:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783586393; cv=none; b=RJ2+XxVIi3p2pbznK2G69udo6R3InAuIhb/oAU1T9ayzq5l37iRG2rRMBokK+cAI628Svt1xwYwUX/uOAQCGTRNN7mw9Pj6Wa9f1fbbq7VcjH6mgpRPf+djCXMSpLoBs2TnvqOwTYKHZfk5wEregpOyiz8290vDCYH79W10KS88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783586393; c=relaxed/simple;
	bh=uTVcMBVSu6LF5k/GQw1+Qu1CLxI79nkt8Zp2r+9tfzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ/GIpXu8VvfcgdcSH8ZPceD9iwvwkYwEGqIlrlHcTdTwyGcfowaalRj5dDVVibsEB6aF8Ujrc8+dP3e9adpJqfc7NDd3cFhdMFiUSYS+Y3piXWC5oCF2sM9frRNKfkehkiJda8aA3JNh5DLw40ByiKuZMxoJsbFJDq4azehEaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dW/7DA5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dW/7DA5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED581F00A3E;
	Thu,  9 Jul 2026 08:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783586388;
	bh=tFcRuXbc9UDD40F9RM+gK2BusULWZIOsuSR9h6g8KKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dW/7DA5saTvItJCnGJAfMpqVlW/ZD58KQa0/YV2ypcKaztfdYnFggefiGaoZuKrLu
	 1Y0UGBZdAREcy4fJ9gC462hd7yY+AGisZcLLNoT3bTIY49uGS+tIl2ls4jKZOb83iY
	 +Eb1PLf52eqrTBG1BbuyUqPzPM6G/cbptuTb3b7VqwPeDTK3Gw5tz44A+fKN5JAukQ
	 BSRkDEghb4spZlnbQSdSM3TJl5Zim1mepwMOvTVF3KN1FS1m3sJi7FNva9Z4W/z2xW
	 AZ8LZ+MDhUIl9HVETlYCo7leYspPgAgt4fjFLY0nVOFhjQb0MdeL4TdHgXaonCscpz
	 DMK0lZ3jNW7gw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v1 2/2] scsi: libsas: terminate deferred commands on time out
Date: Thu,  9 Jul 2026 17:39:34 +0900
Message-ID: <20260709083934.1116862-3-dlemoal@kernel.org>
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

Avoid this unnecessary EH trigger wait time with the same method as
implemented in libata-scsi, using the eh_timed_out scsi host template
operation. The function sas_eh_timed_out() implements this operation and
executes the helper function ata_scsi_port_eh_timed_out() if the device
is a sata one.

Co-developed-by: Igor Pylypiv <ipylypiv@google.com>
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
index 8328778ec046..43762afa58ac 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1738,8 +1738,8 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
 		queue_work(system_highpri_wq, &link->deferred_qc_work);
 }
 
-static enum scsi_timeout_action
-ata_scsi_port_eh_timed_out(struct ata_port *ap, struct scsi_cmnd *scmd)
+enum scsi_timeout_action ata_scsi_port_eh_timed_out(struct ata_port *ap,
+						    struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 
@@ -1761,6 +1761,7 @@ ata_scsi_port_eh_timed_out(struct ata_port *ap, struct scsi_cmnd *scmd)
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

