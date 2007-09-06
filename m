From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 6/9] tgt: convert ibmvstgt and libsrp to use
 scsi_data_buffer
Date: Fri, 7 Sep 2007 06:50:27 +0900
Message-ID: <20070906183756K.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:42989 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360AbXIFVv2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 17:51:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |    2 +-
 drivers/scsi/libsrp.c            |   27 ++++++++++++++-------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 8ba7dd0..ab173d4 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -286,7 +286,7 @@ static int ibmvstgt_cmd_done(struct scsi_cmnd *sc,
 	dprintk("%p %p %x %u\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0],
 		cmd->usg_sg);
 
-	if (sc->use_sg)
+	if (scsi_sg_count(sc))
 		err = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvstgt_rdma, 1, 1);
 
 	spin_lock_irqsave(&target->lock, flags);
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 732446e..32e1529 100644
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
 
@@ -425,8 +426,8 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
 
 	sc->SCp.ptr = info;
 	memcpy(sc->cmnd, cmd->cdb, MAX_COMMAND_SIZE);
-	sc->request_bufflen = len;
-	sc->request_buffer = (void *) (unsigned long) addr;
+	sc->sdb.length = len;
+	sc->sdb.sglist = (void *) (unsigned long) addr;
 	sc->tag = tag;
 	err = scsi_tgt_queue_command(sc, (struct scsi_lun *) &cmd->lun, cmd->tag);
 	if (err)
-- 
1.5.2.4

