Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE30ACD37B0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjIRQ73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjIRQ7N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:59:13 -0400
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4355CC1;
        Mon, 18 Sep 2023 09:59:06 -0700 (PDT)
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-573e67cc6eeso3599381a12.2;
        Mon, 18 Sep 2023 09:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056346; x=1695661146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ayk3AxjHysd3K9eFWMSYNv7Ua0WOR1ms2IIQeFR0F5M=;
        b=L3J/hY9uh3nMFu1p9ktgmrA7GwBI1GLOLnRPK5SCmJAqBb5C1jHGpTVCuQDVTbeSoL
         o3Ul+UIkqmTxVSF+OJGPmBMni2g9ljXYu6nP1hTB95Vxui4SI/RJ0POgBeL1yO+6vZcS
         H9ceDCxbRL7Pc7hq+4aGftIOeLAxKnO6YlPgrygXmeO0xwJW6KZxVlz5j//uvL/giyVj
         mL/8Ki8MkMHlIVOZznp+5bhMkIV5E1aypFY2CRrX2I8vO5ijacu8RWaQY+JI6FzHaegE
         fcu2QD3TOo0fdl5f1Z/dcO2JE/rQx4cuPE7OVeAY6lth8mho0NOoDYfPBG7nvmRVKVss
         B+9w==
X-Gm-Message-State: AOJu0YwWA4V5NJMSJkTCGBwjKW4d/oHehKaH5tuW1Ma/EunFlb5SKsns
        gCYqZBEAQnyDc6NS1Vf1ZC8=
X-Google-Smtp-Source: AGHT+IEqKV38BghtYqB2xU3ywTZcbNK7835cKThO+JAWQi3ifixX1jCJFjsQqSR1XT13ZDnPKMTkZg==
X-Received: by 2002:a17:90b:190d:b0:276:7907:ecf with SMTP id mp13-20020a17090b190d00b0027679070ecfmr2012027pjb.36.1695056346224;
        Mon, 18 Sep 2023 09:59:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id p17-20020a639511000000b005740aa41237sm5658041pgd.74.2023.09.18.09.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:59:05 -0700 (PDT)
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
Subject: [PATCH v12 16/16] scsi: ufs: Inform the block layer about write ordering
Date:   Mon, 18 Sep 2023 09:55:55 -0700
Message-ID: <20230918165713.1598705-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918165713.1598705-1-bvanassche@acm.org>
References: <20230918165713.1598705-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufshcd.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c6823435442e..fbd18a517086 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4324,6 +4324,19 @@ static int ufshcd_update_preserves_write_order(struct ufs_hba *hba,
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
@@ -4366,7 +4379,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 
 	if (!is_mcq_enabled(hba) && !prev_state && new_state) {
 		/*
-		 * Auto-hibernation will be enabled for legacy UFSHCI mode.
+		 * Auto-hibernation will be enabled for legacy UFSHCI mode. Tell
+		 * the block layer that write requests may be reordered.
 		 */
 		ret = ufshcd_update_preserves_write_order(hba, false);
 		if (ret)
@@ -4382,7 +4396,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	}
 	if (!is_mcq_enabled(hba) && prev_state && !new_state) {
 		/*
-		 * Auto-hibernation has been disabled.
+		 * Auto-hibernation has been disabled. Tell the block layer that
+		 * the order of write requests is preserved.
 		 */
 		ret = ufshcd_update_preserves_write_order(hba, true);
 		WARN_ON_ONCE(ret);
@@ -5150,6 +5165,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct ufs_hba *hba = shost_priv(sdev->host);
 	struct request_queue *q = sdev->request_queue;
 
+	q->limits.driver_preserves_write_order =
+		!ufshcd_is_auto_hibern8_supported(hba) ||
+		FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) == 0;
+
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
 		blk_queue_update_dma_alignment(q, SZ_4K - 1);
