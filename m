From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 089/103] target: Remove direct ramdisk code
Date: Thu, 21 Jul 2011 07:05:21 +0000
Message-ID: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51659 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1GUH3O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2011 03:29:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Instead of converting rd_dr to be se_mem-free, just remove it.

This also lets us remove hooks like do_se_mem_map, that are in the common
path but only implemented by rd_dr.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    2 +-
 drivers/target/target_core_rd.c     |  309 -----------------------------------
 2 files changed, 1 insertions(+), 310 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 1185c3b..0b75923 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1575,7 +1575,7 @@ int core_dev_setup_virtual_lun0(void)
 	char buf[16];
 	int ret;
 
-	hba = core_alloc_hba("rd_dr", 0, HBA_FLAGS_INTERNAL_USE);
+	hba = core_alloc_hba("rd_mcp", 0, HBA_FLAGS_INTERNAL_USE);
 	if (IS_ERR(hba))
 		return PTR_ERR(hba);
 
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 4f9416d..3fe3562 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -44,7 +44,6 @@
 
 #include "target_core_rd.h"
 
-static struct se_subsystem_api rd_dr_template;
 static struct se_subsystem_api rd_mcp_template;
 
 /* #define DEBUG_RAMDISK_MCP */
@@ -226,11 +225,6 @@ static void *rd_allocate_virtdevice(
 	return rd_dev;
 }
 
