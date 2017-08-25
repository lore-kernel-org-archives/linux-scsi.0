From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 21/26] aha152x: drop host reset
Date: Fri, 25 Aug 2017 13:57:16 +0200
Message-ID: <1503662241-127788-22-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49649 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756520AbdHYL6E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:58:04 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

From: Hannes Reinecke <hare@suse.com>

The driver has both a bus and a host reset, where the host reset
does a bus reset followed by an attempt to reset the chip registes
to a default state.
However, as the bus reset always returned SUCCESS the host reset
was never called, so the functionality of the register reset function
was never validated.
Additionally, tha AIC-6260 chip has a hard reset line, which
actually should be preferred for a host reset. But I
haven't found a way how this can be triggered via software,
so take the safe approach and drop the host reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aha152x.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index ce5dc73..bc0058d 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1140,6 +1140,9 @@ static void free_hard_reset_SCs(struct Scsi_Host *shpnt, Scsi_Cmnd **SCs)
 /*
  * Reset the bus
  *
+ * AIC-6260 has a hard reset (MRST signal), but apparently
+ * one cannot trigger it via software. So live with
+ * a soft reset; no-one seemed to have cared.
  */
 static int aha152x_bus_reset_host(struct Scsi_Host *shpnt)
 {
@@ -1223,15 +1226,6 @@ int aha152x_host_reset_host(struct Scsi_Host *shpnt)
 }
 
 /*
- * Reset the host (bus and controller)
- *
- */
-static int aha152x_host_reset(Scsi_Cmnd *SCpnt)
-{
-	return aha152x_host_reset_host(SCpnt->device->host);
-}
-
-/*
  * Return the "logical geometry"
  *
  */
@@ -2917,7 +2911,6 @@ static int aha152x_adjust_queue(struct scsi_device *device)
 	.eh_abort_handler		= aha152x_abort,
 	.eh_device_reset_handler	= aha152x_device_reset,
 	.eh_bus_reset_handler		= aha152x_bus_reset,
-	.eh_host_reset_handler		= aha152x_host_reset,
 	.bios_param			= aha152x_biosparam,
 	.can_queue			= 1,
 	.this_id			= 7,
-- 
1.8.5.6
