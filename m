From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] scsi: remove __scsi_release_buffers
Date: Wed, 26 Feb 2014 06:23:44 -0800
Message-ID: <20140226142344.GA14161@infradead.org>
References: <20140226142321.GA14126@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54184 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaBZOXp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Feb 2014 09:23:45 -0500
Content-Disposition: inline
In-Reply-To: <20140226142321.GA14126@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

We always do the bidi check now, so it can be folded into scsi_release_buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 51063ca..94e46ee 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -538,8 +538,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
-static void __scsi_release_buffers(struct scsi_cmnd *, int);
-
 static inline unsigned int scsi_sgtable_index(unsigned short nents)
 {
 	unsigned int index;
@@ -591,26 +589,6 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
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
@@ -630,7 +608,21 @@ static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
  */
 void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	__scsi_release_buffers(cmd, 1);
+	if (cmd->sdb.table.nents)
+		scsi_free_sgtable(&cmd->sdb);
+
+	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
+
+	if (scsi_bidi_cmnd(cmd)) {
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
1.7.10.4

