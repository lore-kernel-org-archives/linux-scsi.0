Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DACC433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E655861A3A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238103AbhCXT66 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238092AbhCXT6o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 15:58:44 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A58C061763;
        Wed, 24 Mar 2021 12:58:43 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r12so34931126ejr.5;
        Wed, 24 Mar 2021 12:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=014HcUicOvrtCKEp/i5/PR0CyFsTl/NEPtcTqEszbNI=;
        b=iiTky/Y20yZWJmJSAkjYXu201iZGyF8rXRQRKjDjnP443ZYHKncSMBDm1I0Z0Nuylj
         4Wa2dZF5VX5zwL5T+REsPyOSGcUnRrFAS/wDjq7tHvXIo8P9fDxm7otStTHtoP3jABfF
         jZVGS221WvHjWj8hnAQq6JqafAAxRBCVPbfGSsZ5mD59Yu6D8RqWZSVnIzgI1B9C5Qhw
         tBwDNywb4UdH29Galv1RhRHccpaZzRh9ROvPBc19gNTiGsSHpm8eULVfEO2gj9k6PTwR
         PxtI61Wu3r4UuQmbGhKQwo5+SMCxma2IMF7V8B463Gag9e4yf8VwpPIRQzZzQHihJQ3q
         JiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=014HcUicOvrtCKEp/i5/PR0CyFsTl/NEPtcTqEszbNI=;
        b=FiP5WeN8Pb24TkP0VEZPfA9l5rWLarxeuJMLQMLdLL0oFd5LWZELB76gIdqBbU4GhI
         L2tjdakzxMbEmBcocmXdzZ9hXGfg6sm7tBSqwyTRM7WzFs7aeXV+kAefN5Cvga+A7JbG
         DwOmhuJTtJmN+ZlTeHEGy0B1U6e2wx8IOpIO9U/y2LOJU3F8T0FwTdytLKgogS6v2nXy
         pAf+PNNvrONC3MO0i0rK5/36yJmmfeAS38umiB6a/sTvFMXbRLrm+caxsjzBYpwnprDB
         vH3muCBPWUgWm/nGOp9BhRl6cWn+2oJWksiSftdXcUbsm4qhE9ZIRSqH0evtF4TRLNal
         HHrg==
X-Gm-Message-State: AOAM530Kz+wtIXwshRn6hLhWddg7Yw3EJ7mzfRWiKyaVPBb1Iz47xOwc
        RDeFthZKChB6eMAPJPtQPV2x5laG+/0=
X-Google-Smtp-Source: ABdhPJyaup14yPUVUG1q+p/bmn/QQTvWNpSSoq8Q2nZl9bvZF08iC+fhET256LEPh9Oku2/aqlIzQA==
X-Received: by 2002:a17:906:7d7:: with SMTP id m23mr5655568ejc.205.1616615922356;
        Wed, 24 Mar 2021 12:58:42 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id qo25sm1366241ejb.93.2021.03.24.12.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 12:58:42 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 3/6] scsi: target: tcmu: Support DATA_BLOCK_SIZE = N * PAGE_SIZE
Date:   Wed, 24 Mar 2021 20:57:55 +0100
Message-Id: <20210324195758.2021-4-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210324195758.2021-1-bostroesser@gmail.com>
References: <20210324195758.2021-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch changes tcmu to support DATA_BLOCK_SIZE being a
multiple of PAGE_SIZE. There are two reason why one would like
to have a bigger DATA_BLOCK_SIZE:

1) If userspace - e.g. due to data compression, encryption or
   deduplication - needs to have receive or transmit data in a
   consecutive buffer, we can define DATA_BLOCK_SIZE to the max.
   size of a SCSI READ/WRITE to enforce that userspace sees just
   one consecutive buffer. That way we can avoid the need for
   doing data copy in userspace.

