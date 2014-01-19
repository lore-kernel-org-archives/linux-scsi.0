From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 13/17] target/file: Add DIF protection support to fd_execute_rw
Date: Sun, 19 Jan 2014 02:44:36 +0000
Message-ID: <1390099480-29013-14-git-send-email-nab@daterainc.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for DIF protection into fd_execute_rw() code
for WRITE/READ I/O using sbc_dif_verify_[write,read]() logic.

It adds fd_do_prot_rw() for handling interface with FILEIO PI, and
uses a locally allocated fd_prot->prot_buf + fd_prot->prot_sg for
interacting with SBC DIF verify emulation code.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |  119 ++++++++++++++++++++++++++++++++++++-
 drivers/target/target_core_file.h |    5 ++
 2 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 119d519..aaba7c5 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -257,6 +257,72 @@ static void fd_free_device(struct se_device *dev)
 	kfree(fd_dev);
 }
 
+static int fd_do_prot_rw(struct se_cmd *cmd, struct fd_prot *fd_prot,
+			 int is_write)
+{
+	struct se_device *se_dev = cmd->se_dev;
+	struct fd_dev *dev = FD_DEV(se_dev);
+	struct file *prot_fd = dev->fd_prot_file;
+	struct scatterlist *sg;
+	loff_t pos = (cmd->t_task_lba * se_dev->prot_length);
+	unsigned char *buf;
+	u32 prot_size, len, size;
+	int rc, ret = 1, i;
+
+	prot_size = (cmd->data_length / se_dev->dev_attrib.block_size) *
+		     se_dev->prot_length;
+
+	if (!is_write) {
+		fd_prot->prot_buf = vzalloc(prot_size);
+		if (!fd_prot->prot_buf) {
+			pr_err("Unable to allocate fd_prot->prot_buf\n");
+			return -ENOMEM;
+		}
+		buf = fd_prot->prot_buf;
+
+		fd_prot->prot_sg_nents = cmd->t_prot_nents;
+		fd_prot->prot_sg = kzalloc(sizeof(struct scatterlist) *
+					   fd_prot->prot_sg_nents, GFP_KERNEL);
+		if (!fd_prot->prot_sg) {
+			pr_err("Unable to allocate fd_prot->prot_sg\n");
+			vfree(fd_prot->prot_buf);
+			return -ENOMEM;
+		}
+		size = prot_size;
+
+		for_each_sg(fd_prot->prot_sg, sg, fd_prot->prot_sg_nents, i) {
+
+			len = min_t(u32, PAGE_SIZE, size);
+			sg_set_buf(sg, buf, len);
+			size -= len;
+			buf += len;
+		}
+	}
+
+	if (is_write) {
+		rc = kernel_write(prot_fd, fd_prot->prot_buf, prot_size, pos);
+		if (rc < 0 || prot_size != rc) {
+			pr_err("kernel_write() for fd_do_prot_rw failed:"
+			       " %d\n", rc);
+			ret = -EINVAL;
+		}
+	} else {
+		rc = kernel_read(prot_fd, pos, fd_prot->prot_buf, prot_size);
+		if (rc < 0) {
+			pr_err("kernel_read() for fd_do_prot_rw failed:"
+			       " %d\n", rc);
+			ret = -EINVAL;
+		}
+	}
+
+	if (is_write || ret < 0) {
+		kfree(fd_prot->prot_sg);
+		vfree(fd_prot->prot_buf);
+	}
+
+	return ret;
+}
+
 static int fd_do_rw(struct se_cmd *cmd, struct scatterlist *sgl,
 		u32 sgl_nents, int is_write)
 {
@@ -551,6 +617,8 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	      enum dma_data_direction data_direction)
 {
 	struct se_device *dev = cmd->se_dev;
+	struct fd_prot fd_prot;
+	sense_reason_t rc;
 	int ret = 0;
 
 	/*
@@ -558,8 +626,48 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	 * physical memory addresses to struct iovec virtual memory.
 	 */
 	if (data_direction == DMA_FROM_DEVICE) {
+		memset(&fd_prot, 0, sizeof(struct fd_prot));
+
+		if (cmd->prot_type) {
+			ret = fd_do_prot_rw(cmd, &fd_prot, false);
+			if (ret < 0)
+				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		}
+
 		ret = fd_do_rw(cmd, sgl, sgl_nents, 0);
+
+		if (ret > 0 && cmd->prot_type) {
+			u32 sectors = cmd->data_length / dev->dev_attrib.block_size;
+
+			rc = sbc_dif_verify_read(cmd, cmd->t_task_lba, sectors,
+						 0, fd_prot.prot_sg, 0);
+			if (rc) {
+				kfree(fd_prot.prot_sg);
+				vfree(fd_prot.prot_buf);
+				return rc;
+			}
+			kfree(fd_prot.prot_sg);
+			vfree(fd_prot.prot_buf);
+		}
 	} else {
+		memset(&fd_prot, 0, sizeof(struct fd_prot));
+
+		if (cmd->prot_type) {
+			u32 sectors = cmd->data_length / dev->dev_attrib.block_size;
+
+			ret = fd_do_prot_rw(cmd, &fd_prot, false);
+			if (ret < 0)
+				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+			rc = sbc_dif_verify_write(cmd, cmd->t_task_lba, sectors,
+						  0, fd_prot.prot_sg, 0);
+			if (rc) {
+				kfree(fd_prot.prot_sg);
+				vfree(fd_prot.prot_buf);
+				return rc;
+			}
+		}
+
 		ret = fd_do_rw(cmd, sgl, sgl_nents, 1);
 		/*
 		 * Perform implicit vfs_fsync_range() for fd_do_writev() ops
@@ -576,10 +684,19 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 		}
+
+		if (ret > 0 && cmd->prot_type) {
+			ret = fd_do_prot_rw(cmd, &fd_prot, true);
+			if (ret < 0)
+				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		}
 	}
 
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(fd_prot.prot_sg);
+		vfree(fd_prot.prot_buf);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
 
 	if (ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index 583691e..97e5e7d 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -18,6 +18,11 @@
 #define FDBD_HAS_BUFFERED_IO_WCE 0x04
 #define FDBD_FORMAT_UNIT_SIZE	2048
 
+struct fd_prot {
+	unsigned char	*prot_buf;
+	struct scatterlist *prot_sg;
+	u32 prot_sg_nents;
+};
 
 struct fd_dev {
 	struct se_device dev;
-- 
1.7.10.4
