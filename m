Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B62FC7EE23
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 22:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjEaWkH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 18:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjEaWkG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 18:40:06 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69723B3
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 15:40:05 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1b065154b79so11810405ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 15:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685572805; x=1688164805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XVTK8PPoBEk/h26NU2XNcUDwLD3TNYhA7a8+wLG7g3s=;
        b=azPzrda7l/cgg2o6YDvXxrgyx62gkk/qoqRInIZtuQ85cK72qQahjoCjOHkKsdx01S
         QNS6K+UUcXx9u8KYNE4bQVzQ1Og4yK6fTha5xyERINVkRm5ju8CldQGWZxoUt8LXQS8W
         QgQAKhwnT8M1ZDxcj4j/knogOaw8L+VTXgBf5ORxBq9cnsE42fVaDu7Fqq4vgvIHwr0M
         gcmqdK/80Y2T+o7JIAOOgtbX//9pwBYgvPqbsr67Du7CVCf6Ketri5/fLSBcGSTjBzyr
         Cx71i6cck6lfbZ9AQzZDTzGkVmGZ7zMcu1LI7pYeLFlbCD161+mDHubmkGBLM7+6VfgB
         CFGA==
X-Gm-Message-State: AC+VfDzJBdPAKkQwdn+tSW/aSaHzSj07FfJKhAjQpZ94WkRLm+7ECFzv
        wakTPy5CvspMhUt8dCCJ7i8=
X-Google-Smtp-Source: ACHHUZ7xMvzTs53R/G8pevclTjVLRQ5sT/qPMvecHC64LIpYf2bOa9Dw2adf9FhN21rGGdtI9I5HZw==
X-Received: by 2002:a17:902:864b:b0:1af:ea40:34f2 with SMTP id y11-20020a170902864b00b001afea4034f2mr6926444plt.11.1685572804744;
        Wed, 31 May 2023 15:40:04 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902dac700b001b0499bee11sm1899518plx.240.2023.05.31.15.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 15:40:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Subject: [PATCH] scsi: ufs: Include major and minor number in command tracing output
Date:   Wed, 31 May 2023 15:39:20 -0700
Message-Id: <20230531223924.25341-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS devices are typically configured with multiple logical units.
The device name, e.g. 13200000.ufs, does not include logical unit
information. Hence this patch that replaces the device name with
the disk major and minor number in the tracing output, e.g. 8,0,
just like the block layer tracing information.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c  |  4 ++--
 include/trace/events/ufs.h | 16 ++++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1f7a4ec211ff..6c84ad9c91d0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -450,8 +450,8 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
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
index 992517ac3292..c66259eb766b 100644
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
+	TP_ARGS(sdev, str_t, tag, doorbell, hwq_id, transfer_len,
 			intr, lba, opcode, group_id),
 
 	TP_STRUCT__entry(
-		__string(dev_name, dev_name)
+		__field(dev_t, dev)
 		__field(enum ufs_trace_str_t, str_t)
 		__field(unsigned int, tag)
 		__field(u32, doorbell)
@@ -288,7 +288,10 @@ TRACE_EVENT(ufshcd_command,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
+		/* 'disk' is cleared by sd_remove(). */
+		struct gendisk *disk = sdev->request_queue->disk;
+
+		__entry->dev = disk ? disk_devt(disk) : 0;
 		__entry->str_t = str_t;
 		__entry->tag = tag;
 		__entry->doorbell = doorbell;
@@ -301,8 +304,9 @@ TRACE_EVENT(ufshcd_command,
 	),
 
 	TP_printk(
-		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x (%s), group_id: 0x%x, hwq_id: %d",
-		show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
+		"%s: %d,%d: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x (%s), group_id: 0x%x, hwq_id: %d",
+		show_ufs_cmd_trace_str(__entry->str_t),
+		MAJOR(__entry->dev), MINOR(__entry->dev),
 		__entry->tag, __entry->doorbell, __entry->transfer_len, __entry->intr,
 		__entry->lba, (u32)__entry->opcode, str_opcode(__entry->opcode),
 		(u32)__entry->group_id, __entry->hwq_id
