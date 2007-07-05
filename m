From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 6/8] scsi_error.c move to scsi_sgtable implementation
Date: Thu, 05 Jul 2007 16:43:57 +0300
Message-ID: <468CF59D.7050608@panasas.com>
References: <468CDB3C.4060500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27101 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757612AbXGENoR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 09:44:17 -0400
In-Reply-To: <468CDB3C.4060500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>


 - Careful considerations in scsi_send_eh_cmnd. Everything
   is kept on the stack as before.
 - This code is backward compatible with unconverted drivers.
   Compatibility will be removed in last patch.

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_error.c |   46 ++++++++++++++++++++++++++------------------
 1 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9adb64a..1105011 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -613,13 +613,10 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
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
+	struct scsi_sgtable *old_sgtable;
 	int rtn;
 
 	/*
@@ -629,31 +626,39 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	 * we will need to restore these values prior to running the actual
 	 * command.
 	 */
-	old_buffer = scmd->request_buffer;
-	old_bufflen = scmd->request_bufflen;
+	old_sgtable = scmd->sgtable;
 	memcpy(old_cmnd, scmd->cmnd, sizeof(scmd->cmnd));
 	old_data_direction = scmd->sc_data_direction;
 	old_cmd_len = scmd->cmd_len;
-	old_use_sg = scmd->use_sg;
 
 	memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
 	memcpy(scmd->cmnd, cmnd, cmnd_size);
 
 	if (copy_sense) {
-		sg_init_one(&sgl, scmd->sense_buffer,
+		struct {
+			struct scsi_sgtable sgtable;
+			struct scatterlist sgl;
+		} new_sgtable;
+
+		sg_init_one(new_sgtable.sgtable.sglist, scmd->sense_buffer,
 			    sizeof(scmd->sense_buffer));
 
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
-		scmd->request_bufflen = sgl.length;
-		scmd->request_buffer = &sgl;
-		scmd->use_sg = 1;
+		new_sgtable.sgtable.length = new_sgtable.sgtable.sglist[0].length;
+		new_sgtable.sgtable.resid = 0;
+		new_sgtable.sgtable.sg_count = 1;
+		new_sgtable.sgtable.sg_pool = -1;	/* invalid */
+		scmd->sgtable = &new_sgtable.sgtable;
 	} else {
-		scmd->request_buffer = NULL;
-		scmd->request_bufflen = 0;
 		scmd->sc_data_direction = DMA_NONE;
-		scmd->use_sg = 0;
+		scmd->sgtable = NULL;
 	}
 
+	/*FIXME: make code backward compatible with old system */
+	cmd->request_buffer = scsi_sglist(scmd);
+	cmd->request_bufflen = scsi_bufflen(scmd);
+	cmd->use_sg = scsi_sg_count(scmd);
+
 	scmd->underflow = 0;
 	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 
@@ -714,13 +719,17 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	/*
 	 * Restore original data
 	 */
-	scmd->request_buffer = old_buffer;
-	scmd->request_bufflen = old_bufflen;
+	scmd->sgtable = old_sgtable;
 	memcpy(scmd->cmnd, old_cmnd, sizeof(scmd->cmnd));
 	scmd->sc_data_direction = old_data_direction;
 	scmd->cmd_len = old_cmd_len;
-	scmd->use_sg = old_use_sg;
 	scmd->result = old_result;
+
+	/*FIXME: make code backward compatible with old system */
+	cmd->request_buffer = scsi_sglist(scmd);
+	cmd->request_bufflen = scsi_bufflen(scmd);
+	cmd->use_sg = scsi_sg_count(scmd);
+
 	return rtn;
 }
 
@@ -1673,8 +1682,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
     
 	scmd->scsi_done		= scsi_reset_provider_done_command;
 	scmd->done			= NULL;
-	scmd->request_buffer		= NULL;
-	scmd->request_bufflen		= 0;
+	scmd->sgtable			= NULL;
 
 	scmd->cmd_len			= 0;
 
-- 
1.5.2.2.249.g45fd


