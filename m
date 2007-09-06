From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 5/9] tgt: convert to use scsi_data_buffer
Date: Fri, 7 Sep 2007 06:50:24 +0900
Message-ID: <20070906183715D.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:42962 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301AbXIFVvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 17:51:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_tgt_if.c  |    2 +-
 drivers/scsi/scsi_tgt_lib.c |   27 ++++++++++++++-------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index ca22ddf..bdfc9b0 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -110,7 +110,7 @@ int scsi_tgt_uspace_send_cmd(struct scsi_cmnd *cmd, struct scsi_lun *lun, u64 ta
 
 	memset(&ev, 0, sizeof(ev));
 	ev.p.cmd_req.host_no = shost->host_no;
-	ev.p.cmd_req.data_len = cmd->request_bufflen;
+	ev.p.cmd_req.data_len = scsi_bufflen(cmd);
 	memcpy(ev.p.cmd_req.scb, cmd->cmnd, sizeof(ev.p.cmd_req.scb));
 	memcpy(ev.p.cmd_req.lun, lun, sizeof(ev.p.cmd_req.lun));
 	ev.p.cmd_req.attribute = cmd->tag;
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 2ee7b5a..30c8ec1 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -328,8 +328,8 @@ static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
 
 	scsi_tgt_uspace_send_status(cmd, tcmd->tag);
 
-	if (cmd->request_buffer)
-		scsi_free_sgtable(cmd);
+	if (cmd->sdb.sglist)
+		scsi_free_sgtable(&cmd->sdb);
 
 	queue_work(scsi_tgtd, &tcmd->work);
 }
@@ -353,24 +353,25 @@ static int scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
 static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
 	struct request *rq = cmd->request;
+	struct scsi_data_buffer *sdb = &cmd->sdb;
 	int count;
+	int ret;
 
-	cmd->use_sg = rq->nr_phys_segments;
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, gfp_mask);
-	if (!cmd->request_buffer)
-		return -ENOMEM;
+	ret = scsi_alloc_sgtable(sdb, gfp_mask, rq->nr_phys_segments);
+	if (ret)
+		return ret;
 
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
 
-- 
1.5.2.4

