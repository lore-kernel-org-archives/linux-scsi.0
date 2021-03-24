Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD63C433EC
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C8F61A0F
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237886AbhCXT33 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237780AbhCXT3F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 15:29:05 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB9AC061763;
        Wed, 24 Mar 2021 12:29:04 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b16so28992016eds.7;
        Wed, 24 Mar 2021 12:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fAJAQqQM/KSIzB/YNyRtDB7l1vZbiPRNKpjtpnrynTs=;
        b=fIdtbC/PHe/IUGNSlQf4sge3v1jTCD4QPKht58Q3eVfWFarC89ahKsygru9ZTczAbW
         M+2YgRmV7NXyaGCSl8LfddXe2/r7GZbzdocwo1QhUXhGLlO0/l9LjDUN4yNo2O303ahj
         NUJ7BmDaQmPHdidpMWBXU1NV1q4eLI7a/QETqJvZP+j3uk5rP5jJWpNE/YKd+yGxqUs3
         M8Yhrb7AvPqvuwUHUr0w60Wc3sw7TJmrACQP45IvXZ9GmTgCoqyVN4vMd8FW1UIbImeB
         ur42tdfuweArOzjlQn/cJHStmAJ0JLl+dL8E9zV0ogfEVH6nhIbD++YbT5s7O43O6AIv
         d05Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fAJAQqQM/KSIzB/YNyRtDB7l1vZbiPRNKpjtpnrynTs=;
        b=K53nQO+kq1v6qM34Mb3k3tqeZcyneoycJ9sbzqzgT3PbNL9Wab3u4ClgoTUipFP3Vq
         0T3ZMO1PsHuumhfDiT2jEQHhD6/wc6EQxmyjw2+sXaw/B7X2Rj/r+69ZJIEA4fUqk9zF
         Ukt0Y/qDfd8bqMDFtAQwzz1df4vay+czuJpolOH7KrndKXD6Vnafh0j5JwIrg4/qcwHl
         a/LWgMitWyP1I7hJBLI4ku4/V3AVkKNYvKzk4K1vcUWBajr0dqyzX9Dl2a78gJwVETuR
         5M6spCBXxBLKIAWhJs3aQtWjQhRahGYKFi8mYKufsgGt8Brvc9M4RgCG/9L8irMPckl3
         6bdw==
X-Gm-Message-State: AOAM532oXGqVGqRs91ebKsTonsNZ1asxirGDzAGshDCLtpRw5du+Hf6M
        21fNbe2se3S4Flbto43eSu1+fZtnvbg=
X-Google-Smtp-Source: ABdhPJwoziWLAknSO29+chFH4v1NVo/wWQX/IG5yJ7oFMNrpeOmiDZiVqkIIJrt0jL91Iz1MaDPUYw==
X-Received: by 2002:aa7:c447:: with SMTP id n7mr5172409edr.171.1616614143621;
        Wed, 24 Mar 2021 12:29:03 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id si7sm1374644ejb.84.2021.03.24.12.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 12:29:03 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/6] scsi: target: tcmu: Prepare for PAGE_SIZE != DATA_BLOCK_SIZE
Date:   Wed, 24 Mar 2021 20:28:38 +0100
Message-Id: <20210324192842.30446-3-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210324192842.30446-1-bostroesser@gmail.com>
References: <20210324192842.30446-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

This patch renames some variables and definitions as a first
preparation for DATA_BLOCK_SIZE != PAGE_SIZE and adds the
new DATA_PAGES_PER_BLK definition containing the number of
pages per data block.
I also renamed tcmu_try_get_block_page() to
tcmu_try_get_data_page(), but kept name tcmu_get_block_page(),
since it will go away in a following patch, when there is only
one caller left.
The following patches will then add full support for
DATA_PAGES_PER_BLK != 1, which also means
DATA_BLOCK_SIZE = DATA_PAGES_PER_BLK * PAGE_SIZE

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 82 +++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 35975dd75dde..f42d38873aaf 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -71,17 +71,17 @@
  * the total size is 256K * PAGE_SIZE.
  */
 #define DATA_BLOCK_SIZE PAGE_SIZE
