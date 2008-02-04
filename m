From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 9/24][RFC] ultrastor: Use scsi_eh_cpy_sense() API
Date: Mon,  4 Feb 2008 18:42:13 +0200
Message-ID: <1202143333-4863-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:60015 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbYBDQsC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 11:48:02 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - allocate a driver private area sense buffer, and set IO
    to transfer sense into that buffer.
  - at end of command execution copy the sense information
    using scsi_eh_cpy_sense().

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/ultrastor.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index f385dce..b2ccb48 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -199,6 +199,7 @@ struct mscp {
   void (*done) (struct scsi_cmnd *);
   struct scsi_cmnd *SCint;
   ultrastor_sg_list sglist[ULTRASTOR_24F_MAX_SG]; /* use larger size for 24F */
+  u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];
 };
 
 
@@ -743,19 +744,20 @@ static int ultrastor_queuecommand(struct scsi_cmnd *SCpnt,
     } else {
 	/* Unset scatter/gather flag in SCSI command packet */
 	my_mscp->sg = FALSE;
-	my_mscp->transfer_data = isa_virt_to_bus(scsi_sglist(SCpnt));
-	my_mscp->transfer_data_length = scsi_bufflen(SCpnt);
+	my_mscp->transfer_data = 0;
+	my_mscp->transfer_data_length = 0;
     }
     my_mscp->command_link = 0;		/*???*/
     my_mscp->scsi_command_link_id = 0;	/*???*/
-    my_mscp->length_of_sense_byte = SCSI_SENSE_BUFFERSIZE;
     my_mscp->length_of_scsi_cdbs = SCpnt->cmd_len;
     memcpy(my_mscp->scsi_cdbs, SCpnt->cmnd, my_mscp->length_of_scsi_cdbs);
     my_mscp->adapter_status = 0;
     my_mscp->target_status = 0;
-    my_mscp->sense_data = isa_virt_to_bus(&SCpnt->sense_buffer);
     my_mscp->done = done;
     my_mscp->SCint = SCpnt;
+    memset(my_mscp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+    my_mscp->length_of_sense_byte = SCSI_SENSE_BUFFERSIZE;
+    my_mscp->sense_data = isa_virt_to_bus(my_mscp->sense_buffer);
     SCpnt->host_scribble = (unsigned char *)my_mscp;
 
     /* Find free OGM slot.  On 24F, look for OGM status byte == 0.
@@ -1140,7 +1142,9 @@ static void ultrastor_interrupt(void *dev_id)
 	status = DID_TIME_OUT << 16;
 	break;
       }
-
+    if (mscp->sense_buffer[0])
+	scsi_eh_cpy_sense(SCtmp, mscp->sense_buffer,
+						sizeof(mscp->sense_buffer));
     SCtmp->result = status | mscp->target_status;
 
     SCtmp->host_scribble = NULL;
-- 
1.5.3.3

