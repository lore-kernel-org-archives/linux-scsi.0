From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] scsi: Introduce REQ_SCSI_ERROR flag
Date: Fri, 20 Nov 2009 08:52:40 +0100
Message-ID: <20091120075240.1BB3F3A081@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZKTHwe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 02:52:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org


When evaluating req->errors we have to know which
subsystem generated them in order to process them correctly.
This patch introduces a REQ_SCSI_ERROR flag to indicate
that the errors field in the request contains a SCSI result.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e5a3884..ccba32d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1258,9 +1258,12 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (error == -EOPNOTSUPP)
 		return error;
 
-	r = eval_scsi_error(clone->errors, clone->sense, clone->sense_len);
-	if (r != DM_ENDIO_REQUEUE)
-		return r;
+	if (blk_rq_scsi_error(clone)) {
+		r = eval_scsi_error(clone->errors, clone->sense,
+				    clone->sense_len);
+		if (r != DM_ENDIO_REQUEUE)
+			return r;
+	}
 
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 10aa084..e878fc5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -723,6 +723,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	req->errors = result;
+	req->cmd_flags |= REQ_SCSI_ERROR;
+
 	if (sense_valid && req->sense) {
 		int len = 8 + cmd->sense_buffer[7];
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 221cecd..dbc3302 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -115,6 +115,7 @@ enum rq_flag_bits {
 	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
+	__REQ_SCSI_ERROR,	/* errors are SCSI result codes */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -144,6 +145,7 @@ enum rq_flag_bits {
 #define REQ_NOIDLE	(1 << __REQ_NOIDLE)
 #define REQ_IO_STAT	(1 << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE	(1 << __REQ_MIXED_MERGE)
+#define REQ_SCSI_ERROR	(1 << __REQ_SCSI_ERROR)
 
 #define REQ_FAILFAST_MASK	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | \
 				 REQ_FAILFAST_DRIVER)
@@ -606,6 +608,7 @@ enum {
 #define blk_rq_started(rq)	((rq)->cmd_flags & REQ_STARTED)
 #define blk_rq_io_stat(rq)	((rq)->cmd_flags & REQ_IO_STAT)
 #define blk_rq_quiet(rq)	((rq)->cmd_flags & REQ_QUIET)
+#define blk_rq_scsi_error(rq)	((rq)->cmd_flags & REQ_SCSI_ERROR)
 
 #define blk_account_rq(rq)	(blk_rq_started(rq) && (blk_fs_request(rq) || blk_discard_rq(rq))) 
 
