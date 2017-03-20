From: lixiubo@cmss.chinamobile.com
Subject: [PATCHv3 2/5] tcmu: Add global data block pool support
Date: Mon, 20 Mar 2017 17:09:21 +0800
Message-ID: <1490000964-15732-3-git-send-email-lixiubo@cmss.chinamobile.com>
References: <1490000964-15732-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1490000964-15732-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

For each target there will be one ring, when the target number
grows larger and larger, it could eventually runs out of the
system memories.

In this patch for each target ring, for the cmd area the size
will be limited to 8MB and for the data area the size will be
limited to 256K * PAGE_SIZE.

For all the targets' data areas, they will get empty blocks
from the "global data block pool", which has limited to 512K *
PAGE_SIZE for now.

When the "global data block pool" has been used up, then any
target could trigger the unmapping thread routine to shrink the
targets' rings. And for the idle targets the unmapping routine
will reserve 256 blocks at least.

When user space has touched the data blocks out of the iov[N],
the tcmu_page_fault() will return one zeroed blocks.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
Signed-off-by: Jianfei Hu <hujianfei@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 426 ++++++++++++++++++++++++++++++--------
 1 file changed, 339 insertions(+), 87 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index fc9f237..8cbe196 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -31,6 +31,8 @@
 #include <linux/bitops.h>
 #include <linux/highmem.h>
 #include <linux/configfs.h>
+#include <linux/mutex.h>
+#include <linux/kthread.h>
 #include <net/genetlink.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
@@ -67,17 +69,24 @@
 
 #define TCMU_TIME_OUT (30 * MSEC_PER_SEC)
 
-/* For cmd area, the size is fixed 2M */
-#define CMDR_SIZE (2 * 1024 * 1024)
+/* For cmd area, the size is fixed 8MB */
+#define CMDR_SIZE (8 * 1024 * 1024)
 
-/* For data area, the size is fixed 32M */
-#define DATA_BLOCK_BITS (8 * 1024)
-#define DATA_BLOCK_SIZE 4096
+/*
+ * For data area, the block size is PAGE_SIZE and
+ * the total size is 256K * PAGE_SIZE.
+ */
+#define DATA_BLOCK_SIZE PAGE_SIZE
+#define DATA_BLOCK_BITS (256 * 1024)
 #define DATA_SIZE (DATA_BLOCK_BITS * DATA_BLOCK_SIZE)
+#define DATA_BLOCK_RES_BITS 256
 
-/* The ring buffer size is 34M */
+/* The total size of the ring is 8M + 256K * PAGE_SIZE */
 #define TCMU_RING_SIZE (CMDR_SIZE + DATA_SIZE)
 
