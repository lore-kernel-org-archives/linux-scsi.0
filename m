Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87042C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B05461405
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 22:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhEMWjg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 18:39:36 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:54215 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbhEMWjZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 18:39:25 -0400
Received: by mail-pj1-f53.google.com with SMTP id p17so14289776pjz.3
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 15:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qmOu6yPUVAiTvr3F59u7miUtgTGmA7jI0Rn33W48iFc=;
        b=K8LxL1QNiEidk/LYCO1bPM7YrSNYObUg7QReioEJE2MN3GC2tTqmJNHs5cAI+Sd9Zw
         sMCvZC57J/pRf65q/nr6uFs1VLNM71aYul+9zAhLYRYxLS6lF6NqyHRnchHBnzQwEgOG
         ZH5W+0npuxlSKlIXNd8xKa9jDoLzUZI2vFKA0vzY9PyQLwChUen33QQ2G5it+mSzGNnx
         FIIQEVLwM3zy551RkVY5KiqAgfqId83t8XLrSWtqrIl9ebrzRlc7j07swF3CPwutEtit
         K148u51W2Z98V0dSaMLItUtgAVi6RDQfIcepHStbHQNTNcXKoWGU+pUAO9abVF/XxNL6
         lj6A==
X-Gm-Message-State: AOAM532bGR79bV12IkfR/4wxSzYfTmE/si/87shXnODh5/DKOoVFltPR
        /Gvru892oGov4r/5pkw/WtU=
X-Google-Smtp-Source: ABdhPJwnR90Cz57iKrYkodxmlfIvCfT7JGEav8hVx15wkJMDRSUmQ3XTZDBJW1rT1ya8VxBEODIv6g==
X-Received: by 2002:a17:90a:8902:: with SMTP id u2mr48474902pjn.143.1620945494663;
        Thu, 13 May 2021 15:38:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:54a8:4531:57a:cfd8])
        by smtp.gmail.com with ESMTPSA id j23sm2852582pfh.179.2021.05.13.15.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 15:38:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v3 7/8] ufs: Fix the tracing code
Date:   Thu, 13 May 2021 15:37:56 -0700
Message-Id: <20210513223757.3938-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513223757.3938-1-bvanassche@acm.org>
References: <20210513223757.3938-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_sector() instead of scsi_get_lba() since the name of the
latter is confusing. Use scsi_get_sector() for all SCSI requests since all
SCSI requests have a block layer request attached and hence calling
scsi_get_sector() is allowed. Convert the scsi_get_sector() result
from sector_t into an LBA with sectors_to_logical(). Since READ(10),
WRITE(10), READ(16) and WRITE(16) all have a GROUP NUMBER field, extract
the GROUP NUMBER field for all four SCSI commands. Apply the 0x3f mask to
that field since the upper two bits are reserved. Rename the 'transfer_len'
variable into 'affected_bytes' since it represents the number of bytes
affected on the storage medium instead of the size of the SCSI data buffer.

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
index ab707a2c3796..75310ac95b3d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -17,6 +17,8 @@
 #include <linux/blk-pm.h>
 #include <linux/blkdev.h>
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_cmnd.h>
+#include "../sd.h"
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
@@ -369,7 +371,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	u32 intr, doorbell;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct scsi_cmnd *cmd = lrbp->cmd;
-	int transfer_len = -1;
+	int affected_bytes = -1;
 
 	if (!trace_ufshcd_command_enabled()) {
 		/* trace UPIU W/O tracing command */
@@ -381,30 +383,24 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
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
+		lba = sectors_to_logical(cmd->device, scsi_get_sector(cmd));
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
index 599739ee7b20..71055021de91 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -268,10 +268,10 @@ DEFINE_EVENT(ufshcd_template, ufshcd_wl_runtime_resume,
 
 TRACE_EVENT(ufshcd_command,
 	TP_PROTO(const char *dev_name, enum ufs_trace_str_t str_t,
-		 unsigned int tag, u32 doorbell, int transfer_len, u32 intr,
+		 unsigned int tag, u32 doorbell, int affected_bytes, u32 intr,
 		 u64 lba, u8 opcode, u8 group_id),
 
-	TP_ARGS(dev_name, str_t, tag, doorbell, transfer_len,
+	TP_ARGS(dev_name, str_t, tag, doorbell, affected_bytes,
 				intr, lba, opcode, group_id),
 
 	TP_STRUCT__entry(
@@ -279,7 +279,7 @@ TRACE_EVENT(ufshcd_command,
 		__field(enum ufs_trace_str_t, str_t)
 		__field(unsigned int, tag)
 		__field(u32, doorbell)
-		__field(int, transfer_len)
+		__field(int, affected_bytes)
 		__field(u32, intr)
 		__field(u64, lba)
 		__field(u8, opcode)
@@ -291,7 +291,7 @@ TRACE_EVENT(ufshcd_command,
 		__entry->str_t = str_t;
 		__entry->tag = tag;
 		__entry->doorbell = doorbell;
-		__entry->transfer_len = transfer_len;
+		__entry->affected_bytes = affected_bytes;
 		__entry->intr = intr;
 		__entry->lba = lba;
 		__entry->opcode = opcode;
@@ -301,7 +301,7 @@ TRACE_EVENT(ufshcd_command,
 	TP_printk(
 		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x (%s), group_id: 0x%x",
 		show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
-		__entry->tag, __entry->doorbell, __entry->transfer_len,
+		__entry->tag, __entry->doorbell, __entry->affected_bytes,
 		__entry->intr, __entry->lba, (u32)__entry->opcode,
 		str_opcode(__entry->opcode), (u32)__entry->group_id
 	)
