From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] libsas: allow async aborts
Date: Mon, 24 Nov 2014 09:40:14 +0100
Message-ID: <1416818414-19430-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44803 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaKXIkX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2014 03:40:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, intel-linux-scu@intel.com

We now first try to call ->eh_abort_handler from a work queue, but libsas
was always failing that for no good reason.  Allow async aborts.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/libsas/sas_scsi_host.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 89e8b68..3ebdfaf 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -539,9 +539,6 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
 	struct Scsi_Host *host = cmd->device->host;
 	struct sas_internal *i = to_sas_internal(host->transportt);
 
-	if (current != host->ehandler)
-		return FAILED;
-
 	if (!i->dft->lldd_abort_task)
 		return FAILED;
 
-- 
1.9.1

