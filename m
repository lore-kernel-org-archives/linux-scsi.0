From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] use the cmd_type of a leading request for scsi_init_sgtable
Date: Sat, 26 Jan 2008 09:57:38 +0900
Message-ID: <20080126095738U.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:53189 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbYAZA6S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jan 2008 19:58:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, bharrosh@panasas.com, pw@osc.edu, fujita.tomonori@lab.ntt.co.jp

This is against the scsi-bidi tree.

We need to use the cmd_type of a leading request for scsi_init_sgtable
to set up scsi_data_buffer:length of a bidi request properly.

An alternative approach is setting the cmd_type of a leading request
and its bidi request (*1). But the block layer and scsi-ml don't
expect that the leading request and its sub-requests have the
different command types.

Note that scsi_debug's XDWRITEREAD_10 support is fine without this
patch since req->nr_sectors works for it but req->nr_sectors doesn't
work for everyone.

(*1)

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12669.html

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] use the cmd_type of a leading request for scsi_init_sgtable

We need to use the cmd_type of a leading request for scsi_init_sgtable
to set up scsi_data_buffer:length of its bidi request properly.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e1c7eeb..61093ea 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1001,8 +1001,9 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	scsi_end_request(cmd, -EIO, this_count, !result);
 }
 
-static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
-			     gfp_t gfp_mask)
+static int scsi_init_sgtable(struct request *req,
+			     enum rq_cmd_type_bits cmd_type,
+			     struct scsi_data_buffer *sdb, gfp_t gfp_mask)
 {
 	int count;
 
@@ -1015,12 +1016,12 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 	}
 
 	req->buffer = NULL;
-	if (blk_pc_request(req))
+	if (cmd_type == REQ_TYPE_BLOCK_PC)
 		sdb->length = req->data_len;
 	else
 		sdb->length = req->nr_sectors << 9;
 
-	/* 
+	/*
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
@@ -1043,21 +1044,25 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
  */
 int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
-	int error = scsi_init_sgtable(cmd->request, &cmd->sdb, gfp_mask);
+	int error;
+	enum rq_cmd_type_bits cmd_type = cmd->request->cmd_type;
+
+	error = scsi_init_sgtable(cmd->request, cmd_type, &cmd->sdb, gfp_mask);
 	if (error)
 		goto err_exit;
 
 	if (blk_bidi_rq(cmd->request)) {
-		struct scsi_data_buffer *bidi_sdb = kmem_cache_zalloc(
-			scsi_bidi_sdb_cache, GFP_ATOMIC);
+		struct scsi_data_buffer *bidi_sdb;
+
+		bidi_sdb = kmem_cache_zalloc(scsi_bidi_sdb_cache, GFP_ATOMIC);
 		if (!bidi_sdb) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
 		}
 
 		cmd->request->next_rq->special = bidi_sdb;
-		error = scsi_init_sgtable(cmd->request->next_rq, bidi_sdb,
-								    GFP_ATOMIC);
+		error = scsi_init_sgtable(cmd->request->next_rq, cmd_type,
+					  bidi_sdb, GFP_ATOMIC);
 		if (error)
 			goto err_exit;
 	}
-- 
1.5.3.4

