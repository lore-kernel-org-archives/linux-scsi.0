From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 08/14] target/sbc: Convert sbc_dif_copy_prot to target_iostate
Date: Wed,  1 Jun 2016 21:48:41 +0000
Message-ID: <1464817727-9125-9-git-send-email-nab@linux-iscsi.org>
References: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53511 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbcFAVtr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2016 17:49:47 -0400
In-Reply-To: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts sbc_dif_copy_prot() to use struct target_iomem
for existing T10-PI scatterlist memory and scatterlist count
dereferences.

Also convert the single external user in rd_do_prot_rw() code.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_rd.c      | 24 +++++++++++++-----------
 drivers/target/target_core_sbc.c     |  9 ++++-----
 include/target/target_core_backend.h |  4 ++--
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index df8bd58..cbcb33e 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -398,19 +398,21 @@ static struct rd_dev_sg_table *rd_get_prot_table(struct rd_dev *rd_dev, u32 page
 	return NULL;
 }
 
-static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_read)
+static sense_reason_t rd_do_prot_rw(struct target_iostate *ios, bool is_read)
 {
-	struct se_device *se_dev = cmd->se_dev;
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
+	struct se_device *se_dev = ios->se_dev;
+	struct target_iomem *iomem = ios->iomem;
 	struct rd_dev *dev = RD_DEV(se_dev);
 	struct rd_dev_sg_table *prot_table;
 	struct scatterlist *prot_sg;
-	u32 sectors = cmd->t_iostate.data_length / se_dev->dev_attrib.block_size;
+	u32 sectors = ios->data_length / se_dev->dev_attrib.block_size;
 	u32 prot_offset, prot_page;
 	u32 prot_npages __maybe_unused;
 	u64 tmp;
 	sense_reason_t rc = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	tmp = cmd->t_iostate.t_task_lba * se_dev->prot_length;
+	tmp = ios->t_task_lba * se_dev->prot_length;
 	prot_offset = do_div(tmp, PAGE_SIZE);
 	prot_page = tmp;
 
@@ -422,14 +424,15 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_read)
 					prot_table->page_start_offset];
 
 	if (is_read)
-		rc = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba, sectors, 0,
+		rc = sbc_dif_verify(cmd, ios->t_task_lba, sectors, 0,
 				    prot_sg, prot_offset);
 	else
-		rc = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba, sectors, 0,
-				    cmd->t_iomem.t_prot_sg, 0);
+		rc = sbc_dif_verify(cmd, ios->t_task_lba, sectors, 0,
+				    iomem->t_prot_sg, 0);
 
 	if (!rc)
-		sbc_dif_copy_prot(cmd, sectors, is_read, prot_sg, prot_offset);
+		sbc_dif_copy_prot(iomem, sectors, is_read, prot_sg, prot_offset,
+				  se_dev->prot_length);
 
 	return rc;
 }
@@ -439,7 +442,6 @@ rd_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_nents
 	      enum dma_data_direction data_direction, bool fua_write,
 	      void (*t_comp_func)(struct target_iostate *, u16))
 {
-	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *se_dev = ios->se_dev;
 	struct rd_dev *dev = RD_DEV(se_dev);
 	struct rd_dev_sg_table *table;
@@ -475,7 +477,7 @@ rd_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_nents
 
 	if (ios->prot_type && se_dev->dev_attrib.pi_prot_type &&
 	    data_direction == DMA_TO_DEVICE) {
-		rc = rd_do_prot_rw(cmd, false);
+		rc = rd_do_prot_rw(ios, false);
 		if (rc)
 			return rc;
 	}
@@ -543,7 +545,7 @@ rd_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_nents
 
 	if (ios->prot_type && se_dev->dev_attrib.pi_prot_type &&
 	    data_direction == DMA_FROM_DEVICE) {
-		rc = rd_do_prot_rw(cmd, true);
+		rc = rd_do_prot_rw(ios, true);
 		if (rc)
 			return rc;
 	}
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index e1288de..e82b261 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1381,10 +1381,9 @@ check_ref:
 	return 0;
 }
 
-void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
-		       struct scatterlist *sg, int sg_off)
+void sbc_dif_copy_prot(struct target_iomem *iomem, unsigned int sectors, bool read,
+		       struct scatterlist *sg, int sg_off, u32 prot_length)
 {
-	struct se_device *dev = cmd->se_dev;
 	struct scatterlist *psg;
 	void *paddr, *addr;
 	unsigned int i, len, left;
@@ -1393,9 +1392,9 @@ void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
 	if (!sg)
 		return;
 
-	left = sectors * dev->prot_length;
+	left = sectors * prot_length;
 
-	for_each_sg(cmd->t_iomem.t_prot_sg, psg, cmd->t_iomem.t_prot_nents, i) {
+	for_each_sg(iomem->t_prot_sg, psg, iomem->t_prot_nents, i) {
 		unsigned int psg_len, copied = 0;
 
 		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index ade90b7..f2d593f 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -73,8 +73,8 @@ sector_t	sbc_get_write_same_sectors(struct se_cmd *cmd);
 void	sbc_dif_generate(struct se_cmd *);
 sense_reason_t	sbc_dif_verify(struct se_cmd *, sector_t, unsigned int,
 				     unsigned int, struct scatterlist *, int);
-void sbc_dif_copy_prot(struct se_cmd *, unsigned int, bool,
-		       struct scatterlist *, int);
+void sbc_dif_copy_prot(struct target_iomem *, unsigned int, bool,
+		       struct scatterlist *, int, u32);
 void	transport_set_vpd_proto_id(struct t10_vpd *, unsigned char *);
 int	transport_set_vpd_assoc(struct t10_vpd *, unsigned char *);
 int	transport_set_vpd_ident_type(struct t10_vpd *, unsigned char *);
-- 
1.9.1

