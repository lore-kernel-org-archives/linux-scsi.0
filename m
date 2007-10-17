From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 30/32] tgt: convert to use scsi_data_buffer
Date: Wed, 17 Oct 2007 20:28:59 +0200
Message-ID: <4716546B.5020105@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:15287 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753926AbXJQS3k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 14:29:40 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>

From: FUJITA Tomonori <tomof@acm.org>

Signed-off-by: FUJITA Tomonori <tomof@acm.org>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_tgt_if.c  |    2 +-
 drivers/scsi/scsi_tgt_lib.c |   43 ++++++++++++-------------------------------
 2 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index 9815a1a..d2557db 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -112,7 +112,7 @@ int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, u64 itn_id,
 	memset(&ev, 0, sizeof(ev));
 	ev.p.cmd_req.host_no = shost->host_no;
 	ev.p.cmd_req.itn_id = itn_id;
-	ev.p.cmd_req.data_len = cmd->request_bufflen;
+	ev.p.cmd_req.data_len = scsi_bufflen(cmd);
 	memcpy(ev.p.cmd_req.scb, cmd->cmnd, sizeof(ev.p.cmd_req.scb));
 	memcpy(ev.p.cmd_req.lun, lun, sizeof(ev.p.cmd_req.lun));
 	ev.p.cmd_req.attribute = cmd->tag;
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index b4b3af5..c2e776d 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -60,24 +60,6 @@ struct scsi_tgt_queuedata {
 	spinlock_t cmd_hash_lock;
 };
 
-/* FIXME Begin: Shim API until tgt is converted to use sdb */
-static struct scatterlist *tgt_scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t flags)
-{
-	if (scsi_alloc_sgtable(&cmd->sdb, cmd->use_sg, flags))
-		return NULL;
-	return cmd->sdb.sglist;
-}
-
-static void tgt_scsi_free_sgtable(struct scsi_cmnd *cmd)
-{
-	scsi_free_sgtable(&cmd->sdb);
-}
-#define scsi_alloc_sgtable tgt_scsi_alloc_sgtable
-#define scsi_free_sgtable tgt_scsi_free_sgtable
-
-/* FIXME End: Shim API until tgt is converted to use sdb */
-
-
 /*
  * Function:	scsi_host_get_command()
  *
@@ -349,8 +331,8 @@ static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
 
 	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
 
-	if (cmd->request_buffer)
-		scsi_free_sgtable(cmd);
+	if (cmd->sdb.sglist)
+		scsi_free_sgtable(&cmd->sdb);
 
 	queue_work(scsi_tgtd, &tcmd->work);
 }
@@ -374,24 +356,23 @@ static int scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
 static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct request *rq = cmd->request;
+	struct scsi_data_buffer *sdb = &cmd->sdb;
 	int count;
 
-	cmd->use_sg = rq->nr_phys_segments;
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, gfp_mask);
-	if (!cmd->request_buffer)
+	if (scsi_alloc_sgtable(sdb, rq->nr_phys_segments, gfp_mask))
 		return -ENOMEM;
 
-	cmd->request_bufflen = rq->data_len;
+	sdb->length = rq->data_len;
 
-	dprintk("cmd %p cnt %d %lu\n", cmd, cmd->use_sg, rq_data_dir(rq));
-	count = blk_rq_map_sg(rq->q, rq, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
-		cmd->use_sg = count;
+	dprintk("cmd %p cnt %d %lu\n", cmd, scsi_sg_count(cmd), rq_data_dir(rq));
+	count = blk_rq_map_sg(rq->q, rq, sdb->sglist);
+	if (likely(count <= sdb->sg_count)) {
+		sdb->sg_count = count;
 		return 0;
 	}
 
-	eprintk("cmd %p cnt %d\n", cmd, cmd->use_sg);
-	scsi_free_sgtable(cmd);
+	eprintk("cmd %p cnt %d\n", cmd, scsi_sg_count(cmd));
+	scsi_free_sgtable(&cmd->sdb);
 	return -EINVAL;
 }
 
@@ -515,7 +496,7 @@ int scsi_tgt_kspace_exec(int host_no, u64 itn_id, int result, u64 tag,
 	cmd = rq->special;
 
 	dprintk("cmd %p scb %x result %d len %d bufflen %u %lu %x\n",
-		cmd, cmd->cmnd[0], result, len, cmd->request_bufflen,
+		cmd, cmd->cmnd[0], result, len, scsi_bufflen(cmd),
 		rq_data_dir(rq), cmd->cmnd[0]);
 
 	if (result == TASK_ABORTED) {
-- 
1.5.3.1


