Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC28C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 11:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32CB7222B8
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 11:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lrjoORtN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgJSLvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 07:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgJSLvY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 07:51:24 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBB6C0613CE;
        Mon, 19 Oct 2020 04:51:23 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dt13so13435719ejb.12;
        Mon, 19 Oct 2020 04:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hGd8rYdj9xN6aYjYyVT64G8gLBdd2xU8PMAYntrCLCE=;
        b=lrjoORtNyEPXLagsW+BsmcMd1IRqEOHlpffWWiLSEKD93NDHxy1Zzbkg6VX79UBJ9p
         mpcyvaUf0SuKI1+l49OZNpqjZZhYeqsHdjTO1rHJWmOVJPa1RrZx6g7KwJQwC1Jts30S
         B88Em+cEz2JHUCteDzfL7lm9EsFb/wMTJ6LAYS6/hfIYhiR5zLJg+jpPdcBGLWV14cMX
         3mivuoBoNIK1p3lvtgUis7sGFcKF1zHTvpqXsqco2/71NWdy1IQokPNhycyz2AqOvMey
         xeHmtO1jmxNe3VthxB+v6bzjOrRf+HmWydmpIdhvcFl4kXaA4pVNF8xl3I2JmydwR1/I
         zVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hGd8rYdj9xN6aYjYyVT64G8gLBdd2xU8PMAYntrCLCE=;
        b=fadniHS93Ic5ERvYsxiLm2QMTJ03q1EIPkubvlQL7HWm+rsEGRFGrA5k+WMZEzq849
         WfK8iJqDTkZkkWXO0uw+1FUUra3vMd6nFQG/9caV5L9tof5cX4mjfbnyi76rOjYRObuV
         nP5YwjpG9y9JMFqfDmiQr4kR+PCJ2qmdsRPk7niYstFe6elDQxSeye0yaVc3wnhS3ZtH
         hkHiKoYVZkL4/OF81ncMwZla8MhVA14QlsW6PkGBRnFmZOQWIVqaBgBajZNeRKKHNW3I
         TZ2PT3Tcgr9djNy8y736dU+qMed1DOZ2q3xCtZjdl3J/PGxEZCO1nDM3JPCboPRHcYQ1
         AXzw==
X-Gm-Message-State: AOAM532NmvW5ukN6qjf6Wa9E/NtpOW0fByW7ML32J8t/6n9Fupb9pFHg
        MnfR1SqKyNQ4R8k4lmzaz4A=
X-Google-Smtp-Source: ABdhPJxtkBSVg2I9vVVKF1EW4k2BZiN1q5hGVCjhE04XEDUor4qp19Scgv8XYNpKoSLrkCyUGZ/Jiw==
X-Received: by 2002:a17:906:1e95:: with SMTP id e21mr16303377ejj.355.1603108282460;
        Mon, 19 Oct 2020 04:51:22 -0700 (PDT)
Received: from localhost (ipbcc08ad4.dynamic.kabel-deutschland.de. [188.192.138.212])
        by smtp.gmail.com with ESMTPSA id p2sm10764537ejd.34.2020.10.19.04.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 04:51:22 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Bodo Stroesser <bostroesser@gmail.com>
Subject: [PATCH v2] scsi: target: tcmu: scatter_/gather_data_area rework
Date:   Mon, 19 Oct 2020 13:51:18 +0200
Message-Id: <20201019115118.11949-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is made on top of the scsi-staging tree plus my previous
patch:
"scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel"

---

scatter_data_area and gather_data_area are not easy to understand,
since data is copied in nested loops over sg_list and tcmu dbi
list. Since sg list can contain only partly filled pages, the loop
has to be prepared to handle sg pages not matching dbi pages
1 by 1.

Existing implementation uses kmap_atomic()/kunmap_atomic() due to
performance reasons. But instead of using these calls strictly
nested for sg and dpi pages, the code holds the mappings in an
overlapping way, which indeed is a bug that would trigger on archs
using highmem.

The scatterlist lib contains the sg_miter_start/_next/_stop
functions which can be used to simplify such complicated loops.

The new code now processes the dbi list in the outer loop, while
sg list is handled by the inner one. That way the code can take
advantage of the sg_miter_* family calls.

Calling sg_miter_stop() after the end of the inner loop enforces
strict nesting of atomic kmaps.

Since the nested loops in scatter_/gather_data_area were very
similar, I replaced them by the new helper function
tcmu_copy_data().

Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>

---

History:

v2: - Fixed a bug when userspace sends less read data than expected
      by SCSI cmd.
    - In function tcmu_copy_data changed type of param data_len
      and local variable block_remaining from int to size_t
    - Removed superfluous line feed in declaration of function
      tcmu_copy_data
