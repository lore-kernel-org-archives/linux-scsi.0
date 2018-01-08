From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] libsas: Check for completed commands before calling lldd_abort_task()
Date: Mon,  8 Jan 2018 13:04:46 +0100
Message-ID: <1515413086-34256-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56320 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756046AbeAHMEu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jan 2018 07:04:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Yves-Alexis Perez <corsac@debian.org>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The abort handler might be racing with command completion, so the
task might already be NULL by the time the abort handler is called.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 58476b7..08203fb 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -486,18 +486,34 @@ static int sas_queue_reset(struct domain_device *dev, int reset_type,
 
 int sas_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	int res;
-	struct sas_task *task = TO_SAS_TASK(cmd);
+	int res = TMF_RESP_FUNC_COMPLETE;
+	struct sas_task *task;
 	struct Scsi_Host *host = cmd->device->host;
 	struct sas_internal *i = to_sas_internal(host->transportt);
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
+	struct sas_ha_struct *ha = dev->port->ha;
+	unsigned long flags;
 
 	if (!i->dft->lldd_abort_task)
 		return FAILED;
 
-	res = i->dft->lldd_abort_task(task);
+	/* Avoid sas_scsi_task_done() interfering */
+	spin_lock_irqsave(&dev->done_lock, flags);
+	task = TO_SAS_TASK(cmd);
+	if (test_bit(SAS_HA_FROZEN, &ha->state)) {
+		res = TMF_RESP_FUNC_FAILED;
+		task = NULL;
+	} else
+		ASSIGN_SAS_TASK(cmd, NULL);
+	spin_unlock_irqrestore(&dev->done_lock, flags);
+	if (task)
+		res = i->dft->lldd_abort_task(task);
 	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE)
 		return SUCCESS;
 
+	spin_lock_irqsave(&dev->done_lock, flags);
+	ASSIGN_SAS_TASK(cmd, task);
+	spin_unlock_irqrestore(&dev->done_lock, flags);
 	return FAILED;
 }
 EXPORT_SYMBOL_GPL(sas_eh_abort_handler);
-- 
1.8.5.6
