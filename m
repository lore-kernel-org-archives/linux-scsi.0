From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH ver2 2/5] scsi_error: Refactoring scsi_error to facilitate
 in synchronous REQUEST_SENSE
Date: Mon, 10 Sep 2007 22:35:25 +0300
Message-ID: <46E59C7D.4040701@panasas.com>
References: <46E59760.9020705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:3906 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761146AbXIJTfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 15:35:51 -0400
In-Reply-To: <46E59760.9020705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>


 - Drivers/transports that want to send a synchronous REQUEST_SENSE command
   as part of their .queuecommand sequence, have 2 new API's that facilitate
   in doing so and abstract them from scsi-ml internals.

   void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
	struct scsi_eh_save *sesci, unsigned char *cmnd,
	int cmnd_size, int copy_sense)

   Will hijack a command and prepare it for request sense if needed.
   And will save any later needed info into a scsi_eh_save structure.

   void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd,
	struct scsi_eh_save *sesci);

   Will undo any changes done to a command by above function. Making
   it ready for completion.

 - Re-factor scsi_send_eh_cmnd to use above APIs

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_error.c |  125 ++++++++++++++++++++++++++-------------------
 include/scsi/scsi_eh.h    |   23 ++++++++-
 2 files changed, 95 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 20a72aa..a02400c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -590,42 +590,23 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 }
 
 /**
- * scsi_send_eh_cmnd  - submit a scsi command as part of error recory
+ * scsi_eh_prep_cmnd  - Save a scsi command info as part of error recory
  * @scmd:       SCSI command structure to hijack
- * @cmnd:       CDB to send
+ * @ses:        structure to save restore information
+ * @cmnd:       CDB to send. Can be NULL if no new cmnd is needed
  * @cmnd_size:  size in bytes of @cmnd
- * @timeout:    timeout for this request
- * @copy_sense: request sense data if set to 1
+ * @copy_sense: size of sense data to copy. or 0
  *
- * This function is used to send a scsi command down to a target device
- * as part of the error recovery process.  If @copy_sense is 0 the command
- * sent must be one that does not transfer any data.  If @copy_sense is 1
- * the command must be REQUEST_SENSE and this functions copies out the
- * sense buffer it got into @scmd->sense_buffer.
- *
- * Return value:
- *    SUCCESS or FAILED or NEEDS_RETRY
+ * This function is used to save a scsi command information before re-execution
+ * as part of an error recovery process.  If @copy_sense is 0 the command
+ * given must be one that does not transfer any data.  If @copy_sense != 0
+ * the command should be NULL and this functions sets up the cmnd and
+ * command buffers to be read into @scmd->sense_buffer.
  **/