---
 drivers/target/target_core_user.c | 168 +++++++++++++++++---------------------
 1 file changed, 77 insertions(+), 91 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 954031c48830..a2cfd59a0375 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -642,14 +642,15 @@ static int handle_compat_iovec(struct tcmu_dev *udev, struct iovec **iov,
 #endif
 
 static int new_block_to_iov(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
-			    struct iovec **iov, int prev_dbi, int *remain)
+			    struct iovec **iov, int prev_dbi, int len)
 {
 	/* Get the next dbi */
 	int dbi = tcmu_cmd_get_dbi(cmd);
+
 	/* Do not add more than DATA_BLOCK_SIZE to iov */
-	int len = min_t(int, DATA_BLOCK_SIZE, *remain);
+	if (len > DATA_BLOCK_SIZE)
+		len = DATA_BLOCK_SIZE;
 
-	*remain -= len;
 	/*
 	 * The following code will gather and map the blocks to the same iovec
 	 * when the blocks are all next to each other.
@@ -678,8 +679,8 @@ static void tcmu_setup_iovs(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	int dbi = -2;
 
 	/* We prepare the IOVs for DMA_FROM_DEVICE transfer direction */
-	while (data_length > 0)
-		dbi = new_block_to_iov(udev, cmd, iov, dbi, &data_length);
+	for (; data_length > 0; data_length -= DATA_BLOCK_SIZE)
+		dbi = new_block_to_iov(udev, cmd, iov, dbi, data_length);
 }
 
 static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
@@ -748,67 +749,83 @@ static inline size_t head_to_end(size_t head, size_t size)
 
 #define UPDATE_HEAD(head, used, size) smp_store_release(&head, ((head % size) + used) % size)
 
+#define TCMU_SG_TO_DATA_AREA 1
+#define TCMU_DATA_AREA_TO_SG 2
+
+static inline void tcmu_copy_data(struct tcmu_dev *udev,
+				  struct tcmu_cmd *tcmu_cmd, uint32_t direction,
+				  struct scatterlist *sg, unsigned int sg_nents,
+				  struct iovec **iov, size_t data_len)
+{
+	/* start value of dbi + 1 must not be a valid dbi */
+	int dbi = -2;
+	size_t block_remaining, cp_len;
+	struct sg_mapping_iter sg_iter;
+	unsigned int sg_flags;
+	struct page *page;
+	void *data_page_start, *data_addr;
+
+	if (direction == TCMU_SG_TO_DATA_AREA)
+		sg_flags = SG_MITER_ATOMIC | SG_MITER_FROM_SG;
+	else
+		sg_flags = SG_MITER_ATOMIC | SG_MITER_TO_SG;
+	sg_miter_start(&sg_iter, sg, sg_nents, sg_flags);
+
+	while (data_len) {
+		if (direction == TCMU_SG_TO_DATA_AREA)
+			dbi = new_block_to_iov(udev, tcmu_cmd, iov, dbi,
+					       data_len);
+		else
+			dbi = tcmu_cmd_get_dbi(tcmu_cmd);
+		page = tcmu_get_block_page(udev, dbi);
+		if (direction == TCMU_DATA_AREA_TO_SG)
+			flush_dcache_page(page);
+		data_page_start = kmap_atomic(page);
+		block_remaining = DATA_BLOCK_SIZE;
+
+		while (block_remaining && data_len) {
+			if (!sg_miter_next(&sg_iter)) {
+				/* set length to 0 to abort outer loop */
+				data_len = 0;
+				pr_debug("tcmu_move_data: aborting data copy due to exhausted sg_list\n");
+				break;
+			}
+			cp_len = min3(sg_iter.length, block_remaining, data_len);
+
+			data_addr = data_page_start +
+				    DATA_BLOCK_SIZE - block_remaining;
+			if (direction == TCMU_SG_TO_DATA_AREA)
+				memcpy(data_addr, sg_iter.addr, cp_len);
+			else
+				memcpy(sg_iter.addr, data_addr, cp_len);
+
+			data_len -= cp_len;
+			block_remaining -= cp_len;
+			sg_iter.consumed = cp_len;
+		}
+		sg_miter_stop(&sg_iter);
+
+		kunmap_atomic(data_page_start);
+		if (direction == TCMU_SG_TO_DATA_AREA)
+			flush_dcache_page(page);
+	}
+}
+
 static void scatter_data_area(struct tcmu_dev *udev, struct tcmu_cmd *tcmu_cmd,
 			      struct iovec **iov)
 {
 	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
-	/* start value of dbi + 1 must not be a valid dbi */
-	int i, dbi = -2;
-	int block_remaining = 0;
-	int data_len = se_cmd->data_length;
-	void *from, *to = NULL;
-	size_t copy_bytes, offset;
-	struct scatterlist *sg;
-	struct page *page = NULL;
 
-	for_each_sg(se_cmd->t_data_sg, sg, se_cmd->t_data_nents, i) {
-		int sg_remaining = sg->length;
-		from = kmap_atomic(sg_page(sg)) + sg->offset;
-		while (sg_remaining > 0) {
-			if (block_remaining == 0) {
-				if (to) {
-					flush_dcache_page(page);
-					kunmap_atomic(to);
-				}
-
-				/* get next dbi and add to IOVs */
-				dbi = new_block_to_iov(udev, tcmu_cmd, iov, dbi,
-						       &data_len);
-				page = tcmu_get_block_page(udev, dbi);
-				to = kmap_atomic(page);
-				block_remaining = DATA_BLOCK_SIZE;
-			}
-
-			copy_bytes = min_t(size_t, sg_remaining,
-					block_remaining);
-			offset = DATA_BLOCK_SIZE - block_remaining;
-			memcpy(to + offset, from + sg->length - sg_remaining,
-			       copy_bytes);
-
-			sg_remaining -= copy_bytes;
-			block_remaining -= copy_bytes;
-		}
-		kunmap_atomic(from - sg->offset);
-	}
-
-	if (to) {
-		flush_dcache_page(page);
-		kunmap_atomic(to);
-	}
+	tcmu_copy_data(udev, tcmu_cmd, TCMU_SG_TO_DATA_AREA, se_cmd->t_data_sg,
+		       se_cmd->t_data_nents, iov, se_cmd->data_length);
 }
 
