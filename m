From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 8/8] Remove compatibility with unconverted drivers
Date: Thu, 05 Jul 2007 16:44:11 +0300
Message-ID: <468CF5AB.5090200@panasas.com>
References: <468CDB3C.4060500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27118 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758018AbXGENoc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 09:44:32 -0400
In-Reply-To: <468CDB3C.4060500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>


   Old IO members are removed from struct scsi_cmnd

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_error.c |   10 ----------
 drivers/scsi/scsi_lib.c   |   11 -----------
 include/scsi/scsi_cmnd.h  |    5 -----
 3 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1105011..936dfd1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -654,11 +654,6 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 		scmd->sgtable = NULL;
 	}
 
-	/*FIXME: make code backward compatible with old system */
-	cmd->request_buffer = scsi_sglist(scmd);
-	cmd->request_bufflen = scsi_bufflen(scmd);
-	cmd->use_sg = scsi_sg_count(scmd);
-
 	scmd->underflow = 0;
 	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 
@@ -725,11 +720,6 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	scmd->cmd_len = old_cmd_len;
 	scmd->result = old_result;
 
-	/*FIXME: make code backward compatible with old system */
-	cmd->request_buffer = scsi_sglist(scmd);
-	cmd->request_bufflen = scsi_bufflen(scmd);
-	cmd->use_sg = scsi_sg_count(scmd);
-
 	return rtn;
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 56829bf..dcd8826 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -756,11 +756,6 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 		_scsi_free_sgtable(cmd->sgtable);
 
 	cmd->sgtable = NULL;
-
-	/*FIXME: make code backward compatible with old system */
-	cmd->request_buffer = NULL;
-	cmd->request_bufflen = 0;
-	cmd->use_sg = 0;
 }
 
 /*
@@ -994,12 +989,6 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	count = blk_rq_map_sg(req->q, req, sgt->sglist);
 	if (likely(count <= sgt->sg_count)) {
 		sgt->sg_count = count;
-		
-		/*FIXME: make code backward compatible with old system */
-		cmd->request_buffer = sgt->sglist;
-		cmd->request_bufflen = sgt->length;
-		cmd->use_sg = sgt->sg_count;
-
 		return BLKPREP_OK;
 	}
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 4b87c0f..c13d47f 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -119,11 +119,6 @@ struct scsi_cmnd {
 
 	unsigned char tag;	/* SCSI-II queued command tag */
 	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
-
-	unsigned short __deprecated use_sg;
-	unsigned __deprecated request_bufflen;
-	void __deprecated *request_buffer;
-	int __deprecated resid;
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
-- 
1.5.2.2.249.g45fd


