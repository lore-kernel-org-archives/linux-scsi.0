From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/3] scsi_lib: Remove that __scsi_release_buffers contraption
Date: Mon, 04 Jan 2010 14:15:08 +0200
Message-ID: <4B41DBCC.5030101@panasas.com>
References: <4B41DADD.4000102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:23606 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752147Ab0ADMPL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 07:15:11 -0500
In-Reply-To: <4B41DADD.4000102@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.k>


Remove "do_bidi_check" by checking and nullifying cmd->request
when blk_end_* indicates the request is no longer valid.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |   41 +++++++++++++++++------------------------
 1 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 05f988a..8d8b4eb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -512,8 +512,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
-static void __scsi_release_buffers(struct scsi_cmnd *, int);
-
 /*
  * Function:    scsi_end_request()
  *
@@ -564,11 +562,12 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 		}
 	}
 
+	cmd->request = NULL;
 	/*
 	 * This will goose the queue request function at the end, so we don't
 	 * need to worry about launching another command.
 	 */
-	__scsi_release_buffers(cmd, 0);
+	scsi_release_buffers(cmd);
 	scsi_next_command(cmd);
 	return NULL;
 }
@@ -624,26 +623,6 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
 	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, scsi_sg_free);
 }
 
-static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
-{
-
-	if (cmd->sdb.table.nents)
-		scsi_free_sgtable(&cmd->sdb);
-
-	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
-
-	if (do_bidi_check && scsi_bidi_cmnd(cmd)) {
-		struct scsi_data_buffer *bidi_sdb =
-			cmd->request->next_rq->special;
-		scsi_free_sgtable(bidi_sdb);
-		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
-		cmd->request->next_rq->special = NULL;
-	}
-
-	if (scsi_prot_sg_count(cmd))
-		scsi_free_sgtable(cmd->prot_sdb);
-}
-
 /*
  * Function:    scsi_release_buffers()
  *
@@ -663,7 +642,21 @@ static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
  */
 void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	__scsi_release_buffers(cmd, 1);
+	if (cmd->sdb.table.nents)
+		scsi_free_sgtable(&cmd->sdb);
+
+	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
+
+	if (cmd->request && scsi_bidi_cmnd(cmd)) {
+		struct scsi_data_buffer *bidi_sdb =
+			cmd->request->next_rq->special;
+		scsi_free_sgtable(bidi_sdb);
+		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
+		cmd->request->next_rq->special = NULL;
+	}
+
+	if (scsi_prot_sg_count(cmd))
+		scsi_free_sgtable(cmd->prot_sdb);
 }
 EXPORT_SYMBOL(scsi_release_buffers);
 
-- 
1.6.6


