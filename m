From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 3/9] convert scsi_error.c to use scsi_data_buffer
Date: Fri, 7 Sep 2007 06:50:41 +0900
Message-ID: <20070906184111N.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:60593 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933117AbXIFVxn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 17:53:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp

From: Boaz Harrosh <bharrosh@panasas.com>

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_error.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 8a525ab..af39a39 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -614,13 +614,11 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	DECLARE_COMPLETION_ONSTACK(done);
 	unsigned long timeleft;
 	unsigned long flags;
-	struct scatterlist sgl;
 	unsigned char old_cmnd[MAX_COMMAND_SIZE];
 	enum dma_data_direction old_data_direction;
-	unsigned short old_use_sg;
 	unsigned char old_cmd_len;
-	unsigned old_bufflen;
-	void *old_buffer;
+	struct scsi_data_buffer old_sdb;
+	struct scatterlist sgl;
 	int rtn;
 
 	/*
@@ -630,12 +628,10 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	 * we will need to restore these values prior to running the actual
 	 * command.
 	 */
-	old_buffer = scmd->request_buffer;
-	old_bufflen = scmd->request_bufflen;
+	old_sdb = scmd->sdb;
 	memcpy(old_cmnd, scmd->cmnd, sizeof(scmd->cmnd));
 	old_data_direction = scmd->sc_data_direction;
 	old_cmd_len = scmd->cmd_len;
-	old_use_sg = scmd->use_sg;
 
 	memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 	memcpy(scmd->cmnd, cmnd, cmnd_size);
@@ -645,14 +641,13 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 			    sizeof(scmd->sense_buffer));
 
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
-		scmd->request_bufflen = sgl.length;
-		scmd->request_buffer = &sgl;
-		scmd->use_sg = 1;
+		scmd->sdb.sglist = &sgl;
+
+		scmd->sdb.length = sgl.length;
+		scmd->sdb.resid = 0;
+		scmd->sdb.sg_count = 1;
 	} else {
-		scmd->request_buffer = NULL;
-		scmd->request_bufflen = 0;
 		scmd->sc_data_direction = DMA_NONE;
-		scmd->use_sg = 0;
 	}
 
 	scmd->underflow = 0;
@@ -715,13 +710,12 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	/*
 	 * Restore original data
 	 */
-	scmd->request_buffer = old_buffer;
-	scmd->request_bufflen = old_bufflen;
+	scmd->sdb = old_sdb;
 	memcpy(scmd->cmnd, old_cmnd, sizeof(scmd->cmnd));
 	scmd->sc_data_direction = old_data_direction;
 	scmd->cmd_len = old_cmd_len;
-	scmd->use_sg = old_use_sg;
 	scmd->result = old_result;
+
 	return rtn;
 }
 
@@ -1672,8 +1666,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
     
 	scmd->scsi_done		= scsi_reset_provider_done_command;
 	scmd->done			= NULL;
-	scmd->request_buffer		= NULL;
-	scmd->request_bufflen		= 0;
+	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 
 	scmd->cmd_len			= 0;
 
-- 
1.5.2.4