2) Using a bigger data block size can speed up command processing
   in tcmu. The number of free data blocks to look up in bitmap
   is reduced by far. The lookup for data pages in radix_tree
   can be done more efficiently if there are multiple pages in
   a data block. The max. number of IOVs to set up is lower,
   so cmd entries in the ring become smaller.

Note: This patch still keeps DATA_BLOCK_SIZE as a preprocessor
definition. So testing this patch with DATA_BLOCK_SIZE > PAGE_SIZE
is possible only by changing the code and building
target_core_user.ko again. (Just change DATA_PAGES_PER_BLK to a
higher value than the default of 1.)
The next patches will replace definitions DATA_PAGES_PER_BLK
and DATA_BLOCK_SIZE with new struct tcmu_dev members data_blk_size
and data_pages_per_blk, and finally will make data_pages_per_blk
changeable via configFS.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 215 +++++++++++++++++++++-----------------
 1 file changed, 121 insertions(+), 94 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index f42d38873aaf..3596346f362e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -67,14 +67,14 @@
 #define CMDR_SIZE (MB_CMDR_SIZE - CMDR_OFF)
 
 /*
- * For data area, the block size is PAGE_SIZE and
- * the total size is 256K * PAGE_SIZE.
+ * For data area, the default block size is PAGE_SIZE and
+ * the default total size is 256K * PAGE_SIZE.
  */
-#define DATA_BLOCK_SIZE PAGE_SIZE
 #define DATA_PAGES_PER_BLK 1
-#define DATA_BLOCK_BITS_DEF (256 * 1024)
+#define DATA_BLOCK_SIZE (DATA_PAGES_PER_BLK * PAGE_SIZE)
+#define DATA_AREA_PAGES_DEF (256 * 1024)
 
-#define TCMU_MBS_TO_PAGES(_mbs) (_mbs << (20 - PAGE_SHIFT))
+#define TCMU_MBS_TO_PAGES(_mbs) ((size_t)_mbs << (20 - PAGE_SHIFT))
 #define TCMU_PAGES_TO_MBS(_pages) (_pages >> (20 - PAGE_SHIFT))
 
 /*
@@ -138,7 +138,7 @@ struct tcmu_dev {
 	/* Offset of data area from start of mb */
 	/* Must add data_off and mb_addr to get the address */
 	size_t data_off;
-	size_t data_size;
+	int data_area_mb;
 	uint32_t max_blocks;
 	size_t mmap_pages;
 
@@ -501,31 +501,39 @@ static void tcmu_cmd_free_data(struct tcmu_cmd *tcmu_cmd, uint32_t len)
 
 static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 				       struct tcmu_cmd *tcmu_cmd,
