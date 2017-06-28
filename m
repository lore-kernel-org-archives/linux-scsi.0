From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 21/28] aha152x: drop bus reset
Date: Wed, 28 Jun 2017 10:25:09 +0200
Message-ID: <1498638316-44420-22-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53001 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751531AbdF1IbJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:09 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

From: Hannes Reinecke <hare@suse.com>

The bus reset function is a subset of host reset, but will always
return SUCCESS. But as the host reset also invokes a reset for
all ports there is a possibility that the bus reset will not be
able to fully reset the HBA, leading to a blocked system.
So drop bus reset completely.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aha152x.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index ce5dc73..21e9d7c 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1165,15 +1165,6 @@ static int aha152x_bus_reset_host(struct Scsi_Host *shpnt)
 }
 
 /*
- * Reset the bus
- *
- */
-static int aha152x_bus_reset(Scsi_Cmnd *SCpnt)
-{
-	return aha152x_bus_reset_host(SCpnt->device->host);
-}
-
-/*
  *  Restore default values to the AIC-6260 registers and reset the fifos
  *
  */
@@ -2916,7 +2907,6 @@ static int aha152x_adjust_queue(struct scsi_device *device)
 	.queuecommand			= aha152x_queue,
 	.eh_abort_handler		= aha152x_abort,
 	.eh_device_reset_handler	= aha152x_device_reset,
-	.eh_bus_reset_handler		= aha152x_bus_reset,
 	.eh_host_reset_handler		= aha152x_host_reset,
 	.bios_param			= aha152x_biosparam,
 	.can_queue			= 1,
-- 
1.8.5.6
