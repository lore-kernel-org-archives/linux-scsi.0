From: lixiubo@cmss.chinamobile.com
Subject: [PATCH] target/user: Add daynmic growing data area feature support
Date: Fri, 17 Feb 2017 17:24:32 +0800
Message-ID: <1487323472-20481-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org, agrover@redhat.com, mchristi@redhat.com, shli@kernel.org
Cc: hch@lst.de, sheng@yasker.org, namei.unix@gmail.com, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Xiubo Li <lixiubo@cmss.chinamobile.com>, Jianfei Hu <hujianfei@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

Currently for the TCMU, the ring buffer size is fixed to 64K cmd
area + 1M data area, and this will be bottlenecks for high iops.

The struct tcmu_cmd_entry {} size is fixed about 44 bytes without
iovec[N], and the size of struct iovec[N] is about (16 * N) bytes.

The sizeof(cmd entry) will be [44B, N *16 + 44B], and corresponding
iovec[N] size will be [0, N * 4096], so the ratio of
sizeof(cmd entry) : sizeof(entry datas) ==
(N * 16 + 44)Bytes : (N * 4096)Bytes == (N * 16)/(N * 4096) +
44/(N*4096) == 4/1024 + 11/(N * 1024).

When N is bigger, the ratio will be smaller. If N >= 1, the ratio
will be [15/1024, 4/1024), for this the ratio 15 : 1024 will be
enough. But maybe some iscsi cmds has no datas, N == 0. So the ratio
should be bigger.

For now we will increase the data area size to 1G, and the cmd area
size to 128M. The tcmu-runner should mmap() about (128M + 1G) when
running and the TCMU will dynamically grows the data area from 0 to
max 1G size.

The cmd area memory will be allocated through vmalloc(), and the data
area's blocks will be allocated individually later when needed.

The allocated data area block memory will be managed via radix tree.
For now the bitmap still be the most efficient way to search and
manage the block index, this could be update later.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
Signed-off-by: Jianfei Hu <hujianfei@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 241 ++++++++++++++++++++++++++------------
 1 file changed, 167 insertions(+), 74 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 2e33100..f2e3769 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2,6 +2,7 @@
  * Copyright (C) 2013 Shaohua Li <shli@kernel.org>
  * Copyright (C) 2014 Red Hat, Inc.
  * Copyright (C) 2015 Arrikto, Inc.
+ * Copyright (C) 2017 Chinamobile, Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -25,6 +26,7 @@
 #include <linux/parser.h>
 #include <linux/vmalloc.h>
 #include <linux/uio_driver.h>
+#include <linux/radix-tree.h>
 #include <linux/stringify.h>
 #include <linux/bitops.h>
 #include <linux/highmem.h>
@@ -65,12 +67,15 @@
 
 #define TCMU_TIME_OUT (30 * MSEC_PER_SEC)
 
-#define DATA_BLOCK_BITS 256
-#define DATA_BLOCK_SIZE 4096
+/* For cmd area, the size is fixed 64M */
+#define CMDR_SIZE (64 * 1024 * 1024)
 
-#define CMDR_SIZE (16 * 4096)
+/* For data area, the size is fixed 1G */
+#define DATA_BLOCK_BITS (256 * 1024)
+#define DATA_BLOCK_SIZE 4096
 #define DATA_SIZE (DATA_BLOCK_BITS * DATA_BLOCK_SIZE)
 
+/* The ring buffer size is 64M + 1G */
 #define TCMU_RING_SIZE (CMDR_SIZE + DATA_SIZE)
 
 static struct device *tcmu_root_device;