-				       int prev_dbi, int *iov_cnt)
+				       int prev_dbi, int length, int *iov_cnt)
 {
+	XA_STATE(xas, &udev->data_pages, 0);
 	struct page *page;
-	int dbi;
+	int i, cnt, dbi;
+	int page_cnt = DIV_ROUND_UP(length, PAGE_SIZE);
 
 	dbi = find_first_zero_bit(udev->data_bitmap, udev->dbi_thresh);
 	if (dbi == udev->dbi_thresh)
 		return -1;
 
-	page = xa_load(&udev->data_pages, dbi);
-	if (!page) {
-		if (atomic_add_return(1, &global_page_count) >
-				      tcmu_global_max_pages)
-			schedule_delayed_work(&tcmu_unmap_work, 0);
+	/* Count the number of already allocated pages */
+	xas_set(&xas, dbi * DATA_PAGES_PER_BLK);
+	for (cnt = 0; xas_next(&xas) && cnt < page_cnt;)
+		cnt++;
 
+	for (i = cnt; i < page_cnt; i++) {
 		/* try to get new page from the mm */
 		page = alloc_page(GFP_NOIO);
 		if (!page)
-			goto err_alloc;
+			break;
 
-		if (xa_store(&udev->data_pages, dbi, page, GFP_NOIO))
-			goto err_insert;
+		if (xa_store(&udev->data_pages, dbi * DATA_PAGES_PER_BLK + i,
+			     page, GFP_NOIO)) {
+			__free_page(page);
+			break;
+		}
 	}
+	if (atomic_add_return(i - cnt, &global_page_count) >
+			      tcmu_global_max_pages)
+		schedule_delayed_work(&tcmu_unmap_work, 0);
 
-	if (dbi > udev->dbi_max)
+	if (i && dbi > udev->dbi_max)
 		udev->dbi_max = dbi;
 
 	set_bit(dbi, udev->data_bitmap);
@@ -534,23 +542,19 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 	if (dbi != prev_dbi + 1)
 		*iov_cnt += 1;
 
-	return dbi;
-err_insert:
-	__free_page(page);
-err_alloc:
-	atomic_dec(&global_page_count);
-	return -1;
+	return i == page_cnt ? dbi : -1;
 }
 
 static int tcmu_get_empty_blocks(struct tcmu_dev *udev,
-				 struct tcmu_cmd *tcmu_cmd, int dbi_cnt)
+				 struct tcmu_cmd *tcmu_cmd, int length)
 {
 	/* start value of dbi + 1 must not be a valid dbi */
 	int dbi = -2;
-	int i, iov_cnt = 0;
+	int blk_len, iov_cnt = 0;
 
-	for (i = 0; i < dbi_cnt; i++) {
-		dbi = tcmu_get_empty_block(udev, tcmu_cmd, dbi, &iov_cnt);
+	for (; length > 0; length -= DATA_BLOCK_SIZE) {
+		blk_len = min_t(int, length, DATA_BLOCK_SIZE);
+		dbi = tcmu_get_empty_block(udev, tcmu_cmd, dbi, blk_len, &iov_cnt);
 		if (dbi < 0)
 			return -1;
 	}
@@ -698,9 +702,11 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 				  struct scatterlist *sg, unsigned int sg_nents,
 				  struct iovec **iov, size_t data_len)
 {
+	XA_STATE(xas, &udev->data_pages, 0);
 	/* start value of dbi + 1 must not be a valid dbi */
 	int dbi = -2;
-	size_t block_remaining, cp_len;
+	size_t page_remaining, cp_len;
+	int page_cnt, page_inx;
 	struct sg_mapping_iter sg_iter;
 	unsigned int sg_flags;
 	struct page *page;
@@ -718,37 +724,48 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 					       data_len);
 		else
 			dbi = tcmu_cmd_get_dbi(tcmu_cmd);
-		page = tcmu_get_block_page(udev, dbi);
-		if (direction == TCMU_DATA_AREA_TO_SG)
-			flush_dcache_page(page);
-		data_page_start = kmap_atomic(page);
-		block_remaining = DATA_BLOCK_SIZE;
-
-		while (block_remaining && data_len) {
-			if (!sg_miter_next(&sg_iter)) {
-				/* set length to 0 to abort outer loop */
-				data_len = 0;
-				pr_debug("tcmu_move_data: aborting data copy due to exhausted sg_list\n");
-				break;
+
+		page_cnt = DIV_ROUND_UP(data_len, PAGE_SIZE);
+		if (page_cnt > DATA_PAGES_PER_BLK)
+			page_cnt = DATA_PAGES_PER_BLK;
+
+		xas_set(&xas, dbi * DATA_PAGES_PER_BLK);
+		for (page_inx = 0; page_inx < page_cnt && data_len; page_inx++) {
+			page = xas_next(&xas);
+
+			if (direction == TCMU_DATA_AREA_TO_SG)
+				flush_dcache_page(page);
+			data_page_start = kmap_atomic(page);
+			page_remaining = PAGE_SIZE;
+
+			while (page_remaining && data_len) {
+				if (!sg_miter_next(&sg_iter)) {
+					/* set length to 0 to abort outer loop */
+					data_len = 0;
+					pr_debug("%s: aborting data copy due to exhausted sg_list\n",
+						 __func__);
+					break;
+				}
+				cp_len = min3(sg_iter.length, page_remaining,
+					      data_len);
+
+				data_addr = data_page_start +
+					    PAGE_SIZE - page_remaining;
+				if (direction == TCMU_SG_TO_DATA_AREA)
+					memcpy(data_addr, sg_iter.addr, cp_len);
+				else
+					memcpy(sg_iter.addr, data_addr, cp_len);
+
+				data_len -= cp_len;
+				page_remaining -= cp_len;
+				sg_iter.consumed = cp_len;
 			}
-			cp_len = min3(sg_iter.length, block_remaining, data_len);
+			sg_miter_stop(&sg_iter);
 
-			data_addr = data_page_start +
-				    DATA_BLOCK_SIZE - block_remaining;
+			kunmap_atomic(data_page_start);
 			if (direction == TCMU_SG_TO_DATA_AREA)
-				memcpy(data_addr, sg_iter.addr, cp_len);
-			else
-				memcpy(sg_iter.addr, data_addr, cp_len);
-
-			data_len -= cp_len;
-			block_remaining -= cp_len;
-			sg_iter.consumed = cp_len;
+				flush_dcache_page(page);
 		}
-		sg_miter_stop(&sg_iter);
-
-		kunmap_atomic(data_page_start);
-		if (direction == TCMU_SG_TO_DATA_AREA)
-			flush_dcache_page(page);
 	}
 }
 
@@ -858,13 +875,12 @@ static int tcmu_alloc_data_space(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 			udev->dbi_thresh = udev->max_blocks;
 	}
 
-	iov_cnt = tcmu_get_empty_blocks(udev, cmd,
-					cmd->dbi_cnt - cmd->dbi_bidi_cnt);
+	iov_cnt = tcmu_get_empty_blocks(udev, cmd, cmd->se_cmd->data_length);
 	if (iov_cnt < 0)
 		return -1;
 
 	if (cmd->dbi_bidi_cnt) {
-		ret = tcmu_get_empty_blocks(udev, cmd, cmd->dbi_bidi_cnt);
+		ret = tcmu_get_empty_blocks(udev, cmd, cmd->data_len_bidi);
 		if (ret < 0)
 			return -1;
 	}
@@ -1020,9 +1036,9 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	if (!list_empty(&udev->qfull_queue))
 		goto queue;
 
-	if (data_length > udev->data_size) {
+	if (data_length > udev->max_blocks * DATA_BLOCK_SIZE) {
 		pr_warn("TCMU: Request of size %zu is too big for %zu data area\n",
-			data_length, udev->data_size);
+			data_length, udev->max_blocks * DATA_BLOCK_SIZE);
 		*scsi_err = TCM_INVALID_CDB_FIELD;
 		return -1;
 	}
@@ -1570,7 +1586,8 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	udev->cmd_time_out = TCMU_TIME_OUT;
 	udev->qfull_time_out = -1;
 
-	udev->max_blocks = DATA_BLOCK_BITS_DEF;
+	udev->max_blocks = DATA_AREA_PAGES_DEF / DATA_PAGES_PER_BLK;
+	udev->data_area_mb = TCMU_PAGES_TO_MBS(DATA_AREA_PAGES_DEF);
 	mutex_init(&udev->cmdr_lock);
 
 	INIT_LIST_HEAD(&udev->node);
@@ -1607,19 +1624,24 @@ static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
 	return -EINVAL;
 }
 
