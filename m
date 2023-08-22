Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D13EE49AE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 19:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjHVTUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjHVTUR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 15:20:17 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3704E47;
        Tue, 22 Aug 2023 12:20:13 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-56c250ff3d3so1770394a12.1;
        Tue, 22 Aug 2023 12:20:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692732013; x=1693336813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7we6QROJmCV/8TDowAkj10fIMIa6vF9cLXAVjoPLfg=;
        b=AiAEHg0JOa335VjGS5sb3ygg/lz8qVXvqWarpQSZlF9ytpHLrTOeQeKcXEAtvjculG
         0ed5qeXfBPXYsQdnNdZezp2B24uEgVYEgFtkJREZtwLFW4JCoG8Fh70af22rMW5AOEB4
         miMlmB60DKQ1sG/ysZCRebHw45y+37ulq4mwL4OOyWwDH48Z/a1t7WrZxdHBYMP2X1qf
         0X0px1z69iml7K+AGqqvEljaxJfHMf9J4tUEYhBve2HrAHjcD70kjwofV28YJ62L6KKj
         RsWp2BN/VcuJ2LfaOgTZ+d0tvFMiXpHhWSFsLUf/eqrO6QyH7RQfKqsM6DtVX4tu7L0S
         OmmQ==
X-Gm-Message-State: AOJu0YzqVsa1R0ckbyHGJazGe1aMSfT9fKuffme5Ls4zMbDdrfyzWXuo
        rZC3qMixi6kGDte/i1f9Wi4=
X-Google-Smtp-Source: AGHT+IG52W/qHjA28sRpb5Sk+prL6Zjt6oJtfk9HOW9Pf2eoDLJnRaati81bpfu92hIp8it42zbJuw==
X-Received: by 2002:a17:90a:d392:b0:269:3757:54bb with SMTP id q18-20020a17090ad39200b00269375754bbmr14923755pju.11.1692732013040;
        Tue, 22 Aug 2023 12:20:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a414b00b002696bd123e4sm8081632pjg.46.2023.08.22.12.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:20:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v11 16/16] scsi: ufs: Inform the block layer about write ordering
Date:   Tue, 22 Aug 2023 12:17:11 -0700
Message-ID: <20230822191822.337080-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230822191822.337080-1-bvanassche@acm.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From the UFSHCI 4.0 specification, about the legacy (single queue) mode:
"The host controller always process transfer requests in-order according
to the order submitted to the list. In case of multiple commands with
single doorbell register ringing (batch mode), The dispatch order for
these transfer requests by host controller will base on their index in
the List. A transfer request with lower index value will be executed
before a transfer request with higher index value."

From the UFSHCI 4.0 specification, about the MCQ mode:
"Command Submission
1. Host SW writes an Entry to SQ
2. Host SW updates SQ doorbell tail pointer

Command Processing
3. After fetching the Entry, Host Controller updates SQ doorbell head
   pointer
4. Host controller sends COMMAND UPIU to UFS device"

In other words, for both legacy and MCQ mode, UFS controllers are
required to forward commands to the UFS device in the order these
commands have been received from the host.

Notes:
- For legacy mode this is only correct if the host submits one
  command at a time. The UFS driver does this.
- Also in legacy mode, the command order is not preserved if
  auto-hibernation is enabled in the UFS controller. Hence, enable
  zone write locking if auto-hibernation is enabled.

This patch improves performance as follows on my test setup:
- With the mq-deadline scheduler: 2.5x more IOPS for small writes.
- When not using an I/O scheduler compared to using mq-deadline with
  zone locking: 4x more IOPS for small writes.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c28a362b5b99..a685058d4943 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4357,6 +4357,19 @@ static int ufshcd_update_preserves_write_order(struct ufs_hba *hba,
 				return -EPERM;
 		}
 	}
+	shost_for_each_device(sdev, hba->host)
+		blk_freeze_queue_start(sdev->request_queue);
+	shost_for_each_device(sdev, hba->host) {
+		struct request_queue *q = sdev->request_queue;
+
+		blk_mq_freeze_queue_wait(q);
+		q->limits.driver_preserves_write_order = preserves_write_order;
+		blk_queue_required_elevator_features(q,
+			preserves_write_order ? 0 : ELEVATOR_F_ZBD_SEQ_WRITE);
+		if (q->disk)
+			disk_set_zoned(q->disk, q->limits.zoned);
+		blk_mq_unfreeze_queue(q);
+	}
 
 	return 0;
 }
@@ -4397,7 +4410,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 
 	if (!is_mcq_enabled(hba) && !prev_state && new_state) {
 		/*
-		 * Auto-hibernation will be enabled for legacy UFSHCI mode.
+		 * Auto-hibernation will be enabled for legacy UFSHCI mode. Tell
+		 * the block layer that write requests may be reordered.
 		 */
 		ret = ufshcd_update_preserves_write_order(hba, false);
 		if (ret)
@@ -4413,7 +4427,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	}
 	if (!is_mcq_enabled(hba) && prev_state && !new_state) {
 		/*
-		 * Auto-hibernation has been disabled.
+		 * Auto-hibernation has been disabled. Tell the block layer that
+		 * the order of write requests is preserved.
 		 */
 		ret = ufshcd_update_preserves_write_order(hba, true);
 		WARN_ON_ONCE(ret);
@@ -5191,6 +5206,9 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	ufshcd_hpb_configure(hba, sdev);
 
+	q->limits.driver_preserves_write_order =
+		!ufshcd_is_auto_hibern8_supported(hba) ||
+		FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) == 0;
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
 		blk_queue_update_dma_alignment(q, SZ_4K - 1);