-#define DATA_BLOCK_SHIFT PAGE_SHIFT
+#define DATA_PAGES_PER_BLK 1
 #define DATA_BLOCK_BITS_DEF (256 * 1024)
 
-#define TCMU_MBS_TO_BLOCKS(_mbs) (_mbs << (20 - DATA_BLOCK_SHIFT))
-#define TCMU_BLOCKS_TO_MBS(_blocks) (_blocks >> (20 - DATA_BLOCK_SHIFT))
+#define TCMU_MBS_TO_PAGES(_mbs) (_mbs << (20 - PAGE_SHIFT))
+#define TCMU_PAGES_TO_MBS(_pages) (_pages >> (20 - PAGE_SHIFT))
 
 /*
  * Default number of global data blocks(512K * PAGE_SIZE)
  * when the unmap thread will be started.
  */
-#define TCMU_GLOBAL_MAX_BLOCKS_DEF (512 * 1024)
+#define TCMU_GLOBAL_MAX_PAGES_DEF (512 * 1024)
 
 static u8 tcmu_kern_cmd_reply_supported;
 static u8 tcmu_netlink_blocked;
@@ -149,7 +149,7 @@ struct tcmu_dev {
 	uint32_t dbi_max;
 	uint32_t dbi_thresh;
 	unsigned long *data_bitmap;
-	struct xarray data_blocks;
+	struct xarray data_pages;
 
 	struct xarray commands;
 
@@ -219,9 +219,9 @@ static LIST_HEAD(timed_out_udevs);
 
 static struct kmem_cache *tcmu_cmd_cache;
 
-static atomic_t global_db_count = ATOMIC_INIT(0);
+static atomic_t global_page_count = ATOMIC_INIT(0);
 static struct delayed_work tcmu_unmap_work;
-static int tcmu_global_max_blocks = TCMU_GLOBAL_MAX_BLOCKS_DEF;
+static int tcmu_global_max_pages = TCMU_GLOBAL_MAX_PAGES_DEF;
 
 static int tcmu_set_global_max_data_area(const char *str,
 					 const struct kernel_param *kp)
@@ -237,8 +237,8 @@ static int tcmu_set_global_max_data_area(const char *str,
 		return -EINVAL;
 	}
 
-	tcmu_global_max_blocks = TCMU_MBS_TO_BLOCKS(max_area_mb);
-	if (atomic_read(&global_db_count) > tcmu_global_max_blocks)
+	tcmu_global_max_pages = TCMU_MBS_TO_PAGES(max_area_mb);
+	if (atomic_read(&global_page_count) > tcmu_global_max_pages)
 		schedule_delayed_work(&tcmu_unmap_work, 0);
 	else
 		cancel_delayed_work_sync(&tcmu_unmap_work);
@@ -249,7 +249,7 @@ static int tcmu_set_global_max_data_area(const char *str,
 static int tcmu_get_global_max_data_area(char *buffer,
 					 const struct kernel_param *kp)
 {
-	return sprintf(buffer, "%d\n", TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
+	return sprintf(buffer, "%d\n", TCMU_PAGES_TO_MBS(tcmu_global_max_pages));
 }
 
 static const struct kernel_param_ops tcmu_global_max_data_area_op = {
@@ -510,10 +510,10 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 	if (dbi == udev->dbi_thresh)
 		return -1;
 
-	page = xa_load(&udev->data_blocks, dbi);
+	page = xa_load(&udev->data_pages, dbi);
 	if (!page) {
-		if (atomic_add_return(1, &global_db_count) >
-				      tcmu_global_max_blocks)
+		if (atomic_add_return(1, &global_page_count) >
+				      tcmu_global_max_pages)
 			schedule_delayed_work(&tcmu_unmap_work, 0);
 
 		/* try to get new page from the mm */
@@ -521,7 +521,7 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 		if (!page)
 			goto err_alloc;
 
-		if (xa_store(&udev->data_blocks, dbi, page, GFP_NOIO))
+		if (xa_store(&udev->data_pages, dbi, page, GFP_NOIO))
 			goto err_insert;
 	}
 
@@ -538,7 +538,7 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 err_insert:
 	__free_page(page);
 err_alloc:
-	atomic_dec(&global_db_count);
+	atomic_dec(&global_page_count);
 	return -1;
 }
 
@@ -558,9 +558,9 @@ static int tcmu_get_empty_blocks(struct tcmu_dev *udev,
 }
 
 static inline struct page *
-tcmu_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
+tcmu_get_block_page(struct tcmu_dev *udev, uint32_t dpi)
 {
-	return xa_load(&udev->data_blocks, dbi);
+	return xa_load(&udev->data_pages, dpi);
 }
 
 static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
@@ -1454,7 +1454,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 	if (free_space)
 		free_space = tcmu_run_tmr_queue(udev);
 
-	if (atomic_read(&global_db_count) > tcmu_global_max_blocks &&
+	if (atomic_read(&global_page_count) > tcmu_global_max_pages &&
 	    xa_empty(&udev->commands) && list_empty(&udev->qfull_queue)) {
 		/*
 		 * Allocated blocks exceeded global block limit, currently no
@@ -1583,7 +1583,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	timer_setup(&udev->qfull_timer, tcmu_qfull_timedout, 0);
 	timer_setup(&udev->cmd_timer, tcmu_cmd_timedout, 0);
 
-	xa_init(&udev->data_blocks);
+	xa_init(&udev->data_pages);
 
 	return &udev->se_dev;
 }
@@ -1617,7 +1617,7 @@ static void tcmu_blocks_release(struct xarray *blocks, unsigned long first,
 	xas_for_each(&xas, page, last) {
 		xas_store(&xas, NULL);
 		__free_page(page);
-		atomic_dec(&global_db_count);
+		atomic_dec(&global_page_count);
 	}
 	xas_unlock(&xas);
 }
@@ -1661,7 +1661,7 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	xa_destroy(&udev->commands);
 	WARN_ON(!all_expired);
 
-	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max);
+	tcmu_blocks_release(&udev->data_pages, 0, udev->dbi_max);
 	bitmap_free(udev->data_bitmap);
 	mutex_unlock(&udev->cmdr_lock);
 
@@ -1759,12 +1759,12 @@ static int tcmu_find_mem_index(struct vm_area_struct *vma)
 	return -1;
 }
 
-static struct page *tcmu_try_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
+static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
 {
 	struct page *page;
 
 	mutex_lock(&udev->cmdr_lock);
-	page = tcmu_get_block_page(udev, dbi);
+	page = tcmu_get_block_page(udev, dpi);
 	if (likely(page)) {
 		mutex_unlock(&udev->cmdr_lock);
 		return page;
@@ -1774,12 +1774,11 @@ static struct page *tcmu_try_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 	 * Userspace messed up and passed in a address not in the
 	 * data iov passed to it.
 	 */
-	pr_err("Invalid addr to data block mapping  (dbi %u) on device %s\n",
-	       dbi, udev->name);
-	page = NULL;
+	pr_err("Invalid addr to data page mapping (dpi %u) on device %s\n",
+	       dpi, udev->name);
 	mutex_unlock(&udev->cmdr_lock);
 
-	return page;
+	return NULL;
 }
 
 static void tcmu_vma_open(struct vm_area_struct *vma)
@@ -1824,11 +1823,11 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 		addr = (void *)(unsigned long)info->mem[mi].addr + offset;
 		page = vmalloc_to_page(addr);
 	} else {
-		uint32_t dbi;
+		uint32_t dpi;
 
 		/* For the dynamically growing data area pages */
-		dbi = (offset - udev->data_off) / DATA_BLOCK_SIZE;
-		page = tcmu_try_get_block_page(udev, dbi);
+		dpi = (offset - udev->data_off) / PAGE_SIZE;
+		page = tcmu_try_get_data_page(udev, dpi);
 		if (!page)
 			return VM_FAULT_SIGBUS;
 	}
@@ -2344,7 +2343,7 @@ static int tcmu_set_dev_attrib(substring_t *arg, u32 *dev_attrib)
 
 static int tcmu_set_max_blocks_param(struct tcmu_dev *udev, substring_t *arg)
 {
-	int val, ret;
+	int val, ret, blks;
 
 	ret = match_int(arg, &val);
 	if (ret < 0) {
@@ -2353,7 +2352,8 @@ static int tcmu_set_max_blocks_param(struct tcmu_dev *udev, substring_t *arg)
 		return ret;
 	}
 
-	if (val <= 0) {
+	blks = TCMU_MBS_TO_PAGES(val) / DATA_PAGES_PER_BLK;
+	if (blks <= 0) {
 		pr_err("Invalid max_data_area %d.\n", val);
 		return -EINVAL;
 	}
@@ -2365,11 +2365,11 @@ static int tcmu_set_max_blocks_param(struct tcmu_dev *udev, substring_t *arg)
 		goto unlock;
 	}
 
-	udev->max_blocks = TCMU_MBS_TO_BLOCKS(val);
-	if (udev->max_blocks > tcmu_global_max_blocks) {
+	udev->max_blocks = blks;
+	if (udev->max_blocks * DATA_PAGES_PER_BLK > tcmu_global_max_pages) {
 		pr_err("%d is too large. Adjusting max_data_area_mb to global limit of %u\n",
-		       val, TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
-		udev->max_blocks = tcmu_global_max_blocks;
+		       val, TCMU_PAGES_TO_MBS(tcmu_global_max_pages));
+		udev->max_blocks = tcmu_global_max_pages / DATA_PAGES_PER_BLK;
 	}
 
 unlock:
@@ -2449,7 +2449,7 @@ static ssize_t tcmu_show_configfs_dev_params(struct se_device *dev, char *b)
 		     udev->dev_config[0] ? udev->dev_config : "NULL");
 	bl += sprintf(b + bl, "Size: %llu ", udev->dev_size);
 	bl += sprintf(b + bl, "MaxDataAreaMB: %u\n",
-		      TCMU_BLOCKS_TO_MBS(udev->max_blocks));
+		      TCMU_PAGES_TO_MBS(udev->max_blocks * DATA_PAGES_PER_BLK));
 
 	return bl;
 }
@@ -2544,7 +2544,7 @@ static ssize_t tcmu_max_data_area_mb_show(struct config_item *item, char *page)
 	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
 
 	return snprintf(page, PAGE_SIZE, "%u\n",
-			TCMU_BLOCKS_TO_MBS(udev->max_blocks));
+			TCMU_PAGES_TO_MBS(udev->max_blocks * DATA_PAGES_PER_BLK));
 }
 CONFIGFS_ATTR_RO(tcmu_, max_data_area_mb);
 
@@ -2904,7 +2904,7 @@ static void find_free_blocks(void)
 	loff_t off;
 	u32 start, end, block, total_freed = 0;
 
-	if (atomic_read(&global_db_count) <= tcmu_global_max_blocks)
+	if (atomic_read(&global_page_count) <= tcmu_global_max_pages)
 		return;
 
 	mutex_lock(&root_udev_mutex);
@@ -2949,7 +2949,7 @@ static void find_free_blocks(void)
 		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
 
 		/* Release the block pages */
-		tcmu_blocks_release(&udev->data_blocks, start, end - 1);
+		tcmu_blocks_release(&udev->data_pages, start, end - 1);
 		mutex_unlock(&udev->cmdr_lock);
 
 		total_freed += end - start;
@@ -2958,7 +2958,7 @@ static void find_free_blocks(void)
 	}
 	mutex_unlock(&root_udev_mutex);
 
-	if (atomic_read(&global_db_count) > tcmu_global_max_blocks)
+	if (atomic_read(&global_page_count) > tcmu_global_max_pages)
 		schedule_delayed_work(&tcmu_unmap_work, msecs_to_jiffies(5000));
 }
 
-- 
2.12.3

