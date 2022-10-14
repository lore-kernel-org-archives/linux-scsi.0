Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030A7C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Oct 2022 11:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiJNLqV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 07:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJNLqP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 07:46:15 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBC8DCEB1;
        Fri, 14 Oct 2022 04:46:11 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5624F4121C;
        Fri, 14 Oct 2022 11:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1665747968; x=1667562369; bh=cpaHYspv4KcZ9j4yk8BXtOr4E
        mIL9e5GVp9UQwUxSsE=; b=mbfxeC6qNV47PSGXxRDKqmIfcQ2KRpRYKBunuqf6+
        QlteI/FnNxM2ZSpHkOWuYPLwDlkaVBYgqTqMlBgZQ1OJtVW3q9pzlp5tjIAs3pVK
        PXg5z9BHEUT0CukXjDpkHFJdXtvO/R2Wddf//JJqbvBAFnrSvLh4ffnblOW66WHN
        e8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KKNQtig-NLld; Fri, 14 Oct 2022 14:46:08 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B719C41226;
        Fri, 14 Oct 2022 14:46:06 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 14 Oct 2022 14:46:06 +0300
Received: from localhost (10.199.23.220) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 14 Oct
 2022 14:46:06 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: [v2,PATCH 3/3] target: core: Change the way target_xcopy_do_work sets restiction on max io
Date:   Fri, 14 Oct 2022 14:45:49 +0300
Message-ID: <20221014114549.32888-4-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221014114549.32888-1-a.kovaleva@yadro.com>
References: <20221014114549.32888-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.23.220]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To determine how many blocks sends in one command, the minimum value is
selected from the hw_max_sectors of both devices. In
target_xcopy_do_work, hw_max_sectors are used as blocks, not sectors; it
also ignores the fact that sectors can be of different sizes, for
example 512 and 4096 bytes. Because of this, a number of blocks can be
transmitted that the device will not be able to accept.