-static void tcmu_blocks_release(struct xarray *blocks, unsigned long first,
+static u32 tcmu_blocks_release(struct xarray *blocks, unsigned long first,
 				unsigned long last)
 {
-	XA_STATE(xas, blocks, first);
+	XA_STATE(xas, blocks, first * DATA_PAGES_PER_BLK);
 	struct page *page;
+	u32 pages_freed = 0;
 
 	xas_lock(&xas);
-	xas_for_each(&xas, page, last) {
+	xas_for_each(&xas, page, (last + 1) * DATA_PAGES_PER_BLK - 1) {
 		xas_store(&xas, NULL);
 		__free_page(page);
-		atomic_dec(&global_page_count);
+		pages_freed++;
 	}
 	xas_unlock(&xas);
+
+	atomic_sub(pages_freed, &global_page_count);
+
+	return pages_freed;
 }
 
 static void tcmu_remove_all_queued_tmr(struct tcmu_dev *udev)
@@ -2086,6 +2108,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	struct tcmu_dev *udev = TCMU_DEV(dev);
 	struct uio_info *info;
 	struct tcmu_mailbox *mb;
+	size_t data_size;
 	int ret = 0;
 
 	ret = tcmu_update_uio_info(udev);
@@ -2113,8 +2136,8 @@ static int tcmu_configure_device(struct se_device *dev)
 	udev->cmdr = (void *)mb + CMDR_OFF;
 	udev->cmdr_size = CMDR_SIZE;
 	udev->data_off = MB_CMDR_SIZE;
-	udev->data_size = udev->max_blocks * DATA_BLOCK_SIZE;
-	udev->mmap_pages = (udev->data_size + MB_CMDR_SIZE) >> PAGE_SHIFT;
+	data_size = TCMU_MBS_TO_PAGES(udev->data_area_mb) << PAGE_SHIFT;
+	udev->mmap_pages = (data_size + MB_CMDR_SIZE) >> PAGE_SHIFT;
 	udev->dbi_thresh = 0; /* Default in Idle state */
 
 	/* Initialise the mailbox of the ring buffer */
@@ -2126,14 +2149,13 @@ static int tcmu_configure_device(struct se_device *dev)
 	mb->cmdr_size = udev->cmdr_size;
 
 	WARN_ON(!PAGE_ALIGNED(udev->data_off));
-	WARN_ON(udev->data_size % PAGE_SIZE);
-	WARN_ON(udev->data_size % DATA_BLOCK_SIZE);
+	WARN_ON(data_size % PAGE_SIZE);
 
 	info->version = __stringify(TCMU_MAILBOX_VERSION);
 
 	info->mem[0].name = "tcm-user command & data buffer";
 	info->mem[0].addr = (phys_addr_t)(uintptr_t)udev->mb_addr;
-	info->mem[0].size = udev->data_size + MB_CMDR_SIZE;
+	info->mem[0].size = data_size + MB_CMDR_SIZE;
 	info->mem[0].memtype = UIO_MEM_NONE;
 
 	info->irqcontrol = tcmu_irqcontrol;
@@ -2343,7 +2365,7 @@ static int tcmu_set_dev_attrib(substring_t *arg, u32 *dev_attrib)
 
 static int tcmu_set_max_blocks_param(struct tcmu_dev *udev, substring_t *arg)
 {
-	int val, ret, blks;
+	int val, ret;
 
 	ret = match_int(arg, &val);
 	if (ret < 0) {
@@ -2351,26 +2373,30 @@ static int tcmu_set_max_blocks_param(struct tcmu_dev *udev, substring_t *arg)
 		       ret);
 		return ret;
 	}
-
-	blks = TCMU_MBS_TO_PAGES(val) / DATA_PAGES_PER_BLK;
-	if (blks <= 0) {
+	if (val <= 0) {
 		pr_err("Invalid max_data_area %d.\n", val);
 		return -EINVAL;
 	}
-
-	mutex_lock(&udev->cmdr_lock);
-	if (udev->data_bitmap) {
-		pr_err("Cannot set max_data_area_mb after it has been enabled.\n");
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	udev->max_blocks = blks;
-	if (udev->max_blocks * DATA_PAGES_PER_BLK > tcmu_global_max_pages) {
+	if (val > TCMU_PAGES_TO_MBS(tcmu_global_max_pages)) {
 		pr_err("%d is too large. Adjusting max_data_area_mb to global limit of %u\n",
 		       val, TCMU_PAGES_TO_MBS(tcmu_global_max_pages));
-		udev->max_blocks = tcmu_global_max_pages / DATA_PAGES_PER_BLK;
+		val = TCMU_PAGES_TO_MBS(tcmu_global_max_pages);
 	}
+	if (TCMU_MBS_TO_PAGES(val) < DATA_PAGES_PER_BLK) {
+		pr_err("Invalid max_data_area %d (%zu pages): smaller than data_pages_per_blk (%d pages).\n",
+		       val, TCMU_MBS_TO_PAGES(val), DATA_PAGES_PER_BLK);
+		return -EINVAL;
+	}
+
+	mutex_lock(&udev->cmdr_lock);
+	if (udev->data_bitmap) {
+		pr_err("Cannot set max_data_area_mb after it has been enabled.\n");
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	udev->data_area_mb = val;
+	udev->max_blocks = TCMU_MBS_TO_PAGES(val) / DATA_PAGES_PER_BLK;
 
 unlock:
 	mutex_unlock(&udev->cmdr_lock);
@@ -2448,8 +2474,7 @@ static ssize_t tcmu_show_configfs_dev_params(struct se_device *dev, char *b)
 	bl = sprintf(b + bl, "Config: %s ",
 		     udev->dev_config[0] ? udev->dev_config : "NULL");
 	bl += sprintf(b + bl, "Size: %llu ", udev->dev_size);
-	bl += sprintf(b + bl, "MaxDataAreaMB: %u\n",
-		      TCMU_PAGES_TO_MBS(udev->max_blocks * DATA_PAGES_PER_BLK));
+	bl += sprintf(b + bl, "MaxDataAreaMB: %u\n", udev->data_area_mb);
 
 	return bl;
 }
@@ -2543,8 +2568,7 @@ static ssize_t tcmu_max_data_area_mb_show(struct config_item *item, char *page)
 						struct se_dev_attrib, da_group);
 	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
 
-	return snprintf(page, PAGE_SIZE, "%u\n",
-			TCMU_PAGES_TO_MBS(udev->max_blocks * DATA_PAGES_PER_BLK));
+	return snprintf(page, PAGE_SIZE, "%u\n", udev->data_area_mb);
 }
 CONFIGFS_ATTR_RO(tcmu_, max_data_area_mb);
 
@@ -2902,7 +2926,8 @@ static void find_free_blocks(void)
 {
 	struct tcmu_dev *udev;
 	loff_t off;
-	u32 start, end, block, total_freed = 0;
+	u32 pages_freed, total_pages_freed = 0;
+	u32 start, end, block, total_blocks_freed = 0;
 
 	if (atomic_read(&global_page_count) <= tcmu_global_max_pages)
 		return;
@@ -2949,12 +2974,14 @@ static void find_free_blocks(void)
 		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
 
 		/* Release the block pages */
-		tcmu_blocks_release(&udev->data_pages, start, end - 1);
+		pages_freed = tcmu_blocks_release(&udev->data_pages, start, end - 1);
 		mutex_unlock(&udev->cmdr_lock);
 
-		total_freed += end - start;
-		pr_debug("Freed %u blocks (total %u) from %s.\n", end - start,
-			 total_freed, udev->name);
+		total_pages_freed += pages_freed;
+		total_blocks_freed += end - start;
+		pr_debug("Freed %u pages (total %u) from %u blocks (total %u) from %s.\n",
+			 pages_freed, total_pages_freed, end - start,
+			 total_blocks_freed, udev->name);
 	}
 	mutex_unlock(&root_udev_mutex);
 
-- 
2.12.3

