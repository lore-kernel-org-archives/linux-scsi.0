Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0A3C433EB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51136619F8
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbhCXT7A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbhCXT6s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 15:58:48 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535AFC061763;
        Wed, 24 Mar 2021 12:58:48 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id w3so34920160ejc.4;
        Wed, 24 Mar 2021 12:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5+hIx5p7bz9AsvCkqooSwiz/LqaDIMVyvjnw+uIs8RY=;
        b=UTPYya2XPpaQrft214WT5YsMIsot7oEKKQa2vo3XAPgBmxZvSjc6BnpQ5IMps4rKu6
         bvhtmtXscC+3+nINRnx7vE+PnWC2vzuIZBh5bIy5dIMw2AmZupgSJoY5w2JfLvUlQIKf
         zmTNjwD4Md5uUyZZCm0FlZsdOYi8ygD/XKWsGCPJoYyrzaUGbjWdPmpTFc14LwpDvKcX
         NCdSuHZVu027gtaeZS+55esbATgvVlz3C2ym+sxVJXSayWEmjPqklg4mECrC7ohli5Pc
         /SIn0GJiLs7k2BFFyCtcHK6OxwP7kZ4VjVBxbcZPQ0imEu5N2M7k0B9PydrMlh76CGy8
         BAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5+hIx5p7bz9AsvCkqooSwiz/LqaDIMVyvjnw+uIs8RY=;
        b=Qd0wsMpYp3vLwccdbRFsYKr1AwtFw1bDKslyWoOhsbxNR6B8Dmp6Cq6azi8V49xKth
         7ZTZxMs1ujvOg7d6ORcmOLSWtUGKrm6F7witlw/AClsEH89TyS3idmWJgqQhnjtNDXiO
         NmVuc19iXlNxcBq99FnNYAIVxZnGiAB9euMkdK3MTF563ve3rlqCsy/YmJUQL+I3226w
         HJXsl90I0bitmCf/5kGfVoq4jpmdIeJNhcatJHNrMqZX1NCBK+IBcIxwRGyt9J38rvrC
         haR4gj8aJJ4i9kGehgb4K3/hLuKcP2qKYvbkaqquDeoGSUcdyJdH/hJc4HpIu8K4Zc/0
         om/Q==
X-Gm-Message-State: AOAM533tKOAnm2xCM3x9PummjE1XxljGM+WE9woeiEv80hZJGoG/1m2f
        DSdzOR+vb/IVQraRRhuxtLQbwGSk/Ws=
X-Google-Smtp-Source: ABdhPJw4AQacSWjHh+WKuKUvb0IZ9IFQFUD2a5Z2UpPpsl0BfJEaW9F3fmgd4FiMXg2He/IQV/7K2g==
X-Received: by 2002:a17:906:3f8c:: with SMTP id b12mr5672753ejj.340.1616615927046;
        Wed, 24 Mar 2021 12:58:47 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id ho11sm1323726ejc.112.2021.03.24.12.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 12:58:46 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 5/6] scsi: target: tcmu: Replace block size definitions with new udev members
Date:   Wed, 24 Mar 2021 20:57:57 +0100
Message-Id: <20210324195758.2021-6-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210324195758.2021-1-bostroesser@gmail.com>
References: <20210324195758.2021-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace DATA_PAGES_PER_BLK and DATA_BLOCK_SIZE with new struct
elements tcmu_dev->data_pages_per_blk and tcmu_dev->data_blk_size.
These new variables are still loaded with constant definition
DATA_PAGES_PER_BLK_DEF (= 1) and DATA_PAGES_PER_BLK_DEF * PAGE_SIZE
There is no way yet to set the values via configFS, so for testing
please modify definition of DATA_PAGES_PER_BLK_DEF in source.
Next patch will add ConfigFS support.

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
---
 drivers/target/target_core_user.c | 82 +++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9b2bff450510..3de66db06438 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -70,8 +70,7 @@
  * For data area, the default block size is PAGE_SIZE and
  * the default total size is 256K * PAGE_SIZE.
  */
