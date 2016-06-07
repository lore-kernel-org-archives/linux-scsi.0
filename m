From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 11/16] target/sbc: Convert sbc_ops->execute_sync_cache to target_iostate
Date: Tue,  7 Jun 2016 04:12:36 +0000
Message-ID: <1465272761-26045-12-git-send-email-nab@linux-iscsi.org>
References: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55978 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbcFGENn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2016 00:13:43 -0400
In-Reply-To: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch convert IBLOCK + FILEIO for sbc_ops->execute_sync_cache()
to accept struct target_iostate, and avoid backend driver sync_cache
SCSI CDB decoding for immediate as reported by HCH.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c    | 19 +++++++++----------
 drivers/target/target_core_iblock.c  | 17 ++++++++---------
 drivers/target/target_core_sbc.c     |  6 ++++--
 include/target/target_core_backend.h |  2 +-
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index ed94969..6fc1099 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -309,11 +309,10 @@ static int fd_do_rw(struct target_iostate *ios, struct file *fd,
 }
 
 static sense_reason_t
-fd_execute_sync_cache(struct se_cmd *cmd)
+fd_execute_sync_cache(struct target_iostate *ios, bool immed)
 {
-	struct se_device *dev = cmd->se_dev;
+	struct se_device *dev = ios->se_dev;
 	struct fd_dev *fd_dev = FD_DEV(dev);
-	int immed = (cmd->t_task_cdb[1] & 0x2);
 	loff_t start, end;
 	int ret;
 
@@ -322,18 +321,18 @@ fd_execute_sync_cache(struct se_cmd *cmd)
 	 * for this SYNCHRONIZE_CACHE op
 	 */
 	if (immed)
-		target_complete_cmd(cmd, SAM_STAT_GOOD);
+		ios->t_comp_func(ios, SAM_STAT_GOOD);
 
 	/*
 	 * Determine if we will be flushing the entire device.
 	 */
-	if (cmd->t_iostate.t_task_lba == 0 && cmd->t_iostate.data_length == 0) {
+	if (ios->t_task_lba == 0 && ios->data_length == 0) {
 		start = 0;
 		end = LLONG_MAX;
 	} else {
-		start = cmd->t_iostate.t_task_lba * dev->dev_attrib.block_size;
-		if (cmd->t_iostate.data_length)
-			end = start + cmd->t_iostate.data_length - 1;
+		start = ios->t_task_lba * dev->dev_attrib.block_size;
+		if (ios->data_length)
+			end = start + ios->data_length - 1;
 		else
 			end = LLONG_MAX;
 	}
@@ -346,9 +345,9 @@ fd_execute_sync_cache(struct se_cmd *cmd)
 		return 0;
 
 	if (ret)
-		target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION);
+		ios->t_comp_func(ios, SAM_STAT_CHECK_CONDITION);
 	else
-		target_complete_cmd(cmd, SAM_STAT_GOOD);
+		ios->t_comp_func(ios, SAM_STAT_GOOD);
 
 	return 0;
 }
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index daf052d..931dd7d 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -351,16 +351,16 @@ static void iblock_submit_bios(struct bio_list *list, int rw)
 
 static void iblock_end_io_flush(struct bio *bio)
 {
-	struct se_cmd *cmd = bio->bi_private;
+	struct target_iostate *ios = bio->bi_private;
 
 	if (bio->bi_error)
 		pr_err("IBLOCK: cache flush failed: %d\n", bio->bi_error);
 
-	if (cmd) {
+	if (ios) {
 		if (bio->bi_error)
-			target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION);
+			ios->t_comp_func(ios, SAM_STAT_CHECK_CONDITION);
 		else
-			target_complete_cmd(cmd, SAM_STAT_GOOD);
+			ios->t_comp_func(ios, SAM_STAT_GOOD);
 	}
 
 	bio_put(bio);
@@ -371,10 +371,9 @@ static void iblock_end_io_flush(struct bio *bio)
  * always flush the whole cache.
  */
 static sense_reason_t
-iblock_execute_sync_cache(struct se_cmd *cmd)
+iblock_execute_sync_cache(struct target_iostate *ios, bool immed)
 {
-	struct iblock_dev *ib_dev = IBLOCK_DEV(cmd->se_dev);
-	int immed = (cmd->t_task_cdb[1] & 0x2);
+	struct iblock_dev *ib_dev = IBLOCK_DEV(ios->se_dev);
 	struct bio *bio;
 
 	/*
@@ -382,13 +381,13 @@ iblock_execute_sync_cache(struct se_cmd *cmd)
 	 * for this SYNCHRONIZE_CACHE op.
 	 */
 	if (immed)
-		target_complete_cmd(cmd, SAM_STAT_GOOD);
+		ios->t_comp_func(ios, SAM_STAT_GOOD);
 
 	bio = bio_alloc(GFP_KERNEL, 0);
 	bio->bi_end_io = iblock_end_io_flush;
 	bio->bi_bdev = ib_dev->ibd_bd;
 	if (!immed)
-		bio->bi_private = cmd;
+		bio->bi_private = ios;
 	submit_bio(WRITE_FLUSH, bio);
 	return 0;
 }
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 649a3f2..be8dd46 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -463,12 +463,14 @@ sbc_execute_rw(struct target_iostate *ios)
 			       cmd->t_iostate.data_direction, fua_write, &target_complete_ios);
 }
 
-static sense_reason_t sbc_execute_sync_cache(struct target_iostate *ios)
+static sense_reason_t
+sbc_execute_sync_cache(struct target_iostate *ios)
 {
 	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct sbc_ops *ops = cmd->protocol_data;
+	bool immed = (cmd->t_task_cdb[1] & 0x2);
 
-	return ops->execute_sync_cache(cmd);
+	return ops->execute_sync_cache(ios, immed);
 }
 
 static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 5859ea5..47fd1fc 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -48,7 +48,7 @@ struct sbc_ops {
 	sense_reason_t (*execute_rw)(struct target_iostate *ios, struct scatterlist *,
 				     u32, enum dma_data_direction, bool fua_write,
 				     void (*t_comp_func)(struct target_iostate *ios, u16));
-	sense_reason_t (*execute_sync_cache)(struct se_cmd *cmd);
+	sense_reason_t (*execute_sync_cache)(struct target_iostate *ios, bool immed);
 	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
 	sense_reason_t (*execute_unmap)(struct se_cmd *cmd,
 				sector_t lba, sector_t nolb);
-- 
1.9.1

