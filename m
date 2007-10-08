From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH ver5 1/5] scsi_error: code cleanup before refactoring of scsi_send_eh_cmnd()
Date: Mon, 08 Oct 2007 16:35:19 +0200
Message-ID: <470A4027.8070508@panasas.com>
References: <46E59760.9020705@panasas.com> <46E59C3E.1020703@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:29575 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751570AbXJHOfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Oct 2007 10:35:46 -0400
In-Reply-To: <46E59C3E.1020703@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>


  - regrouped variables for easier reviewing of next patch
  - Support of cmnd==NULL in call to scsi_send_eh_cmnd()
  - In the @sense_bytes case set transfer size to the minimum
    size of sense_buffer and passed @sense_bytes. cmnd[4] is
    set accordingly.
  - REQUEST_SENSE is set into cmnd[0] so if @sense_bytes is
    not Zero passed @cmnd should be NULL.
  - Also save/restore resid of failed command.
  - Adjust caller

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_error.c |   71 ++++++++++++++++++++++++--------------------
 1 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f49feb9..4d53501 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -592,36 +592,39 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 /**
  * scsi_send_eh_cmnd  - submit a scsi command as part of error recory
  * @scmd:       SCSI command structure to hijack
- * @cmnd:       CDB to send
+ * @cmnd:       CDB to send. Can be NULL if no new cmnd is needed
  * @cmnd_size:  size in bytes of @cmnd
  * @timeout:    timeout for this request
- * @copy_sense: request sense data if set to 1
+ * @sense_bytes: size of sense data to copy. or 0 (if != 0 @cmnd is ignored)
  *
  * This function is used to send a scsi command down to a target device
- * as part of the error recovery process.  If @copy_sense is 0 the command
- * sent must be one that does not transfer any data.  If @copy_sense is 1
- * the command must be REQUEST_SENSE and this functions copies out the
- * sense buffer it got into @scmd->sense_buffer.
+ * as part of the error recovery process.  If @sense_bytes is 0 the command
+ * sent must be one that does not transfer any data.  If @sense_bytes != 0
+ * @cmnd is ignored and this functions sets up a REQUEST_SENSE command
+ * and cmnd buffers to read @sense_bytes into @scmd->sense_buffer.
  *
  * Return value:
  *    SUCCESS or FAILED or NEEDS_RETRY
  **/
 static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
-			     int cmnd_size, int timeout, int copy_sense)
+			     int cmnd_size, int timeout, unsigned sense_bytes)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
-	int old_result = scmd->result;
 	DECLARE_COMPLETION_ONSTACK(done);
 	unsigned long timeleft;
 	unsigned long flags;
-	struct scatterlist sgl;
+
+	unsigned char old_cmd_len;
 	unsigned char old_cmnd[MAX_COMMAND_SIZE];
 	enum dma_data_direction old_data_direction;
-	unsigned short old_use_sg;
-	unsigned char old_cmd_len;
 	unsigned old_bufflen;
 	void *old_buffer;
+	unsigned short old_use_sg;
+	int old_resid;
+	int old_result;
+
+	struct scatterlist sgl;
 	int rtn;
 
 	/*
@@ -631,35 +634,41 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	 * we will need to restore these values prior to running the actual
 	 * command.
 	 */
-	old_buffer = scmd->request_buffer;
-	old_bufflen = scmd->request_bufflen;
+	old_cmd_len = scmd->cmd_len;
 	memcpy(old_cmnd, scmd->cmnd, sizeof(scmd->cmnd));
 	old_data_direction = scmd->sc_data_direction;
-	old_cmd_len = scmd->cmd_len;
+	old_bufflen = scmd->request_bufflen;
+	old_buffer = scmd->request_buffer;
 	old_use_sg = scmd->use_sg;
+	old_resid = scmd->resid;
+	old_result = scmd->result;
 
-	memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
-	memcpy(scmd->cmnd, cmnd, cmnd_size);
-
-	if (copy_sense) {
-		sg_init_one(&sgl, scmd->sense_buffer,
-			    sizeof(scmd->sense_buffer));
-
-		scmd->sc_data_direction = DMA_FROM_DEVICE;
-		scmd->request_bufflen = sgl.length;
+	if (sense_bytes) {
+		scmd->request_bufflen = min_t(unsigned,
+		                       sizeof(scmd->sense_buffer), sense_bytes);
+		sg_init_one(&sgl, scmd->sense_buffer, scmd->request_bufflen);
 		scmd->request_buffer = &sgl;
+		scmd->sc_data_direction = DMA_FROM_DEVICE;
 		scmd->use_sg = 1;
+		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
+		scmd->cmnd[0] = REQUEST_SENSE;
+		scmd->cmnd[4] = scmd->request_bufflen;
+		scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 	} else {
 		scmd->request_buffer = NULL;
 		scmd->request_bufflen = 0;
 		scmd->sc_data_direction = DMA_NONE;
 		scmd->use_sg = 0;
+		if (cmnd) {
+			memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
+			memcpy(scmd->cmnd, cmnd, cmnd_size);
+			scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
+		}
 	}
 
 	scmd->underflow = 0;
-	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 
-	if (sdev->scsi_level <= SCSI_2)
+	if (sdev->scsi_level <= SCSI_2 && sdev->scsi_level != SCSI_UNKNOWN)
 		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
 			(sdev->lun << 5 & 0xe0);
 
@@ -716,12 +725,13 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	/*
 	 * Restore original data
 	 */
-	scmd->request_buffer = old_buffer;
-	scmd->request_bufflen = old_bufflen;
+	scmd->cmd_len = old_cmd_len;
 	memcpy(scmd->cmnd, old_cmnd, sizeof(scmd->cmnd));
 	scmd->sc_data_direction = old_data_direction;
-	scmd->cmd_len = old_cmd_len;
+	scmd->request_bufflen = old_bufflen;
+	scmd->request_buffer = old_buffer;
 	scmd->use_sg = old_use_sg;
+	scmd->resid = old_resid;
 	scmd->result = old_result;
 	return rtn;
 }
@@ -737,10 +747,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
  **/
 static int scsi_request_sense(struct scsi_cmnd *scmd)
 {
-	static unsigned char generic_sense[6] =
-		{REQUEST_SENSE, 0, 0, 0, 252, 0};
-
-	return scsi_send_eh_cmnd(scmd, generic_sense, 6, SENSE_TIMEOUT, 1);
+	return scsi_send_eh_cmnd(scmd, NULL, 0, SENSE_TIMEOUT, ~0);
 }
 
 /**
-- 
1.5.3.1