-static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
+static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *tcmu_cmd,
 			     bool bidi, uint32_t read_len)
 {
-	struct se_cmd *se_cmd = cmd->se_cmd;
-	int i, dbi;
-	int block_remaining = 0;
-	void *from = NULL, *to;
-	size_t copy_bytes, offset;
-	struct scatterlist *sg, *data_sg;
-	struct page *page;
+	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
+	struct scatterlist *data_sg;
 	unsigned int data_nents;
-	uint32_t count = 0;
 
 	if (!bidi) {
 		data_sg = se_cmd->t_data_sg;
@@ -819,46 +836,15 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 		 * buffer blocks, and before gathering the Data-In buffer
 		 * the Data-Out buffer blocks should be skipped.
 		 */
-		count = cmd->dbi_cnt - cmd->dbi_bidi_cnt;
+		tcmu_cmd_set_dbi_cur(tcmu_cmd,
+				     tcmu_cmd->dbi_cnt - tcmu_cmd->dbi_bidi_cnt);
 
 		data_sg = se_cmd->t_bidi_data_sg;
 		data_nents = se_cmd->t_bidi_data_nents;
 	}
 
-	tcmu_cmd_set_dbi_cur(cmd, count);
-
-	for_each_sg(data_sg, sg, data_nents, i) {
-		int sg_remaining = sg->length;
-		to = kmap_atomic(sg_page(sg)) + sg->offset;
-		while (sg_remaining > 0 && read_len > 0) {
-			if (block_remaining == 0) {
-				if (from)
-					kunmap_atomic(from);
-
-				block_remaining = DATA_BLOCK_SIZE;
-				dbi = tcmu_cmd_get_dbi(cmd);
-				page = tcmu_get_block_page(udev, dbi);
-				from = kmap_atomic(page);
-				flush_dcache_page(page);
-			}
-			copy_bytes = min_t(size_t, sg_remaining,
-					block_remaining);
-			if (read_len < copy_bytes)
-				copy_bytes = read_len;
-			offset = DATA_BLOCK_SIZE - block_remaining;
-			memcpy(to + sg->length - sg_remaining, from + offset,
-					copy_bytes);
-
-			sg_remaining -= copy_bytes;
-			block_remaining -= copy_bytes;
-			read_len -= copy_bytes;
-		}
-		kunmap_atomic(to - sg->offset);
-		if (read_len == 0)
-			break;
-	}
-	if (from)
-		kunmap_atomic(from);
+	tcmu_copy_data(udev, tcmu_cmd, TCMU_DATA_AREA_TO_SG, data_sg,
+		       data_nents, NULL, read_len);
 }
 
 static inline size_t spc_bitmap_free(unsigned long *bitmap, uint32_t thresh)
-- 
2.12.3

