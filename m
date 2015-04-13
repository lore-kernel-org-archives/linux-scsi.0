From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH RFC 1/2] target: Merge sbc_verify_dif_read|write
Date: Mon, 13 Apr 2015 20:19:34 +0300
Message-ID: <1428945575-30839-2-git-send-email-sagig@mellanox.com>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Akinobu Mita <akinobu.mita@gmail.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Instead of providing DIF verify routines for read/write
that are almost identical and conditionally copy protection
information, just let the caller do the right thing.

Have a single sbc_dif_verify that handles an sgl (that
does NOT copy any data) and a protection information copy
routine used by rd_mcp and fileio backend.

In the WRITE case, call sbc_dif_verify with cmd->t_prot_sg
and then do the copy from it to local sgl (assuming the verify
succeeded of course). In the READ case, call sbc_dif_verify
with the local sgl and if it succeeds, copy it to t_prot_sg (or
not if we are stripping it).

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_file.c      |   14 ++++--
 drivers/target/target_core_rd.c        |   20 +++++---
 drivers/target/target_core_sbc.c       |   94 ++------------------------------
 drivers/target/target_core_transport.c |   17 +++---
 include/target/target_core_backend.h   |    8 +--
 5 files changed, 41 insertions(+), 112 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index fa54835..3476397 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -595,12 +595,15 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		if (ret > 0 && cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 			u32 sectors = cmd->data_length / dev->dev_attrib.block_size;
 
-			rc = sbc_dif_verify_read(cmd, cmd->t_task_lba, sectors,
-						 0, fd_prot.prot_sg, 0);
+			rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors,
+					    0, fd_prot.prot_sg, 0);
 			if (rc) {
 				kfree(fd_prot.prot_sg);
 				vfree(fd_prot.prot_buf);
 				return rc;
+			} else {
+				sbc_dif_copy_prot(cmd, sectors, true,
+						  fd_prot.prot_sg, 0);
 			}
 			kfree(fd_prot.prot_sg);
 			vfree(fd_prot.prot_buf);
@@ -615,12 +618,15 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-			rc = sbc_dif_verify_write(cmd, cmd->t_task_lba, sectors,
-						  0, fd_prot.prot_sg, 0);
+			rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors,
+					    0, cmd->t_prot_sg, 0);
 			if (rc) {
 				kfree(fd_prot.prot_sg);
 				vfree(fd_prot.prot_buf);
 				return rc;
+			} else {
+				sbc_dif_copy_prot(cmd, sectors, false,
+						  fd_prot.prot_sg, 0);
 			}
 		}
 
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index a263bf5..12fbe90 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -403,10 +403,7 @@ static struct rd_dev_sg_table *rd_get_prot_table(struct rd_dev *rd_dev, u32 page
 	return NULL;
 }
 
-typedef sense_reason_t (*dif_verify)(struct se_cmd *, sector_t, unsigned int,
-				     unsigned int, struct scatterlist *, int);
-
-static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, dif_verify dif_verify)
+static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_read)
 {
 	struct se_device *se_dev = cmd->se_dev;
 	struct rd_dev *dev = RD_DEV(se_dev);
@@ -466,7 +463,16 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, dif_verify dif_verify)
 
 #endif /* !CONFIG_ARCH_HAS_SG_CHAIN */
 
-	rc = dif_verify(cmd, cmd->t_task_lba, sectors, 0, prot_sg, prot_offset);
+	if (is_read)
+		rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors, 0,
+				    prot_sg, prot_offset);
+	else
+		rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors, 0,
+				    cmd->t_prot_sg, 0);
+
+	if (!rc)
+		sbc_dif_copy_prot(cmd, sectors, is_read, prot_sg, prot_offset);
+
 	if (need_to_release)
 		kfree(prot_sg);
 
@@ -512,7 +518,7 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	if (cmd->prot_type && se_dev->dev_attrib.pi_prot_type &&
 	    data_direction == DMA_TO_DEVICE) {
-		rc = rd_do_prot_rw(cmd, sbc_dif_verify_write);
+		rc = rd_do_prot_rw(cmd, true);
 		if (rc)
 			return rc;
 	}
@@ -580,7 +586,7 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	if (cmd->prot_type && se_dev->dev_attrib.pi_prot_type &&
 	    data_direction == DMA_FROM_DEVICE) {
-		rc = rd_do_prot_rw(cmd, sbc_dif_verify_read);
+		rc = rd_do_prot_rw(cmd, false);
 		if (rc)
 			return rc;
 	}
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 0064ffe..c0e4175 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1254,9 +1254,8 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct se_dif_v1_tuple *sdt,
 	return 0;
 }
 
-static void
-sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
-		  struct scatterlist *sg, int sg_off)
+void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
+		       struct scatterlist *sg, int sg_off)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct scatterlist *psg;
@@ -1297,68 +1296,11 @@ sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
 		kunmap_atomic(paddr);
 	}
 }
+EXPORT_SYMBOL(sbc_dif_copy_prot);
 
 sense_reason_t
