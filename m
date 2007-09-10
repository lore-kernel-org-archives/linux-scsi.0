From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH ver2 1/5] scsi_error: code cleanup before refactoring of scsi_send_eh_cmnd()
Date: Mon, 10 Sep 2007 22:34:22 +0300
Message-ID: <46E59C3E.1020703@panasas.com>
References: <46E59760.9020705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:28901 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757762AbXIJTes (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 15:34:48 -0400
In-Reply-To: <46E59760.9020705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>


  - regrouped variables for easier reviewing of next patch
  - Support of cmnd==NULL in call to scsi_send_eh_cmnd()
  - In the copy_sense case set transfer size to the minimum
    size of sense_buffer and passed copy_sense. cmnd[4] is
    set accordingly.
  - REQUEST_SENSE is set into cmnd[0] so if copy_sense is
    not Zero passed cmnd can/should be NULL.
  - Also save/restore resid of faild command.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_error.c |   63 +++++++++++++++++++++++++--------------------
 1 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c8e351f..20a72aa 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -607,21 +607,24 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
  *    SUCCESS or FAILED or NEEDS_RETRY
  **/
 static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
-			     int cmnd_size, int timeout, int copy_sense)
+			     int cmnd_size, int timeout, unsigned copy_sense)
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
@@ -631,24 +634,37 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
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
+	if (cmnd) {
+		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
+		memcpy(scmd->cmnd, cmnd, cmnd_size);
+		scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
+	}
 
 	if (copy_sense) {
 		sg_init_one(&sgl, scmd->sense_buffer,
 			    sizeof(scmd->sense_buffer));
-
-		scmd->sc_data_direction = DMA_FROM_DEVICE;
-		scmd->request_bufflen = sgl.length;
 		scmd->request_buffer = &sgl;
+		scmd->sc_data_direction = DMA_FROM_DEVICE;
+		scmd->request_bufflen = min_t(unsigned,
+		                       sizeof(scmd->sense_buffer), copy_sense);
 		scmd->use_sg = 1;
+		memset(scmd->cmnd, 0, 6);
+		scmd->cmnd[0] = REQUEST_SENSE;
+		scmd->cmnd[4] = scmd->request_bufflen;
+		/*
+		 * Zero the sense buffer.  The scsi spec mandates that any
+		 * untransferred sense data should be interpreted as being zero.
+		 */
+		memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
 	} else {
 		scmd->request_buffer = NULL;
 		scmd->request_bufflen = 0;
@@ -657,18 +673,11 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	}
 
 	scmd->underflow = 0;
-	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 
-	if (sdev->scsi_level <= SCSI_2)
+	if (sdev->scsi_level <= SCSI_2 && sdev->scsi_level != SCSI_UNKNOWN)
 		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
 			(sdev->lun << 5 & 0xe0);
 
-	/*
-	 * Zero the sense buffer.  The scsi spec mandates that any
-	 * untransferred sense data should be interpreted as being zero.
-	 */
-	memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
-
 	shost->eh_action = &done;
 
 	spin_lock_irqsave(shost->host_lock, flags);
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