Change the selection of max transmission size into bytes.

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_xcopy.c | 96 ++++++++++++++++--------------
 drivers/target/target_core_xcopy.h |  2 +-
 2 files changed, 51 insertions(+), 47 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 8713cda0c2fb..55ee74a15746 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -582,11 +582,11 @@ static int target_xcopy_read_source(
 	struct xcopy_op *xop,
 	struct se_device *src_dev,
 	sector_t src_lba,
-	u32 src_sectors)
+	u32 src_bytes)
 {
 	struct xcopy_pt_cmd xpt_cmd;
 	struct se_cmd *se_cmd = &xpt_cmd.se_cmd;
-	u32 length = (src_sectors * src_dev->dev_attrib.block_size);
+	u32 transfer_length_block = src_bytes / src_dev->dev_attrib.block_size;
 	int rc;
 	unsigned char cdb[16];
 	bool remote_port = (xop->op_origin == XCOL_DEST_RECV_OP);
@@ -597,11 +597,11 @@ static int target_xcopy_read_source(
 	memset(&cdb[0], 0, 16);
 	cdb[0] = READ_16;
 	put_unaligned_be64(src_lba, &cdb[2]);
-	put_unaligned_be32(src_sectors, &cdb[10]);
-	pr_debug("XCOPY: Built READ_16: LBA: %llu Sectors: %u Length: %u\n",
-		(unsigned long long)src_lba, src_sectors, length);
+	put_unaligned_be32(transfer_length_block, &cdb[10]);
+	pr_debug("XCOPY: Built READ_16: LBA: %llu Blocks: %u Length: %u\n",
+		(unsigned long long)src_lba, transfer_length_block, src_bytes);
 
-	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
+	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, src_bytes,
 			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
 
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
@@ -627,11 +627,11 @@ static int target_xcopy_write_destination(
 	struct xcopy_op *xop,
 	struct se_device *dst_dev,
 	sector_t dst_lba,
-	u32 dst_sectors)
+	u32 dst_bytes)
 {
 	struct xcopy_pt_cmd xpt_cmd;
 	struct se_cmd *se_cmd = &xpt_cmd.se_cmd;
-	u32 length = (dst_sectors * dst_dev->dev_attrib.block_size);
+	u32 transfer_length_block = dst_bytes / dst_dev->dev_attrib.block_size;
 	int rc;
 	unsigned char cdb[16];
 	bool remote_port = (xop->op_origin == XCOL_SOURCE_RECV_OP);
@@ -642,11 +642,11 @@ static int target_xcopy_write_destination(
 	memset(&cdb[0], 0, 16);
 	cdb[0] = WRITE_16;
 	put_unaligned_be64(dst_lba, &cdb[2]);
-	put_unaligned_be32(dst_sectors, &cdb[10]);
-	pr_debug("XCOPY: Built WRITE_16: LBA: %llu Sectors: %u Length: %u\n",
-		(unsigned long long)dst_lba, dst_sectors, length);
+	put_unaligned_be32(transfer_length_block, &cdb[10]);
+	pr_debug("XCOPY: Built WRITE_16: LBA: %llu Blocks: %u Length: %u\n",
+		(unsigned long long)dst_lba, transfer_length_block, dst_bytes);
 
-	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
+	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, dst_bytes,
 			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
 
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
@@ -670,9 +670,10 @@ static void target_xcopy_do_work(struct work_struct *work)
 	struct se_cmd *ec_cmd = xop->xop_se_cmd;
 	struct se_device *src_dev, *dst_dev;
 	sector_t src_lba, dst_lba, end_lba;
-	unsigned int max_sectors;
+	unsigned long long max_bytes, max_bytes_src, max_bytes_dst, max_blocks;
 	int rc = 0;
-	unsigned short nolb, max_nolb, copied_nolb = 0;
+	unsigned short nolb;
+	unsigned int copied_bytes = 0;
 	sense_reason_t sense_rc;
 
 	sense_rc = target_parse_xcopy_cmd(xop);
@@ -691,23 +692,26 @@ static void target_xcopy_do_work(struct work_struct *work)
 	nolb = xop->nolb;
 	end_lba = src_lba + nolb;
 	/*
-	 * Break up XCOPY I/O into hw_max_sectors sized I/O based on the
-	 * smallest max_sectors between src_dev + dev_dev, or
+	 * Break up XCOPY I/O into hw_max_sectors * hw_block_size sized
+	 * I/O based on the smallest max_bytes between src_dev + dst_dev
 	 */
-	max_sectors = min(src_dev->dev_attrib.hw_max_sectors,
-			  dst_dev->dev_attrib.hw_max_sectors);
-	max_sectors = min_t(u32, max_sectors, XCOPY_MAX_SECTORS);
-
-	max_nolb = min_t(u16, max_sectors, ((u16)(~0U)));
-
-	pr_debug("target_xcopy_do_work: nolb: %hu, max_nolb: %hu end_lba: %llu\n",
-			nolb, max_nolb, (unsigned long long)end_lba);
-	pr_debug("target_xcopy_do_work: Starting src_lba: %llu, dst_lba: %llu\n",
+	max_bytes_src = (unsigned long long) src_dev->dev_attrib.hw_max_sectors *
+			src_dev->dev_attrib.hw_block_size;
+	max_bytes_dst = (unsigned long long) dst_dev->dev_attrib.hw_max_sectors *
+			dst_dev->dev_attrib.hw_block_size;
+
+	max_bytes = min_t(u64, max_bytes_src, max_bytes_dst);
+	max_bytes = min_t(u64, max_bytes, XCOPY_MAX_BYTES);
+	max_blocks = max_bytes / src_dev->dev_attrib.block_size;
+
+	pr_debug("%s: nolb: %u, max_blocks: %llu end_lba: %llu\n", __func__,
+			nolb, max_blocks, (unsigned long long)end_lba);
+	pr_debug("%s: Starting src_lba: %llu, dst_lba: %llu\n", __func__,
 			(unsigned long long)src_lba, (unsigned long long)dst_lba);
 
-	while (src_lba < end_lba) {
-		unsigned short cur_nolb = min(nolb, max_nolb);
-		u32 cur_bytes = cur_nolb * src_dev->dev_attrib.block_size;
+	while (nolb) {
+		u32 cur_bytes = min_t(u64, max_bytes, nolb * src_dev->dev_attrib.block_size);
+		unsigned short cur_nolb = cur_bytes / src_dev->dev_attrib.block_size;
 
 		if (cur_bytes != xop->xop_data_bytes) {
 			/*
@@ -724,43 +728,43 @@ static void target_xcopy_do_work(struct work_struct *work)
 			xop->xop_data_bytes = cur_bytes;
 		}
 
-		pr_debug("target_xcopy_do_work: Calling read src_dev: %p src_lba: %llu,"
-			" cur_nolb: %hu\n", src_dev, (unsigned long long)src_lba, cur_nolb);
+		pr_debug("%s: Calling read src_dev: %p src_lba: %llu, cur_nolb: %hu\n",
+				__func__, src_dev, (unsigned long long)src_lba, cur_nolb);
 
-		rc = target_xcopy_read_source(ec_cmd, xop, src_dev, src_lba, cur_nolb);
+		rc = target_xcopy_read_source(ec_cmd, xop, src_dev, src_lba, cur_bytes);
 		if (rc < 0)
 			goto out;
 
-		src_lba += cur_nolb;
-		pr_debug("target_xcopy_do_work: Incremented READ src_lba to %llu\n",
+		src_lba += cur_bytes / src_dev->dev_attrib.block_size;
+		pr_debug("%s: Incremented READ src_lba to %llu\n", __func__,
 				(unsigned long long)src_lba);
 
-		pr_debug("target_xcopy_do_work: Calling write dst_dev: %p dst_lba: %llu,"
-			" cur_nolb: %hu\n", dst_dev, (unsigned long long)dst_lba, cur_nolb);
+		pr_debug("%s: Calling write dst_dev: %p dst_lba: %llu, cur_nolb: %u\n",
+				__func__, dst_dev, (unsigned long long)dst_lba, cur_nolb);
 
 		rc = target_xcopy_write_destination(ec_cmd, xop, dst_dev,
-						dst_lba, cur_nolb);
+						dst_lba, cur_bytes);
 		if (rc < 0)
 			goto out;
 
-		dst_lba += cur_nolb;
-		pr_debug("target_xcopy_do_work: Incremented WRITE dst_lba to %llu\n",
+		dst_lba += cur_bytes / dst_dev->dev_attrib.block_size;
+		pr_debug("%s: Incremented WRITE dst_lba to %llu\n", __func__,
 				(unsigned long long)dst_lba);
 
-		copied_nolb += cur_nolb;
-		nolb -= cur_nolb;
+		copied_bytes += cur_bytes;
+		nolb -= cur_bytes / src_dev->dev_attrib.block_size;
 	}
 
 	xcopy_pt_undepend_remotedev(xop);
 	target_free_sgl(xop->xop_data_sg, xop->xop_data_nents);
 	kfree(xop);
 
-	pr_debug("target_xcopy_do_work: Final src_lba: %llu, dst_lba: %llu\n",
+	pr_debug("%s: Final src_lba: %llu, dst_lba: %llu\n", __func__,
 		(unsigned long long)src_lba, (unsigned long long)dst_lba);
-	pr_debug("target_xcopy_do_work: Blocks copied: %hu, Bytes Copied: %u\n",
-		copied_nolb, copied_nolb * dst_dev->dev_attrib.block_size);
+	pr_debug("%s: Blocks copied: %u, Bytes Copied: %u\n", __func__,
+		copied_bytes / dst_dev->dev_attrib.block_size, copied_bytes);
 
-	pr_debug("target_xcopy_do_work: Setting X-COPY GOOD status -> sending response\n");
+	pr_debug("%s: Setting X-COPY GOOD status -> sending response\n", __func__);
 	target_complete_cmd(ec_cmd, SAM_STAT_GOOD);
 	return;
 
@@ -776,8 +780,8 @@ static void target_xcopy_do_work(struct work_struct *work)
 
 err_free:
 	kfree(xop);
-	pr_warn_ratelimited("target_xcopy_do_work: rc: %d, sense: %u, XCOPY operation failed\n",
-			   rc, sense_rc);
+	pr_warn_ratelimited("%s: rc: %d, sense: %u, XCOPY operation failed\n",
+			   __func__, rc, sense_rc);
 	target_complete_cmd_with_sense(ec_cmd, SAM_STAT_CHECK_CONDITION, sense_rc);
 }
 
diff --git a/drivers/target/target_core_xcopy.h b/drivers/target/target_core_xcopy.h
index e5f20005179a..0aad7dc65895 100644
--- a/drivers/target/target_core_xcopy.h
+++ b/drivers/target/target_core_xcopy.h
@@ -5,7 +5,7 @@
 #define XCOPY_TARGET_DESC_LEN		32
 #define XCOPY_SEGMENT_DESC_LEN		28
 #define XCOPY_NAA_IEEE_REGEX_LEN	16
-#define XCOPY_MAX_SECTORS		4096
+#define XCOPY_MAX_BYTES			16777216 /* 16 MB */
 
 /*
  * SPC4r37 6.4.6.1
-- 
2.30.2

