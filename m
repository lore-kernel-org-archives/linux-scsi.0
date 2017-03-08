From: lixiubo@cmss.chinamobile.com
Subject: [PATCHv2 2/5] target/user: Add global data block pool support
Date: Wed,  8 Mar 2017 16:45:40 +0800
Message-ID: <1488962743-17028-3-git-send-email-lixiubo@cmss.chinamobile.com>
References: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:51598 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751276AbdCHIqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 03:46:39 -0500
In-Reply-To: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, Xiubo Li <lixiubo@cmss.chinamobile.com>

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

For each target there will be one ring, when the target number
grows larger and larger, it could eventually runs out of the
system memories.

In this patch for each target ring, the cmd area size will be
limited to 8M and the data area size will be limited to 1G. And
the data area will be divided into two parts: the fixed and
growing.

For the fixed part, it will be 1M size and pre-allocated together
with the cmd area. This could speed up the low iops case, and
also could make sure that each ring will have at least 1M private
data size when there has too many targets, which could get their
data blocks as quick as possible.

For the growing part, it will get the blocks from the global data
block pool. And this part will be used for high iops case.

The global data block pool is a cache, and the total size will be
limited to max 2G(grows from 0 to 2G as needed). And it will cache
the freed data blocks by a list, All targets will get from/release
to the free blocks here.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
Signed-off-by: Jianfei Hu <hujianfei@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 352 +++++++++++++++++++++++++++++++-------
 1 file changed, 290 insertions(+), 62 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index e904bc0..cd9bc4a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -66,17 +66,31 @@
 
 #define TCMU_TIME_OUT (30 * MSEC_PER_SEC)
 
-/* For cmd area, the size is fixed 2M */
-#define CMDR_SIZE (2 * 1024 * 1024)
+/* For cmd area, the size is 8M */
+#define CMDR_SIZE (8 * 1024 * 1024)
 
-/* For data area, the size is fixed 32M */
-#define DATA_BLOCK_BITS (8 * 1024)
+/*
+ * For data area, the total size is 1G: 1M fixed
+ * size area, which will always at the beginning,
+ * and 1023M grow size followed,
+ */
 #define DATA_BLOCK_SIZE 4096
+
+#define DATA_BLOCK_FIX_BITS 256
+#define DATA_FIX_SIZE (DATA_BLOCK_FIX_BITS * DATA_BLOCK_SIZE)
+
+#define DATA_BLOCK_GROW_BITS (256 * 1023)
+#define DATA_GROW_SIZE (DATA_BLOCK_GROW_BITS * DATA_BLOCK_SIZE)
+
+#define DATA_BLOCK_BITS (DATA_BLOCK_FIX_BITS + DATA_BLOCK_GROW_BITS)
 #define DATA_SIZE (DATA_BLOCK_BITS * DATA_BLOCK_SIZE)
 
-/* The ring buffer size is 34M */
+/* The ring buffer size is 8M + 1G */
 #define TCMU_RING_SIZE (CMDR_SIZE + DATA_SIZE)
 
