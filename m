Return-Path: <SRS0=Icgp=EG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6832C55179
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 23:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BE0D208B6
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 23:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgJaXc0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Oct 2020 19:32:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:57544 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgJaXc0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 31 Oct 2020 19:32:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 54A6CB1B5;
        Sat, 31 Oct 2020 23:32:24 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, David Disseldorp <ddiss@suse.de>
Subject: [PATCH v4 4/4] scsi: target: return COMPARE AND WRITE miscompare offsets
Date:   Sun,  1 Nov 2020 00:32:11 +0100
Message-Id: <20201031233211.5207-5-ddiss@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201031233211.5207-1-ddiss@suse.de>
References: <20201031233211.5207-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SBC-4 r15 5.3 COMPARE AND WRITE command states:
  if the compare operation does not indicate a match, then terminate the
  command with CHECK CONDITION status with the sense key set to
  MISCOMPARE and the additional sense code set to MISCOMPARE DURING
  VERIFY OPERATION. In the sense data (see 4.18 and SPC-5) the offset
  from the start of the Data-Out Buffer to the first byte of data that
  was not equal shall be reported in the INFORMATION field.

This change implements the missing logic to report the miscompare offset
in the sense data INFORMATION field. As an optimization, byte-by-byte
miscompare offset calculation is only performed after memcmp() mismatch.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_sbc.c       | 35 ++++++++++++++++++--------
 drivers/target/target_core_transport.c |  1 +
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 22d0cbba6ff3..768c4878e0d3 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -435,13 +435,13 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 }
 
 /*
- * compare @cmp_len bytes of @read_sgl with @cmp_sgl. On miscompare return
- * TCM_MISCOMPARE_VERIFY.
+ * compare @cmp_len bytes of @read_sgl with @cmp_sgl. On miscompare, fill
+ * @miscmp_off and return TCM_MISCOMPARE_VERIFY.
  */
 static sense_reason_t
 compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 			 struct scatterlist *cmp_sgl, unsigned int cmp_nents,
-			 unsigned int cmp_len)
+			 unsigned int cmp_len, unsigned int *miscmp_off)
 {
 	unsigned char *buf = NULL;
 	struct scatterlist *sg;
@@ -466,18 +466,23 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 	 * Compare SCSI READ payload against verify payload
 	 */
 	offset = 0;
+	ret = TCM_NO_SENSE;
 	for_each_sg(read_sgl, sg, read_nents, i) {
 		unsigned int len = min(sg->length, cmp_len);
 		unsigned char *addr = kmap_atomic(sg_page(sg));
 
 		if (memcmp(addr, buf + offset, len)) {
-			pr_warn("Detected MISCOMPARE for addr: %p buf: %p\n",
-				addr, buf + offset);
-			kunmap_atomic(addr);
+			unsigned int i;
+			for (i = 0; i < len && addr[i] == buf[offset + i]; i++)
+				;
+			*miscmp_off = offset + i;
+			pr_warn("Detected MISCOMPARE at offset %u\n",
+				*miscmp_off);
 			ret = TCM_MISCOMPARE_VERIFY;
-			goto out;
 		}
 		kunmap_atomic(addr);
+		if (ret != TCM_NO_SENSE)
+			goto out;
 
 		offset += len;
 		cmp_len -= len;
@@ -485,7 +490,6 @@ compare_and_write_do_cmp(struct scatterlist *read_sgl, unsigned int read_nents,
 			break;
 	}
 	pr_debug("COMPARE AND WRITE read data matches compare data\n");
-	ret = TCM_NO_SENSE;
 out:
 	kfree(buf);
 	return ret;
@@ -501,6 +505,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	unsigned int len;
 	unsigned int block_size = dev->dev_attrib.block_size;
 	unsigned int compare_len = (cmd->t_task_nolb * block_size);
+	unsigned int miscmp_off = 0;
 	sense_reason_t ret = TCM_NO_SENSE;
 	int i;
 
@@ -532,8 +537,18 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 				       cmd->t_bidi_data_nents,
 				       cmd->t_data_sg,
 				       cmd->t_data_nents,
-				       compare_len);
-	if (ret)
+				       compare_len,
+				       &miscmp_off);
+	if (ret == TCM_MISCOMPARE_VERIFY) {
+		/*
+		 * SBC-4 r15: 5.3 COMPARE AND WRITE command
+		 * In the sense data (see 4.18 and SPC-5) the offset from the
+		 * start of the Data-Out Buffer to the first byte of data that
+		 * was not equal shall be reported in the INFORMATION field.
+		 */
+		cmd->sense_info = miscmp_off;
+		goto out;
+	} else if (ret)
 		goto out;
 
 	if (sg_alloc_table(&write_tbl, cmd->t_data_nents, GFP_KERNEL) < 0) {
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c6f45c12d564..693ed3fe4388 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3196,6 +3196,7 @@ static const struct sense_detail sense_detail_table[] = {
 		.key = MISCOMPARE,
 		.asc = 0x1d, /* MISCOMPARE DURING VERIFY OPERATION */
 		.ascq = 0x00,
+		.add_sense_info = true,
 	},
 	[TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED] = {
 		.key = ABORTED_COMMAND,
-- 
2.26.2

