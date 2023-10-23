Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D5E2C25B42
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbjJWV6d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbjJWV6b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:58:31 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664C910C6;
        Mon, 23 Oct 2023 14:58:28 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so3011823a12.1;
        Mon, 23 Oct 2023 14:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098308; x=1698703108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YsXvsUP6WawReslwRCafRl6AOWpeYrdiWv3tFFFP33k=;
        b=MEKVRMFeNqcvDjOSZBOhkDJG0qwniK6ncDeFoO624F2tTfaGma7nZ1OlUSDCmJhBMv
         10bYHW94uSI5KUz2rDvgCOPpA0vKUoOcQbYMHVCxZ8EW2F66EugcQnbpT3fpjRL6pm89
         mZZmqRbvvnqn/ezOkorKzQAwobNTMVDi+q+TLLf7KuYk+Cy8curvEnoYBvogZe3EK7wb
         0+husbdjiVeku8BEJOQcvMB8alY9fcyp46Yo7kYvJzbRJqKJDDb7jI7M5E08tMl69o60
         afwn8+FniNCrleWSjQT/6DnR2BJ7xy/XwGDDdy/OiwkdcQCayeKV1QM6J1Zbc1VRXZx7
         79bg==
X-Gm-Message-State: AOJu0YzBCMM+oFELOidMsXlsBqomHpFBXMPgbmQAuI071yAUbs2B6+ig
        Qaon/0mkoBrEW3YIYLUcqQM=
X-Google-Smtp-Source: AGHT+IHRjexGvQ64Igt3h4gHO28cHfA5bsfbOzqov3eh55WYCfHhuxGIpbTfMM2wlVZf1gZU+hYLrg==
X-Received: by 2002:a17:90a:a38d:b0:27d:3a34:2194 with SMTP id x13-20020a17090aa38d00b0027d3a342194mr9964102pjp.14.1698098307673;
        Mon, 23 Oct 2023 14:58:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:58:27 -0700 (PDT)
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
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v14 19/19] scsi: ufs: Inform the block layer about write ordering
Date:   Mon, 23 Oct 2023 14:54:10 -0700
Message-ID: <20231023215638.3405959-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufshcd.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0a21ea9d7576..70bf62ed414c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4325,6 +4325,20 @@ static int ufshcd_update_preserves_write_order(struct ufs_hba *hba,
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
+			!preserves_write_order && blk_queue_is_zoned(q) ?
+			ELEVATOR_F_ZBD_SEQ_WRITE : 0);
+		if (q->disk)
+			disk_set_zoned(q->disk, q->limits.zoned);
+		blk_mq_unfreeze_queue(q);
+	}
 
 	return 0;
 }
@@ -4367,7 +4381,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 
 	if (!is_mcq_enabled(hba) && !prev_state && new_state) {
 		/*
-		 * Auto-hibernation will be enabled for legacy UFSHCI mode.
+		 * Auto-hibernation will be enabled for legacy UFSHCI mode. Tell
+		 * the block layer that write requests may be reordered.
 		 */
 		ret = ufshcd_update_preserves_write_order(hba, false);
 		if (ret)
@@ -4383,7 +4398,8 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	}
 	if (!is_mcq_enabled(hba) && prev_state && !new_state) {
 		/*
-		 * Auto-hibernation has been disabled.
+		 * Auto-hibernation has been disabled. Tell the block layer that
+		 * the order of write requests is preserved.
 		 */
 		ret = ufshcd_update_preserves_write_order(hba, true);
 		WARN_ON_ONCE(ret);
@@ -5151,6 +5167,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct ufs_hba *hba = shost_priv(sdev->host);
 	struct request_queue *q = sdev->request_queue;
 
+	q->limits.driver_preserves_write_order =
+		!ufshcd_is_auto_hibern8_supported(hba) ||
+		FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) == 0;
+
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
 	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
 		blk_queue_update_dma_alignment(q, SZ_4K - 1);
@@ -8919,6 +8939,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.skip_settle_delay	= 1,
+	.needs_prepare_resubmit	= 1,
 	.sdev_groups		= ufshcd_driver_groups,
 	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
 };
