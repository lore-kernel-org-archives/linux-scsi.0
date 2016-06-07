From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 09/16] target/file: Convert sbc_dif_verify to target_iostate
Date: Tue,  7 Jun 2016 04:12:34 +0000
Message-ID: <1465272761-26045-10-git-send-email-nab@linux-iscsi.org>
References: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55960 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbcFGENl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2016 00:13:41 -0400
In-Reply-To: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts sbc_dif_verify() and associated existing
T10-PI FILEIO driver to use target_iostate

Also add FIXMEs for target_*_prot_action for target_iostate +
target_iomem so this logic can eventually used by external
drivers doing TARGET_PROT_DOUT_INSERT + TARGET_PROT_DIN_STRIP
using software emulation.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c      |  5 ++---
 drivers/target/target_core_rd.c        |  5 ++---
 drivers/target/target_core_sbc.c       | 21 +++++++++++----------
 drivers/target/target_core_transport.c | 15 +++++++++++----
 include/target/target_core_backend.h   |  2 +-
 5 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index bc82018..ed94969 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -512,7 +512,6 @@ fd_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_nents
 	      enum dma_data_direction data_direction, bool fua_write,
 	      void (*t_comp_func)(struct target_iostate *, u16))
 {
-	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct target_iomem *iomem = ios->iomem;
 	struct se_device *dev = ios->se_dev;
 	struct fd_dev *fd_dev = FD_DEV(dev);
@@ -552,7 +551,7 @@ fd_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_nents
 			u32 sectors = ios->data_length >>
 					ilog2(dev->dev_attrib.block_size);
 
-			rc = sbc_dif_verify(cmd, ios->t_task_lba, sectors,
+			rc = sbc_dif_verify(ios, ios->t_task_lba, sectors,
 					    0, iomem->t_prot_sg, 0);
 			if (rc)
 				return rc;
@@ -562,7 +561,7 @@ fd_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_nents
 			u32 sectors = ios->data_length >>
 					ilog2(dev->dev_attrib.block_size);
 
-			rc = sbc_dif_verify(cmd, ios->t_task_lba, sectors,
+			rc = sbc_dif_verify(ios, ios->t_task_lba, sectors,
 					    0, iomem->t_prot_sg, 0);
 			if (rc)
 				return rc;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index cbcb33e..a38a37f 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -400,7 +400,6 @@ static struct rd_dev_sg_table *rd_get_prot_table(struct rd_dev *rd_dev, u32 page
 
 static sense_reason_t rd_do_prot_rw(struct target_iostate *ios, bool is_read)
 {
-	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct se_device *se_dev = ios->se_dev;
 	struct target_iomem *iomem = ios->iomem;
 	struct rd_dev *dev = RD_DEV(se_dev);
@@ -424,10 +423,10 @@ static sense_reason_t rd_do_prot_rw(struct target_iostate *ios, bool is_read)
 					prot_table->page_start_offset];
 
 	if (is_read)
-		rc = sbc_dif_verify(cmd, ios->t_task_lba, sectors, 0,
+		rc = sbc_dif_verify(ios, ios->t_task_lba, sectors, 0,
 				    prot_sg, prot_offset);
 	else
-		rc = sbc_dif_verify(cmd, ios->t_task_lba, sectors, 0,
+		rc = sbc_dif_verify(ios, ios->t_task_lba, sectors, 0,
 				    iomem->t_prot_sg, 0);
 
 	if (!rc)
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index e82b261..649a3f2 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1341,12 +1341,12 @@ sbc_dif_generate(struct se_cmd *cmd)
 }
 
 static sense_reason_t
-sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
+sbc_dif_v1_verify(struct target_iostate *ios, struct t10_pi_tuple *sdt,
 		  __u16 crc, sector_t sector, unsigned int ei_lba)
 {
 	__be16 csum;
 
-	if (!(cmd->t_iostate.prot_checks & TARGET_DIF_CHECK_GUARD))
+	if (!(ios->prot_checks & TARGET_DIF_CHECK_GUARD))
 		goto check_ref;
 
 	csum = cpu_to_be16(crc);
@@ -1359,10 +1359,10 @@ sbc_dif_v1_verify(struct se_cmd *cmd, struct t10_pi_tuple *sdt,
 	}
 
 check_ref:
-	if (!(cmd->t_iostate.prot_checks & TARGET_DIF_CHECK_REFTAG))
+	if (!(ios->prot_checks & TARGET_DIF_CHECK_REFTAG))
 		return 0;
 
-	if (cmd->t_iostate.prot_type == TARGET_DIF_TYPE1_PROT &&
+	if (ios->prot_type == TARGET_DIF_TYPE1_PROT &&
 	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
 		pr_err("DIFv1 Type 1 reference failed on sector: %llu tag: 0x%08x"
 		       " sector MSB: 0x%08x\n", (unsigned long long)sector,
@@ -1370,7 +1370,7 @@ check_ref:
 		return TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
 	}
 
-	if (cmd->t_iostate.prot_type == TARGET_DIF_TYPE2_PROT &&
+	if (ios->prot_type == TARGET_DIF_TYPE2_PROT &&
 	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
 		pr_err("DIFv1 Type 2 reference failed on sector: %llu tag: 0x%08x"
 		       " ei_lba: 0x%08x\n", (unsigned long long)sector,
@@ -1426,12 +1426,13 @@ void sbc_dif_copy_prot(struct target_iomem *iomem, unsigned int sectors, bool re
 EXPORT_SYMBOL(sbc_dif_copy_prot);
 
 sense_reason_t
-sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
+sbc_dif_verify(struct target_iostate *ios, sector_t start, unsigned int sectors,
 	       unsigned int ei_lba, struct scatterlist *psg, int psg_off)
 {
-	struct se_device *dev = cmd->se_dev;
+	struct target_iomem *iomem = ios->iomem;
+	struct se_device *dev = ios->se_dev;
 	struct t10_pi_tuple *sdt;
-	struct scatterlist *dsg = cmd->t_iomem.t_data_sg;
+	struct scatterlist *dsg = iomem->t_data_sg;
 	sector_t sector = start;
 	void *daddr, *paddr;
 	int i;
@@ -1488,11 +1489,11 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 				dsg_off += block_size;
 			}
 
-			rc = sbc_dif_v1_verify(cmd, sdt, crc, sector, ei_lba);
+			rc = sbc_dif_v1_verify(ios, sdt, crc, sector, ei_lba);
 			if (rc) {
 				kunmap_atomic(daddr - dsg->offset);
 				kunmap_atomic(paddr - psg->offset);
-				cmd->t_iostate.bad_sector = sector;
+				ios->bad_sector = sector;
 				return rc;
 			}
 next:
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b6a3543..d588759 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1815,8 +1815,11 @@ err:
 	transport_generic_request_failure(cmd, ret);
 }
 
+// XXX: Convert target_write_prot_action to target_iostate
 static int target_write_prot_action(struct se_cmd *cmd)
 {
+	struct target_iostate *ios = &cmd->t_iostate;
+	struct target_iomem *iomem = ios->iomem;
 	u32 sectors;
 	/*
 	 * Perform WRITE_INSERT of PI using software emulation when backend
@@ -1833,8 +1836,8 @@ static int target_write_prot_action(struct se_cmd *cmd)
 			break;
 
 		sectors = cmd->t_iostate.data_length >> ilog2(cmd->se_dev->dev_attrib.block_size);
-		cmd->pi_err = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba,
-					     sectors, 0, cmd->t_iomem.t_prot_sg, 0);
+		cmd->pi_err = sbc_dif_verify(ios, ios->t_task_lba,
+					     sectors, 0, iomem->t_prot_sg, 0);
 		if (unlikely(cmd->pi_err)) {
 			spin_lock_irq(&cmd->t_state_lock);
 			cmd->transport_state &= ~(CMD_T_BUSY|CMD_T_SENT);
@@ -2055,17 +2058,21 @@ static void transport_handle_queue_full(
 	schedule_work(&cmd->se_dev->qf_work_queue);
 }
 
+// XXX: Convert target_read_prot_action to target_iostate
 static bool target_read_prot_action(struct se_cmd *cmd)
 {
+	struct target_iostate *ios = &cmd->t_iostate;
+	struct target_iomem *iomem = ios->iomem;
+
 	switch (cmd->t_iostate.prot_op) {
 	case TARGET_PROT_DIN_STRIP:
 		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_STRIP)) {
 			u32 sectors = cmd->t_iostate.data_length >>
 				  ilog2(cmd->se_dev->dev_attrib.block_size);
 
-			cmd->pi_err = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba,
+			cmd->pi_err = sbc_dif_verify(ios, ios->t_task_lba,
 						     sectors, 0,
-						     cmd->t_iomem.t_prot_sg, 0);
+						     iomem->t_prot_sg, 0);
 			if (cmd->pi_err)
 				return true;
 		}
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index f2d593f..5859ea5 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -71,7 +71,7 @@ u32	sbc_get_device_rev(struct se_device *dev);
 u32	sbc_get_device_type(struct se_device *dev);
 sector_t	sbc_get_write_same_sectors(struct se_cmd *cmd);
 void	sbc_dif_generate(struct se_cmd *);
-sense_reason_t	sbc_dif_verify(struct se_cmd *, sector_t, unsigned int,
+sense_reason_t	sbc_dif_verify(struct target_iostate *, sector_t, unsigned int,
 				     unsigned int, struct scatterlist *, int);
 void sbc_dif_copy_prot(struct target_iomem *, unsigned int, bool,
 		       struct scatterlist *, int, u32);
-- 
1.9.1