@@ -103,6 +108,7 @@ struct tcmu_dev {
 	size_t data_size;
 
 	DECLARE_BITMAP(data_bitmap, DATA_BLOCK_BITS);
+	struct radix_tree_root data_blocks;
 
 	wait_queue_head_t wait_cmdr;
 	/* TODO should this be a mutex? */
@@ -120,15 +126,22 @@ struct tcmu_dev {
 
 #define CMDR_OFF sizeof(struct tcmu_mailbox)
 
+struct tcmu_data_block_index {
+	struct list_head list;
+	uint32_t index;
+};
+
 struct tcmu_cmd {
 	struct se_cmd *se_cmd;
 	struct tcmu_dev *tcmu_dev;
 
-	uint16_t cmd_id;
+	uint32_t cmd_id;
 
 	/* Can't use se_cmd when cleaning up expired cmds, because if
 	   cmd has been completed then accessing se_cmd is off limits */
-	DECLARE_BITMAP(data_bitmap, DATA_BLOCK_BITS);
+	uint32_t dbi_cnt;
+	uint32_t dbi_cur;
+	uint32_t *dbi;
 
 	unsigned long deadline;
 
@@ -159,10 +172,77 @@ enum tcmu_multicast_groups {
 	.netnsok = true,
 };
 
+static int tcmu_db_get_empty_block(struct tcmu_dev *udev, void **addr)
+{
+	void *p;
+	uint32_t block;
+	int ret;
+
+	block = find_first_zero_bit(udev->data_bitmap, DATA_BLOCK_BITS);
+	set_bit(block, udev->data_bitmap);
+
+	p = radix_tree_lookup(&udev->data_blocks, block);
+	if (!p) {
+		p = kzalloc(DATA_BLOCK_SIZE, GFP_ATOMIC);
+		if (!p) {
+			clear_bit(block, udev->data_bitmap);
+			return -ENOMEM;
+		}
+
+		ret = radix_tree_insert(&udev->data_blocks, block, p);
+		if (ret) {
+			kfree(p);
+			clear_bit(block, udev->data_bitmap);
+			return ret;
+		}
+	}
+
+	*addr = p;
+	return block;
+}
+
+static void *tcmu_db_get_block_addr(struct tcmu_dev *udev, uint32_t block)
+{
+	return radix_tree_lookup(&udev->data_blocks, block);
+}
+
+#define	tcmu_cmd_reset_dbi_cur(cmd) ((cmd)->dbi_cur = 0)
+#define tcmu_cmd_set_dbi(cmd, index) ((cmd)->dbi[(cmd)->dbi_cur++] = (index))
+#define tcmu_cmd_get_dbi(cmd) ((cmd)->dbi[(cmd)->dbi_cur++])
+
+static void tcmu_cmd_free_data(struct tcmu_cmd *tcmu_cmd)
+{
+	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
+	uint32_t bi;
+
+	for (bi = 0; bi < tcmu_cmd->dbi_cnt; bi++)
+		clear_bit(tcmu_cmd->dbi[bi], udev->data_bitmap);
+}
+
+static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
+{
+	kfree(tcmu_cmd->dbi);
+	kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
+}
+
+static inline uint32_t tcmu_cmd_get_dbi_count(struct se_cmd *se_cmd)
+{
+	size_t data_length = se_cmd->data_length;
+	uint32_t dbi_cnt;
+
+	if (se_cmd->se_cmd_flags & SCF_BIDI)
+		data_length += se_cmd->t_bidi_data_sg->length;
+
+	dbi_cnt = (data_length + DATA_BLOCK_SIZE - 1) / DATA_BLOCK_SIZE;
+
+	return dbi_cnt;
+}
+
 static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 {
 	struct se_device *se_dev = se_cmd->se_dev;
 	struct tcmu_dev *udev = TCMU_DEV(se_dev);
+	uint32_t dbi_cnt = tcmu_cmd_get_dbi_count(se_cmd);
 	struct tcmu_cmd *tcmu_cmd;
 	int cmd_id;
 
@@ -174,6 +254,14 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	tcmu_cmd->tcmu_dev = udev;
 	tcmu_cmd->deadline = jiffies + msecs_to_jiffies(TCMU_TIME_OUT);
 
+	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
+	tcmu_cmd->dbi_cnt = dbi_cnt;
+	tcmu_cmd->dbi = kcalloc(dbi_cnt, sizeof(uint32_t), GFP_KERNEL);
+	if (!tcmu_cmd->dbi) {
+		kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
+		return NULL;
+	}
+
 	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&udev->commands_lock);
 	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 0,
@@ -182,7 +270,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	idr_preload_end();
 
 	if (cmd_id < 0) {
-		kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
+		tcmu_free_cmd(tcmu_cmd);
 		return NULL;
 	}
 	tcmu_cmd->cmd_id = cmd_id;
@@ -244,10 +332,10 @@ static inline void new_iov(struct iovec **iov, int *iov_cnt,
 #define UPDATE_HEAD(head, used, size) smp_store_release(&head, ((head % size) + used) % size)
 
 /* offset is relative to mb_addr */
-static inline size_t get_block_offset(struct tcmu_dev *dev,
-		int block, int remaining)
+static inline size_t get_block_offset_user(struct tcmu_dev *dev,
+		int bi, int remaining)
 {
-	return dev->data_off + block * DATA_BLOCK_SIZE +
+	return dev->data_off + bi * DATA_BLOCK_SIZE +
 		DATA_BLOCK_SIZE - remaining;
 }
 
@@ -257,13 +345,14 @@ static inline size_t iov_tail(struct tcmu_dev *udev, struct iovec *iov)
 }
 
 static void alloc_and_scatter_data_area(struct tcmu_dev *udev,
-	struct scatterlist *data_sg, unsigned int data_nents,
-	struct iovec **iov, int *iov_cnt, bool copy_data)
+	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
+	unsigned int data_nents, struct iovec **iov,
+	int *iov_cnt, bool copy_data)
 {
-	int i, block;
+	int i, bi;
 	int block_remaining = 0;
-	void *from, *to;
-	size_t copy_bytes, to_offset;
+	void *from, *to = NULL;
+	size_t copy_bytes, to_offset, offset;
 	struct scatterlist *sg;
 
 	for_each_sg(data_sg, sg, data_nents, i) {
@@ -271,22 +360,24 @@ static void alloc_and_scatter_data_area(struct tcmu_dev *udev,
 		from = kmap_atomic(sg_page(sg)) + sg->offset;
 		while (sg_remaining > 0) {
 			if (block_remaining == 0) {
-				block = find_first_zero_bit(udev->data_bitmap,
-						DATA_BLOCK_BITS);
 				block_remaining = DATA_BLOCK_SIZE;
-				set_bit(block, udev->data_bitmap);
+				bi = tcmu_db_get_empty_block(udev, &to);
+				tcmu_cmd_set_dbi(tcmu_cmd, bi);
 			}
+
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
-			to_offset = get_block_offset(udev, block,
+			to_offset = get_block_offset_user(udev, bi,
 					block_remaining);
-			to = (void *)udev->mb_addr + to_offset;
+			offset = DATA_BLOCK_SIZE - block_remaining;
+			to = (void *)(unsigned long)to + offset;
+
 			if (*iov_cnt != 0 &&
 			    to_offset == iov_tail(udev, *iov)) {
 				(*iov)->iov_len += copy_bytes;
 			} else {
 				new_iov(iov, iov_cnt, udev);
-				(*iov)->iov_base = (void __user *) to_offset;
+				(*iov)->iov_base = (void __user *)to_offset;
 				(*iov)->iov_len = copy_bytes;
 			}
 			if (copy_data) {
@@ -301,19 +392,13 @@ static void alloc_and_scatter_data_area(struct tcmu_dev *udev,
 	}
 }
 
-static void free_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd)
-{
-	bitmap_xor(udev->data_bitmap, udev->data_bitmap, cmd->data_bitmap,
-		   DATA_BLOCK_BITS);
-}
-
-static void gather_data_area(struct tcmu_dev *udev, unsigned long *cmd_bitmap,
+static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *tcmu_cmd,
 		struct scatterlist *data_sg, unsigned int data_nents)
 {
-	int i, block;
+	int i, bi;
 	int block_remaining = 0;
 	void *from, *to;
-	size_t copy_bytes, from_offset;
+	size_t copy_bytes, offset;
 	struct scatterlist *sg;
 
 	for_each_sg(data_sg, sg, data_nents, i) {
@@ -321,16 +406,15 @@ static void gather_data_area(struct tcmu_dev *udev, unsigned long *cmd_bitmap,
 		to = kmap_atomic(sg_page(sg)) + sg->offset;
 		while (sg_remaining > 0) {
 			if (block_remaining == 0) {
-				block = find_first_bit(cmd_bitmap,
-						DATA_BLOCK_BITS);
 				block_remaining = DATA_BLOCK_SIZE;
-				clear_bit(block, cmd_bitmap);
+				bi = tcmu_cmd_get_dbi(tcmu_cmd);
+
+				from = tcmu_db_get_block_addr(udev, bi);
 			}
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
-			from_offset = get_block_offset(udev, block,
-					block_remaining);
-			from = (void *) udev->mb_addr + from_offset;
+			offset = DATA_BLOCK_SIZE - block_remaining;
+			from = (void *)(unsigned long)from + offset;
 			tcmu_flush_dcache_range(from, copy_bytes);
 			memcpy(to + sg->length - sg_remaining, from,
 					copy_bytes);
@@ -404,7 +488,6 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 	uint64_t cdb_off;
 	bool copy_to_data_area;
 	size_t data_length;
-	DECLARE_BITMAP(old_bitmap, DATA_BLOCK_BITS);
 
 	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags))
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -490,28 +573,22 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 	entry->hdr.kflags = 0;
 	entry->hdr.uflags = 0;
 
-	bitmap_copy(old_bitmap, udev->data_bitmap, DATA_BLOCK_BITS);
-
 	/* Handle allocating space from the data area */
 	iov = &entry->req.iov[0];
 	iov_cnt = 0;
 	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
 		|| se_cmd->se_cmd_flags & SCF_BIDI);
-	alloc_and_scatter_data_area(udev, se_cmd->t_data_sg,
+	alloc_and_scatter_data_area(udev, tcmu_cmd, se_cmd->t_data_sg,
 		se_cmd->t_data_nents, &iov, &iov_cnt, copy_to_data_area);
 	entry->req.iov_cnt = iov_cnt;
 	entry->req.iov_dif_cnt = 0;
 
 	/* Handle BIDI commands */
 	iov_cnt = 0;
-	alloc_and_scatter_data_area(udev, se_cmd->t_bidi_data_sg,
+	alloc_and_scatter_data_area(udev, tcmu_cmd, se_cmd->t_bidi_data_sg,
 		se_cmd->t_bidi_data_nents, &iov, &iov_cnt, false);
 	entry->req.iov_bidi_cnt = iov_cnt;
 
-	/* cmd's data_bitmap is what changed in process */
-	bitmap_xor(tcmu_cmd->data_bitmap, old_bitmap, udev->data_bitmap,
-			DATA_BLOCK_BITS);
-
 	/* All offsets relative to mb_addr, not start of entry! */
 	cdb_off = CMDR_OFF + cmd_head + base_command_size;
 	memcpy((void *) mb + cdb_off, se_cmd->t_task_cdb, scsi_command_size(se_cmd->t_task_cdb));
@@ -551,7 +628,7 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 		idr_remove(&udev->commands, tcmu_cmd->cmd_id);
 		spin_unlock_irq(&udev->commands_lock);
 
-		kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
+		tcmu_free_cmd(tcmu_cmd);
 	}
 
 	return ret;
@@ -562,43 +639,38 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	struct se_cmd *se_cmd = cmd->se_cmd;
 	struct tcmu_dev *udev = cmd->tcmu_dev;
 
+	tcmu_cmd_reset_dbi_cur(cmd);
+
 	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
 		/*
 		 * cmd has been completed already from timeout, just reclaim
 		 * data area space and free cmd
 		 */
-		free_data_area(udev, cmd);
+		tcmu_cmd_free_data(cmd);
 
-		kmem_cache_free(tcmu_cmd_cache, cmd);
+		tcmu_free_cmd(cmd);
 		return;
 	}
 
 	if (entry->hdr.uflags & TCMU_UFLAG_UNKNOWN_OP) {
-		free_data_area(udev, cmd);
+		tcmu_cmd_free_data(cmd);
 		pr_warn("TCMU: Userspace set UNKNOWN_OP flag on se_cmd %p\n",
 			cmd->se_cmd);
 		entry->rsp.scsi_status = SAM_STAT_CHECK_CONDITION;
 	} else if (entry->rsp.scsi_status == SAM_STAT_CHECK_CONDITION) {
 		memcpy(se_cmd->sense_buffer, entry->rsp.sense_buffer,
 			       se_cmd->scsi_sense_length);
-		free_data_area(udev, cmd);
+		tcmu_cmd_free_data(cmd);
 	} else if (se_cmd->se_cmd_flags & SCF_BIDI) {
-		DECLARE_BITMAP(bitmap, DATA_BLOCK_BITS);
-
-		/* Get Data-In buffer before clean up */
-		bitmap_copy(bitmap, cmd->data_bitmap, DATA_BLOCK_BITS);
-		gather_data_area(udev, bitmap,
+		gather_data_area(udev, cmd,
 			se_cmd->t_bidi_data_sg, se_cmd->t_bidi_data_nents);
-		free_data_area(udev, cmd);
+		tcmu_cmd_free_data(cmd);
 	} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
-		DECLARE_BITMAP(bitmap, DATA_BLOCK_BITS);
-
-		bitmap_copy(bitmap, cmd->data_bitmap, DATA_BLOCK_BITS);
-		gather_data_area(udev, bitmap,
+		gather_data_area(udev, cmd,
 			se_cmd->t_data_sg, se_cmd->t_data_nents);
-		free_data_area(udev, cmd);
+		tcmu_cmd_free_data(cmd);
 	} else if (se_cmd->data_direction == DMA_TO_DEVICE) {
-		free_data_area(udev, cmd);
+		tcmu_cmd_free_data(cmd);
 	} else if (se_cmd->data_direction != DMA_NONE) {
 		pr_warn("TCMU: data direction was %d!\n",
 			se_cmd->data_direction);
@@ -607,7 +679,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
 	cmd->se_cmd = NULL;
 
-	kmem_cache_free(tcmu_cmd_cache, cmd);
+	tcmu_free_cmd(cmd);
 }
 
 static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
@@ -801,11 +873,19 @@ static int tcmu_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 */
 	offset = (vmf->pgoff - mi) << PAGE_SHIFT;
 
-	addr = (void *)(unsigned long)info->mem[mi].addr + offset;
-	if (info->mem[mi].memtype == UIO_MEM_LOGICAL)
-		page = virt_to_page(addr);
-	else
+	if (offset < udev->data_off) {
+		/* For the vmalloc()ed cmd area pages */
+		addr = (void *)(unsigned long)info->mem[mi].addr + offset;
 		page = vmalloc_to_page(addr);
+	} else {
+		/* For the dynamically growing data area pages */
+		uint32_t block;
+
+		block = (offset - udev->data_off) / DATA_BLOCK_SIZE;
+		addr = tcmu_db_get_block_addr(udev, block);
+		page = virt_to_page(addr);
+	}
+
 	get_page(page);
 	vmf->page = page;
 	return 0;
@@ -919,7 +999,7 @@ static int tcmu_configure_device(struct se_device *dev)
 
 	info->name = str;
 
-	udev->mb_addr = vzalloc(TCMU_RING_SIZE);
+	udev->mb_addr = vzalloc(CMDR_SIZE);
 	if (!udev->mb_addr) {
 		ret = -ENOMEM;
 		goto err_vzalloc;
@@ -928,8 +1008,9 @@ static int tcmu_configure_device(struct se_device *dev)
 	/* mailbox fits in first part of CMDR space */
 	udev->cmdr_size = CMDR_SIZE - CMDR_OFF;
 	udev->data_off = CMDR_SIZE;
-	udev->data_size = TCMU_RING_SIZE - CMDR_SIZE;
+	udev->data_size = DATA_SIZE;
 
+	/* Initialise the mailbox of the ring buffer */
 	mb = udev->mb_addr;
 	mb->version = TCMU_MAILBOX_VERSION;
 	mb->flags = TCMU_MAILBOX_FLAG_CAP_OOOC;
@@ -940,12 +1021,14 @@ static int tcmu_configure_device(struct se_device *dev)
 	WARN_ON(udev->data_size % PAGE_SIZE);
 	WARN_ON(udev->data_size % DATA_BLOCK_SIZE);
 
+	INIT_RADIX_TREE(&udev->data_blocks, GFP_ATOMIC);
+
 	info->version = __stringify(TCMU_MAILBOX_VERSION);
 
 	info->mem[0].name = "tcm-user command & data buffer";
 	info->mem[0].addr = (phys_addr_t)(uintptr_t)udev->mb_addr;
 	info->mem[0].size = TCMU_RING_SIZE;
-	info->mem[0].memtype = UIO_MEM_VIRTUAL;
+	info->mem[0].memtype = UIO_MEM_NONE;
 
 	info->irqcontrol = tcmu_irqcontrol;
 	info->irq = UIO_IRQ_CUSTOM;
@@ -982,13 +1065,23 @@ static int tcmu_configure_device(struct se_device *dev)
 	return ret;
 }
 
-static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
+static inline int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
 {
-	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
-		kmem_cache_free(tcmu_cmd_cache, cmd);
-		return 0;
+	struct tcmu_dev *udev = cmd->tcmu_dev;
+	void *addr;
+	int i, ret = 0;
+
+	for (i = 0; i < cmd->dbi_cnt; i++) {
+		addr = radix_tree_delete(&udev->data_blocks, cmd->dbi[i]);
+		kfree(addr);
 	}
-	return -EINVAL;
+
+	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
+		ret = -EINVAL;
+
+	tcmu_free_cmd(cmd);
+
+	return ret;
 }
 
 static void tcmu_dev_call_rcu(struct rcu_head *p)
-- 
1.8.3.1
