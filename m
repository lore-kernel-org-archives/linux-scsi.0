From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH RFC 2/2] target/file: Remove fd_prot bounce buffer
Date: Mon, 13 Apr 2015 20:19:35 +0300
Message-ID: <1428945575-30839-3-git-send-email-sagig@mellanox.com>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Akinobu Mita <akinobu.mita@gmail.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

The reason this bounce buffer exists is to allow code
reuse between rd_mcp and fileio in DIF mode. But the fact is,
that this bounce is really not needed at all, we can simply call
sbc_dif_verify on cmd->t_prot_sg and use it for file IO.

This also removes fd_do_prot_rw as fd_do_rw was generalised
to receive file pointer, block size (8 bytes for DIF data) and
total data length.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/target_core_file.c |  140 +++++++-----------------------------
 drivers/target/target_core_file.h |    6 --
 2 files changed, 28 insertions(+), 118 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 3476397..d43638f 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -258,83 +258,15 @@ static void fd_free_device(struct se_device *dev)
 	kfree(fd_dev);
 }
 
-static int fd_do_prot_rw(struct se_cmd *cmd, struct fd_prot *fd_prot,
-			 int is_write)
+static int fd_do_rw(struct se_cmd *cmd, struct file *fd,
+		    u32 block_size, struct scatterlist *sgl,
+		    u32 sgl_nents, u32 data_length, int is_write)
 {
-	struct se_device *se_dev = cmd->se_dev;
-	struct fd_dev *dev = FD_DEV(se_dev);
-	struct file *prot_fd = dev->fd_prot_file;
-	struct scatterlist *sg;
-	loff_t pos = (cmd->t_task_lba * se_dev->prot_length);
-	unsigned char *buf;
-	u32 prot_size, len, size;
-	int rc, ret = 1, i;
-
-	prot_size = (cmd->data_length / se_dev->dev_attrib.block_size) *
-		     se_dev->prot_length;
-
-	if (!is_write) {
-		fd_prot->prot_buf = vzalloc(prot_size);
-		if (!fd_prot->prot_buf) {
-			pr_err("Unable to allocate fd_prot->prot_buf\n");
-			return -ENOMEM;
-		}
-		buf = fd_prot->prot_buf;
-
-		fd_prot->prot_sg_nents = cmd->t_prot_nents;
-		fd_prot->prot_sg = kzalloc(sizeof(struct scatterlist) *
-					   fd_prot->prot_sg_nents, GFP_KERNEL);
-		if (!fd_prot->prot_sg) {
-			pr_err("Unable to allocate fd_prot->prot_sg\n");
-			vfree(fd_prot->prot_buf);
-			return -ENOMEM;
-		}
-		size = prot_size;
-
-		for_each_sg(fd_prot->prot_sg, sg, fd_prot->prot_sg_nents, i) {
-
-			len = min_t(u32, PAGE_SIZE, size);
-			sg_set_buf(sg, buf, len);
-			size -= len;
-			buf += len;
-		}
-	}
-
-	if (is_write) {
-		rc = kernel_write(prot_fd, fd_prot->prot_buf, prot_size, pos);
-		if (rc < 0 || prot_size != rc) {
-			pr_err("kernel_write() for fd_do_prot_rw failed:"
-			       " %d\n", rc);
-			ret = -EINVAL;
-		}
-	} else {
-		rc = kernel_read(prot_fd, pos, fd_prot->prot_buf, prot_size);
-		if (rc < 0) {
-			pr_err("kernel_read() for fd_do_prot_rw failed:"
-			       " %d\n", rc);
-			ret = -EINVAL;
-		}
-	}
-
-	if (is_write || ret < 0) {
-		kfree(fd_prot->prot_sg);
-		vfree(fd_prot->prot_buf);
-	}
-
-	return ret;
-}
-
-static int fd_do_rw(struct se_cmd *cmd, struct scatterlist *sgl,
-		u32 sgl_nents, int is_write)
-{
-	struct se_device *se_dev = cmd->se_dev;
-	struct fd_dev *dev = FD_DEV(se_dev);
-	struct file *fd = dev->fd_file;
 	struct scatterlist *sg;
 	struct iov_iter iter;
 	struct bio_vec *bvec;
 	ssize_t len = 0;
-	loff_t pos = (cmd->t_task_lba * se_dev->dev_attrib.block_size);
+	loff_t pos = (cmd->t_task_lba * block_size);
 	int ret = 0, i;
 
 	bvec = kcalloc(sgl_nents, sizeof(struct bio_vec), GFP_KERNEL);
@@ -360,7 +292,7 @@ static int fd_do_rw(struct se_cmd *cmd, struct scatterlist *sgl,
 	kfree(bvec);
 
 	if (is_write) {
-		if (ret < 0 || ret != cmd->data_length) {
+		if (ret < 0 || ret != data_length) {
 			pr_err("%s() write returned %d\n", __func__, ret);
 			return (ret < 0 ? ret : -EINVAL);
 		}
@@ -371,10 +303,10 @@ static int fd_do_rw(struct se_cmd *cmd, struct scatterlist *sgl,
 		 * block_device.
 		 */
 		if (S_ISBLK(file_inode(fd)->i_mode)) {
-			if (ret < 0 || ret != cmd->data_length) {
+			if (ret < 0 || ret != data_length) {
 				pr_err("%s() returned %d, expecting %u for "
 						"S_ISBLK\n", __func__, ret,
-						cmd->data_length);
+						data_length);
 				return (ret < 0 ? ret : -EINVAL);
 			}
 		} else {
@@ -564,7 +496,9 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	      enum dma_data_direction data_direction)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct fd_prot fd_prot;
+	struct fd_dev *fd_dev = FD_DEV(dev);
+	struct file *file = fd_dev->fd_file;
+	struct file *pfile = fd_dev->fd_prot_file;
 	sense_reason_t rc;
 	int ret = 0;
 	/*
@@ -582,55 +516,39 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	 * physical memory addresses to struct iovec virtual memory.
 	 */
 	if (data_direction == DMA_FROM_DEVICE) {
-		memset(&fd_prot, 0, sizeof(struct fd_prot));
-
 		if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
-			ret = fd_do_prot_rw(cmd, &fd_prot, false);
+			ret = fd_do_rw(cmd, pfile, dev->prot_length,
+				       cmd->t_prot_sg, cmd->t_prot_nents,
+				       cmd->prot_length, 0);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 
-		ret = fd_do_rw(cmd, sgl, sgl_nents, 0);
+		ret = fd_do_rw(cmd, file, dev->dev_attrib.block_size,
+			       sgl, sgl_nents, cmd->data_length, 0);
 
 		if (ret > 0 && cmd->prot_type && dev->dev_attrib.pi_prot_type) {
-			u32 sectors = cmd->data_length / dev->dev_attrib.block_size;
+			u32 sectors = cmd->data_length >>
+					ilog2(dev->dev_attrib.block_size);
 
 			rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors,
-					    0, fd_prot.prot_sg, 0);
-			if (rc) {
-				kfree(fd_prot.prot_sg);
-				vfree(fd_prot.prot_buf);
+					    0, cmd->t_prot_sg, 0);
+			if (rc)
 				return rc;
-			} else {
-				sbc_dif_copy_prot(cmd, sectors, true,
-						  fd_prot.prot_sg, 0);
-			}
-			kfree(fd_prot.prot_sg);
-			vfree(fd_prot.prot_buf);
 		}
 	} else {
-		memset(&fd_prot, 0, sizeof(struct fd_prot));
-
 		if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
-			u32 sectors = cmd->data_length / dev->dev_attrib.block_size;
-
-			ret = fd_do_prot_rw(cmd, &fd_prot, false);
-			if (ret < 0)
-				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			u32 sectors = cmd->data_length >>
+					ilog2(dev->dev_attrib.block_size);
 
 			rc = sbc_dif_verify(cmd, cmd->t_task_lba, sectors,
 					    0, cmd->t_prot_sg, 0);
-			if (rc) {
-				kfree(fd_prot.prot_sg);
-				vfree(fd_prot.prot_buf);
+			if (rc)
 				return rc;
-			} else {
-				sbc_dif_copy_prot(cmd, sectors, false,
-						  fd_prot.prot_sg, 0);
-			}
 		}
 
-		ret = fd_do_rw(cmd, sgl, sgl_nents, 1);
+		ret = fd_do_rw(cmd, file, dev->dev_attrib.block_size,
+			       sgl, sgl_nents, cmd->data_length, 1);
 		/*
 		 * Perform implicit vfs_fsync_range() for fd_do_writev() ops
 		 * for SCSI WRITEs with Forced Unit Access (FUA) set.
@@ -639,7 +557,6 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		if (ret > 0 &&
 		    dev->dev_attrib.emulate_fua_write > 0 &&
 		    (cmd->se_cmd_flags & SCF_FUA)) {
-			struct fd_dev *fd_dev = FD_DEV(dev);
 			loff_t start = cmd->t_task_lba *
 				dev->dev_attrib.block_size;
 			loff_t end;
@@ -653,17 +570,16 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		}
 
 		if (ret > 0 && cmd->prot_type && dev->dev_attrib.pi_prot_type) {
-			ret = fd_do_prot_rw(cmd, &fd_prot, true);
+			ret = fd_do_rw(cmd, pfile, dev->prot_length,
+				       cmd->t_prot_sg, cmd->t_prot_nents,
+				       cmd->prot_length, 1);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
 	}
 
-	if (ret < 0) {
-		kfree(fd_prot.prot_sg);
-		vfree(fd_prot.prot_buf);
+	if (ret < 0)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-	}
 
 	if (ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index 182cbb2..068966f 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -21,12 +21,6 @@
 #define FDBD_HAS_BUFFERED_IO_WCE 0x04
 #define FDBD_FORMAT_UNIT_SIZE	2048
 
-struct fd_prot {
-	unsigned char	*prot_buf;
-	struct scatterlist *prot_sg;
-	u32 prot_sg_nents;
-};
-
 struct fd_dev {
 	struct se_device dev;
 
-- 
1.7.1
