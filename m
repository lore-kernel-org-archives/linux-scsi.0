From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/28] qedf: drop bus reset handler
Date: Wed, 28 Jun 2017 10:25:07 +0200
Message-ID: <1498638316-44420-20-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53010 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751819AbdF1IbY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:24 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>, Chad Dupuis <chad.dupuis@cavium.com>

qedf has a host reset handler, but as the bus reset handler is
a stub always returning SUCCESS the host reset is never invoked.
So drop the bus reset handler.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 6149ea0..d48a13a 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -629,16 +629,6 @@ static int qedf_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	return qedf_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
 }
 
-static int qedf_eh_bus_reset(struct scsi_cmnd *sc_cmd)
-{
-	QEDF_ERR(NULL, "BUS RESET Issued...\n");
-	/*
-	 * Essentially a no-op but return SUCCESS to prevent
-	 * unnecessary escalation to the host reset handler.
-	 */
-	return SUCCESS;
-}
-
 void qedf_wait_for_upload(struct qedf_ctx *qedf)
 {
 	while (1) {
@@ -716,7 +706,6 @@ static int qedf_slave_configure(struct scsi_device *sdev)
 	.eh_abort_handler	= qedf_eh_abort,
 	.eh_device_reset_handler = qedf_eh_device_reset, /* lun reset */
 	.eh_target_reset_handler = qedf_eh_target_reset, /* target reset */
-	.eh_bus_reset_handler = qedf_eh_bus_reset,
 	.eh_host_reset_handler  = qedf_eh_host_reset,
 	.slave_configure	= qedf_slave_configure,
 	.dma_boundary = QED_HW_DMA_BOUNDARY,
-- 
1.8.5.6
