From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/3] scsi_lib: Remove that __scsi_release_buffers contraption
Date: Mon, 08 Nov 2010 17:11:49 +0200
Message-ID: <4CD81335.8020201@panasas.com>
References: <4CD810FA.902@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:58288 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754837Ab0KHPLx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 10:11:53 -0500
In-Reply-To: <4CD810FA.902@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


Remove "do_bidi_check" by checking and nullifying cmd->request
when blk_end_* indicates the request is no longer valid.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c |   41 +++++++++++++++++------------------------
 1 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c886754..db3bb7f 100644
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
1.7.2.3


