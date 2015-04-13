From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/3] target/file: Fix SG table for prot_buf initialization
Date: Mon, 13 Apr 2015 23:21:57 +0900
Message-ID: <1428934918-4004-2-git-send-email-akinobu.mita@gmail.com>
References: <1428934918-4004-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32797 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbbDMOWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2015 10:22:16 -0400
In-Reply-To: <1428934918-4004-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

In fd_do_prot_rw(), it allocates prot_buf which is used to copy from
se_cmd->t_prot_sg by sbc_dif_copy_prot().  The SG table for prot_buf
is also initialized by allocating 'se_cmd->t_prot_nents' entries of
scatterlist and setting the data length of each entry to PAGE_SIZE
at most.

However if se_cmd->t_prot_sg contains a clustered entry (i.e.
sg->length > PAGE_SIZE), the SG table for prot_buf can't be
initialized correctly and sbc_dif_copy_prot() can't copy to prot_buf.
(This actually happened with TCM loopback fabric module)

As prot_buf is allocated by kzalloc() and it's physically contiguous,
we only need a single scatterlist entry.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/target/target_core_file.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 8ca1883..4c7a6c8 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -264,11 +264,10 @@ static int fd_do_prot_rw(struct se_cmd *cmd, struct fd_prot *fd_prot,
 	struct se_device *se_dev = cmd->se_dev;
 	struct fd_dev *dev = FD_DEV(se_dev);
 	struct file *prot_fd = dev->fd_prot_file;
-	struct scatterlist *sg;
 	loff_t pos = (cmd->t_task_lba * se_dev->prot_length);
 	unsigned char *buf;
-	u32 prot_size, len, size;
-	int rc, ret = 1, i;
+	u32 prot_size;
+	int rc, ret = 1;
 
 	prot_size = (cmd->data_length / se_dev->dev_attrib.block_size) *
 		     se_dev->prot_length;
@@ -281,24 +280,16 @@ static int fd_do_prot_rw(struct se_cmd *cmd, struct fd_prot *fd_prot,
 		}
 		buf = fd_prot->prot_buf;
 
-		fd_prot->prot_sg_nents = cmd->t_prot_nents;
-		fd_prot->prot_sg = kzalloc(sizeof(struct scatterlist) *
-					   fd_prot->prot_sg_nents, GFP_KERNEL);
+		fd_prot->prot_sg_nents = 1;
+		fd_prot->prot_sg = kzalloc(sizeof(struct scatterlist),
+					   GFP_KERNEL);
 		if (!fd_prot->prot_sg) {
 			pr_err("Unable to allocate fd_prot->prot_sg\n");
 			kfree(fd_prot->prot_buf);
 			return -ENOMEM;
 		}
 		sg_init_table(fd_prot->prot_sg, fd_prot->prot_sg_nents);
-		size = prot_size;
-
-		for_each_sg(fd_prot->prot_sg, sg, fd_prot->prot_sg_nents, i) {
-
-			len = min_t(u32, PAGE_SIZE, size);
-			sg_set_buf(sg, buf, len);
-			size -= len;
-			buf += len;
-		}
+		sg_set_buf(fd_prot->prot_sg, buf, prot_size);
 	}
 
 	if (is_write) {
-- 
1.9.1

