From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -next v3] target/rd: Don't pass imcomplete scatterlist entries to sbc_dif_verify_*
Date: Sat, 11 Apr 2015 13:17:31 +0900
Message-ID: <1428725851-9275-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The scatterlist for protection information which is passed to
sbc_dif_verify_read() or sbc_dif_verify_write() requires that
neighboring scatterlist entries are contiguous or chained so that they
can be iterated by sg_next().

However, the protection information for RD-MCP backends could be located
in the multiple scatterlist arrays when the ramdisk space is too large.
So if the read/write request straddles this boundary, sbc_dif_verify_read()
or sbc_dif_verify_write() can't iterate all scatterlist entries.

This problem can be fixed by chaining protection information scatterlist
at creation time.  For the architectures which don't support sg chaining
(i.e. !CONFIG_ARCH_HAS_SG_CHAIN), fix it by allocating temporary
scatterlist if needed.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
* v3
- Fix it by chaining protection information scatterlist at creation time
  if CONFIG_ARCH_HAS_SG_CHAIN is defined.

 drivers/target/target_core_rd.c | 67 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index ac5e8d2..b4e6de0 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -139,10 +139,22 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 	unsigned char *p;
 
 	while (total_sg_needed) {
+		unsigned int chain_entry = 0;
+
 		sg_per_table = (total_sg_needed > max_sg_per_table) ?
 			max_sg_per_table : total_sg_needed;
 
-		sg = kzalloc(sg_per_table * sizeof(struct scatterlist),
+#ifdef CONFIG_ARCH_HAS_SG_CHAIN
+
+		/*
+		 * Reserve extra element for chain entry
+		 */
+		if (sg_per_table < total_sg_needed)
+			chain_entry = 1;
+
+#endif /* CONFIG_ARCH_HAS_SG_CHAIN */
+
+		sg = kcalloc(sg_per_table + chain_entry, sizeof(*sg),
 				GFP_KERNEL);
 		if (!sg) {
 			pr_err("Unable to allocate scatterlist array"
@@ -150,7 +162,16 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 			return -ENOMEM;
 		}
 
-		sg_init_table(sg, sg_per_table);
+		sg_init_table(sg, sg_per_table + chain_entry);
+
+#ifdef CONFIG_ARCH_HAS_SG_CHAIN
+
+		if (i > 0) {
+			sg_chain(sg_table[i - 1].sg_table,
+				 max_sg_per_table + 1, sg);
+		}
+
+#endif /* CONFIG_ARCH_HAS_SG_CHAIN */
 
 		sg_table[i].sg_table = sg;
 		sg_table[i].rd_sg_count = sg_per_table;
@@ -390,11 +411,13 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, dif_verify dif_verify)
 	struct se_device *se_dev = cmd->se_dev;
 	struct rd_dev *dev = RD_DEV(se_dev);
 	struct rd_dev_sg_table *prot_table;
+	bool need_to_release = false;
 	struct scatterlist *prot_sg;
 	u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
 	u32 prot_offset, prot_page;
+	u32 prot_npages __maybe_unused;
 	u64 tmp;
-	sense_reason_t rc;
+	sense_reason_t rc = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	tmp = cmd->t_task_lba * se_dev->prot_length;
 	prot_offset = do_div(tmp, PAGE_SIZE);
@@ -407,7 +430,45 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, dif_verify dif_verify)
 	prot_sg = &prot_table->sg_table[prot_page -
 					prot_table->page_start_offset];
 
+#ifndef CONFIG_ARCH_HAS_SG_CHAIN
+
+	prot_npages = DIV_ROUND_UP(prot_offset + sectors * se_dev->prot_length,
+				   PAGE_SIZE);
+
+	/*
+	 * Allocate temporaly contiguous scatterlist entries if prot pages
+	 * straddles multiple scatterlist tables.
+	 */
+	if (prot_table->page_end_offset < prot_page + prot_npages - 1) {
+		int i;
+
+		prot_sg = kcalloc(prot_npages, sizeof(*prot_sg), GFP_KERNEL);
+		if (!prot_sg)
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+		need_to_release = true;
+		sg_init_table(prot_sg, prot_npages);
+
+		for (i = 0; i < prot_npages; i++) {
+			if (prot_page + i > prot_table->page_end_offset) {
+				prot_table = rd_get_prot_table(dev,
+								prot_page + i);
+				if (!prot_table) {
+					kfree(prot_sg);
+					return rc;
+				}
+				sg_unmark_end(&prot_sg[i - 1]);
+			}
+			prot_sg[i] = prot_table->sg_table[prot_page + i -
+						prot_table->page_start_offset];
+		}
+	}
+
+#endif /* !CONFIG_ARCH_HAS_SG_CHAIN */
+
 	rc = dif_verify(cmd, cmd->t_task_lba, sectors, 0, prot_sg, prot_offset);
+	if (need_to_release)
+		kfree(prot_sg);
 
 	return rc;
 }
-- 
1.9.1
