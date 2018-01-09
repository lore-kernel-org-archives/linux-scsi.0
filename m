From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] libsas: Disable asynchronous aborts for SATA devices
Date: Tue,  9 Jan 2018 16:43:52 +0100
Message-ID: <1515512632-115483-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933048AbeAIPn5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Jan 2018 10:43:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Yves-Alexis Perez <corsac@debian.org>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Handling CD-ROM devices from libsas is decidedly odd, as libata
relies on SCSI EH to be started to figure out that no medium is
present.
So we cannot do asynchronous aborts for SATA devices.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 6267272..6de9681 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -487,15 +487,28 @@ static int sas_queue_reset(struct domain_device *dev, int reset_type,
 
 int sas_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	int res;
+	int res = TMF_RESP_FUNC_FAILED;
 	struct sas_task *task = TO_SAS_TASK(cmd);
 	struct Scsi_Host *host = cmd->device->host;
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct sas_internal *i = to_sas_internal(host->transportt);
+	unsigned long flags;
 
 	if (!i->dft->lldd_abort_task)
 		return FAILED;
 
-	res = i->dft->lldd_abort_task(task);
+	spin_lock_irqsave(host->host_lock, flags);
+	/* We cannot do async aborts for SATA devices */
+	if (dev_is_sata(dev) && !host->host_eh_scheduled) {
+		spin_unlock_irqrestore(host->host_lock, flags);
+		return FAILED;
+	}
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	if (task)
+		res = i->dft->lldd_abort_task(task);
+	else
+		SAS_DPRINTK("no task to abort\n");
 	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE)
 		return SUCCESS;
 
-- 
1.8.5.6
