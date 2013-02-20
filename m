From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target/file: Add WRITE_SAME w/ UNMAP=0 emulation support
Date: Wed, 20 Feb 2013 01:43:43 +0000
Message-ID: <1361324623-17041-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Asias He <asias@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi mkp, hch, & Co,

Please review this patch to add support for WRITE_SAME w/ UNMAP=0
emulation into FILEIO, as I'd really like to include this in the
upcoming for-3.9 target merge.

Thank you,

--nab

---------------------------------------------------------------------

This patch adds support for emulation of WRITE_SAME w/ UNMAP=0 within
fd_execute_write_same() backend code.

The emulation uses vfs_writev() to submit a locally populated buffer
from the received WRITE_SAME scatterlist block for duplication, and by
default enforces a limit of max_write_same_len=0x1000 (8192) sectors up
to the limit of 1024 iovec entries for the single call to vfs_writev().

It also sets max_write_same_len to the operational default at setup ->
fd_configure_device() time.

Tested with 512, 1k, 2k, and 4k block_sizes.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Asias He <asias@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |  115 +++++++++++++++++++++++++++++++++++++
 1 files changed, 115 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index b9c8849..0b71509 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -190,6 +190,11 @@ static int fd_configure_device(struct se_device *dev)
 
 	fd_dev->fd_dev_id = fd_host->fd_host_dev_id_count++;
 	fd_dev->fd_queue_depth = dev->queue_depth;
+	/*
+	 * Limit WRITE_SAME w/ UNMAP=0 emulation to 8k Number of LBAs (NoLB)
+	 * based upon struct iovec limit for vfs_writev()
+	 */
+	dev->dev_attrib.max_write_same_len = 0x1000;
 
 	pr_debug("CORE_FILE[%u] - Added TCM FILEIO Device ID: %u at %s,"
 		" %llu total bytes\n", fd_host->fd_host_id, fd_dev->fd_dev_id,
@@ -328,6 +333,115 @@ fd_execute_sync_cache(struct se_cmd *cmd)
 	return 0;
 }
 
+static unsigned char *
+fd_setup_write_same_buf(struct se_cmd *cmd, struct scatterlist *sg,
+		    unsigned int len)
+{
+	struct se_device *se_dev = cmd->se_dev;
+	unsigned int block_size = se_dev->dev_attrib.block_size;
+	unsigned int i = 0, end;
+	unsigned char *buf, *p, *kmap_buf;
+
+	buf = kzalloc(min_t(unsigned int, len, PAGE_SIZE), GFP_KERNEL);
+	if (!buf) {
+		pr_err("Unable to allocate fd_execute_write_same buf\n");
+		return NULL;
+	}
+
+	kmap_buf = kmap(sg_page(sg)) + sg->offset;
+	if (!kmap_buf) {
+		pr_err("kmap() failed in fd_setup_write_same\n");
+		kfree(buf);
+		return NULL;
+	}
+	/*
+	 * Fill local *buf to contain multiple WRITE_SAME blocks up to
+	 * min(len, PAGE_SIZE)
+	 */
+	p = buf;
+	end = min_t(unsigned int, len, PAGE_SIZE);
+
+	while (i < end) {
+		memcpy(p, kmap_buf, block_size);
+
+		i += block_size;
+		p += block_size;
+	}
+	kunmap(sg_page(sg));
+
+	return buf;
+}
+
+static sense_reason_t
+fd_execute_write_same(struct se_cmd *cmd)
+{
+	struct se_device *se_dev = cmd->se_dev;
+	struct fd_dev *fd_dev = FD_DEV(se_dev);
+	struct file *f = fd_dev->fd_file;
+	struct scatterlist *sg;
+	struct iovec *iov;
+	mm_segment_t old_fs;
+	sector_t nolb = spc_get_write_same_sectors(cmd);
+	loff_t pos = cmd->t_task_lba * se_dev->dev_attrib.block_size;
+	unsigned int len, len_tmp, iov_num;
+	int i, rc;
+	unsigned char *buf;
+
+	if (!nolb) {
+		target_complete_cmd(cmd, SAM_STAT_GOOD);
+		return 0;
+	}
+	sg = &cmd->t_data_sg[0];
+
+	if (cmd->t_data_nents > 1 ||
+	    sg->length != cmd->se_dev->dev_attrib.block_size) {
+		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
+			" block_size: %u\n", cmd->t_data_nents, sg->length,
+			cmd->se_dev->dev_attrib.block_size);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
+	len = len_tmp = nolb * se_dev->dev_attrib.block_size;
+	iov_num = DIV_ROUND_UP(len, PAGE_SIZE);
+
+	buf = fd_setup_write_same_buf(cmd, sg, len);
+	if (!buf)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	iov = vmalloc(sizeof(struct iovec) * iov_num);
+	if (!iov) {
+		pr_err("Unable to allocate fd_execute_write_same iovecs\n");
+		kfree(buf);
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+	memset(iov, 0, sizeof(struct iovec) * iov_num);
+	/*
+	 * Map the single fabric received scatterlist block into each
+	 * iovec for submission.
+	 */
+	for (i = 0; i < iov_num; i++) {
+		iov[i].iov_base = buf;
+		iov[i].iov_len = min_t(unsigned int, len_tmp, PAGE_SIZE);
+		len_tmp -= iov[i].iov_len;
+	}
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+	rc = vfs_writev(f, &iov[0], iov_num, &pos);
+	set_fs(old_fs);
+
+	vfree(iov);
+	kfree(buf);
+
+	if (rc < 0 || rc != len) {
+		pr_err("vfs_writev() returned %d for write same\n", rc);
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
+	return 0;
+}
+
 static sense_reason_t
 fd_execute_rw(struct se_cmd *cmd)
 {
@@ -486,6 +600,7 @@ static sector_t fd_get_blocks(struct se_device *dev)
 static struct sbc_ops fd_sbc_ops = {
 	.execute_rw		= fd_execute_rw,
 	.execute_sync_cache	= fd_execute_sync_cache,
+	.execute_write_same	= fd_execute_write_same,
 };
 
 static sense_reason_t
-- 
1.7.2.5
