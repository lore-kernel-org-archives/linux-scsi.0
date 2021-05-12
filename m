Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEB4C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7181C61288
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345098AbhELVX0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 17:23:26 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:44961 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385607AbhELUKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 16:10:15 -0400
Received: by mail-pl1-f172.google.com with SMTP id b3so13106944plg.11
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 13:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AQIzDB1rBiJtJ7DexFD1p1hImAD8B5fsMZyCH6p6lds=;
        b=JkmaFny3euNugAgBZPhTHIkDql/PxLidw9+i8PHO7S1kS4IUmRpm7+y6pf/+CLTJ+9
         G9SiomOIcKi/ehEXXKyCfqSoxmcH1uCIV9DmaMzJI04GMh6fv8gL2/lxt1f1rFf/YmXP
         h29R/e0xCDe1rZnlwKRun7Za9FAKLp8q6EzgDUiqbLdKX1gtwjKRFpWb2rNX3mjVysk8
         hm6Ucb4SrRObG1uImlGrnf/DeUxrFDHaRxK8PfaZj6wCL57haA+L4Qnz6zLW9yf3cu91
         hOA2GWg07Fy8UQgpYqvVZ38SI2E+RKG1DanIkbAMpZ5AXN7evAhbQ0Qm2qOcW1P6VjlR
         MyTA==
X-Gm-Message-State: AOAM533aSuPkfYvG6Zb1JPG/IfIDCQXV0uubdMFsA5fiWP2r1qm8UZNs
        ZWO4rDOPU41anyV6dhbGBOY=
X-Google-Smtp-Source: ABdhPJx4D/AK+2Emlox9e9n9pBBZvjl91OJ3Gtd00xp8KK+7KZp+jzclEULNUGjsdG4sLnhrZN6BCA==
X-Received: by 2002:a17:902:ce8c:b029:ef:212e:edcb with SMTP id f12-20020a170902ce8cb02900ef212eedcbmr26613351plg.67.1620850146782;
        Wed, 12 May 2021 13:09:06 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:993e:1516:b2ba:76fe])
        by smtp.gmail.com with ESMTPSA id l21sm513948pfc.114.2021.05.12.13.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:09:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 6/7] ufs: Fix the tracing code
Date:   Wed, 12 May 2021 13:08:48 -0700
Message-Id: <20210512200849.9002-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512200849.9002-1-bvanassche@acm.org>
References: <20210512200849.9002-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_pos() instead of scsi_get_lba() since the name of the latter
is confusing. Use scsi_get_pos() for all SCSI requests since all SCSI
requests have a block layer request attached and hence calling
scsi_get_pos() is allowed. Convert the scsi_get_pos() result from sector_t
into an LBA with sectors_to_logical(). Since READ(10), WRITE(10), READ(16)
and WRITE(16) all have a GROUP NUMBER field, extract the GROUP NUMBER field
for all four SCSI commands. Apply the 0x3f mask to that field since the
upper two bits are reserved. Rename the 'transfer_len' variable into
'affected_bytes' since it represents the number of bytes affected on the
storage medium instead of the size of the SCSI data buffer.

Cc: Can Guo <cang@codeaurora.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c  | 34 +++++++++++++++-------------------
 include/trace/events/ufs.h | 10 +++++-----
 2 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0625da7a42ee..4f6b0e28735f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -16,6 +16,8 @@
 #include <linux/bitfield.h>
 #include <linux/blk-pm.h>
 #include <linux/blkdev.h>
+#include <scsi/scsi_cmnd.h>
+#include "../sd.h"
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
@@ -366,7 +368,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct scsi_cmnd *cmd = lrbp->cmd;
-	int transfer_len = -1;
+	int affected_bytes = -1;
 
 	if (!trace_ufshcd_command_enabled()) {
 		/* trace UPIU W/O tracing command */
@@ -378,30 +380,24 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	if (cmd) { /* data phase exists */
 		/* trace UPIU also */
 		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
-		opcode = cmd->cmnd[0];
-		if ((opcode == READ_10) || (opcode == WRITE_10)) {
-			/*
-			 * Currently we only fully trace read(10) and write(10)
-			 * commands
-			 */
-			if (cmd->request && cmd->request->bio)
-				lba = cmd->request->bio->bi_iter.bi_sector;
-			transfer_len = be32_to_cpu(
-				lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
-			if (opcode == WRITE_10)
-				group_id = lrbp->cmd->cmnd[6];
-		} else if (opcode == UNMAP) {
-			if (cmd->request) {
-				lba = scsi_get_lba(cmd);
-				transfer_len = blk_rq_bytes(cmd->request);
-			}
+		lba = sectors_to_logical(cmd->device, scsi_get_pos(cmd));
+		affected_bytes = blk_rq_bytes(cmd->request);
+		switch (cmd->cmnd[0]) {
+		case READ_10:
+		case WRITE_10:
+			group_id = lrbp->cmd->cmnd[6] & 0x3f;
+			break;
+		case READ_16:
+		case WRITE_16:
+			group_id = lrbp->cmd->cmnd[14] & 0x3f;
+			break;
 		}
 	}
 
 	intr = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	trace_ufshcd_command(dev_name(hba->dev), str_t, tag,
-			doorbell, transfer_len, intr, lba, opcode, group_id);
+			doorbell, affected_bytes, intr, lba, opcode, group_id);
 }
 
 static void ufshcd_print_clk_freqs(struct ufs_hba *hba)
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index 1cb6f1afba0e..b36df5b20ad1 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -248,10 +248,10 @@ DEFINE_EVENT(ufshcd_template, ufshcd_init,
 
 TRACE_EVENT(ufshcd_command,
 	TP_PROTO(const char *dev_name, enum ufs_trace_str_t str_t,
-		 unsigned int tag, u32 doorbell, int transfer_len, u32 intr,
+		 unsigned int tag, u32 doorbell, int affected_bytes, u32 intr,
 		 u64 lba, u8 opcode, u8 group_id),
 
-	TP_ARGS(dev_name, str_t, tag, doorbell, transfer_len,
+	TP_ARGS(dev_name, str_t, tag, doorbell, affected_bytes,
 				intr, lba, opcode, group_id),
 
 	TP_STRUCT__entry(
@@ -259,7 +259,7 @@ TRACE_EVENT(ufshcd_command,
 		__field(enum ufs_trace_str_t, str_t)
 		__field(unsigned int, tag)
 		__field(u32, doorbell)
-		__field(int, transfer_len)
+		__field(int, affected_bytes)
 		__field(u32, intr)
 		__field(u64, lba)
 		__field(u8, opcode)
@@ -271,7 +271,7 @@ TRACE_EVENT(ufshcd_command,
 		__entry->str_t = str_t;
 		__entry->tag = tag;
 		__entry->doorbell = doorbell;
-		__entry->transfer_len = transfer_len;
+		__entry->affected_bytes = affected_bytes;
 		__entry->intr = intr;
 		__entry->lba = lba;
 		__entry->opcode = opcode;
@@ -281,7 +281,7 @@ TRACE_EVENT(ufshcd_command,
 	TP_printk(
 		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x (%s), group_id: 0x%x",
 		show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
-		__entry->tag, __entry->doorbell, __entry->transfer_len,
+		__entry->tag, __entry->doorbell, __entry->affected_bytes,
 		__entry->intr, __entry->lba, (u32)__entry->opcode,
 		str_opcode(__entry->opcode), (u32)__entry->group_id
 	)