-#define DATA_PAGES_PER_BLK 1
-#define DATA_BLOCK_SIZE (DATA_PAGES_PER_BLK * PAGE_SIZE)
+#define DATA_PAGES_PER_BLK_DEF 1
 #define DATA_AREA_PAGES_DEF (256 * 1024)
 
 #define TCMU_MBS_TO_PAGES(_mbs) ((size_t)_mbs << (20 - PAGE_SHIFT))
@@ -150,6 +149,8 @@ struct tcmu_dev {
 	uint32_t dbi_thresh;
 	unsigned long *data_bitmap;
 	struct xarray data_pages;
+	uint32_t data_pages_per_blk;
+	uint32_t data_blk_size;
 
 	struct xarray commands;
 
@@ -505,15 +506,16 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 {
 	XA_STATE(xas, &udev->data_pages, 0);
 	struct page *page;
-	int i, cnt, dbi;
+	int i, cnt, dbi, dpi;
 	int page_cnt = DIV_ROUND_UP(length, PAGE_SIZE);
 
 	dbi = find_first_zero_bit(udev->data_bitmap, udev->dbi_thresh);
 	if (dbi == udev->dbi_thresh)
 		return -1;
 
+	dpi = dbi * udev->data_pages_per_blk;
 	/* Count the number of already allocated pages */
-	xas_set(&xas, dbi * DATA_PAGES_PER_BLK);
+	xas_set(&xas, dpi);
 	for (cnt = 0; xas_next(&xas) && cnt < page_cnt;)
 		cnt++;
 
@@ -523,8 +525,7 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
 		if (!page)
 			break;
 
-		if (xa_store(&udev->data_pages, dbi * DATA_PAGES_PER_BLK + i,
-			     page, GFP_NOIO)) {
+		if (xa_store(&udev->data_pages, dpi + i, page, GFP_NOIO)) {
 			__free_page(page);
 			break;
 		}
@@ -550,11 +551,13 @@ static int tcmu_get_empty_blocks(struct tcmu_dev *udev,
 {
 	/* start value of dbi + 1 must not be a valid dbi */
 	int dbi = -2;
-	int blk_len, iov_cnt = 0;
+	int blk_data_len, iov_cnt = 0;
+	uint32_t blk_size = udev->data_blk_size;
 
-	for (; length > 0; length -= DATA_BLOCK_SIZE) {
-		blk_len = min_t(int, length, DATA_BLOCK_SIZE);
-		dbi = tcmu_get_empty_block(udev, tcmu_cmd, dbi, blk_len, &iov_cnt);
+	for (; length > 0; length -= blk_size) {
+		blk_data_len = min_t(uint32_t, length, blk_size);
+		dbi = tcmu_get_empty_block(udev, tcmu_cmd, dbi, blk_data_len,
+					   &iov_cnt);
 		if (dbi < 0)
 			return -1;
 	}
@@ -571,14 +574,15 @@ static inline void tcmu_cmd_set_block_cnts(struct tcmu_cmd *cmd)
 {
 	int i, len;
 	struct se_cmd *se_cmd = cmd->se_cmd;
+	uint32_t blk_size = cmd->tcmu_dev->data_blk_size;
 
-	cmd->dbi_cnt = DIV_ROUND_UP(se_cmd->data_length, DATA_BLOCK_SIZE);
+	cmd->dbi_cnt = DIV_ROUND_UP(se_cmd->data_length, blk_size);
 
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
 		for (i = 0, len = 0; i < se_cmd->t_bidi_data_nents; i++)
 			len += se_cmd->t_bidi_data_sg[i].length;
-		cmd->dbi_bidi_cnt = DIV_ROUND_UP(len, DATA_BLOCK_SIZE);
+		cmd->dbi_bidi_cnt = DIV_ROUND_UP(len, blk_size);
 		cmd->dbi_cnt += cmd->dbi_bidi_cnt;
 		cmd->data_len_bidi = len;
 	}
@@ -590,9 +594,8 @@ static int new_block_to_iov(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	/* Get the next dbi */
 	int dbi = tcmu_cmd_get_dbi(cmd);
 
-	/* Do not add more than DATA_BLOCK_SIZE to iov */
-	if (len > DATA_BLOCK_SIZE)
-		len = DATA_BLOCK_SIZE;
+	/* Do not add more than udev->data_blk_size to iov */
+	len = min_t(int,  len, udev->data_blk_size);
 
 	/*
 	 * The following code will gather and map the blocks to the same iovec
@@ -604,7 +607,7 @@ static int new_block_to_iov(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 			(*iov)++;
 		/* write offset relative to mb_addr */
 		(*iov)->iov_base = (void __user *)
-				(udev->data_off + dbi * DATA_BLOCK_SIZE);
+				   (udev->data_off + dbi * udev->data_blk_size);
 	}
 	(*iov)->iov_len += len;
 
@@ -618,7 +621,7 @@ static void tcmu_setup_iovs(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	int dbi = -2;
 
 	/* We prepare the IOVs for DMA_FROM_DEVICE transfer direction */
-	for (; data_length > 0; data_length -= DATA_BLOCK_SIZE)
+	for (; data_length > 0; data_length -= udev->data_blk_size)
 		dbi = new_block_to_iov(udev, cmd, iov, dbi, data_length);
 }
 
@@ -720,10 +723,10 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
 			dbi = tcmu_cmd_get_dbi(tcmu_cmd);
 
 		page_cnt = DIV_ROUND_UP(data_len, PAGE_SIZE);
-		if (page_cnt > DATA_PAGES_PER_BLK)
-			page_cnt = DATA_PAGES_PER_BLK;
+		if (page_cnt > udev->data_pages_per_blk)
+			page_cnt = udev->data_pages_per_blk;
 
-		xas_set(&xas, dbi * DATA_PAGES_PER_BLK);
+		xas_set(&xas, dbi * udev->data_pages_per_blk);
 		for (page_inx = 0; page_inx < page_cnt && data_len; page_inx++) {
 			page = xas_next(&xas);
 
@@ -858,9 +861,9 @@ static int tcmu_alloc_data_space(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 				(udev->max_blocks - udev->dbi_thresh) + space;
 
 		if (blocks_left < cmd->dbi_cnt) {
-			pr_debug("no data space: only %lu available, but ask for %lu\n",
-					blocks_left * DATA_BLOCK_SIZE,
-					cmd->dbi_cnt * DATA_BLOCK_SIZE);
+			pr_debug("no data space: only %lu available, but ask for %u\n",
+					blocks_left * udev->data_blk_size,
+					cmd->dbi_cnt * udev->data_blk_size);
 			return -1;
 		}
 
@@ -1012,8 +1015,9 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	int iov_cnt, iov_bidi_cnt;
 	uint32_t cmd_id, cmd_head;
 	uint64_t cdb_off;
+	uint32_t blk_size = udev->data_blk_size;
 	/* size of data buffer needed */
-	size_t data_length = (size_t)tcmu_cmd->dbi_cnt * DATA_BLOCK_SIZE;
+	size_t data_length = (size_t)tcmu_cmd->dbi_cnt * blk_size;
 
 	*scsi_err = TCM_NO_SENSE;
 
@@ -1030,9 +1034,9 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 	if (!list_empty(&udev->qfull_queue))
 		goto queue;
 
-	if (data_length > udev->max_blocks * DATA_BLOCK_SIZE) {
+	if (data_length > (size_t)udev->max_blocks * blk_size) {
 		pr_warn("TCMU: Request of size %zu is too big for %zu data area\n",
-			data_length, udev->max_blocks * DATA_BLOCK_SIZE);
+			data_length, (size_t)udev->max_blocks * blk_size);
 		*scsi_err = TCM_INVALID_CDB_FIELD;
 		return -1;
 	}
@@ -1580,8 +1584,10 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	udev->cmd_time_out = TCMU_TIME_OUT;
 	udev->qfull_time_out = -1;
 
-	udev->max_blocks = DATA_AREA_PAGES_DEF / DATA_PAGES_PER_BLK;
+	udev->data_pages_per_blk = DATA_PAGES_PER_BLK_DEF;
+	udev->max_blocks = DATA_AREA_PAGES_DEF / udev->data_pages_per_blk;
 	udev->data_area_mb = TCMU_PAGES_TO_MBS(DATA_AREA_PAGES_DEF);
+
 	mutex_init(&udev->cmdr_lock);
 
 	INIT_LIST_HEAD(&udev->node);
@@ -1618,15 +1624,15 @@ static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
 	return -EINVAL;
 }
 
-static u32 tcmu_blocks_release(struct xarray *blocks, unsigned long first,
+static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
 				unsigned long last)
 {
-	XA_STATE(xas, blocks, first * DATA_PAGES_PER_BLK);
+	XA_STATE(xas, &udev->data_pages, first * udev->data_pages_per_blk);
 	struct page *page;
 	u32 pages_freed = 0;
 
 	xas_lock(&xas);
-	xas_for_each(&xas, page, (last + 1) * DATA_PAGES_PER_BLK - 1) {
+	xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
 		xas_store(&xas, NULL);
 		__free_page(page);
 		pages_freed++;
@@ -1677,7 +1683,7 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	xa_destroy(&udev->commands);
 	WARN_ON(!all_expired);
 
-	tcmu_blocks_release(&udev->data_pages, 0, udev->dbi_max);
+	tcmu_blocks_release(udev, 0, udev->dbi_max);
 	bitmap_free(udev->data_bitmap);
 	mutex_unlock(&udev->cmdr_lock);
 
@@ -2132,6 +2138,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	udev->data_off = MB_CMDR_SIZE;
 	data_size = TCMU_MBS_TO_PAGES(udev->data_area_mb) << PAGE_SHIFT;
 	udev->mmap_pages = (data_size + MB_CMDR_SIZE) >> PAGE_SHIFT;
+	udev->data_blk_size = udev->data_pages_per_blk * PAGE_SIZE;
 	udev->dbi_thresh = 0; /* Default in Idle state */
 
 	/* Initialise the mailbox of the ring buffer */
@@ -2360,6 +2367,7 @@ static int tcmu_set_dev_attrib(substring_t *arg, u32 *dev_attrib)
 static int tcmu_set_max_blocks_param(struct tcmu_dev *udev, substring_t *arg)
 {
 	int val, ret;
+	uint32_t pages_per_blk = udev->data_pages_per_blk;
 
 	ret = match_int(arg, &val);
 	if (ret < 0) {
@@ -2376,9 +2384,9 @@ static int tcmu_set_max_blocks_param(struct tcmu_dev *udev, substring_t *arg)
 		       val, TCMU_PAGES_TO_MBS(tcmu_global_max_pages));
 		val = TCMU_PAGES_TO_MBS(tcmu_global_max_pages);
 	}
-	if (TCMU_MBS_TO_PAGES(val) < DATA_PAGES_PER_BLK) {
-		pr_err("Invalid max_data_area %d (%zu pages): smaller than data_pages_per_blk (%d pages).\n",
-		       val, TCMU_MBS_TO_PAGES(val), DATA_PAGES_PER_BLK);
+	if (TCMU_MBS_TO_PAGES(val) < pages_per_blk) {
+		pr_err("Invalid max_data_area %d (%zu pages): smaller than data_pages_per_blk (%u pages).\n",
+		       val, TCMU_MBS_TO_PAGES(val), pages_per_blk);
 		return -EINVAL;
 	}
 
@@ -2390,7 +2398,7 @@ static int tcmu_set_max_blocks_param(struct tcmu_dev *udev, substring_t *arg)
 	}
 
 	udev->data_area_mb = val;
-	udev->max_blocks = TCMU_MBS_TO_PAGES(val) / DATA_PAGES_PER_BLK;
+	udev->max_blocks = TCMU_MBS_TO_PAGES(val) / pages_per_blk;
 
 unlock:
 	mutex_unlock(&udev->cmdr_lock);
@@ -2964,11 +2972,11 @@ static void find_free_blocks(void)
 		}
 
 		/* Here will truncate the data area from off */
-		off = udev->data_off + start * DATA_BLOCK_SIZE;
+		off = udev->data_off + (loff_t)start * udev->data_blk_size;
 		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
 
 		/* Release the block pages */
-		pages_freed = tcmu_blocks_release(&udev->data_pages, start, end - 1);
+		pages_freed = tcmu_blocks_release(udev, start, end - 1);
 		mutex_unlock(&udev->cmdr_lock);
 
 		total_pages_freed += pages_freed;
-- 
2.12.3

