From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH ver2 5/5] arm: fas216 Use scsi_eh API for REQUEST_SENSE invocation
Date: Mon, 10 Sep 2007 22:39:11 +0300
Message-ID: <46E59D5F.5060500@panasas.com>
References: <46E59760.9020705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26737 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932626AbXIJTje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 15:39:34 -0400
In-Reply-To: <46E59760.9020705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>


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
index 00e5f05..c39882e 100644
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


