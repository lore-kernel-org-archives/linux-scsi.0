From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/2] target/rd: reduce code duplication in rd_execute_rw()
Date: Sat,  4 Apr 2015 21:24:27 +0900
Message-ID: <1428150268-30260-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Asias He <asias@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Factor out code duplication in rd_execute_rw() into a helper function
rd_do_prot_rw().  This change is required to minimize the forthcoming
fix in rd_do_prot_rw().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Asias He <asias@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/target/target_core_rd.c | 66 ++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 98e83ac..4d614c9 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -382,6 +382,36 @@ static struct rd_dev_sg_table *rd_get_prot_table(struct rd_dev *rd_dev, u32 page
 	return NULL;
 }
 
+static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_write)
+{
+	struct se_device *se_dev = cmd->se_dev;
+	struct rd_dev *dev = RD_DEV(se_dev);
+	struct rd_dev_sg_table *prot_table;
+	struct scatterlist *prot_sg;
+	u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
+	u32 prot_offset, prot_page;
+	u64 tmp;
+	sense_reason_t rc;
+	sense_reason_t (*dif_verify)(struct se_cmd *, sector_t, unsigned int,
+			unsigned int, struct scatterlist *, int) =
+		is_write ?  sbc_dif_verify_write : sbc_dif_verify_read;
+
+	tmp = cmd->t_task_lba * se_dev->prot_length;
+	prot_offset = do_div(tmp, PAGE_SIZE);
+	prot_page = tmp;
+
+	prot_table = rd_get_prot_table(dev, prot_page);
+	if (!prot_table)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	prot_sg = &prot_table->sg_table[prot_page -
+					prot_table->page_start_offset];
+
+	rc = dif_verify(cmd, cmd->t_task_lba, sectors, 0, prot_sg, prot_offset);
+
+	return rc;
+}
+
 static sense_reason_t
 rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	      enum dma_data_direction data_direction)
@@ -420,23 +450,7 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			cmd->t_task_lba, rd_size, rd_page, rd_offset);
 
 	if (cmd->prot_type && data_direction == DMA_TO_DEVICE) {
-		struct rd_dev_sg_table *prot_table;
-		struct scatterlist *prot_sg;
-		u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
-		u32 prot_offset, prot_page;
-
-		tmp = cmd->t_task_lba * se_dev->prot_length;
-		prot_offset = do_div(tmp, PAGE_SIZE);
-		prot_page = tmp;
-
-		prot_table = rd_get_prot_table(dev, prot_page);
-		if (!prot_table)
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-
-		prot_sg = &prot_table->sg_table[prot_page - prot_table->page_start_offset];
-
-		rc = sbc_dif_verify_write(cmd, cmd->t_task_lba, sectors, 0,
-					  prot_sg, prot_offset);
+		rc = rd_do_prot_rw(cmd, true);
 		if (rc)
 			return rc;
 	}
@@ -503,23 +517,7 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	sg_miter_stop(&m);
 
 	if (cmd->prot_type && data_direction == DMA_FROM_DEVICE) {
-		struct rd_dev_sg_table *prot_table;
-		struct scatterlist *prot_sg;
-		u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
-		u32 prot_offset, prot_page;
-
-		tmp = cmd->t_task_lba * se_dev->prot_length;
-		prot_offset = do_div(tmp, PAGE_SIZE);
-		prot_page = tmp;
-
-		prot_table = rd_get_prot_table(dev, prot_page);
-		if (!prot_table)
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-
-		prot_sg = &prot_table->sg_table[prot_page - prot_table->page_start_offset];
-
-		rc = sbc_dif_verify_read(cmd, cmd->t_task_lba, sectors, 0,
-					 prot_sg, prot_offset);
+		rc = rd_do_prot_rw(cmd, false);
 		if (rc)
 			return rc;
 	}
-- 
1.9.1
