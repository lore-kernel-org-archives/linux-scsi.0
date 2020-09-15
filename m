Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C99FC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32D3E20771
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600202875;
	bh=py0H0Nt71dgZGsc2v1e3bd1BFG4ko+PaI/MDzo15VX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hcmOyDtQrXsZphyP/QSuBWIMQggU/2Ud0Da1JB306HSIxPVu/nG2x9ea46FgQcNaB
	 K2iYZX7WUJ2/re8+6hTR08S52ymNI/ZGxOr75I4wJ05tlZt+pPjF6DCI9AaG+EJ1y7
	 LHKJX26uVMzV7FDhjeBAv53C2MzxLs0+BkJK0FG8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgIOUrM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 16:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbgIOUqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 16:46:47 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1568B21655;
        Tue, 15 Sep 2020 20:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600202799;
        bh=py0H0Nt71dgZGsc2v1e3bd1BFG4ko+PaI/MDzo15VX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1czTBxu7slicrVo5h3XqzbXp8mbMy9GTa1qHc9jxpAIJIPZ9ckStu39gMC+XCgi9o
         DELYRBCUSy72rVgzXkSrC4+BAPiimCK4S6Qb5ffIrGqh3n+1MDADJ2lEkAcRuoEasy
         z+RarUd0ilF6LghxOI7gFv3DyIhLbwlVNKVqlkMs=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 6/6] scsi: add more contexts in the ufs tracepoints
Date:   Tue, 15 Sep 2020 13:45:32 -0700
Message-Id: <20200915204532.1672300-6-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200915204532.1672300-1-jaegeuk@kernel.org>
References: <20200915204532.1672300-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

This adds user-friendly tracepoints with group id.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufshcd.c  |  6 ++++--
 include/trace/events/ufs.h | 21 +++++++++++++++++----
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b81c116b976ff..d70ca62c4c6d0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -336,7 +336,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba,
 		unsigned int tag, const char *str)
 {
 	sector_t lba = -1;
-	u8 opcode = 0;
+	u8 opcode = 0, group_id = 0;
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct scsi_cmnd *cmd = lrbp->cmd;
@@ -362,13 +362,15 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba,
 				lba = cmd->request->bio->bi_iter.bi_sector;
 			transfer_len = be32_to_cpu(
 				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
+			if (opcode == WRITE_10)
+				group_id = lrbp->cmd->cmnd[6];
 		}
 	}
 
 	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	trace_ufshcd_command(dev_name(hba->dev), str, tag,
-				doorbell, transfer_len, intr, lba, opcode);
+			doorbell, transfer_len, intr, lba, opcode, group_id);
 }
 
 static void ufshcd_print_clk_freqs(struct ufs_hba *hba)
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index 84841b3a7ffd5..50654f3526392 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -11,6 +11,15 @@
 
 #include <linux/tracepoint.h>
 
+#define str_opcode(opcode)						\
+	__print_symbolic(opcode,					\
+		{ WRITE_16,		"WRITE_16" },			\
+		{ WRITE_10,		"WRITE_10" },			\
+		{ READ_16,		"READ_16" },			\
+		{ READ_10,		"READ_10" },			\
+		{ SYNCHRONIZE_CACHE,	"SYNC" },			\
+		{ UNMAP,		"UNMAP" })
+
 #define UFS_LINK_STATES			\
 	EM(UIC_LINK_OFF_STATE)		\
 	EM(UIC_LINK_ACTIVE_STATE)	\
@@ -215,9 +224,10 @@ DEFINE_EVENT(ufshcd_template, ufshcd_init,
 TRACE_EVENT(ufshcd_command,
 	TP_PROTO(const char *dev_name, const char *str, unsigned int tag,
 			u32 doorbell, int transfer_len, u32 intr, u64 lba,
-			u8 opcode),
+			u8 opcode, u8 group_id),
 
-	TP_ARGS(dev_name, str, tag, doorbell, transfer_len, intr, lba, opcode),
+	TP_ARGS(dev_name, str, tag, doorbell, transfer_len,
+				intr, lba, opcode, group_id),
 
 	TP_STRUCT__entry(
 		__string(dev_name, dev_name)
@@ -228,6 +238,7 @@ TRACE_EVENT(ufshcd_command,
 		__field(u32, intr)
 		__field(u64, lba)
 		__field(u8, opcode)
+		__field(u8, group_id)
 	),
 
 	TP_fast_assign(
@@ -239,13 +250,15 @@ TRACE_EVENT(ufshcd_command,
 		__entry->intr = intr;
 		__entry->lba = lba;
 		__entry->opcode = opcode;
+		__entry->group_id = group_id;
 	),
 
 	TP_printk(
-		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x",
+		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x (%s), group_id: 0x%x",
 		__get_str(str), __get_str(dev_name), __entry->tag,
 		__entry->doorbell, __entry->transfer_len,
-		__entry->intr, __entry->lba, (u32)__entry->opcode
+		__entry->intr, __entry->lba, (u32)__entry->opcode,
+		str_opcode(__entry->opcode), (u32)__entry->group_id
 	)
 );
 
-- 
2.28.0.618.gf4bc123cb7-goog