+/* Default maximum of the global data blocks(512K * PAGE_SIZE) */
+#define TCMU_GLOBAL_MAX_BLOCKS (512 * 1024)
+
 static struct device *tcmu_root_device;
 
 struct tcmu_hba {
@@ -87,6 +96,8 @@ struct tcmu_hba {
 #define TCMU_CONFIG_LEN 256
 
 struct tcmu_dev {
+	struct list_head node;
+
 	struct se_device se_dev;
 
 	char *name;
@@ -98,6 +109,16 @@ struct tcmu_dev {
 
 	struct uio_info uio_info;
 
+	struct inode *inode;
+
+	struct mutex unmap_mutex;
+	bool unmapping;
+	bool waiting_global;
+	uint32_t dbi_cur;
+	uint32_t dbi_thresh;
+	DECLARE_BITMAP(data_bitmap, DATA_BLOCK_BITS);
+	struct radix_tree_root data_blocks;
+
 	struct tcmu_mailbox *mb_addr;
 	size_t dev_size;
 	u32 cmdr_size;
@@ -111,10 +132,6 @@ struct tcmu_dev {
 	/* TODO should this be a mutex? */
 	spinlock_t cmdr_lock;
 
-	uint32_t dbi_cur;
-	DECLARE_BITMAP(data_bitmap, DATA_BLOCK_BITS);
-	struct radix_tree_root data_blocks;
-
 	struct idr commands;
 	spinlock_t commands_lock;
 
@@ -146,6 +163,14 @@ struct tcmu_cmd {
 	unsigned long flags;
 };
 
+static struct task_struct *unmap_thread;
+static wait_queue_head_t unmap_wait;
+static DEFINE_MUTEX(udev_mutex);
+static LIST_HEAD(root_udev);
+
+static spinlock_t db_count_lock;
+static unsigned long global_db_count;
+
 static struct kmem_cache *tcmu_cmd_cache;
 
 /* multicast group */
@@ -169,54 +194,90 @@ enum tcmu_multicast_groups {
 	.netnsok = true,
 };
 
-static int tcmu_get_empty_block(struct tcmu_dev *udev, void **addr)
+#define tcmu_cmd_reset_dbi_cur(cmd) ((cmd)->dbi_cur = 0)
+#define tcmu_cmd_set_dbi(cmd, index) ((cmd)->dbi[(cmd)->dbi_cur++] = (index))
+#define tcmu_cmd_get_dbi(cmd) ((cmd)->dbi[(cmd)->dbi_cur++])
+
+static inline void tcmu_cmd_free_data(struct tcmu_cmd *tcmu_cmd, uint32_t len)
 {
-	void *p;
-	uint32_t dbi;
-	int ret;
+	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
+	uint32_t i;
 
-	dbi = find_first_zero_bit(udev->data_bitmap, DATA_BLOCK_BITS);
-	if (dbi > udev->dbi_cur)
-		udev->dbi_cur = dbi;
+	for (i = 0; i < len; i++)
+		clear_bit(tcmu_cmd->dbi[i], udev->data_bitmap);
+}
 
-	set_bit(dbi, udev->data_bitmap);
+static inline bool tcmu_get_empty_block(struct tcmu_dev *udev,
+					struct tcmu_cmd *tcmu_cmd)
+{
+	struct page *page;
+	int ret, dbi;
 
-	p = radix_tree_lookup(&udev->data_blocks, dbi);
-	if (!p) {
-		p = kzalloc(DATA_BLOCK_SIZE, GFP_ATOMIC);
-		if (!p) {
-			clear_bit(dbi, udev->data_bitmap);
-			return -ENOMEM;
+	dbi = find_first_zero_bit(udev->data_bitmap, udev->dbi_thresh);
+	if (dbi == udev->dbi_thresh)
+		return false;
+
+	page = radix_tree_lookup(&udev->data_blocks, dbi);
+	if (!page) {
+		/* try to get new page from the mm */
+		spin_lock_irq(&db_count_lock);
+		if (global_db_count >= TCMU_GLOBAL_MAX_BLOCKS) {
+			spin_unlock_irq(&db_count_lock);
+			wake_up(&unmap_wait);
+			return false;
 		}
+		global_db_count++;
+		spin_unlock_irq(&db_count_lock);
+
+		page = alloc_page(GFP_ATOMIC);
+		if (!page)
+			return false;
 
-		ret = radix_tree_insert(&udev->data_blocks, dbi, p);
+		ret = radix_tree_insert(&udev->data_blocks, dbi, page);
 		if (ret) {
-			kfree(p);
-			clear_bit(dbi, udev->data_bitmap);
-			return ret;
+			__free_page(page);
+			return false;
 		}
 	}
 
-	*addr = p;
-	return dbi;
+	if (dbi > udev->dbi_cur)
+		udev->dbi_cur = dbi;
+
+	set_bit(dbi, udev->data_bitmap);
+	tcmu_cmd_set_dbi(tcmu_cmd, dbi);
+
+	return true;
 }
 
-static void *tcmu_get_block_addr(struct tcmu_dev *udev, uint32_t dbi)
+static bool tcmu_get_empty_blocks(struct tcmu_dev *udev,
+				  struct tcmu_cmd *tcmu_cmd)
 {
-	return radix_tree_lookup(&udev->data_blocks, dbi);
-}
+	int i;
 
-#define tcmu_cmd_reset_dbi_cur(cmd) ((cmd)->dbi_cur = 0)
-#define tcmu_cmd_set_dbi(cmd, index) ((cmd)->dbi[(cmd)->dbi_cur++] = (index))
-#define tcmu_cmd_get_dbi(cmd) ((cmd)->dbi[(cmd)->dbi_cur++])
+	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
+	for (i = 0; i < tcmu_cmd->dbi_len; i++) {
+		if (!tcmu_get_empty_block(udev, tcmu_cmd))
+			goto err;
+	}
+	return true;
+
+err:
+	pr_debug("no blocks: only %u blocks available, but ask for %u\n",
+			tcmu_cmd->dbi_len, tcmu_cmd->dbi_cur);
+	tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cur);
+	udev->waiting_global = true;
+	return false;
+}
 
-static void tcmu_cmd_free_data(struct tcmu_cmd *tcmu_cmd)
+static struct page *tcmu_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 {
-	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
-	uint32_t bi;
+	struct page *page;
+
+	page = radix_tree_lookup(&udev->data_blocks, dbi);
+	if (!page)
+		return NULL;
 
-	for (bi = 0; bi < tcmu_cmd->dbi_len; bi++)
-		clear_bit(tcmu_cmd->dbi[bi], udev->data_bitmap);
+	return page;
 }
 
 static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
@@ -356,17 +417,20 @@ static int alloc_and_scatter_data_area(struct tcmu_dev *udev,
 	void *from, *to = NULL;
 	size_t copy_bytes, to_offset, offset;
 	struct scatterlist *sg;
+	struct page *page;
 
 	for_each_sg(data_sg, sg, data_nents, i) {
 		int sg_remaining = sg->length;
 		from = kmap_atomic(sg_page(sg)) + sg->offset;
 		while (sg_remaining > 0) {
 			if (block_remaining == 0) {
+				if (to)
+					kunmap_atomic(to);
+
 				block_remaining = DATA_BLOCK_SIZE;
-				dbi = tcmu_get_empty_block(udev, &to);
-				if (dbi < 0)
-					return dbi;
-				tcmu_cmd_set_dbi(tcmu_cmd, dbi);
+				dbi = tcmu_cmd_get_dbi(tcmu_cmd);
+				page = tcmu_get_block_page(udev, dbi);
+				to = kmap_atomic(page);
 			}
 
 			copy_bytes = min_t(size_t, sg_remaining,
@@ -394,6 +458,8 @@ static int alloc_and_scatter_data_area(struct tcmu_dev *udev,
 		}
 		kunmap_atomic(from - sg->offset);
 	}
+	if (to)
+		kunmap_atomic(to);
 
 	return 0;
 }
@@ -403,18 +469,23 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *tcmu_cmd,
 {
 	int i, dbi;
 	int block_remaining = 0;
-	void *from, *to;
+	void *from = NULL, *to;
 	size_t copy_bytes, offset;
 	struct scatterlist *sg;
+	struct page *page;
 
 	for_each_sg(data_sg, sg, data_nents, i) {
 		int sg_remaining = sg->length;
 		to = kmap_atomic(sg_page(sg)) + sg->offset;
 		while (sg_remaining > 0) {
 			if (block_remaining == 0) {
+				if (from)
+					kunmap_atomic(from);
+
 				block_remaining = DATA_BLOCK_SIZE;
 				dbi = tcmu_cmd_get_dbi(tcmu_cmd);
-				from = tcmu_get_block_addr(udev, dbi);
+				page = tcmu_get_block_page(udev, dbi);
+				from = kmap_atomic(page);
 			}
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
@@ -429,12 +500,13 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *tcmu_cmd,
 		}
 		kunmap_atomic(to - sg->offset);
 	}
+	if (from)
+		kunmap_atomic(from);
 }
 
-static inline size_t spc_bitmap_free(unsigned long *bitmap)
+static inline size_t spc_bitmap_free(unsigned long *bitmap, uint32_t thresh)
 {
-	return DATA_BLOCK_SIZE * (DATA_BLOCK_BITS -
-			bitmap_weight(bitmap, DATA_BLOCK_BITS));
+	return DATA_BLOCK_SIZE * (thresh - bitmap_weight(bitmap, thresh));
 }
 
 /*
@@ -443,12 +515,14 @@ static inline size_t spc_bitmap_free(unsigned long *bitmap)
  *
  * Called with ring lock held.
  */
-static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t data_needed)
+static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
+		size_t cmd_size, size_t data_needed)
 {
 	struct tcmu_mailbox *mb = udev->mb_addr;
 	size_t space, cmd_needed;
 	u32 cmd_head;
 
+	udev->waiting_global = false;
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
 
 	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
@@ -469,13 +543,31 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 		return false;
 	}
 
-	space = spc_bitmap_free(udev->data_bitmap);
+	/* try to check and get the data blocks as needed */
+	space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
 	if (space < data_needed) {
-		pr_debug("no data space: only %zu available, but ask for %zu\n",
-				space, data_needed);
-		return false;
+		uint32_t dbi_cnt;
+
+		if (udev->unmapping) {
+			pr_debug("the unmap thread is running, try it later");
+			return false;
+		}
+
+		dbi_cnt = (data_needed + DATA_BLOCK_SIZE - 1) /
+			DATA_BLOCK_BITS;
+		udev->dbi_thresh += max(udev->dbi_thresh / 2, dbi_cnt);
+		udev->dbi_thresh = min((int)udev->dbi_thresh, DATA_BLOCK_BITS);
+		space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
+		if (space < data_needed) {
+			pr_debug("no data space: only %zu available, but ask for %zu\n",
+					space, data_needed);
+			return false;
+		}
 	}
 
+	if (!tcmu_get_empty_blocks(udev, cmd))
+		return false;
+
 	return true;
 }
 
@@ -531,7 +623,7 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 		return TCM_INVALID_CDB_FIELD;
 	}
 
-	while (!is_ring_space_avail(udev, command_size, data_length)) {
+	while (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
 		int ret;
 		DEFINE_WAIT(__wait);
 
@@ -583,6 +675,7 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 	entry->hdr.uflags = 0;
 
 	/* Handle allocating space from the data area */
+	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
 	iov = &entry->req.iov[0];
 	iov_cnt = 0;
 	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
@@ -663,10 +756,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		 * cmd has been completed already from timeout, just reclaim
 		 * data area space and free cmd
 		 */
-		free_data_area(udev, cmd);
-
-		kmem_cache_free(tcmu_cmd_cache, cmd);
-		return;
+		goto out;
 	}
 
 	tcmu_cmd_reset_dbi_cur(cmd);
@@ -694,8 +784,9 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 
 	target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
 
+out:
 	cmd->se_cmd = NULL;
-	tcmu_cmd_free_data(cmd);
+	tcmu_cmd_free_data(cmd, cmd->dbi_len);
 	tcmu_free_cmd(cmd);
 }
 
@@ -830,6 +921,8 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 		return NULL;
 	}
 
+	mutex_init(&udev->unmap_mutex);
+
 	udev->hba = hba;
 	udev->cmd_time_out = TCMU_TIME_OUT;
 
@@ -856,41 +949,53 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 
 static void tcmu_blocks_release(struct tcmu_dev *udev, bool release_pending)
 {
-	uint32_t dbi, end;
-	void *addr;
+	int dbi = -1, end;
+	struct page *page;
 
 	spin_lock_irq(&udev->cmdr_lock);
-
 	end = udev->dbi_cur + 1;
 
-	/* try to release all unused blocks */
-	dbi = find_first_zero_bit(udev->data_bitmap, end);
-	if (dbi >= end) {
-		spin_unlock_irq(&udev->cmdr_lock);
-		return;
-	}
+	/* Try to release all empty blocks */
 	do {
-		addr = radix_tree_delete(&udev->data_blocks, dbi);
-		kfree(addr);
-
 		dbi = find_next_zero_bit(udev->data_bitmap, end, dbi + 1);
-	} while (dbi < end);
+		if (dbi == end)
+			break;
 
-	if (!release_pending)
-		return;
+		page = radix_tree_delete(&udev->data_blocks, dbi);
+		if (page) {
+			__free_page(page);
+			spin_lock_irq(&db_count_lock);
+			global_db_count--;
+			spin_unlock_irq(&db_count_lock);
+		}
+	} while (1);
 
-	/* try to release all pending blocks */
-	dbi = find_first_bit(udev->data_bitmap, end);
-	if (dbi >= end) {
+	if (!release_pending) {
 		spin_unlock_irq(&udev->cmdr_lock);
 		return;
 	}
-	do {
-		addr = radix_tree_delete(&udev->data_blocks, dbi);
-		kfree(addr);
 
+	/* Try to release all pending blocks */
+	dbi = -1;
+	do {
 		dbi = find_next_bit(udev->data_bitmap, end, dbi + 1);
-	} while (dbi < end);
+		if (dbi == end)
+			break;
+
+		clear_bit(dbi, udev->data_bitmap);
+
+		page = radix_tree_delete(&udev->data_blocks, dbi);
+		if (page) {
+			__free_page(page);
+			spin_lock_irq(&db_count_lock);
+			global_db_count--;
+			spin_unlock_irq(&db_count_lock);
+		} else {
+			pr_err("block page not found, ring is broken\n");
+			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
+			break;
+		}
+	} while (1);
 
 	spin_unlock_irq(&udev->cmdr_lock);
 }
@@ -919,6 +1024,53 @@ static int tcmu_find_mem_index(struct vm_area_struct *vma)
 	return -1;
 }
 
+/*
+ * Normally it shouldn't be here. This is just for avoid
+ * the page fault call trace, and will return zeroed page.
+ */
+static struct page *tcmu_try_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
+{
+	struct page *page;
+	int ret;
+
+	spin_lock_irq(&udev->cmdr_lock);
+	page = tcmu_get_block_page(udev, dbi);
+	if (page) {
+		spin_unlock_irq(&udev->cmdr_lock);
+		return page;
+	}
+
+	page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	if (!page) {
+		spin_unlock_irq(&udev->cmdr_lock);
+		return NULL;
+	}
+
+	if (dbi >= udev->dbi_thresh) {
+		/*
+		 * Since this case is rare in page fault routine, here we
+		 * will allow the global_db_count >= TCMU_GLOBAL_MAX_BLOCKS
+		 * to reduce possible page fault call trace.
+		 */
+		spin_lock_irq(&db_count_lock);
+		global_db_count++;
+		spin_unlock_irq(&db_count_lock);
+
+		udev->dbi_thresh = dbi;
+		udev->dbi_cur = dbi;
+	}
+
+	ret = radix_tree_insert(&udev->data_blocks, dbi, page);
+	if (ret) {
+		spin_unlock_irq(&udev->cmdr_lock);
+		__free_page(page);
+		return NULL;
+	}
+	spin_unlock_irq(&udev->cmdr_lock);
+
+	return page;
+}
+
 static int tcmu_vma_fault(struct vm_fault *vmf)
 {
 	struct tcmu_dev *udev = vmf->vma->vm_private_data;
@@ -942,14 +1094,15 @@ static int tcmu_vma_fault(struct vm_fault *vmf)
 		addr = (void *)(unsigned long)info->mem[mi].addr + offset;
 		page = vmalloc_to_page(addr);
 	} else {
-		/* For the dynamically growing data area pages */
 		uint32_t dbi;
 
+		/* For the dynamically growing data area pages */
 		dbi = (offset - udev->data_off) / DATA_BLOCK_SIZE;
-		addr = tcmu_get_block_addr(udev, dbi);
-		if (!addr)
+		mutex_lock(&udev->unmap_mutex);
+		page = tcmu_try_get_block_page(udev, dbi);
+		mutex_unlock(&udev->unmap_mutex);
+		if (!page)
 			return VM_FAULT_NOPAGE;
-		page = virt_to_page(addr);
 	}
 
 	get_page(page);
@@ -986,6 +1139,8 @@ static int tcmu_open(struct uio_info *info, struct inode *inode)
 	if (test_and_set_bit(TCMU_DEV_BIT_OPEN, &udev->flags))
 		return -EBUSY;
 
+	udev->inode = inode;
+
 	pr_debug("open\n");
 
 	return 0;
@@ -1076,6 +1231,8 @@ static int tcmu_configure_device(struct se_device *dev)
 	udev->cmdr_size = CMDR_SIZE - CMDR_OFF;
 	udev->data_off = CMDR_SIZE;
 	udev->data_size = DATA_SIZE;
+	udev->dbi_thresh = DATA_BLOCK_BITS;
+	udev->unmapping = false;
 
 	/* Initialise the mailbox of the ring buffer */
 	mb = udev->mb_addr;
@@ -1121,6 +1278,10 @@ static int tcmu_configure_device(struct se_device *dev)
 	if (ret)
 		goto err_netlink;
 
+	mutex_lock(&udev_mutex);
+	list_add(&udev->node, &root_udev);
+	mutex_unlock(&udev_mutex);
+
 	return 0;
 
 err_netlink:
@@ -1164,6 +1325,10 @@ static void tcmu_free_device(struct se_device *dev)
 
 	del_timer_sync(&udev->timeout);
 
+	mutex_lock(&udev_mutex);
+	list_del(&udev->node);
+	mutex_unlock(&udev_mutex);
+
 	vfree(udev->mb_addr);
 
 	/* Upper layer should drain all requests before calling this */
@@ -1369,12 +1534,87 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
 	.tb_dev_attrib_attrs	= NULL,
 };
 
