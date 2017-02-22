From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 1/5] libsas: allow async aborts
Date: Wed, 22 Feb 2017 17:07:26 +0100
Message-ID: <1487779650-1338-2-git-send-email-hare@suse.de>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58755 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754751AbdBVQHe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 11:07:34 -0500
In-Reply-To: <1487779650-1338-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org

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
