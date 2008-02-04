From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 7/24][RFC] qla2xxx: convert to new scsi_eh_cpy_sense API
Date: Mon,  4 Feb 2008 18:17:05 +0200
Message-ID: <1202141825-4767-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:36780 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYBDQW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 11:22:57 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  this driver is special in that it would read sense in parts
  until done. Same mechanics left here but read into a driver
  internal buffer, which is then scsi_eh_cpy_sense() into command
  when done.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    4 ++--
 drivers/scsi/qla2xxx/qla_isr.c |   17 +++++++----------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b72c7f1..c2109f6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -195,8 +195,9 @@ typedef struct srb {
 	/* Single transfer DMA context */
 	dma_addr_t dma_handle;
 
-	uint32_t request_sense_length;
+	uint16_t request_sense_length;
 	uint8_t *request_sense_ptr;
+	uint8_t sense_buffer[SCSI_SENSE_BUFFERSIZE];
 } srb_t;
 
 /*
@@ -2601,7 +2602,6 @@ typedef struct scsi_qla_host {
 #define CMD_COMPL_STATUS(Cmnd)  ((Cmnd)->SCp.this_residual)
 #define CMD_RESID_LEN(Cmnd)	((Cmnd)->SCp.buffers_residual)
 #define CMD_SCSI_STATUS(Cmnd)	((Cmnd)->SCp.Status)
-#define CMD_ACTUAL_SNSLEN(Cmnd)	((Cmnd)->SCp.Message)
 #define CMD_ENTRY_STATUS(Cmnd)	((Cmnd)->SCp.have_data_in)
 
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 642a0c3..611f556 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -8,6 +8,7 @@
 
 #include <linux/delay.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_eh.h>
 
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
 static void qla2x00_process_completed_request(struct scsi_qla_host *, uint32_t);
@@ -825,18 +826,15 @@ qla2x00_process_response_queue(struct scsi_qla_host *ha)
 static inline void
 qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
 {
-	struct scsi_cmnd *cp = sp->cmd;
-
 	if (sense_len >= SCSI_SENSE_BUFFERSIZE)
 		sense_len = SCSI_SENSE_BUFFERSIZE;
 
-	CMD_ACTUAL_SNSLEN(cp) = sense_len;
 	sp->request_sense_length = sense_len;
-	sp->request_sense_ptr = cp->sense_buffer;
-	if (sp->request_sense_length > 32)
+	sp->request_sense_ptr = sp->sense_buffer;
+	if (sense_len > 32)
 		sense_len = 32;
 
-	memcpy(cp->sense_buffer, sense_data, sense_len);
+	memcpy(sp->sense_buffer, sense_data, sense_len);
 
 	sp->request_sense_ptr += sense_len;
 	sp->request_sense_length -= sense_len;
@@ -847,8 +845,7 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t sense_len)
 	    "cmd=%p pid=%ld\n", __func__, sp->ha->host_no, cp->device->channel,
 	    cp->device->id, cp->device->lun, cp, cp->serial_number));
 	if (sense_len)
-		DEBUG5(qla2x00_dump_buffer(cp->sense_buffer,
-		    CMD_ACTUAL_SNSLEN(cp)));
+		DEBUG5(qla2x00_dump_buffer(cp->sense_buffer, sense_len));
 }
 
 /**
@@ -1005,7 +1002,6 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 		if (lscsi_status != SS_CHECK_CONDITION)
 			break;
 
-		memset(cp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		if (!(scsi_status & SS_SENSE_LEN_VALID))
 			break;
 
@@ -1064,7 +1060,6 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 			if (lscsi_status != SS_CHECK_CONDITION)
 				break;
 
-			memset(cp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 			if (!(scsi_status & SS_SENSE_LEN_VALID))
 				break;
 
@@ -1268,6 +1263,8 @@ qla2x00_status_cont_entry(scsi_qla_host_t *ha, sts_cont_entry_t *pkt)
 
 		/* Place command on done queue. */
 		if (sp->request_sense_length == 0) {
+			scsi_eh_cpy_sense(cp, sp->sense_buffer,
+				sp->request_sense_ptr - sp->sense_buffer);
 			ha->status_srb = NULL;
 			qla2x00_sp_compl(ha, sp);
 		}
-- 
1.5.3.3

