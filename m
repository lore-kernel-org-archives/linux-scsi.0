Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB18EC874D
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Sep 2023 18:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343669AbjIGSiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Sep 2023 14:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243739AbjIGSiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2023 14:38:02 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A64C4
        for <linux-scsi@vger.kernel.org>; Thu,  7 Sep 2023 11:37:58 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1c336f3f449so10930325ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 07 Sep 2023 11:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694111878; x=1694716678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AKfObFuO7vix8gOWH8/IfkTtwI2zmBZaAUJ35DytlVQ=;
        b=M2YHq1qti8zcRdtbjnPcAB3YgLWemYLdeI/opbswdu3gFoFfICXaPDsBFcQ46Q/XTz
         FPlY0GbEiAxBfJqE2jedmdRFZ+zjpua4f4SpT2WARGln24kw9Gp6Q9sYFep5CD/OhhYT
         HL/ChoiIKl3KmYQCvQQGFxAn5IMRtnXfsRoUCQTYC5wjk3M5ToAwgxcumRN+sHlfUGJ1
         isvgQdZXVCidBoNXBZdONVUjltSDkQoAOUMihuAJUfsdjcB4TSIfeWjm2kS+X76mGsfx
         +S0W0+LuiwRGR7pfSwwkfs5qUtyUgGeoKi81aqG7t487qSvZG0yrWZxXutgluh9d+4LQ
         IQLw==
X-Gm-Message-State: AOJu0YwUkvFn19CFUEAcMxKKY968lN/ak1NvyRXsBq/na+nIqyfgeegH
        gXwMqEgb76WSrjRG/x4+LYk=
X-Google-Smtp-Source: AGHT+IF5293T0zYReioS+iej2f95JeG0h3DEwSMBzI92vVWm0vy+GGBEr3vntHrUzSxV7hr319z0Kg==
X-Received: by 2002:a17:902:da8e:b0:1bd:a22a:d406 with SMTP id j14-20020a170902da8e00b001bda22ad406mr459531plx.21.1694111877860;
        Thu, 07 Sep 2023 11:37:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3e0c:134b:bf18:e493])
        by smtp.gmail.com with ESMTPSA id x12-20020a1709028ecc00b001b9dadf8bd2sm76397plo.190.2023.09.07.11.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 11:37:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH v2] scsi: ufs: Include the SCSI ID in UFS command tracing output
Date:   Thu,  7 Sep 2023 11:37:16 -0700
Message-ID: <20230907183739.905938-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The logical unit information is missing from the UFS command tracing
output. Although the device name is logged, e.g. 13200000.ufs, this
name does not include logical unit information. Hence this patch that
replaces the device name with the SCSI ID in the tracing output. An
example of tracing output with this patch applied:

    kworker/8:0H-80      [008] .....    89.106063: ufshcd_command: send_req: 0:0:0:4: tag: 10, DB: 0x7ffffbff, size: 524288, IS: 0, LBA: 1085538, opcode: 0x8a (WRITE_16), group_id: 0x0
              dd-4225    [000] d.h..    89.106219: ufshcd_command: complete_rsp: 0:0:0:4: tag: 11, DB: 0x7ffff7ff, size: 524288, IS: 0, LBA: 1081728, opcode: 0x8a (WRITE_16), group_id: 0x0

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c  |  4 ++--
 include/trace/events/ufs.h | 15 ++++++++-------
 2 files changed, 10 insertions(+), 9 deletions(-)

Changes compared to v1 (see also
https://lore.kernel.org/linux-scsi/20230706215124.4113546-1-bvanassche@acm.org/):
replaced major and minor numbers with the SCSI ID.

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2df07545f96..bb3f100276c5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -447,8 +447,8 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	} else {
 		doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	}
-	trace_ufshcd_command(dev_name(hba->dev), str_t, tag,
-			doorbell, hwq_id, transfer_len, intr, lba, opcode, group_id);
+	trace_ufshcd_command(cmd->device, str_t, tag, doorbell, hwq_id,
+			     transfer_len, intr, lba, opcode, group_id);
 }
 
 static void ufshcd_print_clk_freqs(struct ufs_hba *hba)
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index 992517ac3292..b930669bd1f0 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -267,15 +267,15 @@ DEFINE_EVENT(ufshcd_template, ufshcd_wl_runtime_resume,
 	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
 
 TRACE_EVENT(ufshcd_command,
-	TP_PROTO(const char *dev_name, enum ufs_trace_str_t str_t,
+	TP_PROTO(struct scsi_device *sdev, enum ufs_trace_str_t str_t,
 		 unsigned int tag, u32 doorbell, u32 hwq_id, int transfer_len,
 		 u32 intr, u64 lba, u8 opcode, u8 group_id),
 
-	TP_ARGS(dev_name, str_t, tag, doorbell, hwq_id, transfer_len,
-			intr, lba, opcode, group_id),
+	TP_ARGS(sdev, str_t, tag, doorbell, hwq_id, transfer_len, intr, lba,
+		opcode, group_id),
 
 	TP_STRUCT__entry(
-		__string(dev_name, dev_name)
+		__field(struct scsi_device *, sdev)
 		__field(enum ufs_trace_str_t, str_t)
 		__field(unsigned int, tag)
 		__field(u32, doorbell)
@@ -288,7 +288,7 @@ TRACE_EVENT(ufshcd_command,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
+		__entry->sdev = sdev;
 		__entry->str_t = str_t;
 		__entry->tag = tag;
 		__entry->doorbell = doorbell;
@@ -302,8 +302,9 @@ TRACE_EVENT(ufshcd_command,
 
 	TP_printk(
 		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x (%s), group_id: 0x%x, hwq_id: %d",
-		show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
-		__entry->tag, __entry->doorbell, __entry->transfer_len, __entry->intr,
+		show_ufs_cmd_trace_str(__entry->str_t),
+		dev_name(&__entry->sdev->sdev_dev), __entry->tag,
+		__entry->doorbell, __entry->transfer_len, __entry->intr,
 		__entry->lba, (u32)__entry->opcode, str_opcode(__entry->opcode),
 		(u32)__entry->group_id, __entry->hwq_id
 	)
