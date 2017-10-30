From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 18/19] tcmu: allow max block and global max blocks to be settable
Date: Sun, 29 Oct 2017 22:44:38 -0500
Message-ID: <1509335079-5276-19-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Users might have a physical system to a target so they could
have a lot more than 2 gigs of memory they want to devote to
tcmu. OTOH, we could be running in a vm and so a 2 gig
global and 1 gig per dev limit might be too high. This patch
allows the user to specify the limits.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 143 +++++++++++++++++++++++++++++++++-----
 1 file changed, 124 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 92eb918..f49f765 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -77,9 +77,13 @@
  * the total size is 256K * PAGE_SIZE.
  */
 #define DATA_BLOCK_SIZE PAGE_SIZE
-#define DATA_BLOCK_BITS (256 * 1024)
+#define DATA_BLOCK_SHIFT PAGE_SHIFT
+#define DATA_BLOCK_BITS_DEF (256 * 1024)
 #define DATA_SIZE (DATA_BLOCK_BITS * DATA_BLOCK_SIZE)
 
+#define TCMU_MBS_TO_BLOCKS(_mbs) (_mbs << (20 - DATA_BLOCK_SHIFT))
+#define TCMU_BLOCKS_TO_MBS(_blocks) (_blocks >> (20 - DATA_BLOCK_SHIFT))
+
 /* The total size of the ring is 8M + 256K * PAGE_SIZE */
 #define TCMU_RING_SIZE (CMDR_SIZE + DATA_SIZE)
 
@@ -87,7 +91,7 @@
  * Default number of global data blocks(512K * PAGE_SIZE)
  * when the unmap thread will be started.
  */
-#define TCMU_GLOBAL_MAX_BLOCKS (512 * 1024)
+#define TCMU_GLOBAL_MAX_BLOCKS_DEF (512 * 1024)
 
 static u8 tcmu_kern_cmd_reply_supported;
 
