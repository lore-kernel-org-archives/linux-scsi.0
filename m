From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 07/16] target/sbc: Convert sbc_ops->execute_rw to target_iostate
Date: Tue,  7 Jun 2016 04:12:32 +0000
Message-ID: <1465272761-26045-8-git-send-email-nab@linux-iscsi.org>
References: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Convert IBLOCK, FILEIO and RD to use target_iostate.

This includes converting sbc_ops->execute_rw() to accept a
function pointer callback:

    void (*t_comp_func)(struct target_iostate *, u16))

As well as a 'bool fua_write' flag for signaling forced
unit-access to IBLOCK and FILEIO backends.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c    | 72 +++++++++++++++++++-----------------
 drivers/target/target_core_iblock.c  | 65 +++++++++++++++++---------------
 drivers/target/target_core_rd.c      | 22 ++++++-----
 drivers/target/target_core_sbc.c     | 11 ++++--
 include/target/target_core_backend.h |  5 ++-
 5 files changed, 96 insertions(+), 79 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index c865e45..bc82018 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -246,7 +246,7 @@ static void fd_free_device(struct se_device *dev)
 	call_rcu(&dev->rcu_head, fd_dev_call_rcu);
 }
 
-static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
+static int fd_do_rw(struct target_iostate *ios, struct file *fd,
 		    u32 block_size, struct scatterlist *sgl,
 		    u32 sgl_nents, u32 data_length, int is_write)
 {
@@ -254,7 +254,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
 	struct iov_iter iter;
 	struct bio_vec *bvec;
 	ssize_t len = 0;
-	loff_t pos = (cmd->t_iostate.t_task_lba * block_size);
+	loff_t pos = (ios->t_task_lba * block_size);
 	int ret = 0, i;
 
 	bvec = kcalloc(sgl_nents, sizeof(struct bio_vec), GFP_KERNEL);
@@ -508,23 +508,27 @@ fd_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 }
 
 static sense_reason_t
-fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
-	      enum dma_data_direction data_direction)
+fd_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_nents,
+	      enum dma_data_direction data_direction, bool fua_write,
+	      void (*t_comp_func)(struct target_iostate *, u16))
 {
-	struct se_device *dev = cmd->se_dev;
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
+	struct target_iomem *iomem = ios->iomem;
+	struct se_device *dev = ios->se_dev;
 	struct fd_dev *fd_dev = FD_DEV(dev);
 	struct file *file = fd_dev->fd_file;
 	struct file *pfile = fd_dev->fd_prot_file;
 	sense_reason_t rc;
 	int ret = 0;
+
 	/*
 	 * We are currently limited by the number of iovecs (2048) per
 	 * single vfs_[writev,readv] call.
 	 */
-	if (cmd->t_iostate.data_length > FD_MAX_BYTES) {
+	if (ios->data_length > FD_MAX_BYTES) {
 		pr_err("FILEIO: Not able to process I/O of %u bytes due to"
 		       "FD_MAX_BYTES: %u iovec count limitiation\n",
-			cmd->t_iostate.data_length, FD_MAX_BYTES);
+			ios->data_length, FD_MAX_BYTES);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	/*
@@ -532,63 +536,63 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	 * physical memory addresses to struct iovec virtual memory.
 	 */
 	if (data_direction == DMA_FROM_DEVICE) {
-		if (cmd->t_iostate.prot_type && dev->dev_attrib.pi_prot_type) {
-			ret = fd_do_rw(cmd, pfile, dev->prot_length,
-				       cmd->t_iomem.t_prot_sg,
-				       cmd->t_iomem.t_prot_nents,
-				       cmd->t_iostate.prot_length, 0);
+		if (ios->prot_type && dev->dev_attrib.pi_prot_type) {
+			ret = fd_do_rw(ios, pfile, dev->prot_length,
+				       iomem->t_prot_sg,
+				       iomem->t_prot_nents,
+				       ios->prot_length, 0);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 
-		ret = fd_do_rw(cmd, file, dev->dev_attrib.block_size,
-			       sgl, sgl_nents, cmd->t_iostate.data_length, 0);
+		ret = fd_do_rw(ios, file, dev->dev_attrib.block_size,
+			       sgl, sgl_nents, ios->data_length, 0);
 
-		if (ret > 0 && cmd->t_iostate.prot_type && dev->dev_attrib.pi_prot_type) {
-			u32 sectors = cmd->t_iostate.data_length >>
+		if (ret > 0 && ios->prot_type && dev->dev_attrib.pi_prot_type) {
+			u32 sectors = ios->data_length >>
 					ilog2(dev->dev_attrib.block_size);
 
-			rc = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba, sectors,
-					    0, cmd->t_iomem.t_prot_sg, 0);
+			rc = sbc_dif_verify(cmd, ios->t_task_lba, sectors,
+					    0, iomem->t_prot_sg, 0);
 			if (rc)
 				return rc;
 		}
 	} else {
-		if (cmd->t_iostate.prot_type && dev->dev_attrib.pi_prot_type) {
-			u32 sectors = cmd->t_iostate.data_length >>
+		if (ios->prot_type && dev->dev_attrib.pi_prot_type) {
+			u32 sectors = ios->data_length >>
 					ilog2(dev->dev_attrib.block_size);
 
-			rc = sbc_dif_verify(cmd, cmd->t_iostate.t_task_lba, sectors,
-					    0, cmd->t_iomem.t_prot_sg, 0);
+			rc = sbc_dif_verify(cmd, ios->t_task_lba, sectors,
+					    0, iomem->t_prot_sg, 0);
 			if (rc)
 				return rc;
 		}
 
-		ret = fd_do_rw(cmd, file, dev->dev_attrib.block_size,
-			       sgl, sgl_nents, cmd->t_iostate.data_length, 1);
+		ret = fd_do_rw(ios, file, dev->dev_attrib.block_size,
+			       sgl, sgl_nents, ios->data_length, 1);
 		/*
 		 * Perform implicit vfs_fsync_range() for fd_do_writev() ops
 		 * for SCSI WRITEs with Forced Unit Access (FUA) set.
 		 * Allow this to happen independent of WCE=0 setting.
 		 */
-		if (ret > 0 && (cmd->se_cmd_flags & SCF_FUA)) {
-			loff_t start = cmd->t_iostate.t_task_lba *
+		if (ret > 0 && fua_write) {
+			loff_t start = ios->t_task_lba *
 				dev->dev_attrib.block_size;
 			loff_t end;
 
-			if (cmd->t_iostate.data_length)
-				end = start + cmd->t_iostate.data_length - 1;
+			if (ios->data_length)
+				end = start + ios->data_length - 1;
 			else
 				end = LLONG_MAX;
 
 			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 		}
 
-		if (ret > 0 && cmd->t_iostate.prot_type && dev->dev_attrib.pi_prot_type) {
-			ret = fd_do_rw(cmd, pfile, dev->prot_length,
-				       cmd->t_iomem.t_prot_sg,
-				       cmd->t_iomem.t_prot_nents,
-				       cmd->t_iostate.prot_length, 1);
+		if (ret > 0 && ios->prot_type && dev->dev_attrib.pi_prot_type) {
+			ret = fd_do_rw(ios, pfile, dev->prot_length,
+				       iomem->t_prot_sg,
+				       iomem->t_prot_nents,
+				       ios->prot_length, 1);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
@@ -598,7 +602,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	if (ret)
-		target_complete_cmd(cmd, SAM_STAT_GOOD);
+		ios->t_comp_func(ios, SAM_STAT_GOOD);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 0f45973..8e90ec42 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -275,9 +275,9 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 	return blocks_long;
 }
 
-static void iblock_complete_cmd(struct se_cmd *cmd)
+static void iblock_complete_cmd(struct target_iostate *ios)
 {
-	struct iblock_req *ibr = cmd->priv;
+	struct iblock_req *ibr = ios->priv;
 	u8 status;
 
 	if (!atomic_dec_and_test(&ibr->pending))
@@ -288,14 +288,16 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 	else
 		status = SAM_STAT_GOOD;
 
-	target_complete_cmd(cmd, status);
+	// XXX: ios status SAM completion translation
+	ios->t_comp_func(ios, status);
+
 	kfree(ibr);
 }
 
 static void iblock_bio_done(struct bio *bio)
 {
-	struct se_cmd *cmd = bio->bi_private;
-	struct iblock_req *ibr = cmd->priv;
+	struct target_iostate *ios = bio->bi_private;
+	struct iblock_req *ibr = ios->priv;
 
 	if (bio->bi_error) {
 		pr_err("bio error: %p,  err: %d\n", bio, bio->bi_error);
@@ -308,13 +310,15 @@ static void iblock_bio_done(struct bio *bio)
 
 	bio_put(bio);
 
-	iblock_complete_cmd(cmd);
+	iblock_complete_cmd(ios);
 }
 
+
+
 static struct bio *
-iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
+iblock_get_bio(struct target_iostate *ios, sector_t lba, u32 sg_num)
 {
-	struct iblock_dev *ib_dev = IBLOCK_DEV(cmd->se_dev);
+	struct iblock_dev *ib_dev = IBLOCK_DEV(ios->se_dev);
 	struct bio *bio;
 
 	/*
@@ -331,7 +335,7 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
 	}
 
 	bio->bi_bdev = ib_dev->ibd_bd;
-	bio->bi_private = cmd;
+	bio->bi_private = ios;
 	bio->bi_end_io = &iblock_bio_done;
 	bio->bi_iter.bi_sector = lba;
 
@@ -447,6 +451,7 @@ iblock_execute_write_same_direct(struct block_device *bdev, struct se_cmd *cmd)
 static sense_reason_t
 iblock_execute_write_same(struct se_cmd *cmd)
 {
+	struct target_iostate *ios = &cmd->t_iostate;
 	struct block_device *bdev = IBLOCK_DEV(cmd->se_dev)->ibd_bd;
 	struct iblock_req *ibr;
 	struct scatterlist *sg;
@@ -478,9 +483,9 @@ iblock_execute_write_same(struct se_cmd *cmd)
 	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
 	if (!ibr)
 		goto fail;
-	cmd->priv = ibr;
+	ios->priv = ibr;
 
-	bio = iblock_get_bio(cmd, block_lba, 1);
+	bio = iblock_get_bio(ios, block_lba, 1);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -493,7 +498,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
 
-			bio = iblock_get_bio(cmd, block_lba, 1);
+			bio = iblock_get_bio(ios, block_lba, 1);
 			if (!bio)
 				goto fail_put_bios;
 
@@ -623,9 +628,10 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
 }
 
 static int
-iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
+iblock_alloc_bip(struct target_iostate *ios, struct target_iomem *iomem,
+		 struct bio *bio)
 {
-	struct se_device *dev = cmd->se_dev;
+	struct se_device *dev = ios->se_dev;
 	struct blk_integrity *bi;
 	struct bio_integrity_payload *bip;
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -638,20 +644,20 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
 		return -ENODEV;
 	}
 
-	bip = bio_integrity_alloc(bio, GFP_NOIO, cmd->t_iomem.t_prot_nents);
+	bip = bio_integrity_alloc(bio, GFP_NOIO, iomem->t_prot_nents);
 	if (IS_ERR(bip)) {
 		pr_err("Unable to allocate bio_integrity_payload\n");
 		return PTR_ERR(bip);
 	}
 
-	bip->bip_iter.bi_size = (cmd->t_iostate.data_length / dev->dev_attrib.block_size) *
+	bip->bip_iter.bi_size = (ios->data_length / dev->dev_attrib.block_size) *
 			 dev->prot_length;
 	bip->bip_iter.bi_sector = bio->bi_iter.bi_sector;
 
 	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
 		 (unsigned long long)bip->bip_iter.bi_sector);
 
-	for_each_sg(cmd->t_iomem.t_prot_sg, sg, cmd->t_iomem.t_prot_nents, i) {
+	for_each_sg(iomem->t_prot_sg, sg, iomem->t_prot_nents, i) {
 
 		rc = bio_integrity_add_page(bio, sg_page(sg), sg->length,
 					    sg->offset);
@@ -668,11 +674,12 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
 }
 
 static sense_reason_t
-iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
-		  enum dma_data_direction data_direction)
+iblock_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_nents,
+		  enum dma_data_direction data_direction, bool fua_write,
+		  void (*t_comp_func)(struct target_iostate *ios, u16))
 {
-	struct se_device *dev = cmd->se_dev;
-	sector_t block_lba = target_to_linux_sector(dev, cmd->t_iostate.t_task_lba);
+	struct se_device *dev = ios->se_dev;
+	sector_t block_lba = target_to_linux_sector(dev, ios->t_task_lba);
 	struct iblock_req *ibr;
 	struct bio *bio, *bio_start;
 	struct bio_list list;
@@ -690,7 +697,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		 * is not enabled, or if initiator set the Force Unit Access bit.
 		 */
 		if (test_bit(QUEUE_FLAG_FUA, &q->queue_flags)) {
-			if (cmd->se_cmd_flags & SCF_FUA)
+			if (fua_write)
 				rw = WRITE_FUA;
 			else if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
 				rw = WRITE_FUA;
@@ -706,15 +713,15 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
 	if (!ibr)
 		goto fail;
-	cmd->priv = ibr;
+	ios->priv = ibr;
 
 	if (!sgl_nents) {
 		atomic_set(&ibr->pending, 1);
-		iblock_complete_cmd(cmd);
+		iblock_complete_cmd(ios);
 		return 0;
 	}
 
-	bio = iblock_get_bio(cmd, block_lba, sgl_nents);
+	bio = iblock_get_bio(ios, block_lba, sgl_nents);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -738,7 +745,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 				bio_cnt = 0;
 			}
 
-			bio = iblock_get_bio(cmd, block_lba, sg_num);
+			bio = iblock_get_bio(ios, block_lba, sg_num);
 			if (!bio)
 				goto fail_put_bios;
 
@@ -752,14 +759,14 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		sg_num--;
 	}
 
-	if (cmd->t_iostate.prot_type && dev->dev_attrib.pi_prot_type) {
-		int rc = iblock_alloc_bip(cmd, bio_start);
+	if (ios->prot_type && dev->dev_attrib.pi_prot_type) {
+		int rc = iblock_alloc_bip(ios, ios->iomem, bio_start);
 		if (rc)
 			goto fail_put_bios;
 	}
 
 	iblock_submit_bios(&list, rw);
-	iblock_complete_cmd(cmd);
+	iblock_complete_cmd(ios);
 	return 0;
 
 fail_put_bios:
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 4edd3e0..df8bd58 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -435,10 +435,12 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_read)
 }
 
 static sense_reason_t
-rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
-	      enum dma_data_direction data_direction)
+rd_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_nents,
+	      enum dma_data_direction data_direction, bool fua_write,
+	      void (*t_comp_func)(struct target_iostate *, u16))
 {
-	struct se_device *se_dev = cmd->se_dev;
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
+	struct se_device *se_dev = ios->se_dev;
 	struct rd_dev *dev = RD_DEV(se_dev);
 	struct rd_dev_sg_table *table;
 	struct scatterlist *rd_sg;
@@ -451,14 +453,14 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	sense_reason_t rc;
 
 	if (dev->rd_flags & RDF_NULLIO) {
-		target_complete_cmd(cmd, SAM_STAT_GOOD);
+		(*t_comp_func)(ios, SAM_STAT_GOOD);
 		return 0;
 	}
 
-	tmp = cmd->t_iostate.t_task_lba * se_dev->dev_attrib.block_size;
+	tmp = ios->t_task_lba * se_dev->dev_attrib.block_size;
 	rd_offset = do_div(tmp, PAGE_SIZE);
 	rd_page = tmp;
-	rd_size = cmd->t_iostate.data_length;
+	rd_size = ios->data_length;
 
 	table = rd_get_sg_table(dev, rd_page);
 	if (!table)
@@ -469,9 +471,9 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	pr_debug("RD[%u]: %s LBA: %llu, Size: %u Page: %u, Offset: %u\n",
 			dev->rd_dev_id,
 			data_direction == DMA_FROM_DEVICE ? "Read" : "Write",
-			cmd->t_iostate.t_task_lba, rd_size, rd_page, rd_offset);
+			ios->t_task_lba, rd_size, rd_page, rd_offset);
 
-	if (cmd->t_iostate.prot_type && se_dev->dev_attrib.pi_prot_type &&
+	if (ios->prot_type && se_dev->dev_attrib.pi_prot_type &&
 	    data_direction == DMA_TO_DEVICE) {
 		rc = rd_do_prot_rw(cmd, false);
 		if (rc)
@@ -539,14 +541,14 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	}
 	sg_miter_stop(&m);
 
-	if (cmd->t_iostate.prot_type && se_dev->dev_attrib.pi_prot_type &&
+	if (ios->prot_type && se_dev->dev_attrib.pi_prot_type &&
 	    data_direction == DMA_FROM_DEVICE) {
 		rc = rd_do_prot_rw(cmd, true);
 		if (rc)
 			return rc;
 	}
 
-	target_complete_cmd(cmd, SAM_STAT_GOOD);
+	(*t_comp_func)(ios, SAM_STAT_GOOD);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 2095f78..e1288de 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -457,9 +457,10 @@ sbc_execute_rw(struct target_iostate *ios)
 {
 	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct sbc_ops *ops = cmd->protocol_data;
+	bool fua_write = (cmd->se_cmd_flags & SCF_FUA);
 
-	return ops->execute_rw(cmd, cmd->t_iomem.t_data_sg, cmd->t_iomem.t_data_nents,
-			       cmd->t_iostate.data_direction);
+	return ops->execute_rw(ios, cmd->t_iomem.t_data_sg, cmd->t_iomem.t_data_nents,
+			       cmd->t_iostate.data_direction, fua_write, &target_complete_ios);
 }
 
 static sense_reason_t sbc_execute_sync_cache(struct target_iostate *ios)
@@ -654,6 +655,7 @@ sbc_compare_and_write(struct target_iostate *ios)
 	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct sbc_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
+	bool fua_write = (cmd->se_cmd_flags & SCF_FUA);
 	sense_reason_t ret;
 	int rc;
 	/*
@@ -673,8 +675,9 @@ sbc_compare_and_write(struct target_iostate *ios)
 	cmd->t_iostate.data_length = cmd->t_iostate.t_task_nolb *
 				     dev->dev_attrib.block_size;
 
-	ret = ops->execute_rw(cmd, cmd->t_iomem.t_bidi_data_sg,
-			      cmd->t_iomem.t_bidi_data_nents, DMA_FROM_DEVICE);
+	ret = ops->execute_rw(ios, cmd->t_iomem.t_bidi_data_sg,
+			      cmd->t_iomem.t_bidi_data_nents, DMA_FROM_DEVICE,
+			      fua_write, &target_complete_ios);
 	if (ret) {
 		cmd->transport_complete_callback = NULL;
 		up(&dev->caw_sem);
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 4a57477..ade90b7 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -45,8 +45,9 @@ struct target_backend_ops {
 };
 
 struct sbc_ops {
-	sense_reason_t (*execute_rw)(struct se_cmd *cmd, struct scatterlist *,
-				     u32, enum dma_data_direction);
+	sense_reason_t (*execute_rw)(struct target_iostate *ios, struct scatterlist *,
+				     u32, enum dma_data_direction, bool fua_write,
+				     void (*t_comp_func)(struct target_iostate *ios, u16));
 	sense_reason_t (*execute_sync_cache)(struct se_cmd *cmd);
 	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
 	sense_reason_t (*execute_unmap)(struct se_cmd *cmd,
-- 
1.9.1
