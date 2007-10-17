From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/32] arm: fas216 Use scsi_eh API for REQUEST_SENSE invocation
Date: Wed, 17 Oct 2007 19:19:25 +0200
Message-ID: <4716441D.4010505@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:18203 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765198AbXJQRUV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 13:20:21 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Jeff Garzik <jeff@garzik.org>, Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


  - Use new scsi_eh_prep/restor_cmnd() for synchronous
    REQUEST_SENSE invocation.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/arm/fas216.c |   16 +++-------------
 drivers/scsi/arm/fas216.h |    3 +++
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index fb5f202..a715632 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2018,6 +2018,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 	 * the upper layers to process.  This would have been set
 	 * correctly by fas216_std_done.
 	 */
+	scsi_eh_restore_cmnd(SCpnt, &info->ses);
 	SCpnt->scsi_done(SCpnt);
 }
 
@@ -2103,23 +2104,12 @@ request_sense:
 	if (SCpnt->cmnd[0] == REQUEST_SENSE)
 		goto done;
 
+	scsi_eh_prep_cmnd(SCpnt, &info->ses, NULL, 0, ~0);
 	fas216_log_target(info, LOG_CONNECT, SCpnt->device->id,
 			  "requesting sense");
-	memset(SCpnt->cmnd, 0, sizeof (SCpnt->cmnd));
-	SCpnt->cmnd[0] = REQUEST_SENSE;
-	SCpnt->cmnd[1] = SCpnt->device->lun << 5;
-	SCpnt->cmnd[4] = sizeof(SCpnt->sense_buffer);
-	SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
-	SCpnt->SCp.buffer = NULL;
-	SCpnt->SCp.buffers_residual = 0;
-	SCpnt->SCp.ptr = (char *)SCpnt->sense_buffer;
-	SCpnt->SCp.this_residual = sizeof(SCpnt->sense_buffer);
-	SCpnt->SCp.phase = sizeof(SCpnt->sense_buffer);
+	init_SCp(SCpnt);
 	SCpnt->SCp.Message = 0;
 	SCpnt->SCp.Status = 0;
-	SCpnt->request_bufflen = sizeof(SCpnt->sense_buffer);
-	SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	SCpnt->use_sg = 0;
 	SCpnt->tag = 0;
 	SCpnt->host_scribble = (void *)fas216_rq_sns_done;
 
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index 00e5f05..3e73e26 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -16,6 +16,8 @@
 #define NO_IRQ 255
 #endif
 
+#include <scsi/scsi_eh.h>
+
 #include "queue.h"
 #include "msgqueue.h"
 
@@ -311,6 +313,7 @@ typedef struct {
 
 	/* miscellaneous */
 	int			internal_done;		/* flag to indicate request done */
+	struct scsi_eh_save	*ses;		/* holds request sense restore info */
 	unsigned long		magic_end;
 } FAS216_Info;
 
-- 
1.5.3.1