+static int unmap_thread_fn(void *data)
+{
+	struct tcmu_dev *udev;
+	loff_t off;
+	uint32_t start, end, dbi;
+	struct page *page;
+	int i;
+
+	while (1) {
+		DEFINE_WAIT(__wait);
+
+		prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
+		schedule();
+		finish_wait(&unmap_wait, &__wait);
+
+		mutex_lock(&udev_mutex);
+		list_for_each_entry(udev, &root_udev, node) {
+			mutex_lock(&udev->unmap_mutex);
+			spin_lock_irq(&udev->cmdr_lock);
+			end = udev->dbi_cur + 1;
+			dbi = find_last_bit(udev->data_bitmap, end);
+			if (dbi == end) {
+				/*
+				 * Reserving about DATA_BLOCK_RES_BITS
+				 * blocks for idle udev
+				 */
+				dbi = DATA_BLOCK_RES_BITS - 1;
+				udev->dbi_cur = 0;
+			} else {
+				udev->dbi_cur = dbi;
+
+				if (dbi < DATA_BLOCK_RES_BITS - 1)
+					dbi = DATA_BLOCK_RES_BITS - 1;
+			}
+
+			udev->dbi_thresh = start = dbi + 1;
+			if (start >= end) {
+				spin_unlock_irq(&udev->cmdr_lock);
+				mutex_unlock(&udev->unmap_mutex);
+				continue;
+			}
+			udev->unmapping = true;
+			spin_unlock_irq(&udev->cmdr_lock);
+
+			/* Here will truncate the ring from offset */
+			off = udev->data_off + start * DATA_BLOCK_SIZE;
+			unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
+
+			spin_lock_irq(&udev->cmdr_lock);
+			for (i = start; i < end; i++) {
+				page = radix_tree_delete(&udev->data_blocks, i);
+				if (page) {
+					__free_page(page);
+					spin_lock_irq(&db_count_lock);
+					global_db_count--;
+					spin_unlock_irq(&db_count_lock);
+				}
+			}
+			udev->unmapping = false;
+			spin_unlock_irq(&udev->cmdr_lock);
+			mutex_unlock(&udev->unmap_mutex);
+		}
+
+		list_for_each_entry(udev, &root_udev, node) {
+			if (udev->waiting_global)
+				wake_up(&udev->wait_cmdr);
+		}
+		mutex_unlock(&udev_mutex);
+	}
+
+	return 0;
+}
+
 static int __init tcmu_module_init(void)
 {
 	int ret, i, len = 0;
 
 	BUILD_BUG_ON((sizeof(struct tcmu_cmd_entry) % TCMU_OP_ALIGN_SIZE) != 0);
 
+	spin_lock_init(&db_count_lock);
+
 	tcmu_cmd_cache = kmem_cache_create("tcmu_cmd_cache",
 				sizeof(struct tcmu_cmd),
 				__alignof__(struct tcmu_cmd),
@@ -1414,8 +1654,17 @@ static int __init tcmu_module_init(void)
 	if (ret)
 		goto out_attrs;
 
+	init_waitqueue_head(&unmap_wait);
+	unmap_thread = kthread_run(unmap_thread_fn, NULL, "tcmu_unmap");
+	if (IS_ERR(unmap_thread)) {
+		unmap_thread = NULL;
+		goto out_unreg_transport;
+	}
+
 	return 0;
 
+out_unreg_transport:
+	target_backend_unregister(&tcmu_ops);
 out_attrs:
 	kfree(tcmu_attrs);
 out_unreg_genl:
@@ -1430,6 +1679,9 @@ static int __init tcmu_module_init(void)
 
 static void __exit tcmu_module_exit(void)
 {
+	if (unmap_thread)
+		kthread_stop(unmap_thread);
+
 	target_backend_unregister(&tcmu_ops);
 	kfree(tcmu_attrs);
 	genl_unregister_family(&tcmu_genl_family);
-- 
1.8.3.1