+/* Default maximum of the global data blocks(2G) */
+#define TCMU_GLOBAL_MAX_BLOCKS (512 * 1024)
+
 static struct device *tcmu_root_device;
 
 struct tcmu_hba {
@@ -137,6 +151,18 @@ struct tcmu_cmd {
 	uint32_t *dbi;
 };
 
+struct tcmu_block {
+	struct list_head node;
+
+	void *addr;
+	uint32_t user;
+	bool using;
+};
+
+static unsigned long global_db_count;
+static LIST_HEAD(free_data_blockss);
+static spinlock_t g_lock;
+static struct kmem_cache *tcmu_block_cache;
 static struct kmem_cache *tcmu_cmd_cache;
 
 /* multicast group */
@@ -160,54 +186,178 @@ enum tcmu_multicast_groups {
 	.netnsok = true,
 };
 
-static int tcmu_db_get_empty_block(struct tcmu_dev *udev, void **addr)
+#define tcmu_cmd_reset_dbi_cur(cmd) ((cmd)->dbi_cur = 0)
+#define tcmu_cmd_set_dbi(cmd, index) ((cmd)->dbi[(cmd)->dbi_cur++] = (index))
+#define tcmu_cmd_get_dbi(cmd) ((cmd)->dbi[(cmd)->dbi_cur++])
+
+static inline struct tcmu_block *try_to_get_cached_free_block(void)
 {
-	void *p;
-	uint32_t dbi;
-	int ret;
+	struct tcmu_block *p;
+
+	if (list_empty(&free_data_blockss))
+		return NULL;
+
+	p = list_first_entry(&free_data_blockss, struct tcmu_block, node);
+	list_del(&p->node);
+
+	return p;
+}
+
+static inline bool get_empty_fixed_block(struct tcmu_dev *udev,
+					 struct tcmu_cmd *tcmu_cmd)
+{
+	uint32_t end = DATA_BLOCK_FIX_BITS;
+	int dbi = -1;
+
+	dbi = find_first_zero_bit(udev->data_bitmap, end);
+	if (dbi >= end)
+		return false;
 
-	dbi = find_first_zero_bit(udev->data_bitmap, DATA_BLOCK_BITS);
 	if (dbi > udev->dbi_cur)
 		udev->dbi_cur = dbi;
 
 	set_bit(dbi, udev->data_bitmap);
+	tcmu_cmd_set_dbi(tcmu_cmd, dbi);
+	return true;
+}
+
+static inline bool get_empty_growing_block(struct tcmu_dev *udev,
+					   struct tcmu_cmd *tcmu_cmd)
+{
+	struct tcmu_block *p;
+	uint32_t end = DATA_BLOCK_BITS;
+	int ret, dbi = DATA_BLOCK_FIX_BITS - 1;
+	bool new = false;
+
+retry:
+	dbi = find_next_zero_bit(udev->data_bitmap, end, dbi + 1);
+	if (dbi >= end)
+		return false;
 
+	spin_lock_irq(&g_lock);
 	p = radix_tree_lookup(&udev->data_blocks, dbi);
 	if (!p) {
-		p = kzalloc(DATA_BLOCK_SIZE, GFP_ATOMIC);
+		/* try to get the page from free list first */
+		p = try_to_get_cached_free_block();
 		if (!p) {
-			clear_bit(dbi, udev->data_bitmap);
-			return -ENOMEM;
+			/* try to get new page from the mm */
+			if (global_db_count >= TCMU_GLOBAL_MAX_BLOCKS) {
+				spin_unlock_irq(&g_lock);
+				return false;
+			}
+
+			p = kmem_cache_zalloc(tcmu_block_cache, GFP_ATOMIC);
+			if (!p) {
+				spin_unlock_irq(&g_lock);
+				return false;
+			}
+
+			p->addr = kzalloc(DATA_BLOCK_SIZE, GFP_ATOMIC);
+			if (!p->addr) {
+				spin_unlock_irq(&g_lock);
+				kmem_cache_free(tcmu_block_cache, p);
+				return false;
+			}
+
+			new = true;
+			global_db_count++;
 		}
 
 		ret = radix_tree_insert(&udev->data_blocks, dbi, p);
 		if (ret) {
-			kfree(p);
-			clear_bit(dbi, udev->data_bitmap);
-			return ret;
+			if (new) {
+				kfree(p->addr);
+				kmem_cache_free(tcmu_block_cache, p);
+				global_db_count--;
+			}
+			spin_unlock_irq(&g_lock);
+			return false;
 		}
+
+		p->user++;
+	} else if (p->using) {
+		spin_unlock_irq(&g_lock);
+		goto retry;
+	} else {
+		list_del(&p->node);
 	}
+	p->using = true;
+	spin_unlock_irq(&g_lock);
 
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
 
-static void *tcmu_db_get_block_addr(struct tcmu_dev *udev, uint32_t dbi)
+static bool tcmu_db_get_empty_blocks(struct tcmu_dev *udev,
+				     struct tcmu_cmd *tcmu_cmd)
 {
-	return radix_tree_lookup(&udev->data_blocks, dbi);
+	bool fix = true;
+	int i;
+
+	for (i = 0; i < tcmu_cmd->dbi_len; i++) {
+		/* Try to get free blocks from the fixed area */
+		if (fix) {
+			if (get_empty_fixed_block(udev, tcmu_cmd))
+				continue;
+			fix = false;
+		}
+
+		/* Then try to get free blocks from the grow area */
+		if (!get_empty_growing_block(udev, tcmu_cmd))
+			return false;
+	}
+
+	return true;
 }
 
-#define tcmu_cmd_reset_dbi_cur(cmd) ((cmd)->dbi_cur = 0)
-#define tcmu_cmd_set_dbi(cmd, index) ((cmd)->dbi[(cmd)->dbi_cur++] = (index))
-#define tcmu_cmd_get_dbi(cmd) ((cmd)->dbi[(cmd)->dbi_cur++])
+static void *tcmu_db_get_block_addr(struct tcmu_dev *udev, uint32_t dbi)
+{
+	unsigned long offset = udev->data_off + dbi * DATA_BLOCK_SIZE;
+	struct tcmu_block *p;
 
-static void tcmu_cmd_free_data(struct tcmu_cmd *tcmu_cmd)
+	if (dbi < DATA_BLOCK_FIX_BITS)
+		return (void *)((unsigned long)udev->mb_addr + offset);
+
+	p = radix_tree_lookup(&udev->data_blocks, dbi);
+	if (!p)
+		return NULL;
+
+	return p->addr;
+}
+
+static void tcmu_cmd_free_data(struct tcmu_cmd *tcmu_cmd,
+			       uint32_t len, bool del)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
-	uint32_t bi;
+	struct tcmu_block *p;
+	uint32_t i, dbi;
+
+	for (i = 0; i < len; i++) {
+		dbi = tcmu_cmd->dbi[i];
+		clear_bit(dbi, udev->data_bitmap);
+
+		if (dbi < DATA_BLOCK_FIX_BITS)
+			continue;
 
-	for (bi = 0; bi < tcmu_cmd->dbi_len; bi++)
-		clear_bit(tcmu_cmd->dbi[bi], udev->data_bitmap);
+		spin_lock_irq(&g_lock);
+		p = radix_tree_lookup(&udev->data_blocks, dbi);
+		BUG_ON(!p);
+
+		if (p->user == 1 && del) {
+			p = radix_tree_delete(&udev->data_blocks, dbi);
+			kfree(p->addr);
+			kmem_cache_free(tcmu_block_cache, p);
+		} else {
+			p->using = false;
+			list_add(&p->node, &free_data_blockss);
+		}
+		spin_unlock_irq(&g_lock);
+	}
 }
 
 static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
@@ -351,10 +501,8 @@ static int alloc_and_scatter_data_area(struct tcmu_dev *udev,
 		while (sg_remaining > 0) {
 			if (block_remaining == 0) {
 				block_remaining = DATA_BLOCK_SIZE;
-				dbi = tcmu_db_get_empty_block(udev, &to);
-				if (dbi < 0)
-					return dbi;
-				tcmu_cmd_set_dbi(tcmu_cmd, dbi);
+				dbi = tcmu_cmd_get_dbi(tcmu_cmd);
+				to = tcmu_db_get_block_addr(udev, dbi);
 			}
 
 			copy_bytes = min_t(size_t, sg_remaining,
@@ -362,7 +510,7 @@ static int alloc_and_scatter_data_area(struct tcmu_dev *udev,
 			to_offset = get_block_offset_user(udev, dbi,
 					block_remaining);
 			offset = DATA_BLOCK_SIZE - block_remaining;
-			to = (void *)(unsigned long)to + offset;
+			to = (void *)((unsigned long)to + offset);
 
 			if (*iov_cnt != 0 &&
 			    to_offset == iov_tail(udev, *iov)) {
@@ -407,7 +555,7 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *tcmu_cmd,
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
 			offset = DATA_BLOCK_SIZE - block_remaining;
-			from = (void *)(unsigned long)from + offset;
+			from = (void *)((unsigned long)from + offset);
 			tcmu_flush_dcache_range(from, copy_bytes);
 			memcpy(to + sg->length - sg_remaining, from,
 					copy_bytes);
@@ -431,7 +579,8 @@ static inline size_t spc_bitmap_free(unsigned long *bitmap)
  *
  * Called with ring lock held.
  */
-static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t data_needed)
+static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
+		size_t cmd_size, size_t data_needed)
 {
 	struct tcmu_mailbox *mb = udev->mb_addr;
 	size_t space, cmd_needed;
@@ -457,6 +606,7 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 		return false;
 	}
 
+	/* try to check and get the data blocks as needed */
 	space = spc_bitmap_free(udev->data_bitmap);
 	if (space < data_needed) {
 		pr_debug("no data space: only %zu available, but ask for %zu\n",
@@ -464,6 +614,12 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 		return false;
 	}
 
+	if (!tcmu_db_get_empty_blocks(udev, cmd)) {
+		pr_debug("no data space: ask for %zu\n", data_needed);
+		tcmu_cmd_free_data(cmd, cmd->dbi_cur, true);
+		return false;
+	}
+
 	return true;
 }
 
@@ -519,7 +675,7 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 		return TCM_INVALID_CDB_FIELD;
 	}
 
-	while (!is_ring_space_avail(udev, command_size, data_length)) {
+	while (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
 		int ret;
 		DEFINE_WAIT(__wait);
 
@@ -567,6 +723,7 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 	entry->hdr.uflags = 0;
 
 	/* Handle allocating space from the data area */
+	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
 	iov = &entry->req.iov[0];
 	iov_cnt = 0;
 	copy_to_data_area = (se_cmd->data_direction == DMA_TO_DEVICE
@@ -664,7 +821,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
 
 	cmd->se_cmd = NULL;
-	tcmu_cmd_free_data(cmd);
+	tcmu_cmd_free_data(cmd, cmd->dbi_len, false);
 	tcmu_free_cmd(cmd);
 }
 
@@ -783,41 +940,98 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 
 static void tcmu_db_release(struct tcmu_dev *udev, bool release_pending)
 {
-	uint32_t dbi, end;
-	void *addr;
+	int dbi = -1, end;
+	struct tcmu_block *p;
 
 	spin_lock_irq(&udev->cmdr_lock);
-
 	end = udev->dbi_cur + 1;
 
-	/* try to release all unused blocks */
-	dbi = find_first_zero_bit(udev->data_bitmap, end);
-	if (dbi >= end) {
-		spin_unlock_irq(&udev->cmdr_lock);
-		return;
-	}
+	/* try to release all unused but has mapped blocks */
 	do {
-		addr = radix_tree_delete(&udev->data_blocks, dbi);
-		kfree(addr);
-
 		dbi = find_next_zero_bit(udev->data_bitmap, end, dbi + 1);
-	} while (dbi < end);
+		if (dbi >= end)
+			break;
 
-	if (!release_pending)
-		return;
+		if (dbi < DATA_BLOCK_FIX_BITS)
+			continue;
+		/*
+		 * When the bit is cleared and p != NULL, meaning that
+		 * this tcmu block had already freed-after-use.
+		 *
+		 * If p->user == 0, meaning that the current ring buffer
+		 * is the last or the only user of the tcmu block, and
+		 * it must already in the free list, so it could be
+		 * remove from the list and then released its memories.
+		 *
+		 * If p->user != 0, meaning that the current tcmu block is
+		 * still referenced by other ring buffers, so just ignore
+		 * it without doing anyting.
+		 */
+		spin_lock_irq(&g_lock);
+		p = radix_tree_delete(&udev->data_blocks, dbi);
+		if (p) {
+			p->user--;
+			if (p->user == 0) {
+				list_del(&p->node);
+				kfree(p->addr);
+				kmem_cache_free(tcmu_block_cache, p);
+				global_db_count--;
+			}
+		}
+		spin_unlock_irq(&g_lock);
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
 
+	/* try to release all pending blocks */
+	dbi = -1;
+	do {
 		dbi = find_next_bit(udev->data_bitmap, end, dbi + 1);
-	} while (dbi < end);
+		if (dbi >= end)
+			break;
+
+		clear_bit(dbi, udev->data_bitmap);
+
+		if (dbi < DATA_BLOCK_FIX_BITS)
+			continue;
+
+		/*
+		 * When the bit is set and p != NULL, meaning that this
+		 * tcmu block is still being used here.
+		 *
+		 * If p->user == 0, meaning that the current ring buffer
+		 * is the last or the only user of this tcmu block, and
+		 * it won't in the free list, so could just release its
+		 * memories.
+		 *
+		 * If the p->user != 0, we should insert it to the free
+		 * list.
+		 *
+		 * p == NULL means that the current ring buffer is broken.
+		 */
+		spin_lock_irq(&g_lock);
+		p = radix_tree_delete(&udev->data_blocks, dbi);
+		if (p) {
+			p->user--;
+			p->using = false;
+			if (p->user == 0) {
+				kfree(p->addr);
+				kmem_cache_free(tcmu_block_cache, p);
+				global_db_count--;
+			} else {
+				list_add(&p->node, &free_data_blockss);
+			}
+		} else {
+			pr_err("block page not found, ring is broken\n");
+			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
+			spin_unlock_irq(&g_lock);
+			break;
+		}
+		spin_unlock_irq(&g_lock);
+	} while (1);
 
 	spin_unlock_irq(&udev->cmdr_lock);
 }
@@ -851,7 +1065,7 @@ static int tcmu_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct tcmu_dev *udev = vma->vm_private_data;
 	struct uio_info *info = &udev->uio_info;
 	struct page *page;
-	unsigned long offset;
+	unsigned long offset, vm_offset = udev->data_off + DATA_FIX_SIZE;
 	void *addr;
 
 	int mi = tcmu_find_mem_index(vma);
@@ -864,9 +1078,9 @@ static int tcmu_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 */
 	offset = (vmf->pgoff - mi) << PAGE_SHIFT;
 
-	if (offset < udev->data_off) {
+	if (offset < vm_offset) {
 		/* For the vmalloc()ed cmd area pages */
-		addr = (void *)(unsigned long)info->mem[mi].addr + offset;
+		addr = (void *)((unsigned long)info->mem[mi].addr + offset);
 		page = vmalloc_to_page(addr);
 	} else {
 		/* For the dynamically growing data area pages */
@@ -993,7 +1207,7 @@ static int tcmu_configure_device(struct se_device *dev)
 
 	info->name = str;
 
-	udev->mb_addr = vzalloc(CMDR_SIZE);
+	udev->mb_addr = vzalloc(CMDR_SIZE + DATA_FIX_SIZE);
 	if (!udev->mb_addr) {
 		ret = -ENOMEM;
 		goto err_vzalloc;
@@ -1241,6 +1455,9 @@ static int __init tcmu_module_init(void)
 
 	BUILD_BUG_ON((sizeof(struct tcmu_cmd_entry) % TCMU_OP_ALIGN_SIZE) != 0);
 
+	spin_lock_init(&g_lock);
+	global_db_count = 0;
+
 	tcmu_cmd_cache = kmem_cache_create("tcmu_cmd_cache",
 				sizeof(struct tcmu_cmd),
 				__alignof__(struct tcmu_cmd),
@@ -1248,6 +1465,15 @@ static int __init tcmu_module_init(void)
 	if (!tcmu_cmd_cache)
 		return -ENOMEM;
 
+	tcmu_block_cache = kmem_cache_create("tcmu_block_cache",
+				sizeof(struct tcmu_block),
+				__alignof__(struct tcmu_block),
+				0, NULL);
+	if (!tcmu_block_cache) {
+		kmem_cache_destroy(tcmu_cmd_cache);
+		return -ENOMEM;
+	}
+
 	tcmu_root_device = root_device_register("tcm_user");
 	if (IS_ERR(tcmu_root_device)) {
 		ret = PTR_ERR(tcmu_root_device);
@@ -1270,6 +1496,7 @@ static int __init tcmu_module_init(void)
 out_unreg_device:
 	root_device_unregister(tcmu_root_device);
 out_free_cache:
+	kmem_cache_destroy(tcmu_block_cache);
 	kmem_cache_destroy(tcmu_cmd_cache);
 
 	return ret;
@@ -1280,6 +1507,7 @@ static void __exit tcmu_module_exit(void)
 	target_backend_unregister(&tcmu_ops);
 	genl_unregister_family(&tcmu_genl_family);
 	root_device_unregister(tcmu_root_device);
+	kmem_cache_destroy(tcmu_block_cache);
 	kmem_cache_destroy(tcmu_cmd_cache);
 }
 
-- 
1.8.3.1
