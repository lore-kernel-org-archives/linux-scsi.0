From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 16/17] target/rd: Add DIF protection into rd_execute_rw
Date: Sun, 19 Jan 2014 02:44:39 +0000
Message-ID: <1390099480-29013-17-git-send-email-nab@daterainc.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for DIF protection into rd_execute_rw() code
for WRITE/READ I/O using sbc_dif_verify_[write,read]() logic.

It also adds rd_get_prot_table() for locating protection SGLs
assoicated with the ramdisk backend device.

v2 changes:
  - Make rd_execute_rw() to u32 sectors count instead of sector_t
  - Drop SCF_PROT usage

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_rd.c |   65 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 660961d..66a5aba 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -356,6 +356,26 @@ static struct rd_dev_sg_table *rd_get_sg_table(struct rd_dev *rd_dev, u32 page)
 	return NULL;
 }
 
+static struct rd_dev_sg_table *rd_get_prot_table(struct rd_dev *rd_dev, u32 page)
+{
+	struct rd_dev_sg_table *sg_table;
+	u32 i, sg_per_table = (RD_MAX_ALLOCATION_SIZE /
+				sizeof(struct scatterlist));
+
+	i = page / sg_per_table;
+	if (i < rd_dev->sg_prot_count) {
+		sg_table = &rd_dev->sg_prot_array[i];
+		if ((sg_table->page_start_offset <= page) &&
+		     (sg_table->page_end_offset >= page))
+			return sg_table;
+	}
+
+	pr_err("Unable to locate struct prot rd_dev_sg_table for page: %u\n",
+			page);
+
+	return NULL;
+}
+
 static sense_reason_t
 rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	      enum dma_data_direction data_direction)
@@ -370,6 +390,7 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	u32 rd_page;
 	u32 src_len;
 	u64 tmp;
+	sense_reason_t rc;
 
 	if (dev->rd_flags & RDF_NULLIO) {
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
@@ -392,6 +413,28 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			data_direction == DMA_FROM_DEVICE ? "Read" : "Write",
 			cmd->t_task_lba, rd_size, rd_page, rd_offset);
 
+	if (cmd->prot_type && data_direction == DMA_TO_DEVICE) {
+		struct rd_dev_sg_table *prot_table;
+		struct scatterlist *prot_sg;
+		u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
+		u32 prot_offset, prot_page;
+
+		tmp = cmd->t_task_lba * se_dev->prot_length;
+		prot_offset = do_div(tmp, PAGE_SIZE);
+		prot_page = tmp;
+
+		prot_table = rd_get_prot_table(dev, prot_page);
+		if (!prot_table)
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+		prot_sg = &prot_table->sg_table[prot_page - prot_table->page_start_offset];
+
+		rc = sbc_dif_verify_write(cmd, cmd->t_task_lba, sectors, 0,
+					  prot_sg, prot_offset);
+		if (rc)
+			return rc;
+	}
+
 	src_len = PAGE_SIZE - rd_offset;
 	sg_miter_start(&m, sgl, sgl_nents,
 			data_direction == DMA_FROM_DEVICE ?
@@ -453,6 +496,28 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	}
 	sg_miter_stop(&m);
 
+	if (cmd->prot_type && data_direction == DMA_FROM_DEVICE) {
+		struct rd_dev_sg_table *prot_table;
+		struct scatterlist *prot_sg;
+		u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
+		u32 prot_offset, prot_page;
+
+		tmp = cmd->t_task_lba * se_dev->prot_length;
+		prot_offset = do_div(tmp, PAGE_SIZE);
+		prot_page = tmp;
+
+		prot_table = rd_get_prot_table(dev, prot_page);
+		if (!prot_table)
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+		prot_sg = &prot_table->sg_table[prot_page - prot_table->page_start_offset];
+
+		rc = sbc_dif_verify_read(cmd, cmd->t_task_lba, sectors, 0,
+					 prot_sg, prot_offset);
+		if (rc)
+			return rc;
+	}
+
 	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
-- 
1.7.10.4
