From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] tgt: convert to use the data buffer accessors
Date: Thu, 25 Oct 2007 01:21:30 +0900
Message-ID: <20071025011919N.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:38963 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759198AbXJXQZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 12:25:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp

This converts tgt to use the data buffer accessors to reduce the size
of the scsi_data_buffer patch for tgt, which will be merged later.

-
Subject: [PATCH] tgt: convert to use the data buffer accessors

- convert to use the new accessors for the sg lists and the
parameters.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |    2 +-
 drivers/scsi/libsrp.c            |   23 ++++++++++++-----------
 drivers/scsi/scsi_tgt_if.c       |    2 +-
 drivers/scsi/scsi_tgt_lib.c      |   11 ++++++-----
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 82bcab6..d63f11e 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -292,7 +292,7 @@ static int ibmvstgt_cmd_done(struct scsi_cmnd *sc,
 	dprintk("%p %p %x %u\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0],
 		cmd->usg_sg);
 
-	if (sc->use_sg)
+	if (scsi_sg_count(sc))
 		err = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvstgt_rdma, 1, 1);
 
 	spin_lock_irqsave(&target->lock, flags);
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 2ad0a27..5cff020 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -192,18 +192,18 @@ static int srp_direct_data(struct scsi_cmnd *sc, struct srp_direct_buf *md,
 
 	if (dma_map) {
 		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = sc->request_buffer;
+		sg = scsi_sglist(sc);
 
-		dprintk("%p %u %u %d\n", iue, sc->request_bufflen,
-			md->len, sc->use_sg);
+		dprintk("%p %u %u %d\n", iue, scsi_bufflen(sc),
+			md->len, scsi_sg_count(sc));
 
-		nsg = dma_map_sg(iue->target->dev, sg, sc->use_sg,
+		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
 				 DMA_BIDIRECTIONAL);
 		if (!nsg) {
-			printk("fail to map %p %d\n", iue, sc->use_sg);
+			printk("fail to map %p %d\n", iue, scsi_sg_count(sc));
 			return 0;
 		}
-		len = min(sc->request_bufflen, md->len);
+		len = min(scsi_bufflen(sc), md->len);
 	} else
 		len = md->len;
 
@@ -229,10 +229,10 @@ static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 
 	if (dma_map || ext_desc) {
 		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = sc->request_buffer;
+		sg = scsi_sglist(sc);
 
 		dprintk("%p %u %u %d %d\n",
-			iue, sc->request_bufflen, id->len,
+			iue, scsi_bufflen(sc), id->len,
 			cmd->data_in_desc_cnt, cmd->data_out_desc_cnt);
 	}
 
@@ -268,13 +268,14 @@ static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 
 rdma:
 	if (dma_map) {
-		nsg = dma_map_sg(iue->target->dev, sg, sc->use_sg, DMA_BIDIRECTIONAL);
+		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
+				 DMA_BIDIRECTIONAL);
 		if (!nsg) {
-			eprintk("fail to map %p %d\n", iue, sc->use_sg);
+			eprintk("fail to map %p %d\n", iue, scsi_sg_count(sc));
 			err = -EIO;
 			goto free_mem;
 		}
-		len = min(sc->request_bufflen, id->len);
+		len = min(scsi_bufflen(sc), id->len);
 	} else
 		len = id->len;
 
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
index d67ca14..7abef1a 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -331,7 +331,7 @@ static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
 
 	scsi_tgt_uspace_send_status(cmd, tcmd->itn_id, tcmd->tag);
 
-	if (cmd->request_buffer)
+	if (scsi_sglist(cmd))
 		scsi_free_sgtable(cmd);
 
 	queue_work(scsi_tgtd, &tcmd->work);
@@ -365,14 +365,15 @@ static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 	cmd->request_bufflen = rq->data_len;
 
-	dprintk("cmd %p cnt %d %lu\n", cmd, cmd->use_sg, rq_data_dir(rq));
-	count = blk_rq_map_sg(rq->q, rq, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
+	dprintk("cmd %p cnt %d %lu\n", cmd, scsi_sg_count(cmd),
+		rq_data_dir(rq));
+	count = blk_rq_map_sg(rq->q, rq, scsi_sglist(cmd));
+	if (likely(count <= scsi_sg_count(cmd))) {
 		cmd->use_sg = count;
 		return 0;
 	}
 
-	eprintk("cmd %p cnt %d\n", cmd, cmd->use_sg);
+	eprintk("cmd %p cnt %d\n", cmd, scsi_sg_count(cmd));
 	scsi_free_sgtable(cmd);
 	return -EINVAL;
 }
-- 
1.5.2.4

