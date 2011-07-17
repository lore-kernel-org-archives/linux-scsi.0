From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 06/20] target: Eliminate usage of struct se_mem
Date: Sun, 17 Jul 2011 12:57:28 -0700
Message-ID: <1310932648.26130.32.camel@haakon2.linux-iscsi.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
	 <1310174329-22228-7-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49639 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab1GQUGk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jul 2011 16:06:40 -0400
In-Reply-To: <1310174329-22228-7-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2011-07-08 at 18:18 -0700, Andy Grover wrote:
> Both backstores and fabrics use arrays of struct scatterlist to describe
> data buffers. However TCM used struct se_mems, basically a linked list
> of scatterlist entries. We are able to simplify the code by eliminating
> this intermediate data structure and just using struct scatterlist[]
> throughout.
> 
> Also, moved attachment of task to cmd out of transport_generic_get_task
> and into allocate_control_task and allocate_data_tasks. The reasoning
> is that it's nonintuitive that get_task should automatically add it to
> the cmd's task list -- it should just return an allocated, initialized
> task. That's all it should do, based on the function's name, so either the
> function shouldn't do it, or the name should change to encapsulate the
> entire essence of what it does.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target.c         |    6 +-
>  drivers/target/loopback/tcm_loop.c          |    5 +-
>  drivers/target/target_core_iblock.c         |    2 +-
>  drivers/target/target_core_pscsi.c          |    2 +-
>  drivers/target/target_core_transport.c      |  987 +++++++--------------------
>  drivers/target/tcm_fc/tfc_cmd.c             |   22 +-
>  drivers/target/tcm_fc/tfc_io.c              |   46 +-
>  drivers/target/tcm_vhost/tcm_vhost_fabric.c |    6 +-
>  drivers/target/tcm_vhost/tcm_vhost_scsi.c   |    7 +-
>  include/target/target_core_base.h           |   10 +-
>  10 files changed, 301 insertions(+), 792 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 425caef..fd83beb 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -762,8 +762,8 @@ static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
>  
>  static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
>  {
> -	u32 iov_count = (cmd->se_cmd.t_tasks_se_num == 0) ? 1 :
> -				cmd->se_cmd.t_tasks_se_num;
> +	u32 iov_count = (cmd->se_cmd.t_data_nents == 0) ? 1 :
> +				cmd->se_cmd.t_data_nents;
>  
>  	iov_count += TRANSPORT_IOV_DATA_BUFFER;
>  
> @@ -815,7 +815,7 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
>  
>  	/* BIDI ops not supported */
>  
> -	/* make se_mem list from the memory */
> +	/* Tell the core about our preallocated memory */
>  	transport_generic_map_mem_to_cmd(&cmd->se_cmd, sgl, nents, NULL, 0);
>  	/*
>  	 * Allocate iovecs for SCSI payload after transport_generic_map_mem_to_cmd

Although this patch did not directly remove the memsets for newly
allocated pages used with transport_generic_map_mem_to_cmd(), the issue
as below of reproducable strangeness with control CDB payloads without
the explict memset of allocated pages.  As much as I would have liked to
leave the memset out, I don't think it's safe to do.  Added the
following:

commit 7c7649750eb47035ac4fb0123f2e49c1c47c8a15
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sun Jul 17 00:20:07 2011 -0700

    target/iscsi: Make iscsit_alloc_buffs explict memset allocated pages
    
    This patch makes iscsit_alloc_buffs() explictly memset allocated pages in
    order to address some control CDB payload strangeness with iscsi-target
    during recent testing.  Be paranoid here and always zero the complete
    payload just to be sure.
    
    This patch also fixes the failure path to properly release and clear
    cmd->t_mem_sg.
    
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 1645aab..2f89001 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -780,6 +780,7 @@ static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
 static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
 {
        struct scatterlist *sgl;
+       unsigned char *buf;
        u32 length = cmd->se_cmd.data_length;
        int nents = DIV_ROUND_UP(length, PAGE_SIZE);
        int i = 0, ret;
@@ -804,6 +805,14 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
                if (!page)
                        goto page_alloc_failed;
 
+               buf = kmap_atomic(page, KM_IRQ0);
+               if (!buf) {
+                       pr_err("kmap_atomic failed\n");
+                       goto page_alloc_failed;
+               }
+               memset(buf, 0, buf_size);
+               kunmap_atomic(buf, KM_IRQ0);
+
                sg_set_page(&sgl[i], page, buf_size, 0);
 
                length -= buf_size;
@@ -832,6 +841,8 @@ page_alloc_failed:
                __free_page(sg_page(&sgl[i]));
                i--;
        }
+       kfree(cmd->t_mem_sg);
+       cmd->t_mem_sg = NULL;
        return -ENOMEM;
 }
 


>  static int
>  transport_generic_get_mem(struct se_cmd *cmd)
>  {
> -	struct se_mem *se_mem;
> -	int length = cmd->data_length;
> +	u32 length = cmd->data_length;
> +	unsigned int nents;
> +	struct page *page;
> +	int i = 0;
>  
>  	/*
>  	 * If the device uses memory mapping this is enough.
> @@ -4172,161 +4100,25 @@ transport_generic_get_mem(struct se_cmd *cmd)
>  	if (cmd->se_dev->transport->do_se_mem_map)
>  		return 0;
>  
> -	/* Even cmds with length 0 will get here, btw */
> -	while (length) {
> -		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
> -		if (!(se_mem)) {
> -			printk(KERN_ERR "Unable to allocate struct se_mem\n");
> -			goto out;
> -		}
> -
> -/* #warning FIXME Allocate contiguous pages for struct se_mem elements */
> -		se_mem->se_page = alloc_pages(GFP_KERNEL, 0);
> -		if (!(se_mem->se_page)) {
> -			printk(KERN_ERR "alloc_pages() failed\n");
> -			goto out;
> -		}
> +	nents = DIV_ROUND_UP(length, PAGE_SIZE);
> +	cmd->t_data_sg = kmalloc(sizeof(struct scatterlist) * nents, GFP_KERNEL);
> +	if (!cmd->t_data_sg)
> +		return -ENOMEM;
>  
> -		INIT_LIST_HEAD(&se_mem->se_list);
> -		se_mem->se_len = min_t(u32, length, PAGE_SIZE);
> -		list_add_tail(&se_mem->se_list, &cmd->t_mem_list);
> -		cmd->t_tasks_se_num++;
> +	cmd->t_data_nents = nents;
> +	sg_init_table(cmd->t_data_sg, nents);
>  
> -		DEBUG_MEM("Allocated struct se_mem page(%p) Length(%u)"
> -			" Offset(%u)\n", se_mem->se_page, se_mem->se_len,
> -			se_mem->se_off);
> +	while (length) {
> +		u32 page_len = min_t(u32, length, PAGE_SIZE);
> +		page = alloc_page(GFP_KERNEL);
> +		if (!page)
> +			return -ENOMEM;
>  
> -		length -= se_mem->se_len;
> +		sg_set_page(&cmd->t_data_sg[i], page, page_len, 0);
> +		length -= page_len;
> +		i++;
>  	}
> -
> -	DEBUG_MEM("Allocated total struct se_mem elements(%u)\n",
> -			cmd->t_tasks_se_num);
> -
>  	return 0;
> -out:
> -	if (se_mem)
> -		__free_pages(se_mem->se_page, 0);
> -	kmem_cache_free(se_mem_cache, se_mem);
> -	return -ENOMEM;
> -}
> -

Ditto here.  Not clearing the newly allocated pages payload here and has
been resulting in some strange issues with unexpected payloads for
control CDB emulation with iscsit_alloc_buffs().  Readding the explict
memset here, and re-added the missing 'out' label handling with the
following:

commit 0660e91ef4bc5a4c414ac8a2989e779d91ce6520
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sun Jul 17 00:15:15 2011 -0700

    target: Make transport_generic_get_mem() explictly memset allocated pages
    
    This patch makes transport_generic_get_mem() explictly memset allocated pages in
    order to address some control CDB payload strangeness during recent testing.
    Be paranoid here and always zero the complete payload just to be sure.
    
    This reverts part of the following commit that removed the memset of
    data payloads:
    
    commit 46c20ab9d7c94fd6cf35d41eab7b480127fb0ccf
    Author: Andy Grover <agrover@redhat.com>
    Date:   Tue May 3 14:48:10 2011 -0700
    
        target: Don't pass dma_size to generic_get_mem. Don't memset.
    
    This also fixes the failure path that was also dropped in commit:
    
    commit 84b6dd77a6035dff105f628589b8aac8a227031e
    Author: Andy Grover <agrover@redhat.com>
    Date:   Fri Jul 8 15:22:14 2011 -0700
    
        target: Eliminate usage of struct se_mem
    
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c279f23..ecd2c42 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3957,6 +3957,7 @@ transport_generic_get_mem(struct se_cmd *cmd)
        u32 length = cmd->data_length;
        unsigned int nents;
        struct page *page;
+       unsigned char *buf;
        int i = 0;
 
        nents = DIV_ROUND_UP(length, PAGE_SIZE);
@@ -3971,13 +3972,30 @@ transport_generic_get_mem(struct se_cmd *cmd)
                u32 page_len = min_t(u32, length, PAGE_SIZE);
                page = alloc_page(GFP_KERNEL);
                if (!page)
-                       return -ENOMEM;
+                       goto out;
+
+               buf = kmap_atomic(page, KM_IRQ0);
+               if (!buf) {
+                       pr_err("kmap_atomic failed\n");
+                       goto out;
+               }
+               memset(buf, 0, page_len);
+               kunmap_atomic(buf, KM_IRQ0);
 
                sg_set_page(&cmd->t_data_sg[i], page, page_len, 0);
                length -= page_len;
                i++;
        }
        return 0;