-static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
-			     int cmnd_size, int timeout, unsigned copy_sense)
+void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
+			unsigned char *cmnd, int cmnd_size, unsigned copy_sense)
 {
 	struct scsi_device *sdev = scmd->device;
-	struct Scsi_Host *shost = sdev->host;
-	DECLARE_COMPLETION_ONSTACK(done);
-	unsigned long timeleft;
-	unsigned long flags;
-
-	unsigned char old_cmd_len;
-	unsigned char old_cmnd[MAX_COMMAND_SIZE];
-	enum dma_data_direction old_data_direction;
-	unsigned old_bufflen;
-	void *old_buffer;
-	unsigned short old_use_sg;
-	int old_resid;
-	int old_result;
-
-	struct scatterlist sgl;
-	int rtn;
 
 	/*
 	 * We need saved copies of a number of fields - this is because
@@ -634,14 +615,14 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	 * we will need to restore these values prior to running the actual
 	 * command.
 	 */
-	old_cmd_len = scmd->cmd_len;
-	memcpy(old_cmnd, scmd->cmnd, sizeof(scmd->cmnd));
-	old_data_direction = scmd->sc_data_direction;
-	old_bufflen = scmd->request_bufflen;
-	old_buffer = scmd->request_buffer;
-	old_use_sg = scmd->use_sg;
-	old_resid = scmd->resid;
-	old_result = scmd->result;
+	ses->cmd_len = scmd->cmd_len;
+	memcpy(ses->cmnd, scmd->cmnd, sizeof(scmd->cmnd));
+	ses->data_direction = scmd->sc_data_direction;
+	ses->bufflen = scmd->request_bufflen;
+	ses->buffer = scmd->request_buffer;
+	ses->use_sg = scmd->use_sg;
+	ses->resid = scmd->resid;
+	ses->result = scmd->result;
 
 	if (cmnd) {
 		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
@@ -650,9 +631,9 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	}
 
 	if (copy_sense) {
-		sg_init_one(&sgl, scmd->sense_buffer,
+		sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
 			    sizeof(scmd->sense_buffer));
-		scmd->request_buffer = &sgl;
+		scmd->request_buffer = &ses->sense_sgl;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
 		scmd->request_bufflen = min_t(unsigned,
 		                       sizeof(scmd->sense_buffer), copy_sense);
@@ -677,7 +658,58 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	if (sdev->scsi_level <= SCSI_2 && sdev->scsi_level != SCSI_UNKNOWN)
 		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
 			(sdev->lun << 5 & 0xe0);
+}
+EXPORT_SYMBOL(scsi_eh_prep_cmnd);
+
+/**
+ * scsi_eh_restore_cmnd  - Restore a scsi command info as part of error recory
+ * @scmd:       SCSI command structure to restore
+ * @ses:        saved information from a coresponding call to scsi_prep_eh_cmnd
+ *
+ * Undo any damage done by above scsi_prep_eh_cmnd().
+ **/
+void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
+{
+	/*
+	 * Restore original data
+	 */
+	scmd->cmd_len = ses->cmd_len;
+	memcpy(scmd->cmnd, ses->cmnd, sizeof(scmd->cmnd));
+	scmd->sc_data_direction = ses->data_direction;
+	scmd->request_bufflen = ses->bufflen;
+	scmd->request_buffer = ses->buffer;
+	scmd->use_sg = ses->use_sg;
+	scmd->resid = ses->resid;
+	scmd->result = ses->result;
+}
+EXPORT_SYMBOL(scsi_eh_restore_cmnd);
 
+/**
+ * scsi_send_eh_cmnd  - submit a scsi command as part of error recory
+ * @scmd:       SCSI command structure to hijack
+ * @cmnd:       CDB to send
+ * @cmnd_size:  size in bytes of @cmnd
+ * @timeout:    timeout for this request
+ * @copy_sense: size of sense data to copy or 0
+ *
+ * This function is used to send a scsi command down to a target device
+ * as part of the error recovery process. See also scsi_eh_prep_cmnd() above.
+ *
+ * Return value:
+ *    SUCCESS or FAILED or NEEDS_RETRY
+ **/
+static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
+			     int cmnd_size, int timeout, unsigned copy_sense)
+{
+	struct scsi_device *sdev = scmd->device;
+	struct Scsi_Host *shost = sdev->host;
+	DECLARE_COMPLETION_ONSTACK(done);
+	unsigned long timeleft;
+	unsigned long flags;
+	struct scsi_eh_save ses;
+	int rtn;
+
+	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, copy_sense);
 	shost->eh_action = &done;
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -721,18 +753,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 		rtn = FAILED;
 	}
 
-
-	/*
-	 * Restore original data
-	 */
-	scmd->cmd_len = old_cmd_len;
-	memcpy(scmd->cmnd, old_cmnd, sizeof(scmd->cmnd));
-	scmd->sc_data_direction = old_data_direction;
-	scmd->request_bufflen = old_bufflen;
-	scmd->request_buffer = old_buffer;
-	scmd->use_sg = old_use_sg;
-	scmd->resid = old_resid;
-	scmd->result = old_result;
+	scsi_eh_restore_cmnd(scmd, &ses);
 	return rtn;
 }
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index c5c0f67..85b0447 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -1,7 +1,7 @@
 #ifndef _SCSI_SCSI_EH_H
 #define _SCSI_SCSI_EH_H
 
-struct scsi_cmnd;
+#include <scsi/scsi_cmnd.h>
 struct scsi_device;
 struct Scsi_Host;
 
@@ -65,4 +65,25 @@ extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 
 extern int scsi_reset_provider(struct scsi_device *, int);
 
+struct scsi_eh_save {
+	int result;
+	enum dma_data_direction data_direction;
+	unsigned char cmd_len;
+	unsigned char cmnd[MAX_COMMAND_SIZE];
+
+	void *buffer;
+	unsigned bufflen;
+	unsigned short use_sg;
+	int resid;
+
+	struct scatterlist sense_sgl;
+};
+
+extern void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
+		struct scsi_eh_save *ses, unsigned char *cmnd,
+		int cmnd_size, unsigned copy_sense);
+
+extern void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd,
+		struct scsi_eh_save *ses);
+
 #endif /* _SCSI_SCSI_EH_H */
-- 
1.5.3.1


