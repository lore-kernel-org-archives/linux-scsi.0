Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9AEEB64D9
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 21:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjGFVvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jul 2023 17:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjGFVv3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2023 17:51:29 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2790E1BEE
        for <linux-scsi@vger.kernel.org>; Thu,  6 Jul 2023 14:51:29 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-668704a5b5bso963129b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 06 Jul 2023 14:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688680288; x=1691272288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tSX4AJCd7bzCOxjrdyDG76/rEH/Uo0IAJpML52tqR0w=;
        b=T8WGVAfUmlGW94l47rmqByKJNu7YceWiPmLk3BRSCis6bV78aZJD9EhvuRh1jmEDkA
         jlN1G1tzqs1EkcZQICg9pTjlkAVGt5eUFFQYojAs1vFVj+VXy46nq3jO0aPP1+ew3vY6
         cZJN5BI8rpnurHlJFotWJzkwRQySYtXzMV1CB8Xrqhsp1NQa3kO9vmusOd7zfCZXxiHd
         UpASxWwzLTlAXiODDfSxJn39AK+7XgZwKg1Hal8S8p/NgqrxziZyinwKMx+YSNSZ1Vrk
         0/7K2ckylAM5XjnRYZwiSSxc+Wn6yOzQCmT8guhe8RAyBi1m0cMmepABsT5+kCEXBC9n
         VcWQ==
X-Gm-Message-State: ABy/qLbdknrzvIxgIKchc1DnxSh5t5Hlv872zpNtot7Mx0jUJe+9otlx
        2q3p4Hv8lysHJKWJ1I1UGB8=
X-Google-Smtp-Source: APBJJlEYL1CD2ya18ExuHTEYhS3fu1gRYzLM/nHdOFnwKhFzAW22PZkVi3by58mQp+8CrynsraPO6A==
X-Received: by 2002:a05:6a20:1584:b0:12c:763b:f099 with SMTP id h4-20020a056a20158400b0012c763bf099mr3676932pzj.58.1688680288465;
        Thu, 06 Jul 2023 14:51:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a75c:9545:5328:a233])
        by smtp.gmail.com with ESMTPSA id v12-20020a62a50c000000b00640f51801e6sm1680551pfm.159.2023.07.06.14.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 14:51:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>
Subject: [PATCH] scsi: ufs: Include major and minor number in UFS command tracing output
Date:   Thu,  6 Jul 2023 14:51:04 -0700
Message-ID: <20230706215124.4113546-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The logical unit information is missing from the UFS command tracing
output. Although the device name is logged, e.g. 13200000.ufs, this
name does not include logical unit information. Hence this patch that
replaces the device name with the disk major and minor number in the
tracing output, e.g. 8,0, just like the block layer tracing information.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c  |  2 +-
 include/trace/events/ufs.h | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 384537511c7e..4169f840ac66 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -448,7 +448,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	} else {
 		doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	}
-	trace_ufshcd_command(dev_name(hba->dev), str_t, tag,
+	trace_ufshcd_command(cmd->device, str_t, tag,
 			doorbell, hwq_id, transfer_len, intr, lba, opcode, group_id);
 }
 
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index 992517ac3292..ac835313fb11 100644
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
@@ -288,7 +288,7 @@ TRACE_EVENT(ufshcd_command,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
+		__entry->dev = disk_devt(sdev->request_queue->disk);
 		__entry->str_t = str_t;
 		__entry->tag = tag;
 		__entry->doorbell = doorbell;
@@ -301,8 +301,9 @@ TRACE_EVENT(ufshcd_command,
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
