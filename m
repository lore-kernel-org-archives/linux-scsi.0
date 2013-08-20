From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 6/9] target: Allow sbc_ops->execute_rw() to accept SGLs + data_direction
Date: Tue, 20 Aug 2013 20:07:57 +0000
Message-ID: <1377029280-19144-7-git-send-email-nab@daterainc.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

COMPARE_AND_WRITE expects to be able to send down a DMA_FROM_DEVICE
to obtain the necessary READ payload for comparision against the
first half of the WRITE payload containing the verify user data.

Currently virtual backends expect to internally reference SGLs,
SGL nents, and data_direction, so change IBLOCK, FILEIO and RD
sbc_ops->execute_rw() to accept this values as function parameters.

Also add the sbc_execute_rw() wrapper to handle the special case
for the initial COMPARE_AND_WRITE DMA_FROM_DEVICE -> READ I/O
submission.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_file.c    |    6 ++--
 drivers/target/target_core_iblock.c  |    6 ++--
 drivers/target/target_core_rd.c      |    6 ++--
 drivers/target/target_core_sbc.c     |   53 +++++++++++++++++++++++++++-------
 include/target/target_core_backend.h |    3 +-
 include/target/target_core_base.h    |    3 ++
 6 files changed, 54 insertions(+), 23 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index bc3245d..c5448a5 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -547,11 +547,9 @@ fd_execute_unmap(struct se_cmd *cmd)
 }
 
 static sense_reason_t
-fd_execute_rw(struct se_cmd *cmd)
+fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
+	      enum dma_data_direction data_direction)
 {
-	struct scatterlist *sgl = cmd->t_data_sg;
-	u32 sgl_nents = cmd->t_data_nents;
-	enum dma_data_direction data_direction = cmd->data_direction;
 	struct se_device *dev = cmd->se_dev;
 	int ret = 0;
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 0a460f3..81464eb 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -587,11 +587,9 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
 }
 
 static sense_reason_t
-iblock_execute_rw(struct se_cmd *cmd)
+iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
+		  enum dma_data_direction data_direction)
 {
-	struct scatterlist *sgl = cmd->t_data_sg;
-	u32 sgl_nents = cmd->t_data_nents;
-	enum dma_data_direction data_direction = cmd->data_direction;
 	struct se_device *dev = cmd->se_dev;
 	struct iblock_req *ibr;
 	struct bio *bio;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 51127d1..958d17ad 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -280,11 +280,9 @@ static struct rd_dev_sg_table *rd_get_sg_table(struct rd_dev *rd_dev, u32 page)
 }
 
 static sense_reason_t
-rd_execute_rw(struct se_cmd *cmd)
+rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
+	      enum dma_data_direction data_direction)
 {
-	struct scatterlist *sgl = cmd->t_data_sg;
-	u32 sgl_nents = cmd->t_data_nents;
-	enum dma_data_direction data_direction = cmd->data_direction;
 	struct se_device *se_dev = cmd->se_dev;
 	struct rd_dev *dev = RD_DEV(se_dev);
 	struct rd_dev_sg_table *table;
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index be5234a..e98581a 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -337,6 +337,29 @@ out:
 	return ret;
 }
 
