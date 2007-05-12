From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/19] ibmvscsi: convert to use the data buffer accessors
Date: Sat, 12 May 2007 19:05:43 +0900 (JST)
Message-ID: <20070512183139D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55498 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbXELKF6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rcj@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This converts ibmvscsi to use the data buffer accessors.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   52 ++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 57acf86..dfb6eeb 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -353,20 +353,19 @@ static void unmap_cmd_data(struct srp_cm
 	}
 }
 
-static int map_sg_list(int num_entries, 
-		       struct scatterlist *sg,
+static int map_sg_list(struct scsi_cmnd *cmd, int nseg,
 		       struct srp_direct_buf *md)
 {
 	int i;
+	struct scatterlist *sg;
 	u64 total_length = 0;
 
-	for (i = 0; i < num_entries; ++i) {
+	scsi_for_each_sg(cmd, sg, nseg, i) {
 		struct srp_direct_buf *descr = md + i;
-		struct scatterlist *sg_entry = &sg[i];
-		descr->va = sg_dma_address(sg_entry);
-		descr->len = sg_dma_len(sg_entry);
+		descr->va = sg_dma_address(sg);
+		descr->len = sg_dma_len(sg);
 		descr->key = 0;
-		total_length += sg_dma_len(sg_entry);
+		total_length += sg_dma_len(sg);
  	}
 	return total_length;
 }
@@ -387,40 +386,37 @@ static int map_sg_data(struct scsi_cmnd
 
 	int sg_mapped;
 	u64 total_length = 0;
-	struct scatterlist *sg = cmd->request_buffer;
 	struct srp_direct_buf *data =
 		(struct srp_direct_buf *) srp_cmd->add_data;
 	struct srp_indirect_buf *indirect =
 		(struct srp_indirect_buf *) data;
 
-	sg_mapped = dma_map_sg(dev, sg, cmd->use_sg, DMA_BIDIRECTIONAL);
-
-	if (sg_mapped == 0)
+	sg_mapped = scsi_dma_map(dev, cmd);
+	if (!sg_mapped)
+		return 1;
+	else if (sg_mapped < 0)
+		return 0;
+	else if (sg_mapped > SG_ALL) {
+		printk(KERN_ERR
+		       "ibmvscsi: More than %d mapped sg entries, got %d\n",
+		       SG_ALL, sg_mapped);
 		return 0;
+	}
 
 	set_srp_direction(cmd, srp_cmd, sg_mapped);
 
 	/* special case; we can use a single direct descriptor */
 	if (sg_mapped == 1) {
-		data->va = sg_dma_address(&sg[0]);
-		data->len = sg_dma_len(&sg[0]);
-		data->key = 0;
+		map_sg_list(cmd, sg_mapped, data);
 		return 1;
 	}
 
-	if (sg_mapped > SG_ALL) {
-		printk(KERN_ERR
-		       "ibmvscsi: More than %d mapped sg entries, got %d\n",
-		       SG_ALL, sg_mapped);
-		return 0;
-	}
-
 	indirect->table_desc.va = 0;
 	indirect->table_desc.len = sg_mapped * sizeof(struct srp_direct_buf);
 	indirect->table_desc.key = 0;
 
 	if (sg_mapped <= MAX_INDIRECT_BUFS) {
-		total_length = map_sg_list(sg_mapped, sg,
+		total_length = map_sg_list(cmd, sg_mapped,
 					   &indirect->desc_list[0]);
 		indirect->len = total_length;
 		return 1;
@@ -429,25 +425,23 @@ static int map_sg_data(struct scsi_cmnd
 	/* get indirect table */
 	if (!evt_struct->ext_list) {
 		evt_struct->ext_list = (struct srp_direct_buf *)
-			dma_alloc_coherent(dev, 
+			dma_alloc_coherent(dev,
 					   SG_ALL * sizeof(struct srp_direct_buf),
 					   &evt_struct->ext_list_token, 0);
 		if (!evt_struct->ext_list) {
 			printk(KERN_ERR
 			       "ibmvscsi: Can't allocate memory for indirect table\n");
 			return 0;
-			
 		}
 	}
 
-	total_length = map_sg_list(sg_mapped, sg, evt_struct->ext_list);	
+	total_length = map_sg_list(cmd, sg_mapped, evt_struct->ext_list);
 
 	indirect->len = total_length;
 	indirect->table_desc.va = evt_struct->ext_list_token;
 	indirect->table_desc.len = sg_mapped * sizeof(indirect->desc_list[0]);
 	memcpy(indirect->desc_list, evt_struct->ext_list,
 	       MAX_INDIRECT_BUFS * sizeof(struct srp_direct_buf));
-	
  	return 1;
 }
 
@@ -481,8 +475,6 @@ static int map_data_for_srp_cmd(struct s
 		return 0;
 	}
 
-	if (!cmd->request_buffer)
-		return 1;
 	return map_sg_data(cmd, evt_struct, srp_cmd, dev);
 }
 
@@ -616,9 +608,9 @@ static void handle_cmd_rsp(struct srp_ev
 			       evt_struct->hostdata->dev);
 
 		if (rsp->flags & SRP_RSP_FLAG_DOOVER)
-			cmnd->resid = rsp->data_out_res_cnt;
+			scsi_resid(cmnd) = rsp->data_out_res_cnt;
 		else if (rsp->flags & SRP_RSP_FLAG_DIOVER)
-			cmnd->resid = rsp->data_in_res_cnt;
+			scsi_resid(cmnd) = rsp->data_in_res_cnt;
 	}
 
 	if (evt_struct->cmnd_done)
-- 
1.4.3.2

