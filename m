From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH]scsi: BUG_ON() impossible condition.
Date: Mon, 19 Nov 2007 11:28:48 +1100
Message-ID: <200711191128.48340.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:57325 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbXKSA3L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Nov 2007 19:29:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

If blk_rq_map_sg wrote more than was allocated in the scatterlist,
BUG_ON() is probably the right thing to do.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi_tgt_lib.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1102,7 +1102,6 @@ void scsi_io_completion(struct scsi_cmnd
  *
  * Returns:     0 on success
  *		BLKPREP_DEFER if the failure is retryable
- *		BLKPREP_KILL if the failure is fatal
  */
 static int scsi_init_io(struct scsi_cmnd *cmd)
 {
@@ -1136,17 +1135,9 @@ static int scsi_init_io(struct scsi_cmnd
 	 * each segment.
 	 */
 	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
-		cmd->use_sg = count;
-		return BLKPREP_OK;
-	}
-
-	printk(KERN_ERR "Incorrect number of segments after building list\n");
-	printk(KERN_ERR "counted %d, received %d\n", count, cmd->use_sg);
-	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
-			req->current_nr_sectors);
-
-	return BLKPREP_KILL;
+	BUG_ON(count > cmd->use_sg);
+	cmd->use_sg = count;
+	return BLKPREP_OK;
 }
 
 static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -367,14 +367,9 @@ static int scsi_tgt_init_cmd(struct scsi
 
 	dprintk("cmd %p cnt %d %lu\n", cmd, cmd->use_sg, rq_data_dir(rq));
 	count = blk_rq_map_sg(rq->q, rq, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
-		cmd->use_sg = count;
-		return 0;
-	}
-
-	eprintk("cmd %p cnt %d\n", cmd, cmd->use_sg);
-	scsi_free_sgtable(cmd);
-	return -EINVAL;
+	BUG_ON(count > cmd->use_sg);
+	cmd->use_sg = count;
+	return 0;
 }
 
 /* TODO: test this crap and replace bio_map_user with new interface maybe */
