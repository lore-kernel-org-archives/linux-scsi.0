From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/5] usb: transport.c use scsi_eh API in REQUEST_SENSE execution
Date: Mon, 10 Sep 2007 17:25:00 +0300
Message-ID: <46E553BC.9020504@panasas.com>
References: <46E5508B.7030108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:22082 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759267AbXIJOZ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 10:25:29 -0400
In-Reply-To: <46E5508B.7030108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg
Cc: Christoph Hellwig <hch@infradead.org>


  - Use new scsi_eh_prep/restor_cmnd() for synchronous
    REQUEST_SENSE invocation.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/transport.c |   51 ++++++--------------------------------
 1 files changed, 8 insertions(+), 43 deletions(-)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 323293a..92dec34 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -50,7 +50,7 @@
 #include <linux/slab.h>
 
 #include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_device.h>
 
 #include "usb.h"
@@ -580,62 +580,27 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	/* Now, if we need to do the auto-sense, let's do it */
 	if (need_auto_sense) {
 		int temp_result;
-		void* old_request_buffer;
-		unsigned short old_sg;
-		unsigned old_request_bufflen;
-		unsigned char old_sc_data_direction;
-		unsigned char old_cmd_len;
-		unsigned char old_cmnd[MAX_COMMAND_SIZE];
-		int old_resid;
+		struct scsi_eh_save_cmnd_info sesci;
+		static unsigned char generic_sense[6] =
+			{REQUEST_SENSE, 0, 0, 0, 0, 0};
 
 		US_DEBUGP("Issuing auto-REQUEST_SENSE\n");
 
-		/* save the old command */
-		memcpy(old_cmnd, srb->cmnd, MAX_COMMAND_SIZE);
-		old_cmd_len = srb->cmd_len;
-
-		/* set the command and the LUN */
-		memset(srb->cmnd, 0, MAX_COMMAND_SIZE);
-		srb->cmnd[0] = REQUEST_SENSE;
-		srb->cmnd[1] = old_cmnd[1] & 0xE0;
-		srb->cmnd[4] = 18;
-
+		scsi_eh_prep_cmnd(srb, &sesci, generic_sense,
+			sizeof(generic_sense), 1);
+		
 		/* FIXME: we must do the protocol translation here */
 		if (us->subclass == US_SC_RBC || us->subclass == US_SC_SCSI)
 			srb->cmd_len = 6;
 		else
 			srb->cmd_len = 12;
 
-		/* set the transfer direction */
-		old_sc_data_direction = srb->sc_data_direction;
-		srb->sc_data_direction = DMA_FROM_DEVICE;
-
-		/* use the new buffer we have */
-		old_request_buffer = srb->request_buffer;
-		srb->request_buffer = us->sensebuf;
-
-		/* set the buffer length for transfer */
-		old_request_bufflen = srb->request_bufflen;
-		srb->request_bufflen = US_SENSE_SIZE;
-
-		/* set up for no scatter-gather use */
-		old_sg = srb->use_sg;
-		srb->use_sg = 0;
-
 		/* issue the auto-sense command */
-		old_resid = srb->resid;
 		srb->resid = 0;
 		temp_result = us->transport(us->srb, us);
 
 		/* let's clean up right away */
-		memcpy(srb->sense_buffer, us->sensebuf, US_SENSE_SIZE);
-		srb->resid = old_resid;
-		srb->request_buffer = old_request_buffer;
-		srb->request_bufflen = old_request_bufflen;
-		srb->use_sg = old_sg;
-		srb->sc_data_direction = old_sc_data_direction;
-		srb->cmd_len = old_cmd_len;
-		memcpy(srb->cmnd, old_cmnd, MAX_COMMAND_SIZE);
+		scsi_eh_restore_cmnd(srb, &sesci);
 
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->flags)) {
 			US_DEBUGP("-- auto-sense aborted\n");
-- 
1.5.3.1


