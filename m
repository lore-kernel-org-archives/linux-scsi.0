Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1F5C433ED
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39974613C5
	for <linux-scsi@archiver.kernel.org>; Sun,  9 May 2021 21:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhEIVo2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 May 2021 17:44:28 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:34508 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhEIVo1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2021 17:44:27 -0400
Received: by mail-pf1-f175.google.com with SMTP id 10so12394366pfl.1
        for <linux-scsi@vger.kernel.org>; Sun, 09 May 2021 14:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OC22MMvqJy/P/6458EekJliNh+cqkEOFyYCS9onfExY=;
        b=DkSzu8Jed3OFbm/q4KxTlney+I33y+fLfn3KVQPL9DPeq2az/fSfLPD7si17qLtx3A
         JeLza6rH5IQlGtdFZMQ/E6ZOC9SWKTQNCTO9k4qFbWKoQAOLz1R/BSYj3n3QzXqtQ8SE
         Ifc6vFTkGw4/8VrbMdrtckENKQBf9pVN36h0Cn5ad9Fu2tlId7+mpB5hc3nWFc9DkGnW
         yYUPNKaROAENF0/N9r0ZoqvPvLbF1/fgKGcwiYJhacx2Fj+2hMT+IVgGRWYO4t5jvgcp
         fhRlrdajl6+MzQ7kR7Yd+97QvLadtX7N0fEC2WSitWlJ2plIAVMe3qPPd1uM4Xg87io0
         CHNA==
X-Gm-Message-State: AOAM533v/NnqEzAZg10Cd+V6SPvf/4N/EAmkdWy28AdP0n2pKSfNIPdH
        6TBNYqrt2r0HvX9TRQmlyyg=
X-Google-Smtp-Source: ABdhPJx0uVTqvzmGokgp8QdnT3LFJQEHnjOZUH1vl38dHVKp8v2ZYvPMN9JtLdmoA6PZu+gPEszdGg==
X-Received: by 2002:aa7:9992:0:b029:28e:b432:190a with SMTP id k18-20020aa799920000b029028eb432190amr21354446pfh.50.1620596603894;
        Sun, 09 May 2021 14:43:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:1f3e:222f:39bb:cb2e])
        by smtp.gmail.com with ESMTPSA id t4sm9712567pfq.165.2021.05.09.14.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 14:43:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Lee Susman <lsusman@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Can Guo <cang@codeaurora.org>
Subject: [PATCH 6/7] ufs: Fix the tracing code
Date:   Sun,  9 May 2021 14:43:06 -0700
Message-Id: <20210509214307.4610-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509214307.4610-1-bvanassche@acm.org>
References: <20210509214307.4610-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_get_pos() instead of scsi_get_lba() since the name of the latter
is confusing. Use scsi_get_pos() for all SCSI requests since all SCSI
requests have a block layer request attached and hence calling
scsi_get_pos() is allowed. Convert the scsi_get_pos() result from sector_t
into an LBA with sectors_to_logical(). Since both READ(10) and WRITE(10)
have a GROUP NUMBER field, extract the GROUP NUMBER field for both types of
commands. Apply the 0x3f mask to that field since the upper two bits are
reserved. Rename the 'transfer_len' variable into 'affected_bytes' since it
represents the number of bytes affected on the storage medium instead of
the size of the SCSI data buffer.

Cc: Lee Susman <lsusman@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c  | 20 +++++++-------------
 include/trace/events/ufs.h | 10 +++++-----
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0625da7a42ee..63de6b8a2e26 100644
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
@@ -378,30 +380,22 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	if (cmd) { /* data phase exists */
 		/* trace UPIU also */
 		ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
+		lba = sectors_to_logical(cmd->device, scsi_get_pos(cmd));
+		affected_bytes = blk_rq_bytes(cmd->request);
 		opcode = cmd->cmnd[0];
 		if ((opcode == READ_10) || (opcode == WRITE_10)) {
 			/*
 			 * Currently we only fully trace read(10) and write(10)
 			 * commands
 			 */
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
+			group_id = lrbp->cmd->cmnd[6] & 0x3f;
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