-sbc_dif_verify_write(struct se_cmd *cmd, sector_t start, unsigned int sectors,
-		     unsigned int ei_lba, struct scatterlist *sg, int sg_off)
-{
-	struct se_device *dev = cmd->se_dev;
-	struct se_dif_v1_tuple *sdt;
-	struct scatterlist *dsg, *psg = cmd->t_prot_sg;
-	sector_t sector = start;
-	void *daddr, *paddr;
-	int i, j, offset = 0;
-	sense_reason_t rc;
-
-	for_each_sg(cmd->t_data_sg, dsg, cmd->t_data_nents, i) {
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-
-		for (j = 0; j < dsg->length; j += dev->dev_attrib.block_size) {
-
-			if (offset >= psg->length) {
-				kunmap_atomic(paddr);
-				psg = sg_next(psg);
-				paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-				offset = 0;
-			}
-
-			sdt = paddr + offset;
-
-			pr_debug("DIF WRITE sector: %llu guard_tag: 0x%04x"
-				 " app_tag: 0x%04x ref_tag: %u\n",
-				 (unsigned long long)sector, sdt->guard_tag,
-				 sdt->app_tag, be32_to_cpu(sdt->ref_tag));
-
-			rc = sbc_dif_v1_verify(cmd, sdt, daddr + j, sector,
-					       ei_lba);
-			if (rc) {
-				kunmap_atomic(paddr);
-				kunmap_atomic(daddr);
-				cmd->bad_sector = sector;
-				return rc;
-			}
-
-			sector++;
-			ei_lba++;
-			offset += sizeof(struct se_dif_v1_tuple);
-		}
-
-		kunmap_atomic(paddr);
-		kunmap_atomic(daddr);
-	}
-	if (!sg)
-		return 0;
-
-	sbc_dif_copy_prot(cmd, sectors, false, sg, sg_off);
-
-	return 0;
-}
-EXPORT_SYMBOL(sbc_dif_verify_write);
-
-static sense_reason_t
-__sbc_dif_verify_read(struct se_cmd *cmd, sector_t start, unsigned int sectors,
-		      unsigned int ei_lba, struct scatterlist *sg, int sg_off)
+sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
+	       unsigned int ei_lba, struct scatterlist *sg, int sg_off)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_dif_v1_tuple *sdt;
@@ -1414,28 +1356,4 @@ __sbc_dif_verify_read(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 
 	return 0;
 }
-
-sense_reason_t
-sbc_dif_read_strip(struct se_cmd *cmd)
-{
-	struct se_device *dev = cmd->se_dev;
-	u32 sectors = cmd->prot_length / dev->prot_length;
-
-	return __sbc_dif_verify_read(cmd, cmd->t_task_lba, sectors, 0,
-				     cmd->t_prot_sg, 0);
-}
-
-sense_reason_t
-sbc_dif_verify_read(struct se_cmd *cmd, sector_t start, unsigned int sectors,
-		    unsigned int ei_lba, struct scatterlist *sg, int sg_off)
-{
-	sense_reason_t rc;
-
-	rc = __sbc_dif_verify_read(cmd, start, sectors, ei_lba, sg, sg_off);
-	if (rc)
-		return rc;
-
-	sbc_dif_copy_prot(cmd, sectors, true, sg, sg_off);
-	return 0;
-}
-EXPORT_SYMBOL(sbc_dif_verify_read);
+EXPORT_SYMBOL(sbc_dif_verify);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4edb183..5e97757 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1758,8 +1758,8 @@ static int target_write_prot_action(struct se_cmd *cmd)
 			break;
 
 		sectors = cmd->data_length >> ilog2(cmd->se_dev->dev_attrib.block_size);
-		cmd->pi_err = sbc_dif_verify_write(cmd, cmd->t_task_lba,
-						   sectors, 0, NULL, 0);
+		cmd->pi_err = sbc_dif_verify(cmd, cmd->t_task_lba,
+					     sectors, 0, cmd->t_prot_sg, 0);
 		if (unlikely(cmd->pi_err)) {
 			spin_lock_irq(&cmd->t_state_lock);
 			cmd->transport_state &= ~CMD_T_BUSY|CMD_T_SENT;
@@ -1984,16 +1984,17 @@ static void transport_handle_queue_full(
 
 static bool target_read_prot_action(struct se_cmd *cmd)
 {
-	sense_reason_t rc;
-
 	switch (cmd->prot_op) {
 	case TARGET_PROT_DIN_STRIP:
 		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_STRIP)) {
-			rc = sbc_dif_read_strip(cmd);
-			if (rc) {
-				cmd->pi_err = rc;
+			u32 sectors = cmd->data_length >>
+				  ilog2(cmd->se_dev->dev_attrib.block_size);
+
+			cmd->pi_err = sbc_dif_verify(cmd, cmd->t_task_lba,
+						     sectors, 0, cmd->t_prot_sg,
+						     0);
+			if (cmd->pi_err)
 				return true;
-			}
 		}
 		break;
 	case TARGET_PROT_DIN_INSERT:
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index db81c65..45df9e6 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -86,12 +86,10 @@ sense_reason_t sbc_execute_unmap(struct se_cmd *cmd,
 				      sector_t lba, sector_t nolb),
 	void *priv);
 void	sbc_dif_generate(struct se_cmd *);
-sense_reason_t	sbc_dif_verify_write(struct se_cmd *, sector_t, unsigned int,
+sense_reason_t	sbc_dif_verify(struct se_cmd *, sector_t, unsigned int,
 				     unsigned int, struct scatterlist *, int);
-sense_reason_t	sbc_dif_verify_read(struct se_cmd *, sector_t, unsigned int,
-				    unsigned int, struct scatterlist *, int);
-sense_reason_t	sbc_dif_read_strip(struct se_cmd *);
-
+void sbc_dif_copy_prot(struct se_cmd *, unsigned int, bool,
+		       struct scatterlist *, int);
 void	transport_set_vpd_proto_id(struct t10_vpd *, unsigned char *);
 int	transport_set_vpd_assoc(struct t10_vpd *, unsigned char *);
 int	transport_set_vpd_ident_type(struct t10_vpd *, unsigned char *);
-- 
1.7.1
