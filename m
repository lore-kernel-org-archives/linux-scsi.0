From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] libsas: Check for completed commands before calling lldd_abort_task()
Date: Mon,  8 Jan 2018 11:51:56 +0100
Message-ID: <1515408716-102111-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51577 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756683AbeAHKv7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jan 2018 05:51:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Yves-Alexis Perez <corsac@debian.org>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The abort handler might be racing with command completion, so the
task might already be NULL by the time the abort handler is called.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 58476b7..ae2ae3c 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -486,7 +486,7 @@ static int sas_queue_reset(struct domain_device *dev, int reset_type,
 
 int sas_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	int res;
+	int res = TMF_RESP_FUNC_COMPLETE;
 	struct sas_task *task = TO_SAS_TASK(cmd);
 	struct Scsi_Host *host = cmd->device->host;
 	struct sas_internal *i = to_sas_internal(host->transportt);
@@ -494,7 +494,8 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
 	if (!i->dft->lldd_abort_task)
 		return FAILED;
 
-	res = i->dft->lldd_abort_task(task);
+	if (task)
+		res = i->dft->lldd_abort_task(task);
 	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE)
 		return SUCCESS;
 
-- 
1.8.5.6