+static sense_reason_t
+sbc_execute_rw(struct se_cmd *cmd)
+{
+	struct scatterlist *sgl;
+	u32 sgl_nents;
+	enum dma_data_direction data_direction;
+	/*
+	 * Submit READ first for COMPARE_AND_WRITE..
+	 */
+	if (cmd->t_task_cdb[0] == COMPARE_AND_WRITE &&
+	    !(cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE_POST)) {
+		sgl = cmd->t_bidi_data_sg;
+		sgl_nents = cmd->t_bidi_data_nents;
+		data_direction = DMA_FROM_DEVICE;
+	} else {
+		sgl = cmd->t_data_sg;
+		sgl_nents = cmd->t_data_nents;
+		data_direction = cmd->data_direction;
+	}
+
+	return cmd->execute_rw(cmd, sgl, sgl_nents, data_direction);
+}
+
 sense_reason_t
 sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 {
@@ -351,31 +374,36 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_6(cdb);
 		cmd->t_task_lba = transport_lba_21(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-		cmd->execute_cmd = ops->execute_rw;
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case READ_10:
 		sectors = transport_get_sectors_10(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-		cmd->execute_cmd = ops->execute_rw;
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case READ_12:
 		sectors = transport_get_sectors_12(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-		cmd->execute_cmd = ops->execute_rw;
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case READ_16:
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-		cmd->execute_cmd = ops->execute_rw;
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case WRITE_6:
 		sectors = transport_get_sectors_6(cdb);
 		cmd->t_task_lba = transport_lba_21(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-		cmd->execute_cmd = ops->execute_rw;
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case WRITE_10:
 	case WRITE_VERIFY:
@@ -384,7 +412,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (cdb[1] & 0x8)
 			cmd->se_cmd_flags |= SCF_FUA;
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-		cmd->execute_cmd = ops->execute_rw;
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case WRITE_12:
 		sectors = transport_get_sectors_12(cdb);
@@ -392,7 +421,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (cdb[1] & 0x8)
 			cmd->se_cmd_flags |= SCF_FUA;
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-		cmd->execute_cmd = ops->execute_rw;
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case WRITE_16:
 		sectors = transport_get_sectors_16(cdb);
@@ -400,7 +430,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		if (cdb[1] & 0x8)
 			cmd->se_cmd_flags |= SCF_FUA;
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-		cmd->execute_cmd = ops->execute_rw;
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case XDWRITEREAD_10:
 		if (cmd->data_direction != DMA_TO_DEVICE ||
@@ -414,7 +445,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		/*
 		 * Setup BIDI XOR callback to be run after I/O completion.
 		 */
-		cmd->execute_cmd = ops->execute_rw;
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_execute_rw;
 		cmd->transport_complete_callback = &xdreadwrite_callback;
 		if (cdb[1] & 0x8)
 			cmd->se_cmd_flags |= SCF_FUA;
@@ -437,7 +469,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			 * Setup BIDI XOR callback to be run during after I/O
 			 * completion.
 			 */
-			cmd->execute_cmd = ops->execute_rw;
+			cmd->execute_rw = ops->execute_rw;
+			cmd->execute_cmd = sbc_execute_rw;
 			cmd->transport_complete_callback = &xdreadwrite_callback;
 			if (cdb[1] & 0x8)
 				cmd->se_cmd_flags |= SCF_FUA;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index ffa2696..77f25e0 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -39,7 +39,8 @@ struct se_subsystem_api {
 };
 
 struct sbc_ops {
-	sense_reason_t (*execute_rw)(struct se_cmd *cmd);
+	sense_reason_t (*execute_rw)(struct se_cmd *cmd, struct scatterlist *,
+				     u32, enum dma_data_direction);
 	sense_reason_t (*execute_sync_cache)(struct se_cmd *cmd);
 	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
 	sense_reason_t (*execute_write_same_unmap)(struct se_cmd *cmd);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index fac25c5..e1e0843 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -159,6 +159,7 @@ enum se_cmd_flags_table {
 	SCF_ALUA_NON_OPTIMIZED		= 0x00008000,
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00020000,
 	SCF_ACK_KREF			= 0x00040000,
+	SCF_COMPARE_AND_WRITE_POST	= 0x00080000,
 };
 
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
@@ -448,6 +449,8 @@ struct se_cmd {
 	struct kref		cmd_kref;
 	struct target_core_fabric_ops *se_tfo;
 	sense_reason_t		(*execute_cmd)(struct se_cmd *);
+	sense_reason_t		(*execute_rw)(struct se_cmd *, struct scatterlist *,
+					      u32, enum dma_data_direction);
 	sense_reason_t (*transport_complete_callback)(struct se_cmd *);
 
 	unsigned char		*t_task_cdb;
-- 
1.7.10.4
