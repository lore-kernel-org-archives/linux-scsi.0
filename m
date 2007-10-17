From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 28/32] scsi_data_buffer - scsi_error.c
Date: Wed, 17 Oct 2007 20:23:21 +0200
Message-ID: <47165319.8010302@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8820 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756852AbXJQSYN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 14:24:13 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


 - Changed needed members of struct scsi_eh_save.
 - Careful considerations in scsi_eh_prep/restore_cmnd.

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_error.c |   28 ++++++++++------------------
 include/scsi/scsi_eh.h    |    6 +-----
 2 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d29f846..c07b2a0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -618,29 +618,25 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->cmd_len = scmd->cmd_len;
 	memcpy(ses->cmnd, scmd->cmnd, sizeof(scmd->cmnd));
 	ses->data_direction = scmd->sc_data_direction;
-	ses->bufflen = scmd->request_bufflen;
-	ses->buffer = scmd->request_buffer;
-	ses->use_sg = scmd->use_sg;
-	ses->resid = scmd->resid;
+	ses->sdb = scmd->sdb;
 	ses->result = scmd->result;
 
+	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
+
 	if (sense_bytes) {
-		scmd->request_bufflen = min_t(unsigned,
+		scmd->sdb.length = min_t(unsigned,
 		                       sizeof(scmd->sense_buffer), sense_bytes);
 		sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
-		                                       scmd->request_bufflen);
-		scmd->request_buffer = &ses->sense_sgl;
+		                                       scmd->sdb.length);
+		scmd->sdb.sglist = &ses->sense_sgl;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
-		scmd->use_sg = 1;
+		scmd->sdb.sg_count = 1;
 		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 		scmd->cmnd[0] = REQUEST_SENSE;
-		scmd->cmnd[4] = scmd->request_bufflen;
+		scmd->cmnd[4] = scmd->sdb.length;
 		scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 	} else {
-		scmd->request_buffer = NULL;
-		scmd->request_bufflen = 0;
 		scmd->sc_data_direction = DMA_NONE;
-		scmd->use_sg = 0;
 		if (cmnd) {
 			memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 			memcpy(scmd->cmnd, cmnd, cmnd_size);
@@ -677,10 +673,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->cmd_len = ses->cmd_len;
 	memcpy(scmd->cmnd, ses->cmnd, sizeof(scmd->cmnd));
 	scmd->sc_data_direction = ses->data_direction;
-	scmd->request_bufflen = ses->bufflen;
-	scmd->request_buffer = ses->buffer;
-	scmd->use_sg = ses->use_sg;
-	scmd->resid = ses->resid;
+	scmd->sdb = ses->sdb;
 	scmd->result = ses->result;
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
@@ -1700,8 +1693,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
     
 	scmd->scsi_done		= scsi_reset_provider_done_command;
-	scmd->request_buffer		= NULL;
-	scmd->request_bufflen		= 0;
+	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 
 	scmd->cmd_len			= 0;
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 44224ba..17b4b19 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -71,11 +71,7 @@ struct scsi_eh_save {
 	unsigned char cmd_len;
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 
-	void *buffer;
-	unsigned bufflen;
-	unsigned short use_sg;
-	int resid;
-
+	struct scsi_data_buffer sdb;
 	struct scatterlist sense_sgl;
 };
 
-- 
1.5.3.1


