From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 4/8] libsas: allow async aborts
Date: Tue,  4 Apr 2017 16:02:57 +0200
Message-ID: <1491314581-73795-5-git-send-email-hare@suse.de>
References: <1491314581-73795-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34603 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753676AbdDDODJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Apr 2017 10:03:09 -0400
In-Reply-To: <1491314581-73795-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

We now first try to call ->eh_abort_handler from a work queue, but libsas
was always failing that for no good reason.  Allow async aborts.

Reviewed-by: Johannes Thumshirn <jth@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/libsas/sas_scsi_host.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 9bd55bc..ee6b39a 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -491,9 +491,6 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
 	struct Scsi_Host *host = cmd->device->host;
 	struct sas_internal *i = to_sas_internal(host->transportt);
 
-	if (current != host->ehandler)
-		return FAILED;
-
 	if (!i->dft->lldd_abort_task)
 		return FAILED;
 
-- 
1.8.5.6
