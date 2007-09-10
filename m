From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 5/5] arm: fas216 Use scsi_eh API for REQUEST_SENSE invocation
Date: Mon, 10 Sep 2007 17:29:22 +0300
Message-ID: <46E554C2.6020804@panasas.com>
References: <46E5508B.7030108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:22667 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755750AbXIJOcr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 10:32:47 -0400
In-Reply-To: <46E5508B.7030108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>


  - Use new scsi_eh_prep/restor_cmnd() for synchronous
    REQUEST_SENSE invocation.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/arm/fas216.c |    5 ++---
 drivers/scsi/arm/fas216.h |    3 +++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index fb5f202..d80702b 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2018,6 +2018,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 	 * the upper layers to process.  This would have been set
 	 * correctly by fas216_std_done.
 	 */
+	scsi_eh_restore_cmnd(SCpnt, &info->sesci);
 	SCpnt->scsi_done(SCpnt);
 }
 
@@ -2103,6 +2104,7 @@ request_sense:
 	if (SCpnt->cmnd[0] == REQUEST_SENSE)
 		goto done;
 
+	scsi_eh_prep_cmnd(SCpnt, &info->sesci, NULL, 0, 1);
 	fas216_log_target(info, LOG_CONNECT, SCpnt->device->id,
 			  "requesting sense");
 	memset(SCpnt->cmnd, 0, sizeof (SCpnt->cmnd));
@@ -2117,9 +2119,6 @@ request_sense:
 	SCpnt->SCp.phase = sizeof(SCpnt->sense_buffer);
 	SCpnt->SCp.Message = 0;
 	SCpnt->SCp.Status = 0;
-	SCpnt->request_bufflen = sizeof(SCpnt->sense_buffer);
-	SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	SCpnt->use_sg = 0;
 	SCpnt->tag = 0;
 	SCpnt->host_scribble = (void *)fas216_rq_sns_done;
 
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index 00e5f05..8449416 100644
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
+	struct scsi_eh_save_cmnd_info *sesci;		/* holds request sense restore info */
 	unsigned long		magic_end;
 } FAS216_Info;
 
-- 
1.5.3.1