@@ -131,13 +135,15 @@ struct tcmu_dev {
 	/* Must add data_off and mb_addr to get the address */
 	size_t data_off;
 	size_t data_size;
+	uint32_t max_blocks;
+	size_t ring_size;
 
 	struct mutex cmdr_lock;
 	struct list_head cmdr_queue;
 
 	uint32_t dbi_max;
 	uint32_t dbi_thresh;
-	DECLARE_BITMAP(data_bitmap, DATA_BLOCK_BITS);
+	unsigned long *data_bitmap;
 	struct radix_tree_root data_blocks;
 
 	struct idr commands;
@@ -198,10 +204,51 @@ struct tcmu_cmd {
 static DEFINE_SPINLOCK(timed_out_udevs_lock);
 static LIST_HEAD(timed_out_udevs);
 
+static struct kmem_cache *tcmu_cmd_cache;
+
 static atomic_t global_db_count = ATOMIC_INIT(0);
 static struct delayed_work tcmu_unmap_work;
+static int tcmu_global_max_blocks = TCMU_GLOBAL_MAX_BLOCKS_DEF;
 
-static struct kmem_cache *tcmu_cmd_cache;
+static int tcmu_set_global_max_data_area(const char *str,
+					 const struct kernel_param *kp)
+{
+	int ret, max_area_mb;
+
+	ret = kstrtoint(str, 10, &max_area_mb);
+	if (ret)
+		return -EINVAL;
+
+	if (max_area_mb <= 0) {
+		pr_err("global_max_data_area must be larger than 0.\n");
+		return -EINVAL;
+	}
+
+	tcmu_global_max_blocks = TCMU_MBS_TO_BLOCKS(max_area_mb);
+	if (atomic_read(&global_db_count) > tcmu_global_max_blocks)
+		schedule_delayed_work(&tcmu_unmap_work, 0);
+	else
+		cancel_delayed_work_sync(&tcmu_unmap_work);
+
+	return 0;
+}
+
+static int tcmu_get_global_max_data_area(char *buffer,
+					 const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%d", TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
+}
+
+static const struct kernel_param_ops tcmu_global_max_data_area_op = {
+	.set = tcmu_set_global_max_data_area,
+	.get = tcmu_get_global_max_data_area,
+};
+
+module_param_cb(global_max_data_area_mb, &tcmu_global_max_data_area_op, NULL,
+		S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(global_max_data_area_mb,
+		 "Max MBs allowed to be allocated to all the tcmu device's "
+		 "data areas.");
 
 /* multicast group */
 enum tcmu_multicast_groups {
@@ -363,7 +410,7 @@ static inline bool tcmu_get_empty_block(struct tcmu_dev *udev,
 	page = radix_tree_lookup(&udev->data_blocks, dbi);
 	if (!page) {
 		if (atomic_add_return(1, &global_db_count) >
-					TCMU_GLOBAL_MAX_BLOCKS)
+				      tcmu_global_max_blocks)
 			schedule_delayed_work(&tcmu_unmap_work, 0);
 
 		/* try to get new page from the mm */
@@ -705,8 +752,8 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	/* try to check and get the data blocks as needed */
 	space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
 	if ((space * DATA_BLOCK_SIZE) < data_needed) {
-		unsigned long blocks_left = DATA_BLOCK_BITS - udev->dbi_thresh +
-						space;
+		unsigned long blocks_left =
+				(udev->max_blocks - udev->dbi_thresh) + space;
 
 		if (blocks_left < blocks_needed) {
 			pr_debug("no data space: only %lu available, but ask for %zu\n",
@@ -716,8 +763,8 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 		}
 
 		udev->dbi_thresh += blocks_needed;
-		if (udev->dbi_thresh > DATA_BLOCK_BITS)
-			udev->dbi_thresh = DATA_BLOCK_BITS;
+		if (udev->dbi_thresh > udev->max_blocks)
+			udev->dbi_thresh = udev->max_blocks;
 	}
 
 	return tcmu_get_empty_blocks(udev, cmd);
@@ -1072,7 +1119,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 			 * reclaim blocks if needed.
 			 */
 			if (atomic_read(&global_db_count) >
-			    TCMU_GLOBAL_MAX_BLOCKS)
+			    tcmu_global_max_blocks)
 				schedule_delayed_work(&tcmu_unmap_work, 0);
 		}
 	}
@@ -1179,6 +1226,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	udev->cmd_time_out = TCMU_TIME_OUT;
 	udev->qfull_time_out = -1;
 
+	udev->max_blocks = DATA_BLOCK_BITS_DEF;
 	mutex_init(&udev->cmdr_lock);
 
 	INIT_LIST_HEAD(&udev->timedout_entry);
@@ -1323,7 +1371,7 @@ static struct page *tcmu_try_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 
 		/*
 		 * Since this case is rare in page fault routine, here we
-		 * will allow the global_db_count >= TCMU_GLOBAL_MAX_BLOCKS
+		 * will allow the global_db_count >= tcmu_global_max_blocks
 		 * to reduce possible page fault call trace.
 		 */
 		atomic_inc(&global_db_count);
@@ -1384,7 +1432,7 @@ static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
 	vma->vm_private_data = udev;
 
 	/* Ensure the mmap is exactly the right size */
-	if (vma_pages(vma) != (TCMU_RING_SIZE >> PAGE_SHIFT))
+	if (vma_pages(vma) != (udev->ring_size >> PAGE_SHIFT))
 		return -EINVAL;
 
 	return 0;
@@ -1466,6 +1514,7 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	WARN_ON(!all_expired);
 
 	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max + 1);
+	kfree(udev->data_bitmap);
 	mutex_unlock(&udev->cmdr_lock);
 
 	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
@@ -1642,6 +1691,11 @@ static int tcmu_configure_device(struct se_device *dev)
 
 	info = &udev->uio_info;
 
+	udev->data_bitmap = kzalloc(BITS_TO_LONGS(udev->max_blocks) *
+				    sizeof(unsigned long), GFP_KERNEL);
+	if (!udev->data_bitmap)
+		goto err_bitmap_alloc;
+
 	udev->mb_addr = vzalloc(CMDR_SIZE);
 	if (!udev->mb_addr) {
 		ret = -ENOMEM;
@@ -1651,7 +1705,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	/* mailbox fits in first part of CMDR space */
 	udev->cmdr_size = CMDR_SIZE - CMDR_OFF;
 	udev->data_off = CMDR_SIZE;
-	udev->data_size = DATA_SIZE;
+	udev->data_size = udev->max_blocks * DATA_BLOCK_SIZE;
 	udev->dbi_thresh = 0; /* Default in Idle state */
 
 	/* Initialise the mailbox of the ring buffer */
@@ -1669,7 +1723,7 @@ static int tcmu_configure_device(struct se_device *dev)
 
 	info->mem[0].name = "tcm-user command & data buffer";
 	info->mem[0].addr = (phys_addr_t)(uintptr_t)udev->mb_addr;
-	info->mem[0].size = TCMU_RING_SIZE;
+	info->mem[0].size = udev->ring_size = udev->data_size + CMDR_SIZE;
 	info->mem[0].memtype = UIO_MEM_NONE;
 
 	info->irqcontrol = tcmu_irqcontrol;
@@ -1722,6 +1776,9 @@ static int tcmu_configure_device(struct se_device *dev)
 	vfree(udev->mb_addr);
 	udev->mb_addr = NULL;
 err_vzalloc:
+	kfree(udev->data_bitmap);
+	udev->data_bitmap = NULL;
+err_bitmap_alloc:
 	kfree(info->name);
 	info->name = NULL;
 
@@ -1762,7 +1819,7 @@ static void tcmu_destroy_device(struct se_device *dev)
 
 enum {
 	Opt_dev_config, Opt_dev_size, Opt_hw_block_size, Opt_hw_max_sectors,
-	Opt_nl_reply_supported, Opt_err,
+	Opt_nl_reply_supported, Opt_max_data_area_mb, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -1771,6 +1828,7 @@ enum {
 	{Opt_hw_block_size, "hw_block_size=%u"},
 	{Opt_hw_max_sectors, "hw_max_sectors=%u"},
 	{Opt_nl_reply_supported, "nl_reply_supported=%d"},
+	{Opt_max_data_area_mb, "max_data_area_mb=%u"},
 	{Opt_err, NULL}
 };
 
@@ -1804,7 +1862,7 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 	struct tcmu_dev *udev = TCMU_DEV(dev);
 	char *orig, *ptr, *opts, *arg_p;
 	substring_t args[MAX_OPT_ARGS];
-	int ret = 0, token;
+	int ret = 0, token, tmpval;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -1856,6 +1914,39 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 			if (ret < 0)
 				pr_err("kstrtoint() failed for nl_reply_supported=\n");
 			break;
+		case Opt_max_data_area_mb:
+			if (dev->export_count) {
+				pr_err("Unable to set max_data_area_mb while exports exist\n");
+				ret = -EINVAL;
+				break;
+			}
+
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
+			ret = kstrtoint(arg_p, 0, &tmpval);
+			kfree(arg_p);
+			if (ret < 0) {
+				pr_err("kstrtoint() failed for max_data_area_mb=\n");
+				break;
+			}
+
+			if (tmpval <= 0) {
+				pr_err("Invalid max_data_area %d\n", tmpval);
+				ret = -EINVAL;
+				break;
+			}
+
+			udev->max_blocks = TCMU_MBS_TO_BLOCKS(tmpval);
+			if (udev->max_blocks > tcmu_global_max_blocks) {
+				pr_err("%d is too large. Adjusting max_data_area_mb to global limit of %u\n",
+				       tmpval,
+				       TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
+				udev->max_blocks = tcmu_global_max_blocks;
+			}
+			break;
 		default:
 			break;
 		}
@@ -1875,7 +1966,9 @@ static ssize_t tcmu_show_configfs_dev_params(struct se_device *dev, char *b)
 
 	bl = sprintf(b + bl, "Config: %s ",
 		     udev->dev_config[0] ? udev->dev_config : "NULL");
-	bl += sprintf(b + bl, "Size: %zu\n", udev->dev_size);
+	bl += sprintf(b + bl, "Size: %zu ", udev->dev_size);
+	bl += sprintf(b + bl, "MaxDataAreaMB: %u\n",
+		      TCMU_BLOCKS_TO_MBS(udev->max_blocks));
 
 	return bl;
 }
@@ -1960,6 +2053,17 @@ static ssize_t tcmu_qfull_time_out_store(struct config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, qfull_time_out);
 
+static ssize_t tcmu_max_data_area_mb_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%u\n",
+			TCMU_BLOCKS_TO_MBS(udev->max_blocks));
+}
+CONFIGFS_ATTR_RO(tcmu_, max_data_area_mb);
+
 static ssize_t tcmu_dev_config_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = container_of(to_config_group(item),
@@ -2106,6 +2210,7 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
 	&tcmu_attr_qfull_time_out,
+	&tcmu_attr_max_data_area_mb,
 	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
@@ -2139,7 +2244,7 @@ static void find_free_blocks(void)
 	loff_t off;
 	u32 start, end, block, total_freed = 0;
 
-	if (atomic_read(&global_db_count) <= TCMU_GLOBAL_MAX_BLOCKS)
+	if (atomic_read(&global_db_count) <= tcmu_global_max_blocks)
 		return;
 
 	mutex_lock(&root_udev_mutex);
@@ -2187,7 +2292,7 @@ static void find_free_blocks(void)
 	}
 	mutex_unlock(&root_udev_mutex);
 
-	if (atomic_read(&global_db_count) > TCMU_GLOBAL_MAX_BLOCKS)
+	if (atomic_read(&global_db_count) > tcmu_global_max_blocks)
 		schedule_delayed_work(&tcmu_unmap_work, msecs_to_jiffies(5000));
 }
 
-- 
1.8.3.1
