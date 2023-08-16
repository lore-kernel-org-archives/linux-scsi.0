Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7FCC25B5F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345967AbjHPT5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345990AbjHPT5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:57:07 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC4130C7;
        Wed, 16 Aug 2023 12:56:35 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-68934672e7bso194133b3a.2;
        Wed, 16 Aug 2023 12:56:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215795; x=1692820595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bkMQyPixpqYPRVAjDEtNvAJQ2OgvR1IbHljjNClfrjQ=;
        b=jmFrcXYHFRXhaXpob4ZjF2B4sMZ/gV52zXMsQDMstl+kqidTtuVX6zfPmw+06jKMHL
         8qSZkroM6y45H1H76sYx/9gpoNjAzVH82sSJOmprP5nncZkoH+H5I8gBWpDQ/wVwfvVy
         a9tQk0JsD12mRvQY5rtyIHW6Ns1y3CHEQ/e2roJYafgjC2xv8ipELxaLKSh19mMzEY15
         GbtYVeLG3rgBzhVO5DDea5fpN3JZSQCdqumlo+ciHHGTTsBMblO//V2qxjUMdgKf8Rom
         TDT9jpSqleydmvQkZiy44BRNjtu3oo8dDxpvbktCjRUXUclVsjcZN0ezUXK4v/pBVRIg
         Cbhg==
X-Gm-Message-State: AOJu0YxIBvXemW+H+4qu/o4ks70slN1XFjIvFv6BUq1uoieVOv8GU5Xw
        eilIZp+3Z5Auzrq3P0bWprg=
X-Google-Smtp-Source: AGHT+IHSRHvlPvP82XvRMrHHSIS85wJqkYv98PSKADamhZgYPMvI1th7udQmPDbE0/RJWh5YYGTHWg==
X-Received: by 2002:a05:6a21:601:b0:140:2805:6cce with SMTP id ll1-20020a056a21060100b0014028056ccemr2802133pzb.19.1692215795049;
        Wed, 16 Aug 2023 12:56:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:56:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v9 17/17] scsi: ufs: Inform the block layer about write ordering
Date:   Wed, 16 Aug 2023 12:53:29 -0700
Message-ID: <20230816195447.3703954-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
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

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 37d430d20939..7f5049a66cca 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4356,6 +4356,19 @@ static int ufshcd_update_preserves_write_order(struct ufs_hba *hba,
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
@@ -4393,7 +4406,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 
 	if (!is_mcq_enabled(hba) && !prev_state && new_state) {
 		/*
-		 * Auto-hibernation will be enabled for legacy UFSHCI mode.
+		 * Auto-hibernation will be enabled for legacy UFSHCI mode. Tell
+		 * the block layer that write requests may be reordered.
 		 */
 		ret = ufshcd_update_preserves_write_order(hba, false);
 		if (ret)
@@ -4409,7 +4423,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	}
 	if (!is_mcq_enabled(hba) && prev_state && !new_state) {
 		/*
-		 * Auto-hibernation has been disabled.
+		 * Auto-hibernation has been disabled. Tell the block layer that
+		 * the order of write requests is preserved.
 		 */
 		ret = ufshcd_update_preserves_write_order(hba, true);
 		WARN_ON_ONCE(ret);
@@ -5187,6 +5202,9 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	ufshcd_hpb_configure(hba, sdev);
 
+	q->limits.driver_preserves_write_order =
+		!ufshcd_is_auto_hibern8_supported(hba) ||
+		FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) == 0;
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
 		blk_queue_update_dma_alignment(q, SZ_4K - 1);