+
+out:
+       while (i >= 0) {
+               __free_page(sg_page(&cmd->t_data_sg[i]));
+               i--;
+       }
+       kfree(cmd->t_data_sg);
+       cmd->t_data_sg = NULL;
+       return -ENOMEM;
 }

>  /*
>   * Break up cmd into chunks transport can handle
>   */
> -static u32 transport_allocate_tasks(
> +static int transport_allocate_data_tasks(
>  	struct se_cmd *cmd,
>  	unsigned long long lba,
> -	u32 sectors,
>  	enum dma_data_direction data_direction,
> -	struct list_head *mem_list,
> -	int set_counts)
> +	struct scatterlist *sgl,
> +	unsigned int sgl_nents)
>  {
>  	unsigned char *cdb = NULL;
>  	struct se_task *task;
> -	struct se_mem *se_mem = NULL;
> -	struct se_mem *se_mem_lout = NULL;
> -	struct se_mem *se_mem_bidi = NULL;
> -	struct se_mem *se_mem_bidi_lout = NULL;
>  	struct se_device *dev = cmd->se_dev;
> -	int ret;
> -	u32 task_offset_in = 0;
> -	u32 se_mem_cnt = 0;
> -	u32 se_mem_bidi_cnt = 0;
> -	u32 task_cdbs = 0;
> -
> -	BUG_ON(!mem_list);
> -	/*
> -	 * While using RAMDISK_DR backstores is the only case where
> -	 * mem_list will ever be empty at this point.
> -	 */
> -	if (!(list_empty(mem_list)))
> -		se_mem = list_first_entry(mem_list, struct se_mem, se_list);
> -	/*
> -	 * Check for extra se_mem_bidi mapping for BIDI-COMMANDs to
> -	 * struct se_task->task_sg_bidi for TCM/pSCSI passthrough operation
> -	 */
> -	if (!list_empty(&cmd->t_mem_bidi_list) &&
> -	    (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV))
> -		se_mem_bidi = list_first_entry(&cmd->t_mem_bidi_list,
> -					struct se_mem, se_list);
> +	unsigned long flags;
> +	sector_t sectors;
> +	int task_count;
> +	int i;
> +	sector_t dev_max_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
> +	u32 sector_size = dev->se_sub_dev->se_dev_attrib.block_size;
> +	struct scatterlist *sg;
> +	struct scatterlist *cmd_sg;
>  
> -	while (sectors) {
> -		sector_t limited_sectors;
> +	WARN_ON(cmd->data_length % sector_size);
> +	sectors = DIV_ROUND_UP(cmd->data_length, sector_size);
> +	task_count = DIV_ROUND_UP(sectors, dev_max_sectors);
>  
> -		DEBUG_VOL("ITT[0x%08x] LBA(%llu) SectorsLeft(%u) EOBJ(%llu)\n",
> -			cmd->se_tfo->get_task_tag(cmd), lba, sectors,
> -			transport_dev_end_lba(dev));
> -
> -		limited_sectors = transport_limit_task_sectors(dev, lba, sectors);
> -		if (!limited_sectors)
> -			break;
> +	cmd_sg = sgl;
> +	for (i = 0; i < task_count; i++) {
> +		unsigned int task_size;
> +		int count;
>  
>  		task = transport_generic_get_task(cmd, data_direction);
>  		if (!task)
> -			goto out;
> +			return -ENOMEM;
>  
>  		task->task_lba = lba;
> -		task->task_sectors = limited_sectors;
> -		lba += task->task_sectors;
> -		sectors -= task->task_sectors;
> -		task->task_size = (task->task_sectors *
> -				   dev->se_sub_dev->se_dev_attrib.block_size);
> +		task->task_sectors = min(sectors, dev_max_sectors);
> +		task->task_size = task->task_sectors * sector_size;
>  
>  		cdb = dev->transport->get_cdb(task);
> -		/* Should be part of task, can't fail */
>  		BUG_ON(!cdb);
>  
>  		memcpy(cdb, cmd->t_task_cdb,
> @@ -4737,94 +4249,89 @@ static u32 transport_allocate_tasks(
>  		cmd->transport_split_cdb(task->task_lba, task->task_sectors, cdb);
>  
>  		/*
> -		 * Perform the SE OBJ plugin and/or Transport plugin specific
> -		 * mapping for cmd->t_mem_list. And setup the
> -		 * task->task_sg and if necessary task->task_sg_bidi
> +		 * Check if the fabric module driver is requesting that all
> +		 * struct se_task->task_sg[] be chained together..  If so,
> +		 * then allocate an extra padding SG entry for linking and
> +		 * marking the end of the chained SGL.
> +		 * Possibly over-allocate task sgl size by using cmd sgl size.
> +		 * It's so much easier and only a waste when task_count > 1.
> +		 * That is extremely rare.
>  		 */
> -		ret = transport_do_se_mem_map(dev, task, mem_list,
> -				NULL, se_mem, &se_mem_lout, &se_mem_cnt,
> -				&task_offset_in);
> -		if (ret < 0)
> -			goto out;
> +		task->task_sg_num = sgl_nents;
> +		if (cmd->se_tfo->task_sg_chaining) {
> +			task->task_sg_num++;
> +			task->task_padded_sg = 1;
> +		}
>  
> -		se_mem = se_mem_lout;
> -		/*
> -		 * Setup the cmd->t_mem_bidi_list -> task->task_sg_bidi
> -		 * mapping for SCSI READ for BIDI-COMMAND passthrough with TCM/pSCSI
> -		 *
> -		 * Note that the first call to transport_do_se_mem_map() above will
> -		 * allocate struct se_task->task_sg_bidi in transport_do_se_mem_map()
> -		 * -> transport_init_task_sg(), and the second here will do the
> -		 * mapping for SCSI READ for BIDI-COMMAND passthrough with TCM/pSCSI.
> -		 */
> -		if (task->task_sg_bidi != NULL) {
> -			ret = transport_do_se_mem_map(dev, task,
> -				&cmd->t_mem_bidi_list, NULL,
> -				se_mem_bidi, &se_mem_bidi_lout, &se_mem_bidi_cnt,
> -				&task_offset_in);
> -			if (ret < 0)
> -				goto out;
> +		task->task_sg = kmalloc(sizeof(struct scatterlist) * \
> +					task->task_sg_num, GFP_KERNEL);
> +		if (!task->task_sg) {
> +			cmd->se_dev->transport->free_task(task);
> +			return -ENOMEM;
> +		}
>  
> -			se_mem_bidi = se_mem_bidi_lout;
> +		sg_init_table(task->task_sg, task->task_sg_num);
> +
> +		task_size = task->task_size;
> +
> +		/* Build new sgl, only up to task_size */
> +		for_each_sg(task->task_sg, sg, task->task_sg_num, count) {
> +			if (cmd_sg->length > task_size)
> +				break;
> +
> +			*sg = *cmd_sg;
> +			task_size -= cmd_sg->length;
> +			cmd_sg = sg_next(cmd_sg);
>  		}
> -		task_cdbs++;
>  
> -		DEBUG_VOL("Incremented task_cdbs(%u) task->task_sg_num(%u)\n",
> -				task_cdbs, task->task_sg_num);
> -	}
> +		lba += task->task_sectors;
> +		sectors -= task->task_sectors;
>  
> -	if (set_counts) {
> -		atomic_inc(&cmd->t_fe_count);
> -		atomic_inc(&cmd->t_se_count);
> +		spin_lock_irqsave(&cmd->t_state_lock, flags);
> +		list_add_tail(&task->t_list, &cmd->t_task_list);
> +		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
>  	}
>  
> -	DEBUG_VOL("ITT[0x%08x] total %s cdbs(%u)\n",
> -		cmd->se_tfo->get_task_tag(cmd), (data_direction == DMA_TO_DEVICE)
> -		? "DMA_TO_DEVICE" : "DMA_FROM_DEVICE", task_cdbs);
> -
> -	return task_cdbs;
> -out:
> -	return 0;
> +	return task_count;
>  }
>  
>  static int
> -transport_map_control_cmd_to_task(struct se_cmd *cmd)
> +transport_allocate_control_task(struct se_cmd *cmd)
>  {
>  	struct se_device *dev = cmd->se_dev;
>  	unsigned char *cdb;
>  	struct se_task *task;
> -	int ret;
> +	unsigned long flags;
>  
>  	task = transport_generic_get_task(cmd, cmd->data_direction);
>  	if (!task)
> -		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> +		return -ENOMEM;
>  
>  	cdb = dev->transport->get_cdb(task);
>  	BUG_ON(!cdb);
>  	memcpy(cdb, cmd->t_task_cdb,
>  	       scsi_command_size(cmd->t_task_cdb));
>  
> +	task->task_sg = kmalloc(sizeof(struct scatterlist) * cmd->t_data_nents,
> +				GFP_KERNEL);
> +	if (!task->task_sg) {
> +		cmd->se_dev->transport->free_task(task);
> +		return -ENOMEM;
> +	}
> +
> +	memcpy(task->task_sg, cmd->t_data_sg,
> +	       sizeof(struct scatterlist) * cmd->t_data_nents);
>  	task->task_size = cmd->data_length;
> -	task->task_sg_num =
> -		(cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) ? 1 : 0;
> +	task->task_sg_num = cmd->t_data_nents;
>  
>  	atomic_inc(&cmd->t_fe_count);
>  	atomic_inc(&cmd->t_se_count);
>  

The extra atomic_inc for cmd->t_fe_count and cmd->t_se_count here is
bogus, and was causing all control CDBs to be leaked..  Committed the
following bugfix:

commit 53dcfc1555875d3c2000c3df71ea74e91f57cb6c
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sat Jul 16 23:38:58 2011 -0700

    target: Fix control se_cmd descriptor memory leak
    
    This patch removes a bogus duplicate increment of cmd->t_fe_count and
    cmd->t_se_count in the new transport_allocate_control_task() logic.
    
    As these two values are incremented once for all CDB types in
    transport_new_cmd_obj(), the duplicate increment was causing all
    control se_cmd descriptors to be leaked in transport_generic_remove()
    when transport_dec_and_check() was returning non zero.
    
    This bug was introduced with commit:
    
    commit 84b6dd77a6035dff105f628589b8aac8a227031e
    Author: Andy Grover <agrover@redhat.com>
    Date:   Fri Jul 8 15:22:14 2011 -0700
    
        target: Eliminate usage of struct se_mem
    
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b3c010c..c279f23 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4197,9 +4197,6 @@ transport_allocate_control_task(struct se_cmd *cmd)
        task->task_size = cmd->data_length;
        task->task_sg_nents = cmd->t_data_nents;
 
-       atomic_inc(&cmd->t_fe_count);
-       atomic_inc(&cmd->t_se_count);
-
        spin_lock_irqsave(&cmd->t_state_lock, flags);
        list_add_tail(&task->t_list, &cmd->t_task_list);
        spin_unlock_irqrestore(&cmd->t_state_lock, flags);



> -	if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) {
> -		struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
> -		u32 se_mem_cnt = 0, task_offset = 0;
> -
> -		if (!list_empty(&cmd->t_mem_list))
> -			se_mem = list_first_entry(&cmd->t_mem_list,
> -					struct se_mem, se_list);
> -
> -		ret = transport_do_se_mem_map(dev, task,
> -				&cmd->t_mem_list, NULL, se_mem,
> -				&se_mem_lout, &se_mem_cnt, &task_offset);
> -		if (ret < 0)
> -			return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> +	spin_lock_irqsave(&cmd->t_state_lock, flags);
> +	list_add_tail(&task->t_list, &cmd->t_task_list);
> +	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
>  
> +	if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) {
>  		if (dev->transport->map_task_SG)
>  			return dev->transport->map_task_SG(task);
>  		return 0;
> @@ -4834,10 +4341,32 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd)
>  		return 0;
>  	} else {
>  		BUG();
> -		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> +		return -ENOMEM;
>  	}
>  }
>  
> +static u32 transport_allocate_tasks(
> +	struct se_cmd *cmd,
> +	unsigned long long lba,
> +	enum dma_data_direction data_direction,
> +	struct scatterlist *sgl,
> +	unsigned int sgl_nents)
> +{
> +	int ret;
> +
> +	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
> +		return transport_allocate_data_tasks(cmd, lba, data_direction,
> +						     sgl, sgl_nents);
> +	} else {
> +		ret = transport_allocate_control_task(cmd);
> +		if (ret < 0)
> +			return ret;
> +		else
> +			return 1;
> +	}
> +}
> +
> +
>  /*	 transport_generic_new_cmd(): Called from transport_processing_thread()
>   *
>   *	 Allocate storage transport resources from a set of values predefined
> @@ -4856,10 +4385,10 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
>  	/*
>  	 * Determine is the TCM fabric module has already allocated physical
>  	 * memory, and is directly calling transport_generic_map_mem_to_cmd()
> -	 * to setup beforehand the linked list of physical memory at
> -	 * cmd->t_mem_list of struct se_mem->se_page
> +	 * beforehand.
>  	 */
> -	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
> +	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) &&
> +	    cmd->data_length) {
>  		ret = transport_generic_get_mem(cmd);
>  		if (ret < 0)
>  			return ret;
> @@ -4869,19 +4398,13 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
>  	if (ret < 0)
>  		return ret;
>  
> -	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
> -		list_for_each_entry(task, &cmd->t_task_list, t_list) {
> -			if (atomic_read(&task->task_sent))
> -				continue;
> -			if (!dev->transport->map_task_SG)
> -				continue;
> +	list_for_each_entry(task, &cmd->t_task_list, t_list) {
> +		if (atomic_read(&task->task_sent))
> +			continue;
> +		if (!dev->transport->map_task_SG)
> +			continue;
>  
> -			ret = dev->transport->map_task_SG(task);
> -			if (ret < 0)
> -				return ret;
> -		}
> -	} else {
> -		ret = transport_map_control_cmd_to_task(cmd);
> +		ret = dev->transport->map_task_SG(task);
>  		if (ret < 0)
>  			return ret;

Calling dev->transport->map_task_SG() here for all cases is incorrect,
and was triggering an OOPs during iscsi-target initial LUN scan..  Fixed
with the following:

commit 93529985c9de3cd5ab40cb322da24a4d8372ad4c
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sat Jul 16 19:27:07 2011 -0700

    target: Fix incorrect usage of ->map_task_SG in transport_generic_new_cmd
    
    This patch fixes incorrect usage of ->map_task_SG() for all se_cmd descriptors
    in transport_generic_new_cmd().  This introduced with commit:
    
    commit 84b6dd77a6035dff105f628589b8aac8a227031e
    Author: Andy Grover <agrover@redhat.com>
    Date:   Fri Jul 8 15:22:14 2011 -0700
    
        target: Eliminate usage of struct se_mem
    
    and this patch moves the call into it's proper location directly inside of
    transport_allocate_data_tasks().
    
    It also fixes a minor return code issue in transport_new_cmd_obj(), and
    removes a typo in transport_allocate_data_tasks().
    
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 32e5614..372de32 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3892,7 +3892,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
                                              DMA_FROM_DEVICE,
                                              cmd->t_bidi_data_sg,
                                              cmd->t_bidi_data_nents);
-               if (!rc) {
+               if (rc <= 0) {
                        cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
                        cmd->scsi_sense_reason =
                                TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -4068,8 +4068,7 @@ static int transport_allocate_data_tasks(
        struct se_device *dev = cmd->se_dev;
        unsigned long flags;
        sector_t sectors;
-       int task_count;
-       int i;
+       int task_count, i, ret;
        sector_t dev_max_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
        u32 sector_size = dev->se_sub_dev->se_dev_attrib.block_size;
        struct scatterlist *sg;
@@ -4116,7 +4115,7 @@ static int transport_allocate_data_tasks(
                        task->task_padded_sg = 1;
                }
 
-               task->task_sg = kmalloc(sizeof(struct scatterlist) * \
+               task->task_sg = kmalloc(sizeof(struct scatterlist) *
                                        task->task_sg_nents, GFP_KERNEL);
                if (!task->task_sg) {
                        cmd->se_dev->transport->free_task(task);
@@ -4144,6 +4143,20 @@ static int transport_allocate_data_tasks(
                list_add_tail(&task->t_list, &cmd->t_task_list);
                spin_unlock_irqrestore(&cmd->t_state_lock, flags);
        }
+       /*
+        * Now perform the memory map of task->task_sg[] into backend
+        * subsystem memory..
+        */
+       list_for_each_entry(task, &cmd->t_task_list, t_list) {
+               if (atomic_read(&task->task_sent))
+                       continue;
+               if (!dev->transport->map_task_SG)
+                       continue;
+
+               ret = dev->transport->map_task_SG(task);
+               if (ret < 0)
+                       return 0;
+       }
 
        return task_count;
 }
@@ -4229,8 +4242,6 @@ static u32 transport_allocate_tasks(
         */
 int transport_generic_new_cmd(struct se_cmd *cmd)
 {
-       struct se_task *task;
-       struct se_device *dev = cmd->se_dev;
        int ret = 0;
 
        /*
@@ -4244,22 +4255,13 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
                if (ret < 0)
                        return ret;
        }
-
+       /*
+        * Call transport_new_cmd_obj() to invoke transport_allocate_tasks()
+        * and perform the memory map to backend subsystem devices.
+        */
        ret = transport_new_cmd_obj(cmd);
        if (ret < 0)
                return ret;
-
-       list_for_each_entry(task, &cmd->t_task_list, t_list) {
-               if (atomic_read(&task->task_sent))
-                       continue;
-               if (!dev->transport->map_task_SG)
-                       continue;
-
-               ret = dev->transport->map_task_SG(task);
-               if (ret < 0)
-                       return ret;
-       }
-
        /*
         * For WRITEs, let the fabric know its buffer is ready..
         * This WRITE struct se_cmd (and all of its associated struct se_task's)

---

Note that another patch was required for IBLOCK in order to prevent non
SCF_SCSI_DATA_SG_IO_CDB from being processed as bios in
iblock_map_task_SG().  pSCSI is the only case where we actually want
this to happen..


commit 338cdba84c710377aa94e60f33610cb293dd2e62
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sat Jul 16 22:48:16 2011 -0700

    target/iblock: Make iblock_map_task_SG only for SCF_SCSI_DATA_SG_IO_CDB
    
    This patch changes iblock_map_task_SG() to only allocate bios for
    SCF_SCSI_DATA_SG_IO_CDB type payloads.  This fixes a bug where
    control type CDBs where incorrectly having bios allocated that was
    introduced with commit:
    
    commit 84b6dd77a6035dff105f628589b8aac8a227031e
    Author: Andy Grover <agrover@redhat.com>
    Date:   Fri Jul 8 15:22:14 2011 -0700
    
        target: Eliminate usage of struct se_mem
    
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 251fc66..957c208 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -603,6 +603,11 @@ static int iblock_map_task_SG(struct se_task *task)
        u32 i, sg_num = task->task_sg_nents;
        sector_t block_lba;
        /*
+        * Only setup bios for SCF_SCSI_DATA_SG_IO_CDB type payloads
+        */
+       if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
+               return 0;
+       /*
         * Do starting conversion up from non 512-byte blocksize with
         * struct se_task SCSI blocksize into Linux/Block 512 units for BIO.
         */