-static void *rd_DIRECT_allocate_virtdevice(struct se_hba *hba, const char *name)
-{
-	return rd_allocate_virtdevice(hba, name, 1);
-}
-
 static void *rd_MEMCPY_allocate_virtdevice(struct se_hba *hba, const char *name)
 {
 	return rd_allocate_virtdevice(hba, name, 0);
@@ -270,7 +264,6 @@ static struct se_device *rd_create_virtdevice(
 	dev_limits.queue_depth = RD_DEVICE_QUEUE_DEPTH;
 
 	dev = transport_add_device_to_core_hba(hba,
-			(rd_dev->rd_direct) ? &rd_dr_template :
 			&rd_mcp_template, se_dev, dev_flags, rd_dev,
 			&dev_limits, prod, rev);
 	if (!(dev))
@@ -293,14 +286,6 @@ fail:
 	return ERR_PTR(ret);
 }
 
-static struct se_device *rd_DIRECT_create_virtdevice(
-	struct se_hba *hba,
-	struct se_subsystem_dev *se_dev,
-	void *p)
-{
-	return rd_create_virtdevice(hba, se_dev, p, 1);
-}
-
 static struct se_device *rd_MEMCPY_create_virtdevice(
 	struct se_hba *hba,
 	struct se_subsystem_dev *se_dev,
@@ -641,273 +626,6 @@ static int rd_MEMCPY_do_task(struct se_task *task)
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
 
-/*	rd_DIRECT_with_offset():
- *
- *
- */
-static int rd_DIRECT_with_offset(
-	struct se_task *task,
-	struct list_head *se_mem_list,
-	u32 *se_mem_cnt,
-	u32 *task_offset)
-{
-	struct rd_request *req = RD_REQ(task);
-	struct rd_dev *dev = req->rd_dev;
-	struct rd_dev_sg_table *table;
-	struct se_mem *se_mem;
-	struct scatterlist *sg_s;
-	u32 j = 0, set_offset = 1;
-	u32 get_next_table = 0, offset_length, table_sg_end;
-
-	table = rd_get_sg_table(dev, req->rd_page);
-	if (!(table))
-		return -EINVAL;
-
-	table_sg_end = (table->page_end_offset - req->rd_page);
-	sg_s = &table->sg_table[req->rd_page - table->page_start_offset];
-#ifdef DEBUG_RAMDISK_DR
-	printk(KERN_INFO "%s DIRECT LBA: %llu, Size: %u Page: %u, Offset: %u\n",
-		(task->task_data_direction == DMA_TO_DEVICE) ?
-			"Write" : "Read",
-		task->task_lba, req->rd_size, req->rd_page, req->rd_offset);
-#endif
-	while (req->rd_size) {
-		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
-		if (!(se_mem)) {
-			printk(KERN_ERR "Unable to allocate struct se_mem\n");
-			return -ENOMEM;
-		}
-		INIT_LIST_HEAD(&se_mem->se_list);
-
-		if (set_offset) {
-			offset_length = sg_s[j].length - req->rd_offset;
-			if (offset_length > req->rd_size)
-				offset_length = req->rd_size;
-
-			se_mem->se_page = sg_page(&sg_s[j++]);
-			se_mem->se_off = req->rd_offset;
-			se_mem->se_len = offset_length;
-
-			set_offset = 0;
-			get_next_table = (j > table_sg_end);
-			goto check_eot;
-		}
-
-		offset_length = (req->rd_size < req->rd_offset) ?
-			req->rd_size : req->rd_offset;
-
-		se_mem->se_page = sg_page(&sg_s[j]);
-		se_mem->se_len = offset_length;
-
-		set_offset = 1;
-
-check_eot:
-#ifdef DEBUG_RAMDISK_DR
-		printk(KERN_INFO "page: %u, size: %u, offset_length: %u, j: %u"
-			" se_mem: %p, se_page: %p se_off: %u se_len: %u\n",
-			req->rd_page, req->rd_size, offset_length, j, se_mem,
-			se_mem->se_page, se_mem->se_off, se_mem->se_len);
-#endif
-		list_add_tail(&se_mem->se_list, se_mem_list);
-		(*se_mem_cnt)++;
-
-		req->rd_size -= offset_length;
-		if (!(req->rd_size))
-			goto out;
-
-		if (!set_offset && !get_next_table)
-			continue;
-
-		if (++req->rd_page <= table->page_end_offset) {
-#ifdef DEBUG_RAMDISK_DR
-			printk(KERN_INFO "page: %u in same page table\n",
-					req->rd_page);
-#endif
-			continue;
-		}
-#ifdef DEBUG_RAMDISK_DR
-		printk(KERN_INFO "getting new page table for page: %u\n",
-				req->rd_page);
-#endif
-		table = rd_get_sg_table(dev, req->rd_page);
-		if (!(table))
-			return -EINVAL;
-
-		sg_s = &table->sg_table[j = 0];
-	}
-
-out:
-	task->task_se_cmd->t_tasks_se_num += *se_mem_cnt;
-#ifdef DEBUG_RAMDISK_DR
-	printk(KERN_INFO "RD_DR - Allocated %u struct se_mem segments for task\n",
-			*se_mem_cnt);
-#endif
-	return 0;
-}
-
-/*	rd_DIRECT_without_offset():
- *
- *
- */
-static int rd_DIRECT_without_offset(
-	struct se_task *task,
-	struct list_head *se_mem_list,
-	u32 *se_mem_cnt,
-	u32 *task_offset)
-{
-	struct rd_request *req = RD_REQ(task);
-	struct rd_dev *dev = req->rd_dev;
-	struct rd_dev_sg_table *table;
-	struct se_mem *se_mem;
-	struct scatterlist *sg_s;
-	u32 length, j = 0;
-
-	table = rd_get_sg_table(dev, req->rd_page);
-	if (!(table))
-		return -EINVAL;
-
-	sg_s = &table->sg_table[req->rd_page - table->page_start_offset];
-#ifdef DEBUG_RAMDISK_DR
-	printk(KERN_INFO "%s DIRECT LBA: %llu, Size: %u, Page: %u\n",
-		(task->task_data_direction == DMA_TO_DEVICE) ?
-			"Write" : "Read",
-		task->task_lba, req->rd_size, req->rd_page);
-#endif
-	while (req->rd_size) {
-		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
-		if (!(se_mem)) {
-			printk(KERN_ERR "Unable to allocate struct se_mem\n");
-			return -ENOMEM;
-		}
-		INIT_LIST_HEAD(&se_mem->se_list);
-
-		length = (req->rd_size < sg_s[j].length) ?
-			req->rd_size : sg_s[j].length;
-
-		se_mem->se_page = sg_page(&sg_s[j++]);
-		se_mem->se_len = length;
-
-#ifdef DEBUG_RAMDISK_DR
-		printk(KERN_INFO "page: %u, size: %u, j: %u se_mem: %p,"
-			" se_page: %p se_off: %u se_len: %u\n", req->rd_page,
-			req->rd_size, j, se_mem, se_mem->se_page,
-			se_mem->se_off, se_mem->se_len);
-#endif
-		list_add_tail(&se_mem->se_list, se_mem_list);
-		(*se_mem_cnt)++;
-
-		req->rd_size -= length;
-		if (!(req->rd_size))
-			goto out;
-
-		if (++req->rd_page <= table->page_end_offset) {
-#ifdef DEBUG_RAMDISK_DR
-			printk("page: %u in same page table\n",
-				req->rd_page);
-#endif
-			continue;
-		}
-#ifdef DEBUG_RAMDISK_DR
-		printk(KERN_INFO "getting new page table for page: %u\n",
-				req->rd_page);
-#endif
-		table = rd_get_sg_table(dev, req->rd_page);
-		if (!(table))
-			return -EINVAL;
-
-		sg_s = &table->sg_table[j = 0];
-	}
-
-out:
-	task->task_se_cmd->t_tasks_se_num += *se_mem_cnt;
-#ifdef DEBUG_RAMDISK_DR
-	printk(KERN_INFO "RD_DR - Allocated %u struct se_mem segments for task\n",
-			*se_mem_cnt);
-#endif
-	return 0;
-}
-
-/*	rd_DIRECT_do_se_mem_map():
- *
- *
- */
-static int rd_DIRECT_do_se_mem_map(
-	struct se_task *task,
-	struct list_head *se_mem_list,
-	void *in_mem,
-	struct se_mem *in_se_mem,
-	struct se_mem **out_se_mem,
-	u32 *se_mem_cnt,
-	u32 *task_offset_in)
-{
-	struct se_cmd *cmd = task->task_se_cmd;
-	struct rd_request *req = RD_REQ(task);
-	u32 task_offset = *task_offset_in;
-	unsigned long long lba;
-	int ret;
-	int block_size = task->se_dev->se_sub_dev->se_dev_attrib.block_size;
-
-	lba = task->task_lba;
-	req->rd_page = ((task->task_lba * block_size) /	PAGE_SIZE);
-	req->rd_offset = (do_div(lba, (PAGE_SIZE / block_size))) * block_size;
-	req->rd_size = task->task_size;
-
-	if (req->rd_offset)
-		ret = rd_DIRECT_with_offset(task, se_mem_list, se_mem_cnt,
-				task_offset_in);
-	else
-		ret = rd_DIRECT_without_offset(task, se_mem_list, se_mem_cnt,
-				task_offset_in);
-
-	if (ret < 0)
-		return ret;
-
-	if (cmd->se_tfo->task_sg_chaining == 0)
-		return 0;
-	/*
-	 * Currently prevent writers from multiple HW fabrics doing
-	 * pci_map_sg() to RD_DR's internal scatterlist memory.
-	 */
-	if (cmd->data_direction == DMA_TO_DEVICE) {
-		printk(KERN_ERR "DMA_TO_DEVICE not supported for"
-				" RAMDISK_DR with task_sg_chaining=1\n");
-		return -ENOSYS;
-	}
-	/*
-	 * Special case for if task_sg_chaining is enabled, then
-	 * we setup struct se_task->task_sg[], as it will be used by
-	 * transport_do_task_sg_chain() for creating chainged SGLs
-	 * across multiple struct se_task->task_sg[].
-	 */
-	ret = transport_init_task_sg(task,
-			list_first_entry(&cmd->t_mem_list,
-				   struct se_mem, se_list),
-			task_offset);
-	if (ret <= 0)
-		return ret;
-
-	return transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
-			list_first_entry(&cmd->t_mem_list,
-				   struct se_mem, se_list),
-			out_se_mem, se_mem_cnt, task_offset_in);
-}
-
-/*	rd_DIRECT_do_task(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static int rd_DIRECT_do_task(struct se_task *task)
-{
-	/*
-	 * At this point the locally allocated RD tables have been mapped
-	 * to struct se_mem elements in rd_DIRECT_do_se_mem_map().
-	 */
-	task->task_scsi_status = GOOD;
-	transport_complete_task(task, 1);
-
-	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
-}
-
 /*	rd_free_task(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1022,27 +740,6 @@ static sector_t rd_get_blocks(struct se_device *dev)
 	return blocks_long;
 }
 
-static struct se_subsystem_api rd_dr_template = {
-	.name			= "rd_dr",
-	.transport_type		= TRANSPORT_PLUGIN_VHBA_VDEV,
-	.attach_hba		= rd_attach_hba,
-	.detach_hba		= rd_detach_hba,
-	.allocate_virtdevice	= rd_DIRECT_allocate_virtdevice,
-	.create_virtdevice	= rd_DIRECT_create_virtdevice,
-	.free_device		= rd_free_device,
-	.alloc_task		= rd_alloc_task,
-	.do_task		= rd_DIRECT_do_task,
-	.free_task		= rd_free_task,
-	.check_configfs_dev_params = rd_check_configfs_dev_params,
-	.set_configfs_dev_params = rd_set_configfs_dev_params,
-	.show_configfs_dev_params = rd_show_configfs_dev_params,
-	.get_cdb		= rd_get_cdb,
-	.get_device_rev		= rd_get_device_rev,
-	.get_device_type	= rd_get_device_type,
-	.get_blocks		= rd_get_blocks,
-	.do_se_mem_map		= rd_DIRECT_do_se_mem_map,
-};
-
 static struct se_subsystem_api rd_mcp_template = {
 	.name			= "rd_mcp",
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_VDEV,
@@ -1067,13 +764,8 @@ int __init rd_module_init(void)
 {
 	int ret;
 
-	ret = transport_subsystem_register(&rd_dr_template);
-	if (ret < 0)
-		return ret;
-
 	ret = transport_subsystem_register(&rd_mcp_template);
 	if (ret < 0) {
-		transport_subsystem_release(&rd_dr_template);
 		return ret;
 	}
 
@@ -1082,6 +774,5 @@ int __init rd_module_init(void)
 
 void rd_module_exit(void)
 {
-	transport_subsystem_release(&rd_dr_template);
 	transport_subsystem_release(&rd_mcp_template);
 }
-- 
1.7.6

